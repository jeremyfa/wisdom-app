package app.ui;

import wisdom.Component;

/**
 * This application's own settings, shown below the kit's in `SettingsPopup`.
 *
 * The theme and the interface scale are not here: they belong to any app, so
 * the kit's popup declares them. What is left is only ours.
 */
class NotesSettings extends Component {

    function render() '<>
        <div class="flex flex-col gap-3">

            <div class="mt-2"><SectionHeader label="Data" /></div>

            <LabeledRow label="Notes" hint="Removes every note on this device">
                <Button icon="trash-2" label="Clear" variant="danger"
                        disabled=${model.notes.length == 0}
                        onpress=${() -> confirmClear()} />
            </LabeledRow>

        </div>
    ';

    /**
     * Destructive and not undoable, so it asks first.
     *
     * Through `Dialog`, which is in-app and themed, rather than
     * `window.confirm`: the native one blocks the thread, ignores the theme,
     * and some browsers suppress it outright.
     */
    function confirmClear():Void {

        final count = model.notes.length;

        Dialog.confirm(
            'Clear all notes?',
            'This removes ' + count + (count == 1 ? ' note' : ' notes') + ' from this device. It cannot be undone.',
            'Clear',
            () -> {
                model.clearNotes();
                chrome.flash('Notes cleared');
            },
            'danger'
        );

    }

}
