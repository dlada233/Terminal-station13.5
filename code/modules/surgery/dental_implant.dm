#define MARK_TOOTH 1

/datum/surgery/dental_implant
	name = "牙齿植入"
	possible_locs = list(BODY_ZONE_PRECISE_MOUTH)
	steps = list(
		/datum/surgery_step/drill/pill,
		/datum/surgery_step/insert_pill,
		/datum/surgery_step/search_teeth,
		/datum/surgery_step/close,
	)

/datum/surgery_step/drill/pill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	. = ..()
	var/count = 0
	var/obj/item/bodypart/head/teeth_receptangle = target.get_bodypart(BODY_ZONE_HEAD)

	ASSERT(teeth_receptangle)

	for(var/obj/item/reagent_containers/pill/dental in teeth_receptangle)
		count++

	if(teeth_receptangle.teeth_count == 0)
		to_chat(user, span_notice("[user]没有牙齿，笨蛋!"))
		return SURGERY_STEP_FAIL

	if(count >= teeth_receptangle.teeth_count)
		to_chat(user, span_notice("[user]的牙齿都已经被药丸代替了!"))
		return SURGERY_STEP_FAIL

/datum/surgery_step/insert_pill
	name = "植入药丸"
	implements = list(/obj/item/reagent_containers/pill = 100)
	time = 16

/datum/surgery_step/insert_pill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)

	display_results(
		user,
		target,
		span_notice("你开始将[tool]塞入[target]的[target.parse_zone_with_bodypart(target_zone)]..."),
		span_notice("[user]开始将[tool]塞入[target]的[target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user]开始往[target]的[target.parse_zone_with_bodypart(target_zone)]里塞东西."),
	)
	display_pain(target, "有东西正被塞入你的[target.parse_zone_with_bodypart(target_zone)]!")

/datum/surgery_step/insert_pill/success(mob/user, mob/living/carbon/target, target_zone, obj/item/reagent_containers/pill/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(!istype(tool))
		return FALSE

	// Pills go into head
	user.transferItemToLoc(tool, target.get_bodypart(BODY_ZONE_HEAD), TRUE)

	var/datum/action/item_action/activate_pill/pill_action = new(tool)
	pill_action.name = "激活[tool.name]"
	pill_action.build_all_button_icons()
	pill_action.target = tool
	pill_action.Grant(target) //The pill never actually goes in an inventory slot, so the owner doesn't inherit actions from it

	display_results(
		user,
		target,
		span_notice("你将[tool]塞入[target]的[target.parse_zone_with_bodypart(target_zone)]."),
		span_notice("[user]将[tool]塞入[target]的[target.parse_zone_with_bodypart(target_zone)]!"),
		span_notice("[user]往[target]的[target.parse_zone_with_bodypart(target_zone)]!"),
	)
	return ..()

/datum/action/item_action/activate_pill
	name = "激活药丸"
	check_flags = NONE

/datum/action/item_action/activate_pill/IsAvailable(feedback)
	if(owner.stat > SOFT_CRIT)
		return FALSE
	return ..()

/datum/action/item_action/activate_pill/Trigger(trigger_flags)
	if(!..())
		return FALSE
	owner.balloon_alert_to_viewers("[owner]咬紧牙关!", "你咬紧牙关.")
	if(!do_after(owner, owner.stat * (2.5 SECONDS), owner,  IGNORE_USER_LOC_CHANGE | IGNORE_INCAPACITATED))
		return FALSE
	var/obj/item/item_target = target
	to_chat(owner, span_notice("你咬紧牙关并弄爆了植入的[item_target.name]!"))
	owner.log_message("吞下了植入的药丸，[target]", LOG_ATTACK)
	if(item_target.reagents.total_volume)
		item_target.reagents.trans_to(owner, item_target.reagents.total_volume, transferred_by = owner, methods = INGEST)
	qdel(target)
	return TRUE

/datum/surgery_step/search_teeth
	name = "检查牙齿 (手)"
	accept_hand = TRUE
	time = 2 SECONDS
	repeatable = TRUE

/datum/surgery_step/search_teeth/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始在[target]的嘴里寻找可植入牙齿..."),
		span_notice("[user]开始在[target]的嘴里查看."),
		span_notice("[user]开始检查[target]的牙齿."),
	)
	display_pain(target, "你感到手指在你的牙齿间摸索.")

/datum/surgery_step/search_teeth/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("[user]在[target]的嘴里标记了一颗牙齿."),
		span_notice("[user]在[target]的嘴里标记了一颗牙齿."),
		span_notice("[user]用东西戳了戳[target]嘴里的一颗牙齿."),
	)
	surgery.status = MARK_TOOTH
	return ..()

#undef MARK_TOOTH
