var GUI = instance_find(oGUI, 0);

if (GUI == noone) exit;

var NearPlayer = point_distance(x, y, oPlayer.x, oPlayer.y) <= InteractDistance;

// Open store
if (NearPlayer && keyboard_check_pressed(ord("E")) && !GUI.InvOpen)
{
    GUI.StoreOpen = true;
    GUI.InvOpen = true;
    GUI.CurrentStore = id;
}

// Close store
if (GUI.StoreOpen && GUI.CurrentStore == id)
{
    if (keyboard_check_pressed(vk_escape) || !NearPlayer)
    {
        GUI.StoreOpen = false;
        GUI.InvOpen = false;
        GUI.CurrentStore = noone;
    }
}