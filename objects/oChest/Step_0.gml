if (instance_exists(oGUI))
{
    if (oGUI.CurrentChest == id && oGUI.ChestOpen)
    {
        sprite_index = sChestOpen;
    }
    else
    {
        sprite_index = sChestClose;
    }
}