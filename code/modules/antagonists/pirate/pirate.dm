/datum/antagonist/pirate
	name = "\improper 太空海盗"
	job_rank = ROLE_TRAITOR
	roundend_category = "太空海盗"
	antagpanel_category = ANTAG_GROUP_PIRATES
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	suicide_cry = "为了伙计们!!"
	hijack_speed = 2 // That is without doubt the worst pirate I have ever seen.
	var/datum/team/pirate/crew

/datum/antagonist/pirate/greet()
	. = ..()
	to_chat(owner, "<B>空间站拒绝交出保护费，保护你的海盗船，抽取站点的信用点以及突袭它以掠夺更多的战利品.</B>")
	owner.announce_objectives()

/datum/antagonist/pirate/get_team()
	return crew

/datum/antagonist/pirate/create_team(datum/team/pirate/new_team)
	if(!new_team)
		for(var/datum/antagonist/pirate/P in GLOB.antagonists)
			if(!P.owner)
				stack_trace("Antagonist datum without owner in GLOB.antagonists: [P]")
				continue
			if(P.crew)
				crew = P.crew
				return
		if(!new_team)
			crew = new /datum/team/pirate
			crew.forge_objectives()
			return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	crew = new_team

/datum/antagonist/pirate/on_gain()
	if(crew)
		objectives |= crew.objectives
	. = ..()

/datum/antagonist/pirate/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/owner_mob = mob_override || owner.current
	var/datum/language_holder/holder = owner_mob.get_language_holder()
	holder.grant_language(/datum/language/piratespeak, source = LANGUAGE_PIRATE)
	holder.selected_language = /datum/language/piratespeak

/datum/antagonist/pirate/remove_innate_effects(mob/living/mob_override)
	var/mob/living/owner_mob = mob_override || owner.current
	owner_mob.remove_language(/datum/language/piratespeak, source = LANGUAGE_PIRATE)
	return ..()

/datum/team/pirate
	name = "\improper 海盗船员"

/datum/team/pirate/proc/forge_objectives()
	var/datum/objective/loot/getbooty = new()
	getbooty.team = src
	for(var/obj/machinery/computer/piratepad_control/P as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/computer/piratepad_control))
		var/area/A = get_area(P)
		if(istype(A,/area/shuttle/pirate))
			getbooty.cargo_hold = P
			break
	getbooty.update_explanation_text()
	objectives += getbooty
	for(var/datum/mind/M in members)
		var/datum/antagonist/pirate/P = M.has_antag_datum(/datum/antagonist/pirate)
		if(P)
			P.objectives |= objectives


/datum/objective/loot
	var/obj/machinery/computer/piratepad_control/cargo_hold
	explanation_text = "掠夺高价值战利品并存放在指定区域."
	var/target_value = 50000


/datum/objective/loot/update_explanation_text()
	if(cargo_hold)
		var/area/storage_area = get_area(cargo_hold)
		explanation_text = "掠夺价值[target_value]信用点的战利品并存放进[storage_area.name]货舱中."

/datum/objective/loot/proc/loot_listing()
	//Lists notable loot.
	if(!cargo_hold || !cargo_hold.total_report)
		return "无"
	cargo_hold.total_report.total_value = sortTim(cargo_hold.total_report.total_value, cmp = GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)
	var/count = 0
	var/list/loot_texts = list()
	for(var/datum/export/E in cargo_hold.total_report.total_value)
		count++
		if(count > 5)
			break
		loot_texts += E.total_printout(cargo_hold.total_report,notes = FALSE)
	return loot_texts.Join(", ")

/datum/objective/loot/proc/get_loot_value()
	return cargo_hold ? cargo_hold.points : 0

/datum/objective/loot/check_completion()
	return ..() || get_loot_value() >= target_value

/datum/team/pirate/roundend_report()
	var/list/parts = list()

	parts += "<span class='header'>太空海盗名单:</span>"

	var/all_dead = TRUE
	for(var/datum/mind/M in members)
		if(considered_alive(M))
			all_dead = FALSE
	parts += printplayerlist(members)

	parts += "到手的战利品: "
	var/datum/objective/loot/L = locate() in objectives
	parts += L.loot_listing()
	parts += "战利品总价值 : [L.get_loot_value()]/[L.target_value] 信用点"

	if(L.check_completion() && !all_dead)
		parts += "<span class='greentext big'>海盗船员们成功了!</span>"
	else
		parts += "<span class='redtext big'>海盗船员们失败了.</span>"

	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"
