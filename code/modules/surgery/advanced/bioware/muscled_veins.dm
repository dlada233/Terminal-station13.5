/datum/surgery/advanced/bioware/muscled_veins
	name = "肌肉静脉膜"
	desc = "一种外科手术，通过在血管周围添加肌肉膜，使其能够无需心脏即可泵送血液."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/apply_bioware/muscled_veins,
		/datum/surgery_step/close,
	)

	status_effect_gained = /datum/status_effect/bioware/heart/muscled_veins

/datum/surgery_step/apply_bioware/muscled_veins
	name = "塑造静脉肌肉 (手)"

/datum/surgery_step/apply_bioware/muscled_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始为[target]的循环系统包裹肌肉膜."),
		span_notice("[user]开始为[target]的循环系统包裹肌肉膜."),
		span_notice("[user]开始操作[target]的循环系统."),
	)
	display_pain(target, "你全身传来剧烈的疼痛，仿佛被火烧一般！")

/datum/surgery_step/apply_bioware/muscled_veins/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(!.)
		return

	display_results(
		user,
		target,
		span_notice("你重塑了[target]的循环系统，添加了肌肉膜！"),
		span_notice("[user]重塑了[target]的循环系统，添加了肌肉膜！"),
		span_notice("[user]完成了对[target]循环系统的操作."),
	)
	display_pain(target, "你能感觉到自己心跳的强劲脉动在全身回荡！")
