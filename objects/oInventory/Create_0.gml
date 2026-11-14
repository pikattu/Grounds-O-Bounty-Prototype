ItemInformation();
// Inv Size
InvWidth = 6;
InvHeight = 5;

Inv = array_create(InvWidth*InvHeight, -1);

// Open Inventory
InvOpen = false;

// Drag Item Variables

	// To chests
	InvFrom = undefined;
	InvTo = undefined; 
	
	// Within Inventory
	SlotFrom = undefined;
	SlotTo = undefined;

// Gui Init
display_set_gui_size(oCamera.camWidth,oCamera.camHeight);

// INVENTORY UI
book_sprite = sInventoryBook;

// STARTING ITEMS
InventoryAdd(Inv,global.ItemCorn,4);