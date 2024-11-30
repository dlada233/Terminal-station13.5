/datum/surgery/cavity_implant
	name = "腔体植入"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/handle_cavity,
		/datum/surgery_step/close)

//handle cavity
/datum/surgery_step/handle_cavity
	name = "植入物品"
	accept_hand = 1
	implements = list(/obj/item = 100)
	repeatable = TRUE
	time = 32
	preop_sound = 'sound/surgery/organ1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	var/obj/item/item_for_cavity

/datum/surgery_step/handle_cavity/tool_check(mob/user, obj/item/tool)
	if(tool.tool_behaviour == TOOL_CAUTERY || istype(tool, /obj/item/gun/energy/laser))
		return FALSE
	return !tool.get_temperature()

/datum/surgery_step/handle_cavity/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/chest/target_chest = target.get_bodypart(BODY_ZONE_CHEST)
	item_for_cavity = target_chest.cavity_item
	if(tool)
		display_results(
			user,
			target,
			span_notice("你开始将[tool]植入[target]的[target_zone]..."),
			span_notice("[user]开始将[tool]植入[target]的[target_zone]."),
			span_notice("[user]开始将[tool.w_class > WEIGHT_CLASS_SMALL ? tool : "某物"]植入[target]的[target_zone]."),
		)
		display_pain(target, "你能感觉到有东西被放入你的[target_zone]，疼死了!")
	else
		display_results(
			user,
			target,
			span_notice("你检查[target]的[target_zone]里是否有物品..."),
			span_notice("[user]检查[target]的[target_zone]里是否有物品."),
			span_notice("[user]在[target]的[target_zone]里寻找某物."),
		)

/datum/surgery_step/handle_cavity/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery = FALSE)
	var/obj/item/bodypart/chest/target_chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(tool)
		if(item_for_cavity || tool.w_class > WEIGHT_CLASS_NORMAL || HAS_TRAIT(tool, TRAIT_NODROP) || isorgan(tool))
			to_chat(user, span_warning("你似乎无法将[tool]放入[target]的[target_zone]!"))
			return FALSE
		else
			display_results(
				user,
				target,
				span_notice("你将[tool]塞入[target]的[target_zone]."),
				span_notice("[user]将[tool]塞入[target]的[target_zone]!"),
				span_notice("[user]将[tool.w_class > WEIGHT_CLASS_SMALL ? tool : "某物"]塞入[target]的[target_zone]."),
			)
			user.transferItemToLoc(tool, target, TRUE)
			target_chest.cavity_item = tool
			return ..()
	else
		if(item_for_cavity)
			display_results(
				user,
				target,
				span_notice("你从[target]的[target_zone]里取出了[item_for_cavity]."),
				span_notice("[user]从[target]的[target_zone]里取出了[item_for_cavity]!"),
				span_notice("[user]从[target]的[target_zone]里取出了[item_for_cavity.w_class > WEIGHT_CLASS_SMALL ? item_for_cavity : "某物"]."),
			)
			display_pain(target, "有东西从你的[target_zone]里被取出来了! 疼死了!")
			user.put_in_hands(item_for_cavity)
			target_chest.cavity_item = null
			return ..()
		else
			to_chat(user, span_warning("你在[target]的[target_zone]里没有找到任何东西."))
			return FALSE
