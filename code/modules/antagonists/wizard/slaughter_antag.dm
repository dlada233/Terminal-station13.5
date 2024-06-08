/datum/antagonist/slaughter
	name = "\improper 杀戮恶魔"
	show_name_in_check_antagonists = TRUE
	ui_name = "AntagInfoDemon"
	job_rank = ROLE_ALIEN
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	antagpanel_category = ANTAG_GROUP_WIZARDS
	var/fluff = "你是暴怒的恶魔，常被巫师召唤到现实中去威吓敌人."
	var/objective_verb = "杀了"
	var/datum/mind/summoner

/datum/antagonist/slaughter/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/slaughter/greet()
	. = ..()
	owner.announce_objectives()
	to_chat(owner, span_warning("你拥有猛击敌人的能力，通过右键敌人来发动!"))

/datum/antagonist/slaughter/forge_objectives()
	if(summoner)
		var/datum/objective/assassinate/new_objective = new /datum/objective/assassinate
		new_objective.owner = owner
		new_objective.target = summoner
		new_objective.explanation_text = "[objective_verb] [summoner.name], 这家伙召唤了你."
		objectives += new_objective
	var/datum/objective/new_objective2 = new /datum/objective
	new_objective2.owner = owner
	new_objective2.explanation_text = "[objective_verb] 所有人[summoner ? " else while you're at it":""]."
	objectives += new_objective2

/datum/antagonist/slaughter/ui_static_data(mob/user)
	var/list/data = list()
	data["fluff"] = fluff
	data["objectives"] = get_objectives()
	data["explain_attack"] = TRUE
	return data

/datum/antagonist/slaughter/laughter
	name = "奸笑恶魔"
	objective_verb = "拥抱与挠痒"
	fluff = "你是嫉妒恶魔，被巫师拖进现实宇宙制造混乱."
