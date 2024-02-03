//attack with an item - open/close cover, insert cell, or (un)lock interface
/obj/machinery/power/apc/crowbar_act(mob/user, obj/item/crowbar)
	. = TRUE

	//Prying off broken cover
	if((opened == APC_COVER_CLOSED || opened == APC_COVER_OPENED) && (machine_stat & BROKEN))
		crowbar.play_tool_sound(src)
		balloon_alert(user, "撬开中...")
		if(!crowbar.use_tool(src, user, 5 SECONDS))
			return
		opened = APC_COVER_REMOVED
		balloon_alert(user, "面板已移除")
		update_appearance()
		return

	//Opening and closing cover
	if((!opened && opened != APC_COVER_REMOVED) && !(machine_stat & BROKEN))
		if(coverlocked && !(machine_stat & MAINT)) // locked...
			balloon_alert(user, "面板已经上锁!")
			return
		else if(panel_open)
			balloon_alert(user, "电线阻止了开启!")
			return
		else
			opened = APC_COVER_OPENED
			update_appearance()
			return

	if((opened && has_electronics == APC_ELECTRONICS_SECURED) && !(machine_stat & BROKEN))
		opened = APC_COVER_CLOSED
		coverlocked = TRUE //closing cover relocks it
		balloon_alert(user, "面板上锁")
		update_appearance()
		return

	//Taking out the electronics
	if(!opened || has_electronics != APC_ELECTRONICS_INSTALLED)
		return
	if(terminal)
		balloon_alert(user, "先断开电线!")
		return
	crowbar.play_tool_sound(src)
	if(!crowbar.use_tool(src, user, 50))
		return
	if(has_electronics != APC_ELECTRONICS_INSTALLED)
		return
	has_electronics = APC_ELECTRONICS_MISSING
	if(machine_stat & BROKEN)
		user.visible_message(span_notice("[user.name]弄坏了[name]里面的电力控制电路板!"), \
			span_hear("你听到一声爆裂声."))
		balloon_alert(user, "烧焦的电路板断裂")
		return
	else if(obj_flags & EMAGGED)
		obj_flags &= ~EMAGGED
		user.visible_message(span_notice("[user.name]从[name]中丢弃了一个被EMAG的电路板!"))
		balloon_alert(user, "EMAG电路板被丢弃")
		return
	else if(malfhack)
		user.visible_message(span_notice("[user.name]从[name]中丢弃了一个被重编写的奇怪电路板!"))
		balloon_alert(user, "重编写电路板被丢弃")
		malfai = null
		malfhack = 0
		return
	user.visible_message(span_notice("[user.name]从[name]中移除电力控制电路板!"))
	balloon_alert(user, "移除电路板")
	new /obj/item/electronics/apc(loc)
	return

/obj/machinery/power/apc/screwdriver_act(mob/living/user, obj/item/W)
	if(..())
		return TRUE
	. = TRUE

	if(!opened)
		if(obj_flags & EMAGGED)
			balloon_alert(user, "面板已破损!")
			return
		toggle_panel_open()
		balloon_alert(user, "电线[panel_open ? "暴露" : "隐藏"]")
		update_appearance()
		return

	if(cell)
		user.visible_message(span_notice("[user]从[src]中移除[cell]!"))
		balloon_alert(user, "电池已移除")
		var/turf/user_turf = get_turf(user)
		cell.forceMove(user_turf)
		cell.update_appearance()
		cell = null
		charging = APC_NOT_CHARGING
		update_appearance()
		return

	switch (has_electronics)
		if(APC_ELECTRONICS_INSTALLED)
			has_electronics = APC_ELECTRONICS_SECURED
			set_machine_stat(machine_stat & ~MAINT)
			W.play_tool_sound(src)
			balloon_alert(user, "电路板已固定")
		if(APC_ELECTRONICS_SECURED)
			has_electronics = APC_ELECTRONICS_INSTALLED
			set_machine_stat(machine_stat | MAINT)
			W.play_tool_sound(src)
			balloon_alert(user, "电路板已解锁")
		else
			balloon_alert(user, "无电路板可固定!")
			return
	update_appearance()

/obj/machinery/power/apc/wirecutter_act(mob/living/user, obj/item/W)
	. = ..()
	if(terminal && opened)
		terminal.dismantle(user, W)
		return TRUE

/obj/machinery/power/apc/welder_act(mob/living/user, obj/item/welder)
	. = ..()

	//repairing the cover
	if((atom_integrity < max_integrity) && has_electronics)
		if(opened == APC_COVER_REMOVED)
			balloon_alert(user, "没有面板可修补!")
			return
		if (machine_stat & BROKEN)
			balloon_alert(user, "损害太严重，无法修补!")
			return
		if(!welder.tool_start_check(user, amount=1))
			return
		balloon_alert(user, "修补中...")
		if(welder.use_tool(src, user, 4 SECONDS, volume = 50))
			update_integrity(min(atom_integrity += 50,max_integrity))
			balloon_alert(user, "已修补")
		return ITEM_INTERACT_SUCCESS

	//disassembling the frame
	if(!opened || has_electronics || terminal)
		return
	if(!welder.tool_start_check(user, amount=1))
		return
	user.visible_message(span_notice("[user.name]焊接[src]."), \
						span_hear("你听到焊接声."))
	balloon_alert(user, "焊接APC框架")
	if(!welder.use_tool(src, user, 50, volume=50))
		return
	if((machine_stat & BROKEN) || opened == APC_COVER_REMOVED)
		new /obj/item/stack/sheet/iron(loc)
		user.visible_message(span_notice("[user.name]用[welder]切割[src]."))
		balloon_alert(user, "拆卸损坏的框架")
	else
		new /obj/item/wallframe/apc(loc)
		user.visible_message(span_notice("[user.name]用[welder]把[src]从墙上切割下来."))
		balloon_alert(user, "从墙上切割框架")
	qdel(src)
	return TRUE

/obj/machinery/power/apc/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!(the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return FALSE

	if(!has_electronics)
		if(machine_stat & BROKEN)
			balloon_alert(user, "框架受损过于严重!")
			return FALSE
		return list("delay" = 2 SECONDS, "cost" = 1)

	if(!cell)
		if(machine_stat & MAINT)
			balloon_alert(user, "没有可承载电池的电路板!")
			return FALSE
		return list("delay" = 5 SECONDS, "cost" = 10)

	balloon_alert(user, "已有电路板和电池!")
	return FALSE

/obj/machinery/power/apc/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	if(!(the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS) || rcd_data["[RCD_DESIGN_MODE]"] != RCD_WALLFRAME)
		return FALSE

	if(!has_electronics)
		if(machine_stat & BROKEN)
			balloon_alert(user, "框架受损太过严重!")
			return
		balloon_alert(user, "控制电路板已安装")
		has_electronics = TRUE
		locked = TRUE
		return TRUE

	if(!cell)
		if(machine_stat & MAINT)
			balloon_alert(user, "没有可以承载电池的电路板!")
			return FALSE
		var/obj/item/stock_parts/cell/crap/empty/C = new(src)
		C.forceMove(src)
		cell = C
		chargecount = 0
		balloon_alert(user, "电池已安装")
		update_appearance()
		return TRUE

	balloon_alert(user, "已有电路板和电池!")
	return FALSE

/obj/machinery/power/apc/emag_act(mob/user, obj/item/card/emag/emag_card)
	if((obj_flags & EMAGGED) || malfhack)
		return FALSE

	if(opened)
		balloon_alert(user, "先关上面板盖!")
		return FALSE
	else if(panel_open)
		balloon_alert(user, "先关上面板!")
		return FALSE
	else if(machine_stat & (BROKEN|MAINT))
		balloon_alert(user, "无事发生!")
		return FALSE
	else
		flick("apc-spark", src)
		playsound(src, SFX_SPARKS, 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		obj_flags |= EMAGGED
		locked = FALSE
		balloon_alert(user, "面板受损")
		update_appearance()
		flicker_hacked_icon()
		return TRUE

// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		if(cell)
			cell.emp_act(severity)
		if(occupier)
			occupier.emp_act(severity)
	if(. & EMP_PROTECT_SELF)
		return
	lighting = APC_CHANNEL_OFF
	equipment = APC_CHANNEL_OFF
	environ = APC_CHANNEL_OFF
	update_appearance()
	update()
	addtimer(CALLBACK(src, PROC_REF(reset), APC_RESET_EMP), 600)

/obj/machinery/power/apc/proc/togglelock(mob/living/user)
	if(obj_flags & EMAGGED)
		balloon_alert(user, "面板破损!")
	else if(opened)
		balloon_alert(user, "先关上面板盖!")
	else if(panel_open)
		balloon_alert(user, "先关上面板!")
	else if(machine_stat & (BROKEN|MAINT))
		balloon_alert(user, "无事发生!")
	else
		if(allowed(usr) && !wires.is_cut(WIRE_IDSCAN) && !malfhack && !remote_control_user)
			locked = !locked
			balloon_alert(user, locked ? "已锁定" : "未锁定")
			update_appearance()
		else
			balloon_alert(user, "拒绝访问!")
