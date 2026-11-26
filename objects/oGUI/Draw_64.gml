
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
    PlayerX = xDiff - 100;
    PlayerY = yDiff - 45;

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


// ==========================================
// INVENTORY OPEN
// ==========================================

if (InvOpen)
{
    // ==========================================
    // INVENTORY BACKGROUNDS
    // ==========================================

    if (StoreOpen && instance_exists(CurrentStore))
    {
        draw_sprite_stretched(
            sGUIBG, 0,
            PlayerX - 14, PlayerY - 35,
            112, 137
        );

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

    draw_set_font(global.Font);
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
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);

                draw_text_transformed(
                    xx - 7, yy - 8,
                    string(Inv[i][1]),
                    0.5, 0.5, 0
                );

                draw_set_color(c_white);
            }
        }

        // Hover
        if (point_in_rectangle(MouseX, MouseY, xx - 9, yy - 9, xx + 9, yy + 9))
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
                    draw_set_halign(fa_left);
                    draw_set_valign(fa_top);

                    draw_text_transformed(
                        xx - 7, yy - 8,
                        string(ChestInv[i][1]),
                        0.5, 0.5, 0
                    );

                    draw_set_color(c_white);
                }
            }

            // Hover
            if (point_in_rectangle(MouseX, MouseY, xx - 9, yy - 9, xx + 9, yy + 9))
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


// ==========================================
// HOTBAR (INVENTORY CLOSED)
// ==========================================

else
{
    // Hotbar background
    draw_sprite_stretched(
        sGUIBG, 0,
        xDiff - 55, yDiff + 104,
        108, 26
    );

    // ==========================================
    // HOTBAR SLOTS
    // ==========================================

    for (var i = 0; i < InvWidth; i++)
    {
        var xx = xDiff - 43 + i * 21;
        var yy = yDiff + 117;

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
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);

                draw_text_transformed(
                    xx - 7, yy - 8,
                    string(Inv[i][1]),
                    0.5, 0.5, 0
                );

                draw_set_color(c_white);
            }
        }

        // Selected slot (outside item check)
        if (i == HotbarSelect)
        {
            draw_sprite(sSlotSelect, 0, xx, yy);
        }
    }
}


// ==========================================
// USE ITEMS
// ==========================================

if (instance_exists(oPlot))
{
    if (mouse_check_button_pressed(mb_left) && !InvOpen && !StoreOpen)
    {
        // ==========================================
        // HARVEST OR REMOVE DEAD CROP
        // ==========================================

        var NC = instance_nearest(mouse_x, mouse_y, oPlot);

        if (instance_exists(NC))
        {
            if (point_in_rectangle(
                mouse_x, mouse_y,
                NC.x - 8, NC.y - 8,
                NC.x + 8, NC.y + 8
            ) && point_distance(oPlayer.x, oPlayer.y, NC.x, NC.y) < 32)
            {
                if (NC.Crop != undefined)
                {
                    // DEAD CROP
                    if (NC.IsDead)
                    {
                        NC.Crop = undefined;
                        NC.Tick = 0;
                        NC.Stage = 0;
                        NC.SubImage = 0;
                        NC.IsFullyGrown = false;

                        NC.IsWatered = false;
                        NC.DryDays = 0;
                        NC.IsDead = false;
                        NC.isFertilized = false;

                        show_debug_message("Dead crop removed!");
                    }

                    // NORMAL CROP
                    else if (NC.Tick >= NC.Crop.GrowTime)
                    {
                        var Item = NC.Crop.Drop[0];
                        var Amount = NC.Crop.Drop[1];

                        repeat (Amount)
                        {
                            var Drop = instance_create_depth(
                                NC.x, NC.y, 0, oItem
                            );

                            Drop.Item = Item;
                        }

                        // Reset plot
                        NC.Crop = undefined;
                        NC.Tick = 0;
                        NC.Stage = 0;
                        NC.SubImage = 0;
                        NC.IsFullyGrown = false;

                        NC.IsWatered = false;
                        NC.DryDays = 0;
                        NC.IsDead = false;
                        NC.isFertilized = false;

                        show_debug_message("Crop harvested!");
                    }
                    else
                    {
                        show_debug_message(
                            "Crop not ready: "
                            + string(NC.Tick)
                            + " / "
                            + string(NC.Crop.GrowTime)
                        );
                    }
                }
            }
        }


        // ==========================================
        // USE SELECTED ITEM
        // ==========================================

        if (Inv[HotbarSelect] != -1)
        {
            switch (Inv[HotbarSelect][0].ItemType)
            {
                case "Crop":
                break;


                // ==========================================
                // TOOLS
                // ==========================================

                case "Tool":

                    // ==========================================
                    // WATERING CAN
                    // ==========================================

                    if (Inv[HotbarSelect][0] == global.ItemWateringCan)
                    {
                        var _plot = instance_nearest(mouse_x, mouse_y, oPlot);

                        if (instance_exists(_plot))
                        {
                            if (point_in_rectangle(
                                mouse_x, mouse_y,
                                _plot.x - 8, _plot.y - 8,
                                _plot.x + 8, _plot.y + 8
                            ) && point_distance(
                                oPlayer.x, oPlayer.y,
                                _plot.x, _plot.y
                            ) < 32)
                            {
                                // Water planted crops
                                if (_plot.Crop != undefined
                                && !_plot.IsDead
                                && !_plot.IsWatered)
                                {
                                    _plot.IsWatered = true;
                                    _plot.DryDays = 0;

                                    show_debug_message("Crop watered!");
                                }
                            }
                        }
                    }

                    // ==========================================
                    // HOE
                    // ==========================================

                    else
                    {
                        var xx = round(mouse_x / 16) * 16;
                        var yy = round(mouse_y / 16) * 16;

                        if (!collision_rectangle(
                            xx - 2, yy - 2,
                            xx + 2, yy + 2,
                            oPlot, 0, 1
                        ))
                        {
                            instance_create_depth(xx, yy, 0, oPlot);
                        }
                    }

                break;


                // ==========================================
                // SEEDS
                // ==========================================

                case "Seed":

                    var NP = instance_nearest(mouse_x, mouse_y, oPlot);

                    if (instance_exists(NP))
                    {
                        if (point_in_rectangle(
                            mouse_x, mouse_y,
                            NP.x - 8, NP.y - 8,
                            NP.x + 8, NP.y + 8
                        ) && point_distance(oPlayer.x, oPlayer.y, NP.x, NP.y) < 32)
                        {
                            // Only plant on empty plots
                            if (NP.Crop == undefined)
                            {
                                var Crop = undefined;

                                // Identify crop from seed
                                switch (Inv[HotbarSelect][0])
                                {
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

                                // Plant crop
                                if (Crop != undefined)
                                {
                                    NP.Crop = Crop;

                                    // Reset growth
                                    NP.Tick = 0;
                                    NP.Stage = 0;
                                    NP.SubImage = 0;
                                    NP.IsFullyGrown = false;
                                    NP.isFertilized = false;

                                    // Consume seed
                                    InventoryRemove(
                                        Inv,
                                        Inv[HotbarSelect][0],
                                        1
                                    );
                                }
                            }
                            else
                            {
                                show_debug_message("Plot is not empty!");
                            }
                        }
                    }

                break;


                // ==========================================
                // FERTILIZER
                // ==========================================

                case "Fertilizer":

                    var NP = instance_nearest(mouse_x, mouse_y, oPlot);

                    if (instance_exists(NP))
                    {
                        if (point_in_rectangle(
                            mouse_x, mouse_y,
                            NP.x - 8, NP.y - 8,
                            NP.x + 8, NP.y + 8
                        ) && point_distance(
                            oPlayer.x, oPlayer.y,
                            NP.x, NP.y
                        ) < 32)
                        {
                            // Apply fertilizer only to an empty plot
                            if (NP.Crop == undefined && !NP.isFertilized)
                            {
                                NP.isFertilized = true;

                                InventoryRemove(
                                    Inv,
                                    Inv[HotbarSelect][0],
                                    1
                                );

                                show_debug_message("Plot fertilized!");
                            }
                        }
                    }

                break;
            }
        }
    }
}


// ==========================================
// DIALOGUE - DRAW LAST (ABOVE GUI)
// ==========================================

if (instance_exists(oDialogue))
{
    with (oDialogue)
    {
        dialogue_draw_gui();
    }
}
