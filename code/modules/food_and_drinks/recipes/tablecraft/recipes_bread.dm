
// see code/module/crafting/table.dm

////////////////////////////////////////////////BREAD////////////////////////////////////////////////

/datum/crafting_recipe/food/meatbread
	name = "肉面包"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/plain = 3,
		/obj/item/food/cheese/wedge = 3
	)
	result = /obj/item/food/bread/meat
	category = CAT_BREAD

/datum/crafting_recipe/food/xenomeatbread
	name = "异形肉面包"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/xeno = 3,
		/obj/item/food/cheese/wedge = 3
	)
	result = /obj/item/food/bread/xenomeat
	category = CAT_BREAD

/datum/crafting_recipe/food/spidermeatbread
	name = "蜘蛛肉面包"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/spider = 3,
		/obj/item/food/cheese/wedge = 3
	)
	result = /obj/item/food/bread/spidermeat
	category = CAT_BREAD

/datum/crafting_recipe/food/sausagebread
	name = "香肠面包"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/sausage = 2,
	)
	result = /obj/item/food/bread/sausage
	category = CAT_BREAD

/datum/crafting_recipe/food/banananutbread
	name = "奶油香蕉坚果面包"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/boiledegg = 3,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/bread/banana
	category = CAT_BREAD

/datum/crafting_recipe/food/tofubread
	name = "豆腐面包"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/tofu = 3,
		/obj/item/food/cheese/wedge = 3
	)
	result = /obj/item/food/bread/tofu
	category = CAT_BREAD

/datum/crafting_recipe/food/creamcheesebread
	name = "奶油芝士面包"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/cheese/wedge = 2
	)
	result = /obj/item/food/bread/creamcheese
	category = CAT_BREAD

/datum/crafting_recipe/food/mimanabread
	name = "默蕉面包"
	reqs = list(
		/datum/reagent/consumable/soymilk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/tofu = 3,
		/obj/item/food/grown/banana/mime = 1
	)
	result = /obj/item/food/bread/mimana
	category = CAT_BREAD

/datum/crafting_recipe/food/garlicbread
	name = "蒜蓉面包"
	time = 40
	reqs = list(/obj/item/food/grown/garlic = 1,
				/obj/item/food/breadslice/plain = 1,
				/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/garlicbread
	category = CAT_BREAD

/datum/crafting_recipe/food/butterbiscuit
	name = "奶油饼干"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/butterbiscuit
	category = CAT_BREAD

/datum/crafting_recipe/food/butterdog
	name = "黄狗"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butter = 1,
		)
	result = /obj/item/food/butterdog
	category = CAT_BREAD

/datum/crafting_recipe/food/baguette
	name = "法棍面包"
	time = 40
	reqs = list(/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
		/obj/item/food/pastrybase = 2
	)
	result = /obj/item/food/baguette
	category = CAT_BREAD

/datum/crafting_recipe/food/raw_breadstick
	name = "生长面包"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/raw_breadstick
	category = CAT_BREAD

/datum/crafting_recipe/food/raw_croissant
	name = "生羊角面包"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/datum/reagent/consumable/sugar = 1,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/raw_croissant
	category = CAT_BREAD

/datum/crafting_recipe/food/throwing_croissant
	name = "羊角面包镖"
	reqs = list(
		/obj/item/food/croissant = 1,
		/obj/item/stack/rods = 1,
	)
	result = /obj/item/food/croissant/throwing
	category = CAT_BREAD
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/food/breaddog
	name = "面包狗"
	reqs = list(
		/obj/item/organ/internal/brain = 1,
		/obj/item/organ/internal/heart = 1,
		/obj/item/food/bread/plain = 2,
		/obj/item/food/meat/slab = 3,
		/datum/reagent/blood = 30,
		/datum/reagent/teslium = 1 //To shock the whole thing into life
	)
	result = /mob/living/basic/pet/dog/breaddog
	category = CAT_BREAD

////////////////////////////////////////////////TOAST////////////////////////////////////////////////

/datum/crafting_recipe/food/slimetoast
	name = "史莱姆吐司"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/food/breadslice/plain = 1
	)
	result = /obj/item/food/jelliedtoast/slime
	category = CAT_BREAD

/datum/crafting_recipe/food/jelliedyoast
	name = "果酱面包"
	reqs = list(
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/food/breadslice/plain = 1
	)
	result = /obj/item/food/jelliedtoast/cherry
	category = CAT_BREAD

/datum/crafting_recipe/food/butteredtoast
	name = "黄油吐司"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/butteredtoast
	category = CAT_BREAD

/datum/crafting_recipe/food/twobread
	name = "双面包"
	reqs = list(
		/datum/reagent/consumable/ethanol/wine = 5,
		/obj/item/food/breadslice/plain = 2
	)
	result = /obj/item/food/twobread
	category = CAT_BREAD

/datum/crafting_recipe/food/moldybread // why would you make this?
	name = "发霉面包片"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/obj/item/food/grown/mushroom/amanita = 1
		)
	result = /obj/item/food/breadslice/moldy
	category = CAT_BREAD

/datum/crafting_recipe/food/breadcat
	name = "面包猫"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/organ/internal/ears/cat = 1,
		/obj/item/organ/external/tail/cat = 1,
		/obj/item/food/meat/slab = 3,
		/datum/reagent/blood = 50,
		/datum/reagent/medicine/strange_reagent = 5
	)
	result = /mob/living/basic/pet/cat/breadcat
	category = CAT_BREAD

/datum/crafting_recipe/food/frenchtoast
	name = "生法式吐司"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/obj/item/food/egg = 2,
		/datum/reagent/consumable/milk = 5
	)
	result = /obj/item/food/raw_frenchtoast
	category = CAT_BREAD
