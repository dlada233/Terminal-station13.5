/datum/uplink_category/badassery
	name = "(毫无意义)玩具"
	weight = 0

/datum/uplink_item/badass
	category = /datum/uplink_category/badassery
	surplus = 0

/datum/uplink_item/badass/balloon
	name = "辛迪加气球"
	desc = "一个无用的红色气球，上面有辛迪加的标志. \
			只为彰显你是大佬."
	item = /obj/item/toy/balloon/syndicate
	cost = 20
	lock_other_purchases = TRUE
	cant_discount = TRUE
	illegal_tech = FALSE

/datum/uplink_item/badass/balloon/spawn_item(spawn_path, mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	. = ..()

	if(!.)
		return

	notify_ghosts(
		"[user] has purchased a BADASS Syndicate Balloon!",
		source = src,
		header = "What are they THINKING?",
	)

/datum/uplink_item/badass/syndiecards
	name = "辛迪加扑克"
	desc = "一种特殊的太空级扑克牌，有金属加固的牌身与单分子边缘, \
			这让它们比普通的扑克牌要坚固不少. \
			你也可以用来玩纸牌游戏，或者把它们留在你的猎物身上."
	item = /obj/item/toy/cards/deck/syndicate
	cost = 1
	surplus = 40
	illegal_tech = FALSE

/datum/uplink_item/badass/syndiecigs
	name = "辛迪加香烟"
	desc = "味道浓，烟味重，还含有医疗用的全嗪."
	item = /obj/item/storage/fancy/cigarettes/cigpack_syndicate
	cost = 2
	illegal_tech = FALSE

/datum/uplink_item/badass/syndiecash
	name = "装满现金的辛迪加公文包"
	desc = "一个装有5000cr的安全公文包，\
			用于进行贿赂，或以有利可图的价格购买商品和服务. \
			设计时进行了加固增重，所以如果你的客户需要一些强硬的说服力，用箱子本身来给他一个无法拒绝的提议."
	item = /obj/item/storage/briefcase/secure/syndie
	cost = 3
	restricted = TRUE
	illegal_tech = FALSE

/datum/uplink_item/badass/costumes/clown
	name = "小丑服饰"
	desc = "没有什么比拿着全自动武器的小丑更可怕的了."
	item = /obj/item/storage/backpack/duffelbag/clown/syndie
	purchasable_from = ALL
	progression_minimum = 70 MINUTES

/datum/uplink_item/badass/costumes/tactical_naptime
	name = "辛迪加睡衣"
	desc = "即使是士兵也需要晚上好好休息，配有血红色睡衣、毯子、热可可杯和毛茸茸的玩偶."
	item = /obj/item/storage/box/syndie_kit/sleepytime
	purchasable_from = ALL
	progression_minimum = 90 MINUTES
	cost = 4
	limited_stock = 1
	cant_discount = TRUE

/datum/uplink_item/badass/costumes/obvious_chameleon
	name = "劣质变色龙套件"
	desc = "一套包含变色龙技术的物品，可以让你伪装成空间站上的任何东西甚至更多! \
			请注意，这个套件盒还没有经过质检."
	purchasable_from = ALL
	progression_minimum = 90 MINUTES
	item = /obj/item/storage/box/syndie_kit/chameleon/broken

/datum/uplink_item/badass/costumes/centcom_official
	name = "中央指挥部官员服饰"
	desc = "大摇大摆地要求\"检查\"船员们的核磁盘和武器，然后当被拒绝时就掏出全自动步枪射杀舰长. \
			购买后不附赠加密密钥，也不附赠枪."
	purchasable_from = ALL
	progression_minimum = 110 MINUTES
	item = /obj/item/storage/box/syndie_kit/centcom_costume

/datum/uplink_item/badass/stickers
	name = "辛迪加贴纸盒"
	desc = "包含8个随机贴纸，都是可疑物体的样子，你可以将贴纸贴在任何地方，外人不调查就辨认不出来."
	item = /obj/item/storage/box/syndie_kit/stickers
	cost = 1

/datum/uplink_item/badass/demotivational_posters
	name = "辛迪加宣传海报"
	desc = "包含一系列打击士气的海报，用这个来击溃空间站的心理防线吧！"
	item = /obj/item/storage/box/syndie_kit/poster_box
	cost = 1

/datum/uplink_item/badass/syndie_spraycan
	name = "辛迪加喷雾罐"
	desc = "时髦的辛迪加喷雾罐. \
		含有足够的特殊成分来绘画出一个超大的煽动性符号，使站点的人们遭受脚滑的痛苦."
	item = /obj/item/traitor_spraycan
	cost = 1
