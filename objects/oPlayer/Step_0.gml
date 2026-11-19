
// Input
var kLeft  = keyboard_check(ord("A"));
var kRight = keyboard_check(ord("D"));
var kUp    = keyboard_check(ord("W"));
var kDown  = keyboard_check(ord("S"));

// Calculate Movement
var hVel = (kRight - kLeft) * moveSpeed;
var vVel = (kDown - kUp) * moveSpeed;

// Fix Diagonal Movement
var Mag = sqrt(hVel * hVel + vVel * vVel);

if (Mag > 0) {
    hVel /= Mag;
    vVel /= Mag;
}

// Apply Movement
move_and_collide((hVel/Mag)*global.DT, (vVel/Mag)*global.DT, oCollision)


// Animations
<<<<<<< Updated upstream
PlayerAnimations(hVel,vVel);
=======
PlayerAnimations(hVel, vVel);

// Get Collision Tilemap
var lay_id = layer_get_id("tCollision");
var map_id = layer_tilemap_get_id(lay_id);

// Horizontal Collision
if (hVel != 0) {
    var nextX = x + hVel;

    var hitTile = false;

    if (map_id != -1) {
        hitTile =
            tilemap_get_at_pixel(map_id, bbox_left + hVel, bbox_top) != 0 ||
            tilemap_get_at_pixel(map_id, bbox_left + hVel, bbox_bottom - 1) != 0 ||
            tilemap_get_at_pixel(map_id, bbox_right + hVel, bbox_top) != 0 ||
            tilemap_get_at_pixel(map_id, bbox_right + hVel, bbox_bottom - 1) != 0;
    }

    if (!hitTile && !place_meeting(nextX, y, oCollision)) {
        x = nextX;
    }
}

// Vertical Collision
if (vVel != 0) {
    var nextY = y + vVel;

    var hitTile = false;

    if (map_id != -1) {
        hitTile =
            tilemap_get_at_pixel(map_id, bbox_left, bbox_top + vVel) != 0 ||
            tilemap_get_at_pixel(map_id, bbox_right - 1, bbox_top + vVel) != 0 ||
            tilemap_get_at_pixel(map_id, bbox_left, bbox_bottom + vVel) != 0 ||
            tilemap_get_at_pixel(map_id, bbox_right - 1, bbox_bottom + vVel) != 0;
    }

    if (!hitTile && !place_meeting(x, nextY, oCollision)) {
        y = nextY;
    }
}

// Depth
depth = -y;
>>>>>>> Stashed changes
