import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Time;

class OptimizedText extends WatchUi.Text {
  var _currentValue as String;
  var _isChanged as Boolean = true;
  var _playerState as PlayerState;
  var prevWidth = 0;
  var prevX = 1000;
  var font;
  var customClearFunction as
  (Method(dc, realX, realY, textWidth, textHeight) as Void);

  public function initialize(
    options as
      {
        :text as Lang.String or Lang.ResourceId,
        :color as Graphics.ColorType,
        :backgroundColor as Graphics.ColorType,
        :font as Graphics.FontType,
        :justification as Graphics.TextJustification or Lang.Number,
        :identifier as Lang.Object,
        :locX as Lang.Numeric,
        :locY as Lang.Numeric,
        :width as Lang.Numeric,
        :height as Lang.Numeric,
        :visible as Lang.Boolean,
        :playerState as PlayerState,
        :clearFunction as Method,
      }
  ) {
    _playerState = options.get(:playerState);
    customClearFunction = options.get(:clearFunction);
    font = options.get(:font);
    Text.initialize(options);
    _isChanged = true;
  }

  public function getText() {
    return _currentValue;
  }

  public function setText(value) {
    if (_currentValue != null && _currentValue.equals(value)) {
      return;
    }
    _currentValue = value;
    _isChanged = true;
    Text.setText(value);
  }

  public function setTextWithoutState(value) {
    if (_currentValue != null && _currentValue.equals(value)) {
      return;
    }
    _currentValue = value;
    _isChanged = true;
    Text.setText(value);
  }

  public function isChanged() {
    return _isChanged;
  }

  public function drawChecked(dc, shouldCheck) {
    if (shouldCheck) {
      if (_isChanged) {
        draw(dc);
      }
    } else {
      draw(dc);
    }
    _isChanged = false;
  }

  public function draw(dc) {
    var dim = dc.getTextDimensions(_currentValue, font);
    var realX;
    if (locX == WatchUi.LAYOUT_HALIGN_CENTER) {
      realX = dc.getWidth() / 2 - dim[0] / 2;
    } else {
      realX = locX;
    }
    var curWidth = dim[0];
    var curX = realX;
    if (prevWidth > curWidth) {
      curWidth = prevWidth;
      curX = prevX;
    }
    clearWithClip(dc, curX, locY, curWidth, dim[1]);
    Text.draw(dc);
    dc.clearClip();
    _isChanged = false;
    prevWidth = dim[0];
    prevX = realX;
  }

  public function clearWithClip(dc, realX, realY, textWidth, textHeight) {
    customClearFunction.invoke(dc, realX, realY, textWidth, textHeight);
  }
}
