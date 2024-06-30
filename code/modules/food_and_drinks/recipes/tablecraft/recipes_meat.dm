// see code/module/crafting/table.dm

////////////////////////////////////////////////KEBABS////////////////////////////////////////////////

/datum/crafting_recipe/food/humankebab
	name = "烤人肉串"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/meat/steak/plain/human = 2
	)
	result = /obj/item/food/kebab/human
	category = CAT_MEAT

/datum/crafting_recipe/food/kebab
	name = "烤肉串"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/meat/steak = 2
	)
	result = /obj/item/food/kebab/monkey
	category = CAT_MEAT

/datum/crafting_recipe/food/tofukebab
	name = "烤豆腐串"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/tofu = 2
	)
	result = /obj/item/food/kebab/tofu
	category = CAT_MEAT

/datum/crafting_recipe/food/tailkebab
	name = "烤蜥蜴尾串"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/organ/external/tail/lizard = 1
	)
	result = /obj/item/food/kebab/tail
	category = CAT_MEAT

/datum/crafting_recipe/food/fiestaskewer
	name = "什锦肉串"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/corn = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/kebab/fiesta
	category = CAT_MEAT

////////////////////////////////////////////////MR SPIDER////////////////////////////////////////////////

/datum/crafting_recipe/food/spidereggsham
	name = "绿蛋火腿"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/spidereggs = 1,
		/obj/item/food/meat/cutlet/spider = 2
	)
	result = /obj/item/food/spidereggsham
	category = CAT_MEAT

////////////////////////////////////////////////MISC RECIPE's////////////////////////////////////////////////

/datum/crafting_recipe/food/tempehstarter
	name = "天贝混合物"
	reqs = list(
		/obj/item/food/grown/soybeans = 5,
		/obj/item/seeds/plump = 1
	)
	result = /obj/item/food/tempehstarter
	category = CAT_MEAT

/datum/crafting_recipe/food/cornedbeef
	name = "咸牛肉和卷心菜"
	reqs = list(
		/datum/reagent/consumable/salt = 5,
		/obj/item/food/meat/steak = 1,
		/obj/item/food/grown/cabbage = 2
	)
	result = /obj/item/food/cornedbeef
	category = CAT_MEAT

/datum/crafting_recipe/food/bearsteak
	name = "燃力熊排"
	reqs = list(
		/datum/reagent/consumable/ethanol/manly_dorf = 5,
		/obj/item/food/meat/steak/bear = 1,
	)
	tool_paths = list(/obj/item/lighter)
	result = /obj/item/food/bearsteak
	category = CAT_MEAT

/datum/crafting_recipe/food/stewedsoymeat
	name = "炖素肉"
	reqs = list(
		/obj/item/food/soydope = 2,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/stewedsoymeat
	category = CAT_MEAT

/datum/crafting_recipe/food/sausage
	name = "生香肠"
	reqs = list(
		/obj/item/food/raw_meatball = 1,
		/obj/item/food/meat/rawcutlet = 2
	)
	result = /obj/item/food/raw_sausage
	category = CAT_MEAT

/datum/crafting_recipe/food/nugget
	name = "鸡块"
	reqs = list(
		/obj/item/food/meat/cutlet = 1
	)
	result = /obj/item/food/nugget
	category = CAT_MEAT

/datum/crafting_recipe/food/rawkhinkali
	name = "生卡里饺"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/meatball = 1
	)
	result = /obj/item/food/rawkhinkali
	category = CAT_MEAT

/datum/crafting_recipe/food/meatbun
	name = "包肉烧"
	reqs = list(
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/food/bun = 1,
		/obj/item/food/meatball = 1,
		/obj/item/food/grown/cabbage = 1
	)
	result = /obj/item/food/meatbun
	category = CAT_MEAT

/datum/crafting_recipe/food/pigblanket
	name = "猪包毯"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butterslice = 1,
		/obj/item/food/meat/cutlet = 1
	)
	result = /obj/item/food/pigblanket
	category = CAT_MEAT

/datum/crafting_recipe/food/ratkebab
	name = "鼠肉串"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/deadmouse = 1
	)
	result = /obj/item/food/kebab/rat
	category = CAT_MEAT

/datum/crafting_recipe/food/doubleratkebab
	name = "大鼠肉串"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/deadmouse = 2
	)
	result = /obj/item/food/kebab/rat/double
	category = CAT_MEAT

/datum/crafting_recipe/food/ricepork
	name = "猪肉拌饭"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/meat/cutlet = 2
	)
	result = /obj/item/food/salad/ricepork
	category = CAT_MEAT

/datum/crafting_recipe/food/ribs
	name = "烧烤肋排"
	reqs = list(
		/datum/reagent/consumable/bbqsauce = 5,
		/obj/item/food/meat/steak = 2,
		/obj/item/stack/rods = 2
	)
	result = /obj/item/food/bbqribs
	category = CAT_MEAT

/datum/crafting_recipe/food/meatclown
	name = "小丑肉"
	reqs = list(
		/obj/item/food/meat/steak = 1,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/meatclown
	category = CAT_MEAT

/datum/crafting_recipe/food/lasagna
	name = "千层面"
	reqs = list(
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/cheese/wedge = 2,
		/obj/item/food/spaghetti/raw = 1
	)
	result = /obj/item/food/lasagna
	category = CAT_MEAT

/datum/crafting_recipe/food/gumbo
	name = "黑眼秋葵汤饭"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/peas = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/meat/cutlet = 1
	)
	result = /obj/item/food/salad/gumbo
	category = CAT_MEAT


/datum/crafting_recipe/food/fried_chicken
	name = "炸鸡"
	reqs = list(
		/obj/item/food/meat/slab/chicken = 1,
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/corn_starch = 5,
	)
	result = /obj/item/food/fried_chicken
	category = CAT_MEAT

/datum/crafting_recipe/food/beef_stroganoff
	name = "俄式牛柳"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2,
		/obj/item/food/grown/mushroom = 2,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/meat/steak = 1,
	)
	result = /obj/item/food/beef_stroganoff
	category = CAT_MEAT

/datum/crafting_recipe/food/beef_wellington
	name = "惠灵顿牛排"
	reqs = list(
		/obj/item/food/meat/steak = 1,
		/obj/item/food/grown/mushroom = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/flatdough = 1,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2
	)
	result = /obj/item/food/beef_wellington
	category = CAT_MEAT

/datum/crafting_recipe/food/korta_wellington
	name = "科塔尔惠灵顿牛排"
	reqs = list(
		/obj/item/food/meat/steak = 1,
		/obj/item/food/grown/mushroom = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/flatrootdough = 1,
		/datum/reagent/consumable/korta_milk = 5,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2
	)
	result = /obj/item/food/korta_wellington
	category = CAT_MEAT

/datum/crafting_recipe/food/full_roast
	name = "大盘烤鸡"
	reqs = list(
		/obj/item/food/meat/steak/chicken = 2,
		/obj/item/food/roastparsnip = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/peas = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/herbs = 1,
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/gravy = 15,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2
	)
	result = /obj/item/food/roast_dinner
	category = CAT_MEAT

/datum/crafting_recipe/food/full_roast_lizzy
	name = "无谷大盘烤鸡"
	reqs = list(
		/obj/item/food/meat/steak/chicken = 2,
		/obj/item/food/roastparsnip = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/peas = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/herbs = 1,
		/datum/reagent/consumable/korta_flour = 25,
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/blood = 5,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2
	)
	result = /obj/item/food/roast_dinner_lizzy
	category = CAT_MEAT

/datum/crafting_recipe/food/full_roast_tofu
	name = "大盘烤鸡(伪)"
	reqs = list(
		/obj/item/food/tofu = 6,
		/obj/item/food/roastparsnip = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/peas = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/herbs = 1,
		/datum/reagent/consumable/flour = 15,
		/datum/reagent/consumable/soymilk = 15,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2
	)
	result = /obj/item/food/roast_dinner_tofu
	category = CAT_MEAT

/datum/crafting_recipe/food/full_english
	name = "全套英式早餐"
	reqs = list(
		/obj/item/food/sausage = 1,
		/obj/item/food/friedegg = 2,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/grown/mushroom = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/canned/beans = 1,
		/obj/item/food/butteredtoast = 1
	)
	result = /obj/item/food/full_english
	category = CAT_MEAT

/datum/crafting_recipe/food/envirochow
	name = "狗吃狗粮"
	reqs = list(
		/obj/item/food/meat/slab/corgi = 2,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	result = /obj/item/food/canned/envirochow
	category = CAT_MEAT

/datum/crafting_recipe/food/meatloaf
	name = "生肉卷"
	reqs = list(
		/obj/item/food/meat/slab = 2,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/ketchup = 10,
	)
	result = /obj/item/food/raw_meatloaf
	category = CAT_MEAT

/datum/crafting_recipe/food/sweet_and_sour_meatballs
	name = "糖醋肉丸"
	reqs = list(
		/obj/item/food/meatball = 3,
		/obj/item/food/pineappleslice = 1,
		/obj/item/food/grown/bell_pepper = 1,
		/datum/reagent/consumable/sugar = 5,
	)
	result = /obj/item/food/sweet_and_sour_meatballs
	category = CAT_MEAT

/datum/crafting_recipe/food/pineapple_skewer
	name = "菠萝肉串"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/pineappleslice = 2,
		/obj/item/food/meat/cutlet = 2,
	)
	result = /obj/item/food/kebab/pineapple_skewer
	category = CAT_MEAT
