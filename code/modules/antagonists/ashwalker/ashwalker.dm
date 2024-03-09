/datum/antagonist/ashwalker
	name = "\improper 灰烬行者"
	job_rank = ROLE_LAVALAND
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	prevent_roundtype_conversion = FALSE
	antagpanel_category = ANTAG_GROUP_ASHWALKERS
	suicide_cry = "我不知道这东西是做什么用的!!"
	count_against_dynamic_roll_chance = FALSE
	var/datum/team/ashwalkers/ashie_team

/datum/antagonist/ashwalker/create_team(datum/team/ashwalkers/ashwalker_team)
	if(ashwalker_team)
		ashie_team = ashwalker_team
		objectives |= ashie_team.objectives
	else
		ashie_team = new

/datum/antagonist/ashwalker/get_team()
	return ashie_team

/datum/antagonist/ashwalker/on_body_transfer(mob/living/old_body, mob/living/new_body)
	. = ..()
	UnregisterSignal(old_body, COMSIG_MOB_EXAMINATE)
	RegisterSignal(new_body, COMSIG_MOB_EXAMINATE, PROC_REF(on_examinate))

/datum/antagonist/ashwalker/on_gain()
	. = ..()
	RegisterSignal(owner.current, COMSIG_MOB_EXAMINATE, PROC_REF(on_examinate))
	//owner.teach_crafting_recipe(/datum/crafting_recipe/skeleton_key) //SKYRAT EDIT REMOVAL - ASH RITUALS

/datum/antagonist/ashwalker/on_removal()
	. = ..()
	UnregisterSignal(owner.current, COMSIG_MOB_EXAMINATE)

/datum/antagonist/ashwalker/proc/on_examinate(datum/source, atom/A)
	SIGNAL_HANDLER

	if(istype(A, /obj/structure/headpike))
		owner.current.add_mood_event("oogabooga", /datum/mood_event/sacrifice_good)

/datum/team/ashwalkers
	name = "灰烬行者部落"
	member_name = "灰烬行者"
	///A list of "worthy" (meat-bearing) sacrifices made to the Necropolis
	var/sacrifices_made = 0
	///A list of how many eggs were created by the Necropolis
	var/eggs_created = 0

/datum/team/ashwalkers/roundend_report()
	var/list/report = list()

	report += span_header("灰烬行者部落居住在那废土上...</span><br>")
	if(length(members)) //The team is generated alongside the tendril, and it's entirely possible that nobody takes the role.
		report += "[member_name]有:"
		report += printplayerlist(members)

		var/datum/objective/protect_object/necropolis_objective = locate(/datum/objective/protect_object) in objectives

		if(necropolis_objective)
			objectives -= necropolis_objective //So we don't count it in the check for other objectives.
			report += "<b>[name]的任务是保卫墓地:</b>"
			if(necropolis_objective.check_completion())
				report += span_greentext("<span class='header'>巢穴屹立不倒，荣耀归于墓地!</span><br>")
			else
				report += span_redtext("<span class='header'>墓地被摧毁，部落已沦陷...</span><br>")

		if(length(objectives))
			report += span_header("[name]的其他目标有:")
			printobjectives(objectives)

		report += "[name]成功进行了<b>[sacrifices_made]</b>次对墓地的献祭. 因此，墓地产生了<b>[eggs_created]</b>枚灰烬行者蛋."

	else
		report += "<b>但没有蛋孵出来!</b>"

	return "<div class='panel redborder'>[report.Join("<br>")]</div>"
