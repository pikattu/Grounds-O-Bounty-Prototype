/// oTimeOfDay - Step Event

// Stop if the day/night controller has not initialized yet
if (!variable_global_exists("GameTimeScale")) {
    exit;
}

var _deltaSeconds = delta_time / 1000000;

// Convert real time into in-game seconds
var _gameSeconds = _deltaSeconds * global.GameTimeScale;


// ==========================================
// DAILY CROP WATER CHECK
// ==========================================

// Detect when a new day begins
var _currentDay = floor(global.Time / 86400);

if (_currentDay > global.CropTick) {

    global.CropTick = _currentDay;

    with (oPlot) {

        if (Crop != undefined && !IsFullyGrown && !IsDead) {

            if (IsWatered) {
                DryDays = 0;
            }
            else {
                DryDays++;
            }

            // Die after 2 consecutive dry days
            if (DryDays >= 2) {
                IsDead = true;
            }

            // Reset water for the next day
            IsWatered = false;
        }
    }
}


// ==========================================
// UPDATE ALL PLANTED CROPS
// ==========================================

with (oPlot) {

   if (Crop != undefined && !IsFullyGrown && !IsDead && IsWatered) {

        // Normal growth
        var _growthSpeed = 1;

        // Fertilized crops grow faster
        if (isFertilized) {
            _growthSpeed = FertilizerSpeed;
        }

        // Increase crop growth timer
        Tick += _gameSeconds * _growthSpeed;

        // Prevent timer from exceeding total growth time
        Tick = min(Tick, Crop.GrowTime);

        // Calculate current growth stage
        var _stageTime = Crop.GrowTime / GrowthStages;

        if (_stageTime > 0) {
            Stage = clamp(
                floor(Tick / _stageTime),
                0,
                GrowthStages - 1
            );
        }

        // Check if crop is fully grown
        IsFullyGrown = (Tick >= Crop.GrowTime);
    }
}