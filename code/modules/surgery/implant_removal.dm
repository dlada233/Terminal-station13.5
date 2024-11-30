/datum/surgery/implant_removal
	name = "移除植入物"
	target_mobtypes = list(/mob/living)
	possible_locs = list(BODY_ZONE_CHEST)
	surgery_flags = SURGERY_REQUIRE_RESTING
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/extract_implant,
		/datum/surgery_step/close,
	)

//extract implant
/datum/surgery_step/extract_implant
	name = "移除植入物 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_CROWBAR = 65,
		/obj/item/kitchen/fork = 35)
	time = 64
	success_sound = 'sound/surgery/hemostat1.ogg'
	var/obj/item/implant/implant

/datum/surgery_step/extract_implant/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	for(var/obj/item/object in target.implants)
		implant = object
		break
	if(implant)
		display_results(
			user,
			target,
			span_notice("你开始从[target]的[target_zone]中取出[implant]..."),
			span_notice("[user]开始从[target]的[target_zone]中取出[implant]."),
			span_notice("[user]开始从[target]的[target_zone]中取出某物."),
		)
		display_pain(target, "你感到[target_zone]传来剧烈的疼痛!")
	else
		display_results(
			user,
			target,
			span_notice("你在[target]的[target_zone]中寻找植入物..."),
			span_notice("[user]在[target]的[target_zone]中寻找植入物."),
			span_notice("[user]在[target]的[target_zone]中寻找某物."),
		)

/datum/surgery_step/extract_implant/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(implant)
		display_results(
			user,
			target,
			span_notice("你成功地从[target]的[target_zone]中取出[implant]."),
			span_notice("[user]成功地从[target]的[target_zone]中取出[implant]!"),
			span_notice("[user]成功地从[target]的[target_zone]中取出某物!"),
		)
		display_pain(target, "你能感觉到[implant.name]被从你体内拔出!")
		implant.removed(target)

		if (QDELETED(implant))
			return ..()

		var/obj/item/implantcase/case
		for(var/obj/item/implantcase/implant_case in user.held_items)
			case = implant_case
			break
		if(!case)
			case = locate(/obj/item/implantcase) in get_turf(target)
		if(case && !case.imp)
			case.imp = implant
			implant.forceMove(case)
			case.update_appearance()
			display_results(
				user,
				target,
				span_notice("你将[implant]放入[case]中."),
				span_notice("[user]将[implant]放入[case]中!"),
				span_notice("[user]将它放入[case]中!"),
			)
		else
			qdel(implant)

	else
		to_chat(user, span_warning("你在[target]的[target_zone]中什么也没找到!"))
	return ..()

/datum/surgery/implant_removal/mechanic
	name = "移除植入物"
	requires_bodypart_type = BODYTYPE_ROBOTIC
	target_mobtypes = list(/mob/living/carbon/human) // Simpler mobs don't have bodypart types
	surgery_flags = parent_type::surgery_flags | SURGERY_REQUIRE_LIMB
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/extract_implant,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close)
