/obj/machinery/camera/welder_act(mob/living/user, obj/item/tool)
	switch(camera_construction_state)
		if(CAMERA_STATE_WRENCHED, CAMERA_STATE_WELDED)
			if(!tool.tool_start_check(user, amount = 1))
				return ITEM_INTERACT_BLOCKING
			user.balloon_alert_to_viewers("焊[camera_construction_state == CAMERA_STATE_WELDED ? "开" : "接"]...")
			audible_message(span_hear("你听到焊接声."))
			if(!tool.use_tool(src, user, 2 SECONDS, volume = 50))
				user.balloon_alert_to_viewers("焊[camera_construction_state == CAMERA_STATE_WELDED ? "开" : "接"]被停止!")
				return
			camera_construction_state = ((camera_construction_state == CAMERA_STATE_WELDED) ? CAMERA_STATE_WRENCHED : CAMERA_STATE_WELDED)
			set_anchored(camera_construction_state == CAMERA_STATE_WELDED)
			user.balloon_alert_to_viewers(camera_construction_state == CAMERA_STATE_WELDED ? "已焊接" : "已焊开")
			return ITEM_INTERACT_SUCCESS
		if(CAMERA_STATE_FINISHED)
			if(!panel_open)
				return ITEM_INTERACT_BLOCKING
			if(!tool.tool_start_check(user, amount=2))
				return ITEM_INTERACT_BLOCKING
			audible_message(span_hear("你听到焊接声."))
			if(!tool.use_tool(src, user, 100, volume=50))
				return ITEM_INTERACT_BLOCKING
			user.visible_message(span_warning("[user]焊开[src], 它的框架现在只是拴在墙上."),
				span_warning("你焊开[src], 它的框架现在只是拴在墙上"))
			deconstruct(TRUE)
			return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/camera/screwdriver_act(mob/user, obj/item/tool)
	switch(camera_construction_state)
		if(CAMERA_STATE_WIRED)
			tool.play_tool_sound(src)
			var/input = tgui_input_text(user, "你希望将该摄像头连接到哪个网络? 用逗号分隔网络名. 不要用空格!\n如: SS13,Security,Secret", "设置网络", "SS13")
			if(isnull(input))
				return ITEM_INTERACT_BLOCKING
			var/list/tempnetwork = splittext(input, ",")
			if(!length(tempnetwork))
				to_chat(user, span_warning("找不到网络, 请挂机后再拨!"))
				return ITEM_INTERACT_BLOCKING
			for(var/i in tempnetwork)
				tempnetwork -= i
				tempnetwork += LOWER_TEXT(i)
			camera_construction_state = CAMERA_STATE_FINISHED
			toggle_cam(user, displaymessage = FALSE)
			network = tempnetwork
			return ITEM_INTERACT_SUCCESS
		if(CAMERA_STATE_FINISHED)
			toggle_panel_open()
			to_chat(user, span_notice("你[panel_open ? "打开" : "关上"]了摄像头的盖板."))
			tool.play_tool_sound(src)
			update_appearance()
			return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/camera/wirecutter_act(mob/user, obj/item/tool)
	switch(camera_construction_state)
		if(CAMERA_STATE_WIRED)
			new /obj/item/stack/cable_coil(drop_location(), 2)
			tool.play_tool_sound(src)
			to_chat(user, span_notice("你把电路里的电线剪断了."))
			camera_construction_state = CAMERA_STATE_WELDED
			return ITEM_INTERACT_SUCCESS
		if(CAMERA_STATE_FINISHED)
			if(!panel_open)
				return ITEM_INTERACT_BLOCKING
			toggle_cam(user, 1)
			atom_integrity = max_integrity //this is a pretty simplistic way to heal the camera, but there's no reason for this to be complex.
			set_machine_stat(machine_stat & ~BROKEN)
			tool.play_tool_sound(src)
			return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/camera/wrench_act(mob/user, obj/item/tool)
	if(camera_construction_state == CAMERA_STATE_WRENCHED)
		tool.play_tool_sound(src)
		to_chat(user, span_notice("你拆下[src]."))
		deconstruct(TRUE)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/camera/crowbar_act(mob/living/user, obj/item/tool)
	if(camera_construction_state == CAMERA_STATE_FINISHED)
		if(!panel_open)
			return ITEM_INTERACT_BLOCKING
		var/list/droppable_parts = list()
		if(xray_module)
			droppable_parts += xray_module
		if(emp_module)
			droppable_parts += emp_module
		if(proximity_monitor)
			droppable_parts += proximity_monitor
		if(!length(droppable_parts))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/choice = tgui_input_list(user, "选择移除部分", "部分移除", sort_names(droppable_parts))
		if(isnull(choice))
			return ITEM_INTERACT_BLOCKING
		if(!user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
			return ITEM_INTERACT_BLOCKING
		to_chat(user, span_notice("你从[src]移除了[choice]."))
		if(choice == xray_module)
			drop_upgrade(xray_module)
			removeXRay()
		if(choice == emp_module)
			drop_upgrade(emp_module)
			removeEmpProof()
		if(choice == proximity_monitor)
			drop_upgrade(proximity_monitor)
			removeMotion()
		tool.play_tool_sound(src)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/camera/multitool_act(mob/living/user, obj/item/tool)
	if(camera_construction_state == CAMERA_STATE_FINISHED)
		if(!panel_open)
			return ITEM_INTERACT_BLOCKING
		setViewRange((view_range == initial(view_range)) ? short_range : initial(view_range))
		to_chat(user, span_notice("你[(view_range == initial(view_range)) ? "修复了" : "弄乱了"]摄像头的焦点."))
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/camera/attackby(obj/item/attacking_item, mob/living/user, params)
	if(camera_construction_state != CAMERA_STATE_FINISHED || panel_open)
		if(attacking_item.tool_behaviour == TOOL_ANALYZER)
			if(!isXRay(TRUE)) //don't reveal it was already upgraded if was done via MALF AI Upgrade Camera Network ability
				if(!user.temporarilyRemoveItemFromInventory(attacking_item))
					return
				upgradeXRay(FALSE, TRUE)
				to_chat(user, span_notice("你将[attacking_item]连接到[name]的内部电路上."))
				qdel(attacking_item)
			else
				to_chat(user, span_warning("[src]已经升级过该项了!"))
			return
		else if(istype(attacking_item, /obj/item/stack/sheet/mineral/plasma))
			if(!isEmpProof(TRUE)) //don't reveal it was already upgraded if was done via MALF AI Upgrade Camera Network ability
				if(attacking_item.use_tool(src, user, 0, amount=1))
					upgradeEmpProof(FALSE, TRUE)
					to_chat(user, span_notice("你将[attacking_item]连接到[name]的内部电路上."))
			else
				to_chat(user, span_warning("[src]已经升级过该项了!"))
			return
		else if(isprox(attacking_item))
			if(!isMotion())
				if(!user.temporarilyRemoveItemFromInventory(attacking_item))
					return
				upgradeMotion()
				to_chat(user, span_notice("你将[attacking_item]连接到[name]的内部电路上."))
				qdel(attacking_item)
			else
				to_chat(user, span_warning("[src]已经升级过该项了!"))
			return
	switch(camera_construction_state)
		if(CAMERA_STATE_WELDED)
			if(istype(attacking_item, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/attacking_cable = attacking_item
				if(attacking_cable.use(2))
					to_chat(user, span_notice("你添加电线到[src]."))
					camera_construction_state = CAMERA_STATE_WIRED
				else
					to_chat(user, span_warning("你需要2段电缆连接摄像头!"))
				return
		if(CAMERA_STATE_FINISHED)
			if(istype(attacking_item, /obj/item/modular_computer))
				var/itemname = ""
				var/info = ""

				var/obj/item/modular_computer/computer = attacking_item
				for(var/datum/computer_file/program/notepad/notepad_app in computer.stored_files)
					info = notepad_app.written_note
					break

				if(!info)
					return

				itemname = computer.name
				itemname = sanitize(itemname)
				info = sanitize(info)
				to_chat(user, span_notice("你将[itemname]举到镜头前..."))
				user.log_talk(itemname, LOG_GAME, log_globally=TRUE, tag="按至镜头")
				user.changeNext_move(CLICK_CD_MELEE)

				for(var/mob/potential_viewer as anything in GLOB.player_list)
					if(isAI(potential_viewer))
						var/mob/living/silicon/ai/ai = potential_viewer
						if(ai.control_disabled || (ai.stat == DEAD))
							continue

						ai.log_talk(itemname, LOG_VICTIM, tag="按至镜头来自[key_name(user)]", log_globally=FALSE)
						ai.last_tablet_note_seen = "<HTML><HEAD><TITLE>[itemname]</TITLE></HEAD><BODY><TT>[info]</TT></BODY></HTML>"

						if(user.name == "Unknown")
							to_chat(ai, "[span_name(user)]将<a href='?_src_=usr;show_tablet=1;'>[itemname]</a>举到你其中一台摄像头前...")
						else
							to_chat(ai, "<b><a href='?src=[REF(ai)];track=[html_encode(user.name)]'>[user]</a></b>将<a href='?_src_=usr;last_shown_paper=1;'>[itemname]</a>举到你其中一台摄像头前...")
						continue

					if (potential_viewer.client?.eye == src)
						to_chat(potential_viewer, "[span_name("[user]")]将[itemname]举到你其中一台摄像头前...")
						potential_viewer.log_talk(itemname, LOG_VICTIM, tag="按至摄像头来自[key_name(user)]", log_globally=FALSE)
						potential_viewer << browse("<HTML><HEAD><TITLE>[itemname]</TITLE></HEAD><BODY><TT>[info]</TT></BODY></HTML>", "window=[itemname]")
				return

			if(istype(attacking_item, /obj/item/paper))
				// Grab the paper, sanitise the name as we're about to just throw it into chat wrapped in HTML tags.
				var/obj/item/paper/paper = attacking_item

				// Make a complete copy of the paper, store a ref to it locally on the camera.
				last_shown_paper = paper.copy(paper.type, null)

				// Then sanitise the name because we're putting it directly in chat later.
				var/item_name = sanitize(last_shown_paper.name)

				// Start the process of holding it up to the camera.
				to_chat(user, span_notice("你将[item_name]举到镜头前..."))
				user.log_talk(item_name, LOG_GAME, log_globally=TRUE, tag="按至摄像头")
				user.changeNext_move(CLICK_CD_MELEE)

				// And make a weakref we can throw around to all potential viewers.
				last_shown_paper.camera_holder = WEAKREF(src)

				// Iterate over all living mobs and check if anyone is elibile to view the paper.
				// This is backwards, but cameras don't store a list of people that are looking through them,
				// and we'll have to iterate this list anyway so we can use it to pull out AIs too.
				for(var/mob/potential_viewer in GLOB.player_list)
					// All AIs view through cameras, so we need to check them regardless.
					if(isAI(potential_viewer))
						var/mob/living/silicon/ai/ai = potential_viewer
						if(ai.control_disabled || (ai.stat == DEAD))
							continue

						ai.log_talk(item_name, LOG_VICTIM, tag="按至摄像头来自[key_name(user)]", log_globally=FALSE)
						log_paper("[key_name(user)]将[last_shown_paper]举到了[src]前, 需要[key_name(ai)]来阅读它.")

						if(user.name == "Unknown")
							to_chat(ai, "[span_name(user.name)]将<a href='?_src_=usr;show_paper_note=[REF(last_shown_paper)];'>[item_name]</a>举到你其中一台摄像头前...")
						else
							to_chat(ai, "<b><a href='?src=[REF(ai)];track=[html_encode(user.name)]'>[user]</a></b>将<a href='?_src_=usr;show_paper_note=[REF(last_shown_paper)];'>[item_name]</a>举到你其中一台摄像头前...")
						continue

					// If it's not an AI, eye if the client's eye is set to the camera. I wonder if this even works anymore with tgui camera apps and stuff?
					if (potential_viewer.client?.eye == src)
						log_paper("[key_name(user)]将[last_shown_paper]举到[src]前, [key_name(potential_viewer)]可以读一下.")
						potential_viewer.log_talk(item_name, LOG_VICTIM, tag="按至摄像头来自[key_name(user)]", log_globally=FALSE)
						to_chat(potential_viewer, "[span_name(user)] holds <a href='?_src_=usr;show_paper_note=[REF(last_shown_paper)];'>将[item_name]</a>举到你的摄像头前...")
				return

	return ..()
