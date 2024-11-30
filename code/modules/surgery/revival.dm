/datum/surgery/revival
	name = "复活"
	desc = "一种实验性的手术程序，涉及在死亡后很长时间重建和激活患者的大脑. \
		身体必须仍然能够维持生命."
	requires_bodypart_type = NONE
	possible_locs = list(BODY_ZONE_CHEST)
	target_mobtypes = list(/mob/living)
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_MORBID_CURIOSITY
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/revive,
		/datum/surgery_step/close,
	)

/datum/surgery/revival/can_start(mob/user, mob/living/target)
	if(!..())
		return FALSE
	if(target.stat != DEAD)
		return FALSE
	if(HAS_TRAIT(target, TRAIT_SUICIDED) || HAS_TRAIT(target, TRAIT_HUSK) || HAS_TRAIT(target, TRAIT_DEFIB_BLACKLISTED))
		return FALSE
	if(!is_valid_target(target))
		return FALSE
	return TRUE

/// Extra checks which can be overridden
/datum/surgery/revival/proc/is_valid_target(mob/living/patient)
	if (iscarbon(patient))
		return FALSE
	if (!(patient.mob_biotypes & (MOB_ORGANIC|MOB_HUMANOID)))
		return FALSE
	return TRUE

/datum/surgery_step/revive
	name = "电击大脑 (除颤器)"
	implements = list(
		/obj/item/shockpaddles = 100,
		/obj/item/melee/touch_attack/shock = 100,
		/obj/item/melee/baton/security = 75,
		/obj/item/gun/energy = 60)
	repeatable = TRUE
	time = 5 SECONDS
	success_sound = 'sound/magic/lightningbolt.ogg'
	failure_sound = 'sound/magic/lightningbolt.ogg'

/datum/surgery_step/revive/tool_check(mob/user, obj/item/tool)
	. = TRUE
	if(istype(tool, /obj/item/shockpaddles))
		var/obj/item/shockpaddles/paddles = tool
		if((paddles.req_defib && !paddles.defib.powered) || !HAS_TRAIT(paddles, TRAIT_WIELDED) || paddles.cooldown || paddles.busy)
			to_chat(user, span_warning("你需要同时握住两块电极板，并且[paddles.defib]必须通电！"))
			return FALSE
	if(istype(tool, /obj/item/melee/baton/security))
		var/obj/item/melee/baton/security/baton = tool
		if(!baton.active)
			to_chat(user, span_warning("[baton]需要激活！"))
			return FALSE
	if(istype(tool, /obj/item/gun/energy))
		var/obj/item/gun/energy/egun = tool
		if(egun.chambered && istype(egun.chambered, /obj/item/ammo_casing/energy/electrode))
			return TRUE
		else
			to_chat(user, span_warning("你需要一个电极！"))
			return FALSE

/datum/surgery_step/revive/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你准备用[tool]给[target]的大脑带来生命的火花."),
		span_notice("[user]准备用[tool]电击[target]的大脑."),
		span_notice("[user]准备用[tool]电击[target]的大脑."),
	)
	target.notify_revival("有人正在试图电击你的大脑.", source = target)

/datum/surgery_step/revive/play_preop_sound(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(istype(tool, /obj/item/shockpaddles))
		playsound(tool, 'sound/machines/defib_charge.ogg', 75, 0)
	else
		..()

/datum/surgery_step/revive/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	display_results(
		user,
		target,
		span_notice("你成功地用[tool]电击了[target]的大脑..."),
		span_notice("[user]用[tool]向[target]的大脑发送了强烈的电击..."),
		span_notice("[user]用[tool]向[target]的大脑发送了强烈的电击..."),
	)
	target.grab_ghost()
	target.adjustOxyLoss(-50, 0)
	target.updatehealth()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.set_heartattack(FALSE)
	if(target.revive())
		on_revived(user, target)
		return TRUE

	//SKYRAT EDIT CHANGE - DNR TRAIT - need this so that people don't just keep spamming the revival surgery; it runs success just bc the surgery steps are done
	if(HAS_TRAIT(target, TRAIT_DNR))
		target.visible_message(span_warning("...病患仍然躺着，毫无反应. 进一步的尝试是徒劳的，这个人已经永远地离开了."))
	else
		target.visible_message(span_warning("...病患抽搐了一下，然后躺着不动了."))
	//SKYRAT EDIT CHANGE END - DNR TRAIT - ORIGINAL: target.visible_message(span_warning("...[target.p_they()] convulse[target.p_s()], then lie[target.p_s()] still."))
	return FALSE

/// Called when you have been successfully raised from the dead
/datum/surgery_step/revive/proc/on_revived(mob/surgeon, mob/living/patient)
	patient.visible_message(span_notice("...[patient]醒来了，活着并且意识到了!"))
	patient.emote("gasp")
	to_chat(patient, "<span class='userdanger'>[CONFIG_GET(string/blackoutpolicy)]</span>") //SKYRAT EDIT ADDITION - BLACKOUT POLICY
	if(HAS_MIND_TRAIT(surgeon, TRAIT_MORBID) && ishuman(surgeon)) // Contrary to their typical hatred of resurrection, it wouldn't be very thematic if morbid people didn't love playing god
		var/mob/living/carbon/human/morbid_weirdo = surgeon
		morbid_weirdo.add_mood_event("morbid_revival_success", /datum/mood_event/morbid_revival_success)

/datum/surgery_step/revive/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你用[tool]电击了[target]的大脑，但病患没有反应."),
		span_notice("[user]用[tool]向[target]的大脑发送了强烈的电击，但病患没有反应."),
		span_notice("[user]用[tool]向[target]的大脑发送了强烈的电击，但病患没有反应."),
	)
	return FALSE

/// Additional revival effects if the target has a brain
/datum/surgery/revival/carbon
	possible_locs = list(BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon)
	surgery_flags = parent_type::surgery_flags | SURGERY_REQUIRE_LIMB

/datum/surgery/revival/carbon/is_valid_target(mob/living/carbon/patient)
	var/obj/item/organ/internal/brain/target_brain = patient.get_organ_slot(ORGAN_SLOT_BRAIN)
	return !isnull(target_brain)

/datum/surgery_step/revive/carbon

/datum/surgery_step/revive/carbon/on_revived(mob/surgeon, mob/living/patient)
	. = ..()
	patient.adjustOrganLoss(ORGAN_SLOT_BRAIN, 50, 199) // MAD SCIENCE

/datum/surgery_step/revive/carbon/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	. = ..()
	target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15, 180)
