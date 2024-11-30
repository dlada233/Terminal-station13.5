/datum/surgery/eye_surgery
	name = "眼部手术"
	requires_bodypart_type = NONE
	organ_to_manipulate = ORGAN_SLOT_EYES
	possible_locs = list(BODY_ZONE_PRECISE_EYES)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/fix_eyes,
		/datum/surgery_step/close,
	)

//fix eyes
/datum/surgery_step/fix_eyes
	name = "修复眼睛 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 45,
		/obj/item/pen = 25)
	time = 64

/datum/surgery/eye_surgery/can_start(mob/user, mob/living/carbon/target)
	return target.get_organ_slot(ORGAN_SLOT_EYES) && ..()

/datum/surgery_step/fix_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始修复[target]的眼睛..."),
		span_notice("[user]开始修复[target]的眼睛。"),
		span_notice("[user]开始对[target]的眼睛进行手术。"),
	)
	display_pain(target, "你感到眼睛一阵刺痛！")

/datum/surgery_step/fix_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/obj/item/organ/internal/eyes/target_eyes = target.get_organ_slot(ORGAN_SLOT_EYES)
	user.visible_message(span_notice("[user]成功修复了[target]的眼睛!"), span_notice("你成功修复了[target]的眼睛."))
	display_results(
		user,
		target,
		span_notice("你成功修复了[target]的眼睛。"),
		span_notice("[user]成功修复了[target]的眼睛！"),
		span_notice("[user]完成了对[target]眼睛的手术。"),
	)
	display_pain(target, "你的视线模糊了，但似乎看得清楚了一些！")
	target.remove_status_effect(/datum/status_effect/temporary_blindness)
	target.set_eye_blur_if_lower(70 SECONDS) //this will fix itself slowly.
	target_eyes.set_organ_damage(0) // heals nearsightedness and blindness from eye damage
	return ..()

/datum/surgery_step/fix_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_by_type(/obj/item/organ/internal/brain))
		display_results(
			user,
			target,
			span_warning("你不小心刺中了[target]的大脑！"),
			span_warning("[user]不小心刺中了[target]的大脑！"),
			span_warning("[user]不小心刺中了[target]的大脑！"),
		)
		display_pain(target, "你感到头部传来一阵剧痛，直穿大脑！")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 70)
	else
		display_results(
			user,
			target,
			span_warning("你不小心刺中了[target]的大脑！如果[target]有大脑的话。"),
			span_warning("[user]不小心刺中了[target]的大脑！如果[target]有大脑的话。"),
			span_warning("[user]不小心刺中了[target]的大脑！"),
		)
		display_pain(target, "你感到头部传来一阵剧痛！") // dunno who can feel pain w/o a brain but may as well be consistent.
	return FALSE
