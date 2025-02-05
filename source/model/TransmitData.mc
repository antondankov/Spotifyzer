import Toybox.Lang;
import Toybox.Graphics;

class TransmitData{
    public var _action as OperationEnum;
    public var _songId as String;
    public var _currentTime as Number;
    public var _songName as String;
    public var _songArtist as String;
    public var _songLength as Number;
    public var _imageUrl as String;
    public var _playerIsPaused as Boolean;
    public var _isSongLiked as Boolean;
    public var repeatMode as Number;
    public var layoutNumber as Number;
    public var bitmap as Graphics.BitmapType;

    public function initialize(){

    }

    public function fromDict(dict as Dictionary){
        _action = dict.get("action");
        _songId = dict.get("songId");
        _songName = dict.get("songName");
        _songArtist = dict.get("songArtist");
        _songLength = dict.get("songLength");
        _currentTime = dict.get("currentTime") / 1000;
        _imageUrl = dict.get("imageURL");
        _playerIsPaused = dict.get("isPlayerPaused");
        _isSongLiked = dict.get("isSongLiked");
        repeatMode = dict.get("repeatMode");
        layoutNumber = dict.get("layout");
    }


    public function makeDictToTransmit() as Dictionary{
        var dict = {"action" => _action};
        dict.put("songId",_songId);
        dict.put("repeatMode",repeatMode);
        dict.put("layout",layoutNumber);
        return dict;
    }
}