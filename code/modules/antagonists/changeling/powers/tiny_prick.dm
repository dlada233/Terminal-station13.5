/datum/action/changeling/sting//parent path, not meant for users afaik
	name = "Tiny Prick"
	desc = "Stabby stabby"

/datum/action/changeling/sting/Trigger(trigger_flags)
	var/mob/user = owner
	if(!user || !user.mind)
		return
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!changeling)
		return
	if(!changeling.chosen_sting)
		set_sting(user)
	else
		unset_sting(user)
	return

/datum/action/changeling/sting/proc/set_sting(mob/user)
	to_chat(user, span_notice("我们准备好叮咬了.Alt加左键或鼠标中键目标来叮咬他们."))
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	changeling.chosen_sting = src

	changeling.lingstingdisplay.icon_state = button_icon_state
	changeling.lingstingdisplay.SetInvisibility(0, id=type)

/datum/action/changeling/sting/proc/unset_sting(mob/user)
	to_chat(user, span_warning("我们收回了叮刺，现在无法叮咬任何人了."))
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	changeling.chosen_sting = null

	changeling.lingstingdisplay.icon_state = null
	changeling.lingstingdisplay.RemoveInvisibility(type)

/mob/living/carbon/proc/unset_sting()
	if(mind)
		var/datum/antagonist/changeling/changeling = mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling?.chosen_sting)
			changeling.chosen_sting.unset_sting(src)

/datum/action/changeling/sting/can_sting(mob/user, mob/target)
	if(!..())
		return
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!changeling.chosen_sting)
		to_chat(user, "我们还没准备好叮刺!")
	if(!iscarbon(target))
		return
	if(!isturf(user.loc))
		return
	var/mob/living/carbon/human/to_check = target // SKYRAT EDIT START - STINGS DO NOT AFFECT ROBOTIC ENTITIES
	if(to_check.mob_biotypes & MOB_ROBOTIC)
		to_chat(user, "<span class='warning'>我们的叮刺对机器人对象没有任何作用</span>")
		return // SKYRAT EDIT END
	if(!length(get_path_to(user, target, max_distance = changeling.sting_range, simulated_only = FALSE)))
		return // no path within the sting's range is found. what a weird place to use the pathfinding system
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/changeling))
		sting_feedback(user, target)
		changeling.chem_charges -= chemical_cost
	return 1

/datum/action/changeling/sting/sting_feedback(mob/user, mob/target)
	if(!target)
		return
	to_chat(user, span_notice("我们悄悄地叮咬了[target.name]."))
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(target, span_warning("你感到一点刺痛."))
	return 1

/datum/action/changeling/sting/transformation
	name = "变形叮刺"
	desc = "我们可以悄悄地叮咬生物，注射逆转录病毒迫使它们变形. 消耗33点化学物质."
	helptext = "对象会像化形一样变形. \
		对复杂的类人生物，只会暂时变形，但持续时间不会在死亡和静滞状态下减少. \
		对于更简单的类人生物，比如猴子，那么将永久地改变外形. \
		叮咬时不会警告他人. 突变不会被变形."
	button_icon_state = "sting_transform"
	chemical_cost = 33 // Low enough that you can sting only two people in quick succession
	dna_cost = 2
	/// A reference to our active profile, which we grab DNA from
	VAR_FINAL/datum/changeling_profile/selected_dna
	/// Duration of the sting
	var/sting_duration = 8 MINUTES

/datum/action/changeling/sting/transformation/Grant(mob/grant_to)
	. = ..()
	build_all_button_icons(UPDATE_BUTTON_NAME)

/datum/action/changeling/sting/transformation/update_button_name(atom/movable/screen/movable/action_button/button, force)
	. = ..()
	button.desc += "对人类使用时效果将持续[DisplayTimeText(sting_duration)]，且该持续时间在对象陷入死亡或静滞状态下不会减少."
	button.desc += "花费[chemical_cost]点化学物质."

/datum/action/changeling/sting/transformation/Destroy()
	selected_dna = null
	return ..()

/datum/action/changeling/sting/transformation/set_sting(mob/user)
	selected_dna = null
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	var/datum/changeling_profile/new_selected_dna = changeling.select_dna()
	if(QDELETED(src) || QDELETED(changeling) || QDELETED(user))
		return
	if(!new_selected_dna || changeling.chosen_sting || selected_dna) // selected other sting or other DNA while sleeping
		return
	selected_dna = new_selected_dna
	return ..()

/datum/action/changeling/sting/transformation/can_sting(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return
	// Similar checks here are ran to that of changeling can_absorb_dna -
	// Logic being that if their DNA is incompatible with us, it's also bad for transforming
	if(!iscarbon(target) \
		|| !target.has_dna() \
		|| HAS_TRAIT(target, TRAIT_HUSK) \
		|| HAS_TRAIT(target, TRAIT_BADDNA) \
		|| (HAS_TRAIT(target, TRAIT_NO_DNA_COPY) && !ismonkey(target))) // sure, go ahead, make a monk-clone
		user.balloon_alert(user, "不兼容的DNA!")
		return FALSE
	if(target.has_status_effect(/datum/status_effect/temporary_transformation/trans_sting))
		user.balloon_alert(user, "已经变形!")
		return FALSE
	return TRUE

/datum/action/changeling/sting/transformation/sting_action(mob/living/user, mob/living/target)
	var/final_duration = sting_duration
	var/final_message = span_notice("我们将[target]变形为[selected_dna.dna.real_name].")
	if(ismonkey(target))
		final_duration = INFINITY
		final_message = span_warning("当我们将退形的[target]永久变形为[selected_dna.dna.real_name]时，我们的基因正在嚎哭!")

	if(target.apply_status_effect(/datum/status_effect/temporary_transformation/trans_sting, final_duration, selected_dna.dna))
		..()
		log_combat(user, target, "刺痛", "变形叮刺", "新身份为 '[selected_dna.dna.real_name]'")
		to_chat(user, final_message)
		return TRUE
	return FALSE

/datum/action/changeling/sting/false_armblade
	name = "伪臂刃叮刺"
	desc = "我们悄悄地叮咬一名人类，注射逆转录病毒迫使他们的手臂暂时突变成一把臂刃. 消耗20点化学物质."
	helptext = "被注射对象的手臂将突变成一个外形逼真的化形臂刃，但实际上这把臂刃钝且无用."
	button_icon_state = "sting_armblade"
	chemical_cost = 20
	dna_cost = 1

/obj/item/melee/arm_blade/false
	desc = "一大块奇怪的肉，本来这个地方应该长着你的胳膊. 虽然看起来很危险，但实际上你发现它钝而无用."
	force = 5 //Basically as strong as a punch
	fake = TRUE

/datum/action/changeling/sting/false_armblade/can_sting(mob/user, mob/target)
	if(!..())
		return
	if(isliving(target))
		var/mob/living/L = target
		if((HAS_TRAIT(L, TRAIT_HUSK)) || !L.has_dna())
			user.balloon_alert(user, "不兼容的DNA!")
			return FALSE
	return TRUE

/datum/action/changeling/sting/false_armblade/sting_action(mob/user, mob/target)

	var/obj/item/held = target.get_active_held_item()
	if(held && !target.dropItemToGround(held))
		to_chat(user, span_warning("[held]卡在目标的手中，你没法在它上面长出伪臂刃!"))
		return

	..()
	log_combat(user, target, "叮咬", object = "伪臂刃叮刺")
	if(ismonkey(target))
		to_chat(user, span_notice("当我们叮咬[target.name]时，我们的基因在嚎哭!"))

	var/obj/item/melee/arm_blade/false/blade = new(target,1)
	target.put_in_hands(blade)
	target.visible_message(span_warning("[target.name]的手臂周围长出了怪异刀刃!"), span_userdanger("你的手臂扭曲变异，变成了可怖的怪异形状!"), span_hear("你听到有机物撕扯的声音!"))
	playsound(target, 'sound/effects/blobattack.ogg', 30, TRUE)

	addtimer(CALLBACK(src, PROC_REF(remove_fake), target, blade), 600)
	return TRUE

/datum/action/changeling/sting/false_armblade/proc/remove_fake(mob/target, obj/item/melee/arm_blade/false/blade)
	playsound(target, 'sound/effects/blobattack.ogg', 30, TRUE)
	target.visible_message("<span class='warning'>伴随着令人作呕的嘎吱声, \
	[target]将自己的[blade.name]化成了一只手臂!</span>",
	span_warning("[blade]突变恢复正常."),
	"<span class='italics>你听到有机物撕扯的声音!</span>")

	qdel(blade)
	target.update_held_items()

/datum/action/changeling/sting/extract_dna
	name = "DNA提取叮刺"
	desc = "我们可以悄悄地提取出目标的DNA. 花费25点化学物质."
	helptext = "将会给你们目标的DNA，你可以运用它将自己变形成目标形象."
	button_icon_state = "sting_extract"
	chemical_cost = 25
	dna_cost = 0

/datum/action/changeling/sting/extract_dna/can_sting(mob/user, mob/target)
	if(..())
		var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
		return changeling.can_absorb_dna(target)

/datum/action/changeling/sting/extract_dna/sting_action(mob/user, mob/living/carbon/human/target)
	..()
	log_combat(user, target, "叮咬", "提取叮刺")
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!changeling.has_profile_with_dna(target.dna))
		changeling.add_new_profile(target)
	return TRUE

/datum/action/changeling/sting/mute
	name = "噤声叮刺"
	desc = "我们可以悄悄地叮咬一名人类，短时间内目标陷入完全的沉默状态. 花费20点化学物质."
	helptext = "除非目标试图说话，否则他们不会收到被叮咬的警告."
	button_icon_state = "sting_mute"
	chemical_cost = 20
	dna_cost = 2

/datum/action/changeling/sting/mute/sting_action(mob/user, mob/living/carbon/target)
	..()
	log_combat(user, target, "叮咬", "噤声叮刺")
	target.adjust_silence(1 MINUTES)
	return TRUE

/datum/action/changeling/sting/blind
	name = "致盲叮刺"
	desc = "我们可以暂时地使目标陷入失明. 花费25点化学物质."
	helptext = "这种叮咬将使目标在短时间内完全失明，并在长时间内视线模糊，但若目标没有眼睛或植入了机械类义眼则无效."
	button_icon_state = "sting_blind"
	chemical_cost = 25
	dna_cost = 1

/datum/action/changeling/sting/blind/sting_action(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/eyes/eyes = target.get_organ_slot(ORGAN_SLOT_EYES)
	if(!eyes)
		user.balloon_alert(user, "没有眼睛!")
		return FALSE

	if(IS_ROBOTIC_ORGAN(eyes))
		user.balloon_alert(user, "机械类义眼!")
		return FALSE

	..()
	log_combat(user, target, "叮咬", "致盲叮刺")
	to_chat(target, span_danger("你的眼睛吓人地灼烧了起来!"))
	eyes.apply_organ_damage(eyes.maxHealth * 0.8)
	target.adjust_temp_blindness(40 SECONDS)
	target.set_eye_blur_if_lower(80 SECONDS)
	return TRUE

/datum/action/changeling/sting/lsd
	name = "幻觉叮刺"
	desc = "我们可以使目标陷入巨大的恐慌之中. 花费10点化学物质."
	helptext = "我们进化出了给目标注射强效致幻剂的能力. \
			目标不会察觉到自己被叮咬了，而致幻剂会在叮咬后30到60秒起效."
	button_icon_state = "sting_lsd"
	chemical_cost = 10
	dna_cost = 1

/datum/action/changeling/sting/lsd/sting_action(mob/user, mob/living/carbon/target)
	..()
	log_combat(user, target, "叮咬", "LSD叮刺")
	addtimer(CALLBACK(src, PROC_REF(hallucination_time), target), rand(30 SECONDS, 60 SECONDS))
	return TRUE

/datum/action/changeling/sting/lsd/proc/hallucination_time(mob/living/carbon/target)
	if(QDELETED(src) || QDELETED(target))
		return
	target.adjust_hallucinations(180 SECONDS)

/datum/action/changeling/sting/cryo
	name = "冻结叮刺"
	desc = "我们可以悄悄地向目标注射一种化学混合物以降低其体内温度直到冻僵. 花费15点化学物质."
	helptext = "目标不会收到被叮咬警告，但他们能知晓自己突然快要冻僵了."
	button_icon_state = "sting_cryo"
	chemical_cost = 15
	dna_cost = 2

/datum/action/changeling/sting/cryo/sting_action(mob/user, mob/target)
	..()
	log_combat(user, target, "叮咬", "冻结叮刺")
	if(target.reagents)
		target.reagents.add_reagent(/datum/reagent/consumable/frostoil, 30)
	return TRUE
