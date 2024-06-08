/datum/traitor_objective/ultimate/supermatter_cascade
	name = "通过引发晶体共振级联来摧毁空间站"
	description = "通过引发超物质级联来摧毁站点，前往 %AREA% 接收不稳定的晶体，并将其用于超物质。"

	/// 任务持有者必须在此区域内才能接收不稳定的晶体
	var/area/dest_crystal_area_pickup
	/// 检查是否已发送晶体
	var/sent_crystal = FALSE

/datum/traitor_objective/ultimate/supermatter_cascade/can_generate_objective(generating_for, list/possible_duplicates)
	. = ..()
	if(!.)
		return FALSE

	if(isnull(GLOB.main_supermatter_engine))
		return FALSE
	var/obj/machinery/power/supermatter_crystal/engine/crystal = locate() in GLOB.main_supermatter_engine
	if(!is_station_level(crystal.z) && !is_mining_level(crystal.z))
		return FALSE

	return TRUE

/datum/traitor_objective/ultimate/supermatter_cascade/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	var/list/possible_areas = GLOB.the_station_areas.Copy()
	for(var/area/possible_area as anything in possible_areas)
		// 移除距离目标太近、对玩家太明显或不公平的区域
		if(ispath(possible_area, /area/station/hallway) || ispath(possible_area, /area/station/security))
			possible_areas -= possible_area
	if(length(possible_areas) == 0)
		return FALSE
	dest_crystal_area_pickup = pick(possible_areas)
	replace_in_name("%AREA%", initial(dest_crystal_area_pickup.name))
	return TRUE

/datum/traitor_objective/ultimate/supermatter_cascade/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!sent_crystal)
		buttons += add_ui_button("", "点击此按钮将召唤一个带有超物质级联工具包的空投。", "biohazard", "destabilizing_crystal")
	return buttons

/datum/traitor_objective/ultimate/supermatter_cascade/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if("destabilizing_crystal")
			if(sent_crystal)
				return
			var/area/delivery_area = get_area(user)
			if(delivery_area.type != dest_crystal_area_pickup)
				to_chat(user, span_warning("您必须在 [initial(dest_crystal_area_pickup.name)] 才能接收超物质级联工具包。"))
				return
			sent_crystal = TRUE
			podspawn(list(
				"target" = get_turf(user),
				"style" = STYLE_SYNDICATE,
				"spawn" = /obj/item/destabilizing_crystal,
			))
