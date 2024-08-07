/datum/round_event_control/aurora_caelus
	name = "Aurora Caelus-极光"
	typepath = /datum/round_event/aurora_caelus
	max_occurrences = 1
	weight = 1
	earliest_start = 5 MINUTES
	category = EVENT_CATEGORY_FRIENDLY
	description = "透过窗户有五颜六色的风景. 还有厨房."

/datum/round_event_control/aurora_caelus/can_spawn_event(players, allow_magic = FALSE)
	if(!SSmapping.empty_space)
		return FALSE
	return ..()

/datum/round_event/aurora_caelus
	announce_when = 1
	start_when = 21
	end_when = 80

/datum/round_event/aurora_caelus/announce()
	priority_announce("[station_name()]: 一团离子云正在接近你方空间站，预计将无害地产生极光. 纳米传讯已经批准了一段休闲时间以惬意地观赏这个罕见的事件. 可视宇宙将在这段时间内变得静谧而柔美，祝你享受愉快.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "纳米传讯气象部门")
	for(var/V in GLOB.player_list)
		var/mob/M = V
		if((M.client.prefs.read_preference(/datum/preference/toggle/sound_midi)) && is_station_level(M.z))
			M.playsound_local(M, 'sound/ambience/aurora_caelus.ogg', 20, FALSE, pressure_affected = FALSE)
	fade_space(fade_in = TRUE)
	fade_kitchen(fade_in = TRUE)

/datum/round_event/aurora_caelus/start()
	if(!prob(1) && !check_holidays(APRIL_FOOLS))
		return
	for(var/area/station/service/kitchen/affected_area in GLOB.areas)
		var/obj/machinery/oven/roast_ruiner = locate() in affected_area
		if(roast_ruiner)
			roast_ruiner.balloon_alert_to_viewers("oh egads!")
			var/turf/ruined_roast = get_turf(roast_ruiner)
			ruined_roast.atmos_spawn_air("[GAS_PLASMA]=100;[TURF_TEMPERATURE(1000)]")
			message_admins("极光事件导致烤箱在[ADMIN_VERBOSEJMP(ruined_roast)]起火.")
			log_game("极光事件导致烤箱在[loc_name(ruined_roast)]起火.")
			announce_to_ghosts(roast_ruiner)
		for(var/mob/living/carbon/human/seymour as anything in GLOB.human_list)
			if(seymour.mind && istype(seymour.mind.assigned_role, /datum/job/cook))
				seymour.say("烤砸了!!!", forced = "ruined roast")
				seymour.emote("scream")

/datum/round_event/aurora_caelus/tick()
	if(activeFor % 8 != 0)
		return
	var/aurora_color = hsl_gradient((activeFor - start_when) / (end_when - start_when), 0, "#A2FF80", 1, "#A2FFEE")
	set_starlight(aurora_color)

	for(var/area/station/service/kitchen/affected_area in GLOB.areas)
		for(var/turf/open/kitchen_floor in affected_area.get_turfs_from_all_zlevels())
			kitchen_floor.set_light(l_color = aurora_color)

/datum/round_event/aurora_caelus/end()
	fade_space()
	fade_kitchen()
	priority_announce("极光事件即将结束，宇宙光照将恢复正常. 请在结束后马上回到工作岗位继续工作. 祝您今天过得愉快.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "Nanotrasen Meteorology Division")

/datum/round_event/aurora_caelus/proc/fade_space(fade_in = FALSE)
	set waitfor = FALSE
	// iterate all glass tiles
	var/start_color = hsl_gradient(1, 0, "#A2FF80", 1, "#A2FFEE")
	var/start_range = GLOB.starlight_range * 1.75
	var/start_power = GLOB.starlight_power * 0.6
	var/end_color = GLOB.base_starlight_color
	var/end_range = GLOB.starlight_range
	var/end_power = GLOB.starlight_power
	if(fade_in)
		end_color = hsl_gradient(0, 0, "#A2FF80", 1, "#A2FFEE")
		end_range = start_range
		end_power = start_power
		start_color = GLOB.base_starlight_color
		start_range = GLOB.starlight_range
		start_power = GLOB.starlight_power

	for(var/i in 1 to 5)
		var/walked_color = hsl_gradient(i/5, 0, start_color, 1, end_color)
		var/walked_range = LERP(start_range, end_range, i/5)
		var/walked_power = LERP(start_power, end_power, i/5)
		set_starlight(walked_color, walked_range, walked_power)
		sleep(8 SECONDS)
	set_starlight(end_color, end_range, end_power)

/datum/round_event/aurora_caelus/proc/fade_kitchen(fade_in = FALSE)
	set waitfor = FALSE
	var/start_color = hsl_gradient(1, 0, "#A2FF80", 1, "#A2FFEE")
	var/start_range = 1
	var/start_power = 0.75
	var/end_color = COLOR_BLACK
	var/end_range = 0.5
	var/end_power = 0
	if(fade_in)
		end_color = hsl_gradient(0, 0, "#A2FF80", 1, "#A2FFEE")
		end_range = start_range
		end_power = start_power
		start_color = COLOR_BLACK
		start_range = 0.5
		start_power = 0

	for(var/i in 1 to 5)
		var/walked_color = hsl_gradient(i/5, 0, start_color, 1, end_color)
		var/walked_range = LERP(start_range, end_range, i/5)
		var/walked_power = LERP(start_power, end_power, i/5)
		for(var/area/station/service/kitchen/affected_area in GLOB.areas)
			for(var/turf/open/kitchen_floor in affected_area.get_turfs_from_all_zlevels())
				kitchen_floor.set_light(walked_range, walked_power, walked_color)
		sleep(8 SECONDS)
	for(var/area/station/service/kitchen/affected_area in GLOB.areas)
		for(var/turf/open/kitchen_floor in affected_area.get_turfs_from_all_zlevels())
			kitchen_floor.set_light(end_range, end_power, end_color)
