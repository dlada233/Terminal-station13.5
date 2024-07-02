/// Captive Xeno has been found dead, regardless of location.
#define CAPTIVE_XENO_DEAD "captive_xeno_dead"
/// Captive Xeno has been found alive and within the captivity area.
#define CAPTIVE_XENO_FAIL "captive_xeno_failed"
/// Captive Xeno has been found alive and outside of the captivity area.
#define CAPTIVE_XENO_PASS "captive_xeno_escaped"

/datum/team/xeno
	name = "\improper 异形"

//Simply lists them.
/datum/team/xeno/roundend_report()
	var/list/parts = list()
	parts += "<span class='header'>[name]是:</span>"
	parts += printplayerlist(members)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"

/datum/antagonist/xeno
	name = "\improper 异形"
	job_rank = ROLE_ALIEN
	show_in_antagpanel = FALSE
	antagpanel_category = ANTAG_GROUP_XENOS
	prevent_roundtype_conversion = FALSE
	show_to_ghosts = TRUE
	var/datum/team/xeno/xeno_team

/datum/antagonist/xeno/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/xeno/create_team(datum/team/xeno/new_team)
	if(!new_team)
		for(var/datum/antagonist/xeno/X in GLOB.antagonists)
			if(!X.owner || !X.xeno_team)
				continue
			xeno_team = X.xeno_team
			return
		xeno_team = new
	else
		if(!istype(new_team))
			CRASH("Wrong xeno team type provided to create_team")
		xeno_team = new_team

/datum/antagonist/xeno/get_team()
	return xeno_team

/datum/antagonist/xeno/get_preview_icon()
	return finish_preview_icon(icon('icons/mob/nonhuman-player/alien.dmi', "alienh"))

/datum/antagonist/xeno/forge_objectives()
	var/datum/objective/advance_hive/objective = new
	objective.owner = owner
	objectives += objective

/datum/antagonist/xeno/captive
	name = "\improper 被囚禁的异形"
	///Our associated antagonist team for captive xenomorphs
	var/datum/team/xeno/captive/captive_team

/datum/antagonist/xeno/captive/create_team(datum/team/xeno/captive/new_team)
	if(!new_team)
		for(var/datum/antagonist/xeno/captive/captive_xeno in GLOB.antagonists)
			if(!captive_xeno.owner || !captive_xeno.captive_team)
				continue
			captive_team = captive_xeno.captive_team
			return
		captive_team = new
		captive_team.progenitor = owner
	else
		if(!istype(new_team))
			CRASH("Wrong xeno team type provided to create_team")
		captive_team = new_team

/datum/antagonist/xeno/captive/get_team()
	return captive_team

/datum/antagonist/xeno/captive/forge_objectives()
	var/datum/objective/escape_captivity/objective = new
	objective.owner = owner
	objectives += objective
	..()

//Xeno Objectives
/datum/objective/escape_captivity

/datum/objective/escape_captivity/New()
	explanation_text = "逃离囚禁."

/datum/objective/escape_captivity/check_completion()
	if(!istype(get_area(owner), GLOB.communications_controller.captivity_area))
		return TRUE

/datum/objective/advance_hive

/datum/objective/advance_hive/New()
	explanation_text = "生存并发展巢穴."

/datum/objective/advance_hive/check_completion()
	return owner.current.stat != DEAD

///Captive Xenomorphs team
/datum/team/xeno/captive
	name = "\improper 被囚禁的异形"
	///The first member of this team, presumably the queen.
	var/datum/mind/progenitor

/datum/team/xeno/captive/roundend_report()
	var/list/parts = list()
	var/escape_count = 0 //counts the number of xenomorphs that were born in captivity who ended the round outside of it
	var/captive_count = 0 //counts the number of xenomorphs born in captivity who remained there until the end of the round (losers)

	parts += "<span class='header'>[name]是:</span> <br>"

	if(check_captivity(progenitor.current) == CAPTIVE_XENO_PASS)
		parts += span_greentext("巢穴的源兽是[progenitor.key]，作为[progenitor]，它成功逃离了囚禁!") + "<br>"
	else
		parts += span_redtext("巢穴的源兽是[progenitor.key]，作为[progenitor]，它没能逃离囚禁!") + "<br>"

	for(var/datum/mind/alien_mind in members)
		if(alien_mind == progenitor)
			continue

		switch(check_captivity(alien_mind.current))
			if(CAPTIVE_XENO_DEAD)
				parts += "[printplayer(alien_mind, fleecheck = FALSE)]正尝试逃离囚禁!"
			if(CAPTIVE_XENO_FAIL)
				parts += "[printplayer(alien_mind, fleecheck = FALSE)]被囚禁中!"
				captive_count++
			if(CAPTIVE_XENO_PASS)
				parts += "[printplayer(alien_mind, fleecheck = FALSE)]成功[span_greentext("逃离囚禁!")]"
				escape_count++

	parts += "<br> <span class='neutraltext big'> 最终，[captive_count]只异形仍然活囚禁之下，而[escape_count]只成功逃离了!</span> <br>"

	var/thank_you_message
	if(captive_count > escape_count)
		thank_you_message = "异形生物收容工程"
	else
		thank_you_message = "异形生物战斗力测试项目"

	parts += "<span class='neutraltext'>纳米传讯感谢[station_name()]为<b>[thank_you_message]<b>提供了宝贵的研究数据.</span>"

	return "<div class='panel redborder'>[parts.Join("<br>")]</div> <br>"

/datum/team/xeno/captive/proc/check_captivity(mob/living/captive_alien)
	if(!captive_alien || captive_alien.stat == DEAD)
		return CAPTIVE_XENO_DEAD

	if(istype(get_area(captive_alien), GLOB.communications_controller.captivity_area))
		return CAPTIVE_XENO_FAIL

	return CAPTIVE_XENO_PASS

//XENO
/mob/living/carbon/alien/mind_initialize()
	..()
	if(!mind.has_antag_datum(/datum/antagonist/xeno))
		if(GLOB.communications_controller.xenomorph_egg_delivered && istype(get_area(src), GLOB.communications_controller.captivity_area))
			mind.add_antag_datum(/datum/antagonist/xeno/captive)
		else
			mind.add_antag_datum(/datum/antagonist/xeno)

		mind.set_assigned_role(SSjob.GetJobType(/datum/job/xenomorph))
		mind.special_role = ROLE_ALIEN

/mob/living/carbon/alien/on_wabbajacked(mob/living/new_mob)
	. = ..()
	if(!mind)
		return
	if(isalien(new_mob))
		return
	mind.remove_antag_datum(/datum/antagonist/xeno)
	mind.set_assigned_role(SSjob.GetJobType(/datum/job/unassigned))
	mind.special_role = null

#undef CAPTIVE_XENO_DEAD
#undef CAPTIVE_XENO_FAIL
#undef CAPTIVE_XENO_PASS
