/datum/supply_pack/materials
	group = "气罐&材料"

/datum/supply_pack/materials/cardboard50
	name = "50块纸板"
	desc = "搭建一个纸板城堡."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/stack/sheet/cardboard/fifty)
	crate_name = "纸板箱"

/datum/supply_pack/materials/license50
	name = "50块空车牌"
	desc = "打一堆车牌拿来卖."
	cost = CARGO_CRATE_VALUE * 2  // 50 * 25 + 700 - 1000 = 950 credits profit
	access_view = ACCESS_BRIG_ENTRANCE
	contains = list(/obj/item/stack/license_plates/empty/fifty)
	crate_name = "空车牌箱"

/datum/supply_pack/materials/plastic50
	name = "50块塑料板"
	desc = "用50张塑料板制作无穷无尽的玩具!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/stack/sheet/plastic/fifty)
	crate_name = "塑料板箱"

/datum/supply_pack/materials/sandstone30
	name = "30块砂岩砖"
	desc = "既不是沙土也不是石头，这三十块可以完成整个街区的装修工作."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/stack/sheet/mineral/sandstone/thirty)
	crate_name = "砂岩转箱"

/datum/supply_pack/materials/wood50
	name = "50块木板"
	desc = "把货仓无聊的金属地板改造成更有格调的\
		木地板!"
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/stack/sheet/mineral/wood/fifty)
	crate_name = "木板箱"

/datum/supply_pack/materials/foamtank
	name = "消防泡沫箱"
	desc = "内含一水箱的消防泡沫，也被人称为\"等离子克星.\""
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/structure/reagent_dispensers/foamtank)
	crate_name = "消防泡沫箱"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/fueltank
	name = "燃料箱"
	desc = "包含一个焊接油箱，注意，高度易燃."
	cost = CARGO_CRATE_VALUE * 1.6
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	crate_name = "燃料箱"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/hightankfuel
	name = "大型燃料箱"
	desc = "包含一个高容量焊接油箱，远离明火."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ENGINEERING
	contains = list(/obj/structure/reagent_dispensers/fueltank/large)
	crate_name = "高容量焊接油箱"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/watertank
	name = "水箱"
	desc = "一大箱被称为一氧化二氢的化学液体，听起来很危险."
	cost = CARGO_CRATE_VALUE * 1.2
	contains = list(/obj/structure/reagent_dispensers/watertank)
	crate_name = "水箱"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/gas_canisters
	cost = CARGO_CRATE_VALUE * 0.05
	contains = list(/obj/machinery/portable_atmospherics/canister)
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/gas_canisters/generate_supply_packs()
	var/list/canister_packs = list()

	var/obj/machinery/portable_atmospherics/canister/fakeCanister = /obj/machinery/portable_atmospherics/canister
	// This is the amount of moles in a default canister
	var/moleCount = (initial(fakeCanister.maximum_pressure) * initial(fakeCanister.filled)) * initial(fakeCanister.volume) / (R_IDEAL_GAS_EQUATION * T20C)

	for(var/gasType in GLOB.meta_gas_info)
		var/datum/gas/gas = gasType
		var/name = initial(gas.name)
		if(!initial(gas.purchaseable))
			continue
		var/datum/supply_pack/materials/pack = new
		pack.name = "[name]气罐"
		pack.desc = "内含[name]的气罐."
		if(initial(gas.dangerous))
			pack.access = ACCESS_ATMOSPHERICS
			pack.access_view = ACCESS_ATMOSPHERICS
		pack.crate_name = "[name]气罐箱"
		pack.id = "[type]([name])"

		pack.cost = cost + moleCount * initial(gas.base_value) * 1.6
		pack.cost = CEILING(pack.cost, 10)

		pack.contains = list(GLOB.gas_id_to_canister[initial(gas.id)])

		pack.crate_type = crate_type

		canister_packs += pack

	return canister_packs
