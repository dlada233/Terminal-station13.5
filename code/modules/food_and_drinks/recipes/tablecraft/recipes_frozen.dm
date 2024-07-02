
/////////////////
//Misc. Frozen.//
/////////////////

/datum/crafting_recipe/food/icecreamsandwich
	name = "冰淇淋威化"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/ice = 5,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/icecreamsandwich
	category = CAT_ICE

/datum/crafting_recipe/food/strawberryicecreamsandwich
	name = "草莓冰淇淋威化"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/ice = 5,
		/obj/item/food/grown/berries = 2,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/strawberryicecreamsandwich
	category = CAT_ICE

/datum/crafting_recipe/food/spacefreezy
	name ="太空飞霜"
	reqs = list(
		/datum/reagent/consumable/bluecherryjelly = 5,
		/datum/reagent/consumable/spacemountainwind = 15,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/spacefreezy
	category = CAT_ICE

/datum/crafting_recipe/food/sundae
	name ="圣代"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/obj/item/food/grown/cherries = 1,
		/obj/item/food/grown/banana = 1,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/sundae
	category = CAT_ICE

/datum/crafting_recipe/food/honkdae
	name ="蕉代"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/obj/item/clothing/mask/gas/clown_hat = 1,
		/obj/item/food/grown/cherries = 1,
		/obj/item/food/grown/banana = 2,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/honkdae
	category = CAT_ICE

/datum/crafting_recipe/food/cornuto
	name = "巧乐吱"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/cream = 4,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/sugar = 4,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/cornuto
	category = CAT_ICE

//////////////////////////SNOW CONES///////////////////////

/datum/crafting_recipe/food/flavorless_sc
	name = "原味刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15
	)
	result = /obj/item/food/snowcones
	category = CAT_ICE

/datum/crafting_recipe/food/pineapple_sc
	name = "菠萝刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/pineapplejuice = 5
	)
	result = /obj/item/food/snowcones/pineapple
	category = CAT_ICE

/datum/crafting_recipe/food/lime_sc
	name = "酸橙刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/limejuice = 5
	)
	result = /obj/item/food/snowcones/lime
	category = CAT_ICE

/datum/crafting_recipe/food/lemon_sc
	name = "柠檬刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/lemonjuice = 5
	)
	result = /obj/item/food/snowcones/lemon
	category = CAT_ICE

/datum/crafting_recipe/food/apple_sc
	name = "苹果刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/applejuice = 5
	)
	result = /obj/item/food/snowcones/apple
	category = CAT_ICE

/datum/crafting_recipe/food/grape_sc
	name = "葡萄刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/grapejuice = 5
	)
	result = /obj/item/food/snowcones/grape
	category = CAT_ICE

/datum/crafting_recipe/food/orange_sc
	name = "橙子刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/orangejuice = 5
	)
	result = /obj/item/food/snowcones/orange
	category = CAT_ICE

/datum/crafting_recipe/food/blue_sc
	name = "蓝樱桃刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/bluecherryjelly= 5
	)
	result = /obj/item/food/snowcones/blue
	category = CAT_ICE

/datum/crafting_recipe/food/red_sc
	name = "樱桃刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/cherryjelly= 5
	)
	result = /obj/item/food/snowcones/red
	category = CAT_ICE

/datum/crafting_recipe/food/berry_sc
	name = "浆果刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/berryjuice = 5
	)
	result = /obj/item/food/snowcones/berry
	category = CAT_ICE

/datum/crafting_recipe/food/fruitsalad_sc
	name = "柑橘沙拉刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/water = 5,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/orangejuice = 5,
		/datum/reagent/consumable/limejuice = 5,
		/datum/reagent/consumable/lemonjuice = 5
	)
	result = /obj/item/food/snowcones/fruitsalad
	category = CAT_ICE

/datum/crafting_recipe/food/mime_sc
	name = "默剧刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/nothing = 5
	)
	result = /obj/item/food/snowcones/mime
	category = CAT_ICE

/datum/crafting_recipe/food/clown_sc
	name = "小丑刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/laughter = 5
	)
	result = /obj/item/food/snowcones/clown
	category = CAT_ICE

/datum/crafting_recipe/food/soda_sc
	name = "可乐刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/space_cola = 5
	)
	result = /obj/item/food/snowcones/soda
	category = CAT_ICE

/datum/crafting_recipe/food/spacemountainwind_sc
	name = "山风刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/spacemountainwind = 5
	)
	result = /obj/item/food/snowcones/spacemountainwind
	category = CAT_ICE

/datum/crafting_recipe/food/pwrgame_sc
	name = "pwrgame刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/pwr_game = 15
	)
	result = /obj/item/food/snowcones/pwrgame
	category = CAT_ICE

/datum/crafting_recipe/food/honey_sc
	name = "蜂蜜刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/snowcones/honey
	category = CAT_ICE

/datum/crafting_recipe/food/rainbow_sc
	name = "彩虹刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/colorful_reagent = 1 //Harder to make
	)
	result = /obj/item/food/snowcones/rainbow
	category = CAT_ICE

//////////////////////////POPSICLES///////////////////////

// This section includes any frozen treat served on a stick.
////////////////////////////////////////////////////////////

/datum/crafting_recipe/food/orange_popsicle
	name = "柑橙雪糕"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/datum/reagent/consumable/orangejuice = 4,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/creamsicle_orange
	category = CAT_ICE

/datum/crafting_recipe/food/berry_popsicle
	name = "浆果雪糕"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/datum/reagent/consumable/berryjuice = 4,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/creamsicle_berry
	category = CAT_ICE

/datum/crafting_recipe/food/jumbo
	name = "巧克力雪糕"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 3,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/jumbo
	category = CAT_ICE

/datum/crafting_recipe/food/licorice_creamsicle
	name = "甘草雪糕"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/datum/reagent/consumable/blumpkinjuice = 4, //natural source of ammonium chloride
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/licorice_creamsicle
	category = CAT_ICE

/datum/crafting_recipe/food/meatsicle
	name = "Meatsicle"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/obj/item/food/meat/slab = 1,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/meatsicle
	category = CAT_ICE
