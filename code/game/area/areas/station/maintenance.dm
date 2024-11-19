/area/station/maintenance
	name = "Maintenance-维护通道"
	ambience_index = AMBIENCE_MAINT
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED | PERSISTENT_ENGRAVINGS
	airlock_wires = /datum/wires/airlock/maint
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	forced_ambience = TRUE
	ambient_buzz = 'sound/ambience/source_corridor2.ogg'
	ambient_buzz_vol = 20

/*
* Departmental Maintenance
*/

/area/station/maintenance/department/chapel
	name = "Maintenance-教堂维护通道"
	icon_state = "maint_chapel"

/area/station/maintenance/department/chapel/monastery
	name = "Maintenance-寺庙维护通道"
	icon_state = "maint_monastery"

/area/station/maintenance/department/crew_quarters/bar
	name = "Maintenance-酒吧维护通道"
	icon_state = "maint_bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/maintenance/department/crew_quarters/dorms
	name = "Maintenance-宿舍维护通道"
	icon_state = "maint_dorms"

/area/station/maintenance/department/eva
	name = "Maintenance-EVA维护通道"
	icon_state = "maint_eva"

/area/station/maintenance/department/eva/abandoned
	name = "Abandoned EVA Storage-废弃EVA仓库"

/area/station/maintenance/department/electrical
	name = "Maintenance-供电维护通道"
	icon_state = "maint_electrical"

/area/station/maintenance/department/engine/atmos
	name = "Maintenance-大气维护通道"
	icon_state = "maint_atmos"

/area/station/maintenance/department/security
	name = "Maintenance-安保维护通道"
	icon_state = "maint_sec"

/area/station/maintenance/department/security/upper
	name = "Upper Maintenance-上层安保维护通道"

/area/station/maintenance/department/security/brig
	name = "Maintenance-安保门禁维护通道"
	icon_state = "maint_brig"

/area/station/maintenance/department/medical
	name = "Maintenance-医疗部维护通道"
	icon_state = "medbay_维修通道"

/area/station/maintenance/department/medical/central
	name = "Maintenance-医疗部中央维护通道"
	icon_state = "medbay_maint_central"

/area/station/maintenance/department/medical/morgue
	name = "Maintenance-停尸房维护通道"
	icon_state = "morgue_维修通道"

/area/station/maintenance/department/science
	name = "Maintenance-科研部维护通道"
	icon_state = "maint_sci"

/area/station/maintenance/department/science/central
	name = "Maintenance-科研部中央维护通道"
	icon_state = "maint_sci_central"

/area/station/maintenance/department/cargo
	name = "Maintenance-货仓维护通道"
	icon_state = "maint_cargo"

/area/station/maintenance/department/bridge
	name = "Maintenance-舰桥维护通道"
	icon_state = "maint_bridge"

/area/station/maintenance/department/engine
	name = "Maintenance-工程部维护通道"
	icon_state = "maint_engi"

/area/station/maintenance/department/prison
	name = "Maintenance-监狱维护通道"
	icon_state = "sec_prison"

/area/station/maintenance/department/science/xenobiology
	name = "Maintenance-异种学维护通道"
	icon_state = "xeno维修通道"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA | XENOBIOLOGY_COMPATIBLE | CULT_PERMITTED

/*
* Generic Maintenance Tunnels
*/

/area/station/maintenance/aft
	name = "Maintenance-站尾维护通道"
	icon_state = "aft维修通道"

/area/station/maintenance/aft/upper
	name = "Upper Maintenance-上层站尾维护通道"
	icon_state = "upperaft维修通道"

/* Use 远variants of area definitions for when the station has two different sections of maintenance on the same z-level.
* Can stand alone without "lesser".
* This one means that this goes more fore/north than the "lesser" maintenance area.
*/
/area/station/maintenance/aft/greater
	name = "Maintenance-远站尾维护通道"
	icon_state = "greateraft维修通道"

/* Use 近variants of area definitions for when the station has two different sections of maintenance on the same z-level in conjunction with "greater".
* (just because it follows better).
* This one means that this goes more aft/south than the "greater" maintenance area.
*/

/area/station/maintenance/aft/lesser
	name = "Maintenance-近站尾维护通道"
	icon_state = "lesseraft维修通道"

/area/station/maintenance/central
	name = "Maintenance-中央维护通道"
	icon_state = "central维修通道"

/area/station/maintenance/central/greater
	name = "Maintenance-远中央维护通道"
	icon_state = "greatercentral维修通道"

/area/station/maintenance/central/lesser
	name = "Maintenance-近中央维护通道"
	icon_state = "lessercentral维修通道"

/area/station/maintenance/fore
	name = "Maintenance-站首维护通道"
	icon_state = "fore维修通道"

/area/station/maintenance/fore/upper
	name = "Upper Maintenance-上层站首维护通道"
	icon_state = "upperfore维修通道"

/area/station/maintenance/fore/greater
	name = "Maintenance-远站首维护通道"
	icon_state = "greaterfore维修通道"

/area/station/maintenance/fore/lesser
	name = "Maintenance-近站首维护通道"
	icon_state = "lesserfore维修通道"

/area/station/maintenance/starboard
	name = "Maintenance-右舷维护通道"
	icon_state = "starboard维修通道"

/area/station/maintenance/starboard/upper
	name = "Upper Maintenance-右舷维护通道"
	icon_state = "upperstarboard维修通道"

/area/station/maintenance/starboard/central
	name = "Maintenance-中央右舷维护通道"
	icon_state = "centralstarboard维修通道"

/area/station/maintenance/starboard/greater
	name = "Maintenance-远右舷维护通道"
	icon_state = "greaterstarboard维修通道"

/area/station/maintenance/starboard/lesser
	name = "Maintenance-近右舷维护通道"
	icon_state = "lesserstarboard维修通道"

/area/station/maintenance/starboard/aft
	name = "Maintenance-站尾右舷维护通道"
	icon_state = "as维修通道"

/area/station/maintenance/starboard/fore
	name = "Maintenance-站首右舷维护通道"
	icon_state = "fs维修通道"

/area/station/maintenance/port
	name = "Maintenance-左舷维护通道"
	icon_state = "port维修通道"

/area/station/maintenance/port/central
	name = "Maintenance-中央左舷维护通道"
	icon_state = "centralport维修通道"

/area/station/maintenance/port/greater
	name = "Maintenance-远左舷维护通道"
	icon_state = "greaterport维修通道"

/area/station/maintenance/port/lesser
	name = "Maintenance-近左舷维护通道"
	icon_state = "lesserport维修通道"

/area/station/maintenance/port/aft
	name = "Maintenance-站尾左舷维护通道"
	icon_state = "ap维修通道"

/area/station/maintenance/port/fore
	name = "Maintenance-站首左舷维护通道"
	icon_state = "fp维修通道"

/area/station/maintenance/tram
	name = "Maintenance-主电车维护通道"

/area/station/maintenance/tram/left
	name = "\improper Maintenance-左舷电车地下通道"
	icon_state = "mainttramL"

/area/station/maintenance/tram/mid
	name = "\improper Maintenance-中央电车地下通道"
	icon_state = "mainttramM"

/area/station/maintenance/tram/right
	name = "\improper Maintenance-右舷电车地下通道"
	icon_state = "mainttramR"

/*
* Discrete Maintenance Areas
*/

/area/station/maintenance/disposal
	name = "Waste Disposal-废气处理"
	icon_state = "disposal"

/area/station/maintenance/hallway/abandoned_command
	name = "\improper Maintenance-废弃指挥部走廊"
	icon_state = "maint_bridge"

/area/station/maintenance/hallway/abandoned_recreation
	name = "\improper Maintenance-废弃休闲走廊"
	icon_state = "maint_dorms"

/area/station/maintenance/disposal/incinerator
	name = "\improper Incinerator-焚化炉"
	icon_state = "incinerator"

/area/station/maintenance/space_hut
	name = "\improper Space Hut-太空小屋"
	icon_state = "spacehut"

/area/station/maintenance/space_hut/cabin
	name = "Abandoned Cabin-废弃小屋"

/area/station/maintenance/space_hut/plasmaman
	name = "\improper Abandoned Plasmaman Friendly Startup"

/area/station/maintenance/space_hut/observatory
	name = "\improper Space Observatory-太空天文台"

/*
* Radation Storm Shelters
*/

/area/station/maintenance/radshelter
	name = "\improper Shelter-放射性风暴避难所"
	icon_state = "radstorm_shelter"

/area/station/maintenance/radshelter/medical
	name = "\improper Shelter-医疗部放射性风暴避难所"

/area/station/maintenance/radshelter/sec
	name = "\improper Shelter-安保部放射性风暴避难所"

/area/station/maintenance/radshelter/service
	name = "\improper Shelter-服务部放射性风暴避难所"

/area/station/maintenance/radshelter/civil
	name = "\improper Shelter-民用放射性风暴避难所"

/area/station/maintenance/radshelter/sci
	name = "\improper Shelter-科研部放射性风暴避难所"

/area/station/maintenance/radshelter/cargo
	name = "\improper Shelter-货仓放射性风暴避难所"

/*
* External Hull Access Areas
*/

/area/station/maintenance/external
	name = "\improper External Hull Access-外部船体通道"
	icon_state = "a维修通道"

/area/station/maintenance/external/aft
	name = "\improper External Hull Access-站尾外部船体通道"

/area/station/maintenance/external/port
	name = "\improper External Hull Access-左舷外部船体通道"

/area/station/maintenance/external/port/bow
	name = "\improper Bow External Hull Access-站头两侧外部船体通道"

/*
* Station Specific Areas
* If another station gets added, and you make specific areas for it
* Please make its own section in this file
* The areas below belong to North Star's Maintenance
*/

//1
/area/station/maintenance/floor1
	name = "\improper Maint-一楼维修通道"

/area/station/maintenance/floor1/port
	name = "\improper Maint-一楼中央左舷维修通道"
	icon_state = "maintcentral"

/area/station/maintenance/floor1/port/fore
	name = "\improper Maint-一楼站首左舷维修通道"
	icon_state = "maintfore"
/area/station/maintenance/floor1/port/aft
	name = "\improper Maint-一楼站尾左舷维修通道"
	icon_state = "maintaft"

/area/station/maintenance/floor1/starboard
	name = "\improper Maint-一楼中央右舷维修通道"
	icon_state = "maintcentral"

/area/station/maintenance/floor1/starboard/fore
	name = "\improper Maint-一楼站首右舷维修通道"
	icon_state = "maintfore"

/area/station/maintenance/floor1/starboard/aft
	name = "\improper Maint-一楼站尾右舷维修通道"
	icon_state = "maintaft"
//2
/area/station/maintenance/floor2
	name = "\improper Maint-二楼维修通道"
/area/station/maintenance/floor2/port
	name = "\improper Maint-二楼中央左舷维修通道"
	icon_state = "maintcentral"

/area/station/maintenance/floor2/port/fore
	name = "\improper Maint-二楼站首左舷维修通道"
	icon_state = "maintfore"

/area/station/maintenance/floor2/port/aft
	name = "\improper Maint-二楼站尾左舷维修通道"
	icon_state = "maintaft"

/area/station/maintenance/floor2/starboard
	name = "\improper Maint-二楼中央右舷维修通道"
	icon_state = "maintcentral"

/area/station/maintenance/floor2/starboard/fore
	name = "\improper Maint-二楼站首右舷维修通道"
	icon_state = "maintfore"

/area/station/maintenance/floor2/starboard/aft
	name = "\improper Maint-二楼站尾右舷维修通道"
	icon_state = "maintaft"
//3
/area/station/maintenance/floor3
	name = "\improper Maint-三楼维修通道"

/area/station/maintenance/floor3/port
	name = "\improper Maint-三楼中央左舷维修通道"
	icon_state = "maintcentral"

/area/station/maintenance/floor3/port/fore
	name = "\improper Maint-三楼站首左舷维修通道"
	icon_state = "maintfore"

/area/station/maintenance/floor3/port/aft
	name = "\improper Maint-三楼站尾左舷维修通道"
	icon_state = "maintaft"

/area/station/maintenance/floor3/starboard
	name = "\improper Maint-三楼中央右舷维修通道"
	icon_state = "maintcentral"

/area/station/maintenance/floor3/starboard/fore
	name = "\improper Maint-三楼站首右舷维修通道"
	icon_state = "maintfore"

/area/station/maintenance/floor3/starboard/aft
	name = "\improper Maint-三楼站尾右舷维修通道"
	icon_state = "maintaft"
//4
/area/station/maintenance/floor4
	name = "\improper Maint-四楼维修通道"

/area/station/maintenance/floor4/port
	name = "\improper Maint-四楼中央左舷维修通道"
	icon_state = "maintcentral"

/area/station/maintenance/floor4/port/fore
	name = "\improper Maint-四楼站首左舷维修通道"
	icon_state = "maintfore"

/area/station/maintenance/floor4/port/aft
	name = "\improper Maint-四楼站尾左舷维修通道"
	icon_state = "maintaft"

/area/station/maintenance/floor4/starboard
	name = "\improper Maint-四楼中央右舷维修通道"
	icon_state = "maintcentral"

/area/station/maintenance/floor4/starboard/fore
	name = "\improper Maint-四楼站首右舷维修通道"
	icon_state = "maintfore"

/area/station/maintenance/floor4/starboard/aft
	name = "\improper Maint-四楼站尾右舷维修通道"
	icon_state = "maintaft"
