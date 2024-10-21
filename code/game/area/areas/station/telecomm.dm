/*
* Telecommunications Satellite Areas
*/

/area/station/tcommsat
	icon_state = "tcomsatcham"
	ambientsounds = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen9.ogg',
		'sound/ambience/ambitech.ogg',
		'sound/ambience/ambitech2.ogg',
		'sound/ambience/ambitech3.ogg',
		'sound/ambience/ambimystery.ogg',
		)
	airlock_wires = /datum/wires/airlock/engineering

/area/station/tcommsat/computer
	name = "\improper Telecomms-电信控制室"
	icon_state = "tcomsatcomp"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/tcommsat/server
	name = "\improper Telecomms-电信服务器机房"
	icon_state = "tcomsatcham"

/area/station/tcommsat/server/upper
	name = "\improper Upper Telecomms-电信上层服务器机房"

/*
* On-Station Telecommunications Areas
*/

/area/station/comms
	name = "\improper Communications Relay-通信中继"
	icon_state = "tcomsatcham"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/server
	name = "\improper Messaging Server Room-信息服务器机房"
	icon_state = "server"
	sound_environment = SOUND_AREA_STANDARD_STATION
