/datum/surgery/advanced/bioware/vein_threading
	name = "静脉编织术"
	desc = "一种外科手术，能极大地减少受伤时的失血量."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/apply_bioware/thread_veins,
		/datum/surgery_step/close,
	)

	status_effect_gained = /datum/status_effect/bioware/heart/threaded_veins

/datum/surgery_step/apply_bioware/thread_veins
	name = "编织静脉 (手)"

/datum/surgery_step/apply_bioware/thread_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始编织[target]的循环系统."),
		span_notice("[user]开始编织[target]的循环系统."),
		span_notice("[user]开始操作[target]的循环系统."),
	)
	display_pain(target, "你全身如火烧般剧痛！")

/datum/surgery_step/apply_bioware/thread_veins/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(!.)
		return

	display_results(
		user,
		target,
		span_notice("你将[target]的循环系统编织成了一个坚韧的网络！"),
		span_notice("[user]将[target]的循环系统编织成了一个坚韧的网络！"),
		span_notice("[user]完成了对[target]循环系统的操作."),
	)
	display_pain(target, "你能感觉到血液在加固后的静脉中澎湃！")
