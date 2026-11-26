
function scrInventoryInteractions(){

    // ==========================================
    // CHEST INTERACTION (E)
    // ==========================================

    if (keyboard_check_pressed(ord("E")))
    {
        // Close chest if already open
        if (ChestOpen)
        {
            if (instance_exists(CurrentChest))
            {
                CurrentChest.sprite_index = sChestClose;
            }

            AudioSFX(sfxChestStore);

            ChestOpen = false;
            CurrentChest = noone;
            InvOpen = false;

            // Reset drag
            InvFrom = undefined;
            SlotFrom = undefined;
            InvTo = undefined;
            SlotTo = undefined;
        }
        // Close store if already open
        else if (StoreOpen)
        {
            AudioSFX(sfxChestStore);

            StoreOpen = false;
            InvOpen = false;
            CurrentStore = noone;

            // Reset drag
            InvFrom = undefined;
            SlotFrom = undefined;
            InvTo = undefined;
            SlotTo = undefined;
        }
        // Open nearby chest or store if inventory is closed
        else if (!InvOpen)
        {
            // Check nearby chest first
            var Chest = instance_nearest(oPlayer.x, oPlayer.y, oChest);

            if (Chest != noone && point_distance(oPlayer.x, oPlayer.y, Chest.x, Chest.y) <= 32)
            {
                CurrentChest = Chest;
                CurrentChest.sprite_index = sChestOpen;

                ChestOpen = true;
                InvOpen = true;

                AudioSFX(sfxChestStore);
            }
            else
            {
                // Check nearby store
                var Store = instance_nearest(oPlayer.x, oPlayer.y, oStore);

                if (Store != noone && point_distance(oPlayer.x, oPlayer.y, Store.x, Store.y) <= Store.InteractDistance)
                {
                    CurrentStore = Store;
                    StoreOpen = true;
                    InvOpen = true;

                    AudioSFX(sfxChestStore);
                }
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

        if (StoreOpen)
        {
            StoreOpen = false;
            CurrentStore = noone;
        }

        InvOpen = !InvOpen;

        AudioSFX(sfxInteraction);

        // Reset drag
        InvFrom = undefined;
        SlotFrom = undefined;
        InvTo = undefined;
        SlotTo = undefined;
    }

    // ==========================================
    // CLOSE INVENTORY / CHEST / STORE (ESC)
    // ==========================================

    if (keyboard_check_pressed(vk_escape))
    {
        if (ChestOpen || StoreOpen || InvOpen)
        {
            if (ChestOpen && instance_exists(CurrentChest))
            {
                CurrentChest.sprite_index = sChestClose;
                AudioSFX(sfxChestStore);
            }
            else if (StoreOpen)
            {
                AudioSFX(sfxChestStore);
            }
            else
            {
                AudioSFX(sfxInteraction);
            }

            // Close all interfaces
            ChestOpen = false;
            StoreOpen = false;
            InvOpen = false;

            CurrentChest = noone;
            CurrentStore = noone;

            // Reset drag
            InvFrom = undefined;
            SlotFrom = undefined;
            InvTo = undefined;
            SlotTo = undefined;
        }
    }
}
