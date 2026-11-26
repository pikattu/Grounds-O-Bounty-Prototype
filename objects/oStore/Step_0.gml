
var GUI = instance_find(oGUI, 0);

if (GUI == noone) exit;

// ==========================================
// CLOSE STORE WHEN PLAYER WALKS AWAY
// ==========================================

var NearPlayer = point_distance(x, y, oPlayer.x, oPlayer.y) <= InteractDistance;

if (GUI.StoreOpen && GUI.CurrentStore == id && !NearPlayer)
{
    GUI.StoreOpen = false;
    GUI.InvOpen = false;
    GUI.CurrentStore = noone;

    AudioSFX(sfxChestStore);
}
