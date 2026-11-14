
// SHARED UI SETTINGS
var scale = global.ui_settings.scale;
var item_scale = global.ui_settings.item_scale;
var quantity_scale = global.ui_settings.quantity_scale;

if (global.inventory_open)
{
    // GET GUI DIMENSIONS
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    // BOOK DIMENSIONS
    var book_w = sprite_get_width(book_sprite);
    var book_h = sprite_get_height(book_sprite);

    // CENTER BOOK
    var book_x = (gui_w - book_w * scale) / 2;
    var book_y = (gui_h - book_h * scale) / 2;

    // DRAW BOOK
    draw_sprite_ext(
        book_sprite, 0,
        book_x, book_y,
        scale, scale,
        0, c_white, 1
    );

    // SLOT SETTINGS
    var slot_w = 18;
    var slot_h = 18;
    var slot_padding = 2;

    // SLOT CENTER COORDINATES
    var left_x = [26, 48, 72, 96];
    var left_y = [75, 93];

    var right_x = [132, 154, 176, 198];
    var right_y = [24, 46, 68, 91];

    // DRAW INVENTORY ITEMS
    for (var i = 0; i < global.inventory_slots; i++)
    {
        var slot = global.inventory[i];

        if (slot == -1)
            continue;

        var item = slot[0];
        var quantity = slot[1];

        var slot_x;
        var slot_y;

        // LEFT PAGE
        if (i < 8)
        {
            var col = i mod 4;
            var row = i div 4;

            slot_x = left_x[col];
            slot_y = left_y[row];
        }
        // RIGHT PAGE
        else
        {
            var page_index = i - 8;

            var col = page_index mod 4;
            var row = page_index div 4;

            slot_x = right_x[col];
            slot_y = right_y[row];
        }

        // SLOT CENTER ON SCREEN
        var center_x = book_x + slot_x * scale;
        var center_y = book_y + slot_y * scale;

        // ITEM DIMENSIONS
        var sprite_w = sprite_get_width(item.Sprite);
        var sprite_h = sprite_get_height(item.Sprite);

        // AVAILABLE SLOT SPACE
        var available_w = slot_w - slot_padding * 2;
        var available_h = slot_h - slot_padding * 2;

        // AUTOMATIC ITEM FITTING
        var fit_scale = min(
            available_w / sprite_w,
            available_h / sprite_h,
            item_scale
        );

        var final_scale = fit_scale * scale;

        // DRAW ITEM (MIDDLE CENTER ORIGIN)
        draw_sprite_ext(
            item.Sprite, 0,
            center_x, center_y,
            final_scale, final_scale,
            0, c_white, 1
        );

        // DRAW QUANTITY
        if (quantity > 1)
        {
            draw_set_font(global.ui_settings.quantity_font);
            draw_set_color(global.ui_settings.quantity_color);
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);

            draw_text_transformed(
                center_x + (slot_w / 2) * scale,
                center_y + (slot_h / 2) * scale,
                string(quantity),
                quantity_scale,
                quantity_scale,
                0
            );
        }
    }

    // RESET DRAW SETTINGS
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
