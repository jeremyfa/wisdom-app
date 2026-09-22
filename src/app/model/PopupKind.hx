package app.model;

/**
 * The modals this app knows how to show.
 *
 * Settings is not one of them: that popup belongs to the kit and is tracked
 * by `chrome.settingsOpen`.
 */
enum abstract PopupKind(String) from String to String {

    var ABOUT = 'about';

}
