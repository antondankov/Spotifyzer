import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;

class OptimizedBitmap extends WatchUi.Bitmap {
  var _isChanged as Boolean;
  var _playerState as PlayerState;
  var _isFaded as Boolean;
  var customClearFunction as
  (Method(dc, realX, realY, textWidth, textHeight) as Void);

  public function initialize(
    options as
      {
        :rezId as Lang.ResourceId,
        :bitmap as Graphics.BitmapType,
        :identifier as Lang.Object,
        :locX as Lang.Numeric,
        :locY as Lang.Numeric,
        :width as Lang.Numeric,
        :height as Lang.Numeric,
        :visible as Lang.Boolean,
        :faded as Boolean,
        :playerState as PlayerState,
        :clearFunction as Method,
      }
  ) {
    _playerState = options.get(:playerState);
    customClearFunction = options.get(:clearFunction);
    _isFaded = options.get(:faded);
    Bitmap.initialize(options);
    _isChanged = true;
  }

  public function setBitmap(
    bitmap as Graphics.BitmapType or Lang.ResourceId or Null
  ) {
    if (bitmap == null) {
      return;
    }
    _isChanged = true;
    _playerState.isStateChanged = false;
    Bitmap.setBitmap(bitmap);
  }

  public function drawChecked(dc, shouldCheck) {
    if (shouldCheck) {
      if (_isChanged) {
        dc.setClip(locX, locY, width, height);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        draw(dc);
        dc.clearClip();
      }
    } else {
      draw(dc);
    }
  }

  public function drawWithFade(dc) {
    Bitmap.draw(dc);
    dc.setFill(dc.createColor(128, 0, 0, 0));
    dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
  }
  public function drawWithFadeAndClip(dc) {
    dc.clearClip();
    dc.setFill(dc.createColor(128, 0, 0, 0));
    dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
  }

  public function draw(dc) {
    clearWithClip(dc);
    if (_isFaded) {
      drawWithFade(dc);
    } else {
      Bitmap.draw(dc);
    }
    _isChanged = false;
  }

  public function clearWithClip(dc) {
    if (customClearFunction == null) {
      dc.setClip(locX, locY, width, height);
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      dc.clear();
      dc.clearClip();
    } else {
      customClearFunction.invoke(dc, locX, locY, width, height);
    }
  }

  public function getWidth() {
    return width;
  }

  public function getHeight() {
    return height;
  }
}
