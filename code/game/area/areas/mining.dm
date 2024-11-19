/**********************Mine areas**************************/
/area/mine
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED | CULT_PERMITTED
	ambient_buzz = 'sound/ambience/magma.ogg'

/area/mine/lobby
	name = "Mining-采矿基地"
	icon_state = "mining_lobby"

/area/mine/storage
	name = "Mining-采矿基地生产仓库"
	icon_state = "mining_storage"

/area/mine/storage/public
	name = "Mining-采矿基地公共仓库"
	icon_state = "mining_storage"

/area/mine/production
	name = "Mining-采矿基地生产区"
	icon_state = "mining_production"

/area/mine/abandoned
	name = "Abandoned Mining Station-废弃的采矿基地"

/area/mine/living_quarters
	name = "Mining-采矿基地生活区"
	icon_state = "mining_living"

/area/mine/eva
	name = "Mining-采矿基地EVA存放处"
	icon_state = "mining_eva"

/area/mine/eva/lower
	name = "Mining-采矿基地低层EVA存放处"
	icon_state = "mining_eva"

/area/mine/maintenance
	name = "Mining-采矿基地维护通道"

/area/mine/maintenance/production
	name = "Mining-采矿基地生产区维护通道"

/area/mine/maintenance/living
	name = "Mining-采矿基地生活区维护通道"

/area/mine/maintenance/living/north
	name = "Mining-采矿基地生活区北维护通道"

/area/mine/maintenance/living/south
	name = "Mining-采矿基地生活区南维护通道"

/area/mine/maintenance/public
	name = "Mining-采矿基地公共区维护通道"

/area/mine/maintenance/public/north
	name = "Mining-采矿基地公共区北维护通道"

/area/mine/maintenance/public/south
	name = "Mining-采矿基地公共区南维护通道"

/area/mine/maintenance/service
	name = "Mining-采矿基地服务区维护通道"

/area/mine/maintenance/service/disposals
	name = "Mining-采矿基地垃圾处理区"

/area/mine/maintenance/service/comms
	name = "Mining-采矿基地通讯机房"

/area/mine/maintenance/labor
	name = "Labor-劳改营维护通道"

/area/mine/cafeteria
	name = "Mining-采矿基地食堂"
	icon_state = "mining_cafe"

/area/mine/cafeteria/labor
	name = "Labor-劳改营食堂"
	icon_state = "mining_labor_cafe"

/area/mine/hydroponics
	name = "Mining-采矿基地水培室"
	icon_state = "mining_hydro"

/area/mine/medical
	name = "Mining-采矿基地应急医疗处"

/area/mine/mechbay
	name = "Mining-采矿基地机甲停放处"
	icon_state = "mechbay"

/area/mine/lounge
	name = "Mining-采矿基地公共休息室"
	icon_state = "mining_lounge"

/area/mine/laborcamp
	name = "Labor-劳改营"
	icon_state = "mining_labor"

/area/mine/laborcamp/quarters
	name = "Labor-劳改营营房"
	icon_state = "mining_labor_quarters"

/area/mine/laborcamp/production
	name = "Labor-劳改营生产区"
	icon_state = "mining_labor_production"

/area/mine/laborcamp/security
	name = "Labor-劳改营安保区"
	icon_state = "labor_camp_security"
	ambience_index = AMBIENCE_DANGER

/area/mine/laborcamp/security/maintenance
	name = "Labor-劳改营安保区维护通道"
	icon_state = "labor_camp_security"
	ambience_index = AMBIENCE_DANGER




/**********************Lavaland Areas**************************/

/area/lavaland
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED
	sound_environment = SOUND_AREA_LAVALAND
	ambient_buzz = 'sound/ambience/magma.ogg'

/area/lavaland/surface
	name = "Lavaland-拉瓦兰"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambience_index = AMBIENCE_MINING
	area_flags = VALID_TERRITORY | UNIQUE_AREA
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/lavaland/underground
	name = "Lavaland-拉瓦兰地下洞穴"
	icon_state = "unexplored"
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambience_index = AMBIENCE_MINING
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/lavaland/surface/outdoors
	name = "Lavaland-拉瓦兰废土"
	outdoors = TRUE

/area/lavaland/surface/outdoors/unexplored //monsters and ruins spawn here
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	map_generator = /datum/map_generator/cave_generator/lavaland

/area/lavaland/surface/outdoors/unexplored/danger //megafauna will also spawn here
	icon_state = "danger"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED

/// Same thing as parent, but uses a different map generator for the icemoon ruin that needs it.
/area/lavaland/surface/outdoors/unexplored/danger/no_ruins
	map_generator = /datum/map_generator/cave_generator/lavaland/ruin_version

/area/lavaland/surface/outdoors/explored
	name = "Lavaland Labor Camp-拉瓦兰劳改营"
	area_flags = VALID_TERRITORY | UNIQUE_AREA



/**********************Ice Moon Areas**************************/

/area/icemoon
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = UNIQUE_AREA | FLORA_ALLOWED
	ambience_index = AMBIENCE_ICEMOON
	sound_environment = SOUND_AREA_ICEMOON
	ambient_buzz = 'sound/ambience/magma.ogg'

/area/icemoon/surface
	name = "Icemoon-冰月"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	area_flags = UNIQUE_AREA | FLORA_ALLOWED
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/icemoon/surface/outdoors // parent that defines if something is on the exterior of the station.
	name = "Icemoon Wastes-冰月废土"
	outdoors = TRUE

/area/icemoon/surface/outdoors/Initialize(mapload)
	if(HAS_TRAIT(SSstation, STATION_TRAIT_BRIGHT_DAY))
		base_lighting_alpha = 145
	return ..()

/// this is the area you use for stuff to not spawn, but if you still want weather.
/area/icemoon/surface/outdoors/nospawn

// unless you roll forested trait lol (fuck you time green)
/area/icemoon/surface/outdoors/nospawn/New()
	. = ..()
	// this area SOMETIMES does map generation. Often it doesn't at all
	// so it SHOULD NOT be used with the genturf turf type, as it is not always replaced
	if(HAS_TRAIT(SSstation, STATION_TRAIT_FORESTED))
		map_generator = /datum/map_generator/cave_generator/icemoon/surface/forested
		// flip this on, the generator has already disabled dangerous fauna
		area_flags = MOB_SPAWN_ALLOWED | FLORA_ALLOWED

/area/icemoon/surface/outdoors/noteleport // for places like the cursed spring water
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | NOTELEPORT

/area/icemoon/surface/outdoors/noruins // when you want random generation without the chance of getting ruins
	icon_state = "noruins"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED
	map_generator =  /datum/map_generator/cave_generator/icemoon/surface/noruins

/area/icemoon/surface/outdoors/labor_camp
	name = "Icemoon Labor Camp-冰月劳改营"
	area_flags = UNIQUE_AREA

/area/icemoon/surface/outdoors/unexplored //monsters and ruins spawn here
	icon_state = "unexplored"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED

/area/icemoon/surface/outdoors/unexplored/rivers // rivers spawn here
	icon_state = "danger"
	map_generator = /datum/map_generator/cave_generator/icemoon/surface

/area/icemoon/surface/outdoors/unexplored/rivers/New()
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_FORESTED))
		map_generator = /datum/map_generator/cave_generator/icemoon/surface/forested
		area_flags |= MOB_SPAWN_ALLOWED //flip this on, the generator has already disabled dangerous fauna

/area/icemoon/surface/outdoors/unexplored/rivers/no_monsters
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | CAVES_ALLOWED

/area/icemoon/underground
	name = "Icemoon Caves-冰月地下洞穴"
	outdoors = TRUE
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	area_flags = UNIQUE_AREA | FLORA_ALLOWED
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/icemoon/underground/unexplored // mobs and megafauna and ruins spawn here
	name = "Icemoon Caves-冰月地下洞穴"
	icon_state = "unexplored"
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED

/area/icemoon/underground/unexplored/no_rivers
	icon_state = "norivers"
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED // same rules as "shoreline" turfs since we might need this to pull double-duty
	map_generator = /datum/map_generator/cave_generator/icemoon

/area/icemoon/underground/unexplored/rivers // rivers spawn here
	icon_state = "danger"
	map_generator = /datum/map_generator/cave_generator/icemoon

/area/icemoon/underground/unexplored/rivers/deep
	map_generator = /datum/map_generator/cave_generator/icemoon/deep

/area/icemoon/underground/unexplored/rivers/deep/shoreline //use this for when you don't want mobs to spawn in certain areas in the "deep" portions. Think adjacent to rivers or station structures.
	icon_state = "shore"
	area_flags = UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED

/area/icemoon/underground/explored // ruins can't spawn here
	name = "Icemoon Underground-冰月地下区域"
	area_flags = UNIQUE_AREA

/area/icemoon/underground/explored/graveyard
	name = "Graveyard-墓地"
	area_flags = UNIQUE_AREA
	ambience_index = AMBIENCE_SPOOKY
	icon = 'icons/area/areas_station.dmi'
	icon_state = "graveyard"

/area/icemoon/underground/explored/graveyard/chapel
	name = "Chapel Graveyard-教堂墓地"
