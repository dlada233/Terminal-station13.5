// When adding a new area to the security areas, make sure to add it to /datum/bounty/item/security/paperwork as well!

/area/station/security
	name = "Security-安保"
	icon_state = "security"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/security
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/security/office
	name = "\improper Security-安保办公室"
	icon_state = "security"

/area/station/security/breakroom
	name = "\improper Security-安保休息室"
	icon_state = "brig"

/area/station/security/tram
	name = "\improper Security-安保部转运电车"
	icon_state = "security"

/area/station/security/lockers
	name = "\improper Security-安保部更衣室"
	icon_state = "securitylockerroom"

/area/station/security/brig
	name = "\improper Brig-安保大门"
	icon_state = "brig"

/area/station/security/holding_cell
	name = "\improper Holding Cell-拘留室"
	icon_state = "holding_cell"

/area/station/security/medical
	name = "\improper Security-安保部救治处"
	icon_state = "security_medical"

/area/station/security/brig/upper
	name = "\improper Brig Overlook-安保大门检查处"
	icon_state = "upperbrig"

/area/station/security/brig/entrance
	name = "\improper Brig Entrance-安保大门入口"
	icon_state = "brigentry"

/area/station/security/courtroom
	name = "\improper Courtroom-法庭"
	icon_state = "courtroom"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/security/courtroom/holding
	name = "\improper Courtroom-法庭囚犯收容间"

/area/station/security/processing
	name = "\improper Labor-劳改飞船码头"
	icon_state = "sec_labor_processing"

/area/station/security/processing/cremation
	name = "\improper Security-焚烧处"
	icon_state = "sec_cremation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/security/interrogation
	name = "\improper Interrogation-焚烧房"
	icon_state = "interrogation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/security/warden
	name = "Brig Control-安保大门控制"
	icon_state = "warden"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/security/evidence
	name = "Evidence Storage-证据室"
	icon_state = "evidence"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/security/detectives_office
	name = "\improper Detective-侦探事务所"
	icon_state = "detective"
	ambientsounds = list(
		'sound/ambience/ambidet1.ogg',
		'sound/ambience/ambidet2.ogg',
		)

/area/station/security/detectives_office/private_investigators_office
	name = "\improper Private Investigator-私人侦探事务所"
	icon_state = "investigate_office"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/security/range
	name = "\improper Firing Range-靶场"
	icon_state = "firingrange"

/area/station/security/eva
	name = "\improper Security-安保EVA存放室"
	icon_state = "sec_eva"

/area/station/security/execution
	icon_state = "execution_room"

/area/station/security/execution/transfer
	name = "\improper Transfer Centre-安保部转运中心"
	icon_state = "sec_processing"

/area/station/security/execution/education
	name = "\improper Prisoner Education Chamber-囚犯教育室"

/area/station/security/mechbay
	name = "Security-安保机甲库"
	icon_state = "sec_mechbay"

/*
* Security Checkpoints
*/

/area/station/security/checkpoint
	name = "\improper Security-安保检查站"
	icon_state = "checkpoint"

/area/station/security/checkpoint/escape
	name = "\improper Departures-离境检查站"
	icon_state = "checkpoint_esc"

/area/station/security/checkpoint/arrivals
	name = "\improper Arrivals-入境检查站"
	icon_state = "checkpoint_arr"

/area/station/security/checkpoint/supply
	name = "Security-货仓安保亭"
	icon_state = "checkpoint_supp"

/area/station/security/checkpoint/engineering
	name = "Security-工程部安保亭"
	icon_state = "checkpoint_engi"

/area/station/security/checkpoint/medical
	name = "Security-医疗部安保亭"
	icon_state = "checkpoint_med"

/area/station/security/checkpoint/medical/medsci
	name = "Security-医研安保亭"

/area/station/security/checkpoint/science
	name = "Security-科研部安保亭"
	icon_state = "checkpoint_sci"

/area/station/security/checkpoint/science/research
	name = "Security-研究处安保亭"
	icon_state = "checkpoint_res"

/area/station/security/checkpoint/customs
	name = "Customs-海关"
	icon_state = "customs_point"

/area/station/security/checkpoint/customs/auxiliary
	name = "Auxiliary Customs-辅助基地海关"
	icon_state = "customs_point_aux"

/area/station/security/checkpoint/customs/fore
	name = "Fore Customs-站首海关"
	icon_state = "customs_point_fore"

/area/station/security/checkpoint/customs/aft
	name = "Aft Customs-站尾海关"
	icon_state = "customs_point_aft"

/area/station/security/checkpoint/first
	name = "Security-一楼安保亭"
	icon_state = "checkpoint_1"

/area/station/security/checkpoint/second
	name = "Security-二楼安保亭"
	icon_state = "checkpoint_2"

/area/station/security/checkpoint/third
	name = "Security-三楼安保亭"
	icon_state = "checkpoint_3"


/area/station/security/prison
	name = "\improper Prison-监狱"
	icon_state = "sec_prison"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED | PERSISTENT_ENGRAVINGS

//Rad proof
/area/station/security/prison/toilet
	name = "\improper Prison-监狱厕所"
	icon_state = "sec_prison_safe"

// Rad proof
/area/station/security/prison/safe
	name = "\improper Prison-监狱牢房"
	icon_state = "sec_prison_safe"

/area/station/security/prison/upper
	name = "\improper Upper Prison-监狱上层"
	icon_state = "prison_upper"

/area/station/security/prison/visit
	name = "\improper Prison-探监处"
	icon_state = "prison_visit"

/area/station/security/prison/rec
	name = "\improper Prison-监狱休闲室"
	icon_state = "prison_rec"

/area/station/security/prison/mess
	name = "\improper Prison-监狱食堂"
	icon_state = "prison_mess"

/area/station/security/prison/work
	name = "\improper Prison-监狱工作间"
	icon_state = "prison_work"

/area/station/security/prison/shower
	name = "\improper Prison-监狱淋浴间"
	icon_state = "prison_shower"

/area/station/security/prison/workout
	name = "\improper Prison-监狱健身房"
	icon_state = "prison_workout"

/area/station/security/prison/garden
	name = "\improper Prison-监狱菜园"
	icon_state = "prison_garden"
