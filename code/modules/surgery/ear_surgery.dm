//Head surgery to fix the ears organ
/datum/surgery/ear_surgery
	name = "耳部手术"
	requires_bodypart_type = NONE
	organ_to_manipulate = ORGAN_SLOT_EARS
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/fix_ears,
		/datum/surgery_step/close,
	)

//fix ears
/datum/surgery_step/fix_ears
	name = "修复耳朵 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 45,
		/obj/item/pen = 25)
	time = 64

/datum/surgery/ear_surgery/can_start(mob/user, mob/living/carbon/target)
	return target.get_organ_slot(ORGAN_SLOT_EARS) && ..()

/datum/surgery_step/fix_ears/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始修复[target]的耳朵..."),
		span_notice("[user]开始修复[target]的耳朵."),
		span_notice("[user]开始对[target]的耳朵进行手术."),
	)
	display_pain(target, "你感到头部一阵令人昏厥的疼痛!")

/datum/surgery_step/fix_ears/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/obj/item/organ/internal/ears/target_ears = target.get_organ_slot(ORGAN_SLOT_EARS)
	display_results(
		user,
		target,
		span_notice("你成功修复了[target]的耳朵."),
		span_notice("[user]成功地修复了[target]的耳朵!"),
		span_notice("[user]完成了手术对[target]的耳朵."),
	)
	display_pain(target, "你的头有点晕，但听力似乎正在恢复!")
	target_ears.deaf = (20) //deafness works off ticks, so this should work out to about 30-40s
	target_ears.set_organ_damage(0)
	return ..()

/datum/surgery_step/fix_ears/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_by_type(/obj/item/organ/internal/brain))
		display_results(
			user,
			target,
			span_warning("你不小心刺中了[target]的大脑位置!"),
			span_warning("[user]不小心刺中了[target]的大脑位置!"),
			span_warning("[user]不小心刺中了[target]的大脑位置!"),
		)
		display_pain(target, "你感到头部一阵剧烈的刺痛，直穿大脑!")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 70)
	else
		display_results(
			user,
			target,
			span_warning("你不小心刺中了[target]的大脑位置! 但[target]似乎没有大脑."),
			span_warning("[user]不小心刺中了[target]的大脑位置! 但[target]似乎没有大脑."),
			span_warning("[user]不小心刺中了[target]的大脑位置!"),
		)
		display_pain(target, "你感到头部一阵剧烈的刺痛!") // dunno who can feel pain w/o a brain but may as well be consistent.
	return FALSE
