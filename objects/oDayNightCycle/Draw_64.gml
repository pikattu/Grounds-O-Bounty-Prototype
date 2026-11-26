

/// oDayNightCycle - Draw GUI Event

var _hour = floor(global.Time / 3600);
var _minute = floor((global.Time mod 3600) / 60);
var _second = floor(global.Time mod 60);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text(20, 20, "DAY: " + string(global.Day));

draw_text(20, 45,
    "TIME: " + string(_hour) + ":" +
    string_format(_minute, 2, 0) + ":" +
    string_format(_second, 2, 0)
);

draw_text(20, 70, "TIME SCALE: " + string(TimeScale));

draw_text(20, 95, "DARKNESS: " + string(Darkness));

draw_text(20, 120, "TORCH: " + string(global.TorchOn));

draw_text(20, 145, "DAY LENGTH: " + string(DayLengthMinutes));

draw_text(20, 170, "DT: " + string(delta_time / 1000000));