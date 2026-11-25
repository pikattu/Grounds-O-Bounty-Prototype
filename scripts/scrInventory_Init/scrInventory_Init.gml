function scrInventory_Init(){
	// Inv Size
	InvWidth = 5;
	InvHeight = 5;

	Inv = array_create(InvWidth*InvHeight, -1);

	// Open Inventory
	InvOpen = false;
	HotbarSelect = 0;

	// INVENTORY UI
	book_sprite = sInventoryBook;

	// STARTING ITEMS
	InventoryAdd(Inv,global.ItemCorn,20);
	InventoryAdd(Inv,global.ItemPineappleSeeds,20);
	InventoryAdd(Inv,global.ItemHoe,1);
	InventoryAdd(Inv,global.ItemCornSeeds,20);
	InventoryAdd(Inv,global.ItemStrawberrySeeds,20);
	InventoryAdd(Inv,global.ItemRiceSeeds,20);
	InventoryAdd(Inv,global.ItemFertilizer,20);

	// Drag Variables
	InvFrom = undefined;
	InvTo = undefined;

	SlotFrom = undefined;
	SlotTo = undefined;

	// Chest
	ChestOpen = false;
	CurrentChest = noone;

	// Store
	StoreOpen = false;
	CurrentStore = noone;
}