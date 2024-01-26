/datum/round_event_control/mice_migration
	name = "Mice Migration"
	typepath = /datum/round_event/mice_migration
	weight = 10
	category = EVENT_CATEGORY_ENTITIES
	description = "A horde of mice arrives, and perhaps even the Rat King themselves."

/datum/round_event/mice_migration
	var/minimum_mice = 5
	var/maximum_mice = 15

/datum/round_event/mice_migration/announce(fake)
	var/cause = pick("寒冬", "预算不足", "诸神黄昏",
		"太空冷寂", "\[数据删除\]", "气候变化",
		"倒霉")
	var/plural = pick("一群", "一帮", "一大家伙",
		"至多[maximum_mice]的")
	var/name = pick("啮齿动物", "老鼠", "吱吱叫的东西",
		"食电线哺乳动物", "\[数据删除\]", "消耗能量的寄生虫")
	var/movement = pick("迁移", "成群结队地移动", "涌向", "降临")
	var/location = pick("维护通道", "维护区域",
		"\[REDACTED\]", "有很多电线的地方")

	priority_announce("由于 [cause], [plural] [name] 已经 [movement] \
		了[location].", "迁移警报",
		'sound/creatures/mousesqueek.ogg')

/datum/round_event/mice_migration/start()
	SSminor_mapping.trigger_migration(rand(minimum_mice, maximum_mice))
