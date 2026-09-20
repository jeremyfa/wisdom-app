package app.ui;

import app.NotesActions;
import app.model.Note;
import kit.platform.Platform;
import js.html.InputElement;
import js.html.KeyboardEvent;
import wisdom.Component;

/**
 * The hello world.
 *
 * Small on purpose, but every convention this kit teaches is visible here:
 * an observable collection in the root model, a controlled input, `<foreach>`
 * with a key, a computed value, one platform-dependent affordance, and the
 * immutable-collection rule enforced by going through the model's methods
 * instead of touching the array.
 */
class NotesScreen extends Component {

    /** Draft text for the new note. Local and throwaway, so it lives here. */
    @observe var draft:String = '';

    function render() '<>
        <div class="max-w-[640px] mx-auto w-full px-5 py-6 flex flex-col gap-5">

            <div class="flex items-end justify-between gap-3">
                <div>
                    <h1 class="m-0 text-[19px] font-semibold tracking-tight">Notes</h1>
                    <p class="m-0 mt-0.5 text-[13px] text-t-text-muted">
                        ${summary()}
                    </p>
                </div>
                <if ${model.notes.length > 0}>
                    <Button icon="copy" label="Copy"
                            title="Copy the notes as JSON"
                            onpress=${() -> NotesActions.copyToClipboard()} />
                </if>
            </div>

            <div class="flex items-center gap-2">
                <input
                    id="new-note-input"
                    type="text"
                    value=${draft}
                    placeholder=${'Write a note, then press Enter (' + Keys.modifierLabel() + 'N)'}
                    oninput=${(e) -> draft = inputValue(e)}
                    onkeydown=${(e) -> onKeyDown(e)}
                    class="flex-1 min-w-0 h-9 px-3 rounded-lg border border-t-border bg-t-surface text-t-text text-[13px] outline-none focus:border-t-accent select-text"
                />
                <Button icon="plus" label="Add" variant="primary"
                        disabled=${StringTools.trim(draft) == ''}
                        onpress=${() -> commit()} />
            </div>

            <if ${model.error != null}>
                <InfoBox tone="danger" icon="triangle-alert">${model.error}</InfoBox>
            </if>

            <if ${model.notes.length == 0}>
                <div class="py-10 text-center">
                    <Icon kind="notebook-pen" size=28 display="text-t-text-faint" />
                    <p class="m-0 mt-2 text-[13px] text-t-text-muted">Nothing yet. Add a note above.</p>
                </div>
            <else>
                <div class="rounded-xl border border-t-border overflow-hidden">
                    <foreach ${model.notes} ${(i:Int, note:Note) -> row(note, i)} />
                </div>
            </if>

            <InfoBox tone="info" icon="info">
                ${platformNote()}
            </InfoBox>

        </div>
    ';

    function row(note:Note, index:Int) return '<>
        <div
            key=${note.slug}
            class=${'flex items-center gap-3 px-3 py-2 hover:bg-t-surface-2 '
                + (index == 0 ? '' : 'border-t border-t-border')}
        >
            <Switch value=${note.done} ariaLabel="Done"
                    onChange=${(_) -> model.toggleNote(note.slug)} />
            <span class=${'flex-1 min-w-0 text-[13px] truncate select-text '
                + (note.done ? 'line-through text-t-text-faint' : '')}>
                ${note.text}
            </span>
            <IconButton kind="trash-2" title="Delete"
                        onpress=${() -> model.removeNote(note.slug)} />
        </div>
    ';

    function summary():String {

        final total = model.notes.length;
        if (total == 0) return 'A tiny example of the model, the theme and the platform layer.';
        final left = model.remaining;
        return left == 0
            ? '$total done, nothing left'
            : '$left of $total still to do';

    }

    /** The same build says something different depending on where it runs. */
    function platformNote():String {

        return Platform.can(FILE_SYSTEM)
            ? 'Running as a desktop app: Save writes to a real file and you can show it in the file manager.'
            : 'Running in a browser: Save hands you a download, and showing a file in the file manager is unavailable.';

    }

    function onKeyDown(e:KeyboardEvent):Void {

        if (e.key == 'Enter') {
            commit();
            e.preventDefault();
        }
        else if (e.key == 'Escape') {
            draft = '';
        }

    }

    function commit():Void {

        NotesActions.add(draft);
        draft = '';

    }

    static function inputValue(e:js.html.Event):String {

        final el:InputElement = cast e.target;
        return el.value;

    }

}
