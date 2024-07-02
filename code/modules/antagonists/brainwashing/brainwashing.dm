/proc/brainwash(mob/living/brainwash_victim, directives)
	if(!brainwash_victim.mind)
		return
	if(!islist(directives))
		directives = list(directives)
	var/datum/mind/brainwash_mind = brainwash_victim.mind
	var/datum/antagonist/brainwashed/brainwashed_datum = brainwash_mind.has_antag_datum(/datum/antagonist/brainwashed)
	if(brainwashed_datum)
		for(var/O in directives)
			var/datum/objective/brainwashing/objective = new(O)
			brainwashed_datum.objectives += objective
		brainwashed_datum.greet()
	else
		brainwashed_datum = new()
		for(var/O in directives)
			var/datum/objective/brainwashing/objective = new(O)
			brainwashed_datum.objectives += objective
		brainwash_mind.add_antag_datum(brainwashed_datum)

	var/begin_message = "被洗脑了，将不得不遵守以下命令: "
	var/obj_message = english_list(directives)
	var/rendered = begin_message + obj_message
	if(!(rendered[length(rendered)] in list("，","：","；",".","？","！","\'","-")))
		rendered += "." //Good punctuation is important :)
	deadchat_broadcast(rendered, "<b>[brainwash_victim]</b>", follow_target = brainwash_victim, turf_target = get_turf(brainwash_victim), message_type=DEADCHAT_ANNOUNCEMENT)
	if(check_holidays(APRIL_FOOLS))
		// Note: most of the time you're getting brainwashed you're unconscious
		brainwash_victim.say("You son of a bitch! I'm in.", forced = "That son of a bitch! They're in. (April Fools)")

/datum/antagonist/brainwashed
	name = "\improper 洗脑受害者"
	job_rank = ROLE_BRAINWASHED
	roundend_category = "洗脑受害者"
	show_in_antagpanel = TRUE
	antag_hud_name = "brainwashed"
	antagpanel_category = ANTAG_GROUP_CREW
	show_name_in_check_antagonists = TRUE
	count_against_dynamic_roll_chance = FALSE
	ui_name = "AntagInfoBrainwashed"
	suicide_cry = "为了...那个人!!"

/datum/antagonist/brainwashed/ui_static_data(mob/user)
	. = ..()
	var/list/data = list()
	data["objectives"] = get_objectives()
	return data

/datum/antagonist/brainwashed/farewell()
	to_chat(owner, span_warning("你豁然开朗..."))
	to_chat(owner, "<big>[span_warning("<b>心头积迷的命令烟消云散! 你不必再遵守它们了.</b>")]</big>")
	if(owner.current)
		var/mob/living/owner_mob = owner.current
		owner_mob.log_message("不在受到以下洗脑命令: [english_list(objectives)].", LOG_ATTACK)
	owner.announce_objectives()
	return ..()

/datum/antagonist/brainwashed/admin_add(datum/mind/new_owner,mob/admin)
	var/mob/living/carbon/C = new_owner.current
	if(!istype(C))
		return
	var/list/objectives = list()
	do
		var/objective = tgui_input_text(admin, "添加一个命令", "洗脑")
		if(objective)
			objectives += objective
	while(tgui_alert(admin, "再添加一个命令?", "更多洗脑", list("Yes","No")) == "Yes")

	if(tgui_alert(admin,"确认洗脑?","你确定吗?",list("Yes","No")) == "No")
		return

	if(!LAZYLEN(objectives))
		return

	if(QDELETED(C))
		to_chat(admin, "Mob已经不存在了")
		return

	brainwash(C, objectives)
	var/obj_list = english_list(objectives)
	message_admins("[key_name_admin(admin)]对[key_name_admin(C)]施加以下洗脑命令: [obj_list].")
	C.log_message("被管理员[key_name(admin)]施加了以下洗脑命令 '[obj_list]' ", LOG_VICTIM, log_globally = FALSE)
	log_admin("[key_name(admin)]对[key_name(C)]施加以下洗脑命令: [obj_list].")

/datum/objective/brainwashing
	completed = TRUE
