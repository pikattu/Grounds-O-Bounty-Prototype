// Center of the screen
xDiff = oCamera.camWidth / 2;
yDiff = oCamera.camHeight / 2;

if InvOpen {
	// Draw Individual Inventory Slots
	for (var i = 0; i < array_length(Inv); i++) {

	    var xx = xDiff - 200 + (i mod InvWidth) * 21; // padding
	    var yy = yDiff - 5 + (i div InvWidth) * 21;

	    draw_sprite_ext(
	        sInventorySlot,
	        0,
	        xx, yy,
	        1, 1, 0, c_white, 1
	    );
		// Draw Item in Slot
		if Inv[i] != -1 {
			var Sprite = Inv[i][0].Sprite;
			draw_sprite(Sprite,0,xx,yy);
		
			// Draw Amount of Item
			if Inv[i][1] >1 {
				draw_set_color(c_black);
				draw_set_halign(fa_right);
				draw_text_transformed(xx+8,yy,Inv[i][1], .5,.5,0); // size size rotation
				draw_set_halign(fa_left);
				draw_set_color(c_white);
			}
		}
		// Draw Hover
		if point_in_rectangle(device_mouse_x_to_gui(0),device_mouse_y_to_gui(0),xx-9,yy-9,xx+9,yy+9) {
			draw_sprite(sSlotSelect,0,xx,yy);
			
			// Start Item Drag
			if mouse_check_button_pressed(mb_left) {
				InvStartDrag(Inv, i);
			}
			// End Item Drag
			if mouse_check_button_released(mb_left) {
				InvEndDrag(Inv, i);
			}
		}
		
	}
	
	// Show Drag
	ShowItemDrag();
	
	
}



