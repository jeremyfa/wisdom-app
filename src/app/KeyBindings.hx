package app;

import kit.Binding;

/**
 * This application's shortcuts, declared once in a table.
 *
 * The dispatching belongs to `kit.Keys` and is not repeated here: standing
 * aside for text fields, resolving Command against Control, keeping a dialog
 * modal. `kit.Keys` also contributes the zoom shortcuts every app wants, so
 * this table holds only what is genuinely ours.
 *
 * Every binding takes the platform modifier unless it says otherwise.
 */
class KeyBindings {

    public static var bindings(default, null):Array<Binding> = [
        { key: 'n', description: 'New note', action: () -> NotesActions.focusInput() },
        { key: 's', description: 'Save notes', action: () -> NotesActions.save() },
        { key: 'o', description: 'Open notes', action: () -> NotesActions.open() },
        { key: ',', description: 'Settings', action: () -> model.ui.popup = SETTINGS }
    ];

    /**
     * What Escape does when no dialog is open.
     *
     * The shell asks; closing a popup is this application's business, because
     * the shell does not know popups exist. Returning false lets the key fall
     * through to whatever else might want it.
     */
    public static function onEscape():Bool {

        if (model.ui.popup == null) return false;

        model.ui.popup = null;
        return true;

    }

}
