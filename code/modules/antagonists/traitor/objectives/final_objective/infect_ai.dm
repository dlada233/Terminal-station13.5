/datum/traitor_objective/ultimate/infect_ai
	name = "用实验性病毒感染空间站AI"
	description = "用实验性病毒感染空间站AI，前往 %AREA% 领取一个感染法令上传模块，并将其用于AI核心或法令上传控制台."

	/// 任务持有者必须在此区域内才能接收法令上传模块的区域类型
	var/area/board_area_pickup
	/// 检查是否已发送法令上传模块
	var/sent_board = FALSE

/datum/traitor_objective/ultimate/infect_ai/can_generate_objective(generating_for, list/possible_duplicates)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/silicon/ai/ai in GLOB.ai_list)
		if(ai.stat == DEAD || ai.mind?.has_antag_datum(/datum/antagonist/malf_ai) || !is_station_level(ai.z))
			continue
		return TRUE

	return FALSE

/datum/traitor_objective/ultimate/infect_ai/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	var/list/possible_areas = GLOB.the_station_areas.Copy()
	for(var/area/possible_area as anything in possible_areas)
		//移除距离目标太近的区域，太明显的区域，或者对目标不公平的区域
		if(istype(possible_area, /area/station/hallway) || istype(possible_area, /area/station/security))
			possible_areas -= possible_area
	if(!length(possible_areas))
		return FALSE
	board_area_pickup = pick(possible_areas)
	replace_in_name("%AREA%", initial(board_area_pickup.name))
	return TRUE

/datum/traitor_objective/ultimate/infect_ai/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!sent_board)
		buttons += add_ui_button("", "按下此按钮将呼叫一个带有感染法令上传板的传输舱.", "wifi", "upload_board")
	return buttons

/datum/traitor_objective/ultimate/infect_ai/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if("upload_board")
			if(sent_board)
				return
			var/area/delivery_area = get_area(user)
			if(delivery_area.type != board_area_pickup)
				to_chat(user, span_warning("你必须在 [initial(board_area_pickup.name)] 才能接收感染的法令上传板."))
				return
			sent_board = TRUE
			podspawn(list(
				"target" = get_turf(user),
				"style" = STYLE_SYNDICATE,
				"spawn" = /obj/item/ai_module/malf,
			))
