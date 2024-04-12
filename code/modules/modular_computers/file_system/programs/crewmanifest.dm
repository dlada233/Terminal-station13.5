/datum/computer_file/program/crew_manifest
	filename = "plexagoncrew"
	filedesc = "迭角形船员名单"
	downloader_category = PROGRAM_CATEGORY_SECURITY
	program_open_overlay = "id"
	extended_desc = "能查看和打印当前船员名单的程序."
	download_access = list(ACCESS_SECURITY, ACCESS_COMMAND)
	program_flags = PROGRAM_ON_NTNET_STORE | PROGRAM_REQUIRES_NTNET
	size = 4
	tgui_id = "NtosCrewManifest"
	program_icon = "clipboard-list"
	detomatix_resistance = DETOMATIX_RESIST_MAJOR

/datum/computer_file/program/crew_manifest/ui_static_data(mob/user)
	var/list/data = list()
	data["manifest"] = GLOB.manifest.get_manifest()
	return data

/datum/computer_file/program/crew_manifest/ui_act(action, params, datum/tgui/ui)
	switch(action)
		if("PRG_print")
			if(computer) //This option should never be called if there is no printer
				var/contents = {"<h4>船员名单</h4>
								<br>
								[GLOB.manifest ? GLOB.manifest.get_html(0) : ""]
								"}
				if(!computer.print_text(contents, "船员名单 ([station_time_timestamp()])"))
					to_chat(usr, span_notice("打印机没纸了."))
					return
				else
					computer.visible_message(span_notice("[computer]打印出一张纸."))
