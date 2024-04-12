// Action for Raw Prophets that boosts up or shrinks down their sight range.
/datum/action/innate/expand_sight
	name = "视野扩大"
	desc = "大大提高你的视野范围，可以观察到更远方的情况."
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "eye"
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	/// How far we expand the range to.
	var/boost_to = 5
	/// A cooldown for the last time we toggled it, to prevent spam.
	COOLDOWN_DECLARE(last_toggle)

/datum/action/innate/expand_sight/IsAvailable(feedback = FALSE)
	return ..() && COOLDOWN_FINISHED(src, last_toggle)

/datum/action/innate/expand_sight/Activate()
	active = TRUE
	owner.client?.view_size.setTo(boost_to)
	playsound(owner, pick('sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg'), 50, TRUE, ignore_walls = FALSE)
	COOLDOWN_START(src, last_toggle, 8 SECONDS)

/datum/action/innate/expand_sight/Deactivate()
	active = FALSE
	owner.client?.view_size.resetToDefault()
	COOLDOWN_START(src, last_toggle, 4 SECONDS)
