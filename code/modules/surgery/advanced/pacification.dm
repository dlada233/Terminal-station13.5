/datum/surgery/advanced/pacify
	name = "神经安抚"
	desc = "一种永久抑制大脑攻击中心的手术，使手术对象不再愿意对外物造成直接伤害."
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = NONE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/pacify,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/pacify/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	var/obj/item/organ/internal/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE

/datum/surgery_step/pacify
	name = "重连大脑 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 35,
		/obj/item/pen = 15)
	time = 40
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/pacify/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始安抚[target]..."),
		span_notice("[user]开始修复[target]的大脑."),
		span_notice("[user]开始对[target]的大脑进行手术."),
	)
	display_pain(target, "你的头感到难以想象的疼痛!")

/datum/surgery_step/pacify/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("你成功地从神经学上安抚了[target]."),
		span_notice("[user]成功修复了[target]的大脑!"),
		span_notice("[user]完成了对[target]的大脑手术."),
	)
	display_pain(target, "你的头还在疼...暴力的概念在你的脑海中闪现，几乎让你失控!")
	target.gain_trauma(/datum/brain_trauma/severe/pacifism, TRAUMA_RESILIENCE_LOBOTOMY)
	return ..()

/datum/surgery_step/pacify/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你搞砸了，错误地重连了[target]的大脑..."),
		span_warning("[user]搞砸了，造成了大脑损伤!"),
		span_notice("[user]完成了对[target]大脑的手术."),
	)
	display_pain(target, "你的头在疼，而且感觉越来越糟!")
	target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	return FALSE
