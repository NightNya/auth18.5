th_image.LoadImage("item", "assets/item/item.png")
NewQuadGroupBatch("item", "item", {
	{0,0,32,32,"power_big"}, {32,0,32,32,"lives"}, {64,0,32,32,"lives_big"},
	{96,0,32,32,"bomb"}, {128,0,32,32,"bomb_big"}, {160,0,32,32,"full"},
	{192,0,16,16,"power"}, {208,0,16,16,"point"}, {192,32,16,16,"small_point_0"},
	{208,32,16,16,"small_point_1"}, {192,48,16,16,"small_point_2"}
})
NewQuadGroupBatch("item_arrow", "item", {
	{0,32,32,32,"power_big"}, {32,32,32,32,"lives"}, {64,32,32,32,"lives_big"},
	{96,32,32,32,"bomb"}, {128,32,32,32,"bomb_big"}, {160,0,32,32,"full"},
	{192,16,16,16,"power"}, {208,16,16,16,"point"}
})
