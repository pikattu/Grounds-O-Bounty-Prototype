
function scrCropInformation(){

    global.CropCorn = 
    {
        Sprite: sPlantCorn,
        GrowTime: 2 * 86400, // ingame growdays * time each day
        Drop: [global.ItemCorn, 5]
    };

    global.CropPineapple = 
    {
        Sprite: sPlantPineapple,
        GrowTime: 2 * 86400,
        Drop: [global.ItemPineapple, 2]
    };

    global.CropRice = 
    {
        Sprite: sPlantRice,
        GrowTime: 2 * 86400,
        Drop: [global.ItemRice, 5]
    };

    global.CropStrawberry = 
    {
        Sprite: sPlantStrawberry,
        GrowTime: 2 * 86400,
        Drop: [global.ItemStrawberry, 3]
    };
}
