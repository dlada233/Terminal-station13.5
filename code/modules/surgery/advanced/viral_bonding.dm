/datum/surgery/advanced/viral_bonding
	name = "病毒结合"
	desc = "一种迫使病毒与其宿主之间形成共生关系的手术，患者必须接受太空西林、病毒食物和甲醛的注射."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/viral_bond,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/viral_bonding/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return FALSE
	if(!LAZYLEN(target.diseases))
		return FALSE
	return TRUE

/datum/surgery_step/viral_bond
	name = "病毒结合 (缝合器)"
	implements = list(
		TOOL_CAUTERY = 100,
		TOOL_WELDER = 50,
		/obj/item = 30) // 30% success with any hot item.
	time = 100
	chems_needed = list(/datum/reagent/medicine/spaceacillin,/datum/reagent/consumable/virus_food,/datum/reagent/toxin/formaldehyde)

/datum/surgery_step/viral_bond/tool_check(mob/user, obj/item/tool)
	if(implement_type == TOOL_WELDER || implement_type == /obj/item)
		return tool.get_temperature()

	return TRUE

/datum/surgery_step/viral_bond/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始用[tool]加热[target]的骨髓..."),
		span_notice("[user]开始用[tool]加热[target]的骨髓..."),
		span_notice("[user]开始用[tool]加热[target]胸部的某个部位..."),
	)
	display_pain(target, "你感到一股炽热从你胸部蔓延开来!")

/datum/surgery_step/viral_bond/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	display_results(
		user,
		target,
		span_notice("[target]的骨髓开始缓慢跳动。病毒结合完成."),
		span_notice("[target]的骨髓开始缓慢跳动."),
		span_notice("[user]完成了手术."),
	)
	display_pain(target, "你感到胸部有轻微的跳动感.")
	for(var/datum/disease/infected_disease as anything in target.diseases)
		if(infected_disease.severity != DISEASE_SEVERITY_UNCURABLE) //no curing quirks, sweaty
			infected_disease.carrier = TRUE
	return TRUE
