
//These are shuttle areas; all subtypes are only used as teleportation markers, they have no actual function beyond that.
//Multi area shuttles are a thing now, use subtypes! ~ninjanomnom

/area/shuttle
	name = "Shuttle-飞船"
	requires_power = FALSE
	static_lighting = TRUE
	has_gravity = STANDARD_GRAVITY
	always_unpowered = FALSE
	// Loading the same shuttle map at a different time will produce distinct area instances.
	area_flags = NONE
	icon = 'icons/area/areas_station.dmi'
	icon_state = "shuttle"
	flags_1 = CAN_BE_DIRTY_1
	area_limited_icon_smoothing = /area/shuttle
	sound_environment = SOUND_ENVIRONMENT_ROOM


/area/shuttle/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	. = ..()
	if(length(new_baseturfs) > 1 || fake_turf_type)
		return // More complicated larger changes indicate this isn't a player
	if(ispath(new_baseturfs[1], /turf/open/floor/plating))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)

////////////////////////////Multi-area shuttles////////////////////////////

////////////////////////////Syndicate////////////////////////////

/area/shuttle/syndicate
	name = "Syndicate-渗透者号"
	ambience_index = AMBIENCE_DANGER
	area_limited_icon_smoothing = /area/shuttle/syndicate

/area/shuttle/syndicate/bridge
	name = "Syndicate-渗透者号控制室"

/area/shuttle/syndicate/medical
	name = "Syndicate-渗透者号医疗处"

/area/shuttle/syndicate/armory
	name = "Syndicate-渗透者号军械处"

/area/shuttle/syndicate/eva
	name = "Syndicate-渗透者号EVA存放处"

/area/shuttle/syndicate/hallway
	name = "Syndicate-渗透者号船体"

/area/shuttle/syndicate/engineering
	name = "Syndicate-渗透者号工程部"

/area/shuttle/syndicate/airlock
	name = "Syndicate-渗透者号气闸"

////////////////////////////Pirate Shuttle////////////////////////////

/area/shuttle/pirate
	name = "Pirate Shuttle-海盗船"
	requires_power = TRUE

/area/shuttle/pirate/flying_dutchman
	name = "Flying Dutchman-飞翔的荷兰人号"
	requires_power = FALSE

////////////////////////////Bounty Hunter Shuttles////////////////////////////

/area/shuttle/hunter
	name = "Hunter Shuttle-赏金猎人飞船"

/area/shuttle/hunter/russian
	name = "Russian Cargo Hauler-俄罗斯货运船"
	requires_power = TRUE

////////////////////////////White Ship////////////////////////////

/area/shuttle/abandoned
	name = "Abandoned Ship-废弃船"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/abandoned

/area/shuttle/abandoned/bridge
	name = "Abandoned Ship-废弃船舰桥"

/area/shuttle/abandoned/engine
	name = "Abandoned Ship-废弃船引擎"

/area/shuttle/abandoned/bar
	name = "Abandoned Ship-废弃船酒吧"

/area/shuttle/abandoned/crew
	name = "Abandoned Ship-废弃船宿舍"

/area/shuttle/abandoned/cargo
	name = "Abandoned Ship-废弃船货仓"

/area/shuttle/abandoned/medbay
	name = "Abandoned Ship-废弃船医疗部"

/area/shuttle/abandoned/pod
	name = "Abandoned Ship-废弃船逃生舱"

////////////////////////////Single-area shuttles////////////////////////////
/area/shuttle/transit
	name = "Hyperspace-超空间"
	desc = "Weeeeee"
	static_lighting = FALSE
	base_lighting_alpha = 255


/area/shuttle/arrival
	name = "Arrival Shuttle-登站班轮"
	area_flags = UNIQUE_AREA// SSjob refers to this area for latejoiners


/area/shuttle/arrival/on_joining_game(mob/living/boarder)
	if(SSshuttle.arrivals?.mode == SHUTTLE_CALL)
		var/atom/movable/screen/splash/Spl = new(null, boarder.client, TRUE)
		Spl.Fade(TRUE)
		boarder.playsound_local(get_turf(boarder), 'sound/voice/ApproachingTG.ogg', 25)
	boarder.update_parallax_teleport()


/area/shuttle/pod_1
	name = "Escape Pod-第一逃生舱"
	area_flags = NONE

/area/shuttle/pod_2
	name = "Escape Pod-第二逃生舱"
	area_flags = NONE

/area/shuttle/pod_3
	name = "Escape Pod-第三逃生舱"
	area_flags = NONE

/area/shuttle/pod_4
	name = "Escape Pod-第四逃生舱"
	area_flags = NONE

/area/shuttle/mining
	name = "Mining Shuttle-采矿飞船"

/area/shuttle/mining/large
	name = "Mining Shuttle-采矿飞船"
	requires_power = TRUE

/area/shuttle/labor
	name = "Labor Camp Shuttle-劳改营飞船"

/area/shuttle/supply
	name = "NLV Consign" //SKYRAT EDIT CHANGE
	area_flags = NOTELEPORT

/area/shuttle/escape
	name = "Emergency Shuttle-应急撤离飞船"
	area_flags = BLOBS_ALLOWED
	area_limited_icon_smoothing = /area/shuttle/escape
	flags_1 = CAN_BE_DIRTY_1
	area_flags = CULT_PERMITTED

/area/shuttle/escape/backup
	name = "Backup Emergency Shuttle-备用应急撤离飞船"

/area/shuttle/escape/brig
	name = "Escape Shuttle Brig-撤离飞船门关"
	icon_state = "shuttlered"

/area/shuttle/escape/luxury
	name = "Luxurious Emergency Shuttle-高端撤离飞船"
	area_flags = NOTELEPORT

/area/shuttle/escape/simulation
	name = "Medieval Reality Simulation Dome-中世纪现实模拟圆厅"
	icon_state = "shuttlectf"
	area_flags = NOTELEPORT
	static_lighting = FALSE
	base_lighting_alpha = 255

/area/shuttle/escape/arena
	name = "The Arena-竞技场"
	area_flags = NOTELEPORT

/area/shuttle/escape/meteor
	name = "\proper meteor-一块绑着发动机的陨石小行星"
	luminosity = NONE

/area/shuttle/escape/engine
	name = "Escape Shuttle Engine-撤离飞船引擎"

/area/shuttle/transport
	name = "Transport Shuttle-运输船"

/area/shuttle/assault_pod
	name = "Steel Rain-钢雨"

/area/shuttle/sbc_starfury
	name = "SBC Starfury"

/area/shuttle/sbc_fighter1
	name = "SBC Fighter 1"

/area/shuttle/sbc_fighter2
	name = "SBC Fighter 2"

/area/shuttle/sbc_fighter3
	name = "SBC Fighter 3"

/area/shuttle/sbc_corvette
	name = "SBC corvette"

/area/shuttle/syndicate_scout
	name = "Syndicate-侦察舰"

/area/shuttle/ruin
	name = "Ruined Shuttle-毁坏飞船"

/// Special shuttles made for the Caravan Ambush ruin.
/area/shuttle/ruin/caravan
	requires_power = TRUE
	name = "Ruined Caravan Shuttle-毁坏旅行船"

/area/shuttle/ruin/caravan/syndicate1
	name = "Syndicate-辛迪加战斗机"

/area/shuttle/ruin/caravan/syndicate2
	name = "Syndicate-辛迪加战斗机"

/area/shuttle/ruin/caravan/syndicate3
	name = "Syndicate-辛迪加空投船"

/area/shuttle/ruin/caravan/pirate
	name = "Pirate Cutter-海盗切割器"

/area/shuttle/ruin/caravan/freighter1
	name = "Small Freighter-小型货船"

/area/shuttle/ruin/caravan/freighter2
	name = "Tiny Freighter-微型货船"

/area/shuttle/ruin/caravan/freighter3
	name = "Tiny Freighter-微型货船"

// ----------- Cyborg Mothership

/area/shuttle/ruin/cyborg_mothership
	name = "Cyborg Mothership-货仓母舰"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/ruin/cyborg_mothership

// ----------- Arena Shuttle
/area/shuttle/shuttle_arena
	name = "arena"
	has_gravity = STANDARD_GRAVITY
	requires_power = FALSE

/obj/effect/forcefield/arena_shuttle
	name = "portal"
	initial_duration = 0
	var/list/warp_points = list()

/obj/effect/forcefield/arena_shuttle/Initialize(mapload)
	. = ..()
	for(var/obj/effect/landmark/shuttle_arena_safe/exit in GLOB.landmarks_list)
		warp_points += exit

/obj/effect/forcefield/arena_shuttle/Bumped(atom/movable/AM)
	if(!isliving(AM))
		return

	var/mob/living/L = AM
	if(L.pulling && istype(L.pulling, /obj/item/bodypart/head))
		to_chat(L, span_notice("你的申请得到了允诺. 你可以过去了."), confidential = TRUE)
		qdel(L.pulling)
		var/turf/LA = get_turf(pick(warp_points))
		L.forceMove(LA)
		L.remove_status_effect(/datum/status_effect/hallucination)
		to_chat(L, "<span class='reallybig redtext'>战斗胜利了，你的嗜血欲望消退了.</span>", confidential = TRUE)
		for(var/obj/item/chainsaw/doomslayer/chainsaw in L)
			qdel(chainsaw)
		var/obj/item/skeleton_key/key = new(L)
		L.put_in_hands(key)
	else
		to_chat(L, span_warning("你还不够格，把一颗被砍下的头颅拖到栅栏上，才能进入冠军之厅."), confidential = TRUE)

/obj/effect/landmark/shuttle_arena_safe
	name = "hall of champions-冠军之厅"
	desc = "胜者为王."

/obj/effect/landmark/shuttle_arena_entrance
	name = "\proper the arena-竞技场"
	desc = "熔岩遍布的战场."

/obj/effect/forcefield/arena_shuttle_entrance
	name = "portal-传送门"
	initial_duration = 0
	var/list/warp_points = list()

/obj/effect/forcefield/arena_shuttle_entrance/Bumped(atom/movable/AM)
	if(!isliving(AM))
		return

	if(!warp_points.len)
		for(var/obj/effect/landmark/shuttle_arena_entrance/S in GLOB.landmarks_list)
			warp_points |= S

	var/obj/effect/landmark/LA = pick(warp_points)
	var/mob/living/M = AM
	M.forceMove(get_turf(LA))
	to_chat(M, "<span class='reallybig redtext'>你被困在一个致命的竞技场里，只有将一颗被砍下的头颅拖到逃生口，你才能离开.</span>", confidential = TRUE)
	M.apply_status_effect(/datum/status_effect/mayhem)
