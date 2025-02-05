import Toybox.Lang;
import Toybox.WatchUi;

class GarminizedSpotifyDelegate extends WatchUi.BehaviorDelegate {
    private var _player;

    function initialize(player) {
        BehaviorDelegate.initialize();
        _player = player;
    }

    //! Handle the state of a Selectable changing
    //! @param event The selectable event
    //! @return true if handled, false otherwise
    public function onSelectable(event as SelectableEvent) as Boolean {
        var instance = event.getInstance();
        if (instance instanceof CustomButton && event.getPreviousState() == :stateDefault){
            _player.onButtonPressed(instance.buttonId);
            return true;
        }
        return false;
    }

    function onSwipe(swipeEvent) {
        if (swipeEvent.getDirection() == SWIPE_LEFT){
            _player.onButtonPressed(OperationEnum.PREVIOUS);
        }
        else if (swipeEvent.getDirection() == SWIPE_RIGHT){
            _player.onButtonPressed(OperationEnum.NEXT);
        }
        else if (swipeEvent.getDirection() == SWIPE_UP){
            _player.onButtonPressed(OperationEnum.SOUND_UP);
        }
        else if (swipeEvent.getDirection() == SWIPE_DOWN){
            _player.onButtonPressed(OperationEnum.SOUND_DOWN);
        }
        return true;
    }

    function onKey(keyEvent as WatchUi.KeyEvent){
        switch(keyEvent.getKey()){
            case KEY_ENTER: // Refresh the screen fully
            _player.sendRequestToUpdateSong();
            _player.playerState.isStateChanged = true;
            return true;
        }
        return false;
    }

}