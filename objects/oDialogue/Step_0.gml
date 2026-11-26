dialogue_step();

if (current_time mod 2000 < 20) {
    var _dd = -1;
    var _all = [oEduardo, oHope, oJoshua, oKristine, oMJ, oPrincess];
    if (instance_exists(oPlayer)) {
        for (var i = 0; i < array_length(_all); i++) {
            var _n = instance_nearest(oPlayer.x, oPlayer.y, _all[i]);
            if (_n != noone) {
                var _dist = point_distance(oPlayer.x, oPlayer.y, _n.x, _n.y);
                if (_dd < 0 || _dist < _dd) _dd = _dist;
            }
        }
    }
    show_debug_message("dlg | player:" + string(instance_exists(oPlayer))
        + " nearest npc dist:" + string(round(_dd))
        + " near:" + string(near_npc) + " active:" + string(active));
}