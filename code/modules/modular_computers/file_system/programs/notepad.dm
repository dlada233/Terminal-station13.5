/datum/computer_file/program/notepad
	filename = "notepad"
	filedesc = "记事本"
	downloader_category = PROGRAM_CATEGORY_DEVICE
	program_open_overlay = "generic"
	extended_desc = "摘记任何你在空间站上的想法."
	size = 2
	tgui_id = "NtosNotepad"
	program_icon = "book"
	can_run_on_flags = PROGRAM_ALL
	circuit_comp_type = /obj/item/circuit_component/mod_program/notepad

	var/written_note = "祝贺您的站点升级并体验全新的NtOS & Thinktronic的联合协作技术, \
		为您带来自2467年以来最好的电子和软件解决方案!\n\
		为了方便您导航，我们提供了以下术语定义:\n\
		Fore - 站体前端\n\
		Aft - 站体后端\n\
		Port - 站体左侧\n\
		Starboard - 站体右侧\n\
		Quarter - 站尾两测\n\
		Bow - 站头两侧"

/datum/computer_file/program/notepad/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("UpdateNote")
			written_note = params["newnote"]
			return TRUE

/datum/computer_file/program/notepad/ui_data(mob/user)
	var/list/data = list()

	data["note"] = written_note

	return data

/obj/item/circuit_component/mod_program/notepad
	associated_program = /datum/computer_file/program/notepad
	///When the input is received, the written note will be set to its value.
	var/datum/port/input/set_text
	///The written note output, sent everytime notes are updated.
	var/datum/port/output/updated_text
	///Pinged whenever the text is updated
	var/datum/port/output/updated

/obj/item/circuit_component/mod_program/notepad/populate_ports()
	. = ..()
	set_text = add_input_port("Set Notes", PORT_TYPE_STRING)
	updated_text = add_output_port("Notes", PORT_TYPE_STRING)
	updated = add_output_port("Updated", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/mod_program/notepad/register_shell(atom/movable/shell)
	. = ..()
	RegisterSignal(associated_program, COMSIG_UI_ACT, PROC_REF(on_note_updated))

/obj/item/circuit_component/mod_program/notepad/unregister_shell()
	UnregisterSignal(associated_program, COMSIG_UI_ACT)
	return ..()

/obj/item/circuit_component/mod_program/notepad/proc/on_note_updated(datum/source, mob/user, action, list/params)
	SIGNAL_HANDLER
	if(action == "UpdateNote")
		updated_text.set_output(params["newnote"])
		updated.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/mod_program/notepad/input_received(datum/port/port)
	var/datum/computer_file/program/notepad/pad = associated_program
	pad.written_note = set_text.value
	SStgui.update_uis(pad.computer)
	updated_text.set_output(pad.written_note)
	updated.set_output(COMPONENT_SIGNAL)
