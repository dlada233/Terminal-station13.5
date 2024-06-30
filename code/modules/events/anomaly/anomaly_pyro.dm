/datum/round_event_control/anomaly/anomaly_pyro
	name = "Anomaly: Pyroclastic-火焰"
	typepath = /datum/round_event/anomaly/anomaly_pyro

	max_occurrences = 5
	weight = 20
	description = "该异常在周围产生火，并生成火史莱姆"
	min_wizard_trigger_potency = 1
	max_wizard_trigger_potency = 4

/datum/round_event/anomaly/anomaly_pyro
	start_when = ANOMALY_START_HARMFUL_TIME
	announce_when = ANOMALY_ANNOUNCE_HARMFUL_TIME
	anomaly_path = /obj/effect/anomaly/pyro

/datum/round_event/anomaly/anomaly_pyro/announce(fake)
	if(isnull(impact_area))
		impact_area = placer.findValidArea()
	priority_announce("在 [ANOMALY_ANNOUNCE_HARMFUL_TEXT] [impact_area.name] 上检测到火焰异常.", "异常警报", ANNOUNCER_PYROANOMALIES) //SKYRAT EDIT CHANGE - ORIGINAL: priority_announce("Pyroclastic anomaly detected on [ANOMALY_ANNOUNCE_HARMFUL_TEXT] [impact_area.name].", "Anomaly Alert")
