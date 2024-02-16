/**
 * todo: make this a supply_pack/custom. Drop pog? ohoho yes. Would be VERY fun.
 */
/datum/supply_pack/market_materials
	name = "一块蕉板"
	desc = "Australicus 工业采矿公司在这类板材的现行市场价格."
	cost = CARGO_CRATE_VALUE * 2
	// contains = list(/obj/item/stack/sheet/mineral/bananium)
	crate_name = "材料板材箱"
	group = "气罐&材料"
	/// What material we are trying to buy sheets of?
	var/datum/material/material
	/// How many sheets of the material we are trying to buy at once?
	var/amount

/datum/supply_pack/market_materials/get_cost()
	for(var/datum/material/mat as anything in SSstock_market.materials_prices)
		if(material == mat)
			return SSstock_market.materials_prices[mat] * amount

/datum/supply_pack/market_materials/fill(obj/structure/closet/crate/C)
	. = ..()
	new material.sheet_type(C, amount)

/datum/supply_pack/market_materials/iron
	name = "铁板"
	crate_name = "铁板箱"
	material = /datum/material/iron
MARKET_QUANTITY_HELPERS(/datum/supply_pack/market_materials/iron)


/datum/supply_pack/market_materials/gold
	name = "黄金"
	crate_name = "黄金箱"
	material = /datum/material/gold
MARKET_QUANTITY_HELPERS(/datum/supply_pack/market_materials/gold)
