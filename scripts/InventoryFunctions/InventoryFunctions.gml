
// Inventory Add
function InvAdd(InvArray, Item) {

    // Check if item already exists
    for (var i = 0; i < array_length(InvArray); i++) {
        if (InvArray[i] != -1) {
            if (InvArray[i][0] == Item) {
                InvArray[i][1]++;
                return;
            }
        }
    }

    // Add new stack
    for (var i = 0; i < array_length(InvArray); i++) {
        if (InvArray[i] == -1) {
            InvArray[i] = [Item, 1];
            return;
        }
    }
}


// Add multiple items
function InventoryAdd(InvArray, Item, Quantity) {
    repeat (Quantity) {
        InvAdd(InvArray, Item);
    }
	return;
}


// Inventory Remove
function InvRemove(InvArray, Item) {

    // Check if item exists
    for (var i = 0; i < array_length(InvArray); i++) {
        if (InvArray[i] != -1) {
            if (InvArray[i][0] == Item) {
				
				if InvArray[i][1] > 1 {
					InvArray[i][1]--;
					return;
					
				} else {
	            // Empty slot if quantity reaches zers
					InvArray[i] = -1;
				}
            }
        }
    }
}


// Remove multiple items
function InventoryRemove(InvArray, Item, Quantity) {
    repeat (Quantity) {
        InvRemove(InvArray, Item);
    }
	return;
}

// DRAG FUNCTION
function InvStartDrag(InvArray, Slot) {
	if InvFrom == undefined and InvArray[Slot] != -1 {
		InvFrom = InvArray;
		SlotFrom = Slot;
	}
	return;
}

function InvEndDrag(InvArray, Slot) {
	if InvFrom != undefined { // if item exists in slot, swap
		
		InvTo = InvArray;
		SlotTo = Slot;
		
		var TempFrom = InvFrom[SlotFrom];
		var TempTo = InvTo[SlotTo];
		
		InvFrom[SlotFrom] = TempTo;
		InvTo[SlotTo] = TempFrom;
		
		// Reset Variables
		InvFrom = undefined;
		SlotFrom = undefined;
		InvTo = undefined;
		SlotTo = undefined;
		
	}
	return;
}

function ShowItemDrag()
{
    if (InvFrom != undefined)
    {
        if (InvFrom[SlotFrom] != -1)
        {
            var Sprite = InvFrom[SlotFrom][0].Sprite;

            draw_sprite(
                Sprite,
                0,
                device_mouse_x_to_gui(0),
                device_mouse_y_to_gui(0)
            );
        }
    }

    return;
}

function InventoryHasRoom(InvArray, Item) {

    // Check if we have space or an existing stack of the item
    for (var i = 0; i < array_length(InvArray); i++) {

        if (InvArray[i] == -1) {
            return true;
        }
        else if (InvArray[i][0] == Item) {
            return true;
        }
    }

    return false;
}


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
        _plot.IsFullyGrown = false;
        _plot.isFertilized = false;

        return;
    }

   // ==========================================
	// PRIORITY 2: PLANT SEED
	// ==========================================

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

	// RESET CROP GROWTH FOR NEWLY PLANTED CROP
	_plot.Tick = 0;
	_plot.Stage = 0;
	_plot.SubImage = 0;
	_plot.IsFullyGrown = false;
	_plot.isFertilized = false;

	// Consume one seed
	InvRemove(_inventory, _heldItem);

	return;
}
