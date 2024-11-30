
/////BURN FIXING SURGERIES//////

//the step numbers of each of these two, we only currently use the first to switch back and forth due to advancing after finishing steps anyway
#define REALIGN_INNARDS 1
#define WELD_VEINS 2

///// Repair puncture wounds
/datum/surgery/repair_puncture
	name = "修复穿刺伤"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/pierce/bleed
	target_mobtypes = list(/mob/living/carbon)
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
		/datum/surgery_step/repair_innards,
		/datum/surgery_step/seal_veins,
		/datum/surgery_step/close,
	)

/datum/surgery/repair_puncture/can_start(mob/living/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return .

	var/datum/wound/pierce/bleed/pierce_wound = target.get_bodypart(user.zone_selected).get_wound_type(targetable_wound)
	ASSERT(pierce_wound, "[type] on [target] has no pierce wound when it should have been guaranteed to have one by can_start")
	return pierce_wound.blood_flow > 0

//SURGERY STEPS

///// realign the blood vessels so we can reweld them
/datum/surgery_step/repair_innards
	name = "重新排列血管 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCALPEL = 85,
		TOOL_WIRECUTTER = 40)
	time = 3 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'
	surgery_effects_mood = TRUE

/datum/surgery_step/repair_innards/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		user.visible_message(span_notice("[user]在寻找[target]的[target.parse_zone_with_bodypart(user.zone_selected)]。"), span_notice("你在寻找 [target] 的 [target.parse_zone_with_bodypart(user.zone_selected)]..."))
		return

	if(pierce_wound.blood_flow <= 0)
		to_chat(user, span_notice("[target]的[target.parse_zone_with_bodypart(user.zone_selected)]没有需要修复的穿刺伤！"))
		surgery.status++
		return

	display_results(
		user,
		target,
		span_notice("你开始重新排列[target]的[target.parse_zone_with_bodypart(user.zone_selected)]中断裂的血管..."),
		span_notice("[user]开始使用[tool]重新排列[target]的[target.parse_zone_with_bodypart(user.zone_selected)]中断裂的血管。"),
		span_notice("[user]开始重新排列[target]的[target.parse_zone_with_bodypart(user.zone_selected)]中的血管。"),
	)
	display_pain(target, "你感到你的[target.parse_zone_with_bodypart(user.zone_selected)]处传来一阵可怕的刺痛！")

/datum/surgery_step/repair_innards/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		to_chat(user, span_warning("[target]在那里没有穿刺伤!"))
		return ..()

	display_results(
		user,
		target,
		span_notice("你成功重新排列了[target]的[target.parse_zone_with_bodypart(target_zone)]中一些血管。"),
		span_notice("[user]使用[tool]成功重新排列了[target]的[target.parse_zone_with_bodypart(target_zone)]中一些血管！"),
		span_notice("[user]成功重新排列了[target]的[target.parse_zone_with_bodypart(target_zone)]中的一些血管！"),
	)
	log_combat(user, target, "切除了感染的肉体", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	surgery.operated_bodypart.receive_damage(brute=3, wound_bonus=CANT_WOUND)
	pierce_wound.adjust_blood_flow(-0.25)
	return ..()

/datum/surgery_step/repair_innards/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	. = ..()
	display_results(
		user,
		target,
		span_notice("你不小心扯断了[target]的[target.parse_zone_with_bodypart(target_zone)]中一些血管。"),
		span_notice("[user]使用[tool]扯断了[target]的[target.parse_zone_with_bodypart(target_zone)]中一些血管！"),
		span_notice("[user]扯断了[target]的[target.parse_zone_with_bodypart(target_zone)]中的一些血管！"),
	)
	surgery.operated_bodypart.receive_damage(brute=rand(4,8), sharpness=SHARP_EDGED, wound_bonus = 10)

///// Sealing the vessels back together
/datum/surgery_step/seal_veins
	name = "缝合血管 (缝合器)" // if your doctor says they're going to weld your blood vessels back together, you're either A) on SS13, or B) in grave mortal peril
	implements = list(
		TOOL_CAUTERY = 100,
		/obj/item/gun/energy/laser = 90,
		TOOL_WELDER = 70,
		/obj/item = 30)
	time = 4 SECONDS
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/seal_veins/tool_check(mob/user, obj/item/tool)
	if(implement_type == TOOL_WELDER || implement_type == /obj/item)
		return tool.get_temperature()

	return TRUE

/datum/surgery_step/seal_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		user.visible_message(span_notice("[user]正在寻找[target]的[target.parse_zone_with_bodypart(user.zone_selected)]."), span_notice("You look for [target]'s [target.parse_zone_with_bodypart(user.zone_selected)]..."))
		return
	display_results(
		user,
		target,
		span_notice("你开始将[target]的[target.parse_zone_with_bodypart(user.zone_selected)]..."),
		span_notice("[user]开始用[tool]将[target]的[target.parse_zone_with_bodypart(user.zone_selected)]内部分裂的血管熔合在一起。"),
		span_notice("[user]开始熔合[target]的[target.parse_zone_with_bodypart(user.zone_selected)]内部分裂的血管。"),
	)
	display_pain(target, "你感到[target.parse_zone_with_bodypart(user.zone_selected)]里有灼烧感！")

/datum/surgery_step/seal_veins/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		to_chat(user, span_warning("[target]那里没有穿刺伤！"))
		return ..()

	display_results(
		user,
		target,
		span_notice("你成功用[tool]将[target]的[target.parse_zone_with_bodypart(target_zone)]内部分裂的血管熔合在一起。"),
		span_notice("[user]成功用[tool]将[target]的[target.parse_zone_with_bodypart(target_zone)]内部分裂的血管熔合在一起！"),
		span_notice("[user]成功熔合了[target]的[target.parse_zone_with_bodypart(target_zone)]内部分裂的血管！"),
	)
	log_combat(user, target, "造成了烧伤", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	pierce_wound.adjust_blood_flow(-0.5)
	if(pierce_wound.blood_flow > 0)
		surgery.status = REALIGN_INNARDS
		to_chat(user, span_notice("<i>似乎还有一些血管错位需要处理...</i>"))
	else
		to_chat(user, span_green("你已经修复了[target]的[target.parse_zone_with_bodypart(target_zone)]!"))
	return ..()

#undef REALIGN_INNARDS
#undef WELD_VEINS
