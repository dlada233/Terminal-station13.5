/datum/supply_pack/science/chilled_hercuri
	name = "赫库里冷却喷雾包"
	desc = "包含两瓶已冷却的Hercuri-赫库里冷却，每瓶含100u，用于处理合成人烧伤."
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(/obj/item/reagent_containers/spray/hercuri/chilled = 2)
	crate_name = "赫库里冷却喷雾箱"

	access_view = FALSE
	access = FALSE
	access_any = FALSE

/datum/supply_pack/science/synth_treatment_kits
	name = "合成人治疗套装"
	desc = "包含两个合成人治疗包."
	cost = CARGO_CRATE_VALUE * 4.5
	contains = list(/obj/item/storage/backpack/duffelbag/synth_treatment_kit = 2)
	crate_name = "合成人治疗套装箱"

	access_view = FALSE
	access = FALSE
	access_any = FALSE

/datum/supply_pack/science/synth_healing_chems
	name = "合成人药品包"
	desc = "含有多种合成人专用药品，包含有:2份液体焊料，2份纳米浆液，2份系统清洁剂."
	cost = CARGO_CRATE_VALUE * 7 // rarely made, so it should be expensive(?)
	contains = list(
		/obj/item/storage/pill_bottle/liquid_solder = 2,
		/obj/item/storage/pill_bottle/nanite_slurry = 2,
		/obj/item/storage/pill_bottle/system_cleaner = 2
	)
	crate_name = "合成人药品箱"

	access_view = FALSE
	access = FALSE
	access_any = FALSE
