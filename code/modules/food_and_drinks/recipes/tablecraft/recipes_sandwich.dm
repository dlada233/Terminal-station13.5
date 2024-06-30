
// see code/datums/recipe.dm


// see code/module/crafting/table.dm

////////////////////////////////////////////////SANDWICHES////////////////////////////////////////////////

/datum/crafting_recipe/food/sandwich
	name = "三明治"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/meat/steak = 1,
		/obj/item/food/cheese/wedge = 1
	)
	result = /obj/item/food/sandwich
	category = CAT_SANDWICH

/datum/crafting_recipe/food/cheese_sandwich
	name = "奶酪三明治"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/cheese/wedge = 2
	)
	result = /obj/item/food/sandwich/cheese
	category = CAT_SANDWICH

/datum/crafting_recipe/food/slimesandwich
	name = "果酱三明治"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/food/breadslice/plain = 2,
	)
	result = /obj/item/food/sandwich/jelly/slime
	category = CAT_SANDWICH

/datum/crafting_recipe/food/cherrysandwich
	name = "果酱三明治"
	reqs = list(
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/food/breadslice/plain = 2,
	)
	result = /obj/item/food/sandwich/jelly/cherry
	category = CAT_SANDWICH

/datum/crafting_recipe/food/notasandwich
	name = "非三明治"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/clothing/mask/fakemoustache = 1
	)
	result = /obj/item/food/sandwich/notasandwich
	category = CAT_SANDWICH

/datum/crafting_recipe/food/hotdog
	name = "热狗"
	reqs = list(
		/datum/reagent/consumable/ketchup = 5,
		/obj/item/food/bun = 1,
		/obj/item/food/sausage = 1
	)
	result = /obj/item/food/hotdog
	category = CAT_SANDWICH

/datum/crafting_recipe/food/danish_hotdog
	name = "丹麦热狗"
	reqs = list(
		/datum/reagent/consumable/ketchup = 5,
		/obj/item/food/bun = 1,
		/obj/item/food/sausage = 1,
		/obj/item/food/pickle = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/danish_hotdog
	category = CAT_SANDWICH

/datum/crafting_recipe/food/blt
	name = "BLT"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/meat/bacon = 2,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/sandwich/blt
	category = CAT_SANDWICH

/datum/crafting_recipe/food/peanut_butter_jelly_sandwich
	name = "花生果酱三明治"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/datum/reagent/consumable/peanut_butter = 5,
		/datum/reagent/consumable/cherryjelly = 5
	)
	result = /obj/item/food/sandwich/peanut_butter_jelly
	category = CAT_SANDWICH

/datum/crafting_recipe/food/peanut_butter_banana_sandwich
	name = "花生香蕉三明治"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/sandwich/peanut_butter_banana
	category = CAT_SANDWICH

/datum/crafting_recipe/food/philly_cheesesteak
	name = "费城芝士牛排三明治"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/sandwich/philly_cheesesteak
	category = CAT_SANDWICH

/datum/crafting_recipe/food/death_sandwich
	name = "死亡三明治"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/salami = 4,
		/obj/item/food/meatball = 4,
		/obj/item/food/grown/tomato = 1,
	)
	result = /obj/item/food/sandwich/death
	category = CAT_SANDWICH
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/food/toast_sandwich
	name = "吐司三明治"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/butteredtoast = 1,
	)
	result = /obj/item/food/sandwich/toast_sandwich
	category = CAT_SANDWICH
