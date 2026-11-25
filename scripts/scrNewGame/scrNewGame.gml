
/// scr_NewGame

// ==========================================
// GAME INITIALIZATION
// ==========================================

// Save version
global.save_version = 1;

// New game flag
global.is_new_game = true;


/// scr_NewGame - Time Initialization

global.Day = 1;

// Starting time: 6 AM
global.Time = 6 * 3600;

global.TimeOfDay = global.Time / 86400;

global.TorchOn = true;

global.CropTick = 0;

// ==========================================
// PLAYER DATA
// ==========================================

// Initialize your player data here
// Example:
// global.Money = 100;

// ==========================================
// GO TO GAME
// ==========================================

room_goto(rmGame);




