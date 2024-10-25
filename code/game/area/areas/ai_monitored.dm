// Specific AI monitored areas

// Stub defined ai_monitored.dm
/area/station/ai_monitored

/area/station/ai_monitored/turret_protected

// AI
/area/station/ai_monitored
	icon_state = "ai"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/ai_monitored/aisat/exterior
	name = "\improper AI Satellite-AI卫星外部"
	icon_state = "ai"
	airlock_wires = /datum/wires/airlock/ai

/area/station/ai_monitored/command/storage/satellite
	name = "\improper AI Satellite-AI卫星维护"
	icon_state = "ai_storage"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/ai

// Turret protected
/area/station/ai_monitored/turret_protected
	ambientsounds = list('sound/ambience/ambitech.ogg', 'sound/ambience/ambitech2.ogg', 'sound/ambience/ambiatmos.ogg', 'sound/ambience/ambiatmos2.ogg')
	///Some sounds (like the space jam) are terrible when on loop. We use this variable to add it to other AI areas, but override it to keep it from the AI's core.
	var/ai_will_not_hear_this = list('sound/ambience/ambimalf.ogg')
	airlock_wires = /datum/wires/airlock/ai

/area/station/ai_monitored/turret_protected/Initialize(mapload)
	. = ..()
	if(ai_will_not_hear_this)
		ambientsounds += ai_will_not_hear_this

/area/station/ai_monitored/turret_protected/ai_upload
	name = "\improper AI Upload-AI上传室"
	icon_state = "ai_upload"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/ai_monitored/turret_protected/ai_upload_foyer
	name = "\improper AI Upload-AI上传门厅"
	icon_state = "ai_upload_foyer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/ai_monitored/turret_protected/ai
	name = "\improper AI Chamber-AI室"
	icon_state = "ai_chamber"
	ai_will_not_hear_this = null

/area/station/ai_monitored/turret_protected/aisat
	name = "\improper AI Satellite-AI卫星"
	icon_state = "ai"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/station/ai_monitored/turret_protected/aisat/atmos
	name = "\improper AI Satellite-AI卫星"
	icon_state = "ai"

/area/station/ai_monitored/turret_protected/aisat/foyer
	name = "\improper AI Satellite-AI卫星前厅"
	icon_state = "ai_foyer"

/area/station/ai_monitored/turret_protected/aisat/service
	name = "\improper AI Satellite-AI卫星服务部"
	icon_state = "ai"

/area/station/ai_monitored/turret_protected/aisat/hallway
	name = "\improper AI Satellite-AI卫星走廊"
	icon_state = "ai"

/area/station/ai_monitored/turret_protected/aisat/teleporter
	name ="\improper AI Satellite-AI卫星传送处"
	icon_state = "ai"

/area/station/ai_monitored/turret_protected/aisat/equipment
	name ="\improper AI Satellite-AI卫星装备处"
	icon_state = "ai"

/area/station/ai_monitored/turret_protected/aisat/maint
	name = "\improper AI Satellite-AI卫星维护通道"
	icon_state = "ai_maint"

/area/station/ai_monitored/turret_protected/aisat/uppernorth
	name = "\improper AI Satellite Upper-AI卫星上层前厅"
	icon_state = "ai"

/area/station/ai_monitored/turret_protected/aisat/uppersouth
	name = "\improper AI Satellite Upper-AI卫星尾部上层"
	icon_state = "ai"

/area/station/ai_monitored/turret_protected/aisat_interior
	name = "\improper AI Satellite-AI卫星接待室"
	icon_state = "ai_interior"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/ai_monitored/turret_protected/ai_sat_ext_as
	name = "\improper AI Sat Ext-AI卫星东部"
	icon_state = "ai_sat_east"

/area/station/ai_monitored/turret_protected/ai_sat_ext_ap
	name = "\improper AI Sat Ext-AI卫星西部"
	icon_state = "ai_sat_west"

// Station specific ai monitored rooms, move here for consistency

//Command - AI Monitored
/area/station/ai_monitored/command/storage/eva
	name = "EVA Storage-EVA仓库"
	icon_state = "eva"
	ambience_index = AMBIENCE_DANGER

/area/station/ai_monitored/command/storage/eva/upper
	name = "Upper EVA Storage-上层EVA仓库"

/area/station/ai_monitored/command/nuke_storage
	name = "\improper Vault-金库"
	icon_state = "nuke_storage"
	airlock_wires = /datum/wires/airlock/command

//Security - AI Monitored
/area/station/ai_monitored/security/armory
	name = "\improper Armory-军械库"
	icon_state = "armory"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/security

/area/station/ai_monitored/security/armory/upper
	name = "Upper Armory-上层军械库"
