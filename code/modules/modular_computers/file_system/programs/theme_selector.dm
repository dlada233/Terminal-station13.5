/datum/computer_file/program/themeify
	filename = "themeify"
	filedesc = "主题"
	extended_desc = "该程序允许您配置您设备的主题."
	program_open_overlay = "generic"
	undeletable = TRUE
	size = 0
	program_flags = PROGRAM_ON_NTNET_STORE | PROGRAM_HEADER
	tgui_id = "NtosThemeConfigure"
	program_icon = "paint-roller"

	///List of all themes imported from maintenance apps.
	var/list/imported_themes = list()

/datum/computer_file/program/themeify/ui_data(mob/user)
	var/list/data = list()

	if(computer.obj_flags & EMAGGED)
		data["themes"] += list(list("theme_name" = SYNDICATE_THEME_NAME, "theme_ref" = GLOB.pda_name_to_theme[SYNDICATE_THEME_NAME]))
	for(var/theme_key in GLOB.default_pda_themes + imported_themes)
		data["themes"] += list(list("theme_name" = theme_key, "theme_ref" = GLOB.pda_name_to_theme[theme_key]))

	return data

/datum/computer_file/program/themeify/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("PRG_change_theme")
			var/selected_theme = params["selected_theme"]
			if( \
				!GLOB.default_pda_themes.Find(selected_theme) && \
				!imported_themes.Find(selected_theme) && \
				!(computer.obj_flags & EMAGGED) \
			)
				return FALSE
			computer.device_theme = GLOB.pda_name_to_theme[selected_theme]
			return TRUE
