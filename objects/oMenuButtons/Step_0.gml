
/// oMenuButtons - Step Event

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

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
        scr_NewGame();
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
