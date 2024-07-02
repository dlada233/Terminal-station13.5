
// see code/module/crafting/table.dm

////////////////////////////////////////////////PIES////////////////////////////////////////////////

/datum/crafting_recipe/food/bananacreampie
	name = "奶油香蕉派"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/pie/cream
	category = CAT_PIE

/datum/crafting_recipe/food/meatpie
	name = "肉派"
	reqs = list(
		/datum/reagent/consumable/blackpepper = 1,
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/meat/steak/plain = 1
	)
	result = /obj/item/food/pie/meatpie
	category = CAT_PIE

/datum/crafting_recipe/food/tofupie
	name = "豆腐派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/tofu = 1
	)
	result = /obj/item/food/pie/tofupie
	category = CAT_PIE

/datum/crafting_recipe/food/xenopie
	name = "异形派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/meat/cutlet/xeno = 1
	)
	result = /obj/item/food/pie/xemeatpie
	category = CAT_PIE

/datum/crafting_recipe/food/cherrypie
	name = "樱桃派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/cherries = 1
	)
	result = /obj/item/food/pie/cherrypie
	category = CAT_PIE

/datum/crafting_recipe/food/berryclafoutis
	name = "克拉芙提"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/pie/berryclafoutis
	category = CAT_PIE

/datum/crafting_recipe/food/bearypie
	name = "熊肉派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 1,
		/obj/item/food/meat/steak/bear = 1
	)
	result = /obj/item/food/pie/bearypie
	category = CAT_PIE

/datum/crafting_recipe/food/amanitapie
	name = "毒鹅膏派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/mushroom/amanita = 1
	)
	result = /obj/item/food/pie/amanita_pie
	category = CAT_PIE

/datum/crafting_recipe/food/plumppie
	name = "厚头菇派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/mushroom/plumphelmet = 1
	)
	result = /obj/item/food/pie/plump_pie
	category = CAT_PIE

/datum/crafting_recipe/food/applepie
	name = "苹果派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/apple = 1
	)
	result = /obj/item/food/pie/applepie
	category = CAT_PIE

/datum/crafting_recipe/food/pumpkinpie
	name = "南瓜派"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/pumpkin = 1
	)
	result = /obj/item/food/pie/pumpkinpie
	category = CAT_PIE

/datum/crafting_recipe/food/goldenappletart
	name = "金苹果派"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/apple/gold = 1
	)
	result = /obj/item/food/pie/appletart
	category = CAT_PIE

/datum/crafting_recipe/food/grapetart
	name = "葡萄馅饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/grapes = 3
	)
	result = /obj/item/food/pie/grapetart
	category = CAT_PIE

/datum/crafting_recipe/food/mimetart
	name = "默剧馅饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/datum/reagent/consumable/nothing = 5
	)
	result = /obj/item/food/pie/mimetart
	category = CAT_PIE
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/food/berrytart
	name = "浆果馅饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 3
	)
	result = /obj/item/food/pie/berrytart
	category = CAT_PIE
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/food/cocolavatart
	name = "巧克力熔岩馅饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/chocolatebar = 3,
		/obj/item/slime_extract = 1 //The reason you dont know how to make it!
	)
	result = /obj/item/food/pie/cocolavatart
	category = CAT_PIE
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/food/blumpkinpie
	name = "蓝瓜派"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/pumpkin/blumpkin = 1
	)
	result = /obj/item/food/pie/blumpkinpie
	category = CAT_PIE

/datum/crafting_recipe/food/dulcedebatata
	name = "甜土豆派"
	reqs = list(
		/datum/reagent/consumable/vanilla = 5,
		/datum/reagent/water = 5,
		/obj/item/food/grown/potato/sweet = 2
	)
	result = /obj/item/food/pie/dulcedebatata
	category = CAT_PIE

/datum/crafting_recipe/food/frostypie
	name = "霜冻派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/bluecherries = 1
	)
	result = /obj/item/food/pie/frostypie
	category = CAT_PIE

/datum/crafting_recipe/food/baklava
	name = "果仁蜜饼"
	reqs = list(
		/obj/item/food/butterslice = 2,
		/obj/item/food/tortilla = 4, //Layers
		/obj/item/seeds/wheat/oat = 4
	)
	result = /obj/item/food/pie/baklava
	category = CAT_PIE

/datum/crafting_recipe/food/frenchsilkpie
	name = "法式丝绸派"
	reqs = list(
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/chocolatebar = 2,
	)
	result = /obj/item/food/pie/frenchsilkpie
	category = CAT_PIE

/datum/crafting_recipe/food/shepherds_pie
	name = "牧羊人派"
	reqs = list(
		/obj/item/food/mashed_potatoes = 1,
		/obj/item/food/meat/cutlet = 3,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/peas = 1,
		/obj/item/food/grown/corn = 1,
		/obj/item/food/grown/garlic = 1,
	)
	result = /obj/item/food/pie/shepherds_pie
	category = CAT_PIE

/datum/crafting_recipe/food/asdfpie
	name = "派中派"
	reqs = list(
		/obj/item/food/pie/plain = 2,
	)
	result = /obj/item/food/pie/asdfpie
	category = CAT_PIE

/datum/crafting_recipe/food/bacid_pie
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/stock_parts/cell = 2,
	)
	result = /obj/item/food/pie/bacid_pie
	category = CAT_PIE
