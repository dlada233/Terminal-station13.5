/datum/computer_file/program/records
	filename = "ntrecords"
	filedesc = "档案"
	extended_desc = "允许用户查看几种基础的船员档案."
	downloader_category = PROGRAM_CATEGORY_SECURITY
	program_icon = "clipboard"
	program_open_overlay = "crew"
	tgui_id = "NtosRecords"
	size = 4
	can_run_on_flags = PROGRAM_PDA | PROGRAM_LAPTOP
	program_flags = NONE
	detomatix_resistance = DETOMATIX_RESIST_MINOR

	var/mode

/datum/computer_file/program/records/medical
	filedesc = "医疗档案"
	filename = "medrecords"
	program_icon = "book-medical"
	extended_desc = "允许用户查看船员的基本医疗档案."
	download_access = list(ACCESS_MEDICAL, ACCESS_FLAG_COMMAND)
	program_flags = PROGRAM_ON_NTNET_STORE
	mode = "medical"

/datum/computer_file/program/records/security
	filedesc = "安保档案"
	filename = "secrecords"
	extended_desc = "允许用户查看船员的基本安保档案."
	download_access = list(ACCESS_SECURITY, ACCESS_FLAG_COMMAND)
	program_flags = PROGRAM_ON_NTNET_STORE
	mode = "security"

/datum/computer_file/program/records/proc/GetRecordsReadable()
	var/list/all_records = list()

	switch(mode)
		if("security")
			for(var/datum/record/crew/person in GLOB.manifest.general)
				var/list/current_record = list()

				current_record["age"] = person.age
				current_record["fingerprint"] = person.fingerprint
				current_record["gender"] = person.gender
				current_record["name"] = person.name
				current_record["rank"] = person.rank
				current_record["species"] = person.species
				current_record["wanted"] = person.wanted_status
				current_record["voice"] = person.voice

				all_records += list(current_record)
		if("medical")
			for(var/datum/record/crew/person in GLOB.manifest.general)
				var/list/current_record = list()

				current_record["bloodtype"] = person.blood_type
				current_record["ma_dis"] = person.major_disabilities_desc
				current_record["mi_dis"] = person.minor_disabilities_desc
				current_record["physical_status"] = person.physical_status
				current_record["mental_status"] = person.mental_status
				current_record["name"] = person.name
				current_record["notes"] = person.medical_notes

				all_records += list(current_record)

	return all_records

/datum/computer_file/program/records/ui_static_data(mob/user)
	var/list/data = list()
	data["records"] = GetRecordsReadable()
	data["mode"] = mode
	return data
