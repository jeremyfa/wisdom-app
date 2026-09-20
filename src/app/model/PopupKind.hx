package app.model;

/** The modals this app knows how to show. */
enum abstract PopupKind(String) from String to String {

    var ABOUT = 'about';

    var SETTINGS = 'settings';

}
