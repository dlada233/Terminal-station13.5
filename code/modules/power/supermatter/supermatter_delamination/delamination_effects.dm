// These are supposed to be discrete effects so we can tell at a glance what does each override
// of [/datum/sm_delam/proc/delaminate] does.
// Please keep them discrete and give them proper, descriptive function names.
// Oh and all of them returns true if the effect succeeded.

/// Irradiates mobs around 20 tiles of the sm.
/// Just the mobs apparently.
/datum/sm_delam/proc/effect_irradiate(obj/machinery/power/supermatter_crystal/sm)
	var/turf/sm_turf = get_turf(sm)
	for (var/mob/living/victim in range(DETONATION_RADIATION_RANGE, sm))
		if(!is_valid_z_level(get_turf(victim), sm_turf))
			continue
		if(victim.z == 0)
			continue
		SSradiation.irradiate(victim)
	return TRUE

/// Hallucinates and makes mobs in Z level sad.
/datum/sm_delam/proc/effect_demoralize(obj/machinery/power/supermatter_crystal/sm)
	var/turf/sm_turf = get_turf(sm)
	for(var/mob/living/victim as anything in GLOB.alive_mob_list)
		if(!istype(victim) || !is_valid_z_level(get_turf(victim), sm_turf))
			continue
		if(victim.z == 0)
			continue

		//Hilariously enough, running into a closet should make you get hit the hardest.
		var/hallucination_amount = max(100 SECONDS, min(600 SECONDS, DETONATION_HALLUCINATION * sqrt(1 / (get_dist(victim, src) + 1))))
		victim.adjust_hallucinations(hallucination_amount)

	for(var/mob/victim as anything in GLOB.player_list)
		var/turf/victim_turf = get_turf(victim)
		if(!is_valid_z_level(victim_turf, sm_turf))
			continue
		victim.playsound_local(victim_turf, 'sound/magic/charge.ogg')
		if(victim.z == 0) //victim is inside an object, this is to maintain an old bug turned feature with lockers n shit i guess. tg issue #69687
			to_chat(victim, span_boldannounce("你紧抓着[victim.loc]不放, 你周围的现实正不断扭曲. 你感到安全."))
			continue
		to_chat(victim, span_boldannounce("你觉得现实扭曲了一会儿..."))
		if (isliving(victim))
			var/mob/living/living_victim = victim
			living_victim.add_mood_event("delam", /datum/mood_event/delam)
	return TRUE

/// Spawns anomalies all over the station. Half instantly, the other half over time.
/datum/sm_delam/proc/effect_anomaly(obj/machinery/power/supermatter_crystal/sm)
	var/anomalies = 10
	var/list/anomaly_types = list(GRAVITATIONAL_ANOMALY = 55, HALLUCINATION_ANOMALY = 45, DIMENSIONAL_ANOMALY = 35, BIOSCRAMBLER_ANOMALY = 35, FLUX_ANOMALY = 25, PYRO_ANOMALY = 5, VORTEX_ANOMALY = 1)
	var/list/anomaly_places = GLOB.generic_event_spawns

	// Spawns this many anomalies instantly. Spawns the rest with callbacks.
	var/cutoff_point = round(anomalies * 0.5, 1)

	for(var/i in 1 to anomalies)
		var/anomaly_to_spawn = pick_weight(anomaly_types)
		var/anomaly_location = pick_n_take(anomaly_places)

		if(i < cutoff_point)
			supermatter_anomaly_gen(anomaly_location, anomaly_to_spawn, has_changed_lifespan = FALSE)
			continue

		var/current_spawn = rand(5 SECONDS, 10 SECONDS)
		var/next_spawn = rand(5 SECONDS, 10 SECONDS)
		var/extended_spawn = 0
		if(SPT_PROB(1, next_spawn))
			extended_spawn = rand(5 MINUTES, 15 MINUTES)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(supermatter_anomaly_gen), anomaly_location, anomaly_to_spawn, TRUE), current_spawn + extended_spawn)
	return TRUE

/// Explodes
/datum/sm_delam/proc/effect_explosion(obj/machinery/power/supermatter_crystal/sm)
	var/explosion_power = sm.explosion_power
	var/power_scaling = sm.gas_heat_power_generation
	var/turf/sm_turf = get_turf(sm)
	//Dear mappers, balance the sm max explosion radius to 17.5, 37, 39, 41
	explosion(origin = sm_turf,
		devastation_range = explosion_power * max(power_scaling, 0.205) * 0.5,
		heavy_impact_range = explosion_power * max(power_scaling, 0.205) + 2,
		light_impact_range = explosion_power * max(power_scaling, 0.205) + 4,
		flash_range = explosion_power * max(power_scaling, 0.205) + 6,
		adminlog = TRUE,
		ignorecap = TRUE
	)
	return TRUE

/// Spawns a scrung and eat the SM.
/datum/sm_delam/proc/effect_singulo(obj/machinery/power/supermatter_crystal/sm)
	var/turf/sm_turf = get_turf(sm)
	if(!sm_turf)
		stack_trace("Supermatter [sm] failed to spawn singularity, cant get current turf.")
		return FALSE
	var/obj/singularity/created_singularity = new(sm_turf)
	created_singularity.energy = 800
	created_singularity.consume(sm)
	return TRUE

/// Teslas
/datum/sm_delam/proc/effect_tesla(obj/machinery/power/supermatter_crystal/sm)
	var/turf/sm_turf = get_turf(sm)
	if(!sm_turf)
		stack_trace("Supermatter [sm] failed to spawn tesla, cant get current turf.")
		return FALSE
	var/obj/energy_ball/created_tesla = new(sm_turf)
	created_tesla.energy = 200 //Gets us about 9 balls
	return TRUE

/// Mail the shuttle off to buy milk.
/datum/sm_delam/proc/effect_strand_shuttle()
	set waitfor = FALSE
	// set timer to infinity, so shuttle never arrives
	SSshuttle.emergency.setTimer(INFINITY)
	// disallow shuttle recalls, so people cannot cheese the timer
	SSshuttle.emergency_no_recall = TRUE
	// set supermatter cascade to true, to prevent auto evacuation due to no way of calling the shuttle
	SSshuttle.supermatter_cascade = TRUE
	// set hijack completion timer to infinity, so that you cant prematurely end the round with a hijack
	for(var/obj/machinery/computer/emergency_shuttle/console as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/computer/emergency_shuttle))
		console.hijack_completion_flight_time_set = INFINITY

	/* This logic is to keep uncalled shuttles uncalled
	In SSshuttle, there is not much of a way to prevent shuttle calls, unless we mess with admin panel vars
	SHUTTLE_STRANDED is different here, because it *can* block the shuttle from being called, however if we don't register a hostile
	environment, it gets unset immediately. Internally, it checks if the count of HEs is zero
	and that the shuttle is in stranded mode, then frees it with an announcement.
	This is a botched solution to a problem that could be solved with a small change in shuttle code, however-
	*/
	if(SSshuttle.emergency.mode == SHUTTLE_IDLE)
		SSshuttle.emergency.mode = SHUTTLE_STRANDED
		SSshuttle.registerHostileEnvironment(src)
		return

	// say goodbye to that shuttle of yours
	if(SSshuttle.emergency.mode != SHUTTLE_ESCAPE)
		priority_announce(
			text = "紧急撤离船在运输过程中发生致命错误，无法重新建立连接.",
			title = "撤离指令失败",
			sound = ANNOUNCER_SHUTTLE, // SKYRAT EDIT CHANGE - Announcer Sounds - ORIGINAL: sound = 'sound/misc/announce_dig.ogg',
			sender_override = "应急撤离线路",
			color_override = "grey",
		)
	else
	// except if you are on it already, then you are safe c:
		minor_announce("错误: 在导航协议中检测到损坏. 与应答器#XCC-P5831-ES13的连接丢失. \
				备份退出路由协议解密. 校准路线...",
			"应急撤离船", TRUE) // wait out until the rift on the station gets destroyed and the final message plays
		var/list/mobs = mobs_in_area_type(list(/area/shuttle/escape))
		for(var/mob/living/mob as anything in mobs) // emulate mob/living/lateShuttleMove() behaviour
			if(mob.buckled)
				continue
			if(mob.client)
				shake_camera(mob, 3 SECONDS * 0.25, 1)
			mob.Paralyze(3 SECONDS, TRUE)

/datum/sm_delam/proc/effect_cascade_demoralize()
	for(var/mob/player as anything in GLOB.player_list)
		if(!isdead(player))
			var/mob/living/living_player = player
			to_chat(player, span_boldannounce("你周围的一切都与一种强大的能量产生了共鸣，这不可能是好事."))
			living_player.add_mood_event("cascade", /datum/mood_event/cascade)
		SEND_SOUND(player, 'sound/magic/charge.ogg')

/datum/sm_delam/proc/effect_emergency_state()
	if(SSsecurity_level.get_current_level_as_number() != SEC_LEVEL_DELTA)
		SSsecurity_level.set_level(SEC_LEVEL_DELTA) // skip the announcement and shuttle timer adjustment in set_security_level()
	make_maint_all_access()
	for(var/obj/machinery/light/light_to_break as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
		if(prob(35))
			light_to_break.set_major_emergency_light()
			continue
		light_to_break.break_light_tube()

/// Spawn an evacuation rift for people to go through.
/datum/sm_delam/proc/effect_evac_rift_start()
	var/obj/cascade_portal/rift = new /obj/cascade_portal(get_turf(pick(GLOB.generic_event_spawns)))
	priority_announce("我们被覆盖整个区域的电磁脉冲袭击了. 所有的系统都严重受损, 包括撤离船导航系统. \
		我们只能推断出在你的空间站上或附近正在发生超物质串联.\n\n\
		通过传统方式撤离疏散已不具备可能性; 但我们设法在[get_area_name(rift)]附近打开了一个裂隙. \
		特此要求所有人员以任何可能的方式进入裂隙.\n\n\
		[Gibberish("在必要的系统设备恢复后，将进行救援工作.", FALSE, 5)] \
		[Gibberish("祝你好运--", FALSE, 25)]")
	return rift

/// Announce the destruction of the rift and end the round.
/datum/sm_delam/proc/effect_evac_rift_end()
	priority_announce("[Gibberish("裂缝已经被摧毁了，我们不再能进行援助.", FALSE, 5)]")

	sleep(25 SECONDS)

	priority_announce("报告指出晶体种子的形成是在共振移位事件之后. \
		晶体质量的迅速膨胀与重力效应的上升成正比. \
		在可预见的引力作用下，物质坍缩将发生.",
		"Nanotrasen观星协会")

	sleep(25 SECONDS)

	priority_announce("[Gibberish("所有的撤离尝试现在终止, 所有资产已经从你区域被回收.\n \
		致[station_name()]上的剩余幸存者, 再见.", FALSE, 5)]")

	if(SSshuttle.emergency.mode == SHUTTLE_ESCAPE)
		// special message for hijacks
		var/shuttle_msg = "导航协议设置为[SSshuttle.emergency.is_hijacked() ? "\[错误\]" : "备用路线"]. \
			重新定向蓝空飞船到出口航路. ETA 15 秒."
		// garble the special message
		if(SSshuttle.emergency.is_hijacked())
			shuttle_msg = Gibberish(shuttle_msg, TRUE, 15)
		minor_announce(shuttle_msg, "应急撤离船", TRUE)
		SSshuttle.emergency.setTimer(15 SECONDS)
		return

	sleep(10 SECONDS)

	SSticker.news_report = SUPERMATTER_CASCADE
	SSticker.force_ending = FORCE_END_ROUND

/// Scatters crystal mass over the event spawns as long as they are at least 30 tiles away from whatever we want to avoid.
/datum/sm_delam/proc/effect_crystal_mass(obj/machinery/power/supermatter_crystal/sm, avoid)
	new /obj/crystal_mass(get_turf(sm))
	var/list/possible_spawns = GLOB.generic_event_spawns.Copy()
	for(var/i in 1 to rand(4,6))
		var/spawn_location
		do
			spawn_location = pick_n_take(possible_spawns)
		while(get_dist(spawn_location, avoid) < 30)
		new /obj/crystal_mass(get_turf(spawn_location))
