/datum/market_item/misc
	category = "杂项"
	abstract_path = /datum/market_item/misc

/datum/market_item/misc/Clear_PDA
	name = "透明PDA"
	desc = "用这款限量版透明PDA展示你的不羁."
	item = /obj/item/modular_computer/pda/clear

	price_min = CARGO_CRATE_VALUE * 1.25
	price_max = CARGO_CRATE_VALUE *3
	stock_max = 2
	availability_prob = 50

/datum/market_item/misc/jade_Lantern
	name = "玉提灯"
	desc = "在一个标有‘放射性危险’的铅盒子里发现的，显然是安全的."
	item = /obj/item/flashlight/lantern/jade

	price_min = CARGO_CRATE_VALUE * 0.75
	price_max = CARGO_CRATE_VALUE * 2.5
	stock_max = 2
	availability_prob = 45

/datum/market_item/misc/cap_gun
	name = "发火帽枪"
	desc = "用这把无害的枪恶作剧你的朋友！没有反转."
	item = /obj/item/toy/gun

	price_min = CARGO_CRATE_VALUE * 0.25
	price_max = CARGO_CRATE_VALUE
	stock_max = 6
	availability_prob = 80

/datum/market_item/misc/shoulder_holster
	name = "肩挂式枪套"
	desc = "呵呵，侦探迷朋友们！这个枪套是成为一名侦探并被允许射击真枪的第一步！"
	item = /obj/item/storage/belt/holster

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	stock_max = 8
	availability_prob = 60

/datum/market_item/misc/donk_recycler
	name = "泡沫弹回收模块"
	desc = "如果你喜欢射玩具枪，又讨厌打扫，并且有一套模块服，这个模块是必须有的."
	item = /obj/item/mod/module/recycler/donk
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4.5
	stock_max = 2
	availability_prob = 30

/datum/market_item/misc/shove_blocker
	name = "MOD Bulwark Module"
	desc = "You have no idea how much effort it took us to extract this module from that damn safeguard MODsuit last shift."
	item = /obj/item/mod/module/shove_blocker
	price_min = CARGO_CRATE_VALUE * 4
	price_max = CARGO_CRATE_VALUE * 5.75
	stock_max = 1
	availability_prob = 25

/datum/market_item/misc/holywater
	name = "圣水瓶"
	desc = "卢修斯神父牌的现成圣水"
	item = /obj/item/reagent_containers/cup/glass/bottle/holywater

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 3
	stock_max = 3
	availability_prob = 40

/datum/market_item/misc/holywater/spawn_item(loc, datum/market_purchase/purchase)
	if (prob(6.66))
		item = /obj/item/reagent_containers/cup/beaker/unholywater
	else
		item = initial(item)
	return ..()

/datum/market_item/misc/strange_seed
	name = "奇怪的种子"
	desc = "一种奇怪的种子，可能种出发光到发酸的任何东西"
	item = /obj/item/seeds/random

	price_min = CARGO_CRATE_VALUE * 1.6
	price_max = CARGO_CRATE_VALUE * 1.8
	stock_min = 2
	stock_max = 5
	availability_prob = 50

/datum/market_item/misc/smugglers_satchel
	name = "走私挎包"
	desc = "这个挎包容量大，易隐蔽."
	item = /obj/item/storage/backpack/satchel/flat/empty

	price_min = CARGO_CRATE_VALUE * 3.75
	price_max = CARGO_CRATE_VALUE * 5
	stock_max = 2
	availability_prob = 30

/datum/market_item/misc/roulette
	name = "轮盘赌投送信标"
	desc = "开一个你自己的地下赌场，仅限一次使用，不提供退款."
	item = /obj/item/roulette_wheel_beacon
	price_min = CARGO_CRATE_VALUE * 1
	price_max = CARGO_CRATE_VALUE * 2.5
	stock_max = 3
	availability_prob = 50

/datum/market_item/misc/jawed_hook
	name = "颚型鱼钩"
	desc = "当你和大鱼搏斗时将会用到的东西，要记得在万事休矣前大声呼救，因为这东西会像狠狠地伤害到它们."
	item = /obj/item/fishing_hook/jaws
	price_min = CARGO_CRATE_VALUE * 0.75
	price_max = CARGO_CRATE_VALUE * 2
	stock_max = 3
	availability_prob = 70

/datum/market_item/misc/v8_engine
	name = "正版V8引擎 (珍藏版)"
	desc = "嘿，油猴子们，准备好发动引擎了吗？想要在大厅里狂飙？想在星际环城公路上做一些漂移动作吗？你需要这个经典的引擎."
	item = /obj/item/v8_engine
	price_min = CARGO_CRATE_VALUE * 4
	price_max = CARGO_CRATE_VALUE * 6
	stock_max = 1
	availability_prob = 15

/datum/market_item/misc/fish
	name = "鱼"
	desc = "鱼！好大的鱼！如果你想的话，你可以切鱼、磨鱼，甚至把鱼养在水族馆里也好！在我村子里的下一场战斗爆发前，赶紧弄点来！"
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 1.2
	item = /obj/item/storage/fish_case/blackmarket
	stock_min = 3
	stock_max = 8
	availability_prob = 90

/datum/market_item/misc/giant_wrench_parts
	name = "大零件"
	desc = "廉价非法的大零件，是最快也是最危险的扳手."
	item = /obj/item/weaponcrafting/giant_wrench
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 5
	stock_max = 1
	availability_prob = 25
