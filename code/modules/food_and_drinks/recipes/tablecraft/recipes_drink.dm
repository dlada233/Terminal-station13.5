
// This is the home of drink related tablecrafting recipes, I have opted to only let players bottle fancy boozes to reduce the number of entries.

///////////////// Booze & Bottles ///////////////////

/datum/crafting_recipe/lizardwine
	name = "蜥蜴酒"
	time = 40
	reqs = list(
		/obj/item/organ/external/tail/lizard = 1,
		/datum/reagent/consumable/ethanol = 100
	)
	blacklist = list(/obj/item/organ/external/tail/lizard/fake)
	result = /obj/item/reagent_containers/cup/glass/bottle/lizardwine
	category = CAT_DRINK

/datum/crafting_recipe/moonshinejug
	name = "月光"
	time = 30
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/moonshine = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/moonshine
	category = CAT_DRINK

/datum/crafting_recipe/hoochbottle
	name = "Hooch私酒"
	time = 30
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/obj/item/storage/box/papersack = 1,
		/datum/reagent/consumable/ethanol/hooch = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/hooch
	category = CAT_DRINK

/datum/crafting_recipe/blazaambottle
	name = "Blazaam酒"
	time = 20
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/blazaam = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/blazaam
	category = CAT_DRINK

/datum/crafting_recipe/champagnebottle
	name = "Champagne香槟酒"
	time = 30
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/champagne = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/champagne
	category = CAT_DRINK

/datum/crafting_recipe/trappistbottle
	name = "Trappist特拉比斯啤酒"
	time = 15
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle/small = 1,
		/datum/reagent/consumable/ethanol/trappist = 50
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/trappist
	category = CAT_DRINK

/datum/crafting_recipe/goldschlagerbottle
	name = "Goldschlager金杜松子酒"
	time = 30
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/goldschlager = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/goldschlager
	category = CAT_DRINK

/datum/crafting_recipe/patronbottle
	name = "Patron"
	time = 30
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/patron = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/patron
	category = CAT_DRINK

////////////////////// Non-alcoholic recipes ///////////////////

/datum/crafting_recipe/holybottle
	name = "圣水"
	time = 30
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/water/holywater = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/holywater
	category = CAT_DRINK

//flask of unholy water is a beaker for some reason, I will try making it a bottle and add it here once the antag freeze is over. t. kryson

/datum/crafting_recipe/nothingbottle
	name = "Nothing"
	time = 30
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/nothing = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/bottleofnothing
	category = CAT_DRINK

/datum/crafting_recipe/smallcarton
	name = "小纸盒"
	result = /obj/item/reagent_containers/cup/glass/bottle/juice/smallcarton
	time = 10
	reqs = list(/obj/item/stack/sheet/cardboard = 1)
	category = CAT_CONTAINERS

/datum/crafting_recipe/candycornliquor
	name = "玉米糖酒"
	result = /obj/item/reagent_containers/cup/glass/bottle/candycornliquor
	time = 30
	reqs = list(/datum/reagent/consumable/ethanol/whiskey = 100,
				/obj/item/food/candy_corn = 1,
				/obj/item/reagent_containers/cup/glass/bottle = 1)
	category = CAT_DRINK

/datum/crafting_recipe/kong
	name = "空"
	result = /obj/item/reagent_containers/cup/glass/bottle/kong
	time = 30
	reqs = list(/datum/reagent/consumable/ethanol/whiskey = 100,
				/obj/item/food/monkeycube = 1,
				/obj/item/reagent_containers/cup/glass/bottle = 1)
	category = CAT_DRINK

/datum/crafting_recipe/pruno
	name = "混合pruno"
	result = /obj/item/reagent_containers/cup/glass/bottle/pruno
	time = 30
	reqs = list(/obj/item/storage/bag/trash = 1,
	            /obj/item/food/breadslice/moldy = 1,
	            /obj/item/food/grown = 4,
	            /obj/item/food/candy_corn = 2,
	            /datum/reagent/water = 15)
	category = CAT_DRINK
