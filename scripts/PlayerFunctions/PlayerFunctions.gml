function PlayerAnimations(hVel,vVel){
	// Determine Dir
	if hVel > 0 { Dir = 1;} // Right
	if hVel < 0 { Dir = 3;} // Left
	if vVel > 0 { Dir = 2;} // Down
	if vVel < 0 { Dir = 0;} // Up
	
	// Idle Anim
	if hVel == 0 and vVel == 0 { // not moving
		switch (Dir) {
			case 0:
				sprite_index = sPlayerIdleUp;
				image_xscale = 1;
			break;
			
			case 1:
				sprite_index = sPlayerIdleSide;
				image_xscale = 1;
			break;
			
			case 2:
				sprite_index = sPlayerIdleDown;
				image_xscale = 1;
			break;
			
			
			case 3:
				sprite_index = sPlayerIdleSide;
				image_xscale = -1;
			break;
		}
	}	else { // IF MOVING
			switch (Dir) {
				case 0:
					sprite_index = sPlayerWalkUp;
					image_xscale = 1;
				break;
			
				case 1:
					sprite_index = sPlayerWalkSide;
					image_xscale = 1;
				break;
			
				case 2:
					sprite_index = sPlayerWalkDown;
					image_xscale = 1;
				break;
			
			
				case 3:
					sprite_index = sPlayerWalkSide;
					image_xscale = -1;
				break;
		}
	}
		
}