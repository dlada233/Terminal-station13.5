
// Clown Operative Stuff
// Maybe someday, someone will care to maintain this

/datum/uplink_item/weapon_kits/pie_cannon
	name = "香蕉奶油派连射大炮"
	desc = "这款特殊的馅饼大炮是为一个特殊小丑设计的，它可以容纳20个馅饼，并且每两秒钟自动制作一个馅饼!"
	cost = 10
	item = /obj/item/pneumatic_cannon/pie/selfcharge
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/weapon_kits/bananashield
	name = "香蕉能量盾"
	desc = "一个小丑最强大的防御武器，这种能量盾对远程能量攻击具有近乎免疫的防御力，可以将攻击反弹回发射它们的人身上. \
		它也可以通过投掷使用，被击中的人将滑到，然后盾牌在它们身上反弹，最终还会回到你的身上. \
		警告：在使用时不要试图站在盾牌上，即使穿着防滑鞋也一样."
	item = /obj/item/shield/energy/bananium
	cost = 16
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/weapon_kits/clownsword
	name = "香蕉能量剑"
	desc = "一把能量剑，但不会造成任何伤害. \
		任何接触的到它的人，哪怕只是不小心踩上去的，都会不可避免地滑到，穿戴什么装备都没有用."
	item = /obj/item/melee/energy/sword/bananium
	cost = 3
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/weapon_kits/clownoppin
	name = "超级搞笑的撞针"
	desc = "一个撞针，当安装到枪里时，这把枪只能被小丑和笨手笨脚的人使用，而且当有任何人试图开枪时，这把枪会发出喇叭声."
	cost = 1 //much cheaper for clown ops than for clowns
	item = /obj/item/firing_pin/clown/ultra
	purchasable_from = UPLINK_CLOWN_OPS
	illegal_tech = FALSE

/datum/uplink_item/weapon_kits/clownopsuperpin
	name = "超级超级搞笑的撞针"
	desc = "一个比超级搞笑还要搞笑的撞针，当安装到枪里时，除了小丑和笨手笨脚的人之外开枪都会让这把枪爆炸."
	cost = 4 //much cheaper for clown ops than for clowns
	item = /obj/item/firing_pin/clown/ultra/selfdestruct
	purchasable_from = UPLINK_CLOWN_OPS
	illegal_tech = FALSE

/datum/uplink_item/weapon_kits/foamsmg
	name = "玩具冲锋枪"
	desc = "装满子弹的Donksoft bullpup冲锋枪，可发射防暴级泡沫弹，自带有20发的弹匣."
	item = /obj/item/gun/ballistic/automatic/c20r/toy
	cost = 5
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/weapon_kits/foammachinegun
	name = "玩具机关枪"
	desc = "一把满膛的Donksoft背带机枪，带有50发的大容量弹匣，里面是\
		防暴极的毁灭性泡沫弹，一发就能让一个人暂时瘫痪."
	item = /obj/item/gun/ballistic/automatic/l6_saw/toy
	cost = 10
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/explosives/bombanana
	name = "香蕉炸弹"
	desc = "一根会爆炸的芭拿拿！\
		香蕉皮将在你吃掉香蕉后的几秒内引爆，其威力堪比辛迪加迷你炸弹."
	item = /obj/item/food/grown/banana/bombanana
	cost = 4 //it is a bit cheaper than a minibomb because you have to take off your helmet to eat it, which is how you arm it
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/explosives/clown_bomb_clownops
	name = "小丑炸弹"
	desc = "小丑炸弹是一种引发大规模恶作剧的搞笑装置，带有一个调节的定时器，最短可以设置为%MIN_BOMB_TIMER秒， \
		如果想要它固定在某个地方，可以使用扳手拧紧炸弹上的地板螺栓.\
		炸弹的体积庞大，无法被收纳或拿在手中，只能通过推或者拖动移动. \
		因此我们会先发送给你一个小体积的位置信标，你在需要使用的时候激活该信标，炸弹将传送到你的位置. \
		此外，炸弹是可能被拆除的."
	item = /obj/item/sbeacondrop/clownbomb
	cost = 15
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/explosives/clown_bomb_clownops/New()
	. = ..()
	desc = replacetext(desc, "%MIN_BOMB_TIMER", SYNDIEBOMB_MIN_TIMER_SECONDS)

/datum/uplink_item/explosives/tearstache
	name = "胡子手榴弹"
	desc = "这是一枚催泪弹，特色是它能把黏糊糊的胡子喷到碰到任何不佩戴小丑或哑剧面具的人脸上. \
		这些胡子将附着在目标脸上一分钟，在此期间内该目标没法带上呼吸面罩或其他类似设备."
	item = /obj/item/grenade/chem_grenade/teargas/moustache
	cost = 3
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/explosives/pinata
	name = "实战型皮纳塔工具包"
	desc = "一个装满糖果和炸药的皮纳塔，以及两条携带它们的腰带，邀请人们捶打它，看看你会得到什么!"
	item = /obj/item/storage/box/syndie_kit/pinata
	purchasable_from = UPLINK_CLOWN_OPS
	limited_stock = 1
	cost = 12 //This is effectively the clown ops version of the grenadier belt where you should on average get 8 explosives if you use a weapon with exactly 10 force.
	surplus = 0

/datum/uplink_item/reinforcement/clown_reinforcement
	name = "小丑增援"
	desc = "再呼叫一个小丑来分享快乐，他将配备完整的初始装备，但没有Tc."
	item = /obj/item/antag_spawner/nuke_ops/clown
	cost = 20
	purchasable_from = UPLINK_CLOWN_OPS
	restricted = TRUE
	refundable = TRUE

/datum/uplink_item/reinforcement/monkey_agent
	name = "猴特工增援"
	desc = "从辛迪加香蕉部找一个训练有素的猴子特工来，它擅长操作机器和做一些灵活向工作. \
		唯一的缺点是它们不会说我们的语言."
	item = /obj/item/antag_spawner/loadout/monkey_man
	cost = 7
	purchasable_from = UPLINK_CLOWN_OPS
	restricted = TRUE
	refundable = TRUE

/datum/uplink_item/reinforcement/monkey_supplies
	name = "猴特工补给"
	desc = "比一个训练有素的猴子特工更好的是什么？一个训练有素的武装猴子特工! \
		猴子们可以打开这个补给包，得到一些枪支弹药以及其他杂项用品."
	item = /obj/item/storage/toolbox/guncase/monkeycase
	cost = 4
	purchasable_from = UPLINK_CLOWN_OPS
	restricted = TRUE
	refundable = TRUE

/datum/uplink_item/mech/honker
	name = "Dark H.O.N.K."
	desc = "一个小丑战斗机甲配备bombanana peel和催泪榴弹发射器，以及无处不在的HoNkER BlAsT 5000."
	item = /obj/vehicle/sealed/mecha/honker/dark/loaded
	cost = 80
	purchasable_from = UPLINK_CLOWN_OPS

/* // SKYRAT EDIT REMOVAL START
/datum/uplink_item/stealthy_tools/combatbananashoes
	name = "Combat Banana Shoes"
	desc = "While making the wearer immune to most slipping attacks like regular combat clown shoes, these shoes \
		can generate a large number of synthetic banana peels as the wearer walks, slipping up would-be pursuers. They also \
		squeak significantly louder."
	item = /obj/item/clothing/shoes/clown_shoes/banana_shoes/combat
	cost = 6
	surplus = 0
	purchasable_from = UPLINK_CLOWN_OPS
*/ // SKYRAT EDIT REMOVAL END

/datum/uplink_item/badass/clownopclumsinessinjector //clowns can buy this too, but it's in the role-restricted items section for them
	name = "笨手笨脚注射器"
	desc = "给自己注射这个，会让自己变得像小丑一样笨手笨脚...或者给别人注射，让他们像小丑一样笨手笨脚，传奇的小丑特工往往是将猎物折磨戏耍致死."
	item = /obj/item/dnainjector/clumsymut
	cost = 1
	purchasable_from = UPLINK_CLOWN_OPS
	illegal_tech = FALSE
