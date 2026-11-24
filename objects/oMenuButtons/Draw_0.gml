//var _gw = display_get_gui_width();
//var _gw = display_get_gui_width();
//var _gh = display_get_gui_height();

//button_width  = _gw * 0.32;
//button_height = _gh * 0.105;
//button_x      = (_gw - button_width) / 2;
//newgame_y     = _gh * 0.58;
//continue_y    = newgame_y + button_height + _gh * 0.025;
//exit_y        = continue_y + button_height + _gh * 0.025;
///// oMenuButtons - Draw GUI Event

//var _buttons = [
//    ["NEW GAME", newgame_y, "newgame"],
//    ["CONTINUE", continue_y, "continue"],
//    ["EXIT", exit_y, "exit"]
//];

//for (var i = 0; i < array_length(_buttons); i++)
//{
//    var _label = _buttons[i][0];
//    var _y = _buttons[i][1];
//    var _id = _buttons[i][2];

//    var _hover = (hovered_button == _id);

//    // Button background
//    if (_id == "continue" && !has_save)
//    {
//        draw_set_color(make_color_rgb(90, 90, 90));
//    }
//    else if (_hover)
//    {
//        draw_set_color(make_color_rgb(190, 130, 70));
//    }
//    else
//    {
//        draw_set_color(make_color_rgb(110, 75, 45));
//    }

//    draw_rectangle(
//        button_x, _y,
//        button_x + button_width,
//        _y + button_height,
//        false
//    );

//    // Button outline
//    draw_set_color(c_white);
//    draw_rectangle(
//        button_x, _y,
//        button_x + button_width,
//        _y + button_height,
//        true
//    );

//    // Button text
//    draw_set_halign(fa_center);
//    draw_set_valign(fa_middle);

//    if (_id == "continue" && !has_save)
//        draw_set_color(make_color_rgb(160, 160, 160));
//    else
//        draw_set_color(c_white);

//    draw_text(
//        button_x + button_width / 2,
//        _y + button_height / 2,
//        _label
//    );
//}

//// Reset drawing settings
//draw_set_color(c_white);
//draw_set_halign(fa_left);
//draw_set_valign(fa_top);


if (!variable_instance_exists(id, "btn_scale")) exit;

var _list = [
    [sMenuButtonNew,      sMenuButtonNewHover,      newgame_y,   "newgame",  "NEW GAME"],
    [sMenuButtonContinue, sMenuButtonContinueHover, continue_y,  "continue", "CONTINUE"],
    [sMenuButtonExit,     sMenuButtonExitHover,     exit_y,      "exit",     "EXIT"]
];

for (var i = 0; i < array_length(_list); i++)
{
    var _normal = _list[i][0];
    var _hov    = _list[i][1];
    var _y      = _list[i][2];
    var _id     = _list[i][3];
    var _label  = _list[i][4];

    var _spr = _normal;
    if (hovered_button == _id) _spr = _hov;

    var _dx = button_x + sprite_get_xoffset(_spr) * btn_scale;
    var _dy = _y + sprite_get_yoffset(_spr) * btn_scale;

    var _locked = (_id == "continue" && !has_save);

    var _col = c_white;
    var _alpha = 1;
    if (_locked)
    {
        _col = c_gray;
        _alpha = 0.5;
    }

    draw_sprite_ext(_spr, 0, _dx, _dy, btn_scale, btn_scale, 0, _col, _alpha);
	
	draw_set_font(global.FontDialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(_alpha);
    draw_set_color(_locked ? c_ltgray : c_white);
    draw_text(button_x + button_width / 2, _y + button_height / 2, _label);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);