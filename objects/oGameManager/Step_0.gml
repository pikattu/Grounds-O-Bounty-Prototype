if (!variable_global_exists("antique_room") || global.antique_room != room) {
    antique_setup_room();
}

if (keyboard_check_pressed(vk_f2)) antique_debug_tile_under_mouse();
if (keyboard_check_pressed(vk_f3)) antique_learn_dirt_tile();
if (keyboard_check_pressed(vk_f4)) antique_new_day();