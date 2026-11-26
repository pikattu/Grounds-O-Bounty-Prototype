#macro CONTROLS_BOX_SPRITE   sTextBox
#macro CONTROLS_BOX_BORDER   0
#macro CONTROLS_TEXT_SCALE   1

function controls_is_open() {
    return variable_global_exists("controls_open") && global.controls_open;
}

function controls_ensure() {
    if (!instance_exists(oControlsMenu)) instance_create_depth(0, 0, -25000, oControlsMenu);
}

function controls_font() {
    return -1;
}

function controls_list() {
    return [
        ["Move",                   "W A S D"],
        ["Interact / Talk / Dig",  "E"],
        ["Select hotbar slot",     "1 - 5"],
        ["Open inventory",         "I"],
        ["Use tool / Click",       "Left Click"],
        ["Controls menu",          "Esc"]
    ];
}

function controls_create() {
    global.controls_open = false;
}

function controls_open_menu() {
    global.controls_open = true;
    global.dialogue_active = true;
}

function controls_close() {
    global.controls_open = false;
    global.dialogue_active = false;
}

function controls_step() {
    if (room == rmMainMenu) {
        if (controls_is_open()) controls_close();
        exit;
    }

    if (keyboard_check_pressed(vk_escape)) {
        if (controls_is_open()) {
            controls_close();
        } else if (!dialogue_is_active()) {
            controls_open_menu();
        }
    }
}

function controls_draw_box(_spr, _x, _y, _w, _h) {
    var _b = CONTROLS_BOX_BORDER;
    if (_b <= 0) {
        draw_sprite_stretched(_spr, 0, _x, _y, _w, _h);
        return;
    }

    var _sw = sprite_get_width(_spr);
    var _sh = sprite_get_height(_spr);
    var _mw = _sw - _b * 2;
    var _mh = _sh - _b * 2;
    var _cw = _w - _b * 2;
    var _ch = _h - _b * 2;
    var _xs = _cw / _mw;
    var _ys = _ch / _mh;

    draw_sprite_part(_spr, 0, 0,        0,        _b, _b, _x,           _y);
    draw_sprite_part(_spr, 0, _sw - _b, 0,        _b, _b, _x + _w - _b, _y);
    draw_sprite_part(_spr, 0, 0,        _sh - _b, _b, _b, _x,           _y + _h - _b);
    draw_sprite_part(_spr, 0, _sw - _b, _sh - _b, _b, _b, _x + _w - _b, _y + _h - _b);

    draw_sprite_part_ext(_spr, 0, _b,        0,        _mw, _b,  _x + _b,       _y,           _xs, 1,   c_white, 1);
    draw_sprite_part_ext(_spr, 0, _b,        _sh - _b, _mw, _b,  _x + _b,       _y + _h - _b, _xs, 1,   c_white, 1);
    draw_sprite_part_ext(_spr, 0, 0,         _b,       _b,  _mh, _x,            _y + _b,      1,   _ys, c_white, 1);
    draw_sprite_part_ext(_spr, 0, _sw - _b,  _b,       _b,  _mh, _x + _w - _b,  _y + _b,      1,   _ys, c_white, 1);
    draw_sprite_part_ext(_spr, 0, _b,        _b,       _mw, _mh, _x + _b,       _y + _b,      _xs, _ys, c_white, 1);
}

function controls_text(_x, _y, _str, _col, _s) {
    draw_set_color(c_black);
    draw_text_transformed(_x + 1, _y + 1, _str, _s, _s, 0);
    draw_set_color(_col);
    draw_text_transformed(_x, _y, _str, _s, _s, 0);
}

function controls_draw_gui() {
    if (!controls_is_open()) exit;

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    draw_set_alpha(0.55);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    var _f = controls_font();
    if (_f != -1) draw_set_font(_f);

    var _list = controls_list();
    var _n = array_length(_list);
    var _title = "CONTROLS";
    var _hint = "Press Esc to close";

    var _pad = 14;
    var _gap = 16;
    var _aw = 0;
    var _kw = 0;
    for (var i = 0; i < _n; i++) {
        _aw = max(_aw, string_width(_list[i][0]));
        _kw = max(_kw, string_width(_list[i][1]));
    }

    var _lh = string_height("A") + 4;
    var _w = max(_aw + _kw + _gap, string_width(_title), string_width(_hint)) + _pad * 2;
    var _h = _pad * 2 + _lh * (_n + 2) + 4;

    var _s = min(CONTROLS_TEXT_SCALE, (_gw - 16) / _w, (_gh - 16) / _h);
    var _bw = _w * _s;
    var _bh = _h * _s;
    var _bx = (_gw - _bw) / 2;
    var _by = (_gh - _bh) / 2;

    controls_draw_box(CONTROLS_BOX_SPRITE, _bx, _by, _bw, _bh);

    draw_set_valign(fa_top);

    draw_set_halign(fa_center);
    controls_text(_bx + _bw / 2, _by + _pad * _s, _title, c_yellow, _s);

    for (var i = 0; i < _n; i++) {
        var _ry = _by + _pad * _s + (_lh * (i + 1) + 4) * _s;

        draw_set_halign(fa_left);
        controls_text(_bx + _pad * _s, _ry, _list[i][0], c_white, _s);

        draw_set_halign(fa_right);
        controls_text(_bx + _bw - _pad * _s, _ry, _list[i][1], c_yellow, _s);
    }

    draw_set_halign(fa_center);
    controls_text(_bx + _bw / 2, _by + _bh - (_pad + _lh) * _s, _hint, c_ltgray, _s);

    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}