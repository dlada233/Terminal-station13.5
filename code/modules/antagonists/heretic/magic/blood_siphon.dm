/datum/action/cooldown/spell/pointed/blood_siphon
	name = "吸血术"
	desc = "指向性咒语，伤害敌人的同时恢复自身. \
		此外还有概率将自身的重伤口转移到目标身上."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "blood_siphon"
	ranged_mousepointer = 'icons/effects/mouse_pointers/throw_target.dmi'

	school = SCHOOL_FORBIDDEN
	cooldown_time = 15 SECONDS

	invocation = "FL'MS O'ET'RN'ITY."
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	cast_range = 6

/datum/action/cooldown/spell/pointed/blood_siphon/can_cast_spell(feedback = TRUE)
	return ..() && isliving(owner)

/datum/action/cooldown/spell/pointed/blood_siphon/is_valid_target(atom/cast_on)
	return ..() && isliving(cast_on)

/datum/action/cooldown/spell/pointed/blood_siphon/cast(mob/living/cast_on)
	. = ..()
	playsound(owner, 'sound/magic/demon_attack1.ogg', 75, TRUE)
	if(cast_on.can_block_magic())
		owner.balloon_alert(owner, "咒语被阻塞!")
		cast_on.visible_message(
			span_danger("咒语从[cast_on]的身上弹开了!"),
			span_danger("咒语从你的身上弹开了!"),
		)
		return FALSE

	cast_on.visible_message(
		span_danger("[cast_on]在一阵血光笼罩下变得脸色苍白!"),
		span_danger("你在一阵血光笼罩下变得脸色苍白!"),
	)

	var/mob/living/living_owner = owner
	cast_on.adjustBruteLoss(20)
	living_owner.adjustBruteLoss(-20)

	if(!cast_on.blood_volume || !living_owner.blood_volume)
		return TRUE

	cast_on.blood_volume -= 20
	if(living_owner.blood_volume < BLOOD_VOLUME_MAXIMUM) // we dont want to explode from casting
		living_owner.blood_volume += 20

	if(!iscarbon(cast_on) || !iscarbon(owner))
		return TRUE

	var/mob/living/carbon/carbon_target = cast_on
	var/mob/living/carbon/carbon_user = owner
	for(var/obj/item/bodypart/bodypart as anything in carbon_user.bodyparts)
		for(var/datum/wound/iter_wound as anything in bodypart.wounds)
			if(prob(50))
				continue
			var/obj/item/bodypart/target_bodypart = locate(bodypart.type) in carbon_target.bodyparts
			if(!target_bodypart)
				continue
			iter_wound.remove_wound()
			iter_wound.apply_wound(target_bodypart)

	return TRUE
