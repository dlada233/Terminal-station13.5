/**
 * Sandstorm Event: Throws dust/sand at one side of the station. High-intensity and relatively short,
 * however the incoming direction is given along with time to prepare. Damages can be reduced or
 * mitigated with a few people actively working to fix things as the storm hits, but leaving the event to run on its own can lead to widespread breaches.
 *
 * Meant to be encountered mid-round, with enough spare manpower among the crew to properly respond.
 * Anyone with a welder or metal can contribute.
 */

/datum/round_event_control/sandstorm
	name = "Sandstorm: Directional-沙尘暴（单向）"
	typepath = /datum/round_event/sandstorm
	max_occurrences = 3
	min_players = 35
	earliest_start = 35 MINUTES
	category = EVENT_CATEGORY_SPACE
	description = "沙尘暴从空间站某个方向持续吹来."
	min_wizard_trigger_potency = 6
	max_wizard_trigger_potency = 7
	admin_setup = list(/datum/event_admin_setup/listed_options/sandstorm)
	map_flags = EVENT_SPACE_ONLY

/datum/round_event/sandstorm
	start_when = 60
	end_when = 100
	announce_when = 1
	///Which direction the storm will come from.
	var/start_side

/datum/round_event/sandstorm/setup()
	start_when = rand(70, 90)
	end_when = rand(110, 140)

/datum/round_event/sandstorm/announce(fake)
	if(!start_side)
		start_side = pick(GLOB.cardinals)

	var/start_side_text = "unknown"
	switch(start_side)
		if(NORTH)
			start_side_text = "前"
		if(SOUTH)
			start_side_text = "尾"
		if(EAST)
			start_side_text = "右"
		if(WEST)
			start_side_text = "左"
		else
			stack_trace("Sandstorm event given [start_side] as unrecognized direction. Cancelling event...")
			kill()
			return

	priority_announce("一股巨大的太空尘埃正从 [start_side_text] 侧逼近. \
		预计俩分钟后会有影响. 鼓励所有员工协助维修和减少损害.", "碰撞警报")

/datum/round_event/sandstorm/tick()
	spawn_meteors(15, GLOB.meteors_sandstorm, start_side)

/**
 * The original sandstorm event. An admin-only disasterfest that sands down all sides of the station
 * Uses space dust, meaning walls/rwalls are quickly chewed up very quickly.
 *
 * Super dangerous, super funny, preserved for future admin use in case the new event reminds
 * them that this exists. It is unchanged from its original form and is arguably perfect.
 */

/datum/round_event_control/sandstorm_classic
	name = "Sandstorm: Classic-沙尘暴（经典）"
	typepath = /datum/round_event/sandstorm_classic
	weight = 0
	max_occurrences = 0
	earliest_start = 0 MINUTES
	category = EVENT_CATEGORY_SPACE
	description = "空间站在几分钟内持续遭受从四面而来的沙尘暴，极具破坏性且可能造成卡顿延迟，使用风险自负."
	map_flags = EVENT_SPACE_ONLY

/datum/round_event/sandstorm_classic
	start_when = 1
	end_when = 150 // ~5 min //I don't think this actually lasts 5 minutes unless you're including the lag it induces
	announce_when = 0
	fakeable = FALSE

/datum/round_event/sandstorm_classic/tick()
	spawn_meteors(10, GLOB.meteors_dust)

/datum/event_admin_setup/listed_options/sandstorm
	input_text = "选择方向?"
	normal_run_option = "Random Sandstorm Direction"

/datum/event_admin_setup/listed_options/sandstorm/get_list()
	return list("上", "下", "右", "左")

/datum/event_admin_setup/listed_options/sandstorm/apply_to_event(datum/round_event/sandstorm/event)
	switch(chosen)
		if("上")
			event.start_side = NORTH
		if("下")
			event.start_side = SOUTH
		if("右")
			event.start_side = EAST
		if("左")
			event.start_side = WEST
