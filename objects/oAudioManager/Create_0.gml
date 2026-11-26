// ==========================================
// AUDIO MANAGER INITIALIZATION
// ==========================================

// Prevent duplicate audio managers
if (instance_number(oAudioManager) > 1)
{
    instance_destroy();
    exit;
}

// Global music tracking
global.MusicID = -1;
global.MusicAsset = -1;

// Start main menu music
AudioBG(musMainMenu);