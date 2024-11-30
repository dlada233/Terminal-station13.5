/datum/surgery/brain_surgery
	name = "大脑手术"
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = NONE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/fix_brain,
		/datum/surgery_step/close,
	)

/datum/surgery_step/fix_brain
	name = "修复大脑 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 85,
		TOOL_SCREWDRIVER = 35,
		/obj/item/pen = 15) //don't worry, pouring some alcohol on their open brain will get that chance to 100
	repeatable = TRUE
	time = 100 //long and complicated
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery/brain_surgery/can_start(mob/user, mob/living/carbon/target)
	return target.get_organ_slot(ORGAN_SLOT_BRAIN) && ..()

/datum/surgery_step/fix_brain/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始修复[target]的大脑..."),
		span_notice("[user]开始修复[target]的大脑."),
		span_notice("[user]开始对[target]的大脑进行手术."),
	)
	display_pain(target, "你的头部传来难以想象的剧痛!")

/datum/surgery_step/fix_brain/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("你成功修复了[target]的大脑."),
		span_notice("[user]成功修复了[target]的大脑!"),
		span_notice("[user]完成了对[target]大脑的手术."),
	)
	display_pain(target, "你头部的疼痛减轻了，思考变得稍微容易了一些!")
	if(target.mind?.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	target.setOrganLoss(ORGAN_SLOT_BRAIN, target.get_organ_loss(ORGAN_SLOT_BRAIN) - 50) //we set damage in this case in order to clear the "failing" flag
	target.cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)
	if(target.get_organ_loss(ORGAN_SLOT_BRAIN) > 0)
		to_chat(user, "[target]的大脑看起来还可以进一步修复.")
	return ..()

/datum/surgery_step/fix_brain/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_slot(ORGAN_SLOT_BRAIN))
		display_results(
			user,
			target,
			span_warning("你搞砸了，造成了更多损伤!"),
			span_warning("[user]搞砸了，造成大脑损伤!"),
			span_notice("[user]完成了对[target]大脑的手术."),
		)
		display_pain(target, "你的头部剧烈疼痛；思考都变得困难了!")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message(span_warning("[user]突然发现正在操作的大脑不见了."), span_warning("你突然发现正在操作的大脑不见了."))
	return FALSE
