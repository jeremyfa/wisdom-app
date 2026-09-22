package app.ui;

import app.NotesActions;
import wisdom.Component;

/**
 * What this application puts in its title bar.
 *
 * The bar itself is `kit.ui.TitleBar`, which wraps this one. Dragging, the
 * room the macOS traffic lights need and the window buttons on Windows and
 * Linux all live there, so none of it is repeated here and none of it has to
 * change when the contents do.
 *
 * The title on the left is not clickable, so it stays draggable like the empty
 * middle of the bar. The button cluster on the right carries
 * `data-tauri-drag-region="false"` so its gaps do not drag the window either.
 */
class TopBar extends Component {

    function render() '<>
        // One root, as every wisdom component needs, and flex-1 so it fills
        // the bar between whatever chrome TitleBar puts on either side.
        <div class="flex-1 min-w-0 flex items-center gap-2">

            <div class="flex items-center gap-2 min-w-0">
                <Icon kind="sparkles" size=16 display="text-t-accent" />
                <span class="text-[14px] font-semibold truncate">Wisdom App</span>
                <if ${model.currentFile != null}>
                    <span class="text-[12px] text-t-text-faint truncate mono">${model.currentFile.name}</span>
                </if>
            </div>

            // Deliberately unmarked: the empty middle of the bar should drag
            // the window.
            <div class="flex-1"></div>

            <div class="flex items-center gap-1" data-tauri-drag-region="false">
                <Button icon="folder-open" label="Open"
                        title=${'Open notes (' + Keys.modifierLabel() + 'O)'}
                        onpress=${() -> NotesActions.open()} />
                <Button icon="save" label="Save"
                        title=${'Save notes (' + Keys.modifierLabel() + 'S)'}
                        onpress=${() -> NotesActions.save()} />

                // Capability driven: disabled rather than missing, with a tooltip
                // that says why, so the limitation reads as a fact about the host
                // and not as a bug.
                //
                // Wrapped in Tooltip rather than left to the native `title`,
                // because a disabled button receives no pointer events and its
                // native tooltip therefore never appears. That is precisely when
                // the user most needs the explanation.
                <Tooltip label=${revealTitle()}>
                    <IconButton kind="folder-search"
                                title=${revealTitle()}
                                nativeTitle=${false}
                                disabled=${!canReveal()}
                                onpress=${() -> NotesActions.reveal()} />
                </Tooltip>

                <IconButton kind="settings"
                            title=${'Settings (' + Keys.modifierLabel() + ',)'}
                            onpress=${() -> chrome.settingsOpen = true} />
                <IconButton kind="info" title="About"
                            onpress=${() -> model.ui.popup = ABOUT} />
            </div>

        </div>
    ';

    function canReveal():Bool {

        return Platform.can(REVEAL_IN_FOLDER) && model.currentFile != null
            && model.currentFile.isWritableInPlace();

    }

    function revealTitle():String {

        if (!Platform.can(REVEAL_IN_FOLDER)) return 'Showing a file in the file manager needs the desktop app';
        if (model.currentFile == null) return 'Save the notes first';
        return 'Show in file manager';

    }

}
