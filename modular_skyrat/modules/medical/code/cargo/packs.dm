/datum/supply_pack/science/synthetic_burns
	name = "Synthetic Burns Kit"
	desc = "Contains bottles of pre-chilled hercuri and dinitrogen plasmide, perfect for treating synthetic burns!"
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(/obj/item/reagent_containers/spray/hercuri/chilled = 3, /obj/item/reagent_containers/spray/dinitrogen_plasmide = 3)
	crate_name = "chilled hercuri crate"

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

/datum/supply_pack/science/synth_medkits
	name = "Mechanical Repair Kits"
	desc = "Contains a few low-grade portable synthetic medkits, useful for distributing to the crew."
	cost = CARGO_CRATE_VALUE * 4.5 // same as treatment kits
	contains = list(/obj/item/storage/medkit/robotic_repair/stocked = 4)

	crate_name = "synthetic repair kits crate"

	access_view = FALSE
	access = FALSE
	access_any = FALSE
