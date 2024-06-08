/datum/traitor_objective/ultimate/dark_matteor
	name = "召唤暗物质奇点吞噬车站"
	description = "前往 %AREA% 并接收走私卫星和电子干扰器.设置并使用电子干扰器修改卫星的校准，\
	当足够多的卫星被重新校准后，暗物质奇点将会出现. 警告：暗物质奇点会猎杀所有生物，包括你在内."

	//这是一个原型，所以这个进程适用于所有基本级别的杀戮目标

	///任务持有者必须在此区域内才能接收卫星
	var/area/satellites_spawnarea_type
	///检查是否已发送卫星
	var/sent_satellites = FALSE

/datum/traitor_objective/ultimate/dark_matteor/can_generate_objective(generating_for, list/possible_duplicates)
	. = ..()
	if(!.)
		return FALSE
	if(SSmapping.is_planetary())
		return FALSE //陨石无法在行星上生成
	return TRUE

/datum/traitor_objective/ultimate/dark_matteor/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	var/list/possible_areas = GLOB.the_station_areas.Copy()
	for(var/area/possible_area as anything in possible_areas)
		if(!ispath(possible_area, /area/station/maintenance/solars) && !ispath(possible_area, /area/station/solars))
			possible_areas -= possible_area
	if(length(possible_areas) == 0)
		return FALSE
	satellites_spawnarea_type = pick(possible_areas)
	replace_in_name("%AREA%", initial(satellites_spawnarea_type.name))
	return TRUE

/datum/traitor_objective/ultimate/dark_matteor/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!sent_satellites)
		buttons += add_ui_button("", "按下此按钮将呼叫一个带有走私卫星的传输舱.", "satellite", "satellite")
	return buttons

/datum/traitor_objective/ultimate/dark_matteor/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if("satellite")
			if(sent_satellites)
				return
			var/area/delivery_area = get_area(user)
			if(delivery_area.type != satellites_spawnarea_type)
				to_chat(user, span_warning("你必须在 [initial(satellites_spawnarea_type.name)] 才能接收走私卫星."))
				return
			sent_satellites = TRUE
			podspawn(list(
				"target" = get_turf(user),
				"style" = STYLE_SYNDICATE,
				"spawn" = /obj/structure/closet/crate/engineering/smuggled_meteor_shields,
			))

/obj/structure/closet/crate/engineering/smuggled_meteor_shields

/obj/structure/closet/crate/engineering/smuggled_meteor_shields/PopulateContents()
	..()
	for(var/i in 1 to 11)
		new /obj/machinery/satellite/meteor_shield(src)
	new /obj/item/card/emag/meteor_shield_recalibrator(src)
	new /obj/item/paper/dark_matteor_summoning(src)

/obj/item/paper/dark_matteor_summoning
	name = "笔记 - 暗物质陨石召唤"
	default_raw_text = {"
		召唤暗物质陨石.<br>
		<br>
		<br>
		特工，此箱子包含10+1个陨石防护卫星，是从NT的供应线上偷来的.你的任务是在车站附近的太空中部署它们，并使用提供的电子干扰器重新校准它们.小心：每次骇入需要30秒的冷却时间，在七次重新校准后NT会检测到你的干扰，这意味着你至少需要5分钟的工作时间和1分钟的抵抗时间.<br>
		<br>
		这是一次高风险的行动. 你需要后援、设防以及决心. 那么回报是什么呢？<br>
		一个壮观的暗物质奇点，摧毁整个空间站.<br>
		<br>
		<b>**死于Nanotrasen.**</b>
"}

/obj/item/card/emag/meteor_shield_recalibrator
	name = "加密卫星重新校准器"
	desc = "这是一个加密的序列器，已被调校为更快且更安全地重新校准陨石防护卫星."
