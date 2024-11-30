//open shell
/datum/surgery_step/mechanic_open
	name = "拧开外壳 (螺丝刀)"
	implements = list(
		TOOL_SCREWDRIVER = 100,
		TOOL_SCALPEL = 75, // med borgs could try to unscrew shell with scalpel
		/obj/item/knife = 50,
		/obj/item = 10) // 10% success with any sharp item.
	time = 24
	preop_sound = 'sound/items/screwdriver.ogg'
	success_sound = 'sound/items/screwdriver2.ogg'

/datum/surgery_step/mechanic_open/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始用螺丝刀拧开[target]的[target.parse_zone_with_bodypart(target_zone)]的外壳..."),
		span_notice("[user]开始用螺丝刀拧开[target]的[target.parse_zone_with_bodypart(target_zone)]的外壳."),
		span_notice("[user]开始用螺丝刀拧开[target]的[target.parse_zone_with_bodypart(target_zone)]的外壳."),
	)
	display_pain(target, "你能感觉到[target.parse_zone_with_bodypart(target_zone)]随着传感面板被拧开而逐渐麻木.", TRUE)

/datum/surgery_step/mechanic_open/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE
	if(tool.usesound)
		preop_sound = tool.usesound

	return TRUE

//close shell
/datum/surgery_step/mechanic_close
	name = "拧紧外壳 (螺丝刀)"
	implements = list(
		TOOL_SCREWDRIVER = 100,
		TOOL_SCALPEL = 75,
		/obj/item/knife = 50,
		/obj/item = 10) // 10% success with any sharp item.
	time = 24
	preop_sound = 'sound/items/screwdriver.ogg'
	success_sound = 'sound/items/screwdriver2.ogg'

/datum/surgery_step/mechanic_close/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始用螺丝刀拧紧[target]的[target.parse_zone_with_bodypart(target_zone)]的外壳..."),
		span_notice("[user]开始用螺丝刀拧紧[target]的[target.parse_zone_with_bodypart(target_zone)]的外壳."),
		span_notice("[user]开始用螺丝刀拧紧[target]的[target.parse_zone_with_bodypart(target_zone)]的外壳."),
	)
	display_pain(target, "你感觉到[target.parse_zone_with_bodypart(target_zone)]的面板被拧紧时，微弱的刺痛感回来了.", TRUE)

/datum/surgery_step/mechanic_close/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE
	if(tool.usesound)
		preop_sound = tool.usesound

	return TRUE

//prepare electronics
/datum/surgery_step/prepare_electronics
	name = "准备电子设备 (多功能工具)"
	implements = list(
		TOOL_MULTITOOL = 100,
		TOOL_HEMOSTAT = 10) // try to reboot internal controllers via short circuit with some conductor
	time = 24
	preop_sound = 'sound/items/taperecorder/tape_flip.ogg'
	success_sound = 'sound/items/taperecorder/taperecorder_close.ogg'

/datum/surgery_step/prepare_electronics/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始准备[target]的[target.parse_zone_with_bodypart(target_zone)]中的电子设备..."),
		span_notice("[user]开始准备[target]的[target.parse_zone_with_bodypart(target_zone)]中的电子设备."),
		span_notice("[user]开始准备[target]的[target.parse_zone_with_bodypart(target_zone)]中的电子设备."),
	)
	display_pain(target, "你能感觉到[target.parse_zone_with_bodypart(target_zone)]中有微弱的嗡嗡声，电子设备正在重启.", TRUE)

//unwrench
/datum/surgery_step/mechanic_unwrench
	name = "拧松螺栓 (扳手)"
	implements = list(
		TOOL_WRENCH = 100,
		TOOL_RETRACTOR = 10)
	time = 24
	preop_sound = 'sound/items/ratchet.ogg'

/datum/surgery_step/mechanic_unwrench/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始用扳手拧松[target]的[target.parse_zone_with_bodypart(target_zone)]的一些螺栓..."),
		span_notice("[user]开始用扳手拧松[target]的[target.parse_zone_with_bodypart(target_zone)]的一些螺栓."),
		span_notice("[user]开始用扳手拧松[target]的[target.parse_zone_with_bodypart(target_zone)]的一些螺栓."),
	)
	display_pain(target, "你感到[target.parse_zone_with_bodypart(target_zone)]里一阵晃动，螺栓开始松动.", TRUE)

/datum/surgery_step/mechanic_unwrench/tool_check(mob/user, obj/item/tool)
	if(tool.usesound)
		preop_sound = tool.usesound

	return TRUE

//wrench
/datum/surgery_step/mechanic_wrench
	name = "拧紧螺栓 (扳手)"
	implements = list(
		TOOL_WRENCH = 100,
		TOOL_RETRACTOR = 10)
	time = 24
	preop_sound = 'sound/items/ratchet.ogg'

/datum/surgery_step/mechanic_wrench/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始用扳手拧紧[target]的[target.parse_zone_with_bodypart(target_zone)]的一些螺栓..."),
		span_notice("[user]开始用扳手拧紧[target]的[target.parse_zone_with_bodypart(target_zone)]的一些螺栓."),
		span_notice("[user]开始用扳手拧紧[target]的[target.parse_zone_with_bodypart(target_zone)]的一些螺栓."),
	)
	display_pain(target, "你感到[target.parse_zone_with_bodypart(target_zone)]里一阵晃动，螺栓开始拧紧.", TRUE)

/datum/surgery_step/mechanic_wrench/tool_check(mob/user, obj/item/tool)
	if(tool.usesound)
		preop_sound = tool.usesound

	return TRUE

//open hatch
/datum/surgery_step/open_hatch
	name = "打开舱口 (手)"
	accept_hand = TRUE
	time = 10
	preop_sound = 'sound/items/ratchet.ogg'
	preop_sound = 'sound/machines/doorclick.ogg'

/datum/surgery_step/open_hatch/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始打开[target]的[target.parse_zone_with_bodypart(target_zone)]的舱口支架..."),
		span_notice("[user]开始打开[target]的[target.parse_zone_with_bodypart(target_zone)]的舱口支架."),
		span_notice("[user]开始打开[target]的[target.parse_zone_with_bodypart(target_zone)]的舱口支架."),
	)
	display_pain(target, "[target.parse_zone_with_bodypart(target_zone)]里最后微弱的触觉感觉随着舱口的打开而消失.", TRUE)

/datum/surgery_step/open_hatch/tool_check(mob/user, obj/item/tool)
	if(tool.usesound)
		preop_sound = tool.usesound

	return TRUE
