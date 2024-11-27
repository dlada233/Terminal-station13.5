/datum/surgery/advanced/lobotomy
	name = "脑叶切除术"
	desc = "一种侵入性手术，确保移除几乎所有的大脑创伤，但可能会导致另一种永久性创伤作为代价."
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = NONE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/lobotomize,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/lobotomy/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/organ/internal/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE
	return TRUE

/datum/surgery_step/lobotomize
	name = "执行脑叶切除 (手术刀)"
	implements = list(
		TOOL_SCALPEL = 85,
		/obj/item/melee/energy/sword = 55,
		/obj/item/knife = 35,
		/obj/item/shard = 25,
		/obj/item = 20,
	)
	time = 100
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/lobotomize/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE
	return TRUE

/datum/surgery_step/lobotomize/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始对[target]的大脑进行脑叶切除..."),
		span_notice("[user]开始对[target]的大脑进行脑叶切除."),
		span_notice("[user]开始对[target]的大脑进行手术."),
	)
	display_pain(target, "你的头部感到难以想象的剧痛!")

/datum/surgery_step/lobotomize/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("你成功地对[target]进行了脑叶切除."),
		span_notice("[user]成功地对[target]进行了脑叶切除！"),
		span_notice("[user]完成了对[target]大脑的手术."),
	)
	display_pain(target, "你的头部瞬间完全麻木，疼痛难以忍受!")

	target.cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	if(prob(75)) // 75% chance to get a trauma from this
		switch(rand(1, 3))//Now let's see what hopefully-not-important part of the brain we cut off
			if(1)
				target.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_MAGIC)
			if(2)
				if(HAS_TRAIT(target, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
					target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
				else
					target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_MAGIC)
			if(3)
				target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
	return ..()

/datum/surgery_step/lobotomize/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/internal/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(target_brain)
		display_results(
			user,
			target,
			span_warning("你切除了错误的部位，造成了更多伤害!"),
			span_notice("[user]成功脑叶切除了[target]!"),
			span_notice("[user]完成了对[target]大脑的手术."),
		)
		display_pain(target, "你头部的疼痛似乎更加剧烈了!")
		target_brain.apply_organ_damage(80)
		switch(rand(1,3))
			if(1)
				target.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_MAGIC)
			if(2)
				if(HAS_TRAIT(target, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
					target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
				else
					target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_MAGIC)
			if(3)
				target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
	else
		user.visible_message(span_warning("[user]突然发现正在手术的大脑不见了."), span_warning("你突然发现刚才正在手术的大脑不见了."))
	return FALSE
