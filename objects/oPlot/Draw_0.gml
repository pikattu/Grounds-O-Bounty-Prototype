
/// oPlot - Draw Event

// ==========================================
// DRAW PLOT (SOIL)
// ==========================================

if (IsWatered) {
    draw_sprite(sWateredPlot, 0, x, y);
}
else {
    draw_self();
}

// ==========================================
// DRAW CROP
// ==========================================

if (Crop != undefined) {

    // Dead crop
    if (IsDead) {
        draw_sprite(sDeadCrop, 0, x, y);
    }
    else {
        var _sprite = Crop.Sprite;

        if (sprite_exists(_sprite)) {

            var _subImage = clamp(
                Stage,
                0,
                sprite_get_number(_sprite) - 1
            );

            draw_sprite_ext(
                _sprite,
                _subImage,
                x,
                y,
                1,
                1,
                0,
                c_white,
                1
            );
        }
    }
	draw_text(x, y - 40,
    "Tick: " + string(Tick)
    + " | Stage: " + string(Stage)
    + " | Mature: " + string(IsFullyGrown)
    + " | Watered: " + string(IsWatered)
);
}

