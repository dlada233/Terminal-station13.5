// Currently unused
/datum/action/cooldown/spell/touch/mad_touch
	name = "疯狂之触" // 疯狂的摸
	desc = "吸走目标理智的触摸咒语"
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "mad_touch"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 15 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_MIND

/datum/action/cooldown/spell/touch/mad_touch/is_valid_target(atom/cast_on)
	if(!ishuman(cast_on))
		return FALSE
	var/mob/living/carbon/human/human_cast_on = cast_on
	if(!human_cast_on.mind || !human_cast_on.mob_mood || IS_HERETIC_OR_MONSTER(human_cast_on))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/touch/mad_touch/on_antimagic_triggered(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	victim.visible_message(
		span_danger("咒语在[victim]身上弹开!"),
		span_danger("咒语从你身上弹开了!"),
	)

/datum/action/cooldown/spell/touch/mad_touch/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/carbon/human/victim, mob/living/carbon/caster)
	to_chat(caster, span_warning("[victim.name]已经被诅咒了!"))
	victim.add_mood_event("gates_of_mansus", /datum/mood_event/gates_of_mansus)
	return TRUE
