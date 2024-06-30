/datum/round_event_control/anomaly/anomaly_bluespace
	name = "Anomaly: Bluespace-蓝空"
	typepath = /datum/round_event/anomaly/anomaly_bluespace

	max_occurrences = 1
	weight = 15
	description = "该异常在大范围内随机传送所有物品和mob."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 2

/datum/round_event/anomaly/anomaly_bluespace
	start_when = ANOMALY_START_MEDIUM_TIME
	announce_when = ANOMALY_ANNOUNCE_MEDIUM_TIME
	anomaly_path = /obj/effect/anomaly/bluespace

/datum/round_event/anomaly/anomaly_bluespace/announce(fake)
	if(isnull(impact_area))
		impact_area = placer.findValidArea()
	priority_announce("在 [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name] 上检测到蓝空异常.", "异常警报", ANNOUNCER_MASSIVEBSPACEANOMALIES) //SKYRAT EDIT CHANGE - ORIGINAL: 	priority_announce("Bluespace instability detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Anomaly Alert")
