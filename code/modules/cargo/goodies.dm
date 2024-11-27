
/datum/supply_pack/goody
	access = NONE
	group = "小商品"
	goody = TRUE
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

/datum/supply_pack/goody/clear_pda
	name = "全新的纳米传讯牌透明款PDA"
	desc = "崭新出厂，物美价廉!这款收藏品通常价值超过250万信用点，现在限时特价!"
	cost = 100000
	contains = list(/obj/item/modular_computer/pda/clear)

/datum/supply_pack/goody/dumdum38
	name = "快速装弹器(.38 达姆弹)"
	desc = "包含一个装满.38 达姆弹的快速装弹器，对软目标威力巨大."
	cost = PAYCHECK_CREW * 2
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/ammo_box/c38/dumdum)

/datum/supply_pack/goody/match38
	name = "快速装弹器(.38 竞赛弹)"
	desc = "包含一个装满.38 竞赛弹的快速装弹器，用来炫耀花式射击的完美选择."
	cost = PAYCHECK_CREW * 2
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/ammo_box/c38/match)

/datum/supply_pack/goody/rubber
	name = "快速装弹器(.38 橡胶弹)"
	desc = "包含一个装满.38 橡胶弹的快速装弹器，你想体验子弹往四面八方跳弹时."
	cost = PAYCHECK_CREW * 1.5
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/ammo_box/c38/match/bouncy)

/datum/supply_pack/goody/mars_single
	name = "柯尔特警探特装左轮单品包"
	desc = "安保部长没收了你的枪和徽章？没问题！只要支付一笔荒谬的税费，你就能再次拥有致命火力———把.38 左轮手枪!"
	cost = PAYCHECK_CREW * 40 //they really mean a premium here
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/ballistic/revolver/c38/detective)

/datum/supply_pack/goody/stingbang
	name = "碎裂手榴弹单品包"
	desc = "包含一枚\"碎裂\"手榴弹，适合不怀好意的恶作剧."
	cost = PAYCHECK_COMMAND * 2.5
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/grenade/stingbang)

/datum/supply_pack/goody/Survivalknives_single
	name = "生存刀单品包"
	desc = "包含一把锋利的求生刀. 可完美放入任何纳米传讯的制式靴子中."
	cost = PAYCHECK_COMMAND * 1.75
	contains = list(/obj/item/knife/combat/survival)

/datum/supply_pack/goody/ballistic_single
	name = "战斗散弹枪单品包"
	desc = "当敌人眼里需要长铅弹的时候使用. 包含Aussec设计的战斗霰弹枪和子弹带."
	cost = PAYCHECK_COMMAND * 15
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/gun/ballistic/shotgun/automatic/combat, /obj/item/storage/belt/bandolier)

/datum/supply_pack/goody/disabler_single
	name = "镇暴光枪单品包"
	desc = "包含一把镇暴光枪，纳米传讯安保部大量配发的非致命制伏利器. 附赠能量枪套，方便你携带额外的镇爆光枪."
	cost = PAYCHECK_COMMAND * 3
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/storage/belt/holster/energy/disabler)

/datum/supply_pack/goody/energy_single
	name = "光能枪单品包"
	desc = "包含一把能量枪，能发射非致命和致命的光束."
	cost = PAYCHECK_COMMAND * 12
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/energy/e_gun)

/datum/supply_pack/goody/laser_single
	name = "能量枪单品包"
	desc = "包含一把能量枪，纳米传讯安保人员大量配发的致命主力武器."
	cost = PAYCHECK_COMMAND * 6
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/energy/laser)

/datum/supply_pack/goody/hell_single
	name = "地狱光能枪单品包"
	desc = "包含一套降级的地狱枪套件，这是一款老式光能枪，因其可对目标造成可怕的烧伤而臭名昭著. 对人形生物使用时，技术上违反了太空日内瓦公约."
	cost = PAYCHECK_CREW * 2
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/weaponcrafting/gunkit/hellgun)

/datum/supply_pack/goody/thermal_single
	name = "热力双枪单品包"
	desc = "包含一个枪套，内含两把实验性热力手枪，蓄势待发."
	cost = PAYCHECK_COMMAND * 15
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/storage/belt/holster/energy/thermal)

/datum/supply_pack/goody/sologamermitts
	name = "绝缘手套单品包"
	desc = "现代社会的支柱，但订购的人没几个真用来施工的."
	cost = PAYCHECK_CREW * 8
	contains = list(/obj/item/clothing/gloves/color/yellow)

/datum/supply_pack/goody/gorilla_single
	name = "大猩猩手套单品包"
	desc = "一副备用的大猩猩手套，比安保售货机提供的抓握手套更适合擒抱."
	cost = PAYCHECK_COMMAND * 6
	contains = list(/obj/item/clothing/gloves/tackler/combat)

/datum/supply_pack/goody/firstaidbruises_single
	name = "创伤医疗箱单品包"
	desc = "一个创伤医疗箱，非常适合治疗被气闸压伤的创口. 你知道吗？人们经常被气闸压伤，真有意思..."
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/storage/medkit/brute)

/datum/supply_pack/goody/firstaidburns_single
	name = "烧伤医疗箱单品包"
	desc = "一个烧伤医疗箱. 广告上，一个单眨眼睛的气象技术员笑着说：\"马有失蹄，人有失足！\""
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/storage/medkit/fire)

/datum/supply_pack/goody/firstaid_single
	name = "急救箱单品包"
	desc = "一个急救箱，可有效处理大多数身体伤害."
	cost = PAYCHECK_CREW * 3
	contains = list(/obj/item/storage/medkit/regular)

/datum/supply_pack/goody/firstaidoxygen_single
	name = "窒息医疗箱单品包"
	desc = " 一个窒息医疗箱，针对那些有严重窒息恐惧症的人进行了大力宣传."
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/storage/medkit/o2)

/datum/supply_pack/goody/firstaidtoxins_single
	name = "毒素医疗箱单品包"
	desc = "一个毒素医疗箱，专门用于治疗重度毒素伤害."
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/storage/medkit/toxin)

/datum/supply_pack/goody/bandagebox_singlepack
	name = "绷带盒单品包"
	desc = "一盒德福瑞斯特牌的绷带. 当你不想去找医生时."
	cost = PAYCHECK_CREW * 3
	contains = list(/obj/item/storage/box/bandages)

/datum/supply_pack/goody/toolbox // mostly just to water down coupon probability
	name = "机械工具箱"
	desc = "一个工具齐全的机械工具箱，适合那些懒得自己打印工具的人."
	cost = PAYCHECK_CREW * 3
	contains = list(/obj/item/storage/toolbox/mechanical)

/datum/supply_pack/goody/valentine
	name = "情人节贺卡"
	desc = "俘获你的真爱!内含一张情人节贺卡和一颗免费的心形糖果!"
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/paper/valentine, /obj/item/food/candyheart)

/datum/supply_pack/goody/beeplush
	name = "蜜蜂玩偶"
	desc = "这可能是你用辛苦赚来的钱买到的最有价值的东西."
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/toy/plush/beeplushie)

/datum/supply_pack/goody/blahaj
	name = "鲨鱼玩偶"
	desc = "温暖柔软的午睡小伙伴."
	cost = PAYCHECK_CREW * 5
	contains = list(/obj/item/toy/plush/shark)

/datum/supply_pack/goody/dog_bone
	name = "巨无霸狗骨头"
	desc = "这是空间站上能买到的最好的出口狗骨头.送给狗狗的完美礼物."
	cost = PAYCHECK_COMMAND * 4
	contains = list(/obj/item/dog_bone)

/datum/supply_pack/goody/dyespray
	name = "染发喷剂"
	desc = "一瓶炫酷的喷剂，让你染出炫丽色彩!"
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/dyespray)

/datum/supply_pack/goody/beach_ball
	name = "沙滩排球"
	// uses desc from item
	cost = PAYCHECK_CREW
	contains = list(/obj/item/toy/beach_ball/branded)

/datum/supply_pack/goody/beach_ball/New()
	..()
	var/obj/item/toy/beach_ball/branded/beachball_type = /obj/item/toy/beach_ball/branded
	desc = initial(beachball_type.desc)

/datum/supply_pack/goody/medipen_twopak
	name = "医疗笔两件包"
	desc = "包含一支标准肾上腺素医疗笔和一支标准急救医疗笔. 适用于事事做好了最坏打算的人."
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/reagent_containers/hypospray/medipen, /obj/item/reagent_containers/hypospray/medipen/ekit)

/datum/supply_pack/goody/mothic_rations
	name = "蛾类应急口粮补给包"
	desc = "一份蛾族舰队剩余的军用单人口粮包. 里面有3根口味随机的营养棒和一包Activin口香糖."
	cost = PAYCHECK_COMMAND * 2
	contains = list(/obj/item/storage/box/mothic_rations)

/datum/supply_pack/goody/ready_donk
	name = "Donk-杜客快捷餐单品包"
	desc = "专为终极懒汉设计的完整餐饮套餐. 含一份Donk-杜客快捷餐."
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/food/ready_donk)

/datum/supply_pack/goody/pill_mutadone
	name = "应急突变定药片"
	desc = "一颗用于治疗基因缺陷的药丸. 当你没法从医疗部获得治疗时使用."
	cost = PAYCHECK_CREW * 2.5
	contains = list(/obj/item/reagent_containers/pill/mutadone)

/datum/supply_pack/goody/rapid_lighting_device
	name = "快捷照明装置(RLD)"
	desc = "一种用于快速为区域提供光源的设备. 可用铁、等离子铁、玻璃或压缩物质筒进行装填."
	cost = PAYCHECK_CREW * 10
	contains = list(/obj/item/construction/rld)

/datum/supply_pack/goody/fishing_toolbox
	name = "钓鱼工具箱"
	desc = "一整套钓鱼工具，开启你的钓鱼冒险. 高级鱼钩和钓鱼线需额外购买."
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/storage/toolbox/fishing)

/datum/supply_pack/goody/fishing_hook_set
	name = "钓鱼钩套装"
	desc = "一套不同类型的鱼钩."
	cost = PAYCHECK_CREW
	contains = list(/obj/item/storage/box/fishing_hooks)

/datum/supply_pack/goody/fishing_line_set
	name = "钓鱼线套装"
	desc = "一套不同类型的钓鱼线."
	cost = PAYCHECK_CREW
	contains = list(/obj/item/storage/box/fishing_lines)

/datum/supply_pack/goody/fishing_hook_rescue
	name = "救援钓鱼钩"
	desc = "当你的矿工伙伴不幸失足掉进深渊时，你便是他们可仰仗的救星."
	cost = PAYCHECK_CREW * 12
	contains = list(/obj/item/fishing_hook/rescue)

/datum/supply_pack/goody/premium_bait
	name = "豪华鱼饵"
	desc = "当普通鱼饵满足不了你的时候."
	cost = PAYCHECK_CREW
	contains = list(/obj/item/bait_can/worm/premium)

/datum/supply_pack/goody/fish_feed
	name = "Can of Fish Food Single-Pack"
	desc = "For keeping your little friends fed and alive."
	cost = PAYCHECK_CREW * 1
	contains = list(/obj/item/fish_feed)

/datum/supply_pack/goody/naturalbait
	name = "Freshness Jars full of Natural Bait Single-Pack"
	desc = "Homemade in the Spinward Sector."
	cost = PAYCHECK_CREW * 4 //rock on
	contains = list(/obj/item/storage/pill_bottle/naturalbait)

/datum/supply_pack/goody/telescopic_fishing_rod
	name = "伸缩鱼竿"
	desc = "可伸缩式钓鱼竿，方便收纳放入背包."
	cost = PAYCHECK_CREW * 8
	contains = list(/obj/item/fishing_rod/telescopic)

/datum/supply_pack/goody/fish_analyzer
	name = "鱼类分析仪"
	desc = "一个鱼类分析仪，让你免受打印扫描仪所需科技未解锁之苦，可用于监测鱼类的状态和特征."
	cost = PAYCHECK_CREW * 2.5
	contains = list(/obj/item/fish_analyzer)

/datum/supply_pack/goody/fish_catalog
	name = "钓鱼图鉴"
	desc = "一本包含你需要的所有钓鱼信息的图鉴."
	cost = PAYCHECK_LOWER
	contains = list(/obj/item/book/manual/fish_catalog)

/datum/supply_pack/goody/coffee_mug
	name = "咖啡杯"
	desc = "一个普通的咖啡杯，用来喝咖啡."
	cost = PAYCHECK_LOWER
	contains = list(/obj/item/reagent_containers/cup/glass/mug)

/datum/supply_pack/goody/nt_mug
	name = "纳米传讯咖啡杯"
	desc = "一个印有你公司logo的蓝色马克杯. 通常在入职或公司活动中赠送，我们可以特别为您发送一个，只需支付少量费用."
	cost = PAYCHECK_LOWER
	contains = list(/obj/item/reagent_containers/cup/glass/mug/nanotrasen)

/datum/supply_pack/goody/coffee_cartridge
	name = "咖啡胶囊"
	desc = "用于咖啡机的普通咖啡胶囊. 可以泡四壶咖啡."
	cost = PAYCHECK_LOWER
	contains = list(/obj/item/coffee_cartridge)

/datum/supply_pack/goody/coffee_cartridge_fancy
	name = "高档咖啡胶囊"
	desc = "用于咖啡机的高档咖啡胶囊. 可以泡四壶咖啡."
	cost = PAYCHECK_CREW
	contains = list(/obj/item/coffee_cartridge/fancy)

/datum/supply_pack/goody/coffeepot
	name = "咖啡壶"
	desc = "标准尺寸的咖啡壶，适用于咖啡机."
	cost = PAYCHECK_CREW
	contains = list(/obj/item/reagent_containers/cup/coffeepot)

/datum/supply_pack/goody/climbing_hook
	name = "登山钩"
	desc = "一个相对便宜的进口登山钩，仅适用于行星类空间站的攀岩环境."
	cost = PAYCHECK_CREW * 5
	contains = list(/obj/item/climbing_hook)

/datum/supply_pack/goody/double_barrel
	name = "Double-barreled Shotgun Single-Pack"
	desc = "Lost your beloved bunny to a demonic invasion? Clown broke in and stole your beloved gun? No worries! Get a new gun as long as you can pay the absurd fees."
	cost = PAYCHECK_COMMAND * 18
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/ballistic/shotgun/doublebarrel)
