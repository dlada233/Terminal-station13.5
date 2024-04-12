/obj/machinery/power/apc/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(isAI(user) || iscyborg(user))
		context[SCREENTIP_CONTEXT_LMB] = "Open UI"
		context[SCREENTIP_CONTEXT_RMB] = locked ? "解锁" : "锁定"
		context[SCREENTIP_CONTEXT_CTRL_LMB] = operating ? "断电" : "通电"
		context[SCREENTIP_CONTEXT_SHIFT_LMB] = lighting ? "照明断电" : "照明通电"
		context[SCREENTIP_CONTEXT_ALT_LMB] = equipment ? "设备断电" : "设备通电"
		context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB] = environ ? "环境断电" : "环境通电"

	else if (isnull(held_item))
		if (opened == APC_COVER_CLOSED)
			context[SCREENTIP_CONTEXT_RMB] = locked ? "解锁" : "锁定"
		else if (opened == APC_COVER_OPENED && cell)
			context[SCREENTIP_CONTEXT_LMB] = "移除电池"

	else if(held_item.tool_behaviour == TOOL_CROWBAR)
		if (opened == APC_COVER_CLOSED)
			context[SCREENTIP_CONTEXT_LMB] = "打开面板盖"
		else if ((opened == APC_COVER_OPENED && has_electronics == APC_ELECTRONICS_SECURED) && !(machine_stat & BROKEN))
			context[SCREENTIP_CONTEXT_LMB] = "关上并锁定"
		else if (machine_stat & BROKEN|(machine_stat & EMAGGED| malfhack))
			context[SCREENTIP_CONTEXT_LMB] = "移除受损电路板"
		else
			context[SCREENTIP_CONTEXT_LMB] = "移除电路板"

	else if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
		if (opened == APC_COVER_CLOSED)
			context[SCREENTIP_CONTEXT_LMB] = panel_open ? "隐藏电线" : "暴露电线"
		else if (cell && opened == APC_COVER_OPENED)
			context[SCREENTIP_CONTEXT_LMB] = "移除电池"
		else if (has_electronics == APC_ELECTRONICS_INSTALLED)
			context[SCREENTIP_CONTEXT_LMB] = "固定电路板"
		else if (has_electronics == APC_ELECTRONICS_SECURED)
			context[SCREENTIP_CONTEXT_LMB] = "解开电路板"

	else if(held_item.tool_behaviour == TOOL_WIRECUTTER)
		if (terminal && opened == APC_COVER_OPENED)
			context[SCREENTIP_CONTEXT_LMB] = "拆卸电源端口"

	else if(held_item.tool_behaviour == TOOL_WELDER)
		if (opened == APC_COVER_OPENED && !has_electronics)
			context[SCREENTIP_CONTEXT_LMB] = "拆卸APC"

	else if(istype(held_item, /obj/item/stock_parts/cell) && opened == APC_COVER_OPENED)
		context[SCREENTIP_CONTEXT_LMB] = "插入电池"

	else if(istype(held_item, /obj/item/stack/cable_coil) && opened == APC_COVER_OPENED)
		context[SCREENTIP_CONTEXT_LMB] = "创建电源端口"

	else if(istype(held_item, /obj/item/electronics/apc) && opened == APC_COVER_OPENED)
		context[SCREENTIP_CONTEXT_LMB] = "插入电路板"

	else if(istype(held_item, /obj/item/electroadaptive_pseudocircuit) && opened == APC_COVER_OPENED)
		if (!has_electronics)
			context[SCREENTIP_CONTEXT_LMB] = "插入一个APC电路板"
		else if(!cell)
			context[SCREENTIP_CONTEXT_LMB] = "插入一个电池"

	else if(istype(held_item, /obj/item/wallframe/apc))
		context[SCREENTIP_CONTEXT_LMB] = "替换受损框架"

	return CONTEXTUAL_SCREENTIP_SET
