// ==========================================
// CHEST INTERACTION (E)
// ==========================================

if (keyboard_check_pressed(ord("E")))
{
    // Close chest
    if (ChestOpen)
    {
        if (instance_exists(CurrentChest))
        {
            CurrentChest.sprite_index = sChestClose;
        }

        ChestOpen = false;
        CurrentChest = noone;
        InvOpen = false;

        // Reset drag
        InvFrom = undefined;
        SlotFrom = undefined;
        InvTo = undefined;
        SlotTo = undefined;
    }
    // Open chest
    else if (!InvOpen)
    {
        var Chest = instance_nearest(oPlayer.x, oPlayer.y, oChest);

        if (Chest != noone && point_distance(oPlayer.x, oPlayer.y, Chest.x, Chest.y) <= 32)
        {
            CurrentChest = Chest;
            CurrentChest.sprite_index = sChestOpen;

            ChestOpen = true;
            InvOpen = true;
        }
    }
}


// ==========================================
// NORMAL INVENTORY (TAB)
// ==========================================

if (keyboard_check_pressed(vk_tab))
{
    if (ChestOpen)
    {
        if (instance_exists(CurrentChest))
        {
            CurrentChest.sprite_index = sChestClose;
        }

        ChestOpen = false;
        CurrentChest = noone;
    }

    InvOpen = !InvOpen;

    // Reset drag
    InvFrom = undefined;
    SlotFrom = undefined;
    InvTo = undefined;
    SlotTo = undefined;
}


// ==========================================
// HOTBAR SELECTION
// ==========================================

if (!InvOpen)
{
    if (keyboard_check_pressed(ord("1"))) HotbarSelect = 0;
    else if (keyboard_check_pressed(ord("2"))) HotbarSelect = 1;
    else if (keyboard_check_pressed(ord("3"))) HotbarSelect = 2;
    else if (keyboard_check_pressed(ord("4"))) HotbarSelect = 3;
    else if (keyboard_check_pressed(ord("5"))) HotbarSelect = 4;

    // Scroll
    if (mouse_wheel_down())
    {
        if (HotbarSelect > 0)
            HotbarSelect--;
        else
            HotbarSelect = InvWidth - 1;
    }
    else if (mouse_wheel_up())
    {
        if (HotbarSelect < InvWidth - 1)
            HotbarSelect++;
        else
            HotbarSelect = 0;
    }
}