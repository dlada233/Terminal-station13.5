
/////AUGMENTATION SURGERIES//////


//SURGERY STEPS

/datum/surgery_step/replace_limb
	name = "替换肢体"
	implements = list(
		/obj/item/bodypart = 100,
		/obj/item/borg/apparatus/organ_storage = 100)
	time = 32
	var/obj/item/bodypart/target_limb


/datum/surgery_step/replace_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(HAS_TRAIT(target, TRAIT_NO_AUGMENTS))
		to_chat(user, span_warning("[target]无法进行义肢增强!"))
		return SURGERY_STEP_FAIL
	if(istype(tool, /obj/item/borg/apparatus/organ_storage) && istype(tool.contents[1], /obj/item/bodypart))
		tool = tool.contents[1]
	var/obj/item/bodypart/aug = tool
	if(IS_ORGANIC_LIMB(aug))
		to_chat(user, span_warning("那不是义肢增强部件，真笨!"))
		return SURGERY_STEP_FAIL
	if(aug.body_zone != target_zone)
		to_chat(user, span_warning("[tool]不适合[target.parse_zone_with_bodypart(target_zone)]."))
		return SURGERY_STEP_FAIL
	target_limb = surgery.operated_bodypart
	if(target_limb)
		display_results(
			user,
			target,
			span_notice("你开始为[target]的[target.parse_zone_with_bodypart(user.zone_selected)]进行义肢增强..."),
			span_notice("[user]开始为[target]的[target.parse_zone_with_bodypart(user.zone_selected)]安装[aug]."),
			span_notice("[user]开始为[target]的[target.parse_zone_with_bodypart(user.zone_selected)]进行义肢增强."),
		)
		display_pain(target, "你感到[target.parse_zone_with_bodypart(user.zone_selected)]传来剧烈的疼痛！")
	else
		user.visible_message(span_notice("[user]正在寻找[target]的[target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("你正在寻找[target]的[target.parse_zone_with_bodypart(user.zone_selected)]..."))


//ACTUAL SURGERIES

/datum/surgery/augmentation
	name = "义肢增强"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
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
		/datum/surgery_step/replace_limb,
	)
	removes_target_bodypart = TRUE // SKYRAT EDIT ADDITION - Surgically unremovable limbs

//SURGERY STEP SUCCESSES

/datum/surgery_step/replace_limb/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/bodypart/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(target_limb)
		if(istype(tool, /obj/item/borg/apparatus/organ_storage))
			tool.icon_state = initial(tool.icon_state)
			tool.desc = initial(tool.desc)
			tool.cut_overlays()
			tool = tool.contents[1]
		if(istype(tool) && user.temporarilyRemoveItemFromInventory(tool))
			if(!tool.replace_limb(target))
				display_results(
					user,
					target,
					span_warning("你未能成功替换[target]的[target.parse_zone_with_bodypart(target_zone)]！他们的身体排斥了[tool]！"),
					span_warning("[user]未能替换[target]的[target.parse_zone_with_bodypart(target_zone)]！"),
					span_warning("[user]未能替换[target]的[target.parse_zone_with_bodypart(target_zone)]！"),
				)
				tool.forceMove(target.loc)
				return
		if(tool.check_for_frankenstein(target))
			tool.bodypart_flags |= BODYPART_IMPLANTED
		display_results(
			user,
			target,
			span_notice("你成功地为[target]的[target.parse_zone_with_bodypart(target_zone)]进行了义肢增强."),
			span_notice("[user]成功地为[target]的[target.parse_zone_with_bodypart(target_zone)]安装了[tool]！"),
			span_notice("[user]成功地为[target]的[target.parse_zone_with_bodypart(target_zone)]进行了义肢增强！"),
		)
		display_pain(target, "你的[target.parse_zone_with_bodypart(target_zone)]充满了机械的感觉！", mechanical_surgery = TRUE)
		log_combat(user, target, "augmented", addition="通过给他新的[target.parse_zone_with_bodypart(target_zone)] 战斗模式：[uppertext(user.combat_mode)]")
	else
		to_chat(user, span_warning("[target]那里没有有机[target.parse_zone_with_bodypart(target_zone)]！"))
	return ..()
