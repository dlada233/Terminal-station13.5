#define SUMMON_POSSIBILITIES 3

/datum/objective/sacrifice
	var/sacced = FALSE
	var/sac_image

/// Unregister signals from the old target so it doesn't cause issues when sacrificed of when a new target is found.
/datum/objective/sacrifice/proc/clear_sacrifice()
	if(!target)
		return
	UnregisterSignal(target, COMSIG_MIND_TRANSFERRED)
	if(target.current)
		UnregisterSignal(target.current, list(COMSIG_QDELETING, COMSIG_MOB_MIND_TRANSFERRED_INTO))
	target = null

/datum/objective/sacrifice/find_target(dupe_search_range, list/blacklist)
	clear_sacrifice()
	if(!istype(team, /datum/team/cult))
		return
	var/datum/team/cult/cult = team
	var/list/target_candidates = list()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		// SKYRAT EDIT ADDITION START - Players in the interlink can't be obsession targets
		if(SSticker.IsRoundInProgress() && istype(get_area(player), /area/centcom/interlink))
			continue
		// SKYRAT EDIT END
		if(player.mind && !player.mind.has_antag_datum(/datum/antagonist/cult) && !is_convertable_to_cult(player) && player.stat != DEAD)
			target_candidates += player.mind
	if(target_candidates.len == 0)
		message_admins("血教献祭: 找不到不可转换目标，检查可转换目标.")
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			// SKYRAT EDIT ADDITION START - Players in the interlink can't be obsession targets
			if(SSticker.IsRoundInProgress() && istype(get_area(player), /area/centcom/interlink))
				continue
			// SKYRAT EDIT END
			if(player.mind && !player.mind.has_antag_datum(/datum/antagonist/cult) && player.stat != DEAD)
				target_candidates += player.mind
	list_clear_nulls(target_candidates)
	if(LAZYLEN(target_candidates))
		target = pick(target_candidates)
		update_explanation_text()
		// Register a bunch of signals to both the target mind and its body
		// to stop cult from softlocking everytime the target is deleted before being actually sacrificed.
		RegisterSignal(target, COMSIG_MIND_TRANSFERRED, PROC_REF(on_mind_transfer))
		RegisterSignal(target.current, COMSIG_QDELETING, PROC_REF(on_target_body_del))
		RegisterSignal(target.current, COMSIG_MOB_MIND_TRANSFERRED_INTO, PROC_REF(on_possible_mindswap))
	else
		message_admins("血教献祭: 找不到不可转化和可转化目标. WELP!")
		sacced = TRUE // Prevents another hypothetical softlock. This basically means every PC is a cultist.
	if(!sacced)
		cult.make_image(src)
	for(var/datum/mind/mind in cult.members)
		if(mind.current)
			mind.current.clear_alert("bloodsense")
			mind.current.throw_alert("bloodsense", /atom/movable/screen/alert/bloodsense)

/datum/objective/sacrifice/proc/on_target_body_del()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(find_target))

/datum/objective/sacrifice/proc/on_mind_transfer(datum/source, mob/previous_body)
	SIGNAL_HANDLER
	//If, for some reason, the mind was transferred to a ghost (better safe than sorry), find a new target.
	if(!isliving(target.current))
		INVOKE_ASYNC(src, PROC_REF(find_target))
		return
	UnregisterSignal(previous_body, list(COMSIG_QDELETING, COMSIG_MOB_MIND_TRANSFERRED_INTO))
	RegisterSignal(target.current, COMSIG_QDELETING, PROC_REF(on_target_body_del))
	RegisterSignal(target.current, COMSIG_MOB_MIND_TRANSFERRED_INTO, PROC_REF(on_possible_mindswap))

/datum/objective/sacrifice/proc/on_possible_mindswap(mob/source)
	SIGNAL_HANDLER
	UnregisterSignal(target.current, list(COMSIG_QDELETING, COMSIG_MOB_MIND_TRANSFERRED_INTO))
	//we check if the mind is bodyless only after mindswap shenanigeans to avoid issues.
	addtimer(CALLBACK(src, PROC_REF(do_we_have_a_body)), 0 SECONDS)

/datum/objective/sacrifice/proc/do_we_have_a_body()
	if(!target.current) //The player was ghosted and the mind isn't probably going to be transferred to another mob at this point.
		find_target()
		return
	RegisterSignal(target.current, COMSIG_QDELETING, PROC_REF(on_target_body_del))
	RegisterSignal(target.current, COMSIG_MOB_MIND_TRANSFERRED_INTO, PROC_REF(on_possible_mindswap))

/datum/objective/sacrifice/check_completion()
	return sacced || completed

/datum/objective/sacrifice/update_explanation_text()
	if(target)
		explanation_text = "献祭[target]，[target.assigned_role.title]，将其放在一个供给符文上激活，并有三个教徒围在周围."
	else
		explanation_text = "这里的帷幕已经被削弱了，进入最终目标."

/datum/objective/eldergod
	var/summoned = FALSE
	var/killed = FALSE
	var/list/summon_spots = list()

/datum/objective/eldergod/New()
	..()
	var/sanity = 0
	while(summon_spots.len < SUMMON_POSSIBILITIES && sanity < 100)
		var/area/summon_area = pick(GLOB.areas - summon_spots)
		if(summon_area && is_station_level(summon_area.z) && (summon_area.area_flags & VALID_TERRITORY))
			summon_spots += summon_area
		sanity++
	update_explanation_text()

/datum/objective/eldergod/update_explanation_text()
	explanation_text = "通过激活'召唤Nar'Sie'符文召唤Nar'Sie. 召唤只能在[english_list(summon_spots)]中完成 - 那里的帷幕足够弱."

/datum/objective/eldergod/check_completion()
	if(killed)
		return CULT_NARSIE_KILLED // You failed so hard that even the code went backwards.
	return summoned || completed

#undef SUMMON_POSSIBILITIES
