
/// scrGame_Init - Time Initialization

global.Day = 1;

// Starting time: 6 AM
global.Time = 6 * 3600;

global.TimeOfDay = global.Time / 86400;

// Starting at 6 AM means torches are off
global.TorchOn = false;

// Current crop day
global.CropTick = global.Day;


