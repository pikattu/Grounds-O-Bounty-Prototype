LightingSurface = -1;

// ==========================================
// TIME SETTINGS
// ==========================================

Time = 0;
TimeOfDay = 0;

DayNightSpeed = 0.001;
ColorChange = 2;

DayColor = [255, 255, 255];
NightColor = [85, 100, 145];

R = DayColor[0];
G = DayColor[1];
B = DayColor[2];

// ==========================================
// DAY COUNTER
// ==========================================

if (!variable_global_exists("Day")) {
    global.Day = 1;
}

DayCycle = floor((Time * DayNightSpeed + pi) / (2 * pi));

// ==========================================
// LIGHTING
// ==========================================

LightingSurface = surface_create(room_width, room_height);