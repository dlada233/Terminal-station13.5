/datum/quirk/night_vision
	name = "Night Vision-夜视"
	desc = "你在漆黑无光的情况下比常人看得更清楚一些."
	icon = FA_ICON_MOON
	value = 4
	mob_trait = TRAIT_NIGHT_VISION
	gain_text = span_notice("阴影处似乎变得明亮了些.")
	lose_text = span_danger("四周看起来有点更暗了.")
	medical_record_text = "患者双眼对黑暗环境的适应能力超出平均水平."
	mail_goodies = list(
		/obj/item/flashlight/flashdark,
		/obj/item/food/grown/mushroom/glowshroom/shadowshroom,
		/obj/item/skillchip/light_remover,
	)

/datum/quirk/night_vision/add(client/client_source)
	refresh_quirk_holder_eyes()

/datum/quirk/night_vision/remove()
	refresh_quirk_holder_eyes()

/datum/quirk/night_vision/proc/refresh_quirk_holder_eyes()
	var/mob/living/carbon/human/human_quirk_holder = quirk_holder
	var/obj/item/organ/internal/eyes/eyes = human_quirk_holder.get_organ_by_type(/obj/item/organ/internal/eyes)
	if(!eyes || eyes.lighting_cutoff)
		return
	// We've either added or removed TRAIT_NIGHT_VISION before calling this proc. Just refresh the eyes.
	eyes.refresh()
