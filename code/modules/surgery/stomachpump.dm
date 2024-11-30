/datum/surgery/stomach_pump
	name = "洗胃"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/stomach_pump,
		/datum/surgery_step/close,
	)

/datum/surgery/stomach_pump/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/stomach/target_stomach = target.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(HAS_TRAIT(target, TRAIT_HUSK))
		return FALSE
	if(!target_stomach)
		return FALSE
	return ..()

//Working the stomach by hand in such a way that you induce vomiting.
/datum/surgery_step/stomach_pump
	name = "洗胃 (手)"
	accept_hand = TRUE
	repeatable = TRUE
	time = 20
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/stomach_pump/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始给[target]洗胃..."),
		span_notice("[user]开始给[target]洗胃。"),
		span_notice("[user]开始按压[target]的胸部."),
	)
	display_pain(target, "你感到肚子里一阵可怕的晃动！你要吐了！")

/datum/surgery_step/stomach_pump/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_notice("[user]迫使[target_human]呕吐，清空了胃部的一些化学物质！"),
			span_notice("[user]迫使[target_human]呕吐，清空了胃部的一些化学物质！"),
			span_notice("[user]迫使[target_human]呕吐！"),
		)
		target_human.vomit((MOB_VOMIT_MESSAGE | MOB_VOMIT_STUN), lost_nutrition = 20, purge_ratio = 0.67) //higher purge ratio than regular vomiting
	return ..()

/datum/surgery_step/stomach_pump/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("你搞砸了，弄伤了[target_human]的胸部！"),
			span_warning("[user]搞砸了，弄伤了[target_human]的胸部！"),
			span_warning("[user]搞砸了！"),
		)
		target_human.adjustOrganLoss(ORGAN_SLOT_STOMACH, 5)
		target_human.adjustBruteLoss(5)
