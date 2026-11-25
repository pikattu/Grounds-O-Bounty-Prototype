function scrInventoryInteractions(){
	
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





}