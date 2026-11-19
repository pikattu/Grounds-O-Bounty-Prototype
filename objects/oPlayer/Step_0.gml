// Input
var kLeft = keyboard_check(ord("A"));
var kRight = keyboard_check(ord("D"));
var kUp = keyboard_check(ord("W"));
var kDown = keyboard_check(ord("S"));

// Calculate Movement
var hVel = (kRight - kLeft) * moveSpeed;
var vVel = (kDown - kUp) * moveSpeed;

// Fixing Diagonal Movement
var Mag = sqrt((hVel*hVel) + (vVel*vVel));
if Mag == 0 { Mag = 1; }

// Animations
PlayerAnimations(hVel,vVel);

var lay_id = layer_get_id("tCollision");
var map_id = layer_tilemap_get_id(lay_id);

if (kLeft == 1) {
	var left_top = tilemap_get_at_pixel(map_id, bbox_left - moveSpeed, bbox_top);
	var left_bottom = tilemap_get_at_pixel(map_id, bbox_left - moveSpeed, bbox_bottom);
	
	if (left_top == 0 and left_bottom == 0) {
		x -= moveSpeed;
	}
}
// Collisions

var lay_id = layer_get_id("tCollision");
var map_id = layer_tilemap_get_id(lay_id);

// Left
if (kLeft == 1) {
    var left_top = tilemap_get_at_pixel(map_id, bbox_left - moveSpeed, bbox_top);
    var left_bottom = tilemap_get_at_pixel(map_id, bbox_left - moveSpeed, bbox_bottom);

    if (left_top == 0 && left_bottom == 0 &&
        !place_meeting(x - moveSpeed, y, oCollision)) {
        x -= moveSpeed;
    }
}

// Right
if (kRight == 1) {
    var right_top = tilemap_get_at_pixel(map_id, bbox_right + moveSpeed, bbox_top);
    var right_bottom = tilemap_get_at_pixel(map_id, bbox_right + moveSpeed, bbox_bottom);

    if (right_top == 0 && right_bottom == 0 &&
        !place_meeting(x + moveSpeed, y, oCollision)) {
        x += moveSpeed;
    }
}

// Up
if (kUp == 1) {
    var up_top = tilemap_get_at_pixel(map_id, bbox_left, bbox_top - moveSpeed);
    var up_bottom = tilemap_get_at_pixel(map_id, bbox_right, bbox_top - moveSpeed);

    if (up_top == 0 && up_bottom == 0 &&
        !place_meeting(x, y - moveSpeed, oCollision)) {
        y -= moveSpeed;
    }
}

// Down
if (kDown == 1) {
    var down_top = tilemap_get_at_pixel(map_id, bbox_left, bbox_bottom + moveSpeed);
    var down_bottom = tilemap_get_at_pixel(map_id, bbox_right, bbox_bottom + moveSpeed);

    if (down_top == 0 && down_bottom == 0 &&
        !place_meeting(x, y + moveSpeed, oCollision)) {
        y += moveSpeed;
    }
}
depth = -y;