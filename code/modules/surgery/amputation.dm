/datum/surgery/amputation
	name = "截肢"
	requires_bodypart_type = NONE
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_MORBID_CURIOSITY
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/sever_limb,
	)
	removes_target_bodypart = TRUE // SKYRAT EDIT ADDITION - Surgically unremovable limbs

/datum/surgery/amputation/can_start(mob/user, mob/living/patient)
	if(HAS_TRAIT(patient, TRAIT_NODISMEMBER))
		return FALSE
	return ..()

/datum/surgery_step/sever_limb
	name = "切断肢体 (圆锯)"
	implements = list(
		/obj/item/shears = 300,
		TOOL_SCALPEL = 100,
		TOOL_SAW = 100,
		/obj/item/shovel/serrated = 75,
		/obj/item/melee/arm_blade = 80,
		/obj/item/fireaxe = 50,
		/obj/item/hatchet = 40,
		/obj/item/knife/butcher = 25)
	time = 64
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/sever_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始切断[target]的[target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user]开始切断[target]的[target.parse_zone_with_bodypart(target_zone)]!"),
		span_notice("[user]开始切断[target]的[target.parse_zone_with_bodypart(target_zone)]!"),
	)
	display_pain(target, "你感到[parse_zone(target_zone)]的关节处传来剧烈的疼痛!")


/datum/surgery_step/sever_limb/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("你切断了[target]的[target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user]切断了[target]的[target.parse_zone_with_bodypart(target_zone)]!"),
		span_notice("[user]切断了[target]的[target.parse_zone_with_bodypart(target_zone)]!"),
	)
	display_pain(target, "你再也感觉不到你被切断的[target.parse_zone_with_bodypart(target_zone)]!")

	if(HAS_MIND_TRAIT(user, TRAIT_MORBID) && ishuman(user))
		var/mob/living/carbon/human/morbid_weirdo = user
		morbid_weirdo.add_mood_event("morbid_dismemberment", /datum/mood_event/morbid_dismemberment)

	if(surgery.operated_bodypart)
		var/obj/item/bodypart/target_limb = surgery.operated_bodypart
		target_limb.drop_limb()
	return ..()
