/obj/item/clothing/head/mothcap
	name = "蛾类飞行软帽"
	desc = "带护目镜的软皮帽，飞蛾舰队的标准装备，让你的头保持温暖，保护你的大眼睛."
	icon_state = "mothcap"
	icon = 'icons/obj/clothing/head/moth.dmi'
	worn_icon = 'icons/mob/clothing/head/moth.dmi'
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR|SHOWSPRITEEARS // SKYRAT EDIT CHANGE

/obj/item/clothing/head/mothcap/original
	desc = "带护目镜的软皮帽，飞蛾舰队的标准装备，让你的头保持温暖，保护你的大眼睛."

/obj/item/clothing/head/mothcap/original/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.2, zoom_method = ZOOM_METHOD_ITEM_ACTION, item_action_type = /datum/action/item_action/hands_free/moth_googles)

/obj/item/clothing/head/mothcap/original/item_action_slot_check(slot, mob/user, datum/action/action)
	return (slot & ITEM_SLOT_HEAD)
