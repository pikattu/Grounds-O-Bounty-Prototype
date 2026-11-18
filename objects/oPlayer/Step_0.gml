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

var lay_id = layer_get_id("tColissions");
var map_id = layer_tilemap_get_id(lay_id);

if (kLeft == 1) {
	var left_top = tilemap_get_at_pixel(map_id, bbox_left - moveSpeed, bbox_top);
	var left_bottom = tilemap_get_at_pixel(map_id, bbox_left - moveSpeed, bbox_bottom);
	
	if (left_top == 0 and left_bottom == 0) {
		x -= moveSpeed;
	}
}

if (kRight == 1) {
	var Right_top = tilemap_get_at_pixel(map_id, bbox_right + moveSpeed, bbox_top);
	var Right_bottom = tilemap_get_at_pixel(map_id, bbox_right + moveSpeed, bbox_bottom);
	
	if (Right_top == 0 and Right_bottom == 0) {
		x += moveSpeed;
	}
}

if (kUp == 1) {
	var Up_top = tilemap_get_at_pixel(map_id, bbox_left, bbox_top - moveSpeed);
	var Up_bottom = tilemap_get_at_pixel(map_id, bbox_right, bbox_top - moveSpeed);
	
	if (Up_top == 0 and Up_bottom == 0) {
		y -= moveSpeed;
	}
}

if (kDown == 1) {
	var Down_top = tilemap_get_at_pixel(map_id, bbox_left, bbox_bottom + moveSpeed);
	var Down_bottom = tilemap_get_at_pixel(map_id, bbox_right, bbox_bottom + moveSpeed);
	
	if (Down_top == 0 and Down_bottom == 0) {
		y += moveSpeed;
	}
}