/// Cost of the crate. DO NOT GO ANY LOWER THAN X1.4 the "CARGO_CRATE_VALUE" value if using regular crates, or infinite profit will be possible!

/*
*	LIVESTOCK
*/

/datum/supply_pack/critter/doublecrab
	name = "螃蟹箱"
	desc = "包含两只螃蟹，享受你的蟹友会!"
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/mob/living/basic/crab,
		/mob/living/basic/crab,
	)
	crate_name = "蟹友会"

/datum/supply_pack/critter/mouse
	name = "鼠箱"
	desc = "适用于各个年龄段的蜥蜴与蛇，内含六只可食用老鼠."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/mob/living/basic/mouse,
	)
	crate_name = "鼠箱"

/datum/supply_pack/critter/mouse/generate()
	. = ..()
	for(var/i in 1 to 5)
		new /mob/living/basic/mouse(.)

/datum/supply_pack/critter/chinchilla
	name = "龙猫箱"
	desc = "内含四只龙猫，并且不附赠沙子."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(
		/mob/living/basic/pet/chinchilla,
	)
	crate_name = "龙猫箱"

/datum/supply_pack/critter/chinchilla/generate()
	. = ..()
	for(var/i in 1 to 3)
		new /mob/living/basic/pet/chinchilla(.)

/*
*	MEDICAL
*/

/datum/supply_pack/medical/anesthetics
	name = "麻醉用品箱"
	desc = "内含下列物品各两个：吗啡瓶、注射器、呼吸面罩和麻醉气体瓶；需要医疗权限以打开."
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/reagent_containers/cup/bottle/morphine,
		/obj/item/reagent_containers/cup/bottle/morphine,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/syringe,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath,
		/obj/item/tank/internals/anesthetic,
		/obj/item/tank/internals/anesthetic,
	)
	crate_name = "麻醉用品箱"

/datum/supply_pack/medical/bodybags
	name = "尸体袋补给箱"
	desc = "内含四盒尸体袋."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/bodybags,
	)
	crate_name = "尸体袋补给箱"

/datum/supply_pack/medical/firstaidmixed
	name = "综合医疗箱"
	desc = "内含所有伤害对应的急救箱，用于处理各种受伤的船员."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/storage/medkit/toxin,
		/obj/item/storage/medkit/o2,
		/obj/item/storage/medkit/brute,
		/obj/item/storage/medkit/fire,
		/obj/item/storage/medkit/regular,
	)
	crate_name = "综合急救箱"

/datum/supply_pack/medical/medipens
	name = "医用注射笔箱"
	desc = "包含两盒肾上腺素医用注射笔，每盒七支注射笔."
	cost = CARGO_CRATE_VALUE * 4.5
	contains = list(
		/obj/item/storage/box/medipens,
		/obj/item/storage/box/medipens,
	)
	crate_name = "医用注射笔补给箱"

/datum/supply_pack/medical/modsuit_medical
	name = "医疗模块服"
	desc = "内含一套医疗模块服，已配装标准的医疗模块."
	cost = CARGO_CRATE_VALUE * 13
	access = ACCESS_MEDICAL
	contains = list(/obj/item/mod/control/pre_equipped/medical)
	crate_name = "医疗模块服补给箱"
	crate_type = /obj/structure/closet/crate/secure //No medical varient with security locks.

/datum/supply_pack/medical/compact_defib
	name = "紧凑型除颤器"
	desc = "内含一台紧凑型除颤器，可以佩戴在腰上."
	cost = CARGO_CRATE_VALUE * 5
	access = ACCESS_MEDICAL
	contains = list(/obj/item/defibrillator/compact)
	crate_name = "紧凑型除颤器补给箱"

/datum/supply_pack/medical/medigun
	name = "CWM-479 医疗枪"
	desc = "内含一把VeyMedical CWM-479 型医疗枪，不附赠药匣."
	cost = CARGO_CRATE_VALUE * 30
	access = ACCESS_MEDICAL
	contains = list(/obj/item/storage/briefcase/medicalgunset/standard)
	crate_name = "CWM-479 医疗枪补给箱"

/datum/supply_pack/medical/medicells
	name = "药囊补给箱"
	desc = "内含T1的医疗枪药匣."
	cost = CARGO_CRATE_VALUE * 5
	access = ACCESS_MEDICAL
	contains = list(
		/obj/item/weaponcell/medical/brute,
		/obj/item/weaponcell/medical/burn,
		/obj/item/weaponcell/medical/toxin,
	)
	crate_name = "药匣补给箱"

/*
*	SECURITY
*/

/datum/supply_pack/security/MODsuit_security
	name = "安保模块服"
	desc = "内含一套经过强化的模块装甲服，已配装标准的安保模块."
	cost = CARGO_CRATE_VALUE * 16
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/mod/control/pre_equipped/security)
	crate_name = "安保模块服补给箱"

/datum/supply_pack/security/armor_skyrat
	name = "防弹背心箱"
	desc = "内含三个设计轻便、具有一定保护性的防弹背心."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(
		/obj/item/clothing/suit/armor/vest/alt,
		/obj/item/clothing/suit/armor/vest/alt,
		/obj/item/clothing/suit/armor/vest/alt,
	)
	crate_name = "防弹背心箱"

/datum/supply_pack/security/helmets_skyrat
	name = "防弹头盔箱"
	desc = "内含三个标准配发款的头盔"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/helmet/sec/sol = 3)
	crate_name = "防弹头盔箱"

/datum/supply_pack/security/deployablebarricades
	name = "C.U.C.K.S 部署型路障"
	desc = "两箱可部署路障，满足您所有的防御需求."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/storage/barricade,
		/obj/item/storage/barricade,
	)
	crate_name = "C.U.C.K.S 补给箱"

/*
*	ENGINEERING
*/

/datum/supply_pack/engineering/material_pouches
	name = "建材储袋补给箱"
	desc = "内含三个建材储袋."
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(
		/obj/item/storage/pouch/material,
		/obj/item/storage/pouch/material,
		/obj/item/storage/pouch/material,
	)
	cost = CARGO_CRATE_VALUE * 15
	crate_name = "建材储袋补给箱"

/datum/supply_pack/engineering/doublecap_tanks
	name = "双罐应急扩容氧气瓶补给箱"
	desc = "内含四个双管应急扩容氧气瓶."
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(
		/obj/item/tank/internals/emergency_oxygen/double,
		/obj/item/tank/internals/emergency_oxygen/double,
		/obj/item/tank/internals/emergency_oxygen/double,
		/obj/item/tank/internals/emergency_oxygen/double,
	)
	cost = CARGO_CRATE_VALUE * 15
	crate_name = "内含四个双管应急扩容氧气瓶"

/datum/supply_pack/engineering/advanced_extinguisher
	name = "先进泡沫灭火器补给箱"
	desc = "内含三个先进泡沫灭火器."
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(
		/obj/item/extinguisher/advanced,
		/obj/item/extinguisher/advanced,
		/obj/item/extinguisher/advanced,
	)
	cost = CARGO_CRATE_VALUE * 18
	crate_name = "先进泡沫灭火器补给箱"

/datum/supply_pack/engineering/modsuit_engineering
	name = "工程模块服"
	desc = "包含一套工程模块服，已配装标准工程模块."
	access = ACCESS_ENGINE_EQUIP
	contains = list(/obj/item/mod/control/pre_equipped/engineering)
	cost = CARGO_CRATE_VALUE * 13
	crate_name = "工程模块服补给箱"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engineering/modsuit_atmospherics
	name = "大气模块服"
	desc = "包含一套大气模块服，已配装标准大气模块."
	access = ACCESS_ENGINE_EQUIP
	contains = list(/obj/item/mod/control/pre_equipped/atmospheric)
	cost = CARGO_CRATE_VALUE * 16
	crate_name = "大气模块服补给箱"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engineering/engi_inducers
	name = "NT-150 工业无线充电器 补给箱"
	desc = "NT-150 是 NT-75 EPI 的改进型号，充电速率是其两倍，并配备了改进的电源电池，该补给箱内包含两个工业无线充电器."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/item/inducer,
		/obj/item/inducer,
	)
	crate_name = "工业无线充电器补给箱"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/gas_miner
	name = "Gas Miner-气体矿泵输送信标"
	desc = "包含一个气体矿泵输送信标，用于订购一个气体矿泵."
	access = ACCESS_ATMOSPHERICS
	contains = list(/obj/item/summon_beacon/gas_miner)
	cost = CARGO_CRATE_VALUE * 50
	crate_name = "Gas Miner-气体矿泵补给箱"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engineering/improved_rcd
	name = "Improved RCD 改进型 补给箱"
	desc = "内含三个改进型RCD，具有更大的材料储量，每个都附赠有框架和电路升级."
	access = ACCESS_ENGINE_EQUIP
	cost = CARGO_CRATE_VALUE * 18
	contains = list(
		/obj/item/construction/rcd/improved,
		/obj/item/construction/rcd/improved,
		/obj/item/construction/rcd/improved,
	)
	crate_name = "RCD-改进型补给箱"
	crate_type = /obj/structure/closet/crate/secure/engineering

/*
*	MISC
*/

/datum/supply_pack/misc/speedbike //If you see this bought in game, its time to nerf a cargo exploit.
	name = "自行车"
	desc = "戴上墨镜，披上价格，骑上这辆超豪华太空巡航自行车，直奔太阳而去."
	cost = 1000000 //Special case, we don't want to make this in terms of crates because having bikes be a million credits is the whole meme.
	contains = list(/obj/vehicle/ridden/speedbike)
	crate_name = "自行车箱"

/datum/supply_pack/misc/painting
	name = "高级美术用品"
	desc = "使用这些高级的美术用品，释放你的艺术灵感；内含各色绘画工具、画布材料以及两个画架供您使用！"
	cost = CARGO_CRATE_VALUE * 2.2
	contains = list(
		/obj/structure/easel,
		/obj/structure/easel,
		/obj/item/toy/crayon/spraycan,
		/obj/item/toy/crayon/spraycan,
		/obj/item/storage/crayons,
		/obj/item/storage/crayons,
		/obj/item/toy/crayon/white,
		/obj/item/toy/crayon/white,
		/obj/item/toy/crayon/rainbow,
		/obj/item/toy/crayon/rainbow,
		/obj/item/stack/sheet/cloth/ten,
		/obj/item/stack/sheet/cloth/ten,
	)
	crate_name = "高级美术用品"

/datum/supply_pack/service/paintcan
	name = "自适应油漆"
	desc = "用这罐实验性的变色油漆为物品增添一抹色彩！卖家需知：由于您使用此产品而导致的愤怒清洁工、安保人员或其他船员的私刑，我们概不负责."
	cost = CARGO_CRATE_VALUE * 15
	contains = list(/obj/item/paint/anycolor)

/datum/supply_pack/misc/coloredsheets
	name = "床单补给箱"
	desc = "用这个装满床单的箱子为你的夜晚生活增添一抹色彩！总共包含九张不同颜色的床单."
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(
		/obj/item/bedsheet/blue,
		/obj/item/bedsheet/green,
		/obj/item/bedsheet/orange,
		/obj/item/bedsheet/purple,
		/obj/item/bedsheet/red,
		/obj/item/bedsheet/yellow,
		/obj/item/bedsheet/brown,
		/obj/item/bedsheet/black,
		/obj/item/bedsheet/rainbow,
	)
	crate_name = "多色床单箱"

/datum/supply_pack/misc/candles
	name = "蜡烛补给箱"
	desc = "用这些蜡烛和蜡笔来布置一个浪漫的晚餐或主持一场降神会."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(
		/obj/item/storage/fancy/candle_box,
		/obj/item/storage/fancy/candle_box,
		/obj/item/storage/box/matches,
	)
	crate_name = "蜡烛补给箱"

/datum/supply_pack/misc/vanguard_surplus
	name = "远征军存货"
	desc = "包含来自现已解散的先锋远征军的各种剩余装备."
	cost = CARGO_CRATE_VALUE * 19
	contains = list(
		/obj/item/storage/box/expeditionary_survival,
		/obj/item/melee/tomahawk,
		/obj/item/storage/backpack/duffelbag/expeditionary_corps,
		/obj/item/clothing/gloves/color/black/expeditionary_corps,
		/obj/item/clothing/head/helmet/expeditionary_corps,
		/obj/item/clothing/suit/armor/vest/expeditionary_corps,
		/obj/item/storage/belt/military/expeditionary_corps,
		/obj/item/clothing/under/rank/expeditionary_corps,
		/obj/item/clothing/shoes/combat/expeditionary_corps,
		/obj/item/modular_computer/pda/expeditionary_corps,
		/obj/item/knife/combat/marksman,
	)
	/// How many of the contains to put in the crate
	var/num_contained = 3

/datum/supply_pack/misc/vanguard_surplus/fill(obj/structure/closet/crate/filled_crate)
	var/list/contain_copy = contains.Copy()
	for(var/i in 1 to num_contained)
		var/item = pick_n_take(contain_copy)
		new item(filled_crate)

/datum/supply_pack/misc/gravity_harness
	name = "重力悬挂式背带"
	desc = "由电池供电的背部悬挂式背带，由深空部落设计，可用于抵消或放大重力. \
		虽然它是Skrell的个人重力引擎的廉价仿制品, 但同样具有带子和基本储存模块."
	cost = CARGO_CRATE_VALUE * 6 // 1200 credits
	contains = list(/obj/item/gravity_harness)

/*
*	FOOD
*/

/datum/supply_pack/organic/combomeal
	name = "汉堡全家桶"
	desc = "在 Greasy Griddle，我们非常重视我们的顾客，以至于我们愿意为您提供专门的送货服务。包含两份套餐，每份包括一份汉堡、薯条和一盒鸡块！"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/food/burger/cheese,
		/obj/item/food/burger/cheese,
		/obj/item/food/fries,
		/obj/item/food/fries,
		/obj/item/storage/fancy/nugget_box,
		/obj/item/storage/fancy/nugget_box,
	)
	crate_name = "汉堡全家桶"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/organic/fiestatortilla
	name = "墨西哥狂欢节食品箱"
	desc = "用这个狂欢节食物箱为厨房增添一抹墨西哥风味，包含八种以玉米饼为基础的食物和一些辣酱."
	cost = CARGO_CRATE_VALUE * 4.5
	contains = list(
		/obj/item/food/taco,
		/obj/item/food/taco,
		/obj/item/food/taco/plain,
		/obj/item/food/taco/plain,
		/obj/item/food/enchiladas,
		/obj/item/food/enchiladas,
		/obj/item/food/carneburrito,
		/obj/item/food/cheesyburrito,
		/obj/item/reagent_containers/cup/bottle/capsaicin,
	)
	crate_name = "狂欢节食品箱"

/datum/supply_pack/organic/fakemeat
	name = "肉类补给-'合成肉'"
	desc = "肉又用完了吗? 用这个冷藏箱让蜥蜴们满意! 包含十二块合成肉以及四块*鲤鱼肉*."
	cost = CARGO_CRATE_VALUE * 2.25
	contains = list(
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/meat/slab/meatproduct,
		/obj/item/food/fishmeat/carp/imitation,
		/obj/item/food/fishmeat/carp/imitation,
		/obj/item/food/fishmeat/carp/imitation,
		/obj/item/food/fishmeat/carp/imitation,
	)
	crate_name = "肉类冷藏箱"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/mixedboxes
	name = "混合食材箱"
	desc = "通过订购这些装满随机惊喜食材的箱子，激发你的创作灵感！内含四个装满各种食材的盒子！"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/storage/box/ingredients/wildcard,
		/obj/item/storage/box/ingredients/wildcard,
		/obj/item/storage/box/ingredients/wildcard,
		/obj/item/storage/box/ingredients/wildcard,
	)
	crate_name = "混合食材箱"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/fcsurplus
	name = "精致美食超值套餐"
	desc = "做饭做乏了? 有些挑食的船员难伺候? 或者你只是想陶醉在那些诱人的芝士丸子中? 我们行业中最优秀的人为你制作了这个套餐，内含各种精致的油、醋和极为罕见的食材！"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/food/canned/tomatoes,
		/obj/item/food/canned/tomatoes,
		/obj/item/food/canned/pine_nuts,
		/obj/item/food/canned/pine_nuts,
		/obj/item/food/canned/jellyfish,
		/obj/item/food/canned/desert_snails,
		/obj/item/food/canned/larvae,
		/obj/item/food/moonfish_eggs,
	)
	crate_name = "精致美食超值套餐"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/qualityoilbulk
	name = "优质食用油批发套餐"
	desc = "普通食用油不够用了? 厨师把所有的好东西都扔进了炸锅只是因为他们觉得这很有趣? 嗯, 别担心, 这就为你带来一组十瓶的上好食用油批发套餐, 不仅能为冷吃食谱调味, 还能在高温烹饪中不易变酸."
	cost = CARGO_CRATE_VALUE * 9
	contains = list(
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/olive_oil,
		/obj/item/reagent_containers/condiment/olive_oil,
	)
	crate_name = "上好食用油批发套餐"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/vinegarbulk
	name = "陈醋批发套餐"
	desc = "山西美食之夜? PH值大于7.6? 成了老铁，我们会让你立刻开始烹饪, 从几种名贵的发酵物中提炼而出, 经过精心培育最终到达了刚刚好的味道, 一组十瓶的批发套餐, 用于制作完美的调料和酱料."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/reagent_containers/condiment/vinegar,
		/obj/item/reagent_containers/condiment/vinegar,
	)
	crate_name = "陈醋批发套餐"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/bulkcanmoff
	name = "青酱制作套餐"
	desc = "想要尝试制作青酱? 但苦于无法种植和加工罐头? 别担心, 我们这里为您提供五罐番茄和五罐松子."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/item/food/canned/tomatoes,
		/obj/item/food/canned/tomatoes,
		/obj/item/food/canned/tomatoes,
		/obj/item/food/canned/tomatoes,
		/obj/item/food/canned/tomatoes,
		/obj/item/food/canned/pine_nuts,
		/obj/item/food/canned/pine_nuts,
		/obj/item/food/canned/pine_nuts,
		/obj/item/food/canned/pine_nuts,
		/obj/item/food/canned/pine_nuts,
	)
	crate_name = "青酱制作套餐"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/bulkcanliz
	name = "奇异食品套餐"
	desc = "有一些奇怪的口味嗜好? 想开枪新世界的美食大门? 那么您离满足只差一个下单, 内含三瓶海蜇罐头, 三瓶沙蜗罐头和三瓶蜜虫罐头, 再加上三包人道采摘的月鱼子."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(
		/obj/item/food/canned/jellyfish,
		/obj/item/food/canned/jellyfish,
		/obj/item/food/canned/jellyfish,
		/obj/item/food/canned/desert_snails,
		/obj/item/food/canned/desert_snails,
		/obj/item/food/canned/desert_snails,
		/obj/item/food/moonfish_eggs,
		/obj/item/food/moonfish_eggs,
		/obj/item/food/moonfish_eggs,
		/obj/item/food/canned/larvae,
		/obj/item/food/canned/larvae,
		/obj/item/food/canned/larvae,
	)
	crate_name = "奇异食品套餐"
	crate_type = /obj/structure/closet/crate/freezer

/*
*	Service
*/

/datum/supply_pack/service/buildabar
	name = "小吧台套件"
	desc = "想要建立自己的小天堂? 从订购这个便利的套件开始! 内含各种吧台设备的电路板, 建造它们的基础零件和一些基本的调酒用品. (不附赠玻璃杯)"
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/storage/box/drinkingglasses,
		/obj/item/storage/box/drinkingglasses,
		/obj/item/storage/part_replacer/cargo,
		/obj/item/stack/sheet/iron/ten,
		/obj/item/stack/sheet/iron/five,
		/obj/item/stock_parts/cell/high,
		/obj/item/stock_parts/cell/high,
		/obj/item/stack/cable_coil,
		/obj/item/book/manual/wiki/barman_recipes,
		/obj/item/reagent_containers/cup/glass/shaker,
		/obj/item/circuitboard/machine/chem_dispenser/drinks/beer,
		/obj/item/circuitboard/machine/chem_dispenser/drinks,
		/obj/item/circuitboard/machine/dish_drive,
	)
	crate_name = "小吧台套件"

/datum/supply_pack/service/hydrohelper
	name = "小菜园套件"
	desc = "植物学家很懒惰? 被拒绝提供电路板? 内含三块水培有关的电路板, 助力你的小菜园梦. (不附赠种子和零件)"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/circuitboard/machine/hydroponics,
		/obj/item/circuitboard/machine/hydroponics,
		/obj/item/circuitboard/machine/hydroponics,
	)
	crate_name = "小菜园套件"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/service/janitor/janpimp
	name = "清洁巡逻车"
	desc = "小丑偷了你的车? 助手把它锁到宿舍里了? 快订购一辆新的, 以时尚的方式回到清洁工作中!"
	cost = CARGO_CRATE_VALUE * 4
	access = ACCESS_JANITOR
	contains = list(
		/obj/vehicle/ridden/janicart,
		/obj/item/key/janitor,
	)
	crate_name = "清洁巡逻车"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/janitor/janpimpkey
	name = "清洁车钥匙"
	desc = "清洁巡逻车的替代钥匙."
	cost = CARGO_CRATE_VALUE * 1.5
	access = ACCESS_JANITOR
	contains = list(/obj/item/key/janitor)
	crate_name = "钥匙箱"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/service/janitor/janpremium
	name = "清洁用品 (重火力版)"
	desc = "当有大范围的脏乱亟待清理时使用, 内含多颗清洁手榴弹, 一些清洁喷雾, 两块肥皂, 和一块 MCE (大规模清洁爆弹)."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/item/soap/nanotrasen,
		/obj/item/soap/nanotrasen,
		/obj/item/grenade/clusterbuster/cleaner,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/reagent_containers/cup/bottle/ammonia,
		/obj/item/reagent_containers/cup/bottle/ammonia,
		/obj/item/reagent_containers/cup/bottle/ammonia,
	)
	crate_name = "重火力清洁用品箱"

/datum/supply_pack/service/lamplight
	name = "应急灯源补给"
	desc = "电力供应不足中? 站点伸手不见五指? 快使用这个含有四盏台灯和四支手电筒的补给包来照亮一切."
	cost = CARGO_CRATE_VALUE * 1.75
	contains = list(
		/obj/item/flashlight/lamp,
		/obj/item/flashlight/lamp,
		/obj/item/flashlight/lamp/green,
		/obj/item/flashlight/lamp/green,
		/obj/item/flashlight,
		/obj/item/flashlight,
		/obj/item/flashlight,
		/obj/item/flashlight,
	)
	crate_name = "灯源补给箱"

/datum/supply_pack/service/medieval
	name = "复古武装包"
	desc = "包含两套真正的盔甲和剑, 还有两套护胸甲和弓供躲在后方的卑鄙小人使用."
	cost = CARGO_CRATE_VALUE * 30
	contraband = TRUE
	contains = list(
		/obj/item/clothing/suit/armor/riot/knight/larp/red,
		/obj/item/clothing/gloves/plate/larp/red,
		/obj/item/clothing/head/helmet/knight/red,
		/obj/item/clothing/shoes/plate/larp/red,
		/obj/item/claymore/weak/weaker,
		/obj/item/clothing/shoes/plate/larp/blue,
		/obj/item/clothing/suit/armor/riot/knight/larp/blue,
		/obj/item/clothing/gloves/plate/larp/blue,
		/obj/item/clothing/head/helmet/knight/blue,
		/obj/item/claymore/weak/weaker,
		/obj/item/clothing/suit/armor/vest/cuirass/larp,
		/obj/item/clothing/suit/armor/vest/cuirass/larp,
		/obj/item/gun/ballistic/bow/longbow,
		/obj/item/gun/ballistic/bow/longbow,
		/obj/item/storage/bag/quiver,
		/obj/item/storage/bag/quiver,
		/obj/item/clothing/head/helmet/knight/red,
		/obj/item/clothing/head/helmet/knight/blue,
		/obj/item/food/bread/plain,
	)
	crate_name = "复古箱"

/datum/supply_pack/organic/lavalandsamples
	name = "外星植物样本合集"
	desc = "一箱从拉瓦兰采集的样本，需要具备水培权限才能打开."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_HYDROPONICS
	contains = list(
		/obj/item/seeds/lavaland/polypore,
		/obj/item/seeds/lavaland/porcini,
		/obj/item/seeds/lavaland/inocybe,
		/obj/item/seeds/lavaland/ember,
		/obj/item/seeds/lavaland/seraka,
		/obj/item/seeds/lavaland/fireblossom,
		/obj/item/seeds/lavaland/cactus,
	)
	crate_name = "外星种子箱"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/service/MODsuit_cargo
	name = "货运模块服"
	desc = "内含一套货运模块服, 已配装标准货运模块."
	cost = CARGO_CRATE_VALUE * 13
	access_view = ACCESS_CARGO
	contains = list(/obj/item/mod/control/pre_equipped/loader)
	crate_name = "货运模块服补给箱"

/datum/supply_pack/service/snowmobile
	name = "雪地车"
	desc = "困于辽阔雪原? 需要日行千里? 现在购买雪地车还附赠十微妙保修!"
	cost = CARGO_CRATE_VALUE * 7.5
	contains = list(
		/obj/vehicle/ridden/atv/snowmobile = 1,
		/obj/item/key/atv = 1,
		/obj/item/clothing/mask/gas/explorer = 1,
	)
	crate_name = "雪地车"
	crate_type = /obj/structure/closet/crate/large

/*
*	MATERIALS AND SHEETS
*/

/datum/supply_pack/materials/rawlumber
	name = "20 塔盖 原木"
	desc = "这些优质塔盖原木可以搭建露天烧烤或沙滩篝火!"
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/grown/log)
	crate_name = "木材箱"

/datum/supply_pack/materials/rawlumber/generate()
	. = ..()
	for(var/i in 1 to 19)
		new /obj/item/grown/log(.)

/datum/supply_pack/imports/cin_surplus
	name = "CIN 军用物资箱"
	desc = "来自Coalition of Independent Nations-独立国家联盟的淘汰军事物资，包含了旧式过时的军事装备."
	contraband = TRUE
	cost = CARGO_CRATE_VALUE * 9
	contains = list(
		/obj/item/storage/box/colonial_rations = 1,
		/obj/item/storage/toolbox/ammobox/strilka310 = 1,
		/obj/item/storage/toolbox/ammobox/strilka310/surplus = 1,
		/obj/item/storage/toolbox/maint_kit = 1,
		/obj/item/storage/toolbox/guncase/soviet/sakhno = 2,
		/obj/item/ammo_box/strilka310 = 1,
		/obj/item/clothing/suit/armor/vest/cin_surplus_vest = 1,
		/obj/item/clothing/head/helmet/cin_surplus_helmet/random_color = 1,
		/obj/item/storage/backpack/industrial/cin_surplus/random_color = 1,
		/obj/item/storage/belt/military/cin_surplus/random_color = 1,
		/obj/item/clothing/gloves/tackler/combat = 1,
		/obj/item/clothing/under/syndicate/rus_army/cin_surplus/random_color = 1,
		/obj/item/clothing/shoes/jackboots = 1,
		/obj/item/clothing/mask/gas/hecu2 = 1,
		/obj/item/clothing/mask/balaclavaadjust = 1,
	)

/datum/supply_pack/imports/cin_surplus/fill(obj/structure/closet/crate/we_are_filling_this_crate)
	for(var/i in 1 to 10)
		var/item = pick_weight(contains)
		new item(we_are_filling_this_crate)

/*
* VENDING RESTOCKS
*/

/datum/supply_pack/vending/dorms
	name = "LustWish 补货单元"
	desc = "这个箱子包含了LustWish 自动售货机的补货单元."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/lustwish)

/datum/supply_pack/vending/barber
	name = "Fab-O-Vend 补货单元"
	desc = "这个箱子包含了Fab-O-Vend 自动收货机的补货单元."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/barbervend)
