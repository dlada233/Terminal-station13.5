/obj/machinery/modular_computer/preset
	///List of programs the computer starts with, given on Initialize.
	var/list/datum/computer_file/starting_programs = list()

/obj/machinery/modular_computer/preset/Initialize(mapload)
	. = ..()
	if(!cpu)
		return

	for(var/programs in starting_programs)
		var/datum/computer_file/program_type = new programs
		cpu.store_file(program_type)

// ===== ENGINEERING CONSOLE =====
/obj/machinery/modular_computer/preset/engineering
	name = "工程控制台"
	desc = "A stationary computer. This one comes preloaded with engineering programs."
	starting_programs = list(
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/supermatter_monitor,
	)

// ===== RESEARCH CONSOLE =====
/obj/machinery/modular_computer/preset/research
	name = "科研主管控制台"
	desc = "A stationary computer. This one comes preloaded with research programs."
	starting_programs = list(
		/datum/computer_file/program/ntnetmonitor,
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/ai_restorer,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/scipaper_program,
	)

// ===== COMMAND CONSOLE =====
/obj/machinery/modular_computer/preset/command
	name = "指挥控制台"
	desc = "A stationary computer. This one comes preloaded with command programs."
	starting_programs = list(
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/card_mod,
	)

// ===== IDENTIFICATION CONSOLE =====
/obj/machinery/modular_computer/preset/id
	name = "身份识别控制台"
	desc = "一台固定式计算机.这台预装了身份修改程序."
	starting_programs = list(
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/card_mod,
		/datum/computer_file/program/job_management,
		/datum/computer_file/program/crew_manifest,
	)

/obj/machinery/modular_computer/preset/id/centcom
	desc = "A stationary computer. This one comes preloaded with CentCom identification modification programs."

/obj/machinery/modular_computer/preset/id/centcom/Initialize(mapload)
	. = ..()
	var/datum/computer_file/program/card_mod/card_mod_centcom = cpu.find_file_by_name("plexagonidwriter")
	card_mod_centcom.is_centcom = TRUE

// ===== CIVILIAN CONSOLE =====
/obj/machinery/modular_computer/preset/civilian
	name = "民用控制台"
	desc = "A stationary computer. This one comes preloaded with generic programs."
	starting_programs = list(
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/arcade,
	)

// curator
/obj/machinery/modular_computer/preset/curator
	name = "馆长控制台"
	desc = "一台固定式计算机。这台计算机预装了文学及艺术程序."
	starting_programs = list(
		/datum/computer_file/program/portrait_printer,
	)

// ===== CARGO CHAT CONSOLES =====
/obj/machinery/modular_computer/preset/cargochat
	name = "货仓聊天室控制台"
	desc = "A stationary computer. This one comes preloaded with a chatroom for your cargo requests."
	starting_programs = list(
		/datum/computer_file/program/chatclient,
	)

	///Used in Initialize to set the chat client name.
	var/console_department

/obj/machinery/modular_computer/preset/cargochat/Initialize(mapload)
	. = ..()
	var/datum/computer_file/program/chatclient/chatprogram = cpu.find_file_by_name("ntnrc_client")
	chatprogram.username = "[lowertext(console_department)]_department"
	cpu.active_program = chatprogram

/obj/machinery/modular_computer/preset/cargochat/service
	console_department = "服务部"

/obj/machinery/modular_computer/preset/cargochat/engineering
	console_department = "工程部"

/obj/machinery/modular_computer/preset/cargochat/science
	console_department = "科研部"

/obj/machinery/modular_computer/preset/cargochat/security
	console_department = "安保部"

/obj/machinery/modular_computer/preset/cargochat/medical
	console_department = "医疗部"


//ONE PER MAP PLEASE, IT MAKES A CARGOBUS FOR EACH ONE OF THESE
/obj/machinery/modular_computer/preset/cargochat/cargo
	console_department = "货仓"
	name = "部门聊天室控制台"
	desc = "A stationary computer. This one comes preloaded with a chatroom for incoming cargo requests. You may moderate it from this computer."

/obj/machinery/modular_computer/preset/cargochat/cargo/LateInitialize()
	. = ..()
	var/datum/computer_file/program/chatclient/chatprogram = cpu.find_file_by_name("ntnrc_client")
	chatprogram.username = "cargo_requests_operator"

	var/datum/ntnet_conversation/cargochat = chatprogram.create_new_channel("#cargobus", strong = TRUE)
	for(var/obj/machinery/modular_computer/preset/cargochat/cargochat_console as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/modular_computer/preset/cargochat))
		if(cargochat_console == src)
			continue
		var/datum/computer_file/program/chatclient/other_chatprograms = cargochat_console.cpu.find_file_by_name("ntnrc_client")
		other_chatprograms.active_channel = chatprogram.active_channel
		cargochat.add_client(other_chatprograms, silent = TRUE)
