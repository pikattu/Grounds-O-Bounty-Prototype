
/// oMenuButtons - Create Event

// Button dimensions
button_width = 180;
button_height = 40;
button_spacing = 15;
has_save = save_data_exists();

// Center buttons on screen
var _center_x = display_get_gui_width() / 2;
var _center_y = display_get_gui_height() / 2;

button_x = _center_x - button_width / 2;
button_y = _center_y;

// Button positions
newgame_y = button_y;
continue_y = newgame_y + button_height + button_spacing;
exit_y = continue_y + button_height + button_spacing;

// Save availability
has_save = save_data_exists();

// Hover tracking
hovered_button = "";

show_debug_message("button_x:" + string(button_x) + " new_y:" + string(newgame_y)
    + " | gui:" + string(display_get_gui_width()) + "x" + string(display_get_gui_height()));