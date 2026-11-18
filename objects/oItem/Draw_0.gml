// show item


if Item != undefined {
	draw_sprite(Item.Sprite,0,x,y);
}

// player collect drop

if InventoryHasRoom(oGUI.Inv, Item) {
	x = lerp(x,oPlayer.x, .1*global.DT);
	y = lerp(y, oPlayer.y, .1*global.DT);
	
	if distance_to_object(oPlayer) <= 4 {
		InventoryAdd(oGUI.Inv,Item,1);
		instance_destroy();
	}
}