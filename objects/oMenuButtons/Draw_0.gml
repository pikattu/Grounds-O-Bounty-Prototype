
/// oMenuButtons - Draw GUI Event

var _buttons = [
    ["NEW GAME", newgame_y, "newgame"],
    ["CONTINUE", continue_y, "continue"],
    ["EXIT", exit_y, "exit"]
];

for (var i = 0; i < array_length(_buttons); i++)
{
    var _label = _buttons[i][0];
    var _y = _buttons[i][1];
    var _id = _buttons[i][2];

    var _hover = (hovered_button == _id);

    // Button background
    if (_id == "continue" && !has_save)
    {
        draw_set_color(make_color_rgb(90, 90, 90));
    }
    else if (_hover)
    {
        draw_set_color(make_color_rgb(190, 130, 70));
    }
    else
    {
        draw_set_color(make_color_rgb(110, 75, 45));
    }

    draw_rectangle(
        button_x, _y,
        button_x + button_width,
        _y + button_height,
        false
    );

    // Button outline
    draw_set_color(c_white);
    draw_rectangle(
        button_x, _y,
        button_x + button_width,
        _y + button_height,
        true
    );

    // Button text
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (_id == "continue" && !has_save)
        draw_set_color(make_color_rgb(160, 160, 160));
    else
        draw_set_color(c_white);

    draw_text(
        button_x + button_width / 2,
        _y + button_height / 2,
        _label
    );
}

// Reset drawing settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
