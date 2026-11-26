function day_stage_init() {
    if (variable_global_exists("day_suffixes")) return;
    global.day_stages = ["NormalStage", "Day3", "Day4", "Day5_Construction", "Day6_Complete"];
    global.day_suffixes = ["", "_1", "_1_1", "_1_1_1", "_1_1_1_1"];
    global.day_layer_bases = ["iBuildings", "iTrees", "Bridge", "tDecor", "tDirtGrass", "tLeftSideSoil", "tCliff2", "tCliff1", "tLand", "tBaseGround"];
    global.kubo_hide_day = 3;
}

function apply_day_stage() {
    day_stage_init();

    if (global.Day >= global.kubo_hide_day) {
        instance_deactivate_object(oKubo);
    }
    else {
        instance_activate_object(oKubo);
    }

    var _idx = clamp(global.Day - 2, 0, array_length(global.day_suffixes) - 1);

    var _has_target = false;
    for (var b = 0; b < array_length(global.day_layer_bases); b++) {
        if (layer_exists(global.day_layer_bases[b] + global.day_suffixes[_idx])) {
            _has_target = true;
            break;
        }
    }
    if (!_has_target) return;

    for (var s = 0; s < array_length(global.day_suffixes); s++) {
        var _show = (s == _idx);
        for (var b = 0; b < array_length(global.day_layer_bases); b++) {
            var _name = global.day_layer_bases[b] + global.day_suffixes[s];
            if (layer_exists(_name)) {
                layer_set_visible(_name, _show);
                if (_show) {
                    instance_activate_layer(_name);
                }
                else {
                    instance_deactivate_layer(_name);
                }
            }
        }
    }
}