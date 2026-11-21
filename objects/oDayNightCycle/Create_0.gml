
/// oDayNightCycle - Create Event

persistent = true;

// ==========================================
// CONFIGURATION
// ==========================================

DayLengthMinutes = 10;

StartingHour = 6;

SunriseHour = 6;
SunsetHour = 18;

TransitionHours = 2;

// ==========================================
// TIME SCALE
// ==========================================

DayLengthSeconds = DayLengthMinutes * 60;
TimeScale = 86400 / DayLengthSeconds;

global.GameTimeScale = TimeScale;

// ==========================================
// LIGHTING
// ==========================================

LightingSurface = -1;

DayColor = [255, 255, 255];
NightColor = [85, 100, 145];

R = 255;
G = 255;
B = 255;

Darkness = 0;

// ==========================================
// INITIALIZE GLOBAL DATA
// ==========================================

if (!variable_global_exists("Day")) {
    global.Day = 1;
}

if (!variable_global_exists("Time")) {
    global.Time = StartingHour * 3600;
}

if (!variable_global_exists("TimeOfDay")) {
    global.TimeOfDay = global.Time / 86400;
}

if (!variable_global_exists("TorchOn")) {
    global.TorchOn = false;
}

// ==========================================
// INITIAL LIGHTING
// ==========================================

var _hour = global.Time / 3600;

global.TorchOn = (_hour >= SunsetHour || _hour < SunriseHour - TransitionHours);

if (_hour >= SunsetHour || _hour < SunriseHour - TransitionHours) {
    Darkness = 0.75;
}
else if (_hour < SunriseHour) {
    var _progress = (_hour - (SunriseHour - TransitionHours)) / TransitionHours;
    Darkness = lerp(0.75, 0, _progress);
}
else if (_hour >= SunsetHour - TransitionHours) {
    var _progress = (_hour - (SunsetHour - TransitionHours)) / TransitionHours;
    Darkness = lerp(0, 0.75, _progress);
}

Darkness = clamp(Darkness, 0, 0.75);

R = lerp(DayColor[0], NightColor[0], Darkness);
G = lerp(DayColor[1], NightColor[1], Darkness);
B = lerp(DayColor[2], NightColor[2], Darkness);
