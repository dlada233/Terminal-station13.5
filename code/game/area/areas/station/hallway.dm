/area/station/hallway
	icon_state = "hall"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/hallway/primary
	name = "\improper Hallway-主走廊"
	icon_state = "primaryhall"

/area/station/hallway/primary/aft
	name = "\improper Hallway-后主走廊"
	icon_state = "afthall"

/area/station/hallway/primary/fore
	name = "\improper Hallway-前主走廊"
	icon_state = "forehall"

/area/station/hallway/primary/starboard
	name = "\improper Hallway-右舷主走廊"
	icon_state = "starboardhall"

/area/station/hallway/primary/port
	name = "\improper Hallway-左舷主走廊"
	icon_state = "porthall"

/area/station/hallway/primary/central
	name = "\improper Hallway-中央主走廊"
	icon_state = "centralhall"

/area/station/hallway/primary/central/fore
	name = "\improper Hallway-前中央主走廊"
	icon_state = "hallCF"

/area/station/hallway/primary/central/aft
	name = "\improper Hallway-后中央主走廊"
	icon_state = "hallCA"

/area/station/hallway/primary/upper
	name = "\improper Upper Hallway-上层中央主走廊"
	icon_state = "centralhall"

/area/station/hallway/primary/tram
	name = "\improper Primary Tram-主电车"

/area/station/hallway/primary/tram/left
	name = "\improper Port Tram Dock-左舷电车站"
	icon_state = "halltramL"

/area/station/hallway/primary/tram/center
	name = "\improper Central Tram Dock-中央电车站"
	icon_state = "halltramM"

/area/station/hallway/primary/tram/right
	name = "\improper Starboard Tram Dock-右舷电车站"
	icon_state = "halltramR"

// This shouldn't be used, but it gives an icon for the enviornment tree in the map editor
/area/station/hallway/secondary
	icon_state = "secondaryhall"

/area/station/hallway/secondary/command
	name = "\improper Hallway-指挥部走廊"
	icon_state = "bridge_hallway"

/area/station/hallway/secondary/construction
	name = "\improper Construction Area-建筑区域"
	icon_state = "construction"

/area/station/hallway/secondary/construction/engineering
	name = "\improper Hallway-工程部走廊"

/area/station/hallway/secondary/exit
	name = "\improper Hallway-撤离飞船走廊"
	icon_state = "escape"

/area/station/hallway/secondary/exit/escape_pod
	name = "\improper Escape Pod Bay-逃生舱湾"
	icon_state = "escape_pods"

/area/station/hallway/secondary/exit/departure_lounge
	name = "\improper Departure Lounge-候机大厅"
	icon_state = "escape_lounge"

/area/station/hallway/secondary/entry
	name = "\improper Hallway-登站走廊"
	icon_state = "entry"
	area_flags = UNIQUE_AREA | EVENT_PROTECTED

/area/station/hallway/secondary/dock
	name = "\improper Hallway-次站码头走廊"
	icon_state = "hall"

/area/station/hallway/secondary/service
	name = "\improper Hallway-服务部走廊"
	icon_state = "hall_service"

/area/station/hallway/secondary/spacebridge
	name = "\improper Space Bridge-太空桥"
	icon_state = "hall"

/area/station/hallway/secondary/recreation
	name = "\improper Hallway-休闲区走廊"
	icon_state = "hall"

/*
* Station Specific Areas
* If another station gets added, and you make specific areas for it
* Please make its own section in this file
* The areas below belong to North Star's Hallways
*/

//1
/area/station/hallway/floor1
	name = "\improper Hallway-一楼走廊"

/area/station/hallway/floor1/aft
	name = "\improper Hallway-一楼后走廊"
	icon_state = "1_aft"

/area/station/hallway/floor1/fore
	name = "\improper Hallway-一楼前走廊"
	icon_state = "1_fore"
//2
/area/station/hallway/floor2
	name = "\improper Hallway-二楼走廊"

/area/station/hallway/floor2/aft
	name = "\improper Hallway-二楼后走廊"
	icon_state = "2_aft"

/area/station/hallway/floor2/fore
	name = "\improper Hallway-二楼前走廊"
	icon_state = "2_fore"
//3
/area/station/hallway/floor3
	name = "\improper Hallway-三楼走廊"

/area/station/hallway/floor3/aft
	name = "\improper Hallway-三路后走廊"
	icon_state = "3_aft"

/area/station/hallway/floor3/fore
	name = "\improper Hallway-三楼前走廊"
	icon_state = "3_fore"
//4
/area/station/hallway/floor4
	name = "\improper Hallway-四楼走廊"

/area/station/hallway/floor4/aft
	name = "\improper Hallway-四楼后走廊"
	icon_state = "4_aft"

/area/station/hallway/floor4/fore
	name = "\improper Hallway-四楼前走廊"
	icon_state = "4_fore"
