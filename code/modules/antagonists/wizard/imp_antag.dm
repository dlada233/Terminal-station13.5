/**
 * ## Imps
 *
 * Imps used to be summoned by a devil ascending to their final form, but now they're just
 * kinda sitting in limbo... Well, whatever! They're kinda cool anyways!
 */
/datum/antagonist/imp
	name = "\improper 小恶魔"
	show_in_antagpanel = FALSE
	show_in_roundend = FALSE
	ui_name = "AntagInfoDemon"
	antagpanel_category = ANTAG_GROUP_WIZARDS

/datum/antagonist/imp/on_gain()
	. = ..()
	give_objectives()

/datum/antagonist/imp/proc/give_objectives()
	var/datum/objective/newobjective = new
	newobjective.explanation_text = "尝试取得更高的魔鬼位阶."
	newobjective.owner = owner
	objectives += newobjective

/datum/antagonist/imp/ui_static_data(mob/user)
	var/list/data = list()
	data["fluff"] = "你是一只小恶魔，是由凝结的罪恶所召唤出的低等生物，用来服侍地狱的统治阶层."
	data["objectives"] = get_objectives()
	return data
