// harvest time grow time not implemented

function ItemInformation()
{
    // =========================
    // CROPS
    // =========================

    global.ItemStrawberry =
    {
        Name: "Strawberry",
        Sprite: sStrawberr,
        ItemType: "Crop"
    };
	global.ItemRice =
    {
        Name: "Rice",
        Sprite: sRice,
        ItemType: "Crop"
    };

    global.ItemPineapple =
    {
        Name: "Pineapple",
        Sprite: sPineapple,
        ItemType: "Crop"
    };

    global.ItemCorn =
    {
        Name: "Corn",
        Sprite: sCorn,
        ItemType: "Crop"
    };


    // =========================
    // SEEDS
    // =========================

    global.ItemStrawberrySeeds =
    {
        Name: "Strawberry Seed",
        Sprite: sStrawberrySeeds,
        ItemType: "Seed"
    };
	
	global.ItemRiceSeeds =
    {
        Name: "Rice Seed",
        Sprite: sRiceSeeds,
        ItemType: "Seed"
    };
    global.ItemPineappleSeeds =
    {
        Name: "Pineapple Seed",
        Sprite: sPineappleSeeds,
        ItemType: "Seed",
        GrowTime: 8,
        HarvestItem: global.ItemPineapple
    };

    global.ItemCornSeeds =
    {
        Name: "Corn Seed",
        Sprite: sCornSeeds,
        ItemType: "Seed",
        GrowTime: 4,
        HarvestItem: global.ItemCorn
    };


    // =========================
    // TOOLS
    // =========================

    global.ItemHoe =
    {
        Name: "Hoe",
        Sprite: sHoe,
        ItemType: "Tool"
    };
}