/*
	The monitoring computer for the messaging server.
	Lets you read PDA and request console messages.
*/

#define LINKED_SERVER_NONRESPONSIVE  (!linkedServer || (linkedServer.machine_stat & (NOPOWER|BROKEN)))

#define MSG_MON_SCREEN_MAIN 0
#define MSG_MON_SCREEN_LOGS 1
#define MSG_MON_SCREEN_REQUEST_LOGS 2
#define MSG_MON_SCREEN_HACKED 3

/obj/machinery/computer/message_monitor
	name = "信息监控终端"
	desc = "用于监控船员PDA消息以及请求终端消息"
	icon_screen = "comm_logs"
	circuit = /obj/item/circuitboard/computer/message_monitor
	light_color = LIGHT_COLOR_GREEN
	/// Server linked to.
	var/obj/machinery/telecomms/message_server/linkedServer = null
	/// Sparks effect - For emag
	var/datum/effect_system/spark_spread/spark_system
	/// Computer properties.
	/// 0 = Main menu, 1 = Message Logs, 2 = Hacked screen, 3 = Custom Message
	var/screen = MSG_MON_SCREEN_MAIN
	/// The message that shows on the main menu.
	var/message = "系统气动完成，请选择一个选项."
	/// Error message to display in the interface.
	var/error_message = ""
	/// Notice message to display in the interface.
	var/notice_message = ""
	/// Success message to display in the interface.
	var/success_message = ""
	/// Decrypt password
	var/password = ""

/obj/machinery/computer/message_monitor/screwdriver_act(mob/living/user, obj/item/I)
	if(obj_flags & EMAGGED)
		//Stops people from just unscrewing the monitor and putting it back to get the console working again.
		to_chat(user, span_warning("表面太热了，难以触碰!"))
		return TRUE
	return ..()

/obj/machinery/computer/message_monitor/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	if(!isnull(linkedServer))
		obj_flags |= EMAGGED
		screen = MSG_MON_SCREEN_HACKED
		spark_system.set_up(5, 0, src)
		spark_system.start()
		var/obj/item/paper/monitorkey/monitor_key_paper = new(loc, linkedServer)
		// Will help make emagging the console not so easy to get away with.
		monitor_key_paper.add_raw_text("<br><br><font color='red'>£%@%(*$%&(£&?*(%&£/{}</font>")
		var/time = 100 * length(linkedServer.decryptkey)
		addtimer(CALLBACK(src, PROC_REF(unemag_console)), time)
		error_message = "%$&(£: Critical %$$@ 戳误 // !充启! <夹在呗用书入束出> - ?请dneg待!"
		linkedServer.toggled = FALSE
		return TRUE
	else
		to_chat(user, span_notice("无服务器出现错误."))
	return FALSE

/// Remove the emag effect from the console
/obj/machinery/computer/message_monitor/proc/unemag_console()
	screen = MSG_MON_SCREEN_MAIN
	linkedServer.toggled = TRUE
	error_message = ""
	obj_flags &= ~EMAGGED

/obj/machinery/computer/message_monitor/Initialize(mapload)
	..()
	spark_system = new
	GLOB.telecomms_list += src
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/message_monitor/post_machine_initialize()
	. = ..()
	//Is the server isn't linked to a server, and there's a server available, default it to the first one in the list.
	if(!linkedServer)
		for(var/obj/machinery/telecomms/message_server/message_server in GLOB.telecomms_list)
			linkedServer = message_server
			break

/obj/machinery/computer/message_monitor/Destroy()
	GLOB.telecomms_list -= src
	linkedServer = null
	return ..()

/obj/machinery/computer/message_monitor/ui_data(mob/user)
	var/list/data = list(
		"screen" = screen,
		"error_message" = error_message,
		"notice_message" = notice_message,
		"success_message" = success_message,
		"auth" = authenticated,
		"server_status" = !LINKED_SERVER_NONRESPONSIVE,
	)

	switch(screen)
		if(MSG_MON_SCREEN_MAIN)
			data["password"] = password
			data["status"] = linkedServer.on
			// Check is AI or cyborg malf
			var/mob/living/silicon/silicon_user = user
			data["is_malf"] = istype(silicon_user) && silicon_user.hack_software

		if(MSG_MON_SCREEN_LOGS)
			var/list/message_list = list()
			for(var/datum/data_tablet_msg/pda in linkedServer.pda_msgs)
				message_list += list(list("ref" = REF(pda), "sender" = pda.sender, "recipient" = pda.recipient, "message" = pda.message))
			data["messages"] = message_list
		if(MSG_MON_SCREEN_REQUEST_LOGS)
			var/list/request_list = list()
			for(var/datum/data_rc_msg/rc in linkedServer.rc_msgs)
				request_list += list(list("ref" = REF(rc), "message" = rc.message, "stamp" = rc.stamp, "id_auth" = rc.id_auth, "departament" = rc.sender_department))
			data["requests"] = request_list
	return data

/obj/machinery/computer/message_monitor/ui_act(action, params)
	. = ..()
	if(.)
		return .

	error_message = ""
	success_message = ""
	notice_message = ""

	switch(action)
		if("auth")
			var/authPass = params["auth_password"]

			if(authenticated)
				authenticated = FALSE
				return TRUE

			if(linkedServer.decryptkey != authPass)
				error_message = "警告: 解密密钥不正确!"
				return TRUE

			authenticated = TRUE
			success_message = "你成功登陆进去了!"

			return TRUE
		if("link_server")
			var/list/message_servers = list()
			for (var/obj/machinery/telecomms/message_server/message_server in GLOB.telecomms_list)
				message_servers += message_server

			if(length(message_servers) > 1)
				linkedServer = tgui_input_list(usr, "请选择一个服务器", "服务器选项", message_servers)
				if(linkedServer)
					notice_message = "注意: 服务器已选择."
				else if(length(message_servers) > 0)
					linkedServer = message_servers[1]
					notice_message = "注意: 监测到只有一个服务器 - 服务器已选择."
				else
					error_message = "警告: 未检测到服务器."
			screen = MSG_MON_SCREEN_MAIN
			return TRUE
		if("turn_server")
			if(LINKED_SERVER_NONRESPONSIVE)
				error_message = "警告: 未检测到服务器."
				return TRUE

			linkedServer.toggled = !linkedServer.toggled
			return TRUE
		if("view_message_logs")
			screen = MSG_MON_SCREEN_LOGS
			return
		if("view_request_logs")
			screen = MSG_MON_SCREEN_REQUEST_LOGS
			return TRUE
		if("clear_message_logs")
			linkedServer.pda_msgs = list()
			notice_message = "警告: 日志被清除."
			return TRUE
		if("clear_request_logs")
			linkedServer.rc_msgs = list()
			notice_message = "注意: 日志被清除."
			return TRUE
		if("set_key")
			var/dkey = tgui_input_text(usr, "请输入解密密钥", "通讯加密")
			if(dkey && dkey != "")
				if(linkedServer.decryptkey == dkey)
					var/newkey = tgui_input_text(usr, "请输入新密钥 (3 - 16字符)", "新密钥")
					if(length(newkey) <= 3)
						notice_message = "注意: 解密密钥太短!"
					else if(newkey && newkey != "")
						linkedServer.decryptkey = newkey
					notice_message = "注意: 解密密钥设置."
				else
					error_message = "警告: 解密密钥不正确!"
			return TRUE
		if("return_home")
			screen = MSG_MON_SCREEN_MAIN
			return TRUE
		if("delete_message")
			linkedServer.pda_msgs -= locate(params["ref"]) in linkedServer.pda_msgs
			success_message = "日志被删除!"
			return TRUE
		if("delete_request")
			linkedServer.rc_msgs -= locate(params["ref"]) in linkedServer.rc_msgs
			success_message = "日志被删除!"
			return TRUE
		if("connect_server")
			if(!linkedServer)
				for(var/obj/machinery/telecomms/message_server/S in GLOB.telecomms_list)
					linkedServer = S
					break
			return TRUE
		if("send_fake_message")
			var/sender = tgui_input_text(usr, "发送者的名字是?", "发送者")
			var/job = tgui_input_text(usr, "发送者的职业是?", "职业")

			var/recipient
			var/list/tablet_to_messenger = list()
			var/list/viewable_tablets = list()
			for (var/messenger_ref in GLOB.pda_messengers)
				var/datum/computer_file/program/messenger/message_app = GLOB.pda_messengers[messenger_ref]
				if(!message_app || message_app.invisible)
					continue
				if(!message_app.computer.saved_identification)
					continue
				viewable_tablets += message_app.computer
				tablet_to_messenger[message_app.computer] = message_app
			if(length(viewable_tablets) > 0)
				recipient = tgui_input_list(usr, "从列表中选择设备", "设备选择", viewable_tablets)
			else
				recipient = null

			var/message = tgui_input_text(usr, "请输入你的消息", "消息")
			if(isnull(sender) || sender == "")
				sender = "UNKNOWN"

			if(isnull(recipient))
				notice_message = "注意: 未选择收件人!"
				return attack_hand(usr)
			if(isnull(message) || message == "")
				notice_message = "注意: 未输入消息!"
				return attack_hand(usr)

			var/datum/signal/subspace/messaging/tablet_message/signal = new(src, list(
				"fakename" = "[sender]",
				"fakejob" = "[job]",
				"message" = message,
				"targets" = list(tablet_to_messenger[recipient]),
			))
			// This will log the signal and transmit it to the target
			linkedServer.receive_information(signal, null)
			usr.log_message("(Tablet: [name] | [usr.real_name]) sent \"[message]\" to [signal.format_target()]", LOG_PDA)
			return TRUE
		// Malfunction AI and cyborgs can hack console. This will authenticate the console, but you need to wait password selection
		if("hack")
			var/time = 10 SECONDS * length(linkedServer.decryptkey)
			addtimer(CALLBACK(src, PROC_REF(unemag_console)), time)
			screen = MSG_MON_SCREEN_HACKED
			error_message = "%$&(£: Critical %$$@ 戳误 // !充启! <夹在呗用书入束出> - ?请dneg待!"
			linkedServer.toggled = FALSE
			authenticated = TRUE
			return TRUE
	return TRUE

/obj/machinery/computer/message_monitor/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "MessageMonitor", name)
		ui.open()

/obj/machinery/computer/message_monitor/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/chat)

#undef MSG_MON_SCREEN_MAIN
#undef MSG_MON_SCREEN_LOGS
#undef MSG_MON_SCREEN_REQUEST_LOGS
#undef MSG_MON_SCREEN_HACKED
#undef LINKED_SERVER_NONRESPONSIVE

/// Monitor decryption key paper

/obj/item/paper/monitorkey
	name = "监控解密密钥"

/obj/item/paper/monitorkey/Initialize(mapload, obj/machinery/telecomms/message_server/server)
	. = ..()
	if (server)
		print(server)
		return INITIALIZE_HINT_NORMAL
	return INITIALIZE_HINT_LATELOAD

/**
 * Handles printing the monitor key for a given server onto this piece of paper.
 */
/obj/item/paper/monitorkey/proc/print(obj/machinery/telecomms/message_server/server)
	add_raw_text("<center><h2>每日密钥重置</h2></center><br>新的消息密钥为<b>[server.decryptkey]</b>.<br>请严加保密并远离小丑.<br>如果情况必要, 可以更改密码确保安全.")
	add_overlay("paper_words")
	update_appearance()

/obj/item/paper/monitorkey/LateInitialize()
	for (var/obj/machinery/telecomms/message_server/preset/server in GLOB.telecomms_list)
		if (server.decryptkey)
			print(server)
			break
