
// see code/module/crafting/table.dm

// MEXICAN

/datum/crafting_recipe/food/burrito
	name ="墨西哥卷饼"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/grown/soybeans = 2
	)
	result = /obj/item/food/burrito
	category = CAT_MEXICAN

/datum/crafting_recipe/food/cheesyburrito
	name ="墨西哥芝士卷饼"
	reqs = list(
		/obj/item/food/cheese/wedge = 2,
		/obj/item/food/tortilla = 1,
		/obj/item/food/grown/soybeans = 1
	)
	result = /obj/item/food/cheesyburrito
	category = CAT_MEXICAN

/datum/crafting_recipe/food/carneburrito
	name ="墨西哥牛肉卷饼"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/soybeans = 1
	)
	result = /obj/item/food/carneburrito
	category = CAT_MEXICAN

/datum/crafting_recipe/food/fuegoburrito
	name ="墨西哥火山卷饼"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/grown/ghost_chili = 2,
		/obj/item/food/grown/soybeans = 1
	)
	result = /obj/item/food/fuegoburrito
	category = CAT_MEXICAN

/datum/crafting_recipe/food/nachos
	name ="玉米片"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/tortilla = 1
	)
	result = /obj/item/food/nachos
	category = CAT_MEXICAN

/datum/crafting_recipe/food/cheesynachos
	name ="烤干酪玉米片"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/tortilla = 1
	)
	result = /obj/item/food/cheesynachos
	category = CAT_MEXICAN

/datum/crafting_recipe/food/cubannachos
	name ="古巴玉米片"
	reqs = list(
		/datum/reagent/consumable/ketchup = 5,
		/obj/item/food/grown/chili = 2,
		/obj/item/food/tortilla = 1
	)
	result = /obj/item/food/cubannachos
	category = CAT_MEXICAN

/datum/crafting_recipe/food/taco
	name ="经典塔可"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/taco
	category = CAT_MEXICAN

/datum/crafting_recipe/food/tacoplain
	name ="普通塔可"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/meat/cutlet = 1,
	)
	result = /obj/item/food/taco/plain
	category = CAT_MEXICAN

/datum/crafting_recipe/food/enchiladas
	name = "安琪拉达"
	reqs = list(
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/chili = 2,
		/obj/item/food/tortilla = 2
	)
	result = /obj/item/food/enchiladas
	category = CAT_MEXICAN

/datum/crafting_recipe/food/stuffedlegion
	name = "塞军团"
	time = 40
	reqs = list(
		/obj/item/food/meat/steak/goliath = 1,
		/obj/item/organ/internal/monster_core/regenerative_core/legion = 1,
		/datum/reagent/consumable/ketchup = 2,
		/datum/reagent/consumable/capsaicin = 2
	)
	result = /obj/item/food/stuffedlegion
	category = CAT_MEXICAN

/datum/crafting_recipe/food/chipsandsalsa
	name = "玉米片和莎莎酱"
	reqs = list(
		/obj/item/food/cornchips = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/chipsandsalsa
	category = CAT_MEXICAN

/datum/crafting_recipe/food/classic_chimichanga
	name = "经典墨西哥炸卷饼"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/classic_chimichanga
	category = CAT_MEXICAN

/datum/crafting_recipe/food/vegetarian_chimichanga
	name = "素墨西哥炸卷饼"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/chili = 1,
	)
	result = /obj/item/food/vegetarian_chimichanga
	category = CAT_MEXICAN

/datum/crafting_recipe/food/classic_hard_shell_taco
	name = "经典塔可脆饼"
	reqs = list(
		/obj/item/food/hard_taco_shell = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/classic_hard_shell_taco
	category = CAT_MEXICAN

/datum/crafting_recipe/food/plain_hard_shell_taco
	name = "普通塔可脆饼"
	reqs = list(
		/obj/item/food/hard_taco_shell = 1,
		/obj/item/food/meat/cutlet = 1,
	)
	result = /obj/item/food/plain_hard_shell_taco
	category = CAT_MEXICAN

/datum/crafting_recipe/food/refried_beans
	name = "炸豆泥"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/grown/soybeans = 2,
		/datum/reagent/water = 5,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/refried_beans
	category = CAT_MEXICAN

/datum/crafting_recipe/food/spanish_rice
	name = "西班牙米饭"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/tomato = 1,
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
	)
	result = /obj/item/food/spanish_rice
	category = CAT_MEXICAN

/datum/crafting_recipe/food/pineapple_salsa
	name = "菠萝莎莎"
	reqs = list(
		/obj/item/food/pineappleslice = 2,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/chili = 1,
	)
	result = /obj/item/food/pineapple_salsa
	category = CAT_MEXICAN
