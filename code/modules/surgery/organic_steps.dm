
//make incision
/datum/surgery_step/incise
	name = "切开皮肤 (手术刀)"
	implements = list(
		TOOL_SCALPEL = 100,
		/obj/item/melee/energy/sword = 75,
		/obj/item/knife = 65,
		/obj/item/shard = 45,
		/obj/item = 30) // 30% success with any sharp item.
	time = 16
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/incise/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的[target.parse_zone_with_bodypart(target_zone)]上切开皮肤..."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]上切开皮肤."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]上切开皮肤."),
	)
	display_pain(target, "你感到[target.parse_zone_with_bodypart(target_zone)]被刺了一下.")

/datum/surgery_step/incise/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE

	return TRUE

/datum/surgery_step/incise/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if ishuman(target)
		var/mob/living/carbon/human/human_target = target
		if (!HAS_TRAIT(human_target, TRAIT_NOBLOOD))
			display_results(
				user,
				target,
				span_notice("[human_target]的[target.parse_zone_with_bodypart(target_zone)]切口周围流出血液."),
				span_notice("[human_target]的[target.parse_zone_with_bodypart(target_zone)]切口周围流出血液."),
				span_notice("[human_target]的[target.parse_zone_with_bodypart(target_zone)]切口周围流出血液."),
			)
			var/obj/item/bodypart/target_bodypart = target.get_bodypart(target_zone)
			if(target_bodypart)
				target_bodypart.adjustBleedStacks(10)
	return ..()

/datum/surgery_step/incise/nobleed/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始<i>小心</i>地在[target]的[target.parse_zone_with_bodypart(target_zone)]上切开..."),
		span_notice("[user]开始<i>小心</i>地在[target]的[target.parse_zone_with_bodypart(target_zone)]上切开."),
		span_notice("[user]开始<i>小心</i>地在[target]的[target.parse_zone_with_bodypart(target_zone)]上切开."),
	)
	display_pain(target, "你感到<i>轻微</i>的刺痛在[target.parse_zone_with_bodypart(target_zone)]上.")

//clamp bleeders
/datum/surgery_step/clamp_bleeders
	name = "止血夹 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_WIRECUTTER = 60,
		/obj/item/stack/package_wrap = 35,
		/obj/item/stack/cable_coil = 15)
	time = 24
	preop_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/clamp_bleeders/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的[target.parse_zone_with_bodypart(target_zone)]上止血..."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]上止血."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]上止血."),
	)
	display_pain(target, "你感到[target.parse_zone_with_bodypart(target_zone)]被夹住，流血速度减缓.")

/datum/surgery_step/clamp_bleeders/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(20, 0, target_zone = target_zone)
	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/bodypart/target_bodypart = human_target.get_bodypart(target_zone)
		if(target_bodypart)
			target_bodypart.adjustBleedStacks(-3)
	return ..()

//retract skin
/datum/surgery_step/retract_skin
	name = "牵拉皮肤 (牵开器)"
	implements = list(
		TOOL_RETRACTOR = 100,
		TOOL_SCREWDRIVER = 45,
		TOOL_WIRECUTTER = 35,
		/obj/item/stack/rods = 35)
	time = 24
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'

/datum/surgery_step/retract_skin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的[target.parse_zone_with_bodypart(target_zone)]牵拉皮肤..."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]牵拉皮肤."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]牵拉皮肤."),
	)
	display_pain(target, "你感到[target.parse_zone_with_bodypart(target_zone)]传来一阵剧烈的刺痛，皮肤被拉开了！")

//close incision
/datum/surgery_step/close
	name = "缝合切口 (缝合器)"
	implements = list(
		TOOL_CAUTERY = 100,
		/obj/item/gun/energy/laser = 90,
		TOOL_WELDER = 70,
		/obj/item = 30) // 30% success with any hot item.
	time = 24
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/close/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的[target.parse_zone_with_bodypart(target_zone)]缝合切口..."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]缝合切口."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]缝合切口."),
	)
	display_pain(target, "你的[target.parse_zone_with_bodypart(target_zone)]正在被灼烧！")

/datum/surgery_step/close/tool_check(mob/user, obj/item/tool)
	if(implement_type == TOOL_WELDER || implement_type == /obj/item)
		return tool.get_temperature()

	return TRUE

/datum/surgery_step/close/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(45, 0, target_zone = target_zone)
	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/bodypart/target_bodypart = human_target.get_bodypart(target_zone)
		if(target_bodypart)
			target_bodypart.adjustBleedStacks(-3)
	return ..()



//saw bone
/datum/surgery_step/saw
	name = "锯开骨头 (圆锯)"
	implements = list(
		TOOL_SAW = 100,
		/obj/item/shovel/serrated = 75,
		/obj/item/melee/arm_blade = 75,
		/obj/item/fireaxe = 50,
		/obj/item/hatchet = 35,
		/obj/item/knife/butcher = 35,
		/obj/item = 25) //20% success (sort of) with any sharp item with a force >= 10
	time = 54
	preop_sound = list(
		/obj/item/circular_saw = 'sound/surgery/saw.ogg',
		/obj/item/melee/arm_blade = 'sound/surgery/scalpel1.ogg',
		/obj/item/fireaxe = 'sound/surgery/scalpel1.ogg',
		/obj/item/hatchet = 'sound/surgery/scalpel1.ogg',
		/obj/item/knife/butcher = 'sound/surgery/scalpel1.ogg',
		/obj/item = 'sound/surgery/scalpel1.ogg',
	)
	success_sound = 'sound/surgery/organ2.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/saw/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的[target.parse_zone_with_bodypart(target_zone)]锯骨..."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]锯骨."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]锯骨."),
	)
	display_pain(target, "你感到[target.parse_zone_with_bodypart(target_zone)]内部传来一阵可怕的疼痛！")

/datum/surgery_step/saw/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !(tool.get_sharpness() && (tool.force >= 10)))
		return FALSE
	return TRUE

/datum/surgery_step/saw/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	target.apply_damage(50, BRUTE, "[target_zone]", wound_bonus=CANT_WOUND)
	display_results(
		user,
		target,
		span_notice("你把[target]的[target.parse_zone_with_bodypart(target_zone)]锯开了."),
		span_notice("[user]把[target]的[target.parse_zone_with_bodypart(target_zone)]锯开了！"),
		span_notice("[user]把[target]的[target.parse_zone_with_bodypart(target_zone)]锯开了！"),
	)
	display_pain(target, "你感到[target.parse_zone_with_bodypart(target_zone)]里有什么东西断了！")
	return ..()

//drill bone
/datum/surgery_step/drill
	name = "钻骨 (外科电钻)"
	implements = list(
		TOOL_DRILL = 100,
		/obj/item/screwdriver/power = 80,
		/obj/item/pickaxe/drill = 60,
		TOOL_SCREWDRIVER = 25,
		/obj/item/kitchen/spoon = 20)
	time = 30

/datum/surgery_step/drill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的[target.parse_zone_with_bodypart(target_zone)]上钻骨..."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]上钻骨."),
		span_notice("[user]开始在[target]的[target.parse_zone_with_bodypart(target_zone)]上钻骨."),
	)
	display_pain(target, "你感到[target.parse_zone_with_bodypart(target_zone)]传来一阵可怕的刺痛！")

/datum/surgery_step/drill/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("你钻入了[target]的[target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user]钻入了[target]的[target.parse_zone_with_bodypart(target_zone)]！"),
		span_notice("[user]钻入了[target]的[target.parse_zone_with_bodypart(target_zone)]！"),
	)
	return ..()
