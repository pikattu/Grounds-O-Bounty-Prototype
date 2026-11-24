/// oTimeOfDay - Step Event

// Stop if the day/night controller has not initialized yet
if (!variable_global_exists("GameTimeScale")) {
    exit;
}

var _deltaSeconds = delta_time / 1000000;

// Convert real time into in-game seconds
var _gameSeconds = _deltaSeconds * global.GameTimeScale;

// ==========================================
// UPDATE ALL PLANTED CROPS
// ==========================================

with (oPlot) {

    if (Crop != undefined && !IsFullyGrown) {

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