/datum/quirk/item_quirk/tagger
	name = "Tagger-涂鸦绘者"
	desc = "你是一个经验老道的艺术家，人们会对你的涂鸦感到印象深刻，并且你使用绘画用品时获得两倍的使用次数."
	icon = FA_ICON_SPRAY_CAN
	value = 4
	mob_trait = TRAIT_TAGGER
	gain_text = span_notice("你知道如何快速高效地在墙壁上涂鸦.")
	lose_text = span_danger("你忘记了如何涂鸦.")
	medical_record_text = "患者近期有疑似吸食油漆的案例，已就诊."
	mail_goodies = list(
		/obj/item/toy/crayon/spraycan,
		/obj/item/canvas/nineteen_nineteen,
		/obj/item/canvas/twentythree_nineteen,
		/obj/item/canvas/twentythree_twentythree
	)

/datum/quirk_constant_data/tagger
	associated_typepath = /datum/quirk/item_quirk/tagger
	customization_options = list(/datum/preference/color/paint_color)

/datum/quirk/item_quirk/tagger/add_unique(client/client_source)
	var/obj/item/toy/crayon/spraycan/can = new
	can.set_painting_tool_color(client_source?.prefs.read_preference(/datum/preference/color/paint_color))
	give_item_to_holder(can, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
