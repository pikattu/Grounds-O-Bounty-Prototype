
function InteractWithPlot(_plot, _inventory, _slot) {

    // Validate plot
    if (!instance_exists(_plot)) {
        return;
    }

    // Validate inventory slot
    if (_slot < 0 || _slot >= array_length(_inventory)) {
        return;
    }


    // ==========================================
    // PRIORITY 1: HARVEST MATURE CROP
    // ==========================================

    if (_plot.Crop != undefined) {

        // Only mature crops can be harvested
        if (!_plot.IsFullyGrown) {
            return;
        }

        var _drop = _plot.Crop.Drop;
        var _item = _drop[0];
        var _quantity = _drop[1];

        // Make sure inventory has room
        if (!InventoryHasRoom(_inventory, _item)) {
            show_debug_message("Inventory is full!");
            return;
        }

        // Add harvested crop
        InventoryAdd(_inventory, _item, _quantity);

        // Reset plot
        _plot.Crop = undefined;
        _plot.Tick = 0;
        _plot.Stage = 0;
        _plot.SubImage = 0;
        _plot.IsFullyGrown = false;
        _plot.isFertilized = false;

        return;
    }


    // ==========================================
    // PRIORITY 2: PLANT SEED
    // ==========================================

    // Do not plant on a dead plot
    if (_plot.IsDead) {
        return;
    }

    var _selectedSlot = _inventory[_slot];

    if (_selectedSlot == -1) {
        return;
    }

    var _heldItem = _selectedSlot[0];

    // Only seeds can be planted
    if (_heldItem.ItemType != "Seed") {
        return;
    }

    // Identify crop
    var _crop = CropFromSeed(_heldItem);

    if (_crop == undefined) {
        return;
    }


    // ==========================================
    // PLANT NEW CROP
    // ==========================================

    _plot.Crop = _crop;

    // Reset crop growth for newly planted crop
    _plot.Tick = 0;
    _plot.Stage = 0;
    _plot.SubImage = 0;
    _plot.IsFullyGrown = false;
    _plot.isFertilized = false;

    // Consume one seed
    InvRemove(_inventory, _heldItem);
}
