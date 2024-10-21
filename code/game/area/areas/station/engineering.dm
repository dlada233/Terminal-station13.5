/area/station/engineering
	icon_state = "engie"
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/engineering/engine_smes
	name = "\improper Engineering-工程储电"
	icon_state = "engine_smes"

/area/station/engineering/main
	name = "Engineering-工程部"
	icon_state = "engine"

/area/station/engineering/hallway
	name = "Engineering-工程走廊"
	icon_state = "engine_hallway"

/area/station/engineering/atmos
	name = "Atmospherics-工程大气"
	icon_state = "atmos"

/area/station/engineering/atmos/upper
	name = "Upper Atmospherics-上层工程大气"

/*outside atmos*/
/area/station/engineering/atmos/space_catwalk
	name = "\improper Atmospherics-大气太空脚手架"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

	sound_environment = SOUND_AREA_SPACE
	ambience_index = AMBIENCE_SPACE
	ambient_buzz = null //Space is deafeningly quiet
	min_ambience_cooldown = 195 SECONDS //length of ambispace.ogg
	max_ambience_cooldown = 200 SECONDS

/area/station/engineering/atmos/project
	name = "\improper Atmospherics-大气计划室"
	icon_state = "atmos_projectroom"

/area/station/engineering/atmos/pumproom
	name = "\improper Atmospherics-大气气泵房"
	icon_state = "atmos_pump_room"

/area/station/engineering/atmos/mix
	name = "\improper Atmospherics-大气混合室"
	icon_state = "atmos_mix"

/area/station/engineering/atmos/storage
	name = "\improper Atmospherics-大气储藏间"
	icon_state = "atmos_storage"

/area/station/engineering/atmos/storage/gas
	name = "\improper Atmospherics-气体储存间"
	icon_state = "atmos_storage_gas"

/area/station/engineering/atmos/office
	name = "\improper Atmospherics-大气办公室"
	icon_state = "atmos_office"

/area/station/engineering/atmos/hfr_room
	name = "\improper Atmospherics-HFR建造间"
	icon_state = "atmos_HFR"

/area/station/engineering/atmospherics_engine
	name = "\improper Atmospherics-大气引擎间"
	icon_state = "atmos_engine"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/area/station/engineering/lobby
	name = "\improper Engineering-工程部大厅"
	icon_state = "engi_lobby"

/area/station/engineering/supermatter
	name = "\improper Supermatter-超物质引擎"
	icon_state = "engine_sm"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/supermatter/waste
	name = "\improper Supermatter-超物质废气间"
	icon_state = "engine_sm_waste"

/area/station/engineering/supermatter/room
	name = "\improper Supermatter-超物质室"
	icon_state = "engine_sm_room"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/engineering/break_room
	name = "\improper Engineering-工程休息室"
	icon_state = "engine_break"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/gravity_generator
	name = "\improper Gravity Generator-重力发生器"
	icon_state = "grav_gen"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/storage
	name = "Engineering-工程仓库"
	icon_state = "engine_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/storage_shared
	name = "Shared Engineering-公共工程仓库"
	icon_state = "engine_storage_shared"

/area/station/engineering/transit_tube
	name = "\improper Transit Tube-运输管"
	icon_state = "transit_tube"

/area/station/engineering/storage/tech
	name = "Technical Storage-技术仓库"
	icon_state = "tech_storage"

/area/station/engineering/storage/tcomms
	name = "Telecomms Storage-电信仓库"
	icon_state = "tcom_storage"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/*
* Construction Areas
*/

/area/station/construction
	name = "\improper Construction Area-建造区域"
	icon_state = "construction"
	ambience_index = AMBIENCE_ENGI
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/construction/mining/aux_base
	name = "Auxiliary Base-辅助基地建造区"
	icon_state = "aux_base_construction"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/construction/storage_wing
	name = "\improper Storage Wing-储存侧室"
	icon_state = "storage_wing"
