/datum/round_event_control/space_dragon
	name = "Spawn Space Dragon-生成太空龙"
	typepath = /datum/round_event/ghost_role/space_dragon
	weight = 7
	max_occurrences = 1
	min_players = 20
	dynamic_should_hijack = TRUE
	category = EVENT_CATEGORY_ENTITIES
	description = "生成一只太空龙，它试图占领空间站."
	min_wizard_trigger_potency = 6
	max_wizard_trigger_potency = 7

/datum/round_event/ghost_role/space_dragon
	minimum_required = 1
	role_name = "太空龙"
	announce_when = 10

/datum/round_event/ghost_role/space_dragon/announce(fake)
	priority_announce("在 [station_name()] 附近探测到大型生命信号，请各就位.", "生命信号警报")

/datum/round_event/ghost_role/space_dragon/spawn_role()
	var/mob/chosen_one = SSpolling.poll_ghost_candidates(check_jobban = ROLE_SPACE_DRAGON, role = ROLE_SPACE_DRAGON, alert_pic = /mob/living/basic/space_dragon, amount_to_pick = 1)
	if(isnull(chosen_one))
		return NOT_ENOUGH_PLAYERS
	var/spawn_location = find_space_spawn()
	if(isnull(spawn_location))
		return MAP_ERROR
	var/mob/living/basic/space_dragon/dragon = new(spawn_location)
	dragon.key = chosen_one.key
	dragon.mind.add_antag_datum(/datum/antagonist/space_dragon)
	playsound(dragon, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	message_admins("[ADMIN_LOOKUPFLW(dragon)] has been made into a Space Dragon by an event.")
	dragon.log_message("was spawned as a Space Dragon by an event.", LOG_GAME)
	spawned_mobs += dragon
	return SUCCESSFUL_SPAWN
