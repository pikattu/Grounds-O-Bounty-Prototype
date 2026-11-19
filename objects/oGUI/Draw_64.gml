// Center of the screen
xDiff = oCamera.camWidth / 2;
yDiff = oCamera.camHeight / 2;

if InvOpen {
	// Draw Individual Inventory Slots
	for (var i = 0; i < array_length(Inv); i++) {

	    var xx = xDiff - 200 + (i mod InvWidth) * 21; // padding
	    var yy = yDiff - 5 + (i div InvWidth) * 21;
		
		// hotbar separation
		
		if i > InvWidth-1 { yy = yy + 1;}

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
	
	
} else {
	// hotbar
	for (var i = 0; i < InvWidth; i++) {
		var xx =xDiff - 30 + (i mod InvWidth) * 21;
		var yy =yDiff + 117;
		
		draw_sprite(sInventorySlot,0,xx,yy);

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
		if i == HotbarSelect {
			draw_sprite(sSlotSelect,0,xx,yy)
		}
	}
	
} 

// use items
if instance_exists(oPlot) {
	if mouse_check_button_pressed(mb_left) and !InvOpen {
	
		// Harvest
		var NC = instance_nearest(mouse_x, mouse_y, oPlot); // NC ? nearest crop
		if NC.Crop != undefined {
			if point_in_rectangle(mouse_x,mouse_y,NC.x-8, NC.y-8,NC.x+8, NC.y+8) and point_distance(oPlayer.x,oPlayer.y,NC.x, NC.y) < 32 {
				if NC.Tick >= NC.Crop.GrowTime{
						
					var Item = NC.Crop.Drop[0];
					var Amount = NC.Crop.Drop[1];
				
					repeat(Amount){
						var Drop= instance_create_depth(NC.x,NC.y,0,oItem);
						Drop.Item = Item;
					}
						
						
					NC.Crop = undefined;
					NC.Tick = 0;
					NC.isFertilized = false;
					
				}
			}
		}
	
		// Use item
		if Inv[HotbarSelect] != -1 {
	
			switch(Inv[HotbarSelect][0].ItemType){
			
				case "Crop":
				break;
			
				case "Tool":
			
					var xx = round(mouse_x/16)*16;
					var yy = round(mouse_y/16)*16;
				
					if !collision_rectangle(xx-2, yy-2, xx+2,yy+2, oPlot,0,1) {
						instance_create_depth(xx,yy,0,oPlot);
					}
				
			
			
				break;
			
				case "Seed":

			
					var NP = instance_nearest(mouse_x, mouse_y, oPlot);
					if point_in_rectangle(mouse_x,mouse_y,NP.x-8, NP.y-8,NP.x+8, NP.y+8) and point_distance(oPlayer.x,oPlayer.y,NP.x, NP.y) < 32 {
					
					 // NP = nearest plot
					
						var Crop = undefined;
					
						switch(Inv[HotbarSelect][0]) {
						
							case global.ItemCornSeeds:
								Crop = global.CropCorn;
							break;
						
						
							case global.ItemPineappleSeeds:
								Crop = global.CropPineapple;
							break;
						
							case global.ItemRiceSeeds:
								Crop = global.CropRice;
							break;
						
							case global.ItemStrawberrySeeds:
								Crop = global.CropStrawberry;
							break;
						}
						NP.Crop = Crop;
						InventoryRemove(Inv, Inv[HotbarSelect][0], 1);
					} 
				
				break;
			
				case "Fertilizer":
			
				var NP = instance_nearest(mouse_x, mouse_y, oPlot);
					if point_in_rectangle(mouse_x,mouse_y,NP.x-8, NP.y-8,NP.x+8, NP.y+8) and point_distance(oPlayer.x,oPlayer.y,NP.x, NP.y) < 32 {
				
				
						NP.isFertilized = true;
						InventoryRemove(Inv, Inv[HotbarSelect][0], 1);
					}
					
				break;
	
			}
		}		
	
	}
}

// Draw dialogue

if (instance_exists(oTextBox)) {
    var spaceNext = keyboard_check_pressed(vk_space);

    // Handle pages
    if (spaceNext) {
        if (oTextBox.CurrentChar >= string_length(oTextBox.Text[oTextBox.Page])) {
            if (oTextBox.Page < array_length(oTextBox.Text) - 1) {
                oTextBox.Page++;
                oTextBox.CurrentChar = 0;
                oTextBox.String = "";
            } else {
                instance_destroy(oTextBox);
            }
        } else {
            oTextBox.CurrentChar = string_length(oTextBox.Text[oTextBox.Page]);
        }
    }

	// Handle Typewritter effect
	
	if instance_exists(oTextBox) {
		
		if oTextBox.CurrentChar < string_length(oTextBox.Text[oTextBox.Page]) {
		oTextBox.CurrentChar += oTextBox.TextSpeed * global.DT;
		}
	}
	
	
	
	// Reset String and Add new string +1 Character each update
	if instance_exists(oTextBox) {
		
		if (string_length(oTextBox.String) < string_length(oTextBox.Text[oTextBox.Page])) {
			for (var i = 1; i < oTextBox.CurrentChar + 1; i++) {
			    var Char = string_copy(oTextBox.Text[oTextBox.Page], 1, oTextBox.CurrentChar);
			    oTextBox.String = string(Char);
			}
		}
	}

	// Draw TextBox
	
	if instance_exists(oTextBox) {
		
		oTextBox.Anim +=1 * global.DT;
		draw_sprite_stretched(sTextBox,oTextBox.Anim,oTextBox.TBX,oTextBox.TBY, oTextBox.TBoxWidth,oTextBox.TBoxHeight);
		draw_set_font(global.FontDialogue);
		draw_text_ext(oTextBox.TBX+oTextBox.Border,oTextBox.TBY+oTextBox.Border,oTextBox.String,oTextBox.LinePadding,oTextBox.Width);
		
		}
	}