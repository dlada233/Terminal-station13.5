/datum/market_item/tool
	category = "工具"

/datum/market_item/tool/caravan_wrench
	name = "实验性扳手"
	desc = "是你一直想要的更快和更便捷的扳手."
	item = /obj/item/wrench/caravan
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	availability_prob = 20

/datum/market_item/tool/caravan_wirecutters
	name = "实验性剪线钳"
	desc = "是你一直想要的更块和更便捷的剪线钳."
	item = /obj/item/wirecutters/caravan
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	availability_prob = 20

/datum/market_item/tool/caravan_screwdriver
	name = "实验性螺丝刀"
	desc = "是你一直想要的更块和更便捷的螺丝刀."
	item = /obj/item/screwdriver/caravan
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	availability_prob = 20

/datum/market_item/tool/caravan_crowbar
	name = "实验性撬棍"
	desc = "是你一直想要的更块和更便捷的撬棍."
	item = /obj/item/crowbar/red/caravan
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	availability_prob = 20

/datum/market_item/tool/binoculars
	name = "双筒望远镜"
	desc = "用这个方便的工具增加你的视野150%."
	item = /obj/item/binoculars
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4.8
	availability_prob = 30

/datum/market_item/tool/riot_shield
	name = "防爆盾牌"
	desc = "从条子暴动中保护自己."
	item = /obj/item/shield/riot

	price_min = CARGO_CRATE_VALUE * 2.25
	price_max = CARGO_CRATE_VALUE * 3.25
	stock_max = 2
	availability_prob = 50

/datum/market_item/tool/thermite_bottle
	name = "铝热剂瓶"
	desc = "30u的铝热剂，帮助你快速切开一个入口."
	item = /obj/item/reagent_containers/cup/bottle/thermite

	price_min = CARGO_CRATE_VALUE * 2.5
	price_max = CARGO_CRATE_VALUE * 7.5
	stock_max = 3
	availability_prob = 30

/datum/market_item/tool/science_goggles
	name = "科研护目镜"
	desc = "这些护目镜可以扫描容器的内容物并提供可视化数据."
	item = /obj/item/clothing/glasses/science

	price_min = CARGO_CRATE_VALUE * 0.75
	price_max = CARGO_CRATE_VALUE
	stock_max = 3
	availability_prob = 50

/**
 * # Fake N-spect scanner black market entry
 */
/datum/market_item/tool/fake_scanner
	name = "Clowny N-spect scanner"
	desc = "这款升级的N-spect扫描仪可以播放五种高质量的声音(不附赠声音调节所需叉子)和闪电般的打印速度(不附赠速度调节所需螺丝刀). \
	我们不要求它发表的报告是否有用. \
	如果设备被触摸、移动、踢、扔或用香蕉片改造，以上任何保证都将失效. \
	附赠电池，但不附赠更换电池和调整设置所需的撬棍."
	item = /obj/item/inspector/clown

	price_min = CARGO_CRATE_VALUE * 1.15
	price_max = CARGO_CRATE_VALUE * 1.615
	stock_max = 2
	availability_prob = 50

/datum/market_item/tool/program_disk
	name = "盗版数据盘"
	desc = "包含EXCLUSIVE和LIMITED模块程序的数据磁盘，从法律上讲，我不能告诉你我是怎么得到的."
	item = /obj/item/computer_disk/black_market
	price_min = CARGO_CRATE_VALUE * 0.75
	price_max = CARGO_CRATE_VALUE * 2
	stock_max = 3
	availability_prob = 40
