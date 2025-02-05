class PlayerState{
    public var isStateChanged = true;
    public var isUpdatingSongTime;
    public var layoutType as LayoutEnum;

     public function initialize(){
        layoutType = Application.Storage.getValue("playerLayoutType");
        if (layoutType == null){
            layoutType = LayoutEnum.DEFAULT;
        }
    }
}