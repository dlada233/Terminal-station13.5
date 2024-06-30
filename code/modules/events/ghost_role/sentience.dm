GLOBAL_LIST_INIT(high_priority_sentience, typecacheof(list(
	/mob/living/basic/bat,
	/mob/living/basic/butterfly,
	/mob/living/basic/carp/pet/cayenne,
	/mob/living/basic/chicken,
	/mob/living/basic/cow,
	/mob/living/basic/goat,
	/mob/living/basic/lizard,
	/mob/living/basic/mouse/brown/tom,
	/mob/living/basic/parrot,
	/mob/living/basic/pet,
	/mob/living/basic/pig,
	/mob/living/basic/rabbit,
	/mob/living/basic/sheep,
	/mob/living/basic/sloth,
	/mob/living/basic/snake,
	/mob/living/basic/spider/giant/sgt_araneus,
	/mob/living/simple_animal/bot/secbot/beepsky,
	/mob/living/simple_animal/hostile/retaliate/goose/vomit,
)))

/datum/round_event_control/sentience
	name = "Random Human-level Intelligence-随机高等智能"
	typepath = /datum/round_event/ghost_role/sentience
	weight = 10
	category = EVENT_CATEGORY_FRIENDLY
	description = "一只动物或机器人变得拥有知性!"
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 7


/datum/round_event/ghost_role/sentience
	minimum_required = 1
	role_name = "随机动物"
	var/animals = 1
	var/one = "某个"
	fakeable = TRUE

/datum/round_event/ghost_role/sentience/announce(fake)
	var/sentience_report = ""

	var/data = pick("远程传感器扫描结果", "我们的复杂概率模型", "我们的全知全能", "你站的无线电通信流量", "探测到的能量辐射", "\[数据删除\]")
	var/pets = pick("动物/机械", "机械/动物", "宠物", "低等动物", "脆弱生命", "\[数据删除\]")
	var/strength = pick("人类", "高", "蜥蜴人", "安保", "指挥", "小丑", "低", "极低", "\[数据删除\]")

	sentience_report += "根据[data]，我们认为 [one][pets] 已经发展出了[strength]级智能，并具备沟通能力."

	priority_announce(sentience_report,"[command_name()] 中等优先级事项")

/datum/round_event/ghost_role/sentience/spawn_role()
	var/list/mob/dead/observer/candidates = SSpolling.poll_ghost_candidates(check_jobban = ROLE_SENTIENCE, role = ROLE_SENTIENCE, alert_pic = /obj/item/slimepotion/slime/sentience, role_name_text = role_name)
	if(!length(candidates))
		return NOT_ENOUGH_PLAYERS

	// find our chosen mob to breathe life into
	// Mobs have to be simple animals, mindless, on station, and NOT holograms.
	// prioritize starter animals that people will recognise


	var/list/potential = list()

	var/list/hi_pri = list()
	var/list/low_pri = list()

	for(var/mob/living/simple_animal/check_mob in GLOB.alive_mob_list)
		set_mob_priority(check_mob, hi_pri, low_pri)
	for(var/mob/living/basic/check_mob in GLOB.alive_mob_list)
		set_mob_priority(check_mob, hi_pri, low_pri)

	shuffle_inplace(hi_pri)
	shuffle_inplace(low_pri)

	potential = hi_pri + low_pri

	if(!potential.len)
		return WAITING_FOR_SOMETHING
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/spawned_animals = 0
	while(spawned_animals < animals && candidates.len && potential.len)
		var/mob/living/selected = popleft(potential)
		var/mob/dead/observer/picked_candidate = pick_n_take(candidates)

		spawned_animals++

		selected.key = picked_candidate.key

		selected.grant_all_languages(UNDERSTOOD_LANGUAGE, grant_omnitongue = FALSE, source = LANGUAGE_ATOM)

		if (isanimal(selected))
			var/mob/living/simple_animal/animal_selected = selected
			animal_selected.sentience_act()
			animal_selected.del_on_death = FALSE
		else if	(isbasicmob(selected))
			var/mob/living/basic/animal_selected = selected
			animal_selected.basic_mob_flags &= ~DEL_ON_DEATH

		selected.maxHealth = max(selected.maxHealth, 200)
		selected.health = selected.maxHealth
		spawned_mobs += selected

		to_chat(selected, span_userdanger("Hello world!"))
		to_chat(selected, "<span class='warning'>由于受到辐射或化学物质感染\
			或只是运气好，你获得了人类的水平的智力\
			和理解人类语言的能力!</span>")

	return SUCCESSFUL_SPAWN

/// Adds a mob to either the high or low priority event list
/datum/round_event/ghost_role/sentience/proc/set_mob_priority(mob/living/checked_mob, list/high, list/low)
	var/turf/mob_turf = get_turf(checked_mob)
	if(!mob_turf || !is_station_level(mob_turf.z))
		return
	if((checked_mob in GLOB.player_list) || checked_mob.mind || (checked_mob.flags_1 & HOLOGRAM_1))
		return
	if(is_type_in_typecache(checked_mob, GLOB.high_priority_sentience))
		high += checked_mob
	else
		low += checked_mob

/datum/round_event_control/sentience/all
	name = "Station-wide Human-level Intelligence-全站高等智能"
	typepath = /datum/round_event/ghost_role/sentience/all
	weight = 0
	category = EVENT_CATEGORY_FRIENDLY
	description = "所有动物和机器人变得拥有知性，以满足灵魂们的数量."

/datum/round_event/ghost_role/sentience/all
	one = "所有"
	animals = INFINITY // as many as there are ghosts and animals
	// cockroach pride, station wide
