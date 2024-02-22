/datum/supply_pack/emergency
	group = "应急用品"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/emergency/bio
	name = "应急生物防化补给"
	desc = "这个箱子里有两套完整的生物防护服，可以保护你免受病毒的侵害."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/bio_hood = 2,
					/obj/item/clothing/suit/bio_suit = 2,
					/obj/item/storage/bag/bio,
					/obj/item/reagent_containers/syringe/antiviral = 2,
					/obj/item/clothing/gloves/latex/nitrile = 2,
				)
	crate_name = "生物防化服箱"

/datum/supply_pack/emergency/equipment
	name = "应急机器人补给"
	desc = "发生了爆炸事件? 这些补给可以让你快速修补站点和救助人们，\
		这些补给可以让你快速修补站点和治疗人们，\
		内含两个地板机器人、两个医疗机器人、五个氧气面罩和五个氧气瓶."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/mob/living/basic/bot/medbot = 2,
		/mob/living/simple_animal/bot/floorbot = 2,
		/obj/item/tank/internals/emergency_oxygen = 5,
		/obj/item/clothing/mask/breath = 5,
	)
	crate_name = "应急机器人箱"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/bomb
	name = "应急爆炸补给"
	desc = "科研部已经疯了？在气阀门后传来了哔哔声？现在就买！成为拯救站点的拆弹英雄！\
		里面有一件防爆服和配套头盔、防毒面具和拆弹工具."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/utility/bomb_hood,
					/obj/item/clothing/suit/utility/bomb_suit,
					/obj/item/clothing/mask/gas,
					/obj/item/screwdriver,
					/obj/item/wirecutters,
					/obj/item/multitool,
				)
	crate_name = "防爆服箱"

/datum/supply_pack/emergency/firefighting
	name = "应急消防补给"
	desc = "只有你才能拯救站点于火海之中，\
		搭配两套消防服、防毒面具、手电筒、大氧气瓶、灭火器和安全帽!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/suit/utility/fire/firefighter = 2,
					/obj/item/clothing/mask/gas = 2,
					/obj/item/flashlight = 2,
					/obj/item/tank/internals/oxygen/red = 2,
					/obj/item/extinguisher/advanced = 2,
					/obj/item/clothing/head/utility/hardhat/red = 2,
				)
	crate_name = "消防用品箱"

/datum/supply_pack/emergency/atmostank
	name = "背式消防水箱"
	desc = "用这个高容量的背式消防水箱扑灭大火."
	cost = CARGO_CRATE_VALUE * 1.8
	access = ACCESS_ATMOSPHERICS
	contains = list(/obj/item/watertank/atmos)
	crate_name = "背式消防水箱补给箱"
	crate_type = /obj/structure/closet/crate/secure/engineering/atmos

/datum/supply_pack/emergency/internals
	name = "呼吸配件应急补给"
	desc = "掌握你的生命能量，控制你的呼吸，最终你就学会了波纹呼吸法，\
		内含三个呼吸面罩、三个应急氧气瓶和三个大气瓶." // IS THAT A
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/mask/gas = 3,
					/obj/item/clothing/mask/breath = 3,
					/obj/item/tank/internals/emergency_oxygen = 3,
					/obj/item/tank/internals/oxygen = 3,
				)
	crate_name = "呼吸配件箱"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/metalfoam
	name = "金属泡沫手榴弹补给"
	desc = "用七枚金属泡沫手榴弹把那些讨厌的船体裂口封上."
	cost = CARGO_CRATE_VALUE * 2.4
	contains = list(/obj/item/storage/box/metalfoam)
	crate_name = "金属泡沫手榴弹箱"

/datum/supply_pack/emergency/plasma_spacesuit
	name = "等离子人环境保护服补给"
	desc = "内含两套等离子人环境保护服装，\
		现在订购还附赠两个头盔!"
	cost = CARGO_CRATE_VALUE * 3.5
	access = ACCESS_EVA
	contains = list(/obj/item/clothing/suit/space/eva/plasmaman = 2,
					/obj/item/clothing/head/helmet/space/plasmaman = 2,
				)
	crate_name = "等离子人EVA套装箱"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/emergency/plasmaman
	name = "等离子人补给包"
	desc = "用这两套等离子人装备让这些等离子人活下来. \
		每份包含一套等离子连体衣、手套、呼吸瓶和头盔."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/under/plasmaman = 2,
					/obj/item/tank/internals/plasmaman/belt/full = 2,
					/obj/item/clothing/head/helmet/space/plasmaman = 2,
					/obj/item/clothing/gloves/color/plasmaman = 2,
				)
	crate_name = "等离子人补给箱"

/datum/supply_pack/emergency/radiation
	name = "辐射防护箱"
	desc = "靠这两套防辐射服在核事故与超物质引擎故障中活下来.\
		每份包含一个头盔、套装和盖革计数器，我们还附赠一瓶伏特加和一些杯子，\
		这都是出于我们对客户剩余寿命方面的关怀."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/utility/radiation = 2,
					/obj/item/clothing/suit/utility/radiation = 2,
					/obj/item/geiger_counter = 2,
					/obj/item/reagent_containers/cup/glass/bottle/vodka,
					/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass = 2,
				)
	crate_name = "辐射防护箱"
	crate_type = /obj/structure/closet/crate/radiation

/datum/supply_pack/emergency/spacesuit
	name = "宇航服补给"
	desc = "内含一件Space-Goodwill公司的老化宇航服和喷气背包."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_EVA
	contains = list(/obj/item/clothing/suit/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/mask/breath,
					/obj/item/tank/jetpack/carbondioxide,
				)
	crate_name = "宇航服补给箱"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/emergency/weedcontrol
	name = "除草应急补给"
	desc = "将入侵植物拒之门外，内含一把镰刀，一双皮手套，一个防毒面具，还有两枚除草化学手榴弹. \
		若违法用途则保修无效."
	cost = CARGO_CRATE_VALUE * 2.5
	access = ACCESS_HYDROPONICS
	contains = list(/obj/item/scythe,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/mask/gas,
					/obj/item/grenade/chem_grenade/antiweed = 2,
				)
	crate_name = "除草补给箱"
	crate_type = /obj/structure/closet/crate/secure/hydroponics

/datum/supply_pack/emergency/mothic_rations
	name = "蛾类应急口粮补给"
	desc = "船员挨饿? 厨师罢工?\
		这些来自蛾族舰队的多余口粮包可供购买，内含三盒，每盒三包."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/mothic_rations = 3)
	crate_name = "应急口粮箱"
	crate_type = /obj/structure/closet/crate/cardboard/mothic
