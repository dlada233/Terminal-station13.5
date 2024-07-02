/datum/round_event_control/grid_check
	name = "Grid Check-断电检查"
	typepath = /datum/round_event/grid_check
	weight = 10
	max_occurrences = 3
	category = EVENT_CATEGORY_ENGINEERING
	description = "关掉所有APC一段时间，期间可以手动重启."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 4
	/// Cooldown for the announement associated with this event.
	/// Necessary due to the fact that this event is player triggerable.
	COOLDOWN_DECLARE(announcement_spam_protection)

/datum/round_event/grid_check
	announce_when = 1
	start_when = 1

/datum/round_event/grid_check/announce(fake)
	var/datum/round_event_control/grid_check/controller = control
	if(!fake)
		if(!controller)
			CRASH("event started without controller!")
		if(!COOLDOWN_FINISHED(controller, announcement_spam_protection))
			return
	priority_announce("在 [station_name()] 的电网中检测到异常活动，出于预防目的，站点电力将被关闭一段不确定的时间.", "紧急断电", ANNOUNCER_POWEROFF)
	if(!fake) // Only start the CD if we're real
		COOLDOWN_START(controller, announcement_spam_protection, 30 SECONDS)

/datum/round_event/grid_check/start()
	power_fail(30, 120)
