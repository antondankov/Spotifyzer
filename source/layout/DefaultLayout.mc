import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class DefaultLayout extends BaseLayout {
  var progressBarWidth;

  public function initialize(dc, ps) {
    BaseLayout.initialize(dc, ps);
  }

  public function drawProgressBar(dc, percentage) {
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
    var xCord = width / 2 - (progressBarWidth / 2);
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
    var artistFont = Graphics.getVectorFont({
      :face => "RobotoCondensedRegular",
      :size => scale(5, height),
    });
    var timeFont6 = Graphics.getVectorFont({
      :face => "RobotoCondensedRegular",
      :size => scale(6, height),
    });
    var timeFont26 = Graphics.getVectorFont({
      :face => "RobotoCondensedRegular",
      :size => scale(26, height),
    });

    currentImage = createBitmap(
      Rez.Drawables.placeHolder,
      WatchUi.LAYOUT_HALIGN_CENTER,
      scale(5, height),
      scale(50, height),
      scale(50, height),
      false,
      "currentSongImage"
    );
    currentArtist = createText(
      "No song",
      Graphics.COLOR_LT_GRAY,
      artistFont,
      WatchUi.LAYOUT_HALIGN_CENTER,
      scale(35, height),
      scale(20, width), //61,
      scale(5, height), // 20,
      method(:customClear)
    );
    currentSongName = createText(
      "No song",
      Graphics.COLOR_WHITE,
      Graphics.FONT_XTINY,
      WatchUi.LAYOUT_HALIGN_CENTER,
      165,
      150,
      20,
      method(:customClear)
    );

    

    currentTimeString = createText(
      "",
      Graphics.COLOR_WHITE,
      timeFont6,
      WatchUi.LAYOUT_HALIGN_CENTER,
      scale(55, height), //230,
      scale(24, width), //100,
      scale(12, height), //50,
      method(:customClear)
    );

    nextButton = createButton(
      [Rez.Drawables.next],
      width - scale(17, width) - scale(6, height), //scale(78,width),//325,
      scale(57, height), //235,
      scale(0, height),
      scale(0, height),
      "nextButton",
      OperationEnum.NEXT,
      method(:customClear)
    );
    previousButton = createButton(
      [Rez.Drawables.previous],
      scale(17, width), //
      scale(57, height),
      scale(0, height), //25
      scale(0, height),
      "previousButton",
      OperationEnum.PREVIOUS,
      method(:customClear)
    );

    playButton = createButton(
      [Rez.Drawables.play, Rez.Drawables.pause],
      width / 2 - scale(29 / 2, height), // width / 2 - 50,
      scale(67, height),
      scale(0, height),
      scale(0, height),
      "playButton",
      OperationEnum.PLAY,
      method(:customClear)
    );

    likeButton = createButton(
      [Rez.Drawables.like, Rez.Drawables.liked],
      width - scale(19, width) - scale(16, height), //width - 130,
      scale(65, height), //300,
      scale(5, height), //65,
      scale(7, height), //65,
      "likeButton",
      OperationEnum.LIKE,
      method(:customClear)
    );
    repeatButton = createButton(
      [
        Rez.Drawables.repeatOff,
        Rez.Drawables.repeatSolo,
        Rez.Drawables.repeatAll,
      ],
      scale(11, width), //67,
      scale(65, height), //290,
      scale(5, width), //77,
      scale(4, height), //94,
      "repeatButton",
      OperationEnum.REPEAT,
      method(:customClear)
    );

    currentTimeHours = createText(
      "00",
      Graphics.COLOR_WHITE,
      timeFont26,
      scale(12, width), //50,
      scale(15, height), //60,
      null,
      null,
      method(:customClear)
    );
    currentTimeMinutes = createText(
      "00",
      Graphics.COLOR_WHITE,
      timeFont26,
      scale(67, width), //280,
      scale(15, height), //60,
      scale(24, height), //100,
      scale(24, height), //100,
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
  }

  public function customClear(dc, realX, realY, textWidth, textHeight) {
    dc.setClip(realX, realY, textWidth, textHeight);
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();
  }
}
