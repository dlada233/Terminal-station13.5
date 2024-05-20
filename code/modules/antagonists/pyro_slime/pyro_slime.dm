/datum/antagonist/pyro_slime
	name = "\improper 火山灰异常"
	antagpanel_category = ANTAG_GROUP_ABOMINATIONS
	show_in_roundend = FALSE
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE

/datum/antagonist/pyro_slime/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/pyro_slime/greet()
	. = ..()
	owner.announce_objectives()

/datum/objective/pyro_slime
	explanation_text = "火，只有火，我用火做的舌头说话...为什么大家都这样“冷漠”?"

/datum/objective/pyro_slime/check_completion()
	return owner.current.stat != DEAD

/datum/antagonist/pyro_slime/forge_objectives()
	var/datum/objective/pyro_slime/objective = new
	objective.owner = owner
	objectives += objective
