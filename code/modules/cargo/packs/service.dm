/datum/supply_pack/service
	group = "服务用品"

/datum/supply_pack/service/cargo_supples
	name = "货仓用品"
	desc = "用于运行货仓的所有物资，\
		里面有印章、出口扫描仪、标签机还有\
		一些包装纸."
	cost = CARGO_CRATE_VALUE * 1.75
	contains = list(/obj/item/stamp,
					/obj/item/stamp/denied,
					/obj/item/universal_scanner,
					/obj/item/dest_tagger,
					/obj/item/hand_labeler,
					/obj/item/stack/package_wrap,
				)
	crate_name = "货仓用品箱"

/datum/supply_pack/service/noslipfloor
	name = "防滑地砖"
	desc = "三十块工业级防滑地砖让滑到成为过去!"
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_JANITOR
	contains = list(/obj/item/stack/tile/noslip/thirty)
	crate_name = "防滑地砖箱"

/datum/supply_pack/service/janitor
	name = "清洁用品"
	desc = "用以对抗无尽的脏乱! 内含三个桶、地滑标志和清洁手榴弹以及多种清洁工具."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_JANITOR
	contains = list(/obj/item/reagent_containers/cup/bucket = 3,
					/obj/item/mop,
					/obj/item/pushbroom,
					/obj/item/clothing/suit/caution = 3,
					/obj/item/storage/bag/trash,
					/obj/item/reagent_containers/spray/cleaner,
					/obj/item/reagent_containers/cup/rag,
					/obj/item/grenade/chem_grenade/cleaner = 3,
				)
	crate_name = "清洁用品箱"

/datum/supply_pack/service/janitor/janicart
	name = "清洁车与防滑鞋"
	desc = "防滑鞋能使你不受路面湿滑影响而滑到，清洁车可以帮助你存放工具与水."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/structure/mop_bucket/janitorialcart,
					/obj/item/clothing/shoes/galoshes,
				)
	crate_name = "清洁车与防滑鞋箱"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/janitor/janitank
	name = "清洁背式水箱"
	desc = "清洁工也要有重型装备."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_JANITOR
	contains = list(/obj/item/watertank/janitor)
	crate_name = "清洁背式水箱"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/service/mule
	name = "MULE骡子"
	desc = "被称为MULE骡子的机器人可以自动配送货物至指定地点."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/simple_animal/bot/mulebot)
	crate_name = "\improper MULE骡子箱"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/party
	name = "排队用品"
	desc = "今天我们欢聚在这里，就是为了欢聚在这里."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/storage/box/drinkingglasses,
					/obj/item/reagent_containers/cup/glass/shaker,
					/obj/item/reagent_containers/cup/glass/bottle/patron,
					/obj/item/reagent_containers/cup/glass/bottle/goldschlager,
					/obj/item/reagent_containers/cup/glass/bottle/ale = 2,
					/obj/item/storage/cans/sixbeer,
					/obj/item/storage/cans/sixsoda,
					/obj/item/flashlight/glowstick,
					/obj/item/flashlight/glowstick/red,
					/obj/item/flashlight/glowstick/blue,
					/obj/item/flashlight/glowstick/cyan,
					/obj/item/flashlight/glowstick/orange,
					/obj/item/flashlight/glowstick/yellow,
					/obj/item/flashlight/glowstick/pink,
				)
	crate_name = "排队用品箱"

/datum/supply_pack/service/carpet
	name = "优质地毯组合"
	desc = "灰色地板看着糟心？铺上这些红色与黑色的地毯."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/stack/tile/carpet/fifty = 2,
					/obj/item/stack/tile/carpet/black/fifty = 2)
	crate_name = "优质地毯箱"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/service/carpet_exotic
	name = "异国地毯组合"
	desc = "华丽的异国地毯，里面竟然有整整100块，还有8种不同的种类."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/stack/tile/carpet/blue/fifty = 2,
					/obj/item/stack/tile/carpet/cyan/fifty = 2,
					/obj/item/stack/tile/carpet/green/fifty = 2,
					/obj/item/stack/tile/carpet/orange/fifty = 2,
					/obj/item/stack/tile/carpet/purple/fifty = 2,
					/obj/item/stack/tile/carpet/red/fifty = 2,
					/obj/item/stack/tile/carpet/royalblue/fifty = 2,
					/obj/item/stack/tile/carpet/royalblack/fifty = 2,
				)
	crate_name = "异国地毯箱"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/service/carpet_neon
	name = "霓虹地毯组合"
	desc = "带有磷光衬里的简单橡胶垫，包含120块，13种颜色的变体，限量发行中."
	cost = CARGO_CRATE_VALUE * 15
	contains = list(/obj/item/stack/tile/carpet/neon/simple/white/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/black/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/red/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/orange/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/yellow/sixty =2,
					/obj/item/stack/tile/carpet/neon/simple/lime/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/green/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/teal/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/cyan/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/blue/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/purple/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/violet/sixty = 2,
					/obj/item/stack/tile/carpet/neon/simple/pink/sixty = 2,
				)
	crate_name = "霓虹地毯箱"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/service/lightbulbs
	name = "灯泡补给"
	desc = "愿圣光庇护着你."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/lights/mixed = 3)
	crate_name = "灯泡箱"

/datum/supply_pack/service/minerkit
	name = "竖井矿工入门包"
	desc = "矿工都死下面了？想要孤僻更贴近自然的工作？这里面有成为一个矿工所有需要的装备."
	cost = CARGO_CRATE_VALUE * 4
	access = ACCESS_QM
	access_view = ACCESS_MINING_STATION
	contains = list(/obj/item/storage/backpack/duffelbag/mining_conscript)
	crate_name = "竖井矿工入门箱"
	crate_type = /obj/structure/closet/crate/secure/cargo/mining

/datum/supply_pack/service/survivalknives
	name = "生存匕首包"
	desc = "三把锋利的求生刀，你可以把刀舒适地装入靴子里."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/knife/combat/survival = 3)
	crate_name = "生存匕首箱"
	crate_type = /obj/structure/closet/crate/cargo/mining

/datum/supply_pack/service/wedding
	name = "婚礼用品"
	desc = "内含婚纱、西服与鲜花美酒，现在只缺一个司仪了."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/under/dress/wedding_dress,
					/obj/item/clothing/under/suit/tuxedo,
					/obj/item/storage/belt/fannypack/cummerbund,
					/obj/item/clothing/head/costume/weddingveil,
					/obj/item/bouquet,
					/obj/item/bouquet/sunflower,
					/obj/item/bouquet/poppy,
					/obj/item/reagent_containers/cup/glass/bottle/champagne,
				)
	crate_name = "婚礼用品箱"

/// Box of 7 grey IDs.
/datum/supply_pack/service/greyidbox
	name = "空白普通ID卡补给包"
	desc = "一盒七张的空白普通ID卡."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/ids)
	crate_name = "普通ID卡箱"

/// Single silver ID.
/datum/supply_pack/service/silverid
	name = "空白银ID卡补给包"
	desc = "银色ID卡往往只给主管级别的人物持有，能在上面分配更多的权限."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/card/id/advanced/silver)
	crate_name = "银ID卡箱"

/datum/supply_pack/service/emptycrate
	name = "空板条箱"
	desc = "就是一个空板条箱，用来储存东西."
	cost = CARGO_CRATE_VALUE * 1.4 //Net Zero Profit.
	contains = list()
	crate_name = "板条箱"

/datum/supply_pack/service/randomized/donkpockets
	name = "多味口袋饼组合"
	desc = "Donk Co-杜客公司最受欢迎的产品，\
		现在订购随机获得四种口味."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/storage/box/donkpockets/donkpocketspicy,
					/obj/item/storage/box/donkpockets/donkpocketteriyaki,
					/obj/item/storage/box/donkpockets/donkpocketpizza,
					/obj/item/storage/box/donkpockets/donkpocketberry,
					/obj/item/storage/box/donkpockets/donkpockethonk,
				)
	crate_name = "口袋饼箱"
	crate_type = /obj/structure/closet/crate/freezer/food

/datum/supply_pack/service/randomized/donkpockets/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 3)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/service/randomized/ready_donk
	name = "杜客快捷餐组合包"
	desc = "包含三种随机口味的Donk快捷餐."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/food/ready_donk,
					/obj/item/food/ready_donk/mac_n_cheese,
					/obj/item/food/ready_donk/donkhiladas,
				)
	crate_name = "\improper 杜客快捷餐箱"
	crate_type = /obj/structure/closet/crate/freezer/food
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/service/randomized/ready_donk/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 3)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/service/coffeekit
	name = "咖啡用品组合"
	desc = "一个完整的组合包，可用于建立你自己的咖啡馆，很不幸咖啡机由于某些原因则没有包括在内."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/storage/box/coffeepack/robusta,
		/obj/item/storage/box/coffeepack,
		/obj/item/reagent_containers/cup/coffeepot,
		/obj/item/storage/fancy/coffee_condi_display,
		/obj/item/reagent_containers/cup/glass/bottle/juice/cream,
		/obj/item/reagent_containers/condiment/milk,
		/obj/item/reagent_containers/condiment/soymilk,
		/obj/item/reagent_containers/condiment/sugar,
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/caramel, //one extra syrup as a treat
	)
	crate_name = "咖啡用品组合"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/service/coffeemaker
	name = "谐印牌咖啡机"
	desc = "一台组装好的谐印牌咖啡机."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/machinery/coffeemaker/impressa)
	crate_name = "咖啡机箱"
	crate_type = /obj/structure/closet/crate/large
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/service/aquarium_kit
	name = "水族馆套件"
	desc = "开办自己的水族馆所需要的一切，包含水族馆建设工具包，鱼类目录，鱼食饵料和三种淡水鱼."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/book/manual/fish_catalog,
					/obj/item/storage/fish_case/random/freshwater = 3,
					/obj/item/fish_feed,
					/obj/item/storage/box/aquarium_props,
					/obj/item/aquarium_kit,
				)
	crate_name = "水族馆套件箱"
	crate_type = /obj/structure/closet/crate/wooden
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/// Spare bar sign wallmount
/datum/supply_pack/service/bar_sign
	name = "吧牌"
	desc = "一个完美的吧牌，能展示出绚烂多彩的图案以招揽顾客."
	cost = CARGO_CRATE_VALUE * 14
	contains = list(/obj/item/wallframe/barsign/all_access)
	crate_name = "吧牌箱"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE
