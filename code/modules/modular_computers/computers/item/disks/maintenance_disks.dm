/obj/item/computer_disk/maintenance
	name = "管道数据软盘"
	desc = "在维护过程中被遗忘的软盘，上面可能有一些有用的程序."

/// Medical health analyzer app
/obj/item/computer_disk/maintenance/scanner
	starting_programs = list(/datum/computer_file/program/maintenance/phys_scanner)

///Camera app, forced to always have largest image size
/obj/item/computer_disk/maintenance/camera
	starting_programs = list(/datum/computer_file/program/maintenance/camera)

///MODsuit UI, in your PDA!
/obj/item/computer_disk/maintenance/modsuit_control
	starting_programs = list(/datum/computer_file/program/maintenance/modsuit_control)

///Returns A 'spookiness' value based on the number of ghastly creature and hauntium and their distance from the PC.
/obj/item/computer_disk/maintenance/spectre_meter
	starting_programs = list(/datum/computer_file/program/maintenance/spectre_meter)

///A version of the arcade program with less HP/MP for the enemy and more for the player
/obj/item/computer_disk/maintenance/arcade
	starting_programs = list(/datum/computer_file/program/arcade/eazy)

/obj/item/computer_disk/maintenance/theme/Initialize(mapload)
	starting_programs = list(pick(subtypesof(/datum/computer_file/program/maintenance/theme)))
	return ..()

/obj/item/computer_disk/maintenance/cool_sword
	starting_programs = list(/datum/computer_file/program/maintenance/cool_sword)
