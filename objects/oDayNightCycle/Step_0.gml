var _deltaSeconds = delta_time / 1000000;
global.Time += _deltaSeconds * global.GameTimeScale;

var _newDay = false;

while (global.Time >= 86400) {
    global.Time -= 86400;
    global.Day += 1;
    _newDay = true;

    if (global.Day > global.CropTick) {
        global.CropTick = global.Day;

        with (oPlot) {
            if (Crop != undefined && !IsFullyGrown && !IsDead) {
                if (IsWatered) {
                    DryDays = 0;
                }
                else {
                    DryDays++;
                }

                if (DryDays >= 2) {
                    IsDead = true;
                }

                IsWatered = false;
            }
        }
    }
}

if (_newDay) {
    apply_day_stage();
}

global.TimeOfDay = global.Time / 86400;
var _hour = global.Time / 3600;

var _darkness = 0;

if (_hour >= SunsetHour || _hour < SunriseHour - TransitionHours) {
    _darkness = 0.75;
}
else if (_hour < SunriseHour) {
    var _progress = (_hour - (SunriseHour - TransitionHours)) / TransitionHours;
    _darkness = lerp(0.75, 0, _progress);
}
else if (_hour >= SunsetHour - TransitionHours) {
    var _progress = (_hour - (SunsetHour - TransitionHours)) / TransitionHours;
    _darkness = lerp(0, 0.75, _progress);
}

Darkness = clamp(_darkness, 0, 0.75);

R = lerp(DayColor[0], NightColor[0], Darkness);
G = lerp(DayColor[1], NightColor[1], Darkness);
B = lerp(DayColor[2], NightColor[2], Darkness);

global.TorchOn = (
    _hour >= SunsetHour ||
    _hour < SunriseHour - TransitionHours
);

with (oTorch) {
    sprite_index = global.TorchOn ? sTorchOn : sTorchOff;
}