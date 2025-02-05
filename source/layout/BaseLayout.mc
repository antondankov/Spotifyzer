import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class BaseLayout {
  public var height;
  public var width;
  public var progressBarWidth;
  public var playerState;
  public var _list = [];

  public var _prevMinutes = "";
  public var status;
  public var placeHolder = null;
  public var currentTimeHours;
  public var currentTimeMinutes;

  public var currentImage = null;
  public var currentArtist = null;
  public var currentSongName = null;
  public var currentTimeString;

  public var playButton;
  public var nextButton;
  public var previousButton;
  public var likeButton;
  public var repeatButton;
  public var shuffleButton;

  public var isUpdatingSongTime = false;

  public function initialize(dc, ps) {
    playerState = ps;
    height = dc.getHeight();
    width = dc.getWidth();
    progressBarWidth = width - 100;
    setupLayout(dc);
    return _list;
  }

  public function setupLayout(dc) {
    // To be implemented in subclasses
  }

  public function drawProgressBar(dc, percentage) {}

  public function createButton(
    rezIdList,
    locX,
    locY,
    widthOffset,
    heightOffset,
    identifier,
    buttonId,
    clearFunc
  ) {
    var imagesList = new Array<Drawable>[rezIdList.size()];
    var maxWidth = 0;
    var maxHeight = 0;
    for (var i = 0; i < rezIdList.size(); i++) {
        imagesList[i] = new WatchUi.Bitmap({ :rezId => rezIdList[i] });
        var dimensions = imagesList[i].getDimensions();
        if (maxWidth < dimensions[0]){
          maxWidth = dimensions[0];
        }
        if (maxHeight < dimensions[1]){
          maxHeight = dimensions[1];
        }
    }

    var width = maxWidth + (widthOffset * 2);
    var height = maxHeight + (heightOffset * 2);

    for (var i = 0; i < imagesList.size(); i++){
      imagesList[i].setLocation(widthOffset,heightOffset);
    }

    var options = {
      :stateDefault => imagesList[0],
      :stateHighlighted => imagesList[0],
      :stateSelected => imagesList[0],
      :stateDisabled => imagesList[0],
      :locX => locX,
      :locY => locY,
      :width => width,
      :height => height,
      :identifier => identifier,
      :buttonId => buttonId,
      :imageStates => imagesList,
      :playerState => playerState,
      :clearFunction => clearFunc,
    };
    return new CustomButton(options);
  }

  public function createText(
    text,
    color,
    font,
    locX,
    locY,
    width,
    height,
    clearFunc
  ) {
    return new OptimizedText({
      :text => text,
      :color => color,
      :font => font,
      :locX => locX,
      :locY => locY,
      :width => width,
      :height => height,
      :playerState => playerState,
      :clearFunction => clearFunc,
    });
  }

  public function createBitmap(rezId, locX, locY, width, height, faded,identifier) {
    return new OptimizedBitmap({
      :rezId => rezId,
      :locX => locX,
      :locY => locY,
      :width => width,
      :height => height,
      :identifier => identifier,
      :playerState => playerState,
      :faded => faded
    });
  }

  public function getDrawableList() {
    return _list;
  }

  public function scale(value, base) {
    return ((value / 100.0) * base).toNumber();
  }
}
