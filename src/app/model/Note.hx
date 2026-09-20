package app.model;

import kit.model.BaseModel;

/**
 * One note. The sample document type for the hello world.
 *
 * Replace this with whatever your app is actually about; it exists to show a
 * sub-model inside a collection inside the root model, persisted and undoable
 * through the same machinery as everything else.
 */
class Note extends BaseModel {

    /**
     * Our own identifier for this note.
     *
     * NOT named `id`: every tracker `Entity` already has an `id`, which the
     * serializer uses to recognise the same object across a save and a load.
     * Shadowing it with domain data is a compile error at best, and would
     * confuse the object graph at worst, so domain identifiers get their own
     * name.
     */
    @serialize public var slug:String = '';

    @serialize public var text:String = '';

    @serialize public var done:Bool = false;

    public function new() {
        super();
    }

}
