/obj/machinery/computer/launchpad
	name = "发射台控制终端"
	desc = "用于将物体传送到发射台"
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	circuit = /obj/item/circuitboard/computer/launchpad_console

	var/selected_id
	var/list/obj/machinery/launchpad/launchpads
	var/maximum_pads = 4

/obj/machinery/computer/launchpad/Initialize(mapload)
	launchpads = list()
	. = ..()
	AddComponent(/datum/component/usb_port, list(
		/obj/item/circuit_component/bluespace_launchpad/console,
	))

/obj/item/circuit_component/bluespace_launchpad/console
	display_name = "蓝空发射台控制终端"
	desc = "能把任意物体传送到范围内任何地方，不使用GPS坐标，而是使用发射台本身的偏移量，其传送范围取决于自身组件."

	var/datum/port/input/launchpad_id

	var/obj/machinery/computer/launchpad/attached_console

/obj/item/circuit_component/bluespace_launchpad/console/populate_ports()
	launchpad_id = add_input_port("Launchpad ID", PORT_TYPE_NUMBER, trigger = null, default = 1)
	..()

/obj/item/circuit_component/bluespace_launchpad/console/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/computer/launchpad))
		attached_console = shell

/obj/item/circuit_component/bluespace_launchpad/console/unregister_usb_parent(atom/movable/shell)
	attached_console = null
	return ..()

/obj/item/circuit_component/bluespace_launchpad/console/input_received(datum/port/input/port)
	if(!attached_console || length(attached_console.launchpads) == 0)
		why_fail.set_output("无发射台连接!")
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	if(!launchpad_id.value)
		return

	attached_launchpad = KEYBYINDEX(attached_console.launchpads, launchpad_id.value)

	if(isnull(attached_launchpad))
		why_fail.set_output("选择了不可用的发射台!")
		on_fail.set_output(COMPONENT_SIGNAL)
		return
	..()

/obj/machinery/computer/launchpad/attack_paw(mob/user, list/modifiers)
	to_chat(user, span_warning("你太原始了，不会用这台电脑!"))
	return

/obj/machinery/computer/launchpad/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_MULTITOOL)
		if(!multitool_check_buffer(user, W))
			return
		var/obj/item/multitool/M = W
		if(M.buffer && istype(M.buffer, /obj/machinery/launchpad))
			if(LAZYLEN(launchpads) < maximum_pads)
				launchpads |= M.buffer
				M.set_buffer(null)
				to_chat(user, span_notice("你上传了[W.name]缓冲区内数据."))
			else
				to_chat(user, span_warning("[src]无法处理更多的连接了!"))
	else
		return ..()

/obj/machinery/computer/launchpad/proc/pad_exists(number)
	var/obj/machinery/launchpad/pad = launchpads[number]
	if(QDELETED(pad))
		return FALSE
	return TRUE

/obj/machinery/computer/launchpad/proc/get_pad(number)
	var/obj/machinery/launchpad/pad = launchpads[number]
	return pad

/obj/machinery/computer/launchpad/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LaunchpadConsole", name)
		ui.open()

/obj/machinery/computer/launchpad/ui_data(mob/user)
	var/list/data = list()
	var/list/pad_list = list()
	for(var/i in 1 to LAZYLEN(launchpads))
		if(pad_exists(i))
			var/obj/machinery/launchpad/pad = get_pad(i)
			var/list/this_pad = list()
			this_pad["name"] = pad.display_name
			this_pad["id"] = i
			if(pad.machine_stat & NOPOWER)
				this_pad["inactive"] = TRUE
			pad_list += list(this_pad)
		else
			launchpads -= get_pad(i)
	data["launchpads"] = pad_list
	data["selected_id"] = selected_id
	if(selected_id)
		var/obj/machinery/launchpad/current_pad = launchpads[selected_id]
		data["x"] = current_pad.x_offset
		data["y"] = current_pad.y_offset
		data["pad_name"] = current_pad.display_name
		data["range"] = current_pad.range
		data["selected_pad"] = current_pad
		if(QDELETED(current_pad) || (current_pad.machine_stat & NOPOWER))
			data["pad_active"] = FALSE
			return data
		data["pad_active"] = TRUE

	return data

/obj/machinery/computer/launchpad/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/obj/machinery/launchpad/current_pad = launchpads[selected_id]
	switch(action)
		if("select_pad")
			selected_id = text2num(params["id"])
			. = TRUE
		if("set_pos")
			var/new_x = text2num(params["x"])
			var/new_y = text2num(params["y"])
			current_pad.set_offset(new_x, new_y)
			. = TRUE
		if("move_pos")
			var/plus_x = text2num(params["x"])
			var/plus_y = text2num(params["y"])
			if(plus_x || plus_y)
				current_pad.set_offset(
					x = current_pad.x_offset + plus_x,
					y = current_pad.y_offset + plus_y,
				)
			else
				current_pad.set_offset(
					x = 0,
					y = 0,
				)
			. = TRUE
		if("rename")
			. = TRUE
			var/new_name = params["name"]
			if(!new_name)
				return
			current_pad.display_name = new_name
		if("remove")
			if(usr && tgui_alert(usr, "你确定?", "发射台断连", list("确定", "中止")) == "确定")
				launchpads -= current_pad
				selected_id = null
			. = TRUE
		if("launch")
			var/checks = current_pad.teleport_checks()
			if(isnull(checks))
				current_pad.doteleport(usr, TRUE)
			else
				to_chat(usr, span_warning(checks))
			. = TRUE

		if("pull")
			var/checks = current_pad.teleport_checks()
			if(isnull(checks))
				current_pad.doteleport(usr, FALSE)
			else
				to_chat(usr, span_warning(checks))

			. = TRUE
	. = TRUE
