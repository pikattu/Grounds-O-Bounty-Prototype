event_inherited();

// MAIN INVENTORY STORAGE
global.inventory_slots = 24;
global.inventory = array_create(global.inventory_slots, -1);

// HOTBAR REFERENCES
global.hotbar_slots = 8;
global.hotbar = array_create(global.hotbar_slots, -1);

// Link hotbar to first 8 inventory slots
for (var i = 0; i < global.hotbar_slots; i++)
{
    global.hotbar[i] = i;
}

// INVENTORY WINDOW
global.inventory_open = false;

// INVENTORY UI
book_sprite = sInventoryBook;

// STARTING ITEMS
InventoryAdd(global.inventory, global.ItemCorn, 4);
InventoryAdd(global.inventory, global.ItemHoe, 1);
InventoryAdd(global.inventory, global.ItemCornSeeds, 1);
InventoryAdd(global.inventory, global.ItemPineappleSeeds, 1);
InventoryAdd(global.inventory, global.ItemRiceSeeds, 1);
InventoryAdd(global.inventory, global.ItemStrawberrySeeds, 1);
InventoryAdd(global.inventory, global.ItemPineapple, 4);
InventoryAdd(global.inventory, global.ItemRice, 4);
InventoryAdd(global.inventory, global.ItemStrawberry, 4);