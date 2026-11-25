/// oTimeOfDay - Create Event

persistent = true;

CropGrowthInterval = 0.5 * 60; // 10 in-game minutes

if (!variable_global_exists("CropTick")) {
    global.CropTick = 0;
}