/datum/round_event_control/radiation_storm
	name = "Radiation Storm-辐射风暴"
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 1
	category = EVENT_CATEGORY_SPACE
	description = "辐射风暴袭击整个空间站，所有船员需要躲进维护通道."
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 7

/datum/round_event/radiation_storm


/datum/round_event/radiation_storm/setup()
	start_when = 3
	end_when = start_when + 1
	announce_when = 1

/datum/round_event/radiation_storm/announce(fake)
	priority_announce("在站点附近探测到高强度辐射，请进入维护通道以避免暴露在辐射区.", "异常警报", ANNOUNCER_RADIATION)
	//sound not longer matches the text, but an audible warning is probably good

/datum/round_event/radiation_storm/start()
	SSweather.run_weather(/datum/weather/rad_storm)
