/datum/bounty/item/assistant/strange_object
	name = "奇怪的物体"
	description = "纳米传讯公司对奇怪的物体产生了兴趣.在维护管道里找一个，并立即将其运送到中央指挥部."
	reward = CARGO_CRATE_VALUE * 2.4
	wanted_types = list(/obj/item/relic = TRUE)

/datum/bounty/item/assistant/scooter
	name = "滑板车"
	description = "纳米传讯公司认为步行是浪费资源.将一个滑板车运送到中央指挥部以提高运营效率."
	reward = CARGO_CRATE_VALUE * 2.16 // the mat hoffman
	wanted_types = list(/obj/vehicle/ridden/scooter = TRUE)
	include_subtypes = FALSE

/datum/bounty/item/assistant/skateboard
	name = "滑板"
	description = "纳米传讯公司认为步行是浪费资源.将一个滑板运送到中央指挥部以提高运营效率."
	reward = CARGO_CRATE_VALUE * 1.8 // the tony hawk
	wanted_types = list(
		/obj/vehicle/ridden/scooter/skateboard = TRUE,
		/obj/item/melee/skateboard = TRUE,
	)

/datum/bounty/item/assistant/stunprod
	name = "电棍"
	description = "中央指挥部需要一把电棍来对付那些持有不同政见的人.制作一把，然后运送到中央指挥部."
	reward = CARGO_CRATE_VALUE * 2.6
	wanted_types = list(/obj/item/melee/baton/security/cattleprod = TRUE)

/datum/bounty/item/assistant/soap
	name = "肥皂"
	description = "中央指挥部浴室的肥皂失踪了，没人知道谁拿走了它.送新的来替換掉它，成为中央指挥部心目的英雄."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(/obj/item/soap = TRUE)

/datum/bounty/item/assistant/spear
	name = "矛"
	description = "中央指挥部的安保部队正在削減预算.如果运送一套长矛过来，你会获得报酬."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 5
	wanted_types = list(/obj/item/spear = TRUE)

/datum/bounty/item/assistant/toolbox
	name = "工具箱"
	description = "中央指挥部缺少强健性.赶紧运送一些工具箱过来作为解决方案."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 6
	wanted_types = list(/obj/item/storage/toolbox = TRUE)

/datum/bounty/item/assistant/statue
	name = "雕像"
	description = "中央指挥部想为大厅订购一个艺术雕像。请尽可能运送一个过来."
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/structure/statue = TRUE)

/datum/bounty/item/assistant/clown_box
	name = "小丑盒"
	description = "宇宙需要欢笑.用小丑印章盖在纸板上并运送它."
	reward = CARGO_CRATE_VALUE * 3
	wanted_types = list(/obj/item/storage/box/clown = TRUE)

/datum/bounty/item/assistant/cheesiehonkers
	name = "奶酪喇叭"
	description = "奶酪喇叭制造公司快要倒闭了！中央指挥部想在它倒闭之前囤积一些货!"
	reward = CARGO_CRATE_VALUE * 2.4
	required_count = 3
	wanted_types = list(/obj/item/food/cheesiehonkers = TRUE)

/datum/bounty/item/assistant/baseball_bat
	name = "棒球棒"
	description = "棒球热潮席卷中央通信中心！帮个忙，给他们运送一些棒球棒，这样管理层就可以实现他们的童年梦想."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 5
	wanted_types = list(/obj/item/melee/baseball_bat = TRUE)

/datum/bounty/item/assistant/extendohand
	name = "伸缩手"
	description = "贝蒂指挥官年纪大了，弯腰够不着遥控器了。管理层要求送一个伸缩手来帮助她."
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/item/extendohand = TRUE)

/datum/bounty/item/assistant/donut
	name = "甜甜圈"
	description = "中央指挥部的安保部队在与辛迪加的战斗中遭受了重大损失。运送一批甜甜圈来提高士气."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 6
	wanted_types = list(/obj/item/food/donut = TRUE)

/datum/bounty/item/assistant/donkpocket
	name = "口袋饼"
	description = "消费者安全召回：警告。过去一年生产的口袋饼中含有危险的蜥蜴生物质。立即将货物退回中央指挥部."
	reward = CARGO_CRATE_VALUE * 6
	required_count = 10
	wanted_types = list(/obj/item/food/donkpocket = TRUE)

/datum/bounty/item/assistant/monkey_hide
	name = "猴皮"
	description = "中央指挥部的一位科学家对在猴子皮上测试产品很感兴趣。你的任务是获取猴皮并把它运送过来."
	reward = CARGO_CRATE_VALUE * 3
	wanted_types = list(/obj/item/stack/sheet/animalhide/monkey = TRUE)

/datum/bounty/item/assistant/dead_mice
	name = "死老鼠"
	description = "14号空间站的冷冻干燥老鼠用完了。运送一些新鲜的老鼠过来，这样他们的清洁工就不会罢工了."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 5
	wanted_types = list(/obj/item/food/deadmouse = TRUE)

/datum/bounty/item/assistant/comfy_chair
	name = "康乐椅"
	description = "帕特指挥官对他的椅子不满意。他声称椅子对他的背部造成了工伤。运送一些替代品来取悦他."
	reward = CARGO_CRATE_VALUE * 3
	required_count = 5
	wanted_types = list(/obj/structure/chair/comfy = TRUE)

/datum/bounty/item/assistant/geranium
	name = "天竺葵"
	description = "Zot 指挥官迷恋 Zena 指挥官。送一批天竺葵过来 - 她最喜欢的花 - Zot 指挥官会很高兴地奖励你."
	reward = CARGO_CRATE_VALUE * 8
	required_count = 3
	wanted_types = list(/obj/item/food/grown/poppy/geranium = TRUE)
	include_subtypes = FALSE

/datum/bounty/item/assistant/poppy
	name = "罂粟"
	description = "Zot 指挥官真的很想让安全官员 Olivia 对他一见钟情。送一批罂粟过来 - 那位官员最喜欢的花 - 他会很高兴地奖励你."
	reward = CARGO_CRATE_VALUE * 2
	required_count = 3
	wanted_types = list(/obj/item/food/grown/poppy = TRUE)
	include_subtypes = FALSE

/datum/bounty/item/assistant/potted_plants
	name = "盆栽植物"
	description = "中央指挥部正在准备建造一个新的BirdBoat级空间站。你被命令提供盆栽植物."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 8
	wanted_types = list(/obj/item/kirbyplants = TRUE)

/datum/bounty/item/assistant/monkey_cubes
	name = "猴子方块"
	description = "由于最近的一次基因事故，中央指挥部急需猴子。你的任务是运送猴子方块."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(/obj/item/food/monkeycube = TRUE)

/datum/bounty/item/assistant/ied
	name = "IED(简易爆炸装置)"
	description = "纳米传讯公司的中央指挥部最高安全监狱正在进行人员培训。运送一批简易爆炸装置作为训练工具."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(/obj/item/grenade/iedcasing = TRUE)

/datum/bounty/item/assistant/corgimeat
	name = "生柯基狗肉"
	description = "辛迪加最近偷走了中央指挥部所有柯基狗肉。立即运送替换品."
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/item/food/meat/slab/corgi = TRUE)

/datum/bounty/item/assistant/action_figures
	name = "活动人偶"
	description = "副总统的儿子在电视上看到了活动人偶的广告，现在他一直吵着要。运送一些来缓解他的抱怨."
	reward = CARGO_CRATE_VALUE * 8
	required_count = 5
	wanted_types = list(/obj/item/toy/figure = TRUE)

/datum/bounty/item/assistant/paper_bin
	name = "纸盒"
	description = "我们的会计部门缺纸了。我们需要立即运送一批新的纸盒."
	reward = CARGO_CRATE_VALUE * 5
	required_count = 5
	wanted_types = list(/obj/item/paper_bin = TRUE)

/datum/bounty/item/assistant/crayons
	name = "蜡笔"
	description = "琼斯博士的孩子又把我们的蜡笔全给吃了。请把你的那批寄给我们."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 24
	wanted_types = list(/obj/item/toy/crayon = TRUE)

/datum/bounty/item/assistant/pens
	name = "笔"
	description = "我们将举办星际圆珠笔平衡比赛。我们需要你寄给我们一些标准的黑色圆珠笔."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 10
	include_subtypes = FALSE
	wanted_types = list(/obj/item/pen = TRUE)

/datum/bounty/item/assistant/water_tank
	name = "水箱"
	description = "我们需要更多的水来灌溉我们的水培部门。找到一个水箱并运送给我们."
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/structure/reagent_dispensers/watertank = TRUE)

/datum/bounty/item/assistant/pneumatic_cannon
	name = "气动炮"
	description = "我们正在研究如何用气动炮发射超物质碎片。尽快给我们送一个."
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/item/pneumatic_cannon/ghetto = TRUE)

/datum/bounty/item/assistant/improvised_shells
	name = "简易霰弹"
	description = "预算削減对我们的安保部门打击很大。你能运送一些简易霰弹过来吗."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 5
	wanted_types = list(/obj/item/ammo_casing/shotgun/improvised = TRUE)

/datum/bounty/item/assistant/flamethrower
	name = "喷火器"
	description = "我们有飞蛾入侵，请送来喷火器帮忙处理."
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/item/flamethrower = TRUE)

/datum/bounty/item/assistant/fish
	name = "鱼"
	description = "我们需要鱼来填充我们的水族馆。运送死鱼或从货舱购买的鱼过来只能得到一半的报酬."
	reward = CARGO_CRATE_VALUE * 9
	required_count = 4
	wanted_types = list(/obj/item/fish = TRUE)
	///the penalty for shipping dead/bought fish, which can subtract up to half the reward in total.
	var/shipping_penalty

/datum/bounty/item/assistant/fish/New()
	..()
	shipping_penalty = reward * 0.5 / required_count

/datum/bounty/item/assistant/fish/ship(obj/shipped)
	. = ..()
	if(!.)
		return
	var/obj/item/fish/fishie = shipped
	if(fishie.status == FISH_DEAD || HAS_TRAIT(fishie, TRAIT_FISH_FROM_CASE))
		reward -= shipping_penalty

///A subtype of the fish bounty that requires fish with a specific fluid type
/datum/bounty/item/assistant/fish/fluid
	reward = CARGO_CRATE_VALUE * 11
	///The required fluid type of the fish for it to be shipped
	var/fluid_type

/datum/bounty/item/assistant/fish/fluid/New()
	..()
	fluid_type = pick(AQUARIUM_FLUID_FRESHWATER, AQUARIUM_FLUID_SALTWATER, AQUARIUM_FLUID_SULPHWATEVER)
	name = "[fluid_type] 鱼"
	description = "我们需要[lowertext(fluid_type)]鱼来填充我们的水族馆。运送死鱼或从货舱购买的鱼过来只能得到一半的报酬."

/datum/bounty/item/assistant/fish/fluid/applies_to(obj/shipped)
	. = ..()
	if(!.)
		return
	var/obj/item/fish/fishie = shipped
	return compatible_fluid_type(fishie.required_fluid_type, fluid_type)

///A subtype of the fish bounty that requires specific fish types. The higher their rarity, the better the pay.
/datum/bounty/item/assistant/fish/specific
	description = "我们引以为傲的鱼类收藏目前急需补充特定珍稀品种。请注意，死鱼或货舱购买的鱼只能获得一半报酬."
	reward = CARGO_CRATE_VALUE * 16
	required_count = 3
	wanted_types = list()

/datum/bounty/item/assistant/fish/specific/New()
	var/static/list/choosable_fishes
	if(isnull(choosable_fishes))
		choosable_fishes = list()
		for(var/obj/item/fish/prototype as anything in subtypesof(/obj/item/fish))
			if(initial(prototype.experisci_scannable) && initial(prototype.show_in_catalog))
				choosable_fishes += prototype

	var/list/fishes_copylist = choosable_fishes.Copy()
	///Used to calculate the extra reward
	var/total_rarity = 0
	var/list/name_list = list()
	var/num_paths = rand(2,3)
	for(var/i in 1 to num_paths)
		var/obj/item/fish/chosen_path = pick_n_take(fishes_copylist)
		wanted_types[chosen_path] = TRUE
		name_list += initial(chosen_path.name)
		total_rarity += initial(chosen_path.random_case_rarity) / num_paths
	name = english_list(name_list)

	switch(total_rarity)
		if(FISH_RARITY_NOPE to FISH_RARITY_GOOD_LUCK_FINDING_THIS)
			reward += CARGO_CRATE_VALUE * 14
		if(FISH_RARITY_GOOD_LUCK_FINDING_THIS to FISH_RARITY_VERY_RARE)
			reward += CARGO_CRATE_VALUE * 6.5
		if(FISH_RARITY_VERY_RARE to FISH_RARITY_RARE)
			reward += CARGO_CRATE_VALUE * 3
		if(FISH_RARITY_RARE to FISH_RARITY_BASIC-1)
			reward += CARGO_CRATE_VALUE * 1

	..()
