/datum/uplink_category/explosives
	name = "爆炸物"
	weight = 6

/datum/uplink_item/explosives
	category = /datum/uplink_category/explosives

/datum/uplink_item/explosives/soap_clusterbang
	name = "辛迪加肥皂集束炸弹"
	desc = "一种传统的集束炸弹，里面装得全都是辛迪加肥皂."
	item = /obj/item/grenade/clusterbuster/soap
	cost = 3

/datum/uplink_item/explosives/c4
	name = "C-4塑胶炸弹"
	desc = "C-4是一种常见的塑胶炸药，你可以用它来破墙破门，甚至炸毁重要设备. \
			使用方法就是单纯的粘到你的目标上，可以是任何东西甚至是活人. \
			你也可以改造它的引爆方式，设定引爆时间，最短十秒."
	item = /obj/item/grenade/c4
	cost = 1

/datum/uplink_item/explosives/c4bag
	name = "C-4炸弹包"
	desc = "有时候数量就是质量，内含十枚C-4塑胶炸药."
	item = /obj/item/storage/backpack/duffelbag/syndie/c4
	cost = 8 //20% discount!
	cant_discount = TRUE

/datum/uplink_item/explosives/x4bag
	name = "X-4炸弹包"
	desc = "内含三枚X-4型塑料炸药，定向爆破，威力很大. \
			X-4塑胶炸弹同样可以固定到任何物品表面，在破墙破门作业中，它不仅能破开障碍还会伤害障碍后的目标. \
			定向爆破的特性也使得使用者相对安全."
	progression_minimum = 20 MINUTES
	item = /obj/item/storage/backpack/duffelbag/syndie/x4
	cost = 4
	cant_discount = TRUE
/* //SKYRAT EDIT REMOVAL START
/datum/uplink_item/explosives/detomatix
	name = "Detomatix disk"
	desc = "When inserted into a tablet, this cartridge gives you four opportunities to \
			detonate tablets of crewmembers who have their message feature enabled. \
			The concussive effect from the explosion will knock the recipient out for a short period, and deafen them for longer."
	item = /obj/item/computer_disk/virus/detomatix
	cost = 6
	restricted = TRUE
*/ //SKYRAT REMOVAL END
/datum/uplink_item/explosives/emp
	name = "EMP手榴弹和植入物套件"
	desc = "一个装有五枚EMP手榴弹和一支EMP植入物的盒子."
	item = /obj/item/storage/box/syndie_kit/emp
	cost = 2

/datum/uplink_item/explosives/emp/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		cost *= 3

/datum/uplink_item/explosives/pizza_bomb
	name = "披萨炸弹"
	desc = "一盒披萨，盖子上巧妙地贴着一枚炸弹. \
			首先你需要开盒设置计时器，然后炸弹将在下次开盒时激活!"
	progression_minimum = 15 MINUTES
	item = /obj/item/pizzabox/bomb
	cost = 6
	surplus = 8

/datum/uplink_item/explosives/syndicate_minibomb
	name = "辛迪加迷你炸弹"
	desc = "迷你炸弹是一枚手榴弹，有五秒的引信. \
			一旦引爆，能对附近人员造成大量伤害并造成船体缺口."
	progression_minimum = 30 MINUTES
	item = /obj/item/grenade/syndieminibomb
	cost = 6
	purchasable_from = ~UPLINK_CLOWN_OPS


/datum/uplink_item/explosives/syndicate_bomb/emp
	name = "辛迪加EMP炸弹"
	desc = "辛迪加炸弹的一种变体，旨在产生巨大的电磁脉冲效应."
	item = /obj/item/sbeacondrop/emp
	cost = 7

/datum/uplink_item/explosives/syndicate_bomb/emp/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		cost *= 2

/datum/uplink_item/explosives/syndicate_bomb
	name = "辛迪加炸弹"
	desc = "辛迪加炸弹是一种具有巨大破坏力的可怕装置，带有一个可调节的定时器，最短可以设置为%MIN_BOMB_TIMER秒， \
		如果想要它固定在某个地方，可以使用扳手拧紧炸弹上的地板螺栓.\
		炸弹的体积庞大，无法被收纳或拿在手中，只能通过推或者拖动移动. \
		因此我们会先发送给你一个小体积的位置信标，你在需要使用的时候激活该信标，\
		炸弹将传送到你的位置，此外，炸弹是可能被拆除的. \
		炸弹的核心可以撬出来，并与其他爆炸物一起手动引爆."
	progression_minimum = 30 MINUTES
	item = /obj/item/sbeacondrop/bomb
	cost = 11

/datum/uplink_item/explosives/syndicate_bomb/New()
	. = ..()
	desc = replacetext(desc, "%MIN_BOMB_TIMER", SYNDIEBOMB_MIN_TIMER_SECONDS)
