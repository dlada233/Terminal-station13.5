// This contains all boxes with edible stuffs or stuff related to edible stuffs.

/obj/item/storage/box/donkpockets
	name = "口袋饼盒"
	desc = "最佳食用方法为微波炉加热后食用，Donk-杜客公司的尖端技术将使得产品永远保持热气腾腾."
	icon_state = "donkpocketbox"
	illustration = null
	/// What type of donk pocket are we gonna cram into this box?
	var/donktype = /obj/item/food/donkpocket

/obj/item/storage/box/donkpockets/PopulateContents()
	for(var/i in 1 to 6)
		new donktype(src)

/obj/item/storage/box/donkpockets/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(/obj/item/food/donkpocket)

/obj/item/storage/box/donkpockets/donkpocketspicy
	name = "辣味口袋饼盒"
	icon_state = "donkpocketboxspicy"
	donktype = /obj/item/food/donkpocket/spicy

/obj/item/storage/box/donkpockets/donkpocketteriyaki
	name = "照烧味口袋饼盒"
	icon_state = "donkpocketboxteriyaki"
	donktype = /obj/item/food/donkpocket/teriyaki

/obj/item/storage/box/donkpockets/donkpocketpizza
	name = "披萨味口袋饼盒"
	icon_state = "donkpocketboxpizza"
	donktype = /obj/item/food/donkpocket/pizza

/obj/item/storage/box/donkpockets/donkpocketgondola
	name = "贡多拉味口袋饼盒"
	icon_state = "donkpocketboxgondola"
	donktype = /obj/item/food/donkpocket/gondola

/obj/item/storage/box/donkpockets/donkpocketberry
	name = "浆果味口袋饼盒"
	icon_state = "donkpocketboxberry"
	donktype = /obj/item/food/donkpocket/berry

/obj/item/storage/box/donkpockets/donkpockethonk
	name = "香蕉味口袋饼盒"
	icon_state = "donkpocketboxbanana"
	donktype = /obj/item/food/donkpocket/honk

/obj/item/storage/box/papersack
	name = "纸袋"
	desc = "用纸精心制作的袋子."
	icon = 'icons/obj/storage/paperbag.dmi'
	icon_state = "paperbag_None"
	inhand_icon_state = null
	illustration = null
	resistance_flags = FLAMMABLE
	foldable_result = null
	/// A list of all available papersack reskins
	var/list/papersack_designs = list()
	///What design from papersack_designs we are currently using.
	var/design_choice = "None"

/obj/item/storage/box/papersack/Initialize(mapload)
	. = ..()
	papersack_designs = sort_list(list(
		"None" = image(icon = src.icon, icon_state = "paperbag_None"),
		"NanotrasenStandard" = image(icon = src.icon, icon_state = "paperbag_NanotrasenStandard"),
		"SyndiSnacks" = image(icon = src.icon, icon_state = "paperbag_SyndiSnacks"),
		"Heart" = image(icon = src.icon, icon_state = "paperbag_Heart"),
		"SmileyFace" = image(icon = src.icon, icon_state = "paperbag_SmileyFace")
		))
	update_appearance()

/obj/item/storage/box/papersack/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, design_choice))
		update_appearance()

/obj/item/storage/box/papersack/update_icon_state()
	icon_state = "paperbag_[design_choice][(contents.len == 0) ? null : "_closed"]"
	return ..()

/obj/item/storage/box/papersack/update_desc(updates)
	switch(design_choice)
		if("None")
			desc = "用纸精心制作的袋子."
		if("NanotrasenStandard")
			desc = "一个标准的Nanotrasen纸质午餐袋，供忠诚的员工在旅途中使用."
		if("SyndiSnacks")
			desc = "这个纸袋上的设计是臭名昭著的“辛迪加小吃”计划残余."
		if("Heart")
			desc = "一个侧面刻着心形图案的纸袋."
		if("SmileyFace")
			desc = "一个纸袋，上面画着一个简朴的微笑."
	return ..()

/obj/item/storage/box/papersack/storage_insert_on_interacted_with(datum/storage, obj/item/inserted, mob/living/user)
	if(IS_WRITING_UTENSIL(inserted))
		var/choice = show_radial_menu(user, src , papersack_designs, custom_check = CALLBACK(src, PROC_REF(check_menu), user, inserted), radius = 36, require_near = TRUE)
		if(!choice || choice == design_choice)
			return FALSE
		design_choice = choice
		balloon_alert(user, "modified")
		update_appearance()
		return FALSE
	if(inserted.get_sharpness() && !contents.len)
		if(design_choice == "None")
			user.show_message(span_notice("你把[src]上的眼孔切开."), MSG_VISUAL)
			new /obj/item/clothing/head/costume/papersack(drop_location())
			qdel(src)
			return FALSE
		else if(design_choice == "SmileyFace")
			user.show_message(span_notice("你在[src]上切了几个眼孔，然后修改了设计."), MSG_VISUAL)
			new /obj/item/clothing/head/costume/papersack/smiley(drop_location())
			qdel(src)
			return FALSE
	return TRUE

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 * * P The pen used to interact with a menu
 */
/obj/item/storage/box/papersack/proc/check_menu(mob/user, obj/item/pen/P)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(contents.len)
		balloon_alert(user, "内有物品!")
		return FALSE
	if(!P || !user.is_holding(P))
		balloon_alert(user, "需要笔!")
		return FALSE
	return TRUE

/obj/item/storage/box/papersack/meat
	desc = "有点潮湿，闻起来像屠宰场."

/obj/item/storage/box/papersack/meat/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/food/meat/slab(src)

/obj/item/storage/box/papersack/wheat
	desc = "有一点灰尘，闻起来像谷仓里的院子."

/obj/item/storage/box/papersack/wheat/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/food/grown/wheat(src)

/obj/item/storage/box/ingredients //This box is for the randomly chosen version the chef used to spawn with, it shouldn't actually exist.
	name = "食材盒:"
	illustration = "fruit"
	var/theme_name

/obj/item/storage/box/ingredients/Initialize(mapload)
	. = ..()
	if(theme_name)
		name = "[name] ([theme_name])"
		desc = "为有抱负的厨师准备的一盒补充食材。盒子的主题是'[theme_name]'."
		inhand_icon_state = "syringe_kit"

/obj/item/storage/box/ingredients/wildcard
	theme_name = "家常"

/obj/item/storage/box/ingredients/wildcard/PopulateContents()
	for(var/i in 1 to 7)
		var/random_food = pick(
			/obj/item/food/chocolatebar,
			/obj/item/food/grown/apple,
			/obj/item/food/grown/banana,
			/obj/item/food/grown/cabbage,
			/obj/item/food/grown/carrot,
			/obj/item/food/grown/cherries,
			/obj/item/food/grown/chili,
			/obj/item/food/grown/corn,
			/obj/item/food/grown/cucumber,
			/obj/item/food/grown/mushroom/chanterelle,
			/obj/item/food/grown/mushroom/plumphelmet,
			/obj/item/food/grown/potato,
			/obj/item/food/grown/potato/sweet,
			/obj/item/food/grown/soybeans,
			/obj/item/food/grown/tomato,
		)
		new random_food(src)

/obj/item/storage/box/ingredients/fiesta
	theme_name = "祭典"

/obj/item/storage/box/ingredients/fiesta/PopulateContents()
	new /obj/item/food/tortilla(src)
	for(var/i in 1 to 2)
		new /obj/item/food/grown/chili(src)
		new /obj/item/food/grown/corn(src)
		new /obj/item/food/grown/soybeans(src)

/obj/item/storage/box/ingredients/italian
	theme_name = "意式"

/obj/item/storage/box/ingredients/italian/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/food/grown/tomato(src)
		new /obj/item/food/meatball(src)
	new /obj/item/reagent_containers/cup/glass/bottle/wine(src)

/obj/item/storage/box/ingredients/vegetarian
	theme_name = "素菜"

/obj/item/storage/box/ingredients/vegetarian/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/grown/carrot(src)
	new /obj/item/food/grown/apple(src)
	new /obj/item/food/grown/corn(src)
	new /obj/item/food/grown/eggplant(src)
	new /obj/item/food/grown/potato(src)
	new /obj/item/food/grown/tomato(src)

/obj/item/storage/box/ingredients/american
	theme_name = "美式"

/obj/item/storage/box/ingredients/american/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/grown/corn(src)
		new /obj/item/food/grown/potato(src)
		new /obj/item/food/grown/tomato(src)
	new /obj/item/food/meatball(src)

/obj/item/storage/box/ingredients/fruity
	theme_name = "水果"

/obj/item/storage/box/ingredients/fruity/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/grown/apple(src)
		new /obj/item/food/grown/citrus/orange(src)
	new /obj/item/food/grown/citrus/lemon(src)
	new /obj/item/food/grown/citrus/lime(src)
	new /obj/item/food/grown/watermelon(src)

/obj/item/storage/box/ingredients/sweets
	theme_name = "甜食"

/obj/item/storage/box/ingredients/sweets/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/grown/cherries(src)
		new /obj/item/food/grown/banana(src)
	new /obj/item/food/chocolatebar(src)
	new /obj/item/food/grown/apple(src)
	new /obj/item/food/grown/cocoapod(src)

/obj/item/storage/box/ingredients/delights
	theme_name = "喜悦"

/obj/item/storage/box/ingredients/delights/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/grown/bluecherries(src)
		new /obj/item/food/grown/potato/sweet(src)
	new /obj/item/food/grown/berries(src)
	new /obj/item/food/grown/cocoapod(src)
	new /obj/item/food/grown/vanillapod(src)

/obj/item/storage/box/ingredients/grains
	theme_name = "谷物"

/obj/item/storage/box/ingredients/grains/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/food/grown/oat(src)
	new /obj/item/food/grown/cocoapod(src)
	new /obj/item/food/grown/wheat(src)
	new /obj/item/food/honeycomb(src)
	new /obj/item/seeds/poppy(src)

/obj/item/storage/box/ingredients/carnivore
	theme_name = "肉类"

/obj/item/storage/box/ingredients/carnivore/PopulateContents()
	new /obj/item/food/meat/slab/bear(src)
	new /obj/item/food/meat/slab/corgi(src)
	new /obj/item/food/meat/slab/penguin(src)
	new /obj/item/food/meat/slab/spider(src)
	new /obj/item/food/meat/slab/xeno(src)
	new /obj/item/food/meatball(src)
	new /obj/item/food/spidereggs(src)

/obj/item/storage/box/ingredients/exotic
	theme_name = "异域风情"

/obj/item/storage/box/ingredients/exotic/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/fishmeat/carp(src)
		new /obj/item/food/grown/cabbage(src)
		new /obj/item/food/grown/soybeans(src)
	new /obj/item/food/grown/chili(src)

/obj/item/storage/box/ingredients/seafood
	theme_name = "海产"

/obj/item/storage/box/ingredients/seafood/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/fishmeat/armorfish(src)
		new /obj/item/food/fishmeat/carp(src)
		new /obj/item/food/fishmeat/moonfish(src)
	new /obj/item/food/fishmeat/gunner_jellyfish(src)

/obj/item/storage/box/ingredients/salads
	theme_name = "沙拉"

/obj/item/storage/box/ingredients/salads/PopulateContents()
	new /obj/item/food/grown/cabbage(src)
	new /obj/item/food/grown/carrot(src)
	new /obj/item/food/grown/olive(src)
	new /obj/item/food/grown/onion/red(src)
	new /obj/item/food/grown/onion/red(src)
	new /obj/item/food/grown/tomato(src)
	new /obj/item/reagent_containers/condiment/olive_oil(src)

/obj/item/storage/box/ingredients/random
	theme_name = "随机"
	desc = "This box should not exist, contact the proper authorities."

/obj/item/storage/box/ingredients/random/Initialize(mapload)
	. = ..()
	var/chosen_box = pick(subtypesof(/obj/item/storage/box/ingredients) - /obj/item/storage/box/ingredients/random)
	new chosen_box(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/storage/box/gum
	name = "泡泡糖包"
	desc = "显然，包装完全是日文的，所以你一个字也看不懂."
	icon = 'icons/obj/storage/gum.dmi'
	icon_state = "bubblegum_generic"
	w_class = WEIGHT_CLASS_TINY
	illustration = null
	foldable_result = null
	custom_price = PAYCHECK_CREW

/obj/item/storage/box/gum/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/bubblegum))
	atom_storage.max_slots = 4

/obj/item/storage/box/gum/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/bubblegum(src)

/obj/item/storage/box/gum/nicotine
	name = "尼古丁口香糖包"
	desc = "旨在帮助尼古丁成瘾的人们保持口腔清新，同时还不伤害肺，薄荷味!"
	icon_state = "bubblegum_nicotine"
	custom_premium_price = PAYCHECK_CREW * 1.5

/obj/item/storage/box/gum/nicotine/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/bubblegum/nicotine(src)

/obj/item/storage/box/gum/happiness
	name = "HP+ 口香糖包"
	desc = "看似自制的包装纸，却有一种奇怪的气味，它有一个奇怪的画，一个微笑的脸伸出舌头."
	icon_state = "bubblegum_happiness"
	custom_price = PAYCHECK_COMMAND * 3
	custom_premium_price = PAYCHECK_COMMAND * 3

/obj/item/storage/box/gum/happiness/Initialize(mapload)
	. = ..()
	if (prob(25))
		desc += " 你可以依稀看出上面曾经潦草地写着“Hemopagopril”这个词."

/obj/item/storage/box/gum/happiness/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/bubblegum/happiness(src)

/obj/item/storage/box/gum/bubblegum
	name = "血色泡泡糖包"
	desc = "包装上显然全是恶魔语，你觉得打开它都是一种罪过."
	icon_state = "bubblegum_bubblegum"

/obj/item/storage/box/gum/bubblegum/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/bubblegum/bubblegum(src)

/obj/item/storage/box/mothic_rations
	name = "蛾类口粮包"
	desc = "一个装有口粮和口香糖的盒子，供饥饿的飞蛾生存."
	icon_state = "moth_package"
	illustration = null

/obj/item/storage/box/mothic_rations/PopulateContents()
	for(var/i in 1 to 3)
		var/random_food = pick_weight(list(
			/obj/item/food/sustenance_bar = 10,
			/obj/item/food/sustenance_bar/cheese = 5,
			/obj/item/food/sustenance_bar/mint = 5,
			/obj/item/food/sustenance_bar/neapolitan = 5,
			/obj/item/food/sustenance_bar/wonka = 1,
			))
		new random_food(src)
	new /obj/item/storage/box/gum/wake_up(src)

/obj/item/storage/box/tiziran_goods
	name = "缇兹兰农产品盒"
	desc = "一个盒子里装着各种各样的新鲜缇兹兰农产品——非常适合制作蜥蜴人的食物."
	icon_state = "lizard_package"
	illustration = null

/obj/item/storage/box/tiziran_goods/PopulateContents()
	for(var/i in 1 to 12)
		var/random_food = pick_weight(list(
			/obj/item/food/bread/root = 2,
			/obj/item/food/grown/ash_flora/seraka = 2,
			/obj/item/food/grown/korta_nut = 10,
			/obj/item/food/grown/korta_nut/sweet = 2,
			/obj/item/food/liver_pate = 5,
			/obj/item/food/lizard_dumplings = 5,
			/obj/item/food/moonfish_caviar = 5,
			/obj/item/food/root_flatbread = 5,
			/obj/item/food/rootroll = 5,
			/obj/item/food/spaghetti/nizaya = 5,
			))
		new random_food(src)

/obj/item/storage/box/tiziran_cans
	name = "缇兹兰罐头盒"
	desc = "一个盒子，里面装着各种各样的罐头食品，可以直接吃，也可以用来烹饪."
	icon_state = "lizard_package"
	illustration = null

/obj/item/storage/box/tiziran_cans/PopulateContents()
	for(var/i in 1 to 8)
		var/random_food = pick_weight(list(
			/obj/item/food/canned/jellyfish = 5,
			/obj/item/food/canned/desert_snails = 5,
			/obj/item/food/canned/larvae = 5,
			))
		new random_food(src)

/obj/item/storage/box/tiziran_meats
	name = "缇兹兰生鲜盒"
	desc = "一个盒子里装着各种新鲜冷冻的提兹兰本土肉和鱼——蜥蜴料理的关键."
	icon_state = "lizard_package"
	illustration = null

/obj/item/storage/box/tiziran_meats/PopulateContents()
	for(var/i in 1 to 10)
		var/random_food = pick_weight(list(
			/obj/item/food/fishmeat/armorfish = 5,
			/obj/item/food/fishmeat/gunner_jellyfish = 5,
			/obj/item/food/fishmeat/moonfish = 5,
			/obj/item/food/meat/slab = 5,
			))
		new random_food(src)

/obj/item/storage/box/mothic_goods
	name = "蛾类农产品盒"
	desc = "一个装有各种各样的蛾类烹饪用品的盒子."
	icon_state = "moth_package"
	illustration = null

/obj/item/storage/box/mothic_goods/PopulateContents()
	for(var/i in 1 to 12)
		var/random_food = pick_weight(list(
			/obj/item/food/cheese/cheese_curds = 5,
			/obj/item/food/cheese/curd_cheese = 5,
			/obj/item/food/cheese/firm_cheese = 5,
			/obj/item/food/cheese/mozzarella = 5,
			/obj/item/food/cheese/wheel = 5,
			/obj/item/food/grown/toechtauese = 10,
			/obj/item/reagent_containers/condiment/cornmeal = 5,
			/obj/item/reagent_containers/condiment/olive_oil = 5,
			/obj/item/reagent_containers/condiment/yoghurt = 5,
			))
		new random_food(src)

/obj/item/storage/box/mothic_cans_sauces
	name = "蛾类食品盒"
	desc = "一个装有各种罐头食品和预制酱料的盒子."
	icon_state = "moth_package"
	illustration = null

/obj/item/storage/box/mothic_cans_sauces/PopulateContents()
	for(var/i in 1 to 8)
		var/random_food = pick_weight(list(
			/obj/item/food/bechamel_sauce = 5,
			/obj/item/food/canned/pine_nuts = 5,
			/obj/item/food/canned/tomatoes = 5,
			/obj/item/food/pesto = 5,
			/obj/item/food/tomato_sauce = 5,
			))
		new random_food(src)

/obj/item/storage/box/condimentbottles
	name = "调味品盒"
	desc = "上面有番茄酱的图案."
	illustration = "condiment"

/obj/item/storage/box/condimentbottles/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/condiment(src)


/obj/item/storage/box/coffeepack
	icon_state = "arabica_beans"
	name = "阿拉比卡咖啡豆"
	desc = "袋装新鲜、干燥的阿拉比卡咖啡豆，来自Waffle公司的采购和包装."
	illustration = null
	icon = 'icons/obj/food/containers.dmi'
	var/beantype = /obj/item/food/grown/coffee

/obj/item/storage/box/coffeepack/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(/obj/item/food/grown/coffee)

/obj/item/storage/box/coffeepack/PopulateContents()
	atom_storage.max_slots = 5
	for(var/i in 1 to 5)
		var/obj/item/food/grown/coffee/bean = new beantype(src)
		ADD_TRAIT(bean, TRAIT_DRIED, ELEMENT_TRAIT(type))
		bean.add_atom_colour(COLOR_DRIED_TAN, FIXED_COLOUR_PRIORITY) //give them the tan just like from the drying rack

/obj/item/storage/box/coffeepack/robusta
	icon_state = "robusta_beans"
	name = "罗布斯塔咖啡豆"
	desc = "装新鲜、干燥的罗布斯塔咖啡豆，来自Waffle公司的采购和包装."
	beantype = /obj/item/food/grown/coffee/robusta
