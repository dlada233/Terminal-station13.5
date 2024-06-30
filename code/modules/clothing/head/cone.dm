/obj/item/clothing/head/cone
	desc = "这圆锥正在警告你!"
	name = "警示锥"
	icon = 'icons/obj/service/janitor.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	icon_state = "cone"
	inhand_icon_state = null
	worn_y_offset = 1
	force = 1
	throwforce = 3
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("警告", "提醒", "砸")
	attack_verb_simple = list("警告", "提醒", "砸")
	resistance_flags = NONE

/obj/item/clothing/head/cone/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha)


