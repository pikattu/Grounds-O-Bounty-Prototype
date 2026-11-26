
/// oTimeOfDay - Create Event

persistent = true;

// Crop growth interval configuration
CropGrowthInterval = 0.5 * 60;

// Daily crop tracking
if (!variable_global_exists("CropTick")) {
    global.CropTick = 1;
}
