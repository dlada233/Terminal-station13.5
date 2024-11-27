/datum/surgery/advanced/bioware/nerve_splicing
	name = "神经拼接"
	desc = "一种外科手术，通过拼接患者的神经，使其对击晕昏迷具有更强的抵抗力."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/apply_bioware/splice_nerves,
		/datum/surgery_step/close,
	)

	status_effect_gained = /datum/status_effect/bioware/nerves/spliced

/datum/surgery_step/apply_bioware/splice_nerves
	name = "拼接神经 (手)"
	time = 15.5 SECONDS

/datum/surgery_step/apply_bioware/splice_nerves/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始拼接[target]的神经.___TraitRemove"),
		span_notice("[user]开始拼接[target]的神经。"),
		span_notice("[user]开始操作[target]的神经系统."),
	)
	display_pain(target, "你全身突然变得麻木！")

/datum/surgery_step/apply_bioware/splice_nerves/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(!.)
		return

	display_results(
		user,
		target,
		span_notice("你成功拼接了[target]的神经系统！"),
		span_notice("[user]成功拼接了[target]的神经系统！"),
		span_notice("[user]完成了对[target]神经系统的操作."),
	)
	display_pain(target, "你重新感受到了身体的感觉；周围的一切似乎都在慢动作中发生！")
