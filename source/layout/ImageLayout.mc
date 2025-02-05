import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class ImageLayout extends BaseLayout {
  var progressBarWidth;

  public function initialize(dc, ps) {
    BaseLayout.initialize(dc, ps);
  }

  public function drawProgressBar(dc, percentage) {
  var xCord = width / 2 - (progressBarWidth / 2);
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
    dc.fillRoundedRectangle(
      xCord,
      height / 2 + scale(2, height),
      progressBarWidth,
      10,
      5
    );
    dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_BLACK);
    dc.fillRoundedRectangle(
      xCord,
      height / 2 + scale(2, height),
      percentage * progressBarWidth,
      10,
      5
    );
  }

  public function setupLayout(dc) {
    progressBarWidth = scale(72, width);
    var artistFont20 = Graphics.getVectorFont({
      :face => "RobotoCondensedRegular",
      :size => scale(10, height), 
    });
    var songFont = Graphics.getVectorFont({
      :face => "RobotoCondensedRegular",
      :size => scale(7, height), 
    });
    var timeFont25 = Graphics.getVectorFont({
      :face => "RobotoCondensedRegular",
      :size => scale(8.5, height), 
    });
    var timeFont70 = Graphics.getVectorFont({
      :face => "RobotoCondensedRegular",
      :size => scale(24, height),
    });

    currentImage = createBitmap(
      Rez.Drawables.placeHolder_full,
      0,
      0,
      height,
      height,
      true,
      "currentSongImage"
    );


    currentArtist = createText(
      "No song",
      Graphics.COLOR_WHITE,
      artistFont20,
      WatchUi.LAYOUT_HALIGN_CENTER,
      scale(29, height), //120,
      scale(20, width), //61,
      scale(5, height), //20,
      method(:customClear)
    );

    currentSongName = createText(
      "No song",
      Graphics.COLOR_WHITE,
      songFont,
      WatchUi.LAYOUT_HALIGN_CENTER,
      scale(40, height), //165,
      scale(36, width), //150,
      scale(5, height), //20,
      method(:customClear)
    );
    currentTimeString = createText(
      "",
      Graphics.COLOR_WHITE,
      timeFont25,
      WatchUi.LAYOUT_HALIGN_CENTER,
      scale(55, height), //230,
      scale(24, width), //100,
      scale(12, height), //50,
      method(:customClear)
    );
    currentTimeHours = createText(
      "99",
      Graphics.COLOR_WHITE,
      timeFont70,
      width / 2 - scale(20, width) - scale(5, width), // width / 2 -
      scale(5, height), //20,
      null,
      null,
      method(:customClear)
    );
    var currentTimeSpacer = createText(
      ":",
      Graphics.COLOR_WHITE,
      timeFont70,
      width / 2 - scale(2.5, width), // width / 2 - 10
      scale(5, height), //20,
      null,
      null,
      method(:customClear)
    );
    currentTimeMinutes = createText(
      "99",
      Graphics.COLOR_WHITE,
      timeFont70,
      width / 2 + scale(5, width), // + 20
      scale(5, height), //20,
      scale(24, height), //100,
      scale(24, height), //100,
      method(:customClear)
    );



    nextButton = createButton(
      [$.Rez.Drawables.next],
      width - scale(17, width) - scale(6, height), //scale(78,width),//325,
      scale(57, height), //235,
      scale(0, height),
      scale(0, height),
      "nextButton",
      OperationEnum.NEXT,
      method(:customClear)
    );

    previousButton = createButton(
      [$.Rez.Drawables.previous],
      scale(17, width), //70,
      scale(57, height), //235,
      scale(0, height),
      scale(0, height),
      "previousButton",
      OperationEnum.PREVIOUS,
      method(:customClear)
    );

    playButton = createButton(
      [$.Rez.Drawables.play, $.Rez.Drawables.pause],
      width / 2 - scale(29 / 2, height), //width / 2 - 55,
      scale(67, height), // 280
      scale(0, height),
      scale(0, height), ///120,
      "playButton",
      OperationEnum.PLAY,
      method(:customClear)
    );

    likeButton = createButton(
      [$.Rez.Drawables.like, $.Rez.Drawables.liked],
      width - scale(19, width) - scale(16, height), //width - 130, 16
      scale(65, height), //300, 72
      scale(5, width),
      scale(7, height),
      "likeButton",
      OperationEnum.LIKE,
      method(:customClear)
    );
    repeatButton = createButton(
      [
        $.Rez.Drawables.repeatOff,
        $.Rez.Drawables.repeatSolo,
        $.Rez.Drawables.repeatAll,
      ],
      scale(11, width), //56,
      scale(65, height), //290,
      scale(5, width), //77,
      scale(4, height), //94,
      "repeatButton",
      OperationEnum.REPEAT,
      method(:customClear)
    );

    _list.add(currentImage);
    _list.add(currentArtist);
    _list.add(currentSongName);
    _list.add(playButton);
    _list.add(currentTimeString);
    _list.add(nextButton);
    _list.add(previousButton);
    _list.add(likeButton);
    _list.add(repeatButton);
    _list.add(currentTimeHours);
    _list.add(currentTimeMinutes);
    _list.add(currentTimeSpacer);

    return _list;
  }

  public function customClear(dc, realX, realY, textWidth, textHeight) {
    dc.setClip(realX, realY, textWidth, textHeight);
    currentImage.drawWithFade(dc);
  }


  public function getDrawableList() {
    return _list;
  }
}
