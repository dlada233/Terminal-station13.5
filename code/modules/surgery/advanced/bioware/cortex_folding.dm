/datum/surgery/advanced/bioware/cortex_folding
	name = "皮层折叠"
	desc = "一种外科手术，将大脑皮层改造成复杂的褶皱，为非标准神经模式提供空间."
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/apply_bioware/fold_cortex,
		/datum/surgery_step/close,
	)

	status_effect_gained = /datum/status_effect/bioware/cortex/folded

/datum/surgery/advanced/bioware/cortex_folding/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE
	return ..()

/datum/surgery_step/apply_bioware/fold_cortex
	name = "皮层折叠(手)"

/datum/surgery_step/apply_bioware/fold_cortex/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始将[target]的大脑外层皮层折叠成一种分形图案."),
		span_notice("[user]开始将[target]的大脑外层皮层折叠成一种分形图案."),
		span_notice("[user]开始对[target]的大脑进行手术."),
	)
	display_pain(target, "你的头部传来阵阵剧痛，简直让人难以忍受!")

/datum/surgery_step/apply_bioware/fold_cortex/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(!.)
		return

	display_results(
		user,
		target,
		span_notice("你成功将[target]的大脑外层皮层折叠成了分形图案!"),
		span_notice("[user]成功将[target]的大脑外层皮层折叠成了分形图案!"),
		span_notice("[user]完成了对[target]大脑的手术."),
	)
	display_pain(target, "你的大脑感觉变得更加强大...更加灵活了!")

/datum/surgery_step/apply_bioware/fold_cortex/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_slot(ORGAN_SLOT_BRAIN))
		display_results(
			user,
			target,
			span_warning("你搞砸了，大脑受到了损伤!"),
			span_warning("[user]搞砸了，大脑受到了损伤!"),
			span_notice("[user]完成了对[target]大脑的手术."),
		)
		display_pain(target, "你的大脑传来剧烈的疼痛，思考都变得困难了!")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message(span_warning("[user]突然发现正在手术的大脑不见了."), span_warning("你突然发现刚才正在手术的大脑不见了."))
	return FALSE
