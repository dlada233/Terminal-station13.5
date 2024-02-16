/datum/computer_file/program/ai_restorer
	filename = "AI管理&复原"
	filedesc = "AI管理&复原"
	downloader_category = PROGRAM_CATEGORY_SCIENCE
	program_open_overlay = "generic"
	extended_desc = "固件恢复包，能够复原损坏的AI系统.需要将英特利储存卡连接至插槽."
	size = 12
	can_run_on_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	download_access = list(ACCESS_RD)
	tgui_id = "NtosAiRestorer"
	program_icon = "laptop-code"

	/// The AI stored in the program
	var/obj/item/aicard/stored_card
	/// Variable dictating if we are in the process of restoring the AI in the inserted intellicard
	var/restoring = FALSE

/datum/computer_file/program/ai_restorer/on_examine(obj/item/modular_computer/source, mob/user)
	var/list/examine_text = list()
	if(!stored_card)
		examine_text += "有一个用于插入英特利储存卡的卡槽."
		return examine_text

	if(computer.Adjacent(user))
		examine_text += "有一个用于英特利储存卡，当前里面有: [stored_card.name]"
	else
		examine_text += "有一个用于插入英特利储存卡的卡槽，目前已经被占用了."
	examine_text += span_info("Alt-左键取出英特利储存卡.")
	return examine_text

/datum/computer_file/program/ai_restorer/kill_program(mob/user)
	try_eject(forced = TRUE)
	return ..()

/datum/computer_file/program/ai_restorer/process_tick(seconds_per_tick)
	. = ..()
	if(!restoring) //Put the check here so we don't check for an ai all the time
		return

	var/mob/living/silicon/ai/A = stored_card.AI
	if(stored_card.flush)
		restoring = FALSE
		return
	A.adjustOxyLoss(-5, FALSE)
	A.adjustFireLoss(-5, FALSE)
	A.adjustBruteLoss(-5, FALSE)

	// Please don't forget to update health, otherwise the below if statements will probably always fail.
	A.updatehealth()
	if(A.health >= 0 && A.stat == DEAD)
		A.revive()
		stored_card.update_appearance()

	// Finished restoring
	if(A.health >= 100)
		restoring = FALSE

	return TRUE

/datum/computer_file/program/ai_restorer/application_attackby(obj/item/attacking_item, mob/living/user)
	if(!computer)
		return FALSE
	if(!istype(attacking_item, /obj/item/aicard))
		return FALSE

	if(stored_card)
		to_chat(user, span_warning("你尝试将[attacking_item]插入[computer.name], 但插槽已经被占用了."))
		return FALSE
	if(user && !user.transferItemToLoc(attacking_item, computer))
		return FALSE

	stored_card = attacking_item
	to_chat(user, span_notice("你将[attacking_item]插入到[computer.name]上."))

	return TRUE

/datum/computer_file/program/ai_restorer/try_eject(mob/living/user, forced = FALSE)
	if(!stored_card)
		if(user)
			to_chat(user, span_warning("[computer.name]内英特利储存卡."))
		return FALSE

	if(restoring && !forced)
		if(user)
			to_chat(user, span_warning("重建完成前请勿取出储存卡，以免发生安全故障..."))
		return FALSE

	if(user && computer.Adjacent(user))
		to_chat(user, span_notice("你从[computer.name]取出了[stored_card]."))
		user.put_in_hands(stored_card)
	else
		stored_card.forceMove(computer.drop_location())

	stored_card = null
	restoring = FALSE
	return TRUE


/datum/computer_file/program/ai_restorer/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("PRG_beginReconstruction")
			if(!stored_card || !stored_card.AI)
				return FALSE
			var/mob/living/silicon/ai/A = stored_card.AI
			if(A && A.health < 100)
				restoring = TRUE
				A.notify_revival("你的核心文件正在恢复!", source = computer)
			return TRUE
		if("PRG_eject")
			if(stored_card)
				try_eject(usr)
				return TRUE

/datum/computer_file/program/ai_restorer/ui_data(mob/user)
	var/list/data = list()

	data["ejectable"] = TRUE
	data["AI_present"] = !!stored_card?.AI
	data["error"] = null

	if(!stored_card)
		data["error"] = "请插入英特利储存卡."
	else if(!stored_card.AI)
		data["error"] = "未能定位到AI..."
	else if(stored_card.flush)
		data["error"] = "刷新进程!"
	else
		data["name"] = stored_card.AI.name
		data["restoring"] = restoring
		data["health"] = (stored_card.AI.health + 100) / 2
		data["isDead"] = stored_card.AI.stat == DEAD
		data["laws"] = stored_card.AI.laws.get_law_list(include_zeroth = TRUE, render_html = FALSE)

	return data
