// ==========================================
// GUI POSITIONING
// ==========================================

var xDiff = oCamera.camWidth / 2;
var yDiff = oCamera.camHeight / 2;

var PlayerX;
var PlayerY;

var ChestX;
var ChestY;

var StoreX;
var StoreY;

if (StoreOpen && instance_exists(CurrentStore))
{
    // Player inventory: left
    PlayerX = xDiff - 100;
    PlayerY = yDiff - 45;

    // Store inventory: right
    StoreX = xDiff + 20;
    StoreY = yDiff - 45;
}
else if (ChestOpen && instance_exists(CurrentChest))
{
    PlayerX = xDiff - 100;
    PlayerY = yDiff - 45;

    ChestX = xDiff + 20;
    ChestY = yDiff - 45;
}
else
{
    PlayerX = xDiff - 40;
    PlayerY = yDiff - 45;
}

var MouseX = device_mouse_x_to_gui(0);
var MouseY = device_mouse_y_to_gui(0);



if (InvOpen)
{
	// ==========================================
	// INVENTORY BACKGROUNDS
	// ==========================================

	if (StoreOpen && instance_exists(CurrentStore))
	{
	    // Player inventory
	    draw_sprite_stretched(
	        sGUIBG, 0,
	        PlayerX - 14, PlayerY - 35,
	        112, 137
	    );

	    // Store inventory
	    draw_sprite_stretched(
	        sGUIBG, 0,
	        StoreX - 14, StoreY - 35,
	        112, 137
	    );
	}
	else if (ChestOpen && instance_exists(CurrentChest))
	{
	    draw_sprite_stretched(
	        sGUIBG, 0,
	        PlayerX - 14, PlayerY - 35,
	        112, 137
	    );

	    draw_sprite_stretched(
	        sGUIBG, 0,
	        ChestX - 14, ChestY - 35,
	        112, 137
	    );
	}
	else
	{
	    draw_sprite_stretched(
	        sGUIBG, 0,
	        PlayerX - 14, PlayerY - 35,
	        112, 137
	    );
	}


	// ==========================================
	// GUI TITLES
	// ==========================================

	draw_set_font(global.FontDialogue);
	draw_set_color(c_black);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	draw_text(PlayerX + 42, PlayerY - 24, "INVENTORY");

	if (StoreOpen && instance_exists(CurrentStore))
	{
	    draw_text(StoreX + 42, StoreY - 24, "SARI-SARI STORE");
	}
	else if (ChestOpen && instance_exists(CurrentChest))
	{
	    draw_text(ChestX + 42, ChestY - 24, "CHEST");
	}

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	

	// ==========================================
	// STORE ITEMS
	// ==========================================

	if (StoreOpen && instance_exists(CurrentStore))
	{
	    var Items = CurrentStore.StoreItems;

	    for (var i = 0; i < array_length(Items); i++)
	    {
	        var xx = StoreX + (i mod InvWidth) * 21;
	        var yy = StoreY + (i div InvWidth) * 21;

	        var Item = Items[i][0];
	        var Price = Items[i][1];

	        // Draw slot
	        draw_sprite(sInventorySlot, 0, xx, yy);

	        // Draw item
	        draw_sprite(Item.Sprite, 0, xx, yy);

	        // Mouse hover
	        var Hover = point_in_rectangle(
	            MouseX, MouseY,
	            xx - 9, yy - 9,
	            xx + 9, yy + 9
	        );

	        if (Hover)
	        {
	            draw_sprite(sSlotSelect, 0, xx, yy);

	            if (mouse_check_button_pressed(mb_left))
	            {
	                if (global.Coins >= Price)
	                {
	                    if (InventoryHasRoom(Inv, Item))
	                    {
	                        InventoryAdd(Inv, Item, 1);
	                        global.Coins -= Price;

	                        show_debug_message("Purchased: " + string(Item.Name));
	                    }
	                    else
	                    {
	                        show_debug_message("Inventory full!");
	                    }
	                }
	                else
	                {
	                    show_debug_message("Not enough coins!");
	                }
	            }
	        }

	        // Price
	        draw_set_color(c_black);
	        draw_set_halign(fa_center);
	        draw_text_transformed(
	            xx, yy + 8,
	            string(Price),
	            0.5, 0.5, 0
	        );

	        draw_set_halign(fa_left);
	        draw_set_color(c_white);
	    }

	    // Coins
	    draw_set_color(c_black);
	    draw_text(
	        StoreX - 5,
	        StoreY + 91,
	        "Coins: " + string(global.Coins)
	    );

	    draw_set_color(c_white);
	}
    // ==========================================
    // PLAYER INVENTORY
    // ==========================================

    for (var i = 0; i < array_length(Inv); i++)
    {
		var xx = PlayerX + (i mod InvWidth) * 21;
		var yy = PlayerY + (i div InvWidth) * 21;

        // Hotbar separation
        if (i >= InvWidth)
        {
            yy += 1;
        }

        // Draw slot
        draw_sprite(sInventorySlot, 0, xx, yy);

        // Draw item
        if (Inv[i] != -1)
        {
            var Sprite = Inv[i][0].Sprite;

            draw_sprite(Sprite, 0, xx, yy);

            // Amount
            if (Inv[i][1] > 1)
            {
                draw_set_color(c_black);
                draw_set_halign(fa_right);
                draw_text_transformed(xx + 8, yy, Inv[i][1], .5, .5, 0);

                draw_set_halign(fa_left);
                draw_set_color(c_white);
            }
        }

        // Hover
        if (point_in_rectangle(MouseX, MouseY, xx-9, yy-9, xx+9, yy+9))
		{
		    draw_sprite(sSlotSelect, 0, xx, yy);

		    if (mouse_check_button_pressed(mb_left) && !StoreOpen)
		    {
		        InvStartDrag(Inv, i);
		    }

		    if (mouse_check_button_released(mb_left) && !StoreOpen)
		    {
		        InvEndDrag(Inv, i);
		    }
		}
 
    }


    // ==========================================
    // CHEST INVENTORY
    // ==========================================

    if (ChestOpen && instance_exists(CurrentChest))
	{
	
        var ChestWidth = CurrentChest.ChestWidth;
        var ChestInv = CurrentChest.ChestInv;

		
        for (var i = 0; i < array_length(ChestInv); i++)
        {
            var xx = ChestX + (i mod ChestWidth) * 21;
            var yy = ChestY + (i div ChestWidth) * 21;

            // Draw slot
            draw_sprite(sInventorySlot, 0, xx, yy);

            // Draw item
            if (ChestInv[i] != -1)
            {
                var Sprite = ChestInv[i][0].Sprite;

                draw_sprite(Sprite, 0, xx, yy);

                // Amount
                if (ChestInv[i][1] > 1)
                {
                    draw_set_color(c_black);
                    draw_set_halign(fa_right);
                    draw_text_transformed(xx + 8, yy, ChestInv[i][1], .5, .5, 0);

                    draw_set_halign(fa_left);
                    draw_set_color(c_white);
                }
            }

            // Hover
            if (point_in_rectangle(MouseX, MouseY, xx-9, yy-9, xx+9, yy+9))
            {
                draw_sprite(sSlotSelect, 0, xx, yy);

                // Start dragging from chest
                if (mouse_check_button_pressed(mb_left))
                {
                    InvStartDrag(ChestInv, i);
                }

                // Drop into chest
                if (mouse_check_button_released(mb_left))
                {
                    InvEndDrag(ChestInv, i);
                }
            }
        }
    }

    // Draw dragged item after both inventories
    ShowItemDrag();

}
else
{	
	// ==========================================
	// HOTBAR BACKGROUND
	// ==========================================

	draw_sprite_stretched(
	    sGUIBG, 0,
	    xDiff - 55, yDiff + 104,
	    108, 26
	);
    // ==========================================
    // HOTBAR
    // ==========================================

    for (var i = 0; i < InvWidth; i++)
    {
        var xx = xDiff - 43 + i * 21;
        var yy = yDiff + 117;

        draw_sprite(sInventorySlot, 0, xx, yy);

        if (Inv[i] != -1)
        {
            var Sprite = Inv[i][0].Sprite;

            draw_sprite(Sprite, 0, xx, yy);

            if (Inv[i][1] > 1)
            {
                draw_set_color(c_black);
                draw_set_halign(fa_right);
                draw_text_transformed(xx + 8, yy, Inv[i][1], .5, .5, 0);

                draw_set_halign(fa_left);
                draw_set_color(c_white);
            }
        }

        if (i == HotbarSelect)
        {
            draw_sprite(sSlotSelect, 0, xx, yy);
        }
    }
}

// use items
if instance_exists(oPlot) {
	if mouse_check_button_pressed(mb_left) && !InvOpen && !StoreOpen {
	
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
			
				if (NP != noone) {

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