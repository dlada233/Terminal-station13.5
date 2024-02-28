/datum/quirk/item_quirk/mime_fan
	name = "Mime Fan-默剧迷"
	desc = "你是默剧演员滑稽动作的粉丝，戴上你的默剧别针会使你情绪高涨."
	icon = FA_ICON_THUMBTACK
	value = 2
	mob_trait = TRAIT_MIME_FAN
	gain_text = span_notice("你是个默剧爱好者.")
	lose_text = span_danger("默剧演员看起来不那么有意思了.")
	medical_record_text = "患者报告说他是一个狂热的默剧爱好者"
	mail_goodies = list(
		/obj/item/toy/crayon/mime,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/storage/backpack/mime,
		/obj/item/clothing/under/rank/civilian/mime,
		/obj/item/reagent_containers/cup/glass/bottle/bottleofnothing,
		/obj/item/stamp/mime,
		/obj/item/storage/box/survival/hug/black,
		/obj/item/bedsheet/mime,
		/obj/item/clothing/shoes/sneakers/mime,
		/obj/item/toy/figure/mime,
		/obj/item/toy/crayon/spraycan/mimecan,
	)

/datum/quirk/item_quirk/mime_fan/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/mime_fan_pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/mime_fan/add(client/client_source)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.show_to(quirk_holder)
