function AudioBG(_sound)
{
    // Don't restart the same music
    // if it's already playing
    if (global.MusicAsset == _sound)
    {
        if (audio_is_playing(global.MusicID))
        {
            return;
        }
    }

    // Stop previous background music
    if (global.MusicID != -1)
    {
        audio_stop_sound(global.MusicID);
    }

    // Play new background music
    global.MusicAsset = _sound;

    global.MusicID = audio_play_sound(
        _sound,
        100,
        true,
        0.2 // volume
    );
}