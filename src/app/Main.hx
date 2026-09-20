package app;

import app.model.AppModel;
import kit.App;
import kit.AppOptions;
import wisdom.X;

/**
 * Entry point.
 *
 * Everything generic belongs to `kit.App`: the init order, persistence, the
 * theme, the virtual DOM, the keyboard listener. This file holds only what the
 * shell cannot know, which is the model, the storage key, the markup and the
 * shortcuts.
 *
 * `implements X` is what lets this class write wisdom markup.
 */
class Main implements X {

    static function main():Void {

        final model = new AppModel();

        // Made reachable as the ambient `model` before anything renders.
        @:privateAccess Shortcuts._model = model;

        App.start(({
            model: model,
            storageKey: 'wisdom-app',
            onModelLoaded: () -> model.repair(),
            bindings: KeyBindings.bindings,
            onEscape: KeyBindings.onEscape,
            render: () -> '<>
                <div class="h-screen flex flex-col bg-t-background text-t-text">

                    <TitleBar>
                        <TopBar />
                    </TitleBar>

                    <div class="flex-1 min-h-0 overflow-y-auto scrollbar-themed">
                        <NotesScreen />
                    </div>

                    <StatusBar>
                        <if ${model.notes.length > 0}>
                            <span class="mono shrink-0">${Std.string(model.notes.length)} notes</span>
                        </if>
                    </StatusBar>

                    // Always mounted, hidden when there is nothing to show: a
                    // stable child count keeps wisdom matching nodes correctly
                    // across renders.
                    <div class=${model.ui.popup != null ? "" : "hidden"}>
                        <if ${model.ui.popup == ABOUT}>
                            <AboutPopup />
                        <elseif ${model.ui.popup == SETTINGS}>
                            <SettingsPopup />
                        </if>
                    </div>

                    // A separate slot, above the one before it. A question is
                    // usually raised from inside a popup and has to sit on top
                    // of the popup that raised it.
                    <div class=${chrome.dialog != null ? "" : "hidden"}>
                        <if ${chrome.dialog != null}>
                            <DialogPopup />
                        </if>
                    </div>

                </div>
            '
        } : AppOptions));

    }

}
