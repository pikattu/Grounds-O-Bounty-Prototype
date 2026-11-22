var _def = global.antique_defs[artifact];
var _spr = antique_sprite(artifact);
if (_spr != -1) draw_sprite(_spr, 0, x, y - 12);

draw_set_halign(fa_center);
draw_text(x, y, "Found: " + _def.name);
draw_text(x, y + 14, _def.desc);
draw_set_halign(fa_left);