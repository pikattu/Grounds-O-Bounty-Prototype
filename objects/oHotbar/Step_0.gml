if (!global.inventory_open)
{
    if (keyboard_check_pressed(ord("1"))) global.selected_slot = 0;
    if (keyboard_check_pressed(ord("2"))) global.selected_slot = 1;
    if (keyboard_check_pressed(ord("3"))) global.selected_slot = 2;
    if (keyboard_check_pressed(ord("4"))) global.selected_slot = 3;
    if (keyboard_check_pressed(ord("5"))) global.selected_slot = 4;
    if (keyboard_check_pressed(ord("6"))) global.selected_slot = 5;
    if (keyboard_check_pressed(ord("7"))) global.selected_slot = 6;
    if (keyboard_check_pressed(ord("8"))) global.selected_slot = 7;
}