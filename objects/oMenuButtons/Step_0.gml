var _gw = 480;
var _gh = 270;

var _sw = sprite_get_width(sMenuButtonNew);
var _sh = sprite_get_height(sMenuButtonNew);
var _gap = 6;

btn_scale = min(1, (_gw * 0.35) / _sw, ((_gh * 0.38) - _gap * 2) / (_sh * 3));

button_width  = _sw * btn_scale;
button_height = _sh * btn_scale;
button_x      = (_gw - button_width) / 2;
newgame_y     = _gh * 0.58;
continue_y    = newgame_y + button_height + _gap;
exit_y        = continue_y + button_height + _gap;

var _mx = window_mouse_get_x() * _gw / window_get_width();
var _my = window_mouse_get_y() * _gh / window_get_height();

dbg_mx = _mx;
dbg_my = _my;

hovered_button = "";

// Reset hover
hovered_button = "";

// New Game hover
if (point_in_rectangle(
    _mx, _my,
    button_x, newgame_y,
    button_x + button_width,
    newgame_y + button_height
))
{
    hovered_button = "newgame";

    if (mouse_check_button_pressed(mb_left))
    {
       //cr_NewGame();
	   room_goto(rmPlayerFarm);
    }
}

// Continue hover
if (point_in_rectangle(
    _mx, _my,
    button_x, continue_y,
    button_x + button_width,
    continue_y + button_height
))
{
    if (has_save)
    {
        hovered_button = "continue";

        if (mouse_check_button_pressed(mb_left))
        {
            // We'll implement loading later
            // scr_LoadGame();
        }
    }
}

// Exit hover
if (point_in_rectangle(
    _mx, _my,
    button_x, exit_y,
    button_x + button_width,
    exit_y + button_height
))
{
    hovered_button = "exit";

    if (mouse_check_button_pressed(mb_left))
    {
        game_end();
    }
}
