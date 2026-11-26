save_apply_pending();

if (keyboard_check_pressed(vk_f5)) save_game();
if (keyboard_check_pressed(vk_f9)) load_game();
if (keyboard_check_pressed(vk_f6)) {
    var _objs = [oPlot, oChest, oPlayer, oTimeOfDay, oDayNightCycle];
    for (var i = 0; i < array_length(_objs); i++) save_debug_print_vars(_objs[i]);
}

if (!variable_global_exists("path_graph_room") || global.path_graph_room != room) {
    scr_build_path_graph();
    global.path_graph_room = room;
}

if (!variable_global_exists("antique_room") || global.antique_room != room) {
    antique_setup_room();
}

if (keyboard_check_pressed(vk_f2)) antique_debug_tile_under_mouse();
if (keyboard_check_pressed(vk_f3)) antique_learn_dirt_tile();
if (keyboard_check_pressed(vk_f4)) antique_new_day();

if (keyboard_check_pressed(vk_f7) && instance_exists(oGUI)) {
    var _i = oGUI.Inv;
    show_debug_message("Inv type: " + typeof(_i) + " | " + string(_i));
    if (is_real(_i)) {
        show_debug_message("grid:" + string(ds_exists(_i, ds_type_grid))
            + " list:" + string(ds_exists(_i, ds_type_list))
            + " map:" + string(ds_exists(_i, ds_type_map)));
    }
}

dialogue_ensure();