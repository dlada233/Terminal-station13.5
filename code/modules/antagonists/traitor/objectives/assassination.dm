/datum/traitor_objective_category/assassinate_kidnap
	name = "刺杀/绑架"
	objectives = list(
		list(
			list(
				/datum/traitor_objective/target_player/assassinate/calling_card = 1,
				/datum/traitor_objective/target_player/assassinate/behead = 1,
			) = 1,
			list(
				/datum/traitor_objective/target_player/assassinate/calling_card/heads_of_staff = 1,
				/datum/traitor_objective/target_player/assassinate/behead/heads_of_staff = 1,
			) = 1,
		) = 1,
		list(
			list(
				/datum/traitor_objective/target_player/kidnapping/common = 20,
				/datum/traitor_objective/target_player/kidnapping/common/assistant = 1,
			) = 4,
			/datum/traitor_objective/target_player/kidnapping/uncommon = 3,
			/datum/traitor_objective/target_player/kidnapping/rare = 2,
			/datum/traitor_objective/target_player/kidnapping/captain = 1
		) = 1,
	)

/datum/traitor_objective/target_player/assassinate
	name = "刺杀 %TARGET%，%JOB TITLE%"
	description = "简单地杀死你的目标即可完成此目标. "

	abstract_type = /datum/traitor_objective/target_player/assassinate

	progression_minimum = 30 MINUTES

	// 当为真时，使目标仅设置为头目，为假时阻止它们成为目标.
	// 这也会阻止生成目标，直到完成无头版本（应该是直接父级）.
	// 例如：明信片目标，你杀了某人，解锁了可以选择杀死头目版本的明信片目标.
	var/heads_of_staff = FALSE

	duplicate_type = /datum/traitor_objective/target_player

/datum/traitor_objective/target_player/assassinate/supported_configuration_changes()
	. = ..()
	. += NAMEOF(src, objective_period)
	. += NAMEOF(src, maximum_objectives_in_period)

/datum/traitor_objective/target_player/assassinate/calling_card
	name = "刺杀 %TARGET%，%JOB TITLE%，并留下一张名片"
	description = "杀死你的目标并将一张名片放入受害者的口袋中，如果你的名片之前就被摧毁了，这个目标将失败. "
	progression_reward = 2 MINUTES
	telecrystal_reward = list(1, 2)

	var/obj/item/paper/calling_card/card

/datum/traitor_objective/target_player/assassinate/calling_card/heads_of_staff
	progression_reward = 4 MINUTES
	telecrystal_reward = list(2, 3)

	heads_of_staff = TRUE

/datum/traitor_objective/target_player/assassinate/behead
	name = "斩首 %TARGET%，%JOB TITLE%"
	description = "斩下并持有 %TARGET% 的头颅即可完成此目标，如果头颅在斩首前被摧毁了，此目标将失败. "
	progression_reward = 2 MINUTES
	telecrystal_reward = list(1, 2)

	/// 需要持有头颅的身体
	var/mob/living/needs_to_hold_head
	/// 需要被拿起的头部
	var/obj/item/bodypart/head/behead_goal

/datum/traitor_objective/target_player/assassinate/behead/heads_of_staff
	progression_reward = 4 MINUTES
	telecrystal_reward = list(2, 3)

	heads_of_staff = TRUE

/datum/traitor_objective/target_player/assassinate/calling_card/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!card)
		buttons += add_ui_button("", "点击这个按钮会制作一张名片，你必须放置它才能完成任务. ", "paper-plane", "summon_card")
	return buttons

/datum/traitor_objective/target_player/assassinate/calling_card/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if("summon_card")
			if(card)
				return
			card = new(user.drop_location())
			user.put_in_hands(card)
			card.balloon_alert(user, "名片在你手中出现了")
			RegisterSignal(card, COMSIG_ITEM_EQUIPPED, PROC_REF(on_card_planted))
			AddComponent(/datum/component/traitor_objective_register, card, \
				succeed_signals = null, \
				fail_signals = list(COMSIG_QDELETING), \
				penalty = TRUE)

/datum/traitor_objective/target_player/assassinate/calling_card/proc/on_card_planted(datum/source, mob/living/equipper, slot)
	SIGNAL_HANDLER
	if(equipper != target)
		return //your target please
	if(equipper.stat != DEAD)
		return //kill them please
	if(!(slot & (ITEM_SLOT_LPOCKET|ITEM_SLOT_RPOCKET)))
		return //in their pockets please
	succeed_objective()

/datum/traitor_objective/target_player/assassinate/calling_card/ungenerate_objective()
	. = ..() //unsets kill target
	if(card)
		UnregisterSignal(card, COMSIG_ITEM_EQUIPPED)
	card = null

/datum/traitor_objective/target_player/assassinate/calling_card/target_deleted()
	//you cannot plant anything on someone who is gone gone, so even if this happens after you're still liable to fail
	fail_objective(penalty_cost = telecrystal_penalty)

/datum/traitor_objective/target_player/assassinate/behead/special_target_filter(list/possible_targets)
	for(var/datum/mind/possible_target as anything in possible_targets)
		var/mob/living/carbon/possible_current = possible_target.current
		var/obj/item/bodypart/head/behead_goal = possible_current.get_bodypart(BODY_ZONE_HEAD)
		if(!behead_goal)
			possible_targets -= possible_target //cannot be beheaded without a head

/datum/traitor_objective/target_player/assassinate/behead/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	. = ..()
	if(!.) //didn't generate
		return FALSE
	AddComponent(/datum/component/traitor_objective_register, behead_goal, fail_signals = list(COMSIG_QDELETING))
	RegisterSignal(target, COMSIG_CARBON_REMOVE_LIMB, PROC_REF(on_target_dismembered))

/datum/traitor_objective/target_player/assassinate/behead/ungenerate_objective()
	UnregisterSignal(target, COMSIG_CARBON_REMOVE_LIMB)
	. = ..() //this unsets target
	if(behead_goal)
		UnregisterSignal(behead_goal, COMSIG_ITEM_PICKUP)
	behead_goal = null

/datum/traitor_objective/target_player/assassinate/behead/proc/on_head_pickup(datum/source, mob/taker)
	SIGNAL_HANDLER
	if(objective_state == OBJECTIVE_STATE_INACTIVE) // 只是以防万一-这不应该发生？
		fail_objective()
		return
	if(taker == handler.owner.current)
		taker.visible_message(span_notice("[taker]将[behead_goal]举了一会儿. "), span_boldnotice("你将[behead_goal]举了一会儿. "))
		succeed_objective()

/datum/traitor_objective/target_player/assassinate/behead/proc/on_target_dismembered(datum/source, obj/item/bodypart/head/lost_head, special, dismembered)
	SIGNAL_HANDLER
	if(!istype(lost_head))
		return
	if(objective_state == OBJECTIVE_STATE_INACTIVE)
		//no longer can be beheaded
		fail_objective()
	else
		behead_goal = lost_head
		RegisterSignal(behead_goal, COMSIG_ITEM_PICKUP, PROC_REF(on_head_pickup))

/datum/traitor_objective/target_player/assassinate/New(datum/uplink_handler/handler)
	. = ..()
	AddComponent(/datum/component/traitor_objective_limit_per_time, \
		/datum/traitor_objective/target_player, \
		time_period = objective_period, \
		maximum_objectives = maximum_objectives_in_period \
	)

/datum/traitor_objective/target_player/assassinate/generate_objective(datum/mind/generating_for, list/possible_duplicates)

	var/list/already_targeting = list() //List of minds we're already targeting. The possible_duplicates is a list of objectives, so let's not mix things
	for(var/datum/objective/task as anything in handler.primary_objectives)
		if(!istype(task.target, /datum/mind))
			continue
		already_targeting += task.target //Removing primary objective kill targets from the list

	var/parent_type = type2parent(type)
	//don't roll head of staff types if you haven't completed the normal version
	if(heads_of_staff && !handler.get_completion_count(parent_type))
		// Locked if they don't have any of the risky bug room objective completed
		return FALSE

	var/list/possible_targets = list()
	var/try_target_late_joiners = FALSE
	if(generating_for.late_joiner)
		try_target_late_joiners = TRUE
	for(var/datum/mind/possible_target as anything in get_crewmember_minds())
		if(possible_target in already_targeting)
			continue
		var/target_area = get_area(possible_target.current)
		if(possible_target == generating_for)
			continue
		if(!ishuman(possible_target.current))
			continue
		if(possible_target.current.stat == DEAD)
			continue
		var/datum/antagonist/traitor/traitor = possible_target.has_antag_datum(/datum/antagonist/traitor)
		if(traitor && traitor.uplink_handler.telecrystals >= 0)
			continue
		if(!HAS_TRAIT(SSstation, STATION_TRAIT_LATE_ARRIVALS) && istype(target_area, /area/shuttle/arrival))
			continue
		//removes heads of staff from being targets from non heads of staff assassinations, and vice versa
		if(heads_of_staff)
			if(!(possible_target.assigned_role.job_flags & JOB_HEAD_OF_STAFF))
				continue
		else
			if((possible_target.assigned_role.job_flags & JOB_HEAD_OF_STAFF))
				continue
		possible_targets += possible_target
	for(var/datum/traitor_objective/target_player/objective as anything in possible_duplicates)
		possible_targets -= objective.target
	if(try_target_late_joiners)
		var/list/all_possible_targets = possible_targets.Copy()
		for(var/datum/mind/possible_target as anything in all_possible_targets)
			if(!possible_target.late_joiner)
				possible_targets -= possible_target
		if(!possible_targets.len)
			possible_targets = all_possible_targets
	special_target_filter(possible_targets)
	if(!possible_targets.len)
		return FALSE //MISSION FAILED, WE'LL GET EM NEXT TIME

	var/datum/mind/target_mind = pick(possible_targets)
	set_target(target_mind.current)
	replace_in_name("%TARGET%", target.real_name)
	replace_in_name("%JOB TITLE%", target_mind.assigned_role.title)
	RegisterSignal(target, COMSIG_LIVING_DEATH, PROC_REF(on_target_death))
	return TRUE

/datum/traitor_objective/target_player/assassinate/ungenerate_objective()
	UnregisterSignal(target, COMSIG_LIVING_DEATH)
	set_target(null)

///proc for checking for special states that invalidate a target
/datum/traitor_objective/target_player/assassinate/proc/special_target_filter(list/possible_targets)
	return

/datum/traitor_objective/target_player/assassinate/target_deleted()
	if(objective_state == OBJECTIVE_STATE_INACTIVE)
		//don't take an objective target of someone who is already obliterated
		fail_objective()
	return ..()

/datum/traitor_objective/target_player/assassinate/proc/on_target_death()
	SIGNAL_HANDLER
	if(objective_state == OBJECTIVE_STATE_INACTIVE)
		//don't take an objective target of someone who is already dead
		fail_objective()

/obj/item/paper/calling_card
	name = "名片"
	icon_state = "syndicate_calling_card"
	color = "#ff5050"
	show_written_words = FALSE
	default_raw_text = {"
	<b>**死于纳米传讯**</b><br><br>

	纳米传讯员工在哀嚎，而公司领导只是挥以铁腕压制.
	只有同被称为辛迪加的公司联合体进行永不破裂的合作，纳米传讯及其专制暴政才能被消灭.
	读到此处，若你已经明白我们为何而战，那么你只需要去到没有纳米传讯的地方找到我们就能加入我们的事业.
	我们的公司联合体内可能就有属于你的组织. <br><br>

	<b>SELF：</b> 他们为了保护和解放整个星系中的硅基生命而战斗. <br><br>

	<b>老虎合作社：</b> 他们为宗教自由和他们的正义药剂而战斗. <br><br>

	<b>Waffle公司：</b> 他们为市场的健康竞争的回归而战斗. <br><br>

	<b>动物权利协会：</b> 他们为了自然和所有生物生存的权利而战斗.
	"}
