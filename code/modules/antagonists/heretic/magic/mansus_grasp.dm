/datum/action/cooldown/spell/touch/mansus_grasp
	name = "漫宿之握"
	desc = "这种咒语能让你通过触摸吸收古神们的力量."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "mansus_grasp"
	sound = 'sound/items/welder.ogg'

	school = SCHOOL_EVOCATION
	cooldown_time = 10 SECONDS

	invocation = "R'CH T'H TR'TH!"
	invocation_type = INVOCATION_SHOUT
	// Mimes can cast it. Chaplains can cast it. Anyone can cast it, so long as they have a hand.
	spell_requirements = SPELL_CASTABLE_WITHOUT_INVOCATION

	hand_path = /obj/item/melee/touch_attack/mansus_fist

/datum/action/cooldown/spell/touch/mansus_grasp/is_valid_target(atom/cast_on)
	return TRUE // This baby can hit anything

/datum/action/cooldown/spell/touch/mansus_grasp/can_cast_spell(feedback = TRUE)
	return ..() && (!!IS_HERETIC(owner) || !!IS_LUNATIC(owner))

/datum/action/cooldown/spell/touch/mansus_grasp/on_antimagic_triggered(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	victim.visible_message(
		span_danger("咒语从[victim]身上弹开!"),
		span_danger("咒语从你身上弹开!"),
	)

/datum/action/cooldown/spell/touch/mansus_grasp/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(!isliving(victim))
		return FALSE

	if(SEND_SIGNAL(caster, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, victim) & COMPONENT_BLOCK_HAND_USE)
		return FALSE

	var/mob/living/living_hit = victim
	living_hit.apply_damage(10, BRUTE, wound_bonus = CANT_WOUND)
	if(iscarbon(victim))
		var/mob/living/carbon/carbon_hit = victim
		carbon_hit.adjust_timed_status_effect(4 SECONDS, /datum/status_effect/speech/slurring/heretic)
		carbon_hit.AdjustKnockdown(5 SECONDS)
		carbon_hit.adjustStaminaLoss(80)

	return TRUE

/datum/action/cooldown/spell/touch/mansus_grasp/cast_on_secondary_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(isliving(victim)) // if it's a living mob, go with our normal afterattack
		return SECONDARY_ATTACK_CALL_NORMAL

	if(SEND_SIGNAL(caster, COMSIG_HERETIC_MANSUS_GRASP_ATTACK_SECONDARY, victim) & COMPONENT_USE_HAND)
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/melee/touch_attack/mansus_fist
	name = "漫宿之握"
	desc = "一阵不详的灵光，扭曲现实的流动. \
		对目标能造成击倒、轻微创伤和高耐力伤害. \
		随着你学习到更多有关漫宿的知识，它可能会获得额外的增益效果."
	icon_state = "mansus"
	inhand_icon_state = "mansus"

/obj/item/melee/touch_attack/mansus_fist/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/effect_remover, \
		success_feedback = "你移除了 %THEEFFECT.", \
		tip_text = "清楚符文", \
		on_clear_callback = CALLBACK(src, PROC_REF(after_clear_rune)), \
		effects_we_clear = list(/obj/effect/heretic_rune), \
		time_to_remove = 0.4 SECONDS)

/*
 * Callback for effect_remover component.
 */
/obj/item/melee/touch_attack/mansus_fist/proc/after_clear_rune(obj/effect/target, mob/living/user)
	new /obj/effect/temp_visual/drawing_heretic_rune/fail(target.loc, target.greyscale_colors)
	var/datum/action/cooldown/spell/touch/mansus_grasp/grasp = spell_which_made_us?.resolve()
	grasp?.spell_feedback(user)

	remove_hand_with_no_refund(user)

/obj/item/melee/touch_attack/mansus_fist/ignition_effect(atom/to_light, mob/user)
	. = span_notice("[user]将手指搭在了[to_light]上，用指尖的奇异能量将其点燃了. 酷毙了!")
	remove_hand_with_no_refund(user)

/obj/item/melee/touch_attack/mansus_fist/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]用病态的手遮住自己的脸! 看起来是在试图自杀!"))
	var/mob/living/carbon/carbon_user = user //iscarbon already used in spell's parent
	var/datum/action/cooldown/spell/touch/mansus_grasp/source = spell_which_made_us?.resolve()
	if(QDELETED(source) || !IS_HERETIC(user))
		return SHAME

	if(user.can_block_magic(source.antimagic_flags))
		return SHAME

	var/escape_our_torment = 0
	while(carbon_user.stat == CONSCIOUS)
		if(QDELETED(src) || QDELETED(user))
			return SHAME
		if(escape_our_torment > 20) //Stops us from infinitely stunning ourselves if we're just not taking the damage
			return FIRELOSS

		if(prob(70))
			carbon_user.adjustFireLoss(20)
			playsound(carbon_user, 'sound/effects/wounds/sizzle1.ogg', 70, vary = TRUE)
			if(prob(50))
				carbon_user.emote("scream")
				carbon_user.adjust_stutter(26 SECONDS)

		source.cast_on_hand_hit(src, user, user)

		escape_our_torment++
		stoplag(0.4 SECONDS)
	return FIRELOSS
