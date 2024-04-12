/**
 * ## Abductees
 *
 * Abductees are created by being operated on by abductors. They get some instructions about not
 * remembering the abduction, plus some random weird objectives for them to act crazy with.
 */
/datum/antagonist/abductee
	name = "\improper 被劫持者"
	roundend_category = "被劫持者"
	antagpanel_category = ANTAG_GROUP_ABDUCTORS
	antag_hud_name = "abductee"

/datum/antagonist/abductee/on_gain()
	give_objective()
	. = ..()

/datum/antagonist/abductee/greet()
	to_chat(owner, span_warning("<b>你思维断弦了!</b>"))
	to_chat(owner, "<big>[span_warning("<b>你不记得你是怎么来到这的了...</b>")]</big>")
	owner.announce_objectives()

/datum/antagonist/abductee/proc/give_objective()
	var/objtype = (prob(75) ? /datum/objective/abductee/random : pick(subtypesof(/datum/objective/abductee/) - /datum/objective/abductee/random))
	var/datum/objective/abductee/objective = new objtype()
	objectives += objective
