/datum/supply_pack/organic
	group = "食品&农业"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/hydroponics
	access_view = ACCESS_HYDROPONICS

/datum/supply_pack/organic/hydroponics/beekeeping_suits
	name = "养蜂人套装包"
	desc = "蜂蜜生意兴隆? 购买两套养蜂人套装来促进农业发展，\
		包含两套养蜂人套装和配套的头带装备."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/utility/beekeeper_head,
					/obj/item/clothing/suit/utility/beekeeper_suit,
					/obj/item/clothing/head/utility/beekeeper_head,
					/obj/item/clothing/suit/utility/beekeeper_suit,
				)
	crate_name = "养蜂人套装箱"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/hydroponics/beekeeping_fullkit
	name = "养蜂入门套件"
	desc = "BEES BEES BEES，内含三个巢框，养蜂人套装和蜂房，\
		当然！还有纯种的Nanotrasen蜂后!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/structure/beebox/unwrenched,
					/obj/item/honey_frame = 3,
					/obj/item/queen_bee/bought,
					/obj/item/clothing/head/utility/beekeeper_head,
					/obj/item/clothing/suit/utility/beekeeper_suit,
					/obj/item/melee/flyswatter,
				)
	crate_name = "养蜂入门套件箱"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/randomized/chef
	name = "上等肉类进口"
	desc = "全银河系最好的屠宰中心，这里有各种各样的异星肉."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/food/meat/slab/human/mutant/slime,
					/obj/item/food/meat/slab/killertomato,
					/obj/item/food/meat/slab/bear,
					/obj/item/food/meat/slab/xeno,
					/obj/item/food/meat/slab/spider,
					/obj/item/food/meat/rawbacon,
					/obj/item/food/meat/slab/penguin,
					/obj/item/food/spiderleg,
					/obj/item/food/fishmeat/carp,
					/obj/item/food/meat/slab/human,
					/obj/item/food/meat/slab/grassfed,
				)
	crate_name = "食材箱"

/datum/supply_pack/organic/randomized/chef/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 15)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/organic/exoticseeds
	name = "异星种子包"
	desc = "任何上进的植物学家的梦想，\
		包含十二种不同的种子，其中有复制豆荚和两包神秘种子!"
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_HYDROPONICS
	contains = list(
		/obj/item/seeds/amanita,
		/obj/item/seeds/bamboo,
		/obj/item/seeds/eggplant/eggy,
		/obj/item/seeds/liberty,
		/obj/item/seeds/nettle,
		/obj/item/seeds/plump,
		/obj/item/seeds/replicapod,
		/obj/item/seeds/reishi,
		/obj/item/seeds/rainbow_bunch,
		/obj/item/seeds/seedling,
		/obj/item/seeds/shrub,
		/obj/item/seeds/random = 2,
	)
	crate_name = "异星种子箱"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/food
	name = "食材包"
	desc = "用这个装满有用食材的板条箱做饭吧!\
		含有一打鸡蛋、三根香蕉和一些面粉、大米、牛奶和豆浆，\
		以及盐、胡椒、发酵酶、糖和猴子肉."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/reagent_containers/condiment/flour,
					/obj/item/reagent_containers/condiment/rice,
					/obj/item/reagent_containers/condiment/milk,
					/obj/item/reagent_containers/condiment/soymilk,
					/obj/item/reagent_containers/condiment/saltshaker,
					/obj/item/reagent_containers/condiment/peppermill,
					/obj/item/storage/fancy/egg_box,
					/obj/item/reagent_containers/condiment/enzyme,
					/obj/item/reagent_containers/condiment/sugar,
					/obj/item/food/meat/slab/monkey,
					/obj/item/food/grown/banana = 3,
				)
	crate_name = "食材箱"

/datum/supply_pack/organic/randomized/chef/fruits
	name = "水果进口"
	desc = "富含维生素，含有酸橙、甘橙、西瓜、苹果、浆果和\
		柠檬."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/food/grown/citrus/lime,
					/obj/item/food/grown/citrus/orange,
					/obj/item/food/grown/watermelon,
					/obj/item/food/grown/apple,
					/obj/item/food/grown/berries,
					/obj/item/food/grown/citrus/lemon,
				)
	crate_name = "食材箱"

/datum/supply_pack/organic/cream_piee
	name = "高产小丑级香蕉奶油派"
	desc = "这些高产量的小丑级香蕉奶油派由Aussec高级战争研究部门设计而出，\
		得到了性能和效率的上的双重保证，\
		保证提供最大的效果."
	cost = CARGO_CRATE_VALUE * 12
	contains = list(/obj/item/storage/backpack/duffelbag/clown/cream_pie)
	crate_name = "派对用品盒"
	contraband = TRUE
	access = ACCESS_THEATRE
	access_view = ACCESS_THEATRE
	crate_type = /obj/structure/closet/crate/secure
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/organic/hydroponics
	name = "水培用品包"
	desc = "包含一个伟大花园所需的用品! 包含两瓶氨水, \
		两瓶Plant-B-Gone喷雾, 一把斧头, 小耙子, 植物分析仪, \
		还有一双皮手套和植物学家的围裙."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/reagent_containers/spray/plantbgone = 2,
					/obj/item/reagent_containers/cup/bottle/ammonia = 2,
					/obj/item/hatchet,
					/obj/item/cultivator,
					/obj/item/plant_analyzer,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron,
				)
	crate_name = "水培用品箱"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/hydroponics/hydrotank
	name = "背式水箱"
	desc = "上次用这个导致全村抗洪，\
		内含500u的生命之水."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_HYDROPONICS
	contains = list(/obj/item/watertank)
	crate_name = "背式水箱补给箱"
	crate_type = /obj/structure/closet/crate/secure/hydroponics

/datum/supply_pack/organic/pizza
	name = "披萨快递"
	desc = "当你能在几分钟内就得到五个披萨时，为什么还要去厨房呢？\
			全银河最优惠价格! 所有交货99%无异常."
	cost = CARGO_CRATE_VALUE * 10 // Best prices this side of the galaxy.
	contains = list()
	crate_name = "披萨箱"

	///Whether we've provided an infinite pizza box already this shift or not.
	var/anomalous_box_provided = FALSE
	/// one percent chance for a pizza box to be the ininfite pizza box
	var/infinite_pizza_chance = 1
	///Whether we've provided a bomb pizza box already this shift or not.
	var/boombox_provided = FALSE
	/// three percent chance for a pizza box to be the pizza bomb box
	var/bomb_pizza_chance = 3
	/// 1 in 3 pizza bombs spawned will be a dud
	var/bomb_dud_chance = 33

	/// list of pizza that can randomly go inside of a crate, weighted by how disruptive it would be
	var/list/pizza_types = list(
		/obj/item/food/pizza/margherita = 10,
		/obj/item/food/pizza/meat = 10,
		/obj/item/food/pizza/mushroom = 10,
		/obj/item/food/pizza/vegetable = 10,
		/obj/item/food/pizza/donkpocket = 10,
		/obj/item/food/pizza/dank = 7,
		/obj/item/food/pizza/sassysage = 10,
		/obj/item/food/pizza/pineapple = 10,
		/obj/item/food/pizza/arnold = 3,
		/obj/item/food/pizza/energy = 5
	)

/datum/supply_pack/organic/pizza/fill(obj/structure/closet/crate/new_crate)
	. = ..()
	var/list/rng_pizza_list = pizza_types.Copy()
	for(var/i in 1 to 5)
		if(add_anomalous(new_crate))
			continue
		if(add_boombox(new_crate))
			continue
		add_normal_pizza(new_crate, rng_pizza_list)

/// adds the chance for an infinite pizza box
/datum/supply_pack/organic/pizza/proc/add_anomalous(obj/structure/closet/crate/new_crate)
	if(anomalous_box_provided)
		return FALSE
	if(!prob(infinite_pizza_chance))
		return FALSE
	new /obj/item/pizzabox/infinite(new_crate)
	anomalous_box_provided = TRUE
	log_game("An anomalous pizza box was provided in a pizza crate at during cargo delivery.")
	if(prob(50))
		addtimer(CALLBACK(src, PROC_REF(anomalous_pizza_report)), rand(30 SECONDS, 180 SECONDS))
		message_admins("An anomalous pizza box was provided in a pizza crate at during cargo delivery.")
	else
		message_admins("An anomalous pizza box was silently created with no command report in a pizza crate delivery.")
	return TRUE

/// adds a chance of a pizza bomb replacing a pizza
/datum/supply_pack/organic/pizza/proc/add_boombox(obj/structure/closet/crate/new_crate)
	if(boombox_provided)
		return FALSE
	if(!prob(bomb_pizza_chance))
		return FALSE
	var/boombox_type = (prob(bomb_dud_chance)) ? /obj/item/pizzabox/bomb : /obj/item/pizzabox/bomb/armed
	new boombox_type(new_crate)
	boombox_provided = TRUE
	log_game("A pizza box bomb was created by a pizza crate delivery.")
	message_admins("A pizza box bomb has arrived in a pizza crate delivery.")
	return TRUE

/// adds a randomized pizza from the pizza list
/datum/supply_pack/organic/pizza/proc/add_normal_pizza(obj/structure/closet/crate/new_crate, list/rng_pizza_list)
	var/randomize_pizza = pick_weight(rng_pizza_list)
	rng_pizza_list -= randomize_pizza
	var/obj/item/pizzabox/new_pizza_box = new(new_crate)
	new_pizza_box.pizza = new randomize_pizza
	new_pizza_box.boxtag = new_pizza_box.pizza.boxtag
	new_pizza_box.boxtag_set = TRUE
	new_pizza_box.update_appearance(UPDATE_ICON | UPDATE_DESC)

/// tells crew that an infinite pizza box exists, half of the time, based on a roll in the anamolous box proc
/datum/supply_pack/organic/pizza/proc/anomalous_pizza_report()
	print_command_report("[station_name()], 我们的异常材料部门报告了一起物品失踪事件，据调查很可能是在一次例行送货中误送至你站. \
	请检查所有的板条箱与货运清单，如若找到异常对象还请送回. \
	该异常对象被列为<b>\[数据删除\]</b>项目，并且具有<b>\[数据删除\]</b>特性. 请务必注意，异常对象与打开该异常的个体将精确谐调，\
	该个体会认为异常对象是可食用的，并且很美味.")

/datum/supply_pack/organic/potted_plants
	name = "盆栽包"
	desc = "用这些可爱的盆栽装饰你的太空站!\
		包含来自Nanotrasen盆栽植物研究部的五种随机盆栽植物. \
		请勿用来投掷."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/kirbyplants/random = 5)
	crate_name = "盆栽植物箱"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/organic/seeds
	name = "种子包"
	desc = "大事业总是从小开头，包含十五种不同的种子."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/seeds/chili,
					/obj/item/seeds/cotton,
					/obj/item/seeds/berry,
					/obj/item/seeds/corn,
					/obj/item/seeds/eggplant,
					/obj/item/seeds/tomato,
					/obj/item/seeds/soya,
					/obj/item/seeds/wheat,
					/obj/item/seeds/wheat/rice,
					/obj/item/seeds/carrot,
					/obj/item/seeds/sunflower,
					/obj/item/seeds/rose,
					/obj/item/seeds/chanter,
					/obj/item/seeds/potato,
					/obj/item/seeds/sugarcane,
					/obj/item/seeds/cucumber,
				)
	crate_name = "种子箱"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/randomized/chef/vegetables
	name = "蔬菜包"
	desc = "长在大棚里，包含辣椒、玉米、番茄、土豆、胡萝卜、 \
		鸡油菌、洋葱、南瓜和黄瓜."
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(/obj/item/food/grown/chili,
					/obj/item/food/grown/corn,
					/obj/item/food/grown/tomato,
					/obj/item/food/grown/potato,
					/obj/item/food/grown/carrot,
					/obj/item/food/grown/mushroom/chanterelle,
					/obj/item/food/grown/onion,
					/obj/item/food/grown/pumpkin,
					/obj/item/food/grown/cucumber,
				)
	crate_name = "食材箱"

/datum/supply_pack/organic/grill
	name = "烧烤入门工具套件"
	desc = "Hey dad I'm Hungry. Hi Hungry I'm 新来的烧烤入门套件，\
		限量5000份，内含一个烧烤架和燃料."
	cost = CARGO_CRATE_VALUE * 8
	crate_type = /obj/structure/closet/crate
	contains = list(
		/obj/item/stack/sheet/mineral/coal/five,
		/obj/item/kitchen/tongs,
		/obj/item/reagent_containers/cup/soda_cans/monkey_energy,
		/obj/machinery/grill/unwrenched,
	)
	crate_name = "烧烤入门工具套件"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/organic/grillfuel
	name = "烧烤燃料包"
	desc = "内含丙烷和丙烷附件. \
		(注:不含任何丙烷.)"
	cost = CARGO_CRATE_VALUE * 4
	crate_type = /obj/structure/closet/crate
	contains = list(/obj/item/stack/sheet/mineral/coal/ten,
					/obj/item/reagent_containers/cup/soda_cans/monkey_energy,
				)
	crate_name = "烧烤燃料箱"
	discountable = SUPPLY_PACK_UNCOMMON_DISCOUNTABLE

/datum/supply_pack/organic/tiziran_supply
	name = "缇兹兰食材进口"
	desc = "进口自蜥蜴帝国中心的一箱物资. \
		包含缇兹兰特色食材."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/tiziran_goods,
					/obj/item/storage/box/tiziran_cans,
					/obj/item/storage/box/tiziran_meats,
				)
	crate_name = "缇兹兰食材箱"
	crate_type = /obj/structure/closet/crate/cardboard/tiziran

/datum/supply_pack/organic/mothic_supply
	name = "蛾类食材进口"
	desc = "进口自蛾子舰队的一箱物资. \
		包含蛾类特色食材."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/mothic_goods,
					/obj/item/storage/box/mothic_cans_sauces,
					/obj/item/storage/box/mothic_rations,
				)
	crate_name = "蛾类食材箱"
	crate_type = /obj/structure/closet/crate/cardboard/mothic

/datum/supply_pack/organic/syrup
	name = "咖啡糖浆包"
	desc = "一盒包装好的各种糖浆，让你的美味咖啡更加甜蜜."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/caramel,
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/liqueur,
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/korta_nectar,
	)
	crate_name = "咖啡糖浆箱"
	crate_type = /obj/structure/closet/crate/cardboard

/datum/supply_pack/organic/syrup_contraband
	contraband = TRUE
	name = "违禁糖浆进口"
	desc = "装有非法咖啡糖浆的包装盒，在太空法中，持有这些武器将被判重刑."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/laughsyrup,
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/laughsyrup,
	)
	crate_name = "非法糖浆箱"
	crate_type = /obj/structure/closet/crate/cardboard
