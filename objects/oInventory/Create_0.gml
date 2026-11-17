ItemInformation();
CropInformation();
// Inv Size
InvWidth = 5;
InvHeight = 5;

Inv = array_create(InvWidth*InvHeight, -1);

// Open Inventory
InvOpen = false;
HotbarSelect = 0;

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
InventoryAdd(Inv,global.ItemPineappleSeeds,4);
InventoryAdd(Inv,global.ItemHoe,1);
InventoryAdd(Inv,global.ItemCornSeeds,4);
InventoryAdd(Inv,global.ItemStrawberrySeeds,4);
InventoryAdd(Inv,global.ItemRiceSeeds,4);