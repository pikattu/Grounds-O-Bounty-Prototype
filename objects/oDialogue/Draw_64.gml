draw_text(8, 8, "dialogue draw gui alive");
dialogue_draw_gui();

var _t = "dlg player:" + string(instance_exists(oPlayer))
    + " textbox:" + string(instance_number(oTextBox))
    + " near:" + string(near_npc)
    + " active:" + string(active);

var _objs = [oEduardo, oHope, oJoshua, oKristine, oMJ, oPrincess];
for (var i = 0; i < array_length(_objs); i++) {
    var _o = instance_nearest(oPlayer.x, oPlayer.y, _objs[i]);
    if (_o != noone) {
        _t += "\n" + object_get_name(_objs[i]) + " dist:" + string(round(point_distance(oPlayer.x, oPlayer.y, _o.x, _o.y)));
    }
}

draw_set_color(c_yellow);
draw_text(8, 8, _t);
draw_set_color(c_white);