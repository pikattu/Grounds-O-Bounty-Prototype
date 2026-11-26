if (instance_exists(oDialogue)) {
    with (oDialogue) dialogue_draw_gui();
}
var _idx = clamp(global.Day - 2, 0, array_length(global.day_stages) - 1);
draw_set_color(c_white);
draw_text(8, 200, "Stage: " + global.day_stages[_idx]);
var _line = "vis";
for (var s = 0; s < array_length(global.day_suffixes); s++) {
    var _vis = 0;
    for (var b = 0; b < array_length(global.day_layer_bases); b++) {
        var _n = global.day_layer_bases[b] + global.day_suffixes[s];
        if (layer_exists(_n) && layer_get_visible(_n)) _vis++;
    }
    _line += "  " + string(_vis);
}
draw_text(8, 215, _line);