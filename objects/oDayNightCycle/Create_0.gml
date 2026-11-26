
/// oDayNightCycle - Create Event

persistent = true;

// ==========================================
// CONFIGURATION
// ==========================================

// CHANGE THIS TO ADJUST THE LENGTH OF ONE GAME DAY
DayLengthMinutes = 5;

// Starting time
StartingHour = 6;

// Sunrise and sunset
SunriseHour = 6;
SunsetHour = 18;

// Duration of sunrise and sunset transitions
TransitionHours = 2;


// ==========================================
// CENTRAL TIME CONFIGURATION
// ==========================================

// One in-game day always contains 86,400 seconds
DayLengthSeconds = DayLengthMinutes * 60;

// How many in-game seconds pass per real-world second
TimeScale = 86400 / DayLengthSeconds;

// Shared time scale for ALL time-based systems
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

if (!variable_global_exists("CropTick")) {
    global.CropTick = global.Day;
}


// ==========================================
// INITIAL LIGHTING
// ==========================================

var _hour = global.Time / 3600;

global.TorchOn = (
    _hour >= SunsetHour ||
    _hour < SunriseHour - TransitionHours
);

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
