/datum/uplink_category/stealthy
	name = "隐匿武器"
	weight = 8

/datum/uplink_item/stealthy_weapons
	category = /datum/uplink_category/stealthy


/datum/uplink_item/stealthy_weapons/dart_pistol
	name = "飞镖手枪"
	desc = "普通注射枪的缩小版，它开火时非常安静，可以放在任何的小空间里."
	item = /obj/item/gun/syringe/syndicate
	cost = 4
	surplus = 50
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_weapons/dehy_carp
	name = "脱水太空鲤鱼"
	desc = "看起来像毛绒玩具鲤鱼，但只要加水，它就变成了活生生的太空鲤鱼!使用前在手上激活，这样它就会知道不该杀死你."
	item = /obj/item/toy/plush/carpplushie/dehy_carp
	cost = 1

/datum/uplink_item/stealthy_weapons/edagger
	name = "能量匕首"
	desc = "一把由能量制成的匕首，平时被伪装成了一支笔."
	item = /obj/item/pen/edagger
	cost = 2

/datum/uplink_item/stealthy_weapons/traitor_chem_bottle
	name = "毒药包"
	desc = "装在一个小盒子里的各种致命化学品，配有注射器."
	item = /obj/item/storage/box/syndie_kit/chemical
	cost = 6
	surplus = 50

/datum/uplink_item/stealthy_weapons/suppressor
	name = "消音器"
	desc = "这种消声器削减武器枪声，以获得优越的伏击能力，它与许多小型武器兼容，包括马卡洛夫，APS和C-20r，但不包括左轮手枪或能量枪."
	item = /obj/item/suppressor
	cost = 3
	surplus = 10
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/stealthy_weapons/holster
	name = "辛迪加枪套"
	desc = "一个有用的小装置，使用变色龙技术，可以不显眼地携带枪支，它还允许你转枪玩."
	item = /obj/item/storage/belt/holster/chameleon
	cost = 1

/datum/uplink_item/stealthy_weapons/sleepy_pen
	name = "昏睡笔"
	desc = "一个伪装成笔的注射器，里面装满了强效的药物混合物，包括强麻醉剂和一种阻止目标说话的化学物质，\
			这支笔可以容纳一剂混合物，并可以重新填充任何化学物质，请注意，在药效发作前，他们仍能移动和行动."
	item = /obj/item/pen/sleepy
	cost = 4
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)


/datum/uplink_item/stealthy_weapons/origami_kit
	name = "折纸工具"
	desc = "这个盒子里有一本关于如何折出大师级作品的指南，，让你把普通的纸折成完美的空气动力学(和潜在致命性)纸飞机."
	item = /obj/item/storage/box/syndie_kit/origami_bundle
	cost = 4
	surplus = 0
	purchasable_from = ~UPLINK_NUKE_OPS //clown ops intentionally left in, because that seems like some s-tier shenanigans.


/datum/uplink_item/stealthy_weapons/martialarts
	name = "武术卷轴"
	desc = "这个卷轴包含了一种古代武术技巧的全部秘密，你的徒手格斗技巧将提神到能偏转子弹的程度，但你也将从此拒绝使用卑鄙的远程武器."
	item = /obj/item/book/granter/martial/carp
	progression_minimum = 30 MINUTES
	cost = 17
	surplus = 0
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_weapons/crossbow
	name = "迷你能量弩"
	desc = "这把短弩小的可以装进口袋或悄无声息地塞进包里，它会合成并发射带有衰弱毒素的弩箭，\
	对目标造成伤害后使其迷失方向，使其像喝醉了一样模糊. 它可以产生无限数量的弩箭，但需要时间来充能."
	item = /obj/item/gun/energy/recharge/ebow
	cost = 10
	surplus = 50
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_weapons/contrabaton
	name = "契约电棍"
	desc = "一种专为契约特工设计的紧凑型特殊电棍, 可以对目标施加轻微电击造成短暂的昏迷，同时还能影响目标声带，使得他们像喝醉了一样口齿不清."
	item = /obj/item/melee/baton/telescopic/contractor_baton
	cost = 7
	surplus = 50
	limited_stock = 1
	purchasable_from = UPLINK_TRAITORS | UPLINK_SPY
