if (spot == undefined) { instance_destroy(); exit; }

if (digging) {
    dig_timer -= 1;
    if (dig_timer <= 0) {
        spot.dug = true;
        var _a = spot.artifact;
        antique_give_item(_a);
        instance_create_depth(x, y - 8, -10000, oAntiquePopup, { artifact: _a });
        instance_destroy();
    }
    exit;
}

near = instance_exists(oPlayer) && point_distance(x, y, oPlayer.x, oPlayer.y) <= ANTIQUE_DIG_RANGE;

if (near && keyboard_check_pressed(ANTIQUE_KEY) && antique_can_dig()) {
    digging = true;
    dig_timer = 40;
}