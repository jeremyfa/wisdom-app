package app.ui;

import kit.model.ThemeMode;
import wisdom.Component;

/** Preferences. Every control is bound straight to the persisted model. */
class SettingsPopup extends Component {

    function render() '<>
        <Popup title="Settings" onClose=${() -> model.ui.popup = null}>
            <div class="flex flex-col gap-3">

                <SectionHeader label="Appearance" />

                // `preferences` belongs to the shell, reached through its
                // ambient accessor. The theme and the interface scale belong
                // to any app, so they are not ours to declare.
                <LabeledRow label="Theme" hint="Auto follows your system setting">
                    <Dropdown
                        value=${preferences.themeMode}
                        ariaLabel="Theme"
                        options=${[
                            { value: 'auto',  label: 'Auto'  },
                            { value: 'light', label: 'Light' },
                            { value: 'dark',  label: 'Dark'  }
                        ]}
                        onChange=${(value) -> preferences.themeMode = (value:ThemeMode)}
                    />
                </LabeledRow>

                <LabeledRow label="Interface scale" hint=${scaleHint()}>
                    <div class="flex items-center gap-1">
                        <IconButton kind="minus" title="Smaller" onpress=${() -> nudge(-0.1)} />
                        <IconButton kind="rotate-ccw" title="Reset"
                                    onpress=${() -> preferences.uiScale = 1.0} />
                        <IconButton kind="plus" title="Larger" onpress=${() -> nudge(0.1)} />
                    </div>
                </LabeledRow>

                <div class="mt-2"><SectionHeader label="Data" /></div>

                <LabeledRow label="Notes" hint="Removes every note on this device">
                    <Button icon="trash-2" label="Clear" variant="danger"
                            disabled=${model.notes.length == 0}
                            onpress=${() -> confirmClear()} />
                </LabeledRow>

            </div>
        </Popup>
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

    function scaleHint():String {

        return Std.string(Math.round(preferences.uiScale * 100)) + '%';

    }

    function nudge(delta:Float):Void {

        // The same clamp the zoom shortcuts use, so the two cannot disagree
        // about what counts as a legible range.
        preferences.uiScale = Keys.clampScale(preferences.uiScale + delta);

    }

}
