
var scale = global.ui_settings.scale;
var item_scale = global.ui_settings.item_scale;
var quantity_scale = global.ui_settings.quantity_scale;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// Hotbar dimensions
var bar_w = sprite_get_width(sHotBar);
var bar_h = sprite_get_height(sHotBar);

// Position
var bar_x = (gui_w - bar_w * scale) / 2;
var bar_y = gui_h - (bar_h * scale) - bottom_margin;

// Draw hotbar
draw_sprite_ext(
    sHotBar, 0,
    bar_x, bar_y,
    scale, scale,
    0, c_white, 1
);

// Selected slot
var select_x = bar_x +
    (slot_start_x + global.selected_slot * slot_spacing) * scale;

var select_y = bar_y + slot_start_y * scale;

draw_sprite_ext(
    sSlotSelect, 0,
    select_x, select_y,
    scale, scale,
    0, c_white, 1
);

// Draw hotbar items
for (var i = 0; i < global.hotbar_slots; i++)
{
    var inv_index = global.hotbar[i];

    if (inv_index == -1)
        continue;

    var slot = global.inventory[inv_index];

    if (slot == -1)
        continue;

    var item = slot[0];
    var quantity = slot[1];

    var item_x = bar_x +
        (slot_start_x + i * slot_spacing + 1) * scale;

    var item_y = bar_y +
        (slot_start_y + 1) * scale;

    // DRAW ITEM
	draw_sprite_ext(
	    item.Sprite,
	    0,
	    item_x,
	    item_y,
	    scale * item_scale,
	    scale * item_scale,
	    0,
	    c_white,
	    1
	);

    // DRAW QUANTITY
	if (quantity > 1)
	{
	    draw_set_font(global.ui_settings.quantity_font);
	    draw_set_color(global.ui_settings.quantity_color);
	    draw_set_halign(fa_right);
	    draw_set_valign(fa_bottom);

	    draw_text_transformed(
	        item_x + slot_spacing * scale,
	        item_y + slot_spacing * scale,
	        string(quantity),
	        quantity_scale,
	        quantity_scale,
	        0
	    );
	}
}

// Reset drawing settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// HIDE HOTBAR WITH INVENTORY OPEN

if (!global.inventory_open)
{
    // Your existing hotbar Draw GUI code here
}