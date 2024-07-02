/datum/action/cooldown/spell/pointed/moon_smile
	name = "月的微笑"
	desc = "让你将月亮的目光转向某人， \
			使目标暂时失明、失聪、沉默并被击倒."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "moon_smile"
	ranged_mousepointer = 'icons/effects/mouse_pointers/moon_target.dmi'

	sound = 'sound/magic/blind.ogg'
	school = SCHOOL_FORBIDDEN
	cooldown_time = 20 SECONDS

	invocation = "Mo'N S'M'LE"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	cast_range = 6

	active_msg = "你准备让某人看到真实..."

/datum/action/cooldown/spell/pointed/moon_smile/can_cast_spell(feedback = TRUE)
	return ..() && isliving(owner)

/datum/action/cooldown/spell/pointed/moon_smile/is_valid_target(atom/cast_on)
	return ..() && ishuman(cast_on)

/datum/action/cooldown/spell/pointed/moon_smile/cast(mob/living/carbon/human/cast_on)
	. = ..()
	/// The duration of these effects are based on sanity, mainly for flavor but also to make it a weaker alpha strike
	var/maximum_duration = 15 SECONDS
	var/moon_smile_duration = ((SANITY_MAXIMUM - cast_on.mob_mood.sanity) / (SANITY_MAXIMUM - SANITY_INSANE)) * maximum_duration
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(cast_on, span_notice("月亮的微笑不再对着你了."))
		to_chat(owner, span_warning("月亮不会对着他们微笑."))
		return FALSE

	playsound(cast_on, 'sound/hallucinations/i_see_you1.ogg', 50, 1)
	to_chat(cast_on, span_warning("你的眼睛痛苦地流泪，你的耳朵淌出鲜血，你嘴唇无法张开！月亮在向你微笑!!!"))
	cast_on.adjust_temp_blindness(moon_smile_duration + 1 SECONDS)
	cast_on.set_eye_blur_if_lower(moon_smile_duration + 2 SECONDS)

	var/obj/item/organ/internal/ears/ears = cast_on.get_organ_slot(ORGAN_SLOT_EARS)
	//adjustEarDamage takes deafness duration parameter in one unit per two seconds, instead of the normal time, so we divide by two seconds
	ears?.adjustEarDamage(0, (moon_smile_duration + 1 SECONDS) / (2 SECONDS))

	cast_on.adjust_silence(moon_smile_duration + 1 SECONDS)
	cast_on.add_mood_event("moon_smile", /datum/mood_event/moon_smile)

	// Only knocksdown if the target has a low enough sanity
	if(cast_on.mob_mood.sanity < 40)
		cast_on.AdjustKnockdown(2 SECONDS)
	//Lowers sanity
	cast_on.mob_mood.set_sanity(cast_on.mob_mood.sanity - 20)
	return TRUE
