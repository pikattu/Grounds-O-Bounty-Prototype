
/// oPlot - Draw Event

// Draw soil / plot sprite
draw_self();

// ==========================================
// DRAW CROP
// ==========================================

if (Crop != undefined) {

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
