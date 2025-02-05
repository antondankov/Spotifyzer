import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Communications;
using Toybox.Time;
using Toybox.Time.Gregorian;

class Player {
  var _isInit = false;
  var playerState;
  var currentSong as SongInfo;

  var songStorage = new SongStorage();

  var timer = new Timer.Timer();
  var currentTime = 0;

  var layout;

  public function initialize() {}

  public function setCurrentSong(song as SongInfo) {
    currentSong = song;
  }

  public function createInterface(dc) {
    playerState = new PlayerState();
    switch (playerState.layoutType) {
      case LayoutEnum.DEFAULT:
        {
          layout = new DefaultLayout(dc, playerState);
        }
        break;
      case LayoutEnum.FULL_IMAGE:
        {
          layout = new ImageLayout(dc, playerState);
        }
        break;
    }

    currentSong = new SongInfo();
    currentSong.length = 0;
    timer.start(method(:timerCallback), 1000, true);

    sendRequestToUpdateSong();
    _isInit = true;

    return layout.getDrawableList();
  }

  public function updateCurrentSongTime() {
    layout.currentTimeString.setTextWithoutState(
      formatTime(currentTime) + " / " + formatTime(currentSong.length)
    );
  }

  function formatTime(seconds) {
    var minutes = seconds / 60;
    seconds = seconds % 60;
    return (
      minutes.toString() +
      ":" +
      (seconds > 9 ? seconds.toString() : "0" + seconds.toString())
    );
  }

  function getSongProgress() {
    return currentSong.length == 0
      ? 0.0
      : currentTime.toFloat() / currentSong.length;
  }

  public function onButtonPressed(buttonId as OperationEnum) {
    var listener = new $.CommListener();
    var data = new TransmitData();
    data._action = buttonId;

    switch (buttonId) {
      case OperationEnum.PLAY:
      case OperationEnum.PAUSE:
        togglePlayPause(data, listener);
        break;
      case OperationEnum.PREVIOUS:
      case OperationEnum.NEXT:
      case OperationEnum.SOUND_UP:
      case OperationEnum.SOUND_DOWN:
        sendActionWithListener(data, listener);
        break;
      case OperationEnum.LIKE:
      case OperationEnum.DISLIKE:
        toggleLikeDislike(data, listener);
        break;
      case OperationEnum.REPEAT:
        toggleRepeat(data, listener);
        break;
    }
  }

  private function togglePlayPause(data, listener) {
    sendActionWithListener(data, listener);
    layout.playButton.changeState();
    layout.playButton.buttonId =
      data._action == OperationEnum.PLAY
        ? OperationEnum.PAUSE
        : OperationEnum.PLAY;
  }

  private function toggleLikeDislike(data, listener) {
    data._songId = currentSong.id;
    sendActionWithListener(data, listener);
    layout.likeButton.changeState();
    layout.likeButton.buttonId =
      data._action == OperationEnum.LIKE
        ? OperationEnum.DISLIKE
        : OperationEnum.LIKE;
  }

  private function toggleRepeat(data, listener) {
    layout.repeatButton.changeState();
    data.repeatMode = layout.repeatButton.currentStateNumber;
    sendActionWithListener(data, listener);
  }

  private function sendActionWithListener(data, listener) {
    Communications.transmit(data.makeDictToTransmit(), null, listener);
  }

  public function sendRequestToUpdateSong() {
    var listener = new $.CommListener();
    var data = new TransmitData();
    data._action = OperationEnum.FULL_UPDATE;
    Communications.transmit(data.makeDictToTransmit(), null, listener);
  }

  public function sendLayoutInfo() {
    var listener = new $.CommListener();
    var data = new TransmitData();
    data._action = OperationEnum.LAYOUT_INFO;
    data.layoutNumber = playerState.layoutType;
    Communications.transmit(data.makeDictToTransmit(), null, listener);
  }

  function timerCallback() {
    updateTime();
    if (playerState.isUpdatingSongTime) {
      currentTime += 1;
      updateCurrentSongTime();
    }

    updateUi();
  }

  private function updateTime() {
    var timeNow = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var hour = formatTimeUnit(timeNow.hour);
    var minutes = formatTimeUnit(timeNow.min);

    layout.currentTimeHours.setTextWithoutState(hour);
    layout.currentTimeMinutes.setTextWithoutState(minutes);
  }

  private function formatTimeUnit(value) {
    return value < 10 ? "0" + value.toString() : value.toString();
  }

  public function operateOnMessage(transmitData as TransmitData) {
    if (transmitData != null) {
      switch (transmitData._action) {
        case OperationEnum.LAYOUT_CHANGE:
          {
            Application.Storage.setValue(
              "playerLayoutType",
              transmitData.layoutNumber
            );
          }
          break;
        case OperationEnum.LAYOUT_INFO:
          {
            sendLayoutInfo();
          }
          break;
        default: {
          if (transmitData._songId != null) {
            handleSongUpdate(transmitData);
          }
        }
      }
    }
  }

  private function handleSongUpdate(transmitData) {
    if (transmitData._action == OperationEnum.SMALL_UPDATE) {
      updateSmallSongInfo(transmitData);
    } else if (transmitData._action == OperationEnum.FULL_UPDATE) {
      songStorage.removeRequest(transmitData._songId);
      songStorage.storeTransmissionData(transmitData);
      updatePlayerStatus(transmitData);
      updateSongInfo(transmitData);
    }
  }

  private function updateSmallSongInfo(transmitData) {
    var isCurrentSongAndStored =
      !currentSong.id.equals(transmitData._songId) &&
      songStorage.isStored(transmitData._songId);

    if (currentSong.id == null || !isCurrentSongAndStored) {
      if (!songStorage.isRequested(transmitData._songId)) {
        songStorage.setRequest(transmitData._songId);
        sendRequestToUpdateSong();
      }
    } else {
      updateSongInfo(songStorage.getStoredSong(transmitData._songId));
    }
  }

  public function updatePlayerStatus(transmitData as TransmitData) {
    layout.repeatButton.setState(transmitData.repeatMode);
    currentTime = transmitData._currentTime;
    updateCurrentSongTime();

    playerState.isUpdatingSongTime = !transmitData._playerIsPaused;
    toggleButtonState(
      layout.playButton,
      playerState.isUpdatingSongTime,
      OperationEnum.PAUSE,
      OperationEnum.PLAY
    );

    toggleButtonState(
      layout.likeButton,
      transmitData._isSongLiked,
      OperationEnum.DISLIKE,
      OperationEnum.LIKE
    );
  }

  private function toggleButtonState(button, condition, trueState, falseState) {
    if (button.buttonId != (condition ? trueState : falseState)) {
      button.buttonId = condition ? trueState : falseState;
      button.changeState();
    }
  }

  public function updateSongInfo(transmitData as TransmitData) {
    layout.currentSongName.setText(transmitData._songName);
    layout.currentArtist.setText(transmitData._songArtist);

    currentSong.id = transmitData._songId;
    currentSong.length = transmitData._songLength;

    if (transmitData.bitmap == null) {
      sendImageRequest(transmitData._imageUrl);
    } else {
      updateImage(transmitData.bitmap);
    }
  }

  public function onImageMessage(responseCode, data) {
    if (responseCode == 200 && data != null) {
      songStorage.setImageToCurrentSong(data);
      updateImage(data);
    }
  }

  private function sendImageRequest(imageUrl) {
    Communications.makeImageRequest(
      "https://i.scdn.co/image/" + imageUrl,
      null,
      {
        :maxWidth => layout.currentImage.getWidth(),
        :maxHeight => layout.currentImage.getHeight(),
        :packingFormat => Communications.PACKING_FORMAT_JPG,
      },
      method(:onImageMessage)
    );
  }

  public function updateImage(data) {
    layout.currentImage.setBitmap(data);
    playerState.isStateChanged = true;
  }

  public function onTextMessage(responseCode, data) {
    if (responseCode == 200) {
      layout.currentSongName.setText(data);
    }
  }

  public function updateUi() {
    if (System.getDisplayMode() != System.DISPLAY_MODE_LOW_POWER) {
      WatchUi.requestUpdate();
    }
  }
}
