/datum/surgery/autopsy
	name = "尸检解刨"
	surgery_flags = SURGERY_IGNORE_CLOTHES | SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_MORBID_CURIOSITY
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/autopsy,
		/datum/surgery_step/close,
	)

/datum/surgery/autopsy/can_start(mob/user, mob/living/patient)
	if(!..())
		return FALSE
	if(patient.stat != DEAD)
		return FALSE
	if(HAS_TRAIT_FROM(patient, TRAIT_DISSECTED, AUTOPSY_TRAIT))
		return FALSE
	return TRUE

/datum/surgery_step/autopsy
	name = "执行尸检 (尸检扫描仪)"
	implements = list(/obj/item/autopsy_scanner = 100)
	time = 10 SECONDS
	success_sound = 'sound/machines/printer.ogg'

/datum/surgery_step/autopsy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始对[target]进行尸检..."),
		span_notice("[user]使用[tool]对[target]进行尸检."),
		span_notice("[user]将[tool]放在[target]的胸口上."),
	)
	display_pain(target, "你感到胸口有灼烧感!")

/datum/surgery_step/autopsy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/autopsy_scanner/tool, datum/surgery/surgery, default_display_results = FALSE)
	ADD_TRAIT(target, TRAIT_DISSECTED, AUTOPSY_TRAIT)
	if(!HAS_TRAIT(src, TRAIT_SURGICALLY_ANALYZED))
		ADD_TRAIT(target, TRAIT_SURGICALLY_ANALYZED, AUTOPSY_TRAIT)
	tool.scan_cadaver(user, target)
	var/obj/machinery/computer/operating/operating_computer = surgery.locate_operating_computer(get_turf(target))
	if (!isnull(operating_computer))
		SEND_SIGNAL(operating_computer, COMSIG_OPERATING_COMPUTER_AUTOPSY_COMPLETE, target)
	if(HAS_MIND_TRAIT(user, TRAIT_MORBID) && ishuman(user))
		var/mob/living/carbon/human/morbid_weirdo = user
		morbid_weirdo.add_mood_event("morbid_dissection_success", /datum/mood_event/morbid_dissection_success)
	return ..()

/datum/surgery_step/autopsy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("你搞砸了，弄伤了[target]的胸口!"),
		span_warning("[user]搞砸了，弄伤了[target]的胸口!"),
		span_warning("[user]搞砸了!"),
	)
	target.adjustBruteLoss(5)
