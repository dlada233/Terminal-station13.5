#define MAIN_VIEW 0
#define SERVER_VIEW 1
#define MAX_NETWORK_ID_LENGTH 15

/obj/machinery/computer/telecomms/server
	name = "电信服务器监控终端"
	icon_screen = "comm_logs"
	desc = "可以访问其下的电信网络内所有的细节和记录."

	/// Current screen the user is viewing
	var/screen = MAIN_VIEW
	/// the servers located by the computer to be in-network
	var/list/servers = list()
	/// the currently selected server
	var/obj/machinery/telecomms/server/SelectedServer
	/// Network name to probe
	var/network = ""
	/// Error message to show
	var/error_message = ""
	/// Can the monitor translate languages?
	var/universal_translate = FALSE
	/// Access required to delete messages
	req_access = list(ACCESS_TCOMMS)
	circuit = /obj/item/circuitboard/computer/comm_server

/obj/machinery/computer/telecomms/server/ui_data(mob/user)
	var/list/data = list(
		"screen" = screen,
		"network" = network,
		"error" = error_message
	)

	switch(screen)
		if(MAIN_VIEW)
			// If there are servers in the buffer, send them
			var/list/found_servers = list()
			for (var/obj/machinery/telecomms/server/server in servers)
				found_servers += list(list("ref"=REF(server), "name"=server.name, "id"=server.id))
			data["servers"] = found_servers
		if(SERVER_VIEW)
			// Send selected server data
			var/list/server_out = list()
			server_out["name"] = SelectedServer.name
			server_out["traffic"] = SelectedServer.total_traffic
			// Get the messages on this server
			var/list/packets = list()
			for(var/datum/comm_log_entry/packet in SelectedServer.log_entries)
				var/list/packet_out = list()

				packet_out["name"] = packet.name

				var/datum/language/language = packet.parameters["language"]
				var/datum/language/language_instance = GLOB.language_datum_instances[language]
				packet_out["language"] = language_instance.name
				var/message_out = ""
				var/message_in = packet.parameters["message"]
				if(universal_translate || user.has_language(language))
					// Known language or translator, show plain text
					message_out = "\"[message_in]\""
				else if(!user.has_language(language))
					// Language unknown: scramble
					message_out = "\"[language_instance.scramble(message_in)]\""
				else
					message_out = "(Unintelligible)"
				packet_out["message"] = message_out

				var/mob/mobtype = packet.parameters["mobtype"]
				var/race = "Unidentifiable"
				if(ispath(mobtype, /mob/living/carbon/human) || ispath(mobtype, /mob/living/brain))
					race = "Humanoid"

				// NT knows a lot about slimes, but not aliens. Can identify slimes
				else if(ispath(mobtype, /mob/living/basic/slime))
					race = "Slime"

				// sometimes M gets deleted prematurely for AIs... just check the job
				else if(ispath(mobtype, /mob/living/silicon) || packet.parameters["job"] == JOB_AI)
					race = "Artificial Life"

				else if(isobj(mobtype))
					race = "Machinery"

				else if(ispath(mobtype, /mob/living/simple_animal))
					race = "Domestic Animal"

				packet_out["race"] = race
				packet_out["source"] = packet.parameters["name"]
				packet_out["job"] = packet.parameters["job"]
				packet_out["type"] = packet.input_type
				packet_out["ref"] = REF(packet)

				packets += list(packet_out)
			server_out["packets"] = packets
			data["server"] = server_out
	return data


/obj/machinery/computer/telecomms/server/ui_act(action, params)
	. = ..()
	if(.)
		return

	error_message = ""

	. = TRUE
	switch(action)
		if("scan_network")
			// Scan for a network
			var/new_network = params["network_id"]

			if(length(new_network) > MAX_NETWORK_ID_LENGTH)
				error_message = "操作失败: 网络ID过长."
				return

			if(servers.len > 0)
				error_message = "操作失败: 缓冲区已填入，请清空缓冲区."
				return

			network = new_network

			for(var/obj/machinery/telecomms/server/server in urange(25, src))
				if(server.network == network)
					servers.Add(server)
			if(servers.len == 0)
				error_message = "操作失败: 无法在网络[network]中定位任何服务器."
				return
			return
		if("clear_buffer")
			servers = list()
			network = ""
			return
		if("view_server")
			SelectedServer = locate(params["server"])
			if(!SelectedServer)
				error_message = "操作失败: 无法定位到服务器."
				return
			screen = SERVER_VIEW
			return
		if("return_home")
			SelectedServer = null
			screen = MAIN_VIEW
			return
		if("delete_packet")
			if(!SelectedServer)
				return
			// Delete a packet from server logs
			var/datum/comm_log_entry/packet = locate(params["ref"])
			if(!(packet in SelectedServer.log_entries))
				error_message = "操作失败: 未找到数据包."
				return
			if(!src.allowed(usr) && !(obj_flags & EMAGGED))
				error_message = "操作失败: 访问被拒绝."
				return
			SelectedServer.log_entries.Remove(packet)
			error_message = "成功删除 [packet.name]."
			qdel(packet)
			return
	return FALSE

/obj/machinery/computer/telecomms/server/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ServerMonitor", name)
		ui.open()

#undef MAX_NETWORK_ID_LENGTH
#undef MAIN_VIEW
#undef SERVER_VIEW
