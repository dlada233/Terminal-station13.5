/datum/computer_file/program/revelation
	filename = "revelation"
	filedesc = "Revelation-上启"
	downloader_category = PROGRAM_CATEGORY_DEVICE
	program_open_overlay = "hostile"
	extended_desc = "这种病毒在执行时将摧毁磁盘驱动系统，并且具有伪装成无害程序的功能，一旦部署，它会在下次执行时摧毁系统."
	size = 13
	program_flags = PROGRAM_ON_SYNDINET_STORE
	tgui_id = "NtosRevelation"
	program_icon = "magnet"
	var/armed = 0

/datum/computer_file/program/revelation/on_start(mob/living/user)
	. = ..(user)
	if(armed)
		activate()

/datum/computer_file/program/revelation/proc/activate()
	if(computer)
		if(istype(computer, /obj/item/modular_computer/pda/silicon)) //If this is a borg's integrated tablet
			var/obj/item/modular_computer/pda/silicon/modularInterface = computer
			to_chat(modularInterface.silicon_owner,span_userdanger("检测到系统清除/"))
			addtimer(CALLBACK(modularInterface.silicon_owner, TYPE_PROC_REF(/mob/living/silicon/robot/, death)), 2 SECONDS, TIMER_UNIQUE)
			return

		computer.visible_message(span_notice("[computer]高强度闪烁屏幕并发出了巨大的电流声."))
		computer.enabled = FALSE
		computer.update_appearance()

		QDEL_LIST(computer.stored_files)

		computer.take_damage(25, BRUTE, 0, 0)

		if(computer.internal_cell && prob(25))
			QDEL_NULL(computer.internal_cell)
			computer.visible_message(span_notice("[computer]的电源爆炸，迸出一阵火花."))
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
			spark_system.start()

/datum/computer_file/program/revelation/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("PRG_arm")
			armed = !armed
			return TRUE
		if("PRG_activate")
			activate()
			return TRUE
		if("PRG_obfuscate")
			var/newname = params["new_name"]
			if(!newname)
				return
			filedesc = newname
			return TRUE


/datum/computer_file/program/revelation/clone()
	var/datum/computer_file/program/revelation/temp = ..()
	temp.armed = armed
	return temp

/datum/computer_file/program/revelation/ui_data(mob/user)
	var/list/data = list()

	data["armed"] = armed

	return data
