/datum/traitor_objective/ultimate/romerol
	name = "通过在 %AREA% 召唤空投来传播实验性生化武器罗梅罗试剂"
	description = "前往 %AREA%，接收生化武器. 将其传播给船员，\
	然后观察他们死而复生，变成没有意识的杀戮机器. 警告：不死者也会攻击你."

	//这是一个原型，因此这个进程适用于所有基本级别的杀戮目标

	///任务持有者必须在此区域内才能接收罗美罗尔
	var/area/romerol_spawnarea_type
	///检查是否已发送罗美罗尔
	var/sent_romerol = FALSE

/datum/traitor_objective/ultimate/romerol/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	var/list/possible_areas = GLOB.the_station_areas.Copy()
	for(var/area/possible_area as anything in possible_areas)
		//删除离目的地太近、对我们的可怜家伙来说太明显或不公平的区域
		if(ispath(possible_area, /area/station/hallway) || ispath(possible_area, /area/station/security))
			possible_areas -= possible_area
	if(length(possible_areas) == 0)
		return FALSE
	romerol_spawnarea_type = pick(possible_areas)
	replace_in_name("%AREA%", initial(romerol_spawnarea_type.name))
	return TRUE

/datum/traitor_objective/ultimate/romerol/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!sent_romerol)
		buttons += add_ui_button("", "按下此按钮将呼叫一个带有生物危害套件的空投舱.", "biohazard", "romerol")
	return buttons

/datum/traitor_objective/ultimate/romerol/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if("romerol")
			if(sent_romerol)
				return
			var/area/delivery_area = get_area(user)
			if(delivery_area.type != romerol_spawnarea_type)
				to_chat(user, span_warning("你必须在 [initial(romerol_spawnarea_type.name)] 才能接收生化武器."))
				return
			sent_romerol = TRUE
			podspawn(list(
				"target" = get_turf(user),
				"style" = STYLE_SYNDICATE,
				"spawn" = /obj/item/storage/box/syndie_kit/romerol,
			))
