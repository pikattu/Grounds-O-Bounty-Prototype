var _ox = digging ? choose(-1, 0, 1) : 0;

var _spr = asset_get_index("sDigSpot");
if (sprite_exists(_spr)) {
    draw_sprite(_spr, 0, x + _ox, y);
} else {
    draw_set_colour(make_colour_rgb(110, 70, 40));
    draw_ellipse(x - 6 + _ox, y - 3, x + 6 + _ox, y + 3, false);
    draw_set_colour(make_colour_rgb(150, 100, 60));
    draw_ellipse(x - 4 + _ox, y - 2, x + 3 + _ox, y + 1, false);
    draw_set_colour(c_white);
}

if (near && !digging) {
    draw_set_halign(fa_center);
    draw_text(x, y - 18, "[" + chr(ANTIQUE_KEY) + "] Dig");
    draw_set_halign(fa_left);
}