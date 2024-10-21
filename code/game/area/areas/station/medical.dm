/area/station/medical
	name = "Medical-医疗部"
	icon_state = "medbay"
	ambience_index = AMBIENCE_MEDICAL
	airlock_wires = /datum/wires/airlock/medbay
	sound_environment = SOUND_AREA_STANDARD_STATION
	min_ambience_cooldown = 90 SECONDS
	max_ambience_cooldown = 180 SECONDS

/area/station/medical/abandoned
	name = "\improper Abandoned Medbay-废弃医疗区"
	icon_state = "abandoned_medbay"
	ambientsounds = list(
		'sound/ambience/signal.ogg',
		)
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/medical/medbay/central
	name = "Medbay-医疗部中央"
	icon_state = "med_central"

/area/station/medical/medbay/lobby
	name = "\improper Medbay-医疗部大厅"
	icon_state = "med_lobby"

/area/station/medical/medbay/aft
	name = "Medbay-医疗部后部"
	icon_state = "med_aft"

/area/station/medical/storage
	name = "Medbay-医疗部仓库"
	icon_state = "med_storage"

/area/station/medical/paramedic
	name = "Paramedic Dispatch-急救调度"
	icon_state = "paramedic"

/area/station/medical/office
	name = "\improper Medical-医疗部办公室"
	icon_state = "med_office"

/area/station/medical/break_room
	name = "\improper Medical-医疗部休息室"
	icon_state = "med_break"

/area/station/medical/coldroom
	name = "\improper Medical-医疗部冷库"
	icon_state = "kitchen_cold"

/area/station/medical/patients_rooms
	name = "\improper Medical-医疗部病房"
	icon_state = "patients"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/medical/patients_rooms/room_a
	name = "Patient Room-医疗部病房A号"
	icon_state = "patients"

/area/station/medical/patients_rooms/room_b
	name = "Patient Room-医疗部病房B号"
	icon_state = "patients"

/area/station/medical/virology
	name = "Virology-病毒学研究所"
	icon_state = "virology"
	ambience_index = AMBIENCE_VIROLOGY

/area/station/medical/virology/isolation
	name = "Virology Isolation-病毒学隔离间"
	icon_state = "virology_isolation"

/area/station/medical/morgue
	name = "\improper Morgue-停尸房"
	icon_state = "morgue"
	ambience_index = AMBIENCE_SPOOKY
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/medical/chemistry
	name = "Chemistry-化学间"
	icon_state = "chem"

/area/station/medical/chemistry/minisat
	name = "Chemistry Mini-Satellite-化学迷你卫星"

/area/station/medical/pharmacy
	name = "\improper Pharmacy-药房"
	icon_state = "pharmacy"

/area/station/medical/chem_storage
	name = "\improper Chemical-化学仓库"
	icon_state = "chem_storage"

/area/station/medical/surgery
	name = "\improper Operating-手术室"
	icon_state = "surgery"

/area/station/medical/surgery/fore
	name = "\improper Operating-前部手术室"
	icon_state = "foresurgery"

/area/station/medical/surgery/aft
	name = "\improper Operating-后部手术室"
	icon_state = "aftsurgery"

/area/station/medical/surgery/theatre
	name = "\improper Surgery-大手术室"
	icon_state = "surgerytheatre"

/area/station/medical/cryo
	name = "Cryogenics-低温室"
	icon_state = "cryo"

/area/station/medical/exam_room
	name = "\improper Exam Room-诊疗室"
	icon_state = "exam_room"

/area/station/medical/treatment_center
	name = "\improper Medbay-医疗部治疗中心"
	icon_state = "exam_room"

/area/station/medical/psychology
	name = "\improper Psychology-心理学办公室"
	icon_state = "psychology"
	mood_bonus = 3
	mood_message = "在这里很自在."
	ambientsounds = list(
		'sound/ambience/aurora_caelus_short.ogg',
		)
