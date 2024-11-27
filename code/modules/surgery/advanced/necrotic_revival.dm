/datum/surgery/advanced/necrotic_revival
	name = "坏死复活"
	desc = "一种实验性手术，刺激患者在大脑内生长罗梅罗尔肿瘤. 需要僵尸粉或再生剂."
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/bionecrosis,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/necrotic_revival/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	var/obj/item/organ/internal/zombie_infection/z_infection = target.get_organ_slot(ORGAN_SLOT_ZOMBIE)
	if(z_infection)
		return FALSE

/datum/surgery_step/bionecrosis
	name = "开始生物坏死 (注射器)"
	implements = list(
		/obj/item/reagent_containers/syringe = 100,
		/obj/item/pen = 30)
	time = 50
	chems_needed = list(/datum/reagent/toxin/zombiepowder, /datum/reagent/medicine/rezadone)
	require_all_chems = FALSE

/datum/surgery_step/bionecrosis/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的大脑上植入罗梅罗肿瘤..."),
		span_notice("[user]开始修补[target]的大脑..."),
		span_notice("[user]开始对[target]的大脑进行手术."),
	)
	display_pain(target, "你的头承受着难以想象的痛苦!") // Same message as other brain surgeries

/datum/surgery_step/bionecrosis/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("你成功在[target]的大脑上植入了罗梅罗肿瘤."),
		span_notice("[user]成功在[target]的大脑上植入了罗梅罗肿瘤!"),
		span_notice("[user]完成了[target]的脑部手术."),
	)
	display_pain(target, "你的头麻木了一会，压倒性的疼痛涌现.")
	if(!target.get_organ_slot(ORGAN_SLOT_ZOMBIE))
		var/obj/item/organ/internal/zombie_infection/z_infection = new()
		z_infection.Insert(target)
	return ..()
