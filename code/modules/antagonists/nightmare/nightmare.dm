/datum/antagonist/nightmare
	name = "\improper 夜魇"
	antagpanel_category = ANTAG_GROUP_ABOMINATIONS
	job_rank = ROLE_NIGHTMARE
	show_in_antagpanel = TURE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	ui_name = "AntagInfoNightmare"
	suicide_cry = "为了黑暗！！"
	preview_outfit = /datum/outfit/nightmare

/datum/antagonist/nightmare/greet()
	. = ..()
	owner.announce_objectives()

/datum/antagonist/nightmare/on_gain()
	forge_objectives()
	. = ..()

/datum/outfit/nightmare
	name = "夜魇（仅供预览）"

/datum/outfit/nightmare/post_equip(mob/living/carbon/human/human, visualsOnly)
	human.set_species(/datum/species/shadow/nightmare)

/datum/objective/nightmare_fluff

/datum/objective/nightmare_fluff/New()
	var/list/explanation_texts = list(
		"吞噬空间站最后的光芒.",
		"对日行者进行审判.",
		"熄灭这鬼地方的火焰.",
		"揭示阴影的真正本质.",
		"从阴影中，一切都将灭亡.",
		"用刀剑或火焰召唤夜幕.",
		"将黑暗带入光明."
	)
	explanation_text = pick(explanation_texts)
	..()

/datum/objective/nightmare_fluff/check_completion()
	return owner.current.stat != DEAD

/datum/antagonist/nightmare/forge_objectives()
	var/datum/objective/nightmare_fluff/objective = new
	objective.owner = owner
	objectives += objective
