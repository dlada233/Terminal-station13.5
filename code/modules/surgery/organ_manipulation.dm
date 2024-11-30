/datum/surgery/organ_manipulation
	name = "器官操作"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB | SURGERY_MORBID_CURIOSITY
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/manipulate_organs/internal,
		/datum/surgery_step/close,
	)

/datum/surgery/organ_manipulation/soft
	possible_locs = list(BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/manipulate_organs/internal,
		/datum/surgery_step/close,
	)

/datum/surgery/organ_manipulation/external
	name = "特征操作"
	possible_locs = list(
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/manipulate_organs/external,
		/datum/surgery_step/close,
	)

/datum/surgery/organ_manipulation/alien
	name = "异形器官操作"
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	target_mobtypes = list(/mob/living/carbon/alien/adult)
	steps = list(
		/datum/surgery_step/saw,
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/manipulate_organs/internal,
		/datum/surgery_step/close,
	)

/datum/surgery/organ_manipulation/mechanic
	name = "义体器官操作"
	requires_bodypart_type = BODYTYPE_ROBOTIC
	surgery_flags = SURGERY_SELF_OPERABLE | SURGERY_REQUIRE_LIMB
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/prepare_electronics,
		/datum/surgery_step/manipulate_organs/internal/mechanic,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close,
	)

/datum/surgery/organ_manipulation/mechanic/next_step(mob/living/user, modifiers)
	if(location != user.zone_selected)
		return FALSE
	if(user.combat_mode)
		return FALSE
	if(step_in_progress)
		return TRUE

	var/try_to_fail = FALSE
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		try_to_fail = TRUE

	var/datum/surgery_step/step = get_surgery_step()
	if(isnull(step))
		return FALSE
	var/obj/item/tool = user.get_active_held_item()
	if(step.try_op(user, target, user.zone_selected, tool, src, try_to_fail))
		return TRUE
	if(tool && tool.tool_behaviour) //Mechanic organ manipulation isn't done with just surgery tools
		to_chat(user, span_warning("这一步需要不同的工具!"))
		return TRUE

	return FALSE

/datum/surgery/organ_manipulation/mechanic/soft
	possible_locs = list(
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_PRECISE_EYES,
		BODY_ZONE_PRECISE_MOUTH,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
	)
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/prepare_electronics,
		/datum/surgery_step/manipulate_organs/internal/mechanic,
		/datum/surgery_step/mechanic_close,
	)

/datum/surgery/organ_manipulation/mechanic/external
	name = "义体特征操作"
	possible_locs = list(
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
	)
	steps = list( //not shorter than soft prosthetic manip because I dunno what steps could be cut here
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/prepare_electronics,
		/datum/surgery_step/manipulate_organs/external/mechanic,
		/datum/surgery_step/mechanic_close,
	)

///Organ manipulation base class. Do not use, it wont work. Use it's subtypes
/datum/surgery_step/manipulate_organs
	name = "操作器官"
	repeatable = TRUE
	implements = list(
		/obj/item/organ = 100,
		/obj/item/borg/apparatus/organ_storage = 100)
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

	var/implements_extract = list(TOOL_HEMOSTAT = 100, TOOL_CROWBAR = 55, /obj/item/kitchen/fork = 35)
	var/current_type
	var/obj/item/organ/target_organ

/datum/surgery_step/manipulate_organs/New()
	..()
	implements = implements + implements_extract

/datum/surgery_step/manipulate_organs/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	target_organ = null
	if(istype(tool, /obj/item/borg/apparatus/organ_storage))
		preop_sound = initial(preop_sound)
		success_sound = initial(success_sound)
		if(!length(tool.contents))
			to_chat(user, span_warning("[tool]里面什么也没有!"))
			return SURGERY_STEP_FAIL
		target_organ = tool.contents[1]
		if(!isorgan(target_organ))
			if (target_zone == BODY_ZONE_PRECISE_EYES)
				target_zone = check_zone(target_zone)
			to_chat(user, span_warning("你无法把[target_organ]放入[target]的[target.parse_zone_with_bodypart(target_zone)]!"))
			return SURGERY_STEP_FAIL
		tool = target_organ
	if(isorgan(tool))
		current_type = "insert"
		preop_sound = 'sound/surgery/hemostat1.ogg'
		success_sound = 'sound/surgery/organ2.ogg'
		target_organ = tool
		if(target_zone != target_organ.zone || target.get_organ_slot(target_organ.slot))
			to_chat(user, span_warning("[target_organ]没有空间放入[target]的[target.parse_zone_with_bodypart(target_zone)]!"))
			return SURGERY_STEP_FAIL
		var/obj/item/organ/meatslab = tool
		if(!meatslab.useable)
			to_chat(user, span_warning("[target_organ]似乎被咬过，无法使用!"))
			return SURGERY_STEP_FAIL

		if(!can_use_organ(user, meatslab))
			return SURGERY_STEP_FAIL

		if (target_zone == BODY_ZONE_PRECISE_EYES)
			target_zone = check_zone(target_zone)
		display_results(
			user,
			target,
			span_notice("你开始将[tool]放入[target]的[target.parse_zone_with_bodypart(target_zone)]..."),
			span_notice("[user]开始将[tool]放入[target]的[target.parse_zone_with_bodypart(target_zone)]."),
			span_notice("[user]开始往[target]的[target.parse_zone_with_bodypart(target_zone)]里放入某物."),
		)
		display_pain(target, "你感到有东西被放入了你的[target.parse_zone_with_bodypart(target_zone)]！")


	else if(implement_type in implements_extract)
		current_type = "extract"
		var/list/unfiltered_organs = target.get_organs_for_zone(target_zone)
		var/list/organs = list()
		for(var/organ in unfiltered_organs)
			if(can_use_organ(user, organ))
				organs.Add(organ)
		if (target_zone == BODY_ZONE_PRECISE_EYES)
			target_zone = check_zone(target_zone)
		if(!length(organs))
			to_chat(user, span_warning("[target]的[target.parse_zone_with_bodypart(target_zone)]里没有可移除的器官！"))
			return SURGERY_STEP_FAIL
		else
			for(var/obj/item/organ/organ in organs)
				organ.on_find(user)
				organs -= organ
				organs[organ.name] = organ

			var/chosen_organ = tgui_input_list(user, "移除哪个器官？", "手术", sort_list(organs))
			if(isnull(chosen_organ))
				return SURGERY_STEP_FAIL
			target_organ = chosen_organ
			if(user && target && user.Adjacent(target) && user.get_active_held_item() == tool)
				target_organ = organs[target_organ]
				if(!target_organ)
					return SURGERY_STEP_FAIL
				if(target_organ.organ_flags & ORGAN_UNREMOVABLE)
					to_chat(user, span_warning("[target_organ]连接得太紧密，无法取出！"))
					return SURGERY_STEP_FAIL
				display_results(
					user,
					target,
					span_notice("你开始从[target]的[target.parse_zone_with_bodypart(target_zone)]里取出[target_organ]..."),
					span_notice("[user]开始从[target]的[target.parse_zone_with_bodypart(target_zone)]里取出[target_organ]."),
					span_notice("[user]开始从[target]的[target.parse_zone_with_bodypart(target_zone)]里取出某物."),
				)
				display_pain(target, "你感到你的[target_organ.name]正在从你的[target.parse_zone_with_bodypart(target_zone)]里被取出！")
			else
				return SURGERY_STEP_FAIL

/datum/surgery_step/manipulate_organs/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if (target_zone == BODY_ZONE_PRECISE_EYES)
		target_zone = check_zone(target_zone)
	if(current_type == "insert")
		var/obj/item/apparatus
		if(istype(tool, /obj/item/borg/apparatus/organ_storage))
			apparatus = tool
			tool = tool.contents[1]
		target_organ = tool
		user.temporarilyRemoveItemFromInventory(target_organ, TRUE)
		if(target_organ.Insert(target))
			if(apparatus)
				apparatus.icon_state = initial(apparatus.icon_state)
				apparatus.desc = initial(apparatus.desc)
				apparatus.cut_overlays()
			display_results(
				user,
				target,
				span_notice("你把[tool]插入了[target]的[target.parse_zone_with_bodypart(target_zone)]."),
				span_notice("[user]把[tool]插入了[target]的[target.parse_zone_with_bodypart(target_zone)]！"),
				span_notice("[user]把某物插入了[target]的[target.parse_zone_with_bodypart(target_zone)]！"),
			)
			display_pain(target, "你的[target.parse_zone_with_bodypart(target_zone)]剧痛，你的新[tool.name]开始活跃！")
			target_organ.on_surgical_insertion(user, target, target_zone, tool)
		else
			target_organ.forceMove(target.loc)

	else if(current_type == "extract")
		if(target_organ && target_organ.owner == target)
			display_results(
				user,
				target,
				span_notice("你成功地从[target]的[target.parse_zone_with_bodypart(target_zone)]中提取了[target_organ]."),
				span_notice("[user]成功地从[target]的[target.parse_zone_with_bodypart(target_zone)]中提取了[target_organ]！"),
				span_notice("[user]成功地从[target]的[target.parse_zone_with_bodypart(target_zone)]中提取了某物！"),
			)
			display_pain(target, "你的[target.parse_zone_with_bodypart(target_zone)]剧痛，你再也感觉不到你的[target_organ.name]了！")
			log_combat(user, target, "从[target]身上外科移除了[target_organ.name]", addition="COMBAT MODE：[uppertext(user.combat_mode)]")
			target_organ.Remove(target)
			target_organ.forceMove(get_turf(target))
			target_organ.on_surgical_removal(user, target, target_zone, tool)
		else
			display_results(
				user,
				target,
				span_warning("你不能从[target]的[target.parse_zone_with_bodypart(target_zone)]中提取任何东西！"),
				span_notice("[user]似乎不能从[target]的[target.parse_zone_with_bodypart(target_zone)]中提取任何东西！"),
				span_notice("[user]似乎不能从[target]的[target.parse_zone_with_bodypart(target_zone)]中提取任何东西！"),
			)
	if(HAS_MIND_TRAIT(user, TRAIT_MORBID) && ishuman(user))
		var/mob/living/carbon/human/morbid_weirdo = user
		morbid_weirdo.add_mood_event("morbid_abominable_surgery_success", /datum/mood_event/morbid_abominable_surgery_success)
	return ..()

///You can never use this MUHAHAHAHAHAHAH (because its the byond version of abstract)
/datum/surgery_step/manipulate_organs/proc/can_use_organ(mob/user, obj/item/organ/organ)
	return FALSE

///Surgery step for internal organs, like hearts and brains
/datum/surgery_step/manipulate_organs/internal
	time = 6.4 SECONDS
	name = "操作器官 (止血钳/器官)"

///only operate on internal organs
/datum/surgery_step/manipulate_organs/internal/can_use_organ(mob/user, obj/item/organ/organ)
	return isinternalorgan(organ) && !(organ.organ_flags & ORGAN_UNREMOVABLE) // SKYRAT EDIT - Don't show unremovable organs - ORIGINAL: return isinternalorgan(organ)

///prosthetic surgery gives full effectiveness to crowbars (and hemostats)
/datum/surgery_step/manipulate_organs/internal/mechanic
	implements_extract = list(TOOL_HEMOSTAT = 100, TOOL_CROWBAR = 100, /obj/item/kitchen/fork = 35)
	name = "操作人造器官 (止血钳或撬棍/器官)"

///Surgery step for external organs/features, like tails, frills, wings etc
/datum/surgery_step/manipulate_organs/external
	time = 3.2 SECONDS
	name = "操作特征 (止血钳/特征)"

///Only operate on external organs
/datum/surgery_step/manipulate_organs/external/can_use_organ(mob/user, obj/item/organ/organ)
	return isexternalorgan(organ) && !(organ.organ_flags & ORGAN_UNREMOVABLE) // SKYRAT EDIT - Don't show unremovable organs - ORIGINAL: return isexternalorgan(organ)

///prosthetic surgery gives full effectiveness to crowbars (and hemostats)
/datum/surgery_step/manipulate_organs/external/mechanic
	implements_extract = list(TOOL_HEMOSTAT = 100, TOOL_CROWBAR = 100, /obj/item/kitchen/fork = 35)
	name = "操作人造特征 (止血钳或撬棍/特征)"
