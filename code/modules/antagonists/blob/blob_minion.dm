/datum/antagonist/blob_minion
	name = "\improper 真菌侍从"
	antagpanel_category = ANTAG_GROUP_BIOHAZARDS
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	show_in_antagpanel = FALSE
	/// The blob core that this minion is attached to
	var/datum/weakref/overmind

/datum/antagonist/blob_minion/New(mob/camera/blob/overmind)
	. = ..()
	src.overmind = WEAKREF(overmind)

/datum/antagonist/blob_minion/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/blob_minion/greet()
	. = ..()
	owner.announce_objectives()
/datum/objective/blob_minion
	name = "保护真菌体核心"
	explanation_text = "不惜一切代价保护真菌体核心."
	var/datum/weakref/overmind

/datum/objective/blob_minion/check_completion()
	var/mob/camera/blob/resolved_overmind = overmind.resolve()
	if(!resolved_overmind)
		return FALSE
	return resolved_overmind.stat != DEAD

/datum/antagonist/blob_minion/forge_objectives()
	var/datum/objective/blob_minion/objective = new
	objective.owner = owner
	objective.overmind = overmind
	objectives += objective
