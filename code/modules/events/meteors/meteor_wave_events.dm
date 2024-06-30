// Normal strength

/datum/round_event_control/meteor_wave
	name = "Meteor Wave: Normal-陨石雨（普通）"
	typepath = /datum/round_event/meteor_wave
	weight = 4
	min_players = 15
	max_occurrences = 3
	earliest_start = 25 MINUTES
	category = EVENT_CATEGORY_SPACE
	description = "普通规模的陨石雨."
	map_flags = EVENT_SPACE_ONLY

/datum/round_event/meteor_wave
	start_when = 6
	end_when = 66
	announce_when = 1
	var/list/wave_type
	var/wave_name = "普通规模"

/datum/round_event/meteor_wave/New()
	..()
	if(!wave_type)
		determine_wave_type()

/datum/round_event/meteor_wave/proc/determine_wave_type()
	if(!wave_name)
		wave_name = pick_weight(list(
			"normal" = 50,
			"threatening" = 40,
			"catastrophic" = 10))
	switch(wave_name)
		if("normal")
			wave_type = GLOB.meteors_normal
		if("threatening")
			wave_type = GLOB.meteors_threatening
		if("catastrophic")
			if(check_holidays(HALLOWEEN))
				wave_type = GLOB.meteorsSPOOKY
			else
				wave_type = GLOB.meteors_catastrophic
		if("meaty")
			wave_type = GLOB.meateors
		if("space dust")
			wave_type = GLOB.meteors_dust
		if("halloween")
			wave_type = GLOB.meteorsSPOOKY
		else
			WARNING("[wave_name]的陨石雨未被识别.")
			kill()

/datum/round_event/meteor_wave/announce(fake)
	priority_announce("在运行轨道上发现陨石，预测发生撞击.", "陨石警报", ANNOUNCER_METEORS)

/datum/round_event/meteor_wave/tick()
	if(ISMULTIPLE(activeFor, 3))
		spawn_meteors(5, wave_type) //meteor list types defined in gamemode/meteor/meteors.dm

/datum/round_event_control/meteor_wave/threatening
	name = "Meteor Wave: Threatening-陨石雨（威胁性）"
	typepath = /datum/round_event/meteor_wave/threatening
	weight = 5
	min_players = 20
	max_occurrences = 3
	earliest_start = 35 MINUTES
	description = "陨石雨中出现大型陨石的几率更高."

/datum/round_event/meteor_wave/threatening
	wave_name = "威胁性"

/datum/round_event_control/meteor_wave/catastrophic
	name = "Meteor Wave: Catastrophic-陨石雨（灾难性）"
	typepath = /datum/round_event/meteor_wave/catastrophic
	weight = 7
	min_players = 25
	max_occurrences = 3
	earliest_start = 45 MINUTES
	description = "可能发生通古斯级陨石的陨石雨."

/datum/round_event/meteor_wave/catastrophic
	wave_name = "灾难性"

/datum/round_event_control/meteor_wave/meaty
	name = "Meteor Wave: Meaty-陨石雨（肉质性）"
	typepath = /datum/round_event/meteor_wave/meaty
	weight = 2
	max_occurrences = 1
	description = "由肉做成的陨石."

/datum/round_event/meteor_wave/meaty
	wave_name = "肉质性"

/datum/round_event/meteor_wave/meaty/announce(fake)
	priority_announce("在运行轨道上发现富含生物质的小行星，预测发生撞击", "该死，去拿拖把.", ANNOUNCER_METEORS)

/datum/round_event_control/meteor_wave/dust_storm
	name = "Major Space Dust-大型太空尘埃"
	typepath = /datum/round_event/meteor_wave/dust_storm
	weight = 14
	description = "整个空间站要被沙子给埋了."
	earliest_start = 15 MINUTES
	min_wizard_trigger_potency = 4
	max_wizard_trigger_potency = 7

/datum/round_event/meteor_wave/dust_storm
	announce_chance = 85
	wave_name = "太空尘埃"

/datum/round_event/meteor_wave/dust_storm/announce(fake)
	var/list/reasons = list()

	reasons += "[station_name()] 将穿过尘埃云， \
		预计外部设备和固定装置会收到轻微损坏."

	reasons += "纳米传讯的超武部正在测试一个新原型机 \
		[pick("失败的","重装","新星","特战","超级")] \
		[pick("加农炮","火炮","坦克","巡洋舰","\[数据删除\]")], \
		将造成一些轻微碰撞."

	reasons += "隔壁站点正在向你们扔石头. (可能他们受不了\
		你们的频繁信息了.)"

	reasons += "[station_name()]的轨道正穿过小行星采矿作业留下的残骸云 \
		预计会有轻微的外部损坏."

	reasons += "在[station_name()]轨道上的大型流星体已经被拆除. \
		残留的碎片可能会撞击站点外部."

	reasons += "[station_name()] 已经进入危险路段. \
		请注意外部物体的撞击."

	priority_announce(pick(reasons), "碰撞警报")
