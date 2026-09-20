package app.model;

import kit.model.RootModel;
import kit.platform.FileRef;

/**
 * The root of all application state.
 *
 * Extends `RootModel`, which is the seam with the shell: it already carries
 * `preferences` and `chrome`, the two things the shell needs, so everything
 * declared here is genuinely this application's.
 *
 * Sub-models are plain `@serialize` fields holding other models; tracker
 * serialises the whole graph under one key, so `Main` only has to persist this
 * one object.
 *
 * THE RULE THIS CODEBASE CANNOT BREAK: never mutate an observed array in
 * place. Observed collections are compared by identity, so `notes.push(n)`
 * compiles, runs, and notifies nothing: no re-render and no save. Always
 * assign a NEW array, as the methods below do.
 */
class AppModel extends RootModel {

    @serialize public var ui:UiState = new UiState();

    @serialize public var notes:Array<Note> = [];

    /**
     * The file the notes were last read from or written to, if any.
     *
     * Not serialised: on the desktop the path could have moved between
     * sessions, and in a browser it never meant anything to begin with.
     */
    @observe public var currentFile:FileRef = null;

    @compute public function remaining():Int {

        var n = 0;
        for (note in notes) if (!note.done) n++;
        return n;

    }

    public function new() {
        super();
    }

    /**
     * Put back anything an older save did not provide.
     *
     * Same reasoning as `App.repairAfterLoad`, for the sub-models the shell
     * cannot name: a save written before `ui` existed, or written when it
     * lived under a different class name, restores it as null and the first
     * render then dies. Called by `Main` right after `App.start` returns.
     */
    public function repair():Void {

        if (ui == null) ui = new UiState();
        if (notes == null) notes = [];

    }

/// Mutations, each assigning a fresh array

    public function addNote(text:String):Note {

        final note = new Note();
        note.slug = Std.string(Date.now().getTime()) + '-' + Std.random(0x1000000);
        note.text = text;
        notes = notes.concat([note]);
        return note;

    }

    public function removeNote(slug:String):Void {

        notes = [for (note in notes) if (note.slug != slug) note];

    }

    public function toggleNote(slug:String):Void {

        for (note in notes) {
            if (note.slug == slug) {
                note.done = !note.done;
                return;
            }
        }

    }

    public function clearNotes():Void {

        notes = [];

    }

}
