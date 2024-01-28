
// see code/module/crafting/table.dm

////////////////////////////////////////////////DONUTS////////////////////////////////////////////////

/datum/crafting_recipe/food/donut
	time = 15
	name = "甜甜圈"
	reqs = list(
		/datum/reagent/consumable/sugar = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/donut/plain
	category = CAT_PASTRY


/datum/crafting_recipe/food/donut/chaos
	name = "混乱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/frostoil = 5,
		/datum/reagent/consumable/capsaicin = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/donut/chaos

/datum/crafting_recipe/food/donut/meat
	time = 15
	name = "肉甜甜圈"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/donut/meat

/datum/crafting_recipe/food/donut/jelly
	name = "果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/donut/jelly/plain

/datum/crafting_recipe/food/donut/slimejelly
	name = "史莱姆果酱甜甜圈"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/plain


/datum/crafting_recipe/food/donut/berry
	name = "果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/berry

/datum/crafting_recipe/food/donut/trumpet
	name = "宇航员甜甜圈"
	reqs = list(
		/datum/reagent/medicine/polypyr = 3,
		/obj/item/food/donut/plain = 1
	)

	result = /obj/item/food/donut/trumpet

/datum/crafting_recipe/food/donut/apple
	name = "苹果甜甜圈"
	reqs = list(
		/datum/reagent/consumable/applejuice = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/apple

/datum/crafting_recipe/food/donut/caramel
	name = "焦糖甜甜圈"
	reqs = list(
		/datum/reagent/consumable/caramel = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/caramel

/datum/crafting_recipe/food/donut/choco
	name = "巧克力甜甜圈"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/choco

/datum/crafting_recipe/food/donut/blumpkin
	name = "蓝瓜甜甜圈"
	reqs = list(
		/datum/reagent/consumable/blumpkinjuice = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/blumpkin

/datum/crafting_recipe/food/donut/bungo
	name = "Bungo甜甜圈"
	reqs = list(
		/datum/reagent/consumable/bungojuice = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/bungo

/datum/crafting_recipe/food/donut/matcha
	name = "抹茶甜甜圈"
	reqs = list(
		/datum/reagent/toxin/teapowder = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/matcha

/datum/crafting_recipe/food/donut/laugh
	name = "甜浆甜甜圈"
	reqs = list(
		/datum/reagent/consumable/laughsyrup = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/laugh

////////////////////////////////////////////////////JELLY DONUTS///////////////////////////////////////////////////////

/datum/crafting_recipe/food/donut/jelly/berry
	name = "果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/berry

/datum/crafting_recipe/food/donut/jelly/trumpet
	name = "宇航员果酱甜甜圈"
	reqs = list(
		/datum/reagent/medicine/polypyr = 3,
		/obj/item/food/donut/jelly/plain = 1
	)

	result = /obj/item/food/donut/jelly/trumpet

/datum/crafting_recipe/food/donut/jelly/apple
	name = "苹果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/applejuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/apple

/datum/crafting_recipe/food/donut/jelly/caramel
	name = "焦糖果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/caramel = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/caramel

/datum/crafting_recipe/food/donut/jelly/choco
	name = "巧克力果酱甜甜圈"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/choco

/datum/crafting_recipe/food/donut/jelly/blumpkin
	name = "蓝瓜果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/blumpkinjuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/blumpkin

/datum/crafting_recipe/food/donut/jelly/bungo
	name = "Bungo果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/bungojuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/bungo

/datum/crafting_recipe/food/donut/jelly/matcha
	name = "抹茶果酱甜甜圈"
	reqs = list(
		/datum/reagent/toxin/teapowder = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/matcha

/datum/crafting_recipe/food/donut/jelly/laugh
	name = "甜浆果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/laughsyrup = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/laugh

////////////////////////////////////////////////////SLIME  DONUTS///////////////////////////////////////////////////////

/datum/crafting_recipe/food/donut/slimejelly/berry
	name = "史莱姆果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/berry

/datum/crafting_recipe/food/donut/slimejelly/trumpet
	name = "宇航员史莱姆果酱甜甜圈"
	reqs = list(
		/datum/reagent/medicine/polypyr = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)

	result = /obj/item/food/donut/jelly/slimejelly/trumpet

/datum/crafting_recipe/food/donut/slimejelly/apple
	name = "苹果史莱姆酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/applejuice = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/apple

/datum/crafting_recipe/food/donut/slimejelly/caramel
	name = "焦糖史莱姆果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/caramel = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/caramel

/datum/crafting_recipe/food/donut/slimejelly/choco
	name = "巧克力史莱姆果酱甜甜圈"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/choco

/datum/crafting_recipe/food/donut/slimejelly/blumpkin
	name = "蓝瓜史莱姆果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/blumpkinjuice = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/blumpkin

/datum/crafting_recipe/food/donut/slimejelly/bungo
	name = "Bungo史莱姆果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/bungojuice = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/bungo

/datum/crafting_recipe/food/donut/slimejelly/matcha
	name = "抹茶史莱姆果酱甜甜圈"
	reqs = list(
		/datum/reagent/toxin/teapowder = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/matcha

/datum/crafting_recipe/food/donut/slimejelly/laugh
	name = "甜浆史莱姆果酱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/laughsyrup = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/laugh

////////////////////////////////////////////////WAFFLES////////////////////////////////////////////////

/datum/crafting_recipe/food/waffles
	time = 15
	name = "华夫饼"
	reqs = list(
		/obj/item/food/pastrybase = 2
	)
	result = /obj/item/food/waffles
	category = CAT_PASTRY


/datum/crafting_recipe/food/soylenviridians
	name = "营养食品"
	reqs = list(
		/obj/item/food/pastrybase = 2,
		/obj/item/food/grown/soybeans = 1
	)
	result = /obj/item/food/soylenviridians
	category = CAT_PASTRY

/datum/crafting_recipe/food/soylentgreen
	name = "绿色食品"
	reqs = list(
		/obj/item/food/pastrybase = 2,
		/obj/item/food/meat/slab/human = 2
	)
	result = /obj/item/food/soylentgreen
	category = CAT_PASTRY


/datum/crafting_recipe/food/rofflewaffles
	name = "Roffle华夫饼"
	reqs = list(
		/datum/reagent/drug/mushroomhallucinogen = 5,
		/obj/item/food/pastrybase = 2
	)
	result = /obj/item/food/rofflewaffles
	category = CAT_PASTRY

////////////////////////////////////////////////DONKPOCCKETS////////////////////////////////////////////////

/datum/crafting_recipe/food/donkpocket
	time = 15
	name = "原味口袋饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/meatball = 1
	)
	result = /obj/item/food/donkpocket
	category = CAT_PASTRY

/datum/crafting_recipe/food/dankpocket
	time = 15
	name = "哈草口袋饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/cannabis = 1
	)
	result = /obj/item/food/dankpocket
	category = CAT_PASTRY

/datum/crafting_recipe/food/donkpocket/spicy
	time = 15
	name = "辣味口袋饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/meatball = 1,
		/obj/item/food/grown/chili = 1
	)
	result = /obj/item/food/donkpocket/spicy
	category = CAT_PASTRY

/datum/crafting_recipe/food/donkpocket/teriyaki
	time = 15
	name = "照烧味口袋饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/meatball = 1,
		/datum/reagent/consumable/soysauce = 3
	)
	result = /obj/item/food/donkpocket/teriyaki
	category = CAT_PASTRY

/datum/crafting_recipe/food/donkpocket/pizza
	time = 15
	name = "披萨味口袋饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/meatball = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/donkpocket/pizza
	category = CAT_PASTRY

/datum/crafting_recipe/food/donkpocket/honk
	time = 15
	name = "香蕉味口袋饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/banana = 1,
		/datum/reagent/consumable/sugar = 3
	)
	result = /obj/item/food/donkpocket/honk
	category = CAT_PASTRY

/datum/crafting_recipe/food/donkpocket/berry
	time = 15
	name = "浆果味口袋饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/donkpocket/berry
	category = CAT_PASTRY

/datum/crafting_recipe/food/donkpocket/gondola
	time = 15
	name = "贡多拉口袋饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/meatball = 1,
		/datum/reagent/gondola_mutation_toxin = 5
	)
	result = /obj/item/food/donkpocket/gondola
	category = CAT_PASTRY

////////////////////////////////////////////////MUFFINS////////////////////////////////////////////////

/datum/crafting_recipe/food/muffin
	time = 15
	name = "松饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/muffin
	category = CAT_PASTRY

/datum/crafting_recipe/food/berrymuffin
	name = "浆果松饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/muffin/berry
	category = CAT_PASTRY

/datum/crafting_recipe/food/booberrymuffin
	name = "boo果松饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/berries = 1,
		/obj/item/ectoplasm = 1
	)
	result = /obj/item/food/muffin/booberry
	category = CAT_PASTRY

////////////////////////////////////////////OTHER////////////////////////////////////////////


/datum/crafting_recipe/food/khachapuri
	name = "哈恰普哩"
	reqs = list(
		/datum/reagent/consumable/eggyolk = 2,
		/datum/reagent/consumable/eggwhite = 4,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/bread/plain = 1
	)
	result = /obj/item/food/khachapuri
	category = CAT_PASTRY

/datum/crafting_recipe/food/sugarcookie
	time = 15
	name = "糖霜曲奇"
	reqs = list(
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/cookie/sugar
	category = CAT_PASTRY

/datum/crafting_recipe/food/spookyskull
	time = 15
	name = "骷髅曲奇"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/milk = 5
	)
	result = /obj/item/food/cookie/sugar/spookyskull
	category = CAT_PASTRY

/datum/crafting_recipe/food/spookycoffin
	time = 15
	name = "棺材曲奇"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/coffee = 5
	)
	result = /obj/item/food/cookie/sugar/spookycoffin
	category = CAT_PASTRY

/datum/crafting_recipe/food/fortunecookie
	time = 15
	name = "幸运曲奇"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/paper = 1
	)
	parts = list(
		/obj/item/paper = 1
	)
	result = /obj/item/food/fortunecookie
	category = CAT_PASTRY

/datum/crafting_recipe/food/poppypretzel
	time = 15
	name = "罂粟椒盐卷饼"
	reqs = list(
		/obj/item/seeds/poppy = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/poppypretzel
	category = CAT_PASTRY

/datum/crafting_recipe/food/plumphelmetbiscuit
	time = 15
	name = "厚头菇饼干"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/mushroom/plumphelmet = 1
	)
	result = /obj/item/food/plumphelmetbiscuit
	category = CAT_PASTRY

/datum/crafting_recipe/food/cracker
	time = 15
	name = "苏打饼干"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pastrybase = 1,
	)
	result = /obj/item/food/cracker
	category = CAT_PASTRY

/datum/crafting_recipe/food/chococornet
	name = "巧克力螺"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/chocolatebar = 1
	)
	result = /obj/item/food/chococornet
	category = CAT_PASTRY

/datum/crafting_recipe/food/oatmealcookie
	name = "燕麦饼干"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/oat = 1
	)
	result = /obj/item/food/cookie/oatmeal
	category = CAT_PASTRY

/datum/crafting_recipe/food/raisincookie
	name = "葡萄干曲奇"
	reqs = list(
		/obj/item/food/no_raisin = 1,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/oat = 1
	)
	result = /obj/item/food/cookie/raisin
	category = CAT_PASTRY

/datum/crafting_recipe/food/cherrycupcake
	name = "樱桃纸杯蛋糕"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/cherries = 1
	)
	result = /obj/item/food/cherrycupcake
	category = CAT_PASTRY

/datum/crafting_recipe/food/bluecherrycupcake
	name = "蓝樱桃纸杯蛋糕"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/bluecherries = 1
	)
	result = /obj/item/food/cherrycupcake/blue
	category = CAT_PASTRY

/datum/crafting_recipe/food/honeybun
	name = "蜂蜜小面包"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/honeybun
	category = CAT_PASTRY

/datum/crafting_recipe/food/cannoli
	name = "卡诺里"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/milk = 1,
		/datum/reagent/consumable/sugar = 3
	)
	result = /obj/item/food/cannoli
	category = CAT_PASTRY

/datum/crafting_recipe/food/peanut_butter_cookie
	name = "花生酱饼干"
	reqs = list(
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/cookie/peanut_butter
	category = CAT_PASTRY

/datum/crafting_recipe/food/raw_brownie_batter
	name = "生布朗尼面糊"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/egg = 2,
		/datum/reagent/consumable/coco = 5,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/raw_brownie_batter
	category = CAT_PASTRY

/datum/crafting_recipe/food/peanut_butter_brownie_batter
	name = "生花生酱布朗尼面糊"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/egg = 2,
		/datum/reagent/consumable/coco = 5,
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/peanut_butter_brownie_batter
	category = CAT_PASTRY

/datum/crafting_recipe/food/crunchy_peanut_butter_tart
	name = "脆花生酱馅饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/food/grown/peanut = 1,
		/datum/reagent/consumable/cream = 5,
	)
	result = /obj/item/food/crunchy_peanut_butter_tart
	category = CAT_PASTRY

/datum/crafting_recipe/food/chocolate_chip_cookie
	name = "巧克力曲奇"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/cookie/chocolate_chip_cookie
	category = CAT_PASTRY

/datum/crafting_recipe/food/snickerdoodle
	name = "肉桂甜饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/vanilla = 5,
	)
	result = /obj/item/food/cookie/snickerdoodle
	category = CAT_PASTRY

/datum/crafting_recipe/food/thumbprint_cookie
	name = "夹心饼干"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/cherryjelly = 5,
	)
	result = /obj/item/food/cookie/thumbprint_cookie
	category = CAT_PASTRY

/datum/crafting_recipe/food/macaron
	name = "马卡龙"
	reqs = list(
		/datum/reagent/consumable/eggwhite = 2,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/flour = 5,
	)
	result = /obj/item/food/cookie/macaron
	category = CAT_PASTRY
