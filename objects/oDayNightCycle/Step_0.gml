// ==========================================
// LIGHTING SURFACE
// ==========================================

if (!surface_exists(LightingSurface)) {
    LightingSurface = surface_create(room_width, room_height);
}

// ==========================================
// DAY COUNTER
// ==========================================

// UPDATE TIME
Time += global.DT;

// DAY COUNTER
var _currentCycle = floor((Time * DayNightSpeed + pi) / (2 * pi));

if (_currentCycle > DayCycle) {
    global.Day += _currentCycle - DayCycle;
    DayCycle = _currentCycle;
}

// DAY/NIGHT
TimeOfDay = sin(Time * DayNightSpeed);
TimeOfDay = clamp(TimeOfDay, 0, 0.8);

// TORCH
if (TimeOfDay > 0.3) {
    with (oTorch) {
        sprite_index = sTorchOn;
    }
}
else {
    with (oTorch) {
        sprite_index = sTorchOff;
    }
}


// ==========================================
// TORCH SPRITE SWITCH
// ==========================================

if (TimeOfDay > 0.3) {
    with (oTorch) {
        sprite_index = sTorchOn;
    }
}
else {
    with (oTorch) {
        sprite_index = sTorchOff;
    }
}