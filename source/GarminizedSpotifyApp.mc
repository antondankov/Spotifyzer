import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
using Toybox.Media;
using Toybox.Application;

class GarminizedSpotifyApp extends Application.AppBase {
    // private var _view as GarminizedSpotifyView;
    private var _phoneMethod as Method(msg as Message) as Void;
    private const _strings as Array<String> = ["", "", "", "", ""] as Array<String>;
    private var _player;

    function initialize() {
        AppBase.initialize();
        _player = new Player();
        _phoneMethod = method(:onPhone);
        Communications.registerForPhoneAppMessages(_phoneMethod);
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new GarminizedSpotifyView(_player), new GarminizedSpotifyDelegate(_player) ] as Array<Views or InputDelegates>;
    }

    //! Handle a new phone app message
    //! @param msg The message
    public function onPhone(msg as PhoneAppMessage) as Void {
        if (_player != null && _player._isInit && msg != null && msg.data != null && msg.data instanceof Dictionary){
            var data = msg.data as Dictionary;
            var transmitData = new TransmitData();
            transmitData.fromDict(data);
            _player.operateOnMessage(transmitData);
        }
    }

}

function getApp() as GarminizedSpotifyApp {
    return Application.getApp() as GarminizedSpotifyApp;
}