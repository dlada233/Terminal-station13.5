/datum/round_event_control/anomaly/anomaly_grav
	name = "Anomaly: Gravitational-重力"
	typepath = /datum/round_event/anomaly/anomaly_grav

	max_occurrences = 5
	weight = 25
	description = "该异常使周围物品乱飞."
	min_wizard_trigger_potency = 1
	max_wizard_trigger_potency = 3

/datum/round_event/anomaly/anomaly_grav
	start_when = ANOMALY_START_HARMFUL_TIME
	announce_when = ANOMALY_ANNOUNCE_HARMFUL_TIME
	anomaly_path = /obj/effect/anomaly/grav

/datum/round_event_control/anomaly/anomaly_grav/high
	name = "Anomaly: Gravitational (High Intensity)-重力场"
	typepath = /datum/round_event/anomaly/anomaly_grav/high
	weight = 15
	max_occurrences = 1
	earliest_start = 20 MINUTES
	description = "该异常产生重力场，可使重力发生器失效."

/datum/round_event/anomaly/anomaly_grav/high
	start_when = ANOMALY_START_HARMFUL_TIME
	announce_when = ANOMALY_ANNOUNCE_HARMFUL_TIME
	anomaly_path = /obj/effect/anomaly/grav/high

/datum/round_event/anomaly/anomaly_grav/announce(fake)
	if(isnull(impact_area))
		impact_area = placer.findValidArea()
	priority_announce("在[ANOMALY_ANNOUNCE_HARMFUL_TEXT] [impact_area.name]上检测到重力异常.", "异常警报" , ANNOUNCER_GRAVANOMALIES) //SKYRAT EDIT CHANGE - ORIGINAL: priority_announce("Gravitational anomaly detected on [ANOMALY_ANNOUNCE_HARMFUL_TEXT] [impact_area.name].", "Anomaly Alert" , ANNOUNCER_GRANOMALIES)
