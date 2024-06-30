/datum/supply_pack/misc
	group = "杂项用品"

/datum/supply_pack/misc/artsupply
	name = "艺术用品包"
	desc = "为生活提供多些艺趣, \
		内含三个喷雾罐和各色蜡笔以及一个艺术工具箱!"
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(/obj/item/rcl,
					/obj/item/storage/toolbox/artistic,
					/obj/item/toy/crayon/spraycan = 3,
					/obj/item/storage/crayons,
					/obj/item/toy/crayon/white,
					/obj/item/toy/crayon/rainbow,
				)
	crate_name = "艺术用品箱"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/tattoo_kit
	name = "纹身工具包"
	desc = "一个纹身包，里面附带一些墨水."
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(
		/obj/item/tattoo_kit,
		/obj/item/toner = 2)
	crate_name = "纹身工具箱"
	crate_type = /obj/structure/closet/crate/wooden
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

/datum/supply_pack/misc/bicycle
	name = "自行车"
	desc = "纳米传讯提醒员工们永远不要滥用职权."
	cost = 1000000 //Special case, we don't want to make this in terms of crates because having bikes be a million credits is the whole meme.
	contains = list(/obj/vehicle/ridden/bicycle)
	crate_name = "自行车箱"
	crate_type = /obj/structure/closet/crate/large
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/misc/bigband
	name = "名牌乐器收藏品"
	desc = "让站点流淌在动人的乐曲中! \
		内含九种乐器!"
	cost = CARGO_CRATE_VALUE * 10
	crate_name = "名牌乐器收藏箱"
	contains = list(/obj/item/instrument/violin,
					/obj/item/instrument/guitar,
					/obj/item/instrument/glockenspiel,
					/obj/item/instrument/accordion,
					/obj/item/instrument/saxophone,
					/obj/item/instrument/trombone,
					/obj/item/instrument/recorder,
					/obj/item/instrument/harmonica,
					/obj/structure/musician/piano/unanchored,
				)
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/book_crate
	name = "书籍补给包"
	desc = "来自Nanotrasen档案馆, 这七本肯定是很好的读物."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_LIBRARY
	contains = list(/obj/item/book/codex_gigas,
					/obj/item/book/manual/random = 3,
					/obj/item/book/random = 3,
				)
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/commandkeys
	name = "指挥频道密匙"
	desc = "一组加密密钥，用于访问指挥无线电频道. \
		纳米传讯提醒未授权的员工不要窃听指挥无线电频道, \
		也要尽量减少对指挥人员的诘问."
	access_view = ACCESS_COMMAND
	access = ACCESS_COMMAND
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/encryptionkey/headset_com = 3)
	crate_type = /obj/structure/closet/crate/secure/centcom
	crate_name = "指挥频道密匙箱"

/datum/supply_pack/misc/exploration_drone
	name = "勘探无人机"
	desc = "可改装型远距勘探无人机."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/exodrone)
	crate_name = "勘探无人机箱"

/datum/supply_pack/misc/exploration_fuel
	name = "无人机燃料罐"
	desc = "为探险无人机准备的燃料罐."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/fuel_pellet)
	crate_name = "探险无人机燃料箱"

/datum/supply_pack/misc/paper
	name = "文书用品包"
	desc = "办公桌上堆积如山的文件是个大问题 - 使用文书用品将其归档整理，\
		内含六支钢笔、一些照相胶卷、手持标签器、一个打印纸盒, 一个复写纸盒，\
		三个文件夹、一支激光笔、两个剪贴板和两枚邮票."
	cost = CARGO_CRATE_VALUE * 3.2
	contains = list(/obj/structure/filingcabinet/chestdrawer/wheeled,
					/obj/item/camera_film,
					/obj/item/hand_labeler,
					/obj/item/hand_labeler_refill = 2,
					/obj/item/paper_bin,
					/obj/item/paper_bin/carbon,
					/obj/item/pen/fourcolor = 2,
					/obj/item/pen,
					/obj/item/pen/fountain,
					/obj/item/pen/blue,
					/obj/item/pen/red,
					/obj/item/folder/blue,
					/obj/item/folder/red,
					/obj/item/folder/yellow,
					/obj/item/clipboard = 2,
					/obj/item/stamp,
					/obj/item/stamp/denied,
					/obj/item/laser_pointer/purple,
				)
	crate_name = "文书用品箱"

/datum/supply_pack/misc/fountainpens
	name = "写字用品"
	desc = "用这七支行政钢笔签署死刑令."
	cost = CARGO_CRATE_VALUE * 1.45
	contains = list(/obj/item/storage/box/fountainpens)
	crate_type = /obj/structure/closet/crate/wooden
	crate_name = "写字用品箱"

/datum/supply_pack/misc/wrapping_paper
	name = "彩色包装纸"
	desc = "想要给你爱的人一份节日惊喜吗? \
		节日风格的彩色包装纸可以帮助您."
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(/obj/item/stack/wrapping_paper)
	crate_type = /obj/structure/closet/crate/wooden
	crate_name = "彩色包装纸箱"


/datum/supply_pack/misc/funeral
	name = "殡葬用品包"
	desc = "总有一天我们都会死，那时我们希望会有一场体面的送行，\
		内含丧服与鲜花."
	cost = CARGO_CRATE_VALUE * 1.6
	access_view = ACCESS_CHAPEL_OFFICE
	contains = list(/obj/item/clothing/under/misc/burial,
					/obj/item/food/grown/harebell,
					/obj/item/food/grown/poppy/geranium,
				)
	crate_name = "棺材"
	crate_type = /obj/structure/closet/crate/coffin

/datum/supply_pack/misc/empty
	name = "空补给仓"
	desc = "展示全新的Nanotrasen牌蓝空补给仓! 运输货物优雅自如! \
		今天订购我们将做出演示!"
	cost = CARGO_CRATE_VALUE * 0.6 //Empty pod, so no crate refund
	contains = list()
	drop_pod_only = TRUE
	crate_type = null
	special_pod = /obj/structure/closet/supplypod/bluespacepod

/datum/supply_pack/misc/empty/generate(atom/A, datum/bank_account/paying_account)
	return

/datum/supply_pack/misc/religious_supplies
	name = "宗教用品包"
	desc = "让你当地的牧师感到高兴和供应充足, 以免他们对你的货舱进行绝罚，\
		内含两瓶圣水、圣经、牧师长袍和丧服."
	cost = CARGO_CRATE_VALUE * 6 // it costs so much because the Space Church needs funding to build a cathedral
	access_view = ACCESS_CHAPEL_OFFICE
	contains = list(/obj/item/reagent_containers/cup/glass/bottle/holywater = 2,
					/obj/item/book/bible/booze = 2,
					/obj/item/clothing/suit/hooded/chaplain_hoodie = 2,
					/obj/item/clothing/under/misc/burial = 2,
				)
	crate_name = "宗教用品箱"

/datum/supply_pack/misc/candles_bulk
	name = "蜡烛盒子"
	desc = "用三个蜡烛盒子点亮你当地的教堂!"
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/storage/fancy/candle_box = 3)
	crate_name = "蜡烛盒子箱"

/datum/supply_pack/misc/toner
	name = "墨粉包"
	desc = "花太多墨粉打印屁股图片呢? 补充了这六盒墨粉, \
		你会一直印屁股直到母牛回家!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/toner = 6)
	crate_name = "墨粉箱"

/datum/supply_pack/misc/toner_large
	name = "墨粉(大号)"
	desc = "厌倦了更换墨盒? 这六盒额外的大型墨粉盒容量是普通的约五倍 \
		你能一直印到天荒地老!"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/toner/large = 6)
	crate_name = "大号墨粉箱"

/datum/supply_pack/misc/training_toolbox
	name = "训练工具箱"
	desc = "用AURUMILL品牌的训练工具箱磨砺你的战斗技术! \
		保证能算出对活人的命中数!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/training_toolbox = 2)
	crate_name = "训练工具箱补给箱"

///Special supply crate that generates random syndicate gear up to a determined TC value
/datum/supply_pack/misc/syndicate
	name = "各类辛迪加装备"
	desc = "包含一个随机的辛迪加装备."
	special = TRUE //Cannot be ordered via cargo
	contains = list()
	crate_name = "辛迪加装备箱"
	crate_type = /obj/structure/closet/crate
	///Total TC worth of contained uplink items
	var/crate_value = 30
	///What uplink the contents are pulled from
	var/contents_uplink_type = UPLINK_TRAITORS

///Generate assorted uplink items, taking into account the same surplus modifiers used for surplus crates
/datum/supply_pack/misc/syndicate/fill(obj/structure/closet/crate/C)
	var/list/uplink_items = list()
	for(var/datum/uplink_item/item_path as anything in SStraitor.uplink_items_by_type)
		var/datum/uplink_item/item = SStraitor.uplink_items_by_type[item_path]
		if(item.purchasable_from & contents_uplink_type && item.item)
			uplink_items += item

	while(crate_value)
		var/datum/uplink_item/uplink_item = pick(uplink_items)
		if(!uplink_item.surplus || prob(100 - uplink_item.surplus))
			continue
		if(length(uplink_item.restricted_roles) || length(uplink_item.restricted_species))
			continue
		if(crate_value < uplink_item.cost)
			continue
		crate_value -= uplink_item.cost
		new uplink_item.item(C)

///Syndicate supply crate that can have its contents value changed by admins, uses a seperate datum to avoid having admins touch the original one.
/datum/supply_pack/misc/syndicate/custom_value

/datum/supply_pack/misc/syndicate/custom_value/proc/setup_contents(value, uplink)
	crate_value = value
	contents_uplink_type = uplink

/datum/supply_pack/misc/papercutter
	name = "裁纸用品包"
	desc = "包含三个办公级裁纸刀，配有锋利的刀片，可以将任何纸张剪成两片薄片.\
		附赠可更换刀片."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(
		/obj/item/papercutter = 3,
		/obj/item/hatchet/cutterblade = 1,
	)
	crate_name = "裁纸用品箱"
