/// Exploration drone unlockables ///

/datum/supply_pack/exploration
	special = TRUE
	group = "未知来源物"

/datum/supply_pack/exploration/scrapyard
	name = "废品箱"
	desc = "包含各种废品的外来板条箱."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/relic,
					/obj/item/broken_bottle,
					/obj/item/pickaxe/rusted)
	crate_name = "废品箱"

/datum/supply_pack/exploration/catering
	name = "餐饮箱"
	desc = "没做饭？没问题！注意：食品质量因供应对象而异"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/food/sandwich = 5)
	crate_name = "外来餐饮箱"

/datum/supply_pack/exploration/catering/fill(obj/structure/closet/crate/crate)
	. = ..()
	if(!prob(30))
		return

	for(var/obj/item/food/food_item in crate)
		// makes all of our items GROSS
		food_item.name = "不可食用的[food_item.name]"
		food_item.AddComponent(/datum/component/edible, foodtypes = GROSS)

/datum/supply_pack/exploration/shrubbery
	name = "灌木箱"
	desc = "满是灌木的板条箱."
	cost = CARGO_CRATE_VALUE * 5
	crate_name = "灌木箱"
	var/shrub_amount = 8

/datum/supply_pack/exploration/shrubbery/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to shrub_amount)
		new /obj/item/grown/shrub(C)
