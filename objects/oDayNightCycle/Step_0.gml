
/// oDayNightCycle - Step Event

// ==========================================
// UPDATE TIME
// ==========================================

var _deltaSeconds = delta_time / 1000000;

// Use the CENTRAL time scale
global.Time += _deltaSeconds * global.GameTimeScale;


// ==========================================
// DAY TRANSITION
// ==========================================

while (global.Time >= 86400) {

    global.Time -= 86400;
    global.Day += 1;


    // ==========================================
    // DAILY CROP WATER CHECK
    // ==========================================

    // Prevent processing the same day more than once
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

                // Die after 2 consecutive dry days
                if (DryDays >= 2) {
                    IsDead = true;
                }

                // Reset water for the next day
                IsWatered = false;
            }
        }
    }
}


// ==========================================
// UPDATE TIME OF DAY
// ==========================================

global.TimeOfDay = global.Time / 86400;

var _hour = global.Time / 3600;


// ==========================================
// CALCULATE DARKNESS
// ==========================================

var _darkness = 0;

// Full night
if (_hour >= SunsetHour || _hour < SunriseHour - TransitionHours) {
    _darkness = 0.75;
}

// Sunrise transition
else if (_hour < SunriseHour) {

    var _progress = (
        _hour - (SunriseHour - TransitionHours)
    ) / TransitionHours;

    _darkness = lerp(0.75, 0, _progress);
}

// Sunset transition
else if (_hour >= SunsetHour - TransitionHours) {

    var _progress = (
        _hour - (SunsetHour - TransitionHours)
    ) / TransitionHours;

    _darkness = lerp(0, 0.75, _progress);
}

Darkness = clamp(_darkness, 0, 0.75);


// ==========================================
// LIGHTING COLORS
// ==========================================

R = lerp(DayColor[0], NightColor[0], Darkness);
G = lerp(DayColor[1], NightColor[1], Darkness);
B = lerp(DayColor[2], NightColor[2], Darkness);


// ==========================================
// TORCH ACTIVATION
// ==========================================

global.TorchOn = (
    _hour >= SunsetHour ||
    _hour < SunriseHour - TransitionHours
);


// ==========================================
// UPDATE TORCH SPRITES
// ==========================================

with (oTorch) {
    sprite_index = global.TorchOn ? sTorchOn : sTorchOff;
}
