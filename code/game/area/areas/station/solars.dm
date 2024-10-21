/*
* External Solar Areas
*/

/area/station/solars
	icon_state = "panels"
	requires_power = FALSE
	area_flags = UNIQUE_AREA
	flags_1 = NONE
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_SPACE

/area/station/solars/fore
	name = "\improper Solar Array-站首太阳能阵列"
	icon_state = "panelsF"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/solars/aft
	name = "\improper Solar Array-站尾太阳能阵列"
	icon_state = "panelsAF"

/area/station/solars/aux/port
	name = "\improper Solar Array-站首左舷辅助太阳能阵列"
	icon_state = "panelsA"

/area/station/solars/aux/starboard
	name = "\improper Solar Array-站首右舷辅助太阳能阵列"
	icon_state = "panelsA"

/area/station/solars/starboard
	name = "\improper Solar Array-右舷太阳能阵列"
	icon_state = "panelsS"

/area/station/solars/starboard/aft
	name = "\improper Solar Array-站尾右舷太阳能阵列"
	icon_state = "panelsAS"

/area/station/solars/starboard/fore
	name = "\improper Solar Array-站首右舷太阳能阵列"
	icon_state = "panelsFS"

/area/station/solars/port
	name = "\improper Port Solar Array-左舷太阳能阵列"
	icon_state = "panelsP"

/area/station/solars/port/aft
	name = "\improper Port Quarter Solar Array-左舷站尾两侧太阳能阵列"
	icon_state = "panelsAP"

/area/station/solars/port/fore
	name = "\improper Port Bow Solar Array-左舷站首两侧太阳能阵列"
	icon_state = "panelsFP"

/area/station/solars/aisat
	name = "\improper AI Satellite Solars-AI卫星太阳能阵列"
	icon_state = "panelsAI"


/*
* Internal Solar Areas
* The rooms where the SMES and computer are
* Not in the maintenance file just so we can keep these organized with other the external solar areas
*/

/area/station/maintenance/solars
	name = "Solar Maintenance-太阳能维护管道"
	icon_state = "yellow"

/area/station/maintenance/solars/port
	name = "Port Solar Maintenance-左舷太阳能维护管道"
	icon_state = "SolarcontrolP"

/area/station/maintenance/solars/port/aft
	name = "Port Quarter Solar Maintenance-左舷站尾两侧太阳能维护管道"
	icon_state = "SolarcontrolAP"

/area/station/maintenance/solars/port/fore
	name = "Port Bow Solar Maintenance-左舷站首两侧太阳能维护管道"
	icon_state = "SolarcontrolFP"

/area/station/maintenance/solars/starboard
	name = "Starboard Solar Maintenance-右舷太阳能维护管道"
	icon_state = "SolarcontrolS"

/area/station/maintenance/solars/starboard/aft
	name = "Starboard Quarter Solar Maintenance-右舷站尾两侧太阳能维护管道"
	icon_state = "SolarcontrolAS"

/area/station/maintenance/solars/starboard/fore
	name = "Starboard Bow Solar Maintenance-右舷站首两侧太阳能维护管道"
	icon_state = "SolarcontrolFS"
