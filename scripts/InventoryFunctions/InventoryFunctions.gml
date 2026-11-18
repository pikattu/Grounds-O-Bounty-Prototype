
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

function ShowItemDrag() {

    if InvFrom != undefined {
        var Sprite = InvFrom[SlotFrom][0].Sprite;

        draw_sprite(
            Sprite,
            0,
            device_mouse_x_to_gui(0),
            device_mouse_y_to_gui(0)
        );
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