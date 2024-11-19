/obj/item/computer_disk/syndicate
	name = "黄金数据软盘"
	desc = "一张装有高科技程序的数据软盘，可能贵的要命."
	icon_state = "datadisk8"
	custom_materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT)

/obj/item/computer_disk/syndicate/camera_app
	starting_programs = list(/datum/computer_file/program/secureye/syndicate)

/obj/item/computer_disk/syndicate/contractor
	starting_programs = list(/datum/computer_file/program/contract_uplink)

/obj/item/computer_disk/black_market
	desc = "用于存储数据的可移动软盘，这个上面粘着一张污迹斑斑的纸，上面写有“PC软件”的字样."

/obj/item/computer_disk/black_market/Initialize(mapload)
	icon_state = "datadisk[rand(0, 10)]"
	//Populated with programs not found in the verified downloader app or that require access to download (but not to run).
	var/list/potential_programs = list(
		/datum/computer_file/program/arcade/eazy,
		/datum/computer_file/program/radar/lifeline,
		/datum/computer_file/program/radar/custodial_locator,
		/datum/computer_file/program/supermatter_monitor,
		/datum/computer_file/program/newscaster,
		/datum/computer_file/program/secureye,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/status,
	)
	potential_programs += subtypesof(/datum/computer_file/program/maintenance) - /datum/computer_file/program/maintenance/theme

	var/total_programs_size = 0
	for(var/i in 1 to rand(2, 4))
		var/datum/computer_file/program/to_add = pick_n_take(potential_programs)
		total_programs_size += initial(to_add.size)
		starting_programs += to_add
	///Make sure the disk has enough space for all the programs
	max_capacity = max(total_programs_size, max_capacity)
	return ..()
