/datum/surgery/advanced/bioware/nerve_grounding
	name = "神经接地"
	desc = "一种外科手术，使患者的神经充当接地棒，保护其免受电击伤害."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/apply_bioware/ground_nerves,
		/datum/surgery_step/close,
	)

	status_effect_gained = /datum/status_effect/bioware/nerves/grounded

/datum/surgery_step/apply_bioware/ground_nerves
	name = "接地神经 (手)"
	time = 15.5 SECONDS

/datum/surgery_step/apply_bioware/ground_nerves/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始重新排列[target]的神经."),
		span_notice("[user]开始重新排列[target]的神经."),
		span_notice("[user]开始操作[target]的神经系统."),
	)
	display_pain(target, "你全身突然变得麻木!")

/datum/surgery_step/apply_bioware/ground_nerves/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("你成功重新排列了[target]的神经系统！"),
		span_notice("[user]成功重新排列了[target]的神经系统！"),
		span_notice("[user]完成了对[target]神经系统的操作."),
	)
	display_pain(target, "你重新感受到了身体的感觉！你感到精力充沛！")
	return ..()
