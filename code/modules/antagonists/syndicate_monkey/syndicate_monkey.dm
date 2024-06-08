/datum/antagonist/syndicate_monkey
	name = "\improper 辛迪加猴子"
	antagpanel_category = ANTAG_GROUP_SYNDICATE
	show_in_roundend = TRUE
	show_in_antagpanel = TRUE
	show_name_in_check_antagonists = TRUE
	count_against_dynamic_roll_chance = FALSE
	show_to_ghosts = TRUE
	/// The antagonist's master, used for objective
	var/mob/living/monky_master

/datum/antagonist/syndicate_monkey/on_gain()
	monky_master = owner.enslaved_to?.resolve()
	if(monky_master)
		forge_objectives(monky_master)
	return ..()

/datum/antagonist/syndicate_monkey/Destroy()
	monky_master = null
	return ..()

/datum/antagonist/syndicate_monkey/greet()
	. = ..()
	owner.announce_objectives()

/datum/objective/syndicate_monkey
	var/mob/living/monky_master

/datum/objective/syndicate_monkey/check_completion()
	return monky_master.stat != DEAD

/datum/antagonist/syndicate_monkey/forge_objectives(mob/monky_master)
	var/datum/objective/syndicate_monkey/objective = new
	objective.monky_master = monky_master
	objective.explanation_text = "你是牛逼的辛迪加候特工，保护并服从你主人[monky_master]的命令!"
	objective.owner = owner
	objectives += objective
