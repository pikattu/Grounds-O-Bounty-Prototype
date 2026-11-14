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

// Apply Movement
move_and_collide((hVel/Mag)*global.DT, (vVel/Mag)*global.DT, oCollision)


// Animations
PlayerAnimations(hVel,vVel);
