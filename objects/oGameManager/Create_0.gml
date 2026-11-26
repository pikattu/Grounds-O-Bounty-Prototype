if (instance_number(oGameManager) > 1) {
    instance_destroy();
    exit;
}
window_set_size(1440, 810);
window_center();
global.day = 1;
global.day_stages = ["NormalStage", "Day3", "Day4", "Day5_Construction", "Day6_Complete"];

// store

CurrentStore = noone;
// Player Currency
global.Coins = 100;
var _layers = layer_get_all();
for (var i = 0; i < array_length(_layers); i++) {
    show_debug_message("layer: " + layer_get_name(_layers[i]));
}
day_stage_init();