/datum/traitor_objective/ultimate/space_dragon
	name = "接收空投在 %AREA% 的DNA收集器，提取太空鲤鱼DNA，然后使自己变异."
	description = "前往 %AREA% ，接收鲤鱼DNA扫描器，可以提取任何一只太空鲤鱼的DNA.\
	然后通过对自己使用将自己的DNA与鲤鱼混合变异，成为太空龙.\
	别担心找不到鲤鱼，当你需要时，会有一波鲤鱼出现的. "

	///任务持有者必须在此区域内才能接收 DNA 提取器
	var/area/dna_scanner_spawnarea_type
	///是否已发送 DNA 提取工具包
	var/received_dna_scanner = FALSE

/datum/traitor_objective/ultimate/space_dragon/on_objective_taken(mob/user)
	. = ..()
	force_event(/datum/round_event_control/carp_migration, "[handler.owner]的最终目标")

/datum/traitor_objective/ultimate/space_dragon/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	var/list/possible_areas = GLOB.the_station_areas.Copy()
	for(var/area/possible_area as anything in possible_areas)
		//删除离目的地太近、对我们的可怜家伙来说太明显或不公平的区域
		if(ispath(possible_area, /area/station/hallway) || ispath(possible_area, /area/station/security))
			possible_areas -= possible_area
	if(length(possible_areas) == 0)
		return FALSE
	dna_scanner_spawnarea_type = pick(possible_areas)
	replace_in_name("%AREA%", initial(dna_scanner_spawnarea_type.name))
	return TRUE

/datum/traitor_objective/ultimate/space_dragon/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!received_dna_scanner)
		buttons += add_ui_button("", "按下此按钮将呼叫一个带有 DNA 提取工具包的空投，", "biohazard", "carp_dna")
	return buttons

/datum/traitor_objective/ultimate/space_dragon/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if("carp_dna")
			if(received_dna_scanner)
				return
			var/area/delivery_area = get_area(user)
			if(delivery_area.type != dna_scanner_spawnarea_type)
				to_chat(user, span_warning("你必须在 [initial(dna_scanner_spawnarea_type.name)] 才能接收 DNA 提取工具包，"))
				return
			received_dna_scanner = TRUE
			podspawn(list(
				"target" = get_turf(user),
				"style" = STYLE_SYNDICATE,
				"spawn" = /obj/item/storage/box/syndie_kit/space_dragon,
			))
