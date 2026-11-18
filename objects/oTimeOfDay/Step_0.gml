Tick += 1*global.DT;

if Tick >= 10 {
	//update crops
	
	with (oPlot) {
		
		//grow if crop is defined
		if Crop != undefined {
			if isFertilized == true {
				Tick+=2;
			} else {
				Tick++;
			}
		} else {
			Tick = 0;

		}
		
	} 
	Tick  =0;
	
}