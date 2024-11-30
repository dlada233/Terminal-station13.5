/datum/surgery/lobectomy
	name = "肺叶切除" //not to be confused with lobotomy
	organ_to_manipulate = ORGAN_SLOT_LUNGS
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/lobectomy,
		/datum/surgery_step/close,
	)

/datum/surgery/lobectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/lungs/target_lungs = target.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(isnull(target_lungs) || target_lungs.damage < 60 || target_lungs.operated)
		return FALSE
	return ..()


//lobectomy, removes the most damaged lung lobe with a 95% base success chance
/datum/surgery_step/lobectomy
	name = "切除受损肺叶 (手术刀)"
	implements = list(
		TOOL_SCALPEL = 95,
		/obj/item/melee/energy/sword = 65,
		/obj/item/knife = 45,
		/obj/item/shard = 35)
	time = 42
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/lobectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的肺部做切口..."),
		span_notice("[user]开始在[target]身上做切口."),
		span_notice("[user]开始在[target]身上做切口."),
	)
	display_pain(target, "你感到胸部一阵刺痛！")

/datum/surgery_step/lobectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/organ/internal/lungs/target_lungs = human_target.get_organ_slot(ORGAN_SLOT_LUNGS)
		target_lungs.operated = TRUE
		human_target.setOrganLoss(ORGAN_SLOT_LUNGS, 60)
		display_results(
			user,
			target,
			span_notice("你成功切除了[human_target]最受损的肺叶."),
			span_notice("成功移除了[human_target]的部分肺."),
			"",
		)
		display_pain(target, "你的胸部剧痛，但呼吸变得稍微轻松了一些.")
	return ..()

/datum/surgery_step/lobectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		display_results(
			user,
			target,
			span_warning("你搞错了，未能切除[human_target]的受损肺叶！"),
			span_warning("[user]搞错了！"),
			span_warning("[user]搞错了！"),
		)
		display_pain(target, "你感到胸部一阵剧痛；你喘不过气来，呼吸变得异常疼痛！")
		human_target.losebreath += 4
		human_target.adjustOrganLoss(ORGAN_SLOT_LUNGS, 10)
	return FALSE
