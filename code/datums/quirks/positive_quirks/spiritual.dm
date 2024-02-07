/datum/quirk/item_quirk/spiritual
	name = "Spiritual-心诚则灵"
	desc = "你心中怀有一种精神信仰，无论是对上帝、自然万物还是宇宙的神秘法则.你从圣洁之人的存在中获得慰藉，并坚信你的祈祷比别人更特别.处在教堂里会让你心情愉悦."
	icon = FA_ICON_BIBLE
	value = 2 /// SKYRAT EDIT - Quirk Rebalance - Original: value = 4
	mob_trait = TRAIT_SPIRITUAL
	gain_text = span_notice("你对一种至高力量有着信仰.")
	lose_text = span_danger("你失去了信仰!")
	medical_record_text = "患者报告称有着对一种至高力量的信仰."
	mail_goodies = list(
		/obj/item/book/bible/booze,
		/obj/item/reagent_containers/cup/glass/bottle/holywater,
		/obj/item/bedsheet/chaplain,
		/obj/item/toy/cards/deck/tarot,
		/obj/item/storage/fancy/candle_box,
	)

/datum/quirk/item_quirk/spiritual/add_unique(client/client_source)
	give_item_to_holder(/obj/item/storage/fancy/candle_box, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
	give_item_to_holder(/obj/item/storage/box/matches, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
