
/////BONE FIXING SURGERIES//////

///// Repair Hairline Fracture (Severe)
/datum/surgery/repair_bone_hairline
	name = "修复骨折 (细微)"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/blunt/bone/severe
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/repair_bone_hairline,
		/datum/surgery_step/close,
	)

///// Repair Compound Fracture (Critical)
/datum/surgery/repair_bone_compound
	name = "修复复合性骨折"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/blunt/bone/critical
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/reset_compound_fracture,
		/datum/surgery_step/repair_bone_compound,
		/datum/surgery_step/close,
	)

//SURGERY STEPS

///// Repair Hairline Fracture (Severe)
/datum/surgery_step/repair_bone_hairline
	name = "修复细微骨折 (接骨器/骨胶/胶带)"
	implements = list(
		TOOL_BONESET = 100,
		/obj/item/stack/medical/bone_gel = 100,
		/obj/item/stack/sticky_tape/surgical = 100,
		/obj/item/stack/sticky_tape/super = 50,
		/obj/item/stack/sticky_tape = 30)
	time = 40

/datum/surgery_step/repair_bone_hairline/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("你开始修复[target]的[target.parse_zone_with_bodypart(user.zone_selected)]..."),
			span_notice("[user]开始使用[tool]修复[target]的[target.parse_zone_with_bodypart(user.zone_selected)] with."),
			span_notice("[user]开始修复[target]的[target.parse_zone_with_bodypart(user.zone_selected)]."),
		)
		display_pain(target, "你的[target.parse_zone_with_bodypart(user.zone_selected)]感到疼痛!")
	else
		user.visible_message(span_notice("[user]正在寻找[target]的[target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("You look for [target]'s [target.parse_zone_with_bodypart(user.zone_selected)]..."))

/datum/surgery_step/repair_bone_hairline/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("你成功修复了[target]的[target.parse_zone_with_bodypart(target_zone)]."),
			span_notice("[user]使用[tool]成功修复了[target]的[target.parse_zone_with_bodypart(target_zone)] with !"),
			span_notice("[user]成功修复了[target]的[target.parse_zone_with_bodypart(target_zone)]!"),
		)
		log_combat(user, target, "修复了细微骨折在", addition="COMBAT_MODE: [uppertext(user.combat_mode)]")
		qdel(surgery.operated_wound)
	else
		to_chat(user, span_warning("[target]那里没有细微骨折!"))
	return ..()

/datum/surgery_step/repair_bone_hairline/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)



///// Reset Compound Fracture (Crticial)
/datum/surgery_step/reset_compound_fracture
	name = "重置骨骼 (接骨器)"
	implements = list(
		TOOL_BONESET = 100,
		/obj/item/stack/sticky_tape/surgical = 60,
		/obj/item/stack/sticky_tape/super = 40,
		/obj/item/stack/sticky_tape = 20)
	time = 40

/datum/surgery_step/reset_compound_fracture/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("你开始重置[target]的[target.parse_zone_with_bodypart(user.zone_selected)]处的骨骼..."),
			span_notice("[user]开始使用[tool]重置[target]的[target.parse_zone_with_bodypart(user.zone_selected)]处的骨骼."),
			span_notice("[user]开始重置[target]的[target.parse_zone_with_bodypart(user.zone_selected)]处的骨骼."),
		)
		display_pain(target, "你[target.parse_zone_with_bodypart(user.zone_selected)]处的剧烈疼痛难以忍受!")
	else
		user.visible_message(span_notice("[user]正在寻找[target]的[target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("You look for [target]'s [target.parse_zone_with_bodypart(user.zone_selected)]..."))

/datum/surgery_step/reset_compound_fracture/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("你成功重置了[target]的[target.parse_zone_with_bodypart(target_zone)]."),
			span_notice("[user]使用[tool]成功重置了[target]的[target.parse_zone_with_bodypart(target_zone)]!"),
			span_notice("[user]成功重置了[target]的[target.parse_zone_with_bodypart(target_zone)]!"),
		)
		log_combat(user, target, "重置了复合骨折在", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	else
		to_chat(user, span_warning("[target]那里没有复合骨折!"))
	return ..()

/datum/surgery_step/reset_compound_fracture/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)

#define IMPLEMENTS_THAT_FIX_BONES list( \
	/obj/item/stack/medical/bone_gel = 100, \
	/obj/item/stack/sticky_tape/surgical = 100, \
	/obj/item/stack/sticky_tape/super = 50, \
	/obj/item/stack/sticky_tape = 30, \
)


///// Repair Compound Fracture (Crticial)
/datum/surgery_step/repair_bone_compound
	name = "修复复合性骨折 (骨胶/胶带)"
	implements = IMPLEMENTS_THAT_FIX_BONES
	time = 40

/datum/surgery_step/repair_bone_compound/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("你开始修复[target]的[target.parse_zone_with_bodypart(user.zone_selected)]..."),
			span_notice("[user]开始使用[tool]修复[target]的[target.parse_zone_with_bodypart(user.zone_selected)]的骨折."),
			span_notice("[user]开始修复[target]的[target.parse_zone_with_bodypart(user.zone_selected)]的骨折."),
		)
		display_pain(target, "你[target.parse_zone_with_bodypart(user.zone_selected)]传来的剧痛难以忍受!")
	else
		user.visible_message(span_notice("[user]正在寻找[target]的[target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("You look for [target]'s [target.parse_zone_with_bodypart(user.zone_selected)]..."))

/datum/surgery_step/repair_bone_compound/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("你成功修复了[target]的[target.parse_zone_with_bodypart(target_zone)]的骨折."),
			span_notice("[user]使用[tool]成功修复了[target]的[target.parse_zone_with_bodypart(target_zone)]的骨折!"),
			span_notice("[user]成功修复了[target]的[target.parse_zone_with_bodypart(target_zone)]的骨折!"),
		)
		log_combat(user, target, "修复了复合性骨折在", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
		qdel(surgery.operated_wound)
	else
		to_chat(user, span_warning("[target] has no compound fracture there!"))
	return ..()

/datum/surgery_step/repair_bone_compound/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)

/// Surgery to repair cranial fissures
/datum/surgery/cranial_reconstruction
	name = "颅骨重建"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/cranial_fissure
	possible_locs = list(
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/clamp_bleeders/discard_skull_debris,
		/datum/surgery_step/repair_skull
	)

/datum/surgery_step/clamp_bleeders/discard_skull_debris
	name = "清除颅骨碎片 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_WIRECUTTER = 40,
		TOOL_SCREWDRIVER = 40,
	)
	time = 2.4 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/clamp_bleeders/discard_skull_debris/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始清除[target]的[target.parse_zone_with_bodypart(target_zone)]中的小块颅骨碎片..."),
		span_notice("[user]开始清除[target]的[target.parse_zone_with_bodypart(target_zone)]中的小块颅骨碎片..."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]中摸索..."),
	)

	display_pain(target, "你的大脑感觉像被小小的玻璃碎片刺穿一样!")

/datum/surgery_step/repair_skull
	name = "修复颅骨 (骨胶/胶带)"
	implements = IMPLEMENTS_THAT_FIX_BONES
	time = 4 SECONDS

/datum/surgery_step/repair_skull/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	ASSERT(surgery.operated_wound, "没有伤口却修复颅骨")

	display_results(
		user,
		target,
		span_notice("你开始尽可能修复[target]的颅骨..."),
		span_notice("[user]开始使用[tool]修复[target]的颅骨."),
		span_notice("[user]开始修复[target]的颅骨."),
	)

	display_pain(target, "你能感觉到颅骨的碎片在你的大脑上摩擦!")

/datum/surgery_step/repair_skull/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if (isnull(surgery.operated_wound))
		to_chat(user, span_warning("[target]的颅骨没问题!"))
		return ..()


	if (isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)

	display_results(
		user,
		target,
		span_notice("你成功修复了[target]的颅骨."),
		span_notice("[user]使用[tool]成功修复了[target]的颅骨."),
		span_notice("[user]成功修复了[target]的颅骨.")
	)

	qdel(surgery.operated_wound)

	return ..()

#undef IMPLEMENTS_THAT_FIX_BONES
