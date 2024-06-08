/datum/antagonist/disease
	name = "感知瘟疫"
	roundend_category = "瘟疫"
	antagpanel_category = ANTAG_GROUP_BIOHAZARDS
	show_to_ghosts = TRUE
	var/disease_name = ""

/datum/antagonist/disease/on_gain()
	owner.set_assigned_role(SSjob.GetJobType(/datum/job/sentient_disease))
	owner.special_role = ROLE_SENTIENT_DISEASE
	var/datum/objective/O = new /datum/objective/disease_infect()
	O.owner = owner
	objectives += O

	O = new /datum/objective/disease_infect_centcom()
	O.owner = owner
	objectives += O

	. = ..()

/datum/antagonist/disease/greet()
	. = ..()
	to_chat(owner.current, span_notice("感染船员以获得进化点，并进一步传播感染."))
	owner.announce_objectives()

/datum/antagonist/disease/apply_innate_effects(mob/living/mob_override)
	if(!istype(owner.current, /mob/camera/disease))
		var/turf/T = get_turf(owner.current)
		T = T ? T : SSmapping.get_station_center()
		var/mob/camera/disease/D = new /mob/camera/disease(T)
		owner.transfer_to(D)

/datum/antagonist/disease/admin_add(datum/mind/new_owner,mob/admin)
	..()
	var/mob/camera/disease/D = new_owner.current
	D.pick_name()

/datum/antagonist/disease/roundend_report()
	var/list/result = list()

	result += "<b>瘟疫名称:</b> [disease_name]"
	result += printplayer(owner)

	var/win = TRUE
	var/objectives_text = ""
	var/count = 1
	for(var/datum/objective/objective in objectives)
		if(objective.check_completion())
			objectives_text += "<br><B>目标 #[count]</B>: [objective.explanation_text] [span_greentext("成功!")]"
		else
			objectives_text += "<br><B>目标 #[count]</B>: [objective.explanation_text] [span_redtext("失败.")]"
			win = FALSE
		count++

	result += objectives_text

	var/special_role_text = lowertext(name)

	if(win)
		result += span_greentext("[special_role_text]成功了!")
	else
		result += span_redtext("[special_role_text]失败了!")

	if(istype(owner.current, /mob/camera/disease))
		var/mob/camera/disease/D = owner.current
		result += "<B>[disease_name]以[D.hosts.len]名感染宿主完成本局，最多时有[D.total_points]人同时感染.</B>"
		result += "<B>[disease_name]在本局中完成了以下进化:</B>"
		var/list/adaptations = list()
		for(var/V in D.purchased_abilities)
			var/datum/disease_ability/A = V
			adaptations += A.name
		result += adaptations.Join(", ")

	return result.Join("<br>")

/datum/antagonist/disease/get_preview_icon()
	var/icon/icon = icon('icons/mob/huds/antag_hud.dmi', "virus_infected")
	icon.Blend(COLOR_GREEN_GRAY, ICON_MULTIPLY)
	icon.Scale(ANTAGONIST_PREVIEW_ICON_SIZE, ANTAGONIST_PREVIEW_ICON_SIZE)
	return icon

/datum/objective/disease_infect
	explanation_text = "存活下去并感染尽可能多的人."

/datum/objective/disease_infect/check_completion()
	var/mob/camera/disease/D = owner.current
	if(istype(D) && D.hosts.len) //theoretically it should not exist if it has no hosts, but better safe than sorry.
		return TRUE
	return FALSE


/datum/objective/disease_infect_centcom
	explanation_text = "确保至少有一名感染宿主乘坐穿梭机或逃生舱成功逃生."

/datum/objective/disease_infect_centcom/check_completion()
	var/mob/camera/disease/D = owner.current
	if(!istype(D))
		return FALSE
	for(var/V in D.hosts)
		var/mob/living/L = V
		if(L.onCentCom() || L.onSyndieBase())
			return TRUE
	return FALSE
