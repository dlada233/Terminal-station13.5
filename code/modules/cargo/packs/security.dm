/datum/supply_pack/security
	group = "安保用品"
	access = ACCESS_SECURITY
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/security/ammo
	name = "弹药补给包"
	desc = "包含三盒豆袋霰弹, 三盒橡胶霰弹\
		和一个特制.38 左轮快速装弹器."
	cost = CARGO_CRATE_VALUE * 8
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/beanbag = 3,
					/obj/item/storage/box/rubbershot = 3,
					/obj/item/ammo_box/c38/trac,
					/obj/item/ammo_box/c38/hotshot,
					/obj/item/ammo_box/c38/iceblox,
				)
	crate_name = "弹药补给箱"

/datum/supply_pack/security/armor
	name = "护甲补给"
	desc = "三件防弹背心."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/clothing/suit/armor/vest = 3)
	crate_name = "护甲补给箱"

/datum/supply_pack/security/disabler
	name = "镇暴光枪箱"
	desc = "被镇暴光束击中的人将逐渐流失体力，最终倒地，内含三把发射镇暴光束的手枪."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/gun/energy/disabler = 3)
	crate_name = "镇暴光枪箱"

/datum/supply_pack/security/forensics
	name = "取证用品包"
	desc = "用于帮助侦探紧跟罪犯踪迹调查案件，使真相水落石出的用品包，\
		里面有一个取证扫描仪、六袋证据袋、相机、录音机、白色蜡笔,\
		当然还有一顶软呢帽."
	cost = CARGO_CRATE_VALUE * 2.5
	access_view = ACCESS_MORGUE
	contains = list(/obj/item/detective_scanner,
					/obj/item/storage/box/evidence,
					/obj/item/camera,
					/obj/item/taperecorder,
					/obj/item/toy/crayon/white,
					/obj/item/clothing/head/fedora/det_hat,
				)
	crate_name = "取证用品箱"

/datum/supply_pack/security/helmets
	name = "头盔补给"
	desc = "包含三顶制式头盔."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/helmet/sec = 3)
	crate_name = "头盔补给箱"

/datum/supply_pack/security/laser
	name = "激光枪补给箱"
	desc = "内含三把致命性的大功率激光枪."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/gun/energy/laser = 3)
	crate_name = "激光枪补给箱"

/datum/supply_pack/security/securitybarriers
	name = "安保屏障手雷"
	desc = "用四枚安保屏障阻挡‘人流’."
	access_view = ACCESS_BRIG
	contains = list(/obj/item/grenade/barrier = 4)
	cost = CARGO_CRATE_VALUE * 2
	crate_name = "安保屏障手雷箱"

/datum/supply_pack/security/securityclothes
	name = "安保制服补给"
	desc = "包含站点安保部队的各种制服，\
		包括典狱长、安保部长和两套警员的制服. \
		每套制服都配有与级别相衬的外装和贝雷帽."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/clothing/under/rank/security/officer/formal = 2,
					/obj/item/clothing/suit/jacket/officer/blue = 2,
					/obj/item/clothing/head/beret/sec/navyofficer = 2,
					/obj/item/clothing/under/rank/security/warden/formal,
					/obj/item/clothing/suit/jacket/warden/blue,
					/obj/item/clothing/head/beret/sec/navywarden,
					/obj/item/clothing/under/rank/security/head_of_security/formal,
					/obj/item/clothing/suit/jacket/hos/blue,
					/obj/item/clothing/head/hats/hos/beret/navyhos,
				)
	crate_name = "安保制服箱"

/datum/supply_pack/security/stingpack
	name = "碎裂手榴弹包"
	desc = "碎裂手榴弹杀伤原理同破片类似，但专注于停止目标而不具致命性，\
		一次购买配送五枚."
	cost = CARGO_CRATE_VALUE * 5
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/stingbangs)
	crate_name = "碎裂手榴弹箱"

/datum/supply_pack/security/supplies
	name = "安保用具补给包"
	desc = "里面有七枚闪光弹、七枚催泪弹、六把闪光灯和七支手铐"
	cost = CARGO_CRATE_VALUE * 3.5
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/teargas,
					/obj/item/storage/box/flashes,
					/obj/item/storage/box/handcuffs,
				)
	crate_name = "安保用具箱"

/datum/supply_pack/security/firingpins
	name = "标准撞针箱"
	desc = "用标准撞针来升级你的武器库，一次购买配送十根."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/firingpins = 2)
	crate_name = "标准撞针箱"

/datum/supply_pack/security/firingpins/paywall
	name = "付费撞针箱"
	desc = "付费撞针可以让使用者在开枪时自动从银行账户扣除余额，一次购买配送十根."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/firingpins/paywall = 2)
	crate_name = "付费撞针箱"

/datum/supply_pack/security/justiceinbound
	name = "罪恶克星套装"
	desc = "是我，出类拔萃，万里挑一的正义化身，罪恶的克星. \
		Nanotrasen安保皇冠上的明珠，精锐中的精锐中的精锐. \
		头盔界的潮流引领者， \
		天地间的宠儿...."
	cost = CARGO_CRATE_VALUE * 6 //justice comes at a price. An expensive, noisy price.
	contraband = TRUE
	contains = list(/obj/item/clothing/head/helmet/toggleable/justice,
					/obj/item/clothing/mask/gas/sechailer,
				)
	crate_name = "罪恶克星箱"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/security/baton
	name = "镇暴电棍箱"
	desc = "内含给安保部队使用的三根电棍及配套电池."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/melee/baton/security/loaded = 3)
	crate_name = "镇暴电棍箱"

/datum/supply_pack/security/wall_flash
	name = "壁挂式闪光灯"
	desc = "里面有四台壁挂式闪光灯"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/wall_flash = 4)
	crate_name = "壁挂式闪光灯箱"

/datum/supply_pack/security/constable
	name = "传统装备箱"
	desc = "不知道从哪个地方翻出来的,包含一套安保队员制服、哨子和转换套件. \
		让你回到那段疑云重重的岁月."
	cost = CARGO_CRATE_VALUE * 2.2
	contraband = TRUE
	contains = list(/obj/item/clothing/under/rank/security/constable,
					/obj/item/clothing/head/costume/constable,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/whistle,
					/obj/item/conversion_kit,
				)
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/// Armory packs

/datum/supply_pack/security/armory
	group = "军械用品"
	access = ACCESS_ARMORY
	access_view = ACCESS_ARMORY
	crate_type = /obj/structure/closet/crate/secure/weapon

/datum/supply_pack/security/armory/bulletarmor
	name = "防弹盔甲"
	desc = "内含三件防弹盔甲. \
		保证能将子弹的停止力减少一半以上."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/suit/armor/bulletproof = 3)
	crate_name = "防弹盔甲箱"

/datum/supply_pack/security/armory/bullethelmets
	name = "防弹头盔"
	desc = "内含三顶防弹头盔."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/head/helmet/alt = 3)
	crate_name = "防弹头盔箱"

/datum/supply_pack/security/armory/chemimp
	name = "'化学'植入物"
	desc = "内含五个远程'化学'植入物."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/storage/box/chemimp)
	crate_name = "远程'化学'植入物箱"

/datum/supply_pack/security/armory/ballistic
	name = "战术霰弹枪箱"
	desc = "当敌人眼里需要长铅弹的时候使用, \
		包含三把Aussec设计的战斗霰弹枪和子弹带."
	cost = CARGO_CRATE_VALUE * 17.5
	contains = list(/obj/item/gun/ballistic/shotgun/automatic/combat = 3,
					/obj/item/storage/belt/bandolier = 3)
	crate_name = "战术霰弹枪箱"

/datum/supply_pack/security/armory/dragnet
	name = "DRAGnet 网枪箱"
	desc = "全称\"动态快速拘捕罪犯\",DRAGnet是一种用于在追击战中发射网具快速逮捕罪犯的网枪, \
		是近年来执法工具的突破."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/gun/energy/e_gun/dragnet = 3)
	crate_name = "\improper 网枪箱"

/datum/supply_pack/security/armory/energy
	name = "SC-2 激光枪箱"
	desc = "SC-2是具有致命和非致命两种模式的激光枪，非常先进.\
		单次购买配送两把SC-2."
	cost = CARGO_CRATE_VALUE * 18
	contains = list(/obj/item/gun/energy/e_gun = 2)
	crate_name = "SC-2激光枪箱"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/laser_carbine
	name = "激光卡宾枪箱"
	desc = "三把射速极快的激光卡宾枪，缺点是威力较低."
	cost = CARGO_CRATE_VALUE * 9
	contains = list(/obj/item/gun/energy/laser/carbine = 3)
	crate_name = "激光卡宾枪箱"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/disabler_smg
	name = "镇暴型SMG箱"
	desc = "发射镇暴光束且射速极快的SMG，缺点是威力较低."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/gun/energy/disabler/smg = 3)
	crate_name = "镇暴SMG箱"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/exileimp
	name = "'流放'植入物"
	desc = "内含五个'流放'植入物."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/storage/box/exileimp)
	crate_name = "'流放'植入物箱"

/datum/supply_pack/security/armory/fire
	name = "燃烧武器箱"
	desc = "烧死他们，宝贝，\
		这里有燃烧弹、喷火器还有等离子！"
	cost = CARGO_CRATE_VALUE * 7
	access = ACCESS_COMMAND
	contains = list(/obj/item/flamethrower/full,
					/obj/item/tank/internals/plasma = 3,
					/obj/item/grenade/chem_grenade/incendiary = 3,
				)
	crate_name = "燃烧武器箱"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/security/armory/mindshield
	name = "'心盾'植入物"
	desc = "保护植入者免受洗脑、催眠等精神控制手段的植入物."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/storage/lockbox/loyalty)
	crate_name = "心盾植入物箱"

/datum/supply_pack/security/armory/trackingimp
	name = "'追踪'植入物"
	desc = "四个'追踪'植入物和.38 追踪弹."
	cost = CARGO_CRATE_VALUE * 4.5
	contains = list(/obj/item/storage/box/trackimp,
					/obj/item/ammo_box/c38/trac = 3,
				)
	crate_name = "'追踪'植入物箱"

/datum/supply_pack/security/armory/laserarmor
	name = "反射背心"
	desc = "反射背心由高反光材料制成，\
		可以将激光的能量减弱一半以上，并有很大概率完全反射激光，\
		单次购买配送两件."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/clothing/suit/armor/laserproof = 2)
	crate_name = "反射背心箱"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/riotarmor
	name = "防暴盔甲"
	desc = "包含三套重型防暴盔甲，\
		配有高级内衬,能够很好的抵御近战武器，能有效减轻一半的近战攻击伤害.\
		单次购买配送三件."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/clothing/suit/armor/riot = 3)
	crate_name = "防暴盔甲箱"

/datum/supply_pack/security/armory/riothelmets
	name = "防暴头盔"
	desc = "内含三顶防暴头盔."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/clothing/head/helmet/toggleable/riot = 3)
	crate_name = "防暴头盔箱"

/datum/supply_pack/security/armory/riotshields
	name = "防暴盾牌箱"
	desc = "内含三个防暴盾牌，无需畏惧灰潮袭来."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/shield/riot = 3)
	crate_name = "防暴盾牌箱"

/datum/supply_pack/security/armory/swat
	name = "SWAT装备"
	desc = "由IS-ERI和纳米传讯联合设计的防火SWAT全身套装，\
		每套有一件盔甲、头盔、面具和突击腰带以及大猩猩手套.\
		一次购买配送两套."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/clothing/head/helmet/swat/nanotrasen = 2,
					/obj/item/clothing/suit/armor/swat = 2,
					/obj/item/clothing/mask/gas/sechailer/swat = 2,
					/obj/item/storage/belt/military/assault = 2,
					/obj/item/clothing/gloves/tackler/combat = 2,
				)
	crate_name = "swat装备箱"

/datum/supply_pack/security/armory/thermal
	name = "热能手枪箱"
	desc = "包含两套枪套,每套枪套内含两把实验性热能手枪,\
		弹药使用纳米技术."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/storage/belt/holster/energy/thermal = 2)
	crate_name = "热能双枪箱"

/datum/supply_pack/security/sunglasses
	name = "太阳镜"
	desc = "一双防闪光的太阳镜."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/clothing/glasses/sunglasses = 1)
	crate_name = "太阳镜箱"

/datum/supply_pack/security/armory/beacon_imp
	name = "'信标'植入物"
	desc = "里面有五个'信标'植入物."
	cost = CARGO_CRATE_VALUE * 5.5
	contains = list(/obj/item/storage/box/beaconimp)
	crate_name = "'信标'植入物箱"

/datum/supply_pack/security/armory/teleport_blocker_imp
	name = "'蓝空接地'植入物"
	desc = "里面有五个'蓝空接地'植入物."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/storage/box/teleport_blocker)
	crate_name = "'蓝空接地'植入物箱"
