/datum/surgery/coronary_bypass
	name = "冠状动脉旁路手术"
	organ_to_manipulate = ORGAN_SLOT_HEART
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise_heart,
		/datum/surgery_step/coronary_bypass,
		/datum/surgery_step/close,
	)

/datum/surgery/coronary_bypass/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/heart/target_heart = target.get_organ_slot(ORGAN_SLOT_HEART)
	if(isnull(target_heart) || target_heart.damage < 60 || target_heart.operated)
		return FALSE
	return ..()


//an incision but with greater bleed, and a 90% base success chance
/datum/surgery_step/incise_heart
	name = "切割心脏 (手术刀)"
	implements = list(
		TOOL_SCALPEL = 90,
		/obj/item/melee/energy/sword = 45,
		/obj/item/knife = 45,
		/obj/item/shard = 25)
	time = 16
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/incise_heart/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的心脏部位做切口..."),
		span_notice("[user]开始在[target]的心脏部位做切口."),
		span_notice("[user]开始在[target]的心脏部位做切口."),
	)
	display_pain(target, "你感到心脏部位传来剧烈的疼痛，几乎要让你昏厥过去!")

/datum/surgery_step/incise_heart/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		if (!HAS_TRAIT(target_human, TRAIT_NOBLOOD))
			display_results(
				user,
				target,
				span_notice("[target_human]心脏部位的切口周围开始积聚血液."),
				span_notice("[target_human]心脏部位的切口周围开始积聚血液."),
				span_notice("[target_human]心脏部位的切口周围开始积聚血液."),
			)
			var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
			target_bodypart.adjustBleedStacks(10)
			target_human.adjustBruteLoss(10)
	return ..()

/datum/surgery_step/incise_heart/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("你失误了，切得太深，切入了心脏!"),
			span_warning("[user]失误了，导致[target_human]的胸口鲜血喷涌而出!"),
			span_warning("[user]失误了，导致[target_human]的胸口鲜血喷涌而出!"),
		)
		var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
		target_bodypart.adjustBleedStacks(10)
		target_human.adjustOrganLoss(ORGAN_SLOT_HEART, 10)
		target_human.adjustBruteLoss(10)

//grafts a coronary bypass onto the individual's heart, success chance is 90% base again
/datum/surgery_step/coronary_bypass
	name = "移植冠状动脉旁路 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 90,
		TOOL_WIRECUTTER = 35,
		/obj/item/stack/package_wrap = 15,
		/obj/item/stack/cable_coil = 5)
	time = 90
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/coronary_bypass/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的心脏上移植旁路..."),
		span_notice("[user]开始在[target]的心脏上移植什么东西！"),
		span_notice("[user]开始在[target]的心脏上移植什么东西！"),
	)
	display_pain(target, "你胸口的疼痛难以忍受！你几乎无法再承受了!")

/datum/surgery_step/coronary_bypass/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	target.setOrganLoss(ORGAN_SLOT_HEART, 60)
	var/obj/item/organ/internal/heart/target_heart = target.get_organ_slot(ORGAN_SLOT_HEART)
	if(target_heart) //slightly worrying if we lost our heart mid-operation, but that's life
		target_heart.operated = TRUE
	display_results(
		user,
		target,
		span_notice("你成功地在[target]的心脏上移植了旁路."),
		span_notice("[user]完成了在[target]的心脏上的移植."),
		span_notice("[user]完成了在[target]的心脏上的移植."),
	)
	display_pain(target, "你胸口的疼痛跳动着，但你的心脏感觉比以前更好了!")
	return ..()

/datum/surgery_step/coronary_bypass/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("你在连接移植物时失误了，它脱落了，并撕扯了一部分心脏！"),
			span_warning("[user]失误了，导致[target_human]的胸口鲜血大量喷涌而出！"),
			span_warning("[user]失误了，导致[target_human]的胸口鲜血大量喷涌而出！"),
		)
		display_pain(target, "你的胸口灼烧着；你感觉自己要疯了!")
		target_human.adjustOrganLoss(ORGAN_SLOT_HEART, 20)
		var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
		target_bodypart.adjustBleedStacks(30)
	return FALSE
