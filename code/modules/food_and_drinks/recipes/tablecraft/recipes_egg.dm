
// see code/module/crafting/table.dm

////////////////////////////////////////////////EGG RECIPE's////////////////////////////////////////////////

/datum/crafting_recipe/food/sausageegg
	name = "香肠煎蛋"
	reqs = list(
		/obj/item/food/sausage = 1,
		/obj/item/food/friedegg = 1,
	)
	result = /obj/item/food/eggsausage
	category = CAT_EGG

/datum/crafting_recipe/food/omelette
	name = "奶酪煎蛋卷"
	reqs = list(
		/obj/item/food/egg = 2,
		/obj/item/food/cheese/wedge = 2
	)
	result = /obj/item/food/omelette
	category = CAT_EGG

/datum/crafting_recipe/food/chocolateegg
	name = "巧克力蛋"
	reqs = list(
		/obj/item/food/boiledegg = 1,
		/obj/item/food/chocolatebar = 1
	)
	result = /obj/item/food/chocolateegg
	category = CAT_EGG

/datum/crafting_recipe/food/eggsbenedict
	name = "班尼迪克蛋"
	reqs = list(
		/obj/item/food/friedegg = 1,
		/obj/item/food/meat/steak = 1,
		/obj/item/food/breadslice/plain = 1,
	)
	result = /obj/item/food/benedict
	category = CAT_EGG

/datum/crafting_recipe/food/eggbowl
	name = "鸡蛋盖饭"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/corn = 1
	)
	result = /obj/item/food/salad/eggbowl
	category = CAT_EGG

/datum/crafting_recipe/food/wrap
	name = "鸡蛋卷"
	reqs = list(/datum/reagent/consumable/soysauce = 10,
		/obj/item/food/friedegg = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/eggwrap
	category = CAT_EGG

/datum/crafting_recipe/food/chawanmushi
	name = "日式蒸蛋"
	reqs = list(
		/datum/reagent/water = 5,
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/food/boiledegg = 2,
		/obj/item/food/grown/mushroom/chanterelle = 1
	)
	result = /obj/item/food/chawanmushi
	category = CAT_EGG

