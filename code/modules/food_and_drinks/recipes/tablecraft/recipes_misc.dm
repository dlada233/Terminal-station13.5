
// see code/module/crafting/table.dm

// MISC

/datum/crafting_recipe/food/candiedapple
	name = "苹果糖"
	reqs = list(
		/datum/reagent/consumable/caramel = 5,
		/obj/item/food/grown/apple = 1
	)
	result = /obj/item/food/candiedapple
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/spiderlollipop
	name = "蜘蛛棒棒糖"
	reqs = list(/obj/item/stack/rods = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/water = 5,
		/obj/item/food/spiderling = 1
	)
	result = /obj/item/food/spiderlollipop
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/chococoin
	name = "巧克力币"
	reqs = list(
		/obj/item/coin = 1,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/chococoin
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/fudgedice
	name = "巧克力骰子"
	reqs = list(
		/obj/item/dice = 1,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/fudgedice
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/chocoorange
	name = "巧克力橙子"
	reqs = list(
		/obj/item/food/grown/citrus/orange = 1,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/chocoorange
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/cheesyfries
	name = "芝士薯条"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/cheese/wedge = 1
	)
	result = /obj/item/food/cheesyfries
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/poutine
	name = "加拿大薯条"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/cheese/wedge = 1,
		/datum/reagent/consumable/gravy = 3
	)
	result = /obj/item/food/poutine
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/beans
	name = "豆子罐头"
	time = 40
	reqs = list(/datum/reagent/consumable/ketchup = 5,
		/obj/item/food/grown/soybeans = 2
	)
	result = /obj/item/food/canned/beans
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/eggplantparm
	name ="茄子通心粉"
	reqs = list(
		/obj/item/food/cheese/wedge = 2,
		/obj/item/food/grown/eggplant = 1
	)
	result = /obj/item/food/eggplantparm
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/melonkeg
	name ="瓜桶"
	reqs = list(
		/datum/reagent/consumable/ethanol/vodka = 25,
		/obj/item/food/grown/holymelon = 1,
		/obj/item/reagent_containers/cup/glass/bottle/vodka = 1
	)
	parts = list(/obj/item/reagent_containers/cup/glass/bottle/vodka = 1)
	result = /obj/item/food/melonkeg
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/honeybar
	name = "蜂蜜坚果棒"
	reqs = list(
		/obj/item/food/grown/oat = 1,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/honeybar
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/powercrepe
	name = "Powercrepe"
	time = 40
	reqs = list(
		/obj/item/food/flatdough = 1,
		/datum/reagent/consumable/milk = 1,
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/stock_parts/cell/super =1,
		/obj/item/melee/sabre = 1
	)
	result = /obj/item/food/powercrepe
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/branrequests
	name = "Bran Requests Cereal"
	reqs = list(
		/obj/item/food/grown/wheat = 1,
		/obj/item/food/no_raisin = 1,
	)
	result = /obj/item/food/branrequests
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/ricepudding
	name = "米饭布丁"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/boiledrice = 1
	)
	result = /obj/item/food/salad/ricepudding
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/risotto
	name = "意大利调味饭"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/cheese/wedge = 1,
		/datum/reagent/consumable/ethanol/wine = 5,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/mushroom/chanterelle = 1
	)
	result = /obj/item/food/salad/risotto
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/butterbear //ITS ALIVEEEEEE!
	name = "熊之炼金术"
	reqs = list(
		/obj/item/organ/internal/brain = 1,
		/obj/item/organ/internal/heart = 1,
		/obj/item/food/butter = 4,
		/obj/item/food/meat/slab = 5,
		/datum/reagent/blood = 50,
		/datum/reagent/teslium = 1 //To shock the whole thing into life
	)
	result = /mob/living/basic/bear/butter
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/crab_rangoon
	name = "炸蟹角"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/datum/reagent/consumable/cream = 5,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/meat/slab/rawcrab = 1
	)
	result = /obj/item/food/crab_rangoon
	category = CAT_SEAFOOD

/datum/crafting_recipe/food/royalcheese
	name = "皇家奶酪"
	reqs = list(
		/obj/item/food/cheese/wheel = 1,
		/obj/item/clothing/head/costume/crown = 1,
		/datum/reagent/medicine/strange_reagent = 5,
		/datum/reagent/toxin/mutagen = 5
	)
	result = /obj/item/food/cheese/royal
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/ant_candy
	name = "蚂蚁糖"
	reqs = list(/obj/item/stack/rods = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/water = 5,
		/datum/reagent/ants = 10
	)
	result = /obj/item/food/ant_candy
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/pesto
	name = "意大利青酱"
	reqs = list(
		/obj/item/food/cheese/firm_cheese_slice = 1,
		/datum/reagent/consumable/salt = 5,
		/obj/item/food/grown/herbs = 2,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 5,
		/obj/item/food/canned/pine_nuts = 1
	)
	result = /obj/item/food/pesto
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/tomato_sauce
	name = "番茄酱"
	reqs = list(
		/obj/item/food/canned/tomatoes = 1,
		/datum/reagent/consumable/salt = 2,
		/obj/item/food/grown/herbs = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 5
	)
	result = /obj/item/food/tomato_sauce
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/bechamel_sauce
	name = "白酱"
	reqs = list(
		/datum/reagent/consumable/milk = 10,
		/datum/reagent/consumable/flour = 5,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/bechamel_sauce
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/pierogi
	name = "波兰饺子"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/pierogi
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/stuffed_cabbage
	name = "卷心菜卷"
	reqs = list(
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/tomato = 1,
	)
	result = /obj/item/food/stuffed_cabbage
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/granola_bar
	name = "燕麦棒"
	reqs = list(
		/obj/item/food/grown/oat = 1,
		/obj/item/food/grown/peanut = 1,
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/no_raisin = 1,
	)
	result = /obj/item/food/granola_bar
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/onigiri
	name = "饭团"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/seaweedsheet = 1,
	)
	result = /obj/item/food/onigiri
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/mashed_potatoes
	name = "土豆泥"
	reqs = list(
		/obj/item/food/grown/potato = 2,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/butterslice = 1,
	)
	result = /obj/item/food/mashed_potatoes
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/pacoca
	name = "花生酥糖"
	reqs = list(
		/obj/item/food/grown/peanut = 2,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/pacoca
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/springroll
	name = "春卷"
	reqs = list(
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/cucumber = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/rice = 10,
		/datum/reagent/water = 10,
	)
	result = /obj/item/food/springroll
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/caramel_popcorn
	name = "焦糖爆米花"
	reqs = list(
		/obj/item/food/popcorn = 1,
		/datum/reagent/consumable/caramel = 3,
	)
	result = /obj/item/food/popcorn/caramel
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/salty_popcorn
	name = "咸爆米花"
	reqs = list(
		/obj/item/food/popcorn = 1,
		/datum/reagent/consumable/salt = 3,
	)
	result = /obj/item/food/popcorn/salty
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/spacylibertyduff
	name = "宇宙果冻"
	reqs = list(
		/datum/reagent/consumable/ethanol/vodka = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/grown/mushroom/libertycap = 3
	)
	result = /obj/item/food/bowled/spacylibertyduff
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/amanitajelly
	name = "鹅膏菌果冻"
	reqs = list(
		/datum/reagent/consumable/ethanol/vodka = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/grown/mushroom/amanita = 3
	)
	result = /obj/item/food/bowled/amanitajelly
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/buttered_baked_potato
	name = "烤黄油土豆"
	reqs = list(
		/obj/item/food/baked_potato = 1,
		/obj/item/food/butterslice = 1,
	)
	result = /obj/item/food/buttered_baked_potato
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/loaded_baked_potato
	name = "烤夹心土豆"
	reqs = list(
		/obj/item/food/baked_potato = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/loaded_baked_potato
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/cheese_pierogi
	name = "波兰奶酪饺子"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/cheese/wedge = 1,
	)
	result = /obj/item/food/cheese_pierogi
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/meat_pierogi
	name = "波兰肉馅饺子"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/meat/cutlet = 1,
	)
	result = /obj/item/food/meat_pierogi
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/bonbon/caramel_truffle
	name = "焦糖巧克力松露"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/caramel = 2,
	)
	result = /obj/item/food/bonbon/caramel_truffle
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/bonbon/chocolate_truffle
	name = "巧克力松露"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/sugar = 2,
	)
	result = /obj/item/food/bonbon/chocolate_truffle
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/bonbon/peanut_truffle
	name = "花生巧克力松露"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/grown/peanut = 1,
	)
	result = /obj/item/food/bonbon/peanut_truffle
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/bonbon/peanut_butter_cup
	name = "花生酱杯"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/peanut_butter = 2,
	)
	result = /obj/item/food/bonbon/peanut_butter_cup
	category = CAT_MISCFOOD

/datum/crafting_recipe/pickles_jar
	name = "腌菜罐"
	reqs = list(
		/obj/item/reagent_containers/cup/beaker/large = 1,
		/obj/item/food/grown/cucumber = 10,
		/datum/reagent/water/salt = 20,
	)
	result = /obj/item/storage/fancy/pickles_jar
	category = CAT_MISCFOOD
	delete_contents = FALSE

/datum/crafting_recipe/food/sauteed_eggplant
	name = "嫩煎茄盒"
	reqs = list(
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 3,
	)
	result = /obj/item/food/sauteed_eggplant
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/stuffed_eggplant
	name = "茄盒"
	reqs = list(
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/meat/cutlet = 1,
	)
	result = /obj/item/food/stuffed_eggplant
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/baba_ghanoush
	name = "茄泥酱"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/pita_bread = 1,
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 5,
		/datum/reagent/consumable/lemonjuice = 3,
	)
	result = /obj/item/food/baba_ghanoush
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/moussaka
	name = "希腊茄盒"
	reqs = list(
		/obj/item/food/grown/eggplant = 2,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/bechamel_sauce = 1,
	)
	result = /obj/item/food/moussaka
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/falafel
	name = "炸豆丸子"
	reqs = list(
		/obj/item/food/grown/soybeans = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/herbs = 1,
	)
	result = /obj/item/food/falafel
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/candied_pineapple
	name = "菠萝蜜饯"
	reqs = list(
		/obj/item/food/pineappleslice = 1,
		/datum/reagent/consumable/sugar = 2,
		/datum/reagent/water = 2,
	)
	result = /obj/item/food/candied_pineapple
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/tzatziki_sauce
	name = "希腊酸奶酱"
	reqs = list(
		/obj/item/food/grown/cucumber = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 2,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/salt = 1,
	)
	result = /obj/item/food/tzatziki_sauce
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/tzatziki_and_pita_bread
	name = "皮塔饼配希腊酸奶酱"
	reqs = list(
		/obj/item/food/tzatziki_sauce = 1,
		/obj/item/food/pita_bread = 1,
	)
	result = /obj/item/food/tzatziki_and_pita_bread
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/grilled_beef_gyro
	name = "希腊烤牛肉卷"
	reqs = list(
		/obj/item/food/tzatziki_sauce = 1,
		/obj/item/food/pita_bread = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/grilled_beef_gyro
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/vegetarian_gyro
	name = "希腊蔬菜卷"
	reqs = list(
		/obj/item/food/tzatziki_sauce = 1,
		/obj/item/food/pita_bread = 1,
		/obj/item/food/grown/cucumber = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/vegetarian_gyro
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/raw_pita_bread
	name = "生皮塔饼"
	reqs = list(
		/datum/reagent/consumable/flour = 10,
		/datum/reagent/water = 5,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 2,
		/datum/reagent/consumable/sugar = 2,
	)
	result = /obj/item/food/raw_pita_bread
	category = CAT_MISCFOOD
