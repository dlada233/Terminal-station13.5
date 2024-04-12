/**
 * Imports category.
 * This is for crates not intended for goodies, but also not intended for departmental orders.
 * This allows us to have a few crates meant for deliberate purchase through cargo, and for cargo to have a few items
 * they explicitly control. It also holds all of the black market material and contraband material, including items
 * meant for purchase only through emagging the console.
 */

/datum/supply_pack/imports
	group = "进口商品"
	crate_name = "应急用品箱"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/imports/foamforce
	name = "泡沫霰弹包"
	desc = "用八支泡沫霰弹枪来击破大枪吧!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/gun/ballistic/shotgun/toy = 8)
	crate_name = "泡沫霰弹箱"
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

/datum/supply_pack/imports/foamforce/bonus
	name = "泡沫手枪包"
	desc = "嘘..嗨嗨...还记得那些因为太酷而停产的老式泡沫手枪吗? \
		我这里有两把，上面有你的名字，我还会给你一个备用弹匣呢，怎么说?"
	contraband = TRUE
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/item/gun/ballistic/automatic/pistol/toy = 2,
		/obj/item/ammo_box/magazine/toy/pistol = 2,
	)
	crate_name = "泡沫手枪箱"

/datum/supply_pack/imports/meatmeatmeatmeat // MEAT MEAT MEAT MEAT
	name = "肉 肉 肉 肉 肉"
	desc = "肉 肉 肉 肉 肉 肉"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/storage/backpack/meat)
	crate_name = "肉 肉 肉 肉 肉"
	crate_type = /obj/structure/closet/crate/necropolis
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/imports/duct_spider
	name = "管道蜘蛛包"
	desc = "Awww!直接从闹大利亚闹到你的通风系统!"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/mob/living/basic/spider/maintenance)
	crate_name = "管道蜘蛛箱"
	crate_type = /obj/structure/closet/crate/critter
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/imports/duct_spider/dangerous
	name = "管道蜘蛛包?"
	desc = "等下, 是这个箱子吗? 上面有一张皱眉的脸，这是什么意思?"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/mob/living/basic/spider/giant/hunter)
	contraband = TRUE

/datum/supply_pack/imports/bamboo50
	name = "50条竹条"
	desc = "你不知道我们杀了多少熊猫才得到这些竹子."
	cost = CARGO_CRATE_VALUE * 15
	contains = list(/obj/item/stack/sheet/mineral/bamboo/fifty)
	crate_name = "50条竹条"

/datum/supply_pack/imports/bananium
	name = "一块蕉板"
	desc = "别让那个小丑知道可以订这个."
	cost = CARGO_CRATE_VALUE * 100
	contains = list(/obj/item/stack/sheet/mineral/bananium)
	crate_name = "蕉板箱"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/imports/naturalbait
	name = "天然鱼饵罐头"
	desc = "手工纯天然."
	cost = 2000 //rock on
	contains = list(/obj/item/storage/pill_bottle/naturalbait)
	crate_name = "鱼饵箱"

/datum/supply_pack/imports/dumpstercorpse
	name = "一堆....垃圾?"
	desc = "为什么闻起来这么糟糕...."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/mob/living/carbon/human)
	crate_name = "腐烂的垃圾桶"
	crate_type = /obj/structure/closet/crate/trashcart

/datum/supply_pack/imports/dumpstercorpse/generate()
	. = ..()
	var/mob/living/carbon/human/corpse = locate() in .
	corpse.death()

/datum/supply_pack/imports/dumpsterloot
	name = "一堆....垃圾"
	desc = "我不知道你为什么要买这个...为什么这么贵？"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/effect/spawner/random/maintenance/three,
		/obj/effect/spawner/random/trash/garbage = 5,
	)
	crate_name = "腐烂的垃圾桶"
	crate_type = /obj/structure/closet/crate/trashcart

/datum/supply_pack/imports/error
	name = "NULL_ENTRY"
	desc = "(*!&@#行了，特工，我们知道你在炫耀多少钱了.好吧,买这个，把它组装起来，祝你好运!#@*$"
	cost = CARGO_CRATE_VALUE * 100
	hidden = TRUE
	contains = list(/obj/item/book/granter/crafting_recipe/regal_condor)

/datum/supply_pack/imports/mafia
	name = "黑手党入门包"
	desc = "这个箱子包含了你建立基于自己的种族敲诈勒索业务所需的一切."
	cost = CARGO_CRATE_VALUE * 4
	contains = list()
	contraband = TRUE

/datum/supply_pack/imports/mafia/fill(obj/structure/closet/crate/our_crate)
	for(var/items in 1 to 4)
		new /obj/effect/spawner/random/clothing/mafia_outfit(our_crate)
		new /obj/item/virgin_mary(our_crate)
		if(prob(30)) //Not all mafioso have mustaches, some people also find this item annoying.
			new /obj/item/clothing/mask/fakemoustache/italian(our_crate)
	if(prob(10)) //A little extra sugar every now and then to shake things up.
		new /obj/item/switchblade(our_crate)

/datum/supply_pack/imports/blackmarket_telepad
	name = "黑市 LTSRBT"
	desc = "需要一种更快更好的方式将你的非法货物运送到站点吗? \
		别担心, 长短距蓝空收发器(LTSRBT)可以帮到你，\
		内含一个LTSRBT电路板，两个蓝空晶体和一个安塞波."
	cost = CARGO_CRATE_VALUE * 20
	contraband = TRUE
	contains = list(
		/obj/item/circuitboard/machine/ltsrbt,
		/obj/item/stack/ore/bluespace_crystal/artificial = 2,
		/obj/item/stock_parts/subspace/ansible,
	)

/datum/supply_pack/imports/contraband
	name = "'违禁品'"
	desc = "嘘.. 嘿...想要违禁品嘛? 我可以给你一张海报、几条好烟以及一些赞助项目...\
		你懂的，好东西.别让条子看到了，好吗?"
	contraband = TRUE
	cost = CARGO_CRATE_VALUE * 20
	contains = list(
		/obj/effect/spawner/random/contraband = 5,
	)
	crate_name = "板条箱"

/datum/supply_pack/imports/wt550
	name = "走私 WT-550自动步枪"
	desc = "(*!&@#好消息, 特工! 虽然我们没法直接给你最顶级的自动武器.\
		但在走私时使用几个失效海关检查站，我们就有办法输送给你这些顶级武器了! \
		WT-550自动步枪，别担心，这把枪会把你融化只是一个谣言! \
		这东西很好用，只是有点脏罢了!#@*$"
	hidden = TRUE
	cost = CARGO_CRATE_VALUE * 7
	contains = list(
		/obj/item/gun/ballistic/automatic/wt550 = 2,
		/obj/item/ammo_box/magazine/wt550m9 = 2,
	)

/datum/supply_pack/imports/wt550ammo
	name = "走私 WT-550弹药补给"
	desc = "(*!&@#特工, 喜欢耍WT-550? 那为什么不带上更多弹药!!#@*$"
	hidden = TRUE
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/ammo_box/magazine/wt550m9 = 2,
		/obj/item/ammo_box/magazine/wt550m9/wtap = 2,
		/obj/item/ammo_box/magazine/wt550m9/wtic = 2,
	)
	crate_name = "应急用品箱"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/imports/shocktrooper
	name = "掷弹兵套装"
	desc = "(*!&@#想让你的敌人陷入死亡的恐惧中嘛? 这一箱好东西可以帮助你实现这个愿望. \
		包含一套护甲背心和头盔, 一盒五枚的EMP手榴弹, 三枚烟雾弹, 两枚胶子手榴弹和两枚破片手榴弹!#@*$"
	hidden = TRUE
	cost = CARGO_CRATE_VALUE * 10
	contains = list(
		/obj/item/storage/box/emps,
		/obj/item/grenade/smokebomb = 3,
		/obj/item/grenade/gluon = 2,
		/obj/item/grenade/frag = 2,
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/head/helmet,
	)

/datum/supply_pack/imports/specialops
	name = "特工补给"
	desc = "(*!&@#亡命天涯了? 也许这些补给能给你争取点时间! \
		内含变色龙面具, 腰带和连体衣, 幻象手榴弹和一张特工卡! 还有一把刀!!#@*$"
	hidden = TRUE
	cost = CARGO_CRATE_VALUE * 10
	contains = list(
		/obj/item/clothing/mask/chameleon,
		/obj/item/clothing/under/chameleon,
		/obj/item/storage/belt/chameleon,
		/obj/item/card/id/advanced/chameleon,
		/obj/item/switchblade,
		/obj/item/grenade/mirage = 5,
	)

// SKYRAT EDIT REMOVAL BEGIN - REPLACED BY LORE BEFITTING CRATE AT: modular_skyrat/modules/cargo/code/packs.dm
/*
/datum/supply_pack/imports/russian
	name = "Russian Surplus Military Gear Crate"
	desc = "Hello <;~insert appropriate greeting here: 'Comrade'|'Imperalist Scum'|'Quartermaster of Reputable Station'~;>, \
		we have the most modern russian military equipment the black market can offer, for the right price of course. \
		No lock, best price."
	contraband = TRUE
	cost = CARGO_CRATE_VALUE * 12
	contains = list(
		/obj/item/food/rationpack,
		/obj/item/ammo_box/strilka310,
		/obj/item/ammo_box/strilka310/surplus,
		/obj/item/storage/toolbox/ammobox/strilka310,
		/obj/item/storage/toolbox/ammobox/strilka310/surplus,
		/obj/item/storage/toolbox/maint_kit,
		/obj/item/clothing/suit/armor/vest/russian,
		/obj/item/clothing/head/helmet/rus_helmet,
		/obj/item/clothing/shoes/russian,
		/obj/item/clothing/gloves/tackler/combat,
		/obj/item/clothing/under/syndicate/rus_army,
		/obj/item/clothing/under/costume/soviet,
		/obj/item/clothing/mask/russian_balaclava,
		/obj/item/clothing/head/helmet/rus_ushanka,
		/obj/item/clothing/suit/armor/vest/russian_coat,
		/obj/item/storage/toolbox/guncase/soviet = 2,
	)
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/imports/russian/fill(obj/structure/closet/crate/our_crate)
	for(var/items in 1 to 10)
		var/item = pick(contains)
		new item(our_crate)
*/
// SKYRAT EDIT REMOVAL END

/datum/supply_pack/imports/moistnuggets
	name = "翻新的萨赫诺栓动步枪"
	desc = "你好，特工同志.你需要枪吗？你已经厌倦我们卖给站点的垃圾了吗？\
		那我们为你准备了完美的武器！特别友情价！ \
		但很不幸我们没有多余的弹药, 所以当你打光了所有弹药的时候，\
		你必须捡起死去战友的武器."
	hidden = TRUE
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/gun/ballistic/rifle/boltaction = 6)

/datum/supply_pack/imports/vehicle
	name = "摩托帮套装" //TUNNEL SNAKES OWN THIS TOWN
	desc = "隧道之蛇统治这个小镇，包含一辆无牌全地形车，\
		和一套完整的帮派装备-黑色手套、头骨头巾和真皮大衣!"
	cost = CARGO_CRATE_VALUE * 4
	contraband = TRUE
	contains = list(
		/obj/vehicle/ridden/atv,
		/obj/item/key/atv,
		/obj/item/clothing/suit/jacket/leather/biker,
		/obj/item/clothing/gloves/color/black,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/mask/bandana/skull/black,
	)//so you can properly #cargoniabikergang
	crate_name = "摩托帮套装"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/imports/abandoned
	name = "遗弃的板条箱"
	desc = "...等等, 怎么弄到这个?"
	cost = CARGO_CRATE_VALUE * 50
	contains = list()
	crate_type = /obj/structure/closet/crate/secure/loot
	crate_name = "遗弃的板条箱"
	contraband = TRUE
	dangerous = TRUE //these are literally bombs so....
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/imports/shambler_evil
	name = "Shamber的奇异果汁能量! 包"
	desc = "~J'I'CE!~"
	cost = CARGO_CRATE_VALUE * 50
	contains = list(/obj/item/reagent_containers/cup/soda_cans/shamblers/eldritch = 1)
	crate_name = "非法果汁箱"
	contraband = TRUE

/datum/supply_pack/imports/hide
	name = "动物皮草包"
	desc = "不想亲自屠杀一群无辜的动物吗? 这里，有些动物皮草，\
		只是不要问它们是从哪里来的..."
	cost = CARGO_CRATE_VALUE * 30
	contains = list(/obj/effect/spawner/random/animalhide = 5)
	crate_name = "动物皮草箱"

/datum/supply_pack/imports/dreadnog
	name = "黯诺酒盒包"
	desc = "我有一盒蛋诺酒，所以我必须加点苏打."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/reagent_containers/cup/glass/bottle/juice/dreadnog = 3)
	crate_name = "黯诺酒箱"

/datum/supply_pack/imports/giant_wrench_parts
	name = "大拍扳"
	desc = "非法的大拍扳，最快也是最危险的扳手."
	cost = CARGO_CRATE_VALUE * 22
	contraband = TRUE
	contains = list(/obj/item/weaponcrafting/giant_wrench)
	crate_name = "未知零件箱"

/datum/supply_pack/imports/materials_market
	name = "银河系材料市场组装包"
	desc = "内含组建银河系材料市场的电路板，警告：投资失败的损失不在保险范围内."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/item/circuitboard/machine/materials_market = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil/five = 2,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/card_reader = 1
	)
	crate_name = "材料市场箱"
	crate_type = /obj/structure/closet/crate/cargo
