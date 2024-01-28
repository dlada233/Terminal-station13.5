
// see code/module/crafting/table.dm

////////////////////////////////////////////////CAKE////////////////////////////////////////////////

/datum/crafting_recipe/food/carrotcake
	name = "胡萝卜蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/carrot = 2
	)
	result = /obj/item/food/cake/carrot
	category = CAT_CAKE

/datum/crafting_recipe/food/cheesecake
	name = "芝士蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/cheese/wedge = 2
	)
	result = /obj/item/food/cake/cheese
	category = CAT_CAKE

/datum/crafting_recipe/food/applecake
	name = "苹果蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/apple = 2
	)
	result = /obj/item/food/cake/apple
	category = CAT_CAKE

/datum/crafting_recipe/food/orangecake
	name = "甘橙蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/citrus/orange = 2
	)
	result = /obj/item/food/cake/orange
	category = CAT_CAKE

/datum/crafting_recipe/food/limecake
	name = "酸橙蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/citrus/lime = 2
	)
	result = /obj/item/food/cake/lime
	category = CAT_CAKE

/datum/crafting_recipe/food/lemoncake
	name = "柠檬蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/citrus/lemon = 2
	)
	result = /obj/item/food/cake/lemon
	category = CAT_CAKE

/datum/crafting_recipe/food/chocolatecake
	name = "巧克力蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/chocolatebar = 2
	)
	result = /obj/item/food/cake/chocolate
	category = CAT_CAKE

/datum/crafting_recipe/food/birthdaycake
	name = "生日蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/flashlight/flare/candle = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/caramel = 2
	)
	result = /obj/item/food/cake/birthday
	category = CAT_CAKE

/datum/crafting_recipe/food/energycake
	name = "能量蛋糕"
	reqs = list(
		/obj/item/food/cake/birthday = 1,
		/obj/item/melee/energy/sword = 1,
	)
	blacklist = list(/obj/item/food/cake/birthday/energy)
	result = /obj/item/food/cake/birthday/energy
	category = CAT_CAKE

/datum/crafting_recipe/food/braincake
	name = "脑蛋糕"
	reqs = list(
		/obj/item/organ/internal/brain = 1,
		/obj/item/food/cake/plain = 1
	)
	result = /obj/item/food/cake/brain
	category = CAT_CAKE

/datum/crafting_recipe/food/slimecake
	name = "史莱姆蛋糕"
	reqs = list(
		/obj/item/slime_extract = 1,
		/obj/item/food/cake/plain = 1
	)
	result = /obj/item/food/cake/slimecake
	category = CAT_CAKE

/datum/crafting_recipe/food/pumpkinspicecake
	name = "南瓜香料蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/pumpkin = 2
	)
	result = /obj/item/food/cake/pumpkinspice
	category = CAT_CAKE

/datum/crafting_recipe/food/holycake
	name = "神圣蛋糕"
	reqs = list(
		/datum/reagent/water/holywater = 15,
		/obj/item/food/cake/plain = 1
	)
	result = /obj/item/food/cake/holy_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/poundcake
	name = "黄油蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 4
	)
	result = /obj/item/food/cake/pound_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/hardwarecake
	name = "硬糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/circuitboard = 2,
		/datum/reagent/toxin/acid = 5
	)
	result = /obj/item/food/cake/hardware_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/berry_chocolate_cake
	name = "草莓巧克力蛋糕块"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/chocolatebar = 2,
		/obj/item/food/grown/berries = 5
	)
	result = /obj/item/food/cake/berry_chocolate_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/pavlovacream
	name = "帕芙洛娃"
	reqs = list(
		/datum/reagent/consumable/eggwhite = 12,
		/datum/reagent/consumable/sugar = 15,
		/datum/reagent/consumable/whipped_cream = 10,
		/obj/item/food/grown/berries = 5
	)
	result = /obj/item/food/cake/pavlova
	category = CAT_CAKE

/datum/crafting_recipe/food/pavlovakorta
	name = "坚果帕芙洛娃"
	reqs = list(
		/datum/reagent/consumable/eggwhite = 12,
		/datum/reagent/consumable/sugar = 15,
		/datum/reagent/consumable/korta_milk = 10,
		/obj/item/food/grown/berries = 5
	)
	result = /obj/item/food/cake/pavlova/nuts
	category = CAT_CAKE

/datum/crafting_recipe/food/berry_vanilla_cake
	name = "莓果香草蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/berries = 5
	)
	result = /obj/item/food/cake/berry_vanilla_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/clowncake
	name = "小丑蛋糕"
	always_available = FALSE
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/sundae = 2,
		/obj/item/food/grown/banana = 5
	)
	result = /obj/item/food/cake/clown_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/vanillacake
	name = "香草蛋糕"
	always_available = FALSE
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/vanillapod = 2
	)
	result = /obj/item/food/cake/vanilla_cake
	category = CAT_CAKE

/datum/crafting_recipe/food/trumpetcake
	name = "宇航员蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/trumpet = 2,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/berryjuice = 5
	)
	result = /obj/item/food/cake/trumpet
	category = CAT_CAKE


/datum/crafting_recipe/food/cak
	name = "蛋糕猫"
	reqs = list(
		/obj/item/organ/internal/brain = 1,
		/obj/item/organ/internal/heart = 1,
		/obj/item/food/cake/birthday = 1,
		/obj/item/food/meat/slab = 3,
		/datum/reagent/blood = 30,
		/datum/reagent/consumable/sprinkles = 5,
		/datum/reagent/teslium = 1 //To shock the whole thing into life
	)
	result = /mob/living/basic/pet/cat/cak
	category = CAT_CAKE //Cat! Haha, get it? CAT? GET IT? We get it - Love Felines

/datum/crafting_recipe/food/fruitcake
	name = "英式水果蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/no_raisin = 1,
		/obj/item/food/grown/cherries = 1,
		/datum/reagent/consumable/ethanol/rum = 5
	)
	result = /obj/item/food/cake/fruit
	category = CAT_CAKE

/datum/crafting_recipe/food/plumcake
	name = "李子蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/plum = 2
	)
	result = /obj/item/food/cake/plum
	category = CAT_CAKE

/datum/crafting_recipe/food/weddingcake
	name = "婚庆蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 4,
		/datum/reagent/consumable/sugar = 120,
	)
	result = /obj/item/food/cake/wedding
	category = CAT_CAKE

/datum/crafting_recipe/food/pineapple_cream_cake
	name = "菠萝奶油蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/pineapple = 1,
		/datum/reagent/consumable/cream = 20,
	)
	result = /obj/item/food/cake/pineapple_cream_cake
	category = CAT_CAKE
