ItemInformation();
CropInformation();
// Inv Size
InvWidth = 5;
InvHeight = 5;

Inv = array_create(InvWidth*InvHeight, -1);

// Open Inventory
InvOpen = false;
HotbarSelect = 0;



// Gui Init
display_set_gui_size(oCamera.camWidth,oCamera.camHeight);

// INVENTORY UI
book_sprite = sInventoryBook;

// STARTING ITEMS
InventoryAdd(Inv,global.ItemCorn,4);
InventoryAdd(Inv,global.ItemPineappleSeeds,1);
InventoryAdd(Inv,global.ItemHoe,1);
InventoryAdd(Inv,global.ItemCornSeeds,4);
InventoryAdd(Inv,global.ItemStrawberrySeeds,4);
InventoryAdd(Inv,global.ItemRiceSeeds,4);
InventoryAdd(Inv,global.ItemFertilizer,4);

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

