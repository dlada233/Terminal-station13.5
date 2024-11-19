/area/station/command
	name = "Command-指挥"
	icon_state = "command"
	ambientsounds = list(
		'sound/ambience/signal.ogg',
		)
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/command/bridge
	name = "\improper Bridge-舰桥"
	icon_state = "bridge"

/area/station/command/meeting_room
	name = "\improper Heads of Staff Meeting Room-部长会议室"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/command/meeting_room/council
	name = "\improper Council Chamber-会议室"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/command/corporate_showroom
	name = "\improper Corporate Showroom-企业展厅"
	icon_state = "showroom"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/command/corporate_suite
	name = "\improper Corporate Guest Suite-企业宾客套房"
	icon_state = "command"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/command/emergency_closet
	name = "\improper Corporate Emergency Closet-企业应急衣柜"
	icon_state = "command"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/*
* Command Head Areas
*/

/area/station/command/heads_quarters
	icon_state = "heads_quarters"

/area/station/command/heads_quarters/captain
	name = "\improper Captain's Office-舰长办公室"
	icon_state = "captain"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/command/heads_quarters/captain/private
	name = "\improper Captain's Quarters-舰长室"
	icon_state = "captain_private"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/command/heads_quarters/ce
	name = "\improper Chief Engineer's Office-工程部长办公室"
	icon_state = "ce_office"

/area/station/command/heads_quarters/cmo
	name = "\improper Chief Medical Officer's Office-医疗部长办公室"
	icon_state = "cmo_office"

/area/station/command/heads_quarters/hop
	name = "\improper Head of Personnel's Office-人事部长办公室"
	icon_state = "hop_office"

/area/station/command/heads_quarters/hos
	name = "\improper Head of Security's Office-安保部长办公室"
	icon_state = "hos_office"

/area/station/command/heads_quarters/rd
	name = "\improper Research Director's Office-科研主管办公室"
	icon_state = "rd_office"

/area/station/command/heads_quarters/qm
	name = "\improper Quartermaster's Office-军需官办公室"
	icon_state = "qm_office"

/*
* Command - Teleporter
*/

/area/station/command/teleporter
	name = "\improper Teleporter Room-远距离传送室"
	icon_state = "teleporter"
	ambience_index = AMBIENCE_ENGI

/area/station/command/gateway
	name = "\improper Gateway-星门"
	icon_state = "gateway"
	ambience_index = AMBIENCE_ENGI

/*
* Command - Misc
*/

/area/station/command/corporate_dock
	name = "\improper Corporate Private Dock-私人码头"
	icon_state = "command"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
