/datum/quirk/item_quirk/clown_enjoyer
	name = "Clown Enjoyer-小丑爱好者"
	desc = "你超爱小丑的滑稽动作，戴上你的小丑别针会让你情绪高涨."
	icon = FA_ICON_MAP_PIN
	value = 2
	mob_trait = TRAIT_CLOWN_ENJOYER
	gain_text = span_notice("你是个小丑爱好者.")
	lose_text = span_danger("小丑看起来不那么有意思了.")
	medical_record_text = "患者报告说他是一个狂热的小丑爱好者."
	mail_goodies = list(
		/obj/item/bikehorn,
		/obj/item/stamp/clown,
		/obj/item/megaphone/clown,
		/obj/item/clothing/shoes/clown_shoes,
		/obj/item/bedsheet/clown,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/storage/backpack/clown,
		/obj/item/storage/backpack/duffelbag/clown,
		/obj/item/toy/crayon/rainbow,
		/obj/item/toy/figure/clown,
		/obj/item/tank/internals/emergency_oxygen/engi/clown/n2o,
		/obj/item/tank/internals/emergency_oxygen/engi/clown/bz,
		/obj/item/tank/internals/emergency_oxygen/engi/clown/helium,
	)

/datum/quirk/item_quirk/clown_enjoyer/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/clown_enjoyer_pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/clown_enjoyer/add(client/client_source)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.show_to(quirk_holder)
