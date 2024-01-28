/datum/uplink_category/ammo
	name = "弹药"
	weight = 7

/datum/uplink_item/ammo
	category = /datum/uplink_category/ammo
	surplus = 40

/datum/uplink_item/ammo/toydarts
	name = "一盒防暴泡沫弹"
	desc = "一盒40个Donksoft防暴泡沫弹，用于任何兼容的泡沫枪弹匣."
	item = /obj/item/ammo_box/foambox/riot
	cost = 2
	surplus = 0
	illegal_tech = FALSE
	purchasable_from = ~UPLINK_NUKE_OPS

/datum/uplink_item/ammo/pistol
	name = "9mm弹匣"
	desc = "一个额外的8发的9毫米弹匣，与马卡洛夫手枪兼容."
	item = /obj/item/ammo_box/magazine/m9mm
	cost = 1
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	illegal_tech = FALSE

/datum/uplink_item/ammo/pistolap
	name = "9mm穿甲弹匣"
	desc = "一个额外的8发的9毫米弹匣，与马卡洛夫手枪兼容. \
			这种子弹伤害肉体的效果较差，但能穿透护甲."
	item = /obj/item/ammo_box/magazine/m9mm/ap
	cost = 2
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/ammo/pistolhp
	name = "9mm空尖弹匣"
	desc = "一个额外的8发的9毫米弹匣，与马卡洛夫手枪兼容. \
			这种子弹对肉体杀伤力更强，但对装甲无效."
	item = /obj/item/ammo_box/magazine/m9mm/hp
	cost = 3
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/ammo/pistolfire
	name = "9mm燃烧弹匣"
	desc = "一个额外的8发的9毫米弹匣，与马卡洛夫手枪兼容. \
			这种子弹只能造成很小的伤害，但能点燃目标."
	item = /obj/item/ammo_box/magazine/m9mm/fire
	cost = 2
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/ammo/revolver
	name = ".357快速装弹器"
	desc = "一个装有7发.357马格南子弹的快速装弹器；可用于辛迪加左轮手枪. \
			当你真的需要很东西死掉的时候使用."
	item = /obj/item/ammo_box/a357
	cost = 4
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS) //nukies get their own version
	illegal_tech = FALSE
