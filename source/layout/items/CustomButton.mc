import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class CustomButton extends WatchUi.Button {
  var currentStateNumber = 0;
  var imageStates as Array<Drawable>;
  var buttonId;
  var _isChanged as Boolean;
  var _playerState as PlayerState;
  var customClearFunction as
  (Method(dc, realX, realY, textWidth, textHeight) as Void);

  //! Constructor
  //! @param options A Dictionary of check box options
  //! @option options :locX The x-coordinate for the check box
  //! @option options :locY The y-coordinate for the check box
  //! @option options :width The clip width of the check box
  //! @option options :height The clip height of the check box
  //! @option options :stateDefault The Drawable or color to display in default state
  //! @option options :stateHighlighted The Drawable or color to display in highlighted state
  //! @option options :stateSelected The Drawable or color to display in selected state
  //! @option options :stateDisabled The Drawable or color to display in disabled state
  //! @option options :stateHighlightedSelected The Drawable or color to display in the
  //!  selected and highlighted state
  public function initialize(
    options as
      {
        :locX as Number,
        :locY as Number,
        :width as Number,
        :height as Number,
        :stateDefault as Graphics.ColorType or Drawable,
        :stateHighlighted as Graphics.ColorType or Drawable,
        :stateSelected as Graphics.ColorType or Drawable,
        :stateDisabled as Graphics.ColorType or Drawable,
        :stateSecond as Graphics.ColorType or Drawable,
        :identifier as Lang.Object,
        :buttonId as OperationEnum,
        :imageStates as Array<Drawable>,
        :playerState as PlayerState,
        :clearFunction as Method,
      }
  ) {
    _playerState = options.get(:playerState);
    customClearFunction = options.get(:clearFunction);
    Button.initialize(options);
    imageStates = options.get(:imageStates);
    buttonId = options.get(:buttonId);
    _isChanged = true;
  }

  public function changeState() {
    currentStateNumber++;
    if (currentStateNumber >= imageStates.size()) {
      currentStateNumber = 0;
    }
    changeInternalState();
  }

  public function setState(number) {
    currentStateNumber = number;
    changeInternalState();
  }

  private function changeInternalState() {
    stateDefault = imageStates[currentStateNumber];
    stateSelected = imageStates[currentStateNumber];
    stateHighlighted = imageStates[currentStateNumber];
    _isChanged = true;
  }

  public function drawChecked(dc, shouldCheck) {
    if (shouldCheck) {
      if (_isChanged) {
        clearWithClip(dc);
        Button.draw(dc);
      }
    } else {
      Button.draw(dc);
    }
    _isChanged = false;
  }

  public function draw(dc) {
    clearWithClip(dc);
    Bitmap.draw(dc);
    _isChanged = false;
  }

  public function clearWithClip(dc) {
    customClearFunction.invoke(dc, locX, locY, width, height);
  }
}
