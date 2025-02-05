import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
using Toybox.System;


class GarminizedSpotifyView extends WatchUi.View {
    var _player;
    var showing = true;


    function initialize(player as Player) {
        _player = player;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        if(dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        setLayout(_player.createInterface(dc));

    }


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        showing = true;
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        if (_player.playerState.isStateChanged){
            for( var i = 0; i < _player.layout._list.size(); i++ ) {
                _player.layout._list[i].drawChecked(dc,false);
            }
            _player.layout.drawProgressBar(dc,_player.getSongProgress());
        }
        else{
            _player.layout.currentTimeString.drawChecked(dc,true);
            _player.layout.currentTimeHours.drawChecked(dc,true);
            _player.layout.currentTimeMinutes.drawChecked(dc,true);
            if (_player.playerState.isUpdatingSongTime){
            _player.layout.drawProgressBar(dc,_player.getSongProgress());
            }
            
            for( var i = 0; i < _player.layout._list.size(); i++ ) {
                _player.layout._list[i].drawChecked(dc,true);
            }
        }
        _player.playerState.isStateChanged = false;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        showing = false;
    }


}
