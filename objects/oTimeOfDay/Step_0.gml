
/// oTimeOfDay - Step Event

// Stop if the day/night controller has not initialized yet
if (!variable_global_exists("GameTimeScale")) {
    exit;
}


// ==========================================
// CALCULATE GAME TIME
// ==========================================

var _deltaSeconds = delta_time / 1000000;
var _gameSeconds = _deltaSeconds * global.GameTimeScale;


// ==========================================
// UPDATE ALL PLANTED CROPS
// ==========================================

with (oPlot) {

    if (Crop != undefined && !IsFullyGrown && !IsDead && IsWatered) {

        // ==========================================
        // GET CROP SPRITE FRAME COUNT
        // ==========================================

        var _sprite = Crop.Sprite;

        if (sprite_exists(_sprite)) {

            var _totalFrames = sprite_get_number(_sprite);
            var _lastFrame = _totalFrames - 1;


            // ==========================================
            // DETERMINE GROWTH SPEED
            // ==========================================

            var _growthSpeed = 1;

            if (isFertilized) {
                _growthSpeed = FertilizerSpeed;
            }


            // ==========================================
            // UPDATE GROWTH TIMER
            // ==========================================

            Tick += _gameSeconds * _growthSpeed;


            // ==========================================
            // CALCULATE GROWTH PROGRESS
            // ==========================================

            var _growTime = Crop.GrowTime;

            if (_growTime > 0) {

                var _progress = clamp(Tick / _growTime, 0, 1);

                // Convert growth progress into sprite frame
                Stage = floor(_progress * _lastFrame);


                // ==========================================
                // CHECK IF FULLY GROWN
                // ==========================================

                if (Tick >= _growTime) {

                    Tick = _growTime;
                    Stage = _lastFrame;
                    IsFullyGrown = true;
                }
            }
        }
    }
}
