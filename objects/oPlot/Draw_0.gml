draw_self();

if (Crop != undefined) {

    var Sprite = Crop.Sprite;
    var SubImage = 0;

    var TotalTime = Crop.GrowTime;
    var StageTime = TotalTime / 5;

    if (Tick >= 0 && Tick < StageTime) SubImage = 0;
    else if (Tick >= StageTime && Tick < StageTime * 2) SubImage = 1;
    else if (Tick >= StageTime * 2 && Tick < StageTime * 3) SubImage = 2;
    else if (Tick >= StageTime * 3 && Tick < StageTime * 4) SubImage = 3;
    else if (Tick >= StageTime * 4) SubImage = 4;

    draw_sprite_ext(Sprite, SubImage, x, y, 1, 1, 0, c_white, 1);

}