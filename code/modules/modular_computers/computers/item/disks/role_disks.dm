/**
 * Command
 */
/obj/item/computer_disk/command
	icon_state = "datadisk7"
	max_capacity = 32
	///Static list of programss ALL command tablets have.
	var/static/list/datum/computer_file/command_programs = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/science,
		/datum/computer_file/program/status,
	)

/obj/item/computer_disk/command/Initialize(mapload)
	. = ..()
	for(var/programs in command_programs)
		var/datum/computer_file/program/program_type = new programs
		add_file(program_type)

/obj/item/computer_disk/command/captain
	name = "舰长数据磁盘"
	desc = "储存有舰长需要的各种应用程序的磁盘."
	icon_state = "datadisk10"
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/records/medical,
	)

/obj/item/computer_disk/command/cmo
	name = "首席医疗官数据磁盘"
	desc = "储存有首席医疗官需要的各种应用程序的磁盘."
	starting_programs = list(
		/datum/computer_file/program/records/medical,
	)

/obj/item/computer_disk/command/rd
	name = "科研主管数据磁盘"
	desc = "储存有科研主管需要的各种应用程序的磁盘."
	starting_programs = list(
		/datum/computer_file/program/signal_commander,
	)

/obj/item/computer_disk/command/hos
	name = "安保部长数据磁盘"
	desc = "储存有安保部长需要的各种应用程序的磁盘."
	icon_state = "datadisk9"
	starting_programs = list(
		/datum/computer_file/program/records/security,
	)

/obj/item/computer_disk/command/hop
	name = "人事部长数据磁盘"
	desc = "储存有人事部长需要的各种应用程序的磁盘."
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/job_management,
	)

/obj/item/computer_disk/command/ce
	name = "首席工程师数据磁盘"
	desc = "储存有首席工程师需要的各种应用程序的磁盘."
	starting_programs = list(
		/datum/computer_file/program/supermatter_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/alarm_monitor,
	)

/**
 * Security
 */
/obj/item/computer_disk/security
	name = "安全官数据磁盘"
	desc = "储存有安全官需要的各种应用程序的磁盘."
	icon_state = "datadisk9"
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/crew_manifest,
	)

/**
 * Medical
 */
/obj/item/computer_disk/medical
	name = "医生数据磁盘"
	desc = "储存有医生需要的各种应用程序的磁盘."
	icon_state = "datadisk7"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
	)

/**
 * Supply
 */
/obj/item/computer_disk/quartermaster
	name = "货仓数据磁盘"
	desc = "储存有货仓工作需要的各种应用程序的磁盘."
	icon_state = "cargodisk"
	starting_programs = list(
		/datum/computer_file/program/shipping,
		/datum/computer_file/program/budgetorders,
	)

/**
 * Science
 */
/obj/item/computer_disk/ordnance
	name = "军械数据磁盘"
	desc = "储存有军械室工作需要的各种应用程序的磁盘."
	icon_state = "datadisk5"
	starting_programs = list(
		/datum/computer_file/program/signal_commander,
		/datum/computer_file/program/scipaper_program,
	)

/**
 * Engineering
 */
/obj/item/computer_disk/engineering
	name = "工程数据磁盘"
	desc = "储存有工程工作需要的各种应用程序的磁盘."
	icon_state = "datadisk6"
	starting_programs = list(
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/supermatter_monitor,

	)

