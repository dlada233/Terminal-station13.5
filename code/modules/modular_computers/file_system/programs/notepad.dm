/datum/computer_file/program/notepad
	filename = "记事本"
	filedesc = "记事本"
	downloader_category = PROGRAM_CATEGORY_DEVICE
	program_open_overlay = "generic"
	extended_desc = "摘记任何你在空间站上的想法."
	size = 2
	tgui_id = "NtosNotepad"
	program_icon = "book"
	can_run_on_flags = PROGRAM_ALL

	var/written_note = "祝贺您的站点升级并体验全新的NtOS & Thinktronic的联合协作技术, \
		为您带来自2467年以来最好的电子和软件解决方案!\n\
		为了方便您导航，我们提供了以下术语定义:\n\
		Fore - 站体前端\n\
		Aft - 站体后端\n\
		Port - 站体左侧\n\
		Starboard - 站体右侧\n\
		Quarter - 站尾两测\n\
		Bow - 站头两侧"

/datum/computer_file/program/notepad/ui_act(action, list/params, datum/tgui/ui)
	switch(action)
		if("UpdateNote")
			written_note = params["newnote"]
			return TRUE

/datum/computer_file/program/notepad/ui_data(mob/user)
	var/list/data = list()

	data["note"] = written_note

	return data
