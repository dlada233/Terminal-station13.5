// Nuclear Operative Weapons and Ammunition

/datum/uplink_category/weapon_kits
	name = "武器组合 (推荐)"
	weight = 30

/datum/uplink_item/weapon_kits
	category = /datum/uplink_category/weapon_kits
	surplus = 40
	purchasable_from = UPLINK_NUKE_OPS

// ~~ Ammunition Categories ~~

/datum/uplink_category/ammo_nuclear
	name = "弹药"
	weight = 29

/datum/uplink_item/ammo_nuclear
	category = /datum/uplink_category/ammo_nuclear
	surplus = 40
	purchasable_from = UPLINK_NUKE_OPS

// Basic: Run of the mill ammunition for various firearms
/datum/uplink_item/ammo_nuclear/basic
	cost = 2

// Armor Penetrating: strong into armor, low damage
/datum/uplink_item/ammo_nuclear/ap
	cost = 4

// Hollow Point: weak into armor, high damage
/datum/uplink_item/ammo_nuclear/hp
	cost = 4

// Incendiary: sets target on fire, does less damage
/datum/uplink_item/ammo_nuclear/incendiary
	cost = 3

// Special: does something particularly extra than just any of the above
/datum/uplink_item/ammo_nuclear/special
	cost = 5

// ~~ Weapon Categories ~~

// Core Gear Box: This contains all the 'fundamental' equipment that most nuclear operatives probably should be buying. It isn't cheaper, but it is a quick and convenient method of acquiring all the gear necessary immediately.
// Only allows one purchase, and doesn't prevent the purchase of the contained items. Focused on newer players to help them understand what items they need to succeed, and to help older players quickly purchase the baseline gear they need.

/datum/uplink_item/weapon_kits/core
	name = "标准装备组(基本)"
	desc = "盒子里包含气闸认证覆写卡，能量防护模块，C-4炸药，自由植入物和加速剂. \
		这写都是大多数特工通常需要用到的装备，我们强烈建议你在没有特别计划的情况下购买. \
		注: 此捆绑包没有折扣，你单独购买也是一样的."
	item = /obj/item/storage/box/syndie_kit/core_gear
	cost = 22 //freedom 5, doormag 3, c-4 1, stimpack 5, shield modsuit module 8
	limited_stock = 1
	cant_discount = TRUE
	purchasable_from = UPLINK_NUKE_OPS

//Low-cost firearms: Around 8 TC each. Meant for easy squad weapon purchases

/datum/uplink_item/weapon_kits/low_cost
	cost = 8
	surplus = 40
	purchasable_from = UPLINK_NUKE_OPS

// ~~ Bulldog Shotgun ~~

/datum/uplink_item/weapon_kits/low_cost/shotgun
	name = "斗牛犬霰弹枪 (Moderate)"
	desc = "斗牛犬霰弹枪是一把半自动双弹鼓式霰弹枪，在枪身上有详细的使用说明. \
		兼容所有12g霰弹，设计用于近距离交战，购买还附带三个备用弹匣."
	item = /obj/item/storage/toolbox/guncase/bulldog

/datum/uplink_item/ammo_nuclear/basic/buck
	name = "12g霰弹鼓(斗牛犬)"
	desc = "一个8发霰弹鼓，用于斗牛犬霰弹枪."
	item = /obj/item/ammo_box/magazine/m12g
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

/datum/uplink_item/ammo_nuclear/basic/slug
	name = "12g独头弹鼓(斗牛犬)"
	desc = "一个8发独头弹鼓，用于牛头犬霰弹枪，\
		现在友伤的可能性降低了8倍."
	item = /obj/item/ammo_box/magazine/m12g/slug
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

/datum/uplink_item/ammo_nuclear/incendiary/dragon
	name = "12g龙息弹鼓(斗牛犬)"
	desc = "一个8发龙息弹鼓，用于牛头犬霰弹枪. \
		'I'm a fire starter, twisted fire starter!'"
	item = /obj/item/ammo_box/magazine/m12g/dragon
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

/datum/uplink_item/ammo_nuclear/special/meteor
	name = "12g穿墙独头弹鼓(斗牛犬)"
	desc = "一个8发穿墙独头弹鼓，用于牛头犬霰弹枪."
	item = /obj/item/ammo_box/magazine/m12g/meteor
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

// ~~ Ansem Pistol ~~

/datum/uplink_item/weapon_kits/low_cost/clandestine
	name = "安瑟姆手枪(Easy/Spare)"
	desc = "一种小型的，易于隐藏的手枪，打10毫米子弹，弹匣容量8发；\
			可以安装消音器，现在购买附赠三个备用弹匣."
	item = /obj/item/storage/toolbox/guncase/clandestine

/datum/uplink_item/ammo_nuclear/basic/m10mm
	name = "10mm手枪弹匣 (安瑟姆)"
	desc = "一个额外的8发10毫米弹匣，与安瑟姆手枪兼容."
	item = /obj/item/ammo_box/magazine/m10mm
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

/datum/uplink_item/ammo_nuclear/ap/m10mm
	name = "10mm穿甲弹匣 (安瑟姆)"
	desc = "一个额外的8发10毫米弹匣，与安瑟姆手枪兼容。 \
		这种子弹伤害肉体的效果较差，但能穿透护甲."
	item = /obj/item/ammo_box/magazine/m10mm/ap
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

/datum/uplink_item/ammo_nuclear/hp/m10mm
	name = "10mm空尖弹匣 (安瑟姆)"
	desc = "一个额外的8发10毫米弹匣，与安瑟姆手枪兼容. \
		这种子弹对肉体杀伤力更强，但对装甲无效."
	item = /obj/item/ammo_box/magazine/m10mm/hp
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

/datum/uplink_item/ammo_nuclear/incendiary/m10mm
	name = "10mm燃烧弹匣 (安瑟姆)"
	desc = "一个额外的8发10毫米弹匣，与安瑟姆手枪兼容. \
		这种子弹只能造成较小的伤害，但能点燃目标."
	item = /obj/item/ammo_box/magazine/m10mm/fire
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

//Medium-cost: 14 TC each. Meant for more expensive purchases with a goal in mind.

/datum/uplink_item/weapon_kits/medium_cost
	cost = 14
	surplus = 20
	purchasable_from = UPLINK_NUKE_OPS

// ~~ C-20r Submachine Gun ~~

/datum/uplink_item/weapon_kits/medium_cost/smg
	name = "C-20r 冲锋枪 (Easy)"
	desc = "一把装满子弹的冲锋枪，打.45口径子弹，弹匣容量24发；\
		可以安装消音器，现在购买附赠三个备用弹匣."
	item = /obj/item/storage/toolbox/guncase/c20r

/datum/uplink_item/ammo_nuclear/basic/smg
	name = ".45冲锋枪弹匣 (C-20r)"
	desc = "一个额外的24发.45弹匣，适用于C-20r冲锋枪."
	item = /obj/item/ammo_box/magazine/smgm45

/datum/uplink_item/ammo_nuclear/ap/smg
	name = ".45穿甲弹匣 (C-20r)"
	desc = "一个额外的24发.45弹匣，适用于C-20r冲锋枪.\
		这种子弹伤害肉体的效果较差，但能穿透护甲."
	item = /obj/item/ammo_box/magazine/smgm45/ap

/datum/uplink_item/ammo_nuclear/hp/smg
	name = ".45空尖弹匣 (C-20r)"
	desc = "一个额外的24发.45弹匣，适用于C-20r冲锋枪.\
		这种子弹对肉体杀伤力更强，但对装甲无效."
	item = /obj/item/ammo_box/magazine/smgm45/hp

/datum/uplink_item/ammo_nuclear/incendiary/smg
	name = ".45燃烧弹匣 (C-20r)"
	desc = "一个额外的24发.45弹匣，适用于C-20r冲锋枪.\
		这种子弹只能造成较小的伤害，但能点燃目标."
	item = /obj/item/ammo_box/magazine/smgm45/incen
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS

// ~~ Energy Sword and Shield & CQC ~~

/datum/uplink_item/weapon_kits/medium_cost/sword_and_board
	name = "能量剑与能量盾 (Very Hard)"
	desc = "一个装有能量剑和能量盾的箱子，它们组合在一起防御性能很棒，但在进攻方面就稍差了一些. \
		非常适合想要建立功业的骑士，为此我们还附赠一个中世纪头盔!"
	item = /obj/item/storage/toolbox/guncase/sword_and_board

/datum/uplink_item/weapon_kits/medium_cost/cqc
	name = "CQC装备套件 (Very Hard)"
	desc = "包含CQC指导手册，隐形植入物，一包烟和一条时髦的头带."
	item = /obj/item/storage/toolbox/guncase/cqc
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	surplus = 0

// ~~ Syndicate Revolver ~~
// Nuclear operatives get a special deal on their revolver purchase compared to traitors.

/datum/uplink_item/weapon_kits/medium_cost/revolvercase
	name = "辛迪加左轮 (Moderate)"
	desc = "Waffle公司设计的辛迪加左轮，打.357马格南子弹，弹巢容量七发. \
		经典的特工武器来到了现代战场上，现在购买还赠送3个填满的.357快速装弹器."
	item = /obj/item/storage/toolbox/guncase/revolver

/datum/uplink_item/ammo_nuclear/basic/revolver
	name = ".357快速装弹器 (左轮)"
	desc = "一个装有7发.357马格南子弹的快速装弹器，可用于辛迪加左轮. \
		当你真的很多东西死掉的时候..."
	item = /obj/item/ammo_box/a357
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

/datum/uplink_item/ammo_nuclear/special/revolver/phasic
	name = ".357相位弹 快速装弹器 (左轮)"
	desc = "一个装有7发.357相位弹的快速装弹器，可用于辛迪加左轮. \
		这些子弹是由一种名为“幽灵铅”的实验合金制成的，这种合金几乎可以穿透任何非有机材料. \
		但别被这个名字误导了，它实际上不含任何铅!"
	item = /obj/item/ammo_box/a357/phasic
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

/datum/uplink_item/ammo_nuclear/special/revolver/heartseeker
	name = ".357寻心弹 快速装弹器 (左轮)"
	desc = "一个装有7发.357寻心弹的快速装弹器，可用于辛迪加左轮. \
		寻心弹在发射后可以直接转向目标，只要目标心脏还在跳动就行."
	item = /obj/item/ammo_box/a357/heartseeker
	cost = 3
	purchasable_from = parent_type::purchasable_from | UPLINK_SPY

// ~~ Grenade Launcher ~~
// 'If god had wanted you to live, he would not have created ME!'

/datum/uplink_item/weapon_kits/medium_cost/rawketlawnchair
	name = "84mm 火箭推进榴弹发射器 (Hard)"
	desc = "一种可重复使用的火箭推进榴弹发射器，预装一枚低当量呃84毫米HE弹 \
		保证把你的目标轰出去或者把你的钱还给你!附带一束备用火箭弹!"
	item = /obj/item/storage/toolbox/guncase/rocketlauncher

/datum/uplink_item/ammo_nuclear/basic/rocket
	name = "84mm HE弹束 (火箭发射器)"
	desc = "三枚低当量杀伤性HE火箭捆绑在一起，我要把你干掉!"
	item = /obj/item/ammo_box/rocket

/datum/uplink_item/ammo_nuclear/ap/rocket
	name = "84mm HEAP弹束 (火箭发射器)"
	desc = "一枚大威力的HEAP火箭弹， 对目标和目标附近的一切物体都很有效. \
			他们将知晓恐惧！"
	item = /obj/item/ammo_casing/rocket/heap

//High-cost: 18 TC each. Really should only be coming out during war for how powerful it is, or be the majority of your TC outside of war.

/datum/uplink_item/weapon_kits/high_cost
	cost = 18
	surplus = 10
	purchasable_from = UPLINK_NUKE_OPS

// ~~ L6 SAW Machine Gun ~~

/datum/uplink_item/weapon_kits/high_cost/machinegun
	name = "L6 SAW 班用轻机枪 (Moderate)"
	desc = "一把装满子弹的轻机枪，打7.12x82mm子弹，弹匣容量50发." //SKYRAT EDIT - AUSSEC TO SCARBOROUGH
	item = /obj/item/gun/ballistic/automatic/l6_saw

/datum/uplink_item/ammo_nuclear/basic/machinegun
	name = "7mm 弹匣 (L6 SAW)"
	desc = "装了50发7毫米子弹的弹匣，用于L6 SAW. \
		当你需要用这个的时候，你已经站在一堆尸体上了."
	item = /obj/item/ammo_box/magazine/m7mm

/datum/uplink_item/ammo_nuclear/ap/machinegun
	name = "7mm (穿甲弹) 弹匣 (L6 SAW)"
	desc = "装了50发7毫米子弹的弹匣，用于L6 SAW. \
		能穿透最坚固的盔甲."
	item = /obj/item/ammo_box/magazine/m7mm/ap

/datum/uplink_item/ammo_nuclear/hp/machinegun
	name = "7mm (空尖弹) 弹匣 (L6 SAW)"
	desc = "装了50发7毫米子弹的弹匣，用于L6 SAW. \
		对没有护甲的人来说尤为致命."
	item = /obj/item/ammo_box/magazine/m7mm/hollow

/datum/uplink_item/ammo_nuclear/incendiary/machinegun
	name = "7mm (燃烧弹) 弹匣 (L6 SAW)"
	desc = "装了50发7毫米子弹的弹匣，用于L6 SAW. \
		弹头尖端上涂满了易燃的混合物."
	item = /obj/item/ammo_box/magazine/m7mm/incen

/datum/uplink_item/ammo_nuclear/special/machinegun
	name = "7mm (竞赛弹) 弹匣 (L6 SAW)"
	desc = "装了50发7毫米子弹的弹匣，用于L6 SAW. 你都不知道我们还有竞赛级别的精确橡胶弹药，\
		这些子弹经过精心调整，不减弱威力的同时还可以完美地在墙上弹跳."
	item = /obj/item/ammo_box/magazine/m7mm/match

// ~~ M-90gl Carbine ~~

/datum/uplink_item/weapon_kits/high_cost/carbine
	name = "M-90gl 卡宾枪 (Hard)"
	desc = "M-90gl卡宾枪是一种使用三连射爆炸开火模式的卡宾枪，它发射.223子弹，弹匣容量30发，同时配有40毫米下挂榴弹. \
		预装有一发爆炸榴弹，你可以按右键发射它. 现在购买我们还附赠两个弹匣和一盒橡胶榴弹. \
		and a box of 40mm rubber slugs."
	item = /obj/item/storage/toolbox/guncase/m90gl

/datum/uplink_item/ammo_nuclear/basic/carbine
	name = ".223 顶装弹匣 (M-90gl)"
	desc = "一个额外的30发.223弹匣，适合使用M-90gl卡宾枪. \
		.223子弹比7毫米子弹的威力小，但由于其固有的穿甲能力，它们仍然比.45弹药提供更大的威力. "
	item = /obj/item/ammo_box/magazine/m223

/datum/uplink_item/ammo_nuclear/special/carbine
	name = ".223 顶装穿甲弹匣 (M-90gl)"
	desc = "一个额外的30发.223弹匣，适合使用M-90gl卡宾枪. \
		这些子弹是由一种名为“幽灵铅”的实验合金制成的，这种合金几乎可以穿透任何非有机材料. \
		但别被这个名字误导了，它实际上不含任何铅!"
	item = /obj/item/ammo_box/magazine/m223/phasic

/datum/uplink_item/ammo_nuclear/basic/carbine/a40mm
	name = "40mm 榴弹箱 (M-90gl)"
	desc = "一箱40毫米HE榴弹，用于M-90gl的下挂榴弹发射器. \
		你的队友会要求你不要在小走廊上射击. \
		但无论如何你还是会这么干的."
	item = /obj/item/ammo_box/a40mm

// ~~ Anti-Materiel Sniper Rifle ~~

/datum/uplink_item/weapon_kits/high_cost/sniper
	name = "反器材狙击步枪 (Hard)"
	desc = "有些过时但仍然强力的反器材狙击步枪，打.50 BMG，弹匣容量为6发. \
		可以安装消音器，如果有人问这怎么做到的，那么告诉他们都是纳米的错. \
		现在订购将直接给你一个公文包，里面有枪、三个备用弹匣和杀手的西装与领带."
	item = /obj/item/storage/briefcase/sniper

/datum/uplink_item/ammo_nuclear/basic/sniper
	name = ".50 BMG 弹匣 (反器材狙)"
	desc = "一个额外的标准6发弹匣，用于.50狙击步枪."
	item = /obj/item/ammo_box/magazine/sniper_rounds

/datum/uplink_item/ammo_nuclear/basic/sniper/surplussniper
	name = ".50 BMG 批发弹药盒 (反器材狙)"
	desc = "一盒子批发.50 BMG弹匣，质量不如一般的弹匣，但胜在量多，可以购买来供整个小队使用."
	cost = 7 //1 TC per magazine, special price for a special deal!
	item = /obj/item/storage/box/syndie_kit/sniper_surplus

/datum/uplink_item/ammo_nuclear/ap/sniper/penetrator
	name = ".50 BMG 贯穿弹匣 (反器材狙)"
	desc = "一个额外的标准6发弹匣，用于.50狙击步枪. \
		可以穿透墙壁和复数敌人."
	item = /obj/item/ammo_box/magazine/sniper_rounds/penetrator

/datum/uplink_item/ammo_nuclear/incendiary/sniper
	name = ".50 BMG 燃烧弹匣 (反器材狙)"
	desc = "一个额外的标准6发弹匣，用于.50狙击步枪. \
		让你的敌人和他们身边的人熊熊燃烧!"
	item = /obj/item/ammo_box/magazine/sniper_rounds/incendiary

/datum/uplink_item/ammo_nuclear/basic/sniper/disruptor
	name = ".50 BMG 干扰弹匣 (反器材狙)"
	desc = "一个额外的标准6发弹匣，用于.50狙击步枪. \
		今天让你的敌人昏睡不止!"
	item = /obj/item/ammo_box/magazine/sniper_rounds/disruptor

/datum/uplink_item/ammo_nuclear/special/sniper/marksman
	name = ".50 BMG 射手弹匣 (反器材狙)"
	desc = "一个额外的标准6发弹匣，用于.50狙击步枪. \
		这种子弹把弹速提升至了极限."
	item = /obj/item/ammo_box/magazine/sniper_rounds/marksman

/datum/uplink_item/weapon_kits/high_cost/doublesword
	name = "双刃能量剑 (Very Hard)"
	desc = "购买后得到的补给箱里有一把双刃能量剑、防滑模块、冰毒注射器还有一块肥皂. \
		有人说，最臭名昭著的核特工利用这种设备组合屠杀了数百名纳米员工. \
		这其中肥皂起了很大作用，以及我们赠送的囚服."
	item = /obj/item/storage/toolbox/guncase/doublesword

//Meme weapons: Literally just weapons used as a joke, shouldn't be particularly expensive.

/datum/uplink_item/weapon_kits/surplus_smg
	name = "堆在角落的冲锋枪 (Flukie)"
	desc = "一种过时的自动武器，你为什么要用这个?"
	item = /obj/item/gun/ballistic/automatic/plastikov
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo_nuclear/surplus_smg
	name = "堆在角落的冲锋枪弹匣 (Surplus)"
	desc = "为PP-95冲锋枪设计的圆柱形弹匣."
	item = /obj/item/ammo_box/magazine/plastikov9mm
	cost = 1
	purchasable_from = UPLINK_NUKE_OPS
	illegal_tech = FALSE

// Explosives and Grenades
// ~~ Grenades ~~

/datum/uplink_item/explosives/grenades
	cost = 15
	surplus = 35
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/explosives/grenades/buzzkill
	name = "杀人蜂手榴弹"
	desc = "一个装有三枚手榴弹的盒子，激活后会释放一群愤怒的蜜蜂，这些蜜蜂用随机的毒素不分青红皂白地攻击所有人，\
		由BLF和Tiger Cooperative联合生产."
	item = /obj/item/storage/box/syndie_kit/bee_grenades

/datum/uplink_item/explosives/grenades/virus_grenade
	name = "真菌结核手榴弹"
	desc = "盒子中有一枚可以散播真菌结核感染的手榴弹，此外全都是该生化武器的解药(BVAK).\
		包含五支BVAK注射器和BVAK药瓶."
	item = /obj/item/storage/box/syndie_kit/tuberculosisgrenade
	restricted = TRUE

/datum/uplink_item/explosives/grenades/viscerators
	name = "刀片无人机手榴弹"
	desc = "三枚刀片无人机手榴弹，引爆后会部署一群刀片无人机，猎杀该地区任何非特工人员."
	item = /obj/item/storage/box/syndie_kit/manhack_grenades

// ~~ Grenadier's Belt Kit ~~

/datum/uplink_item/weapon_kits/high_cost/grenadier
	name = "掷弹腰带与榴弹发射器 (Hard)"
	desc = "一条包含26枚各式手榴弹的腰带，以及一个发射它们的榴弹发射器，附赠多功能工具和螺丝刀."
	item = /obj/item/storage/box/syndie_kit/demoman
	purchasable_from = UPLINK_NUKE_OPS

// ~~ Detonator: In case you lose the old one ~~

/datum/uplink_item/explosives/syndicate_detonator
	name = "辛迪加起爆器"
	desc = "辛迪加引爆器是辛迪加炸弹的配套装置，只需轻轻按下，加密的无线电频率将指示所有辛迪加炸弹引爆. \
		在您希望多个炸弹同步爆炸或想要快速引爆时会派上用场；在引爆之前，请务必确保站在爆炸半径之外."
	item = /obj/item/syndicatedetonator
	cost = 1
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

// Support (Borgs and Reinforcements)

/datum/uplink_category/reinforcements
	name = "增援"
	weight = 28

/datum/uplink_item/reinforcements
	category = /datum/uplink_category/reinforcements
	surplus = 0
	cost = 35
	purchasable_from = UPLINK_NUKE_OPS
	restricted = TRUE
	refundable = TRUE

/datum/uplink_item/reinforcements/operative_reinforcement
	name = "增援队员"
	desc = "从我们的阵营里再叫一个队员来，他只有一把老式冲锋枪，所以最好再给他武装一下."
	item = /obj/item/antag_spawner/nuke_ops

/datum/uplink_item/reinforcements/assault_borg
	name = "辛迪加突击赛博格"
	desc = "一个被设计和编程用于系统消灭非辛迪加人员的赛博格，配有自填装轻机枪、榴弹发射器、能量剑、EMAG、闪光灯和撬棍."
	item = /obj/item/antag_spawner/nuke_ops/borg_tele/assault

/datum/uplink_item/reinforcements/medical_borg
	name = "辛迪加医疗赛博格"
	desc = "战斗医疗型赛博，进攻潜力有限，但支援能力绰绰有余； \
		它配备了纳米喷雾器、医用光束枪、战斗除颤器，以及全套手术设备，包括能量锯、电子显微镜、指针和闪光灯， \
		还有器官储存袋，有了它可以做到更多的手术."
	item = /obj/item/antag_spawner/nuke_ops/borg_tele/medical

/datum/uplink_item/reinforcements/saboteur_borg
	name = "辛迪加武工赛博格"
	desc = "最新型工程赛博格，配备隐蔽模块. 除了常规的工程设备外，特殊的模块设计可以让它遍历管道网络， \
		变色龙投影仪使他伪装成一个纳米赛博格，顶部的热成像还有定位器帮助它为团队收集情报."
	item = /obj/item/antag_spawner/nuke_ops/borg_tele/saboteur

/datum/uplink_item/reinforcements/overwatch_agent
	name = "照管情报人员"
	desc = "一名辛迪加情报人员会加入到你们的任务中来，他可以调用空间站摄像头以及你们的随身摄像头视角，\
		他还可以远程操控你们基地的飞船. 即便你此行是只管杀人而不使智谋，那么该人员也可以用于将你的狂态见证在心."
	item = /obj/item/antag_spawner/nuke_ops/overwatch
	cost = 12

// ~~ Disposable Sentry Gun ~~
// Technically not a spawn but it is a kind of reinforcement...I guess.

/datum/uplink_item/reinforcements/turretbox
	name = "一次性戒哨炮"
	desc = "一次性戒哨炮连带着部署系统巧妙的伪装成了一个工具箱，使用扳手来进行部署."
	item = /obj/item/storage/toolbox/emergency/turret/nukie
	cost = 16
	restricted = FALSE
	refundable = FALSE

// Bundles

/datum/uplink_item/bundles_tc/cyber_implants
	name = "义体植入包"
	desc = "内含X光眼、中枢神经系统重启器和复活植入物，每个都装在自动手术仪里."
	item = /obj/item/storage/box/cyber_implants
	cost = 20 //worth 24 TC
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/bundles_tc/medical
	name = "医疗物资包"
	desc = "用这些医疗物资帮助你的同伴！包含战术医疗包，Donksoft泡沫轻机枪，防暴泡沫弹和磁力靴模块，可以在无重力环境中作业."
	item = /obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle
	cost = 25 // normally 31
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/bundles_tc/firestarter
	name = "Spetsnaz-特战组合包"
	desc = "用于近距离作战，包含精英模块服、火焰喷射器、斯捷奇金APS手枪、燃烧弹匣、迷你炸弹和兴奋剂注射器. \
		现在订购，鲍里斯同志还会赠送你一条运动裤."
	item = /obj/item/storage/backpack/duffelbag/syndie/firestarter
	cost = 30
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/bundles_tc/induction_kit
	name = "辛迪加入伙包"
	desc = "在站点上遇到了一个同伙? 存了点Tc以防万一? 或者你正在通过辛迪加频道与某人交流? \
		购买此项，你就可以通过一个特殊的植入物把他们引入你的行动队伍. \
		此外，它还包含了为新特工准备的各种装备，包括太空服、安瑟姆手枪、备用弹匣等等!"
	item = /obj/item/storage/box/syndie_kit/induction_kit
	cost = 10
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/bundles_tc/cowboy
	name = "法外狂徒套装"
	desc = "这一带一直流传着一伙亡命之徒的传说，一群如此无情和高效的家伙，没有赏金猎人能抓住他们.\
	现在你可以像他们一样了！包含整套牛仔服装、定制的左轮手枪和枪套、以及一匹用苹果驯服的马，一个限量版的打火机也在内，但烟你得自己找."
	item = /obj/item/storage/box/syndie_kit/cowboy
	cost = 18
	purchasable_from = UPLINK_NUKE_OPS

// Mech related gear

/datum/uplink_category/mech
	name = "机甲增援"
	weight = 27

/datum/uplink_item/mech
	category = /datum/uplink_category/mech
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS
	restricted = TRUE

// ~~ Mechs ~~

/datum/uplink_item/mech/gygax
	name = "机甲：黑暗吉加斯"
	desc = "一台坚硬但不笨重的机甲，全身黑色. 它的速度和装备使它非常适合游击式作战，配有霰弹枪、强化装甲、离子推进器和特斯拉能量阵列."
	item = /obj/vehicle/sealed/mecha/gygax/dark/loaded
	cost = 60

/datum/uplink_item/mech/mauler
	name = "机甲：拳击家"
	desc = "一台巨大而致命的军用级机甲. 特点是远程瞄准、离子推进器和释放烟雾. 武器方面则有轻机枪、导弹架、反弹丸装甲和特斯拉能量阵列."
	item = /obj/vehicle/sealed/mecha/marauder/mauler/loaded
	cost = 100

// ~~ Mech Support ~~

/datum/uplink_item/mech/support_bag
	name = "机甲补给包"
	desc = "装有弹药的行李袋，可以在标准的黑暗吉加斯和拳击家上进行四次完整的重新装填，还配备了一些机甲维护的工具."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/mech
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/mech/support_bag/mauler
	name = "拳击家弹药包"
	desc = "装有弹药的行李袋，可以三次装填轻机枪和SRM-8导弹发射器，装备在标准的拳击家机甲上."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/mauler
	cost = 6
	purchasable_from = UPLINK_NUKE_OPS

// Stealthy Tools

/datum/uplink_item/stealthy_tools/syndigaloshes/nuke
	item = /obj/item/clothing/shoes/chameleon/noslip
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/stealthy_weapons/romerol_kit
	name = "Romerol-罗梅罗病毒"
	desc = "Romerol-罗梅罗是一种高度机密的生物病毒，它能在受试对象的灰质中蚀刻出休眠的肿瘤结节，\
		宿主死亡后，这些结节会控制尸体，导致其成为活死人，并伴有口齿不清、攻击和感染他人的能力."
	item = /obj/item/storage/box/syndie_kit/romerol
	cost = 25
	purchasable_from = UPLINK_CLOWN_OPS|UPLINK_NUKE_OPS
	cant_discount = TRUE

// Modsuits

/datum/uplink_item/suits/modsuit/elite
	name = "精英辛迪加模块服"
	desc = "辛迪加模块服的升级精英版，与标准辛迪加模块服相比它拥有更好的装甲、机动性与防火."
	item = /obj/item/mod/control/pre_equipped/elite
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/suits/energy_shield
	name = "能量护盾模块"
	desc = "模块服的能量护盾模块. 充能后可以阻止一次冲击，如果使用得到，这个模块会让你活得很久."
	item = /obj/item/mod/module/energy_shield
	cost = 8
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/suits/emp_shield
	name = "EMP防护模块"
	desc = "模块服用的先进EMP防护模块，可以保护你的整个身体免受电磁脉冲的伤害."
	item = /obj/item/mod/module/emp_shield/advanced
	cost = 5
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/suits/injector
	name = "注射器模块"
	desc = "模块服的注射器模块，是一种容量30u的注射器."
	item = /obj/item/mod/module/injector
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/suits/holster
	name = "枪套模块"
	desc = "模块服的枪套模块，可以秘密地储存任何不太笨重的枪."
	item = /obj/item/mod/module/holster
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/device_tools/medgun_mod
	name = "医疗光束模块"
	desc = "辛迪加工程上的奇迹，使医务兵在战斗中也能治疗同伴，只是注意不要让光线交叉！"
	item = /obj/item/mod/module/medbeam
	cost = 15
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/suits/syndi_intellicard
	name = "预装的辛迪AI人格芯片"
	desc = "辛迪AI人格芯片，可以激活以下载捕获的Nanotrasen AI，并应用辛迪加法令. \
			你可以把它插进模块服里，让它控制模块服，甚至移动你的身体. 然而由于提取过程中的故障，该AI无法远程操纵站点设备，只能靠近以操作."
	item = /obj/item/aicard/syndie/loaded
	cost = 12
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	refundable = TRUE

/datum/uplink_item/suits/synd_ai_upgrade
	name = "辛迪加AI升级"
	desc = "这个数据芯片允许捕获的AI在增加两格的交互范围，辛迪加官方建议购买三到四次，这样就有了七格或无限格的范围."
	item = /obj/item/computer_disk/syndie_ai_upgrade
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	cant_discount = TRUE
	refundable = TRUE

// Devices

/datum/uplink_item/device_tools/assault_pod
	name = "突击舱瞄准设备"
	desc = "使用这个来选择你的突击舱登陆地点."
	item = /obj/item/assault_pod
	cost = 30
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	restricted = TRUE

/datum/uplink_item/device_tools/syndie_jaws_of_life
	name = "辛迪加救生颚"
	desc = "基于纳米版，这个强大的工具既可以用作撬棍，也可以变形成剪线钳，它的撬棍功率非常强大，甚至能强行打开气闸门."
	item = /obj/item/crowbar/power/syndicate
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS | UPLINK_SPY

/datum/uplink_item/device_tools/medkit
	name = "辛迪加战斗医疗包"
	desc = "红黑相间的医疗包.包括一些用于快速稳定和爆炸预防的阿托品药物，\
		用于伤口治疗的缝合线和再生网，更快愈合的贴片，还配有基本的医疗工具和灭菌器."
	item = /obj/item/storage/medkit/tactical
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/device_tools/medkit/premium
	name = "辛迪加战斗医疗套件"
	desc = "红黑相间的医疗包，包括能穿透服装的化学注射枪、用于快速识别受伤人员和化学用品的医疗夜视HUD、\
		先进的医疗用品（包括经Interdyne研制的药物）、被骇入的手术工具臂义体以及有一些有用的模块服模块."
	item = /obj/item/storage/medkit/tactical/premium
	cost = 15
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS

/datum/uplink_item/device_tools/potion
	name = "辛迪加知性药水"
	item = /obj/item/slimepotion/slime/sentience/nuclear
	desc = "一种由辛迪加秘密特工冒着极大的风险才回收的药剂，随后用辛迪加的技术进行了改良. \
		使用它可以让任何动物产生知性，并且一定会为你服务，还可以自动在它体内植入无线电通信和气阀身份认证."
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS | UPLINK_SPY
	restricted = TRUE

// Implants

/datum/uplink_item/implants/nuclear
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/implants/nuclear/deathrattle
	name = "丧铃植入物组"
	desc = "一组团队用植入物，植入后，当团队中的一名成员死亡时，所有其他植入者都会收到死亡信息，告知死者队友的名字和死亡地点."
	item = /obj/item/storage/box/syndie_kit/imp_deathrattle
	cost = 4

/datum/uplink_item/implants/nuclear/microbomb
	name = "微型炸弹植入物"
	desc = "一种植入物，注射到体内，然后在死亡时手动或自动激活自爆，你体内的植入物越多，你自爆的威力就越大."
	item = /obj/item/storage/box/syndie_kit/imp_microbomb
	cost = 2
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_SPY

/datum/uplink_item/implants/nuclear/macrobomb
	name = "高爆炸弹植入物"
	desc = "注射到体后，在死亡时手动或自动激活自爆，释放巨大的爆炸，将摧毁附近的一切."
	item = /obj/item/storage/box/syndie_kit/imp_macrobomb
	cost = 20
	restricted = TRUE

/datum/uplink_item/implants/nuclear/deniability
	name = "战术延爆植入物"
	desc = "一种注入大脑的植入物，然后在进入危急状态时手动或自动激活. \
			能让你在濒死或死后尸体尽可能完整，然后在倒计时结束后自爆."
	item = /obj/item/storage/box/syndie_kit/imp_deniability
	cost = 6
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_SPY

/datum/uplink_item/implants/nuclear/reviver
	name = "复活泵"
	desc = "如果你失去意识，这个义体会试图使你苏醒并治愈你，配有自动手术仪."
	item = /obj/item/autosurgeon/syndicate/reviver
	cost = 8

/datum/uplink_item/implants/nuclear/thermals
	name = "热成像义眼"
	desc = "这个眼部义体会给你热成像视觉，配有自动手术仪."
	item = /obj/item/autosurgeon/syndicate/thermal_eyes
	cost = 8

/datum/uplink_item/implants/nuclear/implants/xray
	name = "X-ray视觉义眼"
	desc = "这个眼部义体会给你能穿透墙壁的x光视觉，配有自动手术仪."
	item = /obj/item/autosurgeon/syndicate/xray_eyes
	cost = 8

/datum/uplink_item/implants/nuclear/antistun
	name = "中枢神经复位器"
	desc = "这种植入物可以帮助你被击晕后更快地站起来，配有自动手术仪."
	item = /obj/item/autosurgeon/syndicate/anti_stun
	cost = 8

// Badass (meme items)

/datum/uplink_item/badass/costumes
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS
	cost = 4
	cant_discount = TRUE

// Base Keys

/datum/uplink_category/base_keys
	name = "基地钥匙"
	weight = 27

/datum/uplink_item/base_keys
	category = /datum/uplink_category/base_keys
	surplus = 0
	purchasable_from = UPLINK_NUKE_OPS
	cost = 15
	cant_discount = TRUE

/datum/uplink_item/base_keys/bomb_key
	name = "辛迪加军械实验室出入卡"
	desc = "你热爱爆炸吗? 如果是，那就恭喜你了!使用这个特殊的授权密钥，你可以打开你基地内的军械实验室，\
		制造自己的炸弹把他们全都炸成灰！*辛迪加不负责使用实验室时造成的伤害或死亡."
	item = /obj/item/keycard/syndicate_bomb
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/base_keys/bio_key
	name = "辛迪加生化武器实验室出入卡"
	desc = "在正确的人手中，即使是卑鄙的公司技术也可以变成解放和正义的利器. \
		从微生物共生到史莱姆核心武器化，这个特殊的授权密钥可以让你以惊人的速度突破生物恐怖主义的极限，\
		这些实验室甚至配备了天然的生命维持系统!*不包括植物."
	item = /obj/item/keycard/syndicate_bio
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_NUKE_OPS

/datum/uplink_item/base_keys/chem_key
	name = "辛迪加化学实验室出入卡"
	desc = "对我们一些最好的特工来说，看着公司空间站被粗暴的炸毁是不够的. \
		他们更喜欢追求个人的艺术风格，这个授权密钥会将你带进化学实验室，创造突破性的化学制剂，烹饪与销售最好的药物，并聆听最优雅的古典音乐!"
	item = /obj/item/keycard/syndicate_chem
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_NUKE_OPS

/datum/uplink_item/base_keys/fridge_key
	name = "洛佩兹的厨师出入卡"
	desc = "饿了? Firebase Balthazord的每个人都是如此，洛佩斯是个很棒的厨师，别误会我的意思，只是他在饮食计划上很固执.\
		但有时候你就是想大吃一顿，听着，别告诉任何人今早简报时我从他口袋里拿了这个，好吗?他现在一直在找呢, \
		拿着，去冰箱里，在他回来之前做好你需要的东西。记住:不要告诉任何人!- m.T"
	item = /obj/item/keycard/syndicate_fridge
	cost = 5
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_NUKE_OPS

// Hats
// It is fundamental for the game's health for there to be a hat crate for nuclear operatives.

/datum/uplink_item/badass/hats
	name = "帽子货箱"
	desc = "帽子货箱，帽子！！！"
	item = /obj/structure/closet/crate/large/hats
	cost = 5
	purchasable_from = UPLINK_CLOWN_OPS | UPLINK_NUKE_OPS
