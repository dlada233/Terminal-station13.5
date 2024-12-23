/datum/action/changeling/defib_grasp
	name = "除颤断手"
	desc = "我们可以在静滞状态中做好准备，一旦敌人试图给我们进行除颤，我们就会将其手臂扯下并立刻从静滞状态中恢复."
	helptext = "这一个被动技能，当我们死亡或进入静滞状态时有人将除颤器放在我们胸部上时自动触发，即使是除颤者是赛博也能将其暂时击晕."
	owner_has_control = FALSE
	dna_cost = 0
	disabled_by_fire = FALSE

	/// Flags to pass to fully heal when we get zapped
	var/heal_flags = HEAL_DAMAGE|HEAL_BODY|HEAL_STATUS|HEAL_CC_STATUS

/datum/action/changeling/defib_grasp/on_purchase(mob/user, is_respec)
	. = ..()
	RegisterSignal(user, COMSIG_DEFIBRILLATOR_PRE_HELP_ZAP, PROC_REF(on_defibbed))

/// Signal proc for [COMSIG_DEFIBRILLATOR_PRE_HELP_ZAP].
/datum/action/changeling/defib_grasp/proc/on_defibbed(mob/living/carbon/source, mob/living/defibber, obj/item/shockpaddles/defib)
	SIGNAL_HANDLER

	if(source.stat != DEAD && !HAS_TRAIT_FROM(source, TRAIT_FAKEDEATH, CHANGELING_TRAIT))
		return

	INVOKE_ASYNC(src, PROC_REF(execute_defib), source, defibber, defib)
	return COMPONENT_DEFIB_STOP

/// Executes the defib action, causing the changeling to fully heal and get up.
/datum/action/changeling/defib_grasp/proc/execute_defib(mob/living/carbon/changeling, mob/living/defibber, obj/item/shockpaddles/defib)
	remove_arms(changeling, defibber, defib)

	if(changeling.stat == DEAD)
		changeling.revive(heal_flags)
	else
		changeling.fully_heal(heal_flags)

	changeling.buckled?.unbuckle_mob(changeling) // get us off of stasis beds please
	changeling.set_resting(FALSE)
	changeling.adjust_jitter(20 SECONDS)
	changeling.emote("scream")
	playsound(changeling, 'sound/magic/demon_consume.ogg', 50, TRUE)

	// Mimics some real defib stuff (wish this was more generalized)
	playsound(defib, SFX_BODYFALL, 50, TRUE)
	playsound(defib, 'sound/machines/defib_zap.ogg', 75, TRUE, -1)
	playsound(defib, 'sound/machines/defib_success.ogg', 50, FALSE) // I guess
	defib.shock_pulling(30, changeling)

/// Removes the arms of the defibber if they're a carbon, and stuns them for a bit.
/// If they're a cyborg, they'll just get stunned instead.
/datum/action/changeling/defib_grasp/proc/remove_arms(mob/living/carbon/changeling, mob/living/defibber, obj/item/shockpaddles/defib)

	if(iscyborg(defibber))
		if(defibber.flash_act(affect_silicon = TRUE))
			to_chat(defibber, span_userdanger("[changeling]突然苏醒，你的传感器一下子过载了!"))
			// run default visible message regardless, no overt indication of the cyborg being overloaded to watchers

	else
		defibber.Stun(4 SECONDS) // stuck defibbing

		if(iscarbon(defibber))
			var/removed_arms = 0
			var/mob/living/carbon/carbon_defibber = defibber
			for(var/obj/item/bodypart/arm/limb in carbon_defibber.bodyparts)
				if(limb.dismember(silent = FALSE))
					removed_arms++
					qdel(limb)

			if(removed_arms)
				// OH GOOD HEAVENS
				defibber.adjust_jitter(3 MINUTES)
				defibber.adjust_dizzy(1 MINUTES)
				defibber.adjust_stutter(1 MINUTES)
				defibber.adjust_eye_blur(10 SECONDS)
				defibber.emote("scream")

				changeling.visible_message(
					span_bolddanger("[changeling]突然苏醒，连带着[defib]扯下了[defibber]的[removed_arms >= 2 ? "" : "其中一条"]手臂!"),
					vision_distance = COMBAT_MESSAGE_RANGE,
					ignored_mobs = list(changeling, defibber),
				)
				to_chat(changeling, span_changeling("[defib]的电流穿过我们，将我们从静滞状态中唤醒! \
					靠着刚刚的那股能量，我们扯下了[defibber]的[removed_arms >= 2 ? "" : "其中一条"]手臂!"))
				to_chat(defibber, span_userdanger("[changeling]突然醒来，扯下了你的[removed_arms >= 2 ? "" : "其中一条"]手臂!"))
				return // no default message if we got an arm

	changeling.visible_message(
		span_bolddanger("[changeling]突然苏醒!"),
		vision_distance = COMBAT_MESSAGE_RANGE,
		ignored_mobs = changeling,
	)
	to_chat(changeling, span_changeling("[defib]的电流穿过我们，将我们从静滞状态中唤醒!"))
