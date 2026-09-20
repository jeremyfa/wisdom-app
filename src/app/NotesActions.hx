package app;

import app.model.Note;
import kit.platform.FileFilter;
import kit.platform.Platform;
import js.Browser.document;
import js.html.InputElement;

/**
 * The commands the hello world offers.
 *
 * This is the piece worth studying: opening and saving are written ONCE and
 * work in both hosts. On the desktop they use native dialogs and a real path;
 * in a browser they use a file input and a download. Nothing here knows which,
 * because `Platform` decides.
 *
 * Note the two places capability matters:
 *   - `save()` overwrites in place only when there is a filesystem
 *   - `reveal()` is offered only when the host has a file manager
 */
class NotesActions {

    static final FILTERS:Array<FileFilter> = [new FileFilter('Notes', ['json'])];

    static inline final DEFAULT_NAME = 'notes.json';

/// Creating

    /** Put the cursor in the new-note field. Bound to the New shortcut. */
    public static function focusInput():Void {

        final input:InputElement = cast document.getElementById('new-note-input');
        if (input != null) input.focus();

    }

    public static function add(text:String):Void {

        final trimmed = StringTools.trim(text);
        if (trimmed == '') return;
        model.addNote(trimmed);
        chrome.flash('Note added');

    }

/// Files

    public static function open():Void {

        Platform.openTextFile(FILTERS, (error, file) -> {
            if (error != null) {
                model.error = 'Could not open that file: ' + Std.string(error);
                return;
            }
            // Null with no error means the user cancelled, which is not a
            // failure and must not produce a message.
            if (file == null) return;

            try {
                final parsed:Array<Dynamic> = haxe.Json.parse(file.content);
                final loaded:Array<Note> = [];
                for (entry in parsed) {
                    final note = new Note();
                    note.slug = entry.id != null ? entry.id : Std.string(Std.random(0x1000000));
                    note.text = entry.text != null ? entry.text : '';
                    note.done = entry.done == true;
                    loaded.push(note);
                }
                model.notes = loaded;
                model.currentFile = file.ref;
                model.error = null;
                chrome.flash('Opened ' + file.ref.name);
            }
            catch (e:Dynamic) {
                model.error = 'That file is not a notes document';
            }
        });

    }

    /**
     * Save.
     *
     * With a filesystem and a known file, overwrite it. Otherwise ask where to
     * put it, which in a browser means handing over a download.
     */
    public static function save():Void {

        final content = serialize();
        final existing = model.currentFile;

        if (Platform.can(FILE_SYSTEM) && existing != null && existing.isWritableInPlace()) {
            Platform.writeTextFile(existing, content, (error, ref) -> onSaved(error, ref));
            return;
        }

        final suggested = existing != null ? existing.name : DEFAULT_NAME;
        Platform.saveTextFileAs(suggested, content, FILTERS, (error, ref) -> onSaved(error, ref));

    }

    static function onSaved(error:Dynamic, ref:kit.platform.FileRef):Void {

        if (error != null) {
            model.error = 'Could not save: ' + Std.string(error);
            return;
        }
        if (ref == null) return;

        model.currentFile = ref;
        model.error = null;
        chrome.flash(Platform.can(FILE_SYSTEM) ? 'Saved to ' + ref.name : 'Downloaded ' + ref.name);

    }

    /** Show the saved file in Finder or Explorer. Desktop only. */
    public static function reveal():Void {

        Platform.revealFile(model.currentFile, error -> {
            if (error != null) model.error = Std.string(error);
        });

    }

    public static function copyToClipboard():Void {

        Platform.copyText(serialize(), error -> {
            if (error != null) model.error = 'Could not copy: ' + Std.string(error);
            else chrome.flash('Copied to clipboard');
        });

    }

    static function serialize():String {

        final plain = [for (note in model.notes) { id: note.slug, text: note.text, done: note.done }];
        return haxe.Json.stringify(plain, null, '  ') + '\n';

    }

}
