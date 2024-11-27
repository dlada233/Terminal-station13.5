/datum/surgery/advanced/wing_reconstruction
	name = "翅膀重建手术"
	desc = "一种实验性手术，用于重建飞蛾人受损的翅膀。需要合成肉."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/wing_reconstruction,
	)

/datum/surgery/advanced/wing_reconstruction/can_start(mob/user, mob/living/carbon/target)
	if(!istype(target))
		return FALSE
	var/obj/item/organ/external/wings/moth/wings = target.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
	if(!istype(wings, /obj/item/organ/external/wings/moth))
		return FALSE
	return ..() && wings?.burnt

/datum/surgery_step/wing_reconstruction
	name = "开始翅膀重建 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 85,
		TOOL_SCREWDRIVER = 35,
		/obj/item/pen = 15)
	time = 200
	chems_needed = list(/datum/reagent/medicine/c2/synthflesh)
	require_all_chems = FALSE

/datum/surgery_step/wing_reconstruction/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始修复[target]烧焦的翅膀膜..."),
		span_notice("[user]开始修复[target]烧焦的翅膀膜."),
		span_notice("[user]开始对[target]烧焦的翅膀膜进行手术."),
	)
	display_pain(target, "你的翅膀剧痛无比！")

/datum/surgery_step/wing_reconstruction/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		display_results(
			user,
			target,
			span_notice("你成功重建了[target]的翅膀."),
			span_notice("[user]成功重建了[target]的翅膀！"),
			span_notice("[user]完成了对[target]翅膀的手术."),
		)
		display_pain(target, "你能再次感受到你的翅膀了！")
		var/obj/item/organ/external/wings/moth/wings = target.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
		if(istype(wings, /obj/item/organ/external/wings/moth)) //make sure we only heal moth wings.
			wings.heal_wings(user, ALL)

		var/obj/item/organ/external/antennae/antennae = target.get_organ_slot(ORGAN_SLOT_EXTERNAL_ANTENNAE) //i mean we might aswell heal their antennae too
		antennae?.heal_antennae()

		human_target.update_body_parts()
	return ..()
