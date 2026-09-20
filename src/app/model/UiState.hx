package app.model;

import kit.model.BaseModel;

/**
 * This application's transient interface state.
 *
 * Everything the SHELL needs to track lives in `kit.model.ChromeState`,
 * reachable as the ambient `chrome`: the dialog, the status message, the
 * window's own state. What is left here is only ours.
 *
 * Nothing is `@serialize`: a half-open popup should not come back after a
 * reload. Contrast with `Preferences`, where everything persists.
 */
class UiState extends BaseModel {

    /** Which modal is open, or null. */
    @observe public var popup:PopupKind = null;

    public function new() {
        super();
    }

}
