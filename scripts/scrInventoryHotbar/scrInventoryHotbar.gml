function scrInventoryHotbar(){
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
}

