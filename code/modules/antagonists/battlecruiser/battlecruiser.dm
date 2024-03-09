/datum/team/battlecruiser
	name = "\improper 战列巡洋舰船员"
	member_name = "船员"
	/// The central objective of this battlecruiser
	var/core_objective = /datum/objective/nuclear
	/// The assigned nuke of this team
	var/obj/machinery/nuclearbomb/nuke

/datum/team/battlecruiser/proc/update_objectives()
	if(core_objective)
		var/datum/objective/objective = new core_objective()
		objective.team = src
		objectives += objective

/datum/antagonist/battlecruiser
	name = "战列巡洋舰船员"
	show_to_ghosts = TRUE
	roundend_category = "战列巡洋舰上的辛迪加特工"
	suicide_cry = "辛迪加万岁!!!"
	antag_hud_name = "battlecruiser_crew"
	antagpanel_category = ANTAG_GROUP_SYNDICATE
	job_rank = ROLE_BATTLECRUISER_CREW
	/// Team to place the crewmember on.
	var/datum/team/battlecruiser/battlecruiser_team

/datum/antagonist/battlecruiser/get_team()
	return battlecruiser_team

/datum/antagonist/battlecruiser/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ops.ogg',100,0, use_reverb = FALSE)
	to_chat(owner, span_big("你是一名[name]!"))
	owner.announce_objectives()

/datum/antagonist/battlecruiser/ally
	name = "战列巡洋舰助手"
	show_to_ghosts = FALSE

/datum/antagonist/battlecruiser/captain
	name = "战列巡洋舰舰长"
	antag_hud_name = "battlecruiser_lead"
	job_rank = ROLE_BATTLECRUISER_CAPTAIN

/datum/antagonist/battlecruiser/create_team(datum/team/battlecruiser/team)
	if(!team)
		return
	if(!istype(team))
		stack_trace("Wrong team type passed to [type] initialization.")
	battlecruiser_team = team

/datum/antagonist/battlecruiser/apply_innate_effects(mob/living/mob_override)
	add_team_hud(mob_override || owner.current, /datum/antagonist/battlecruiser)

/datum/antagonist/battlecruiser/on_gain()
	if(!battlecruiser_team)
		return ..()

	objectives |= battlecruiser_team.objectives
	if(battlecruiser_team.nuke)
		var/obj/machinery/nuclearbomb/nuke = battlecruiser_team.nuke
		antag_memory += "<B>[nuke]密码</B>: [nuke.r_code]<br>"
		owner.add_memory(/datum/memory/key/nuke_code, nuclear_code = nuke.r_code)
		to_chat(owner, "核武授权码是: <B>[nuke.r_code]</B>")
	return ..()
