/obj/effect/spawner/random/vending/snackvend
	loot = list(
		/obj/machinery/vending/imported,
		/obj/machinery/vending/imported/yangyu,
		/obj/machinery/vending/imported/mothic,
		/obj/machinery/vending/imported/tiziran,
	)

/obj/effect/spawner/random/vending/colavend //These can serve both snacks AND drinks so its kinda both of them?
	loot = list(
		/obj/machinery/vending/imported,
		/obj/machinery/vending/imported/yangyu,
		/obj/machinery/vending/imported/mothic,
		/obj/machinery/vending/imported/tiziran,
	)

/datum/supply_pack/vending/imported/fill(obj/structure/closet/crate/target_crate)
	. = ..()
	for(var/obj/vendor_refill as anything in typesof(/obj/item/vending_refill/snack/imported))
		new vendor_refill(target_crate)

/obj/machinery/vending/imported
	name = "NT食品特供"
	desc = "出售人类食物的自动贩卖机."
	icon = 'modular_skyrat/modules/imported_vendors/icons/imported_vendors.dmi'
	icon_state = "nt_food"
	panel_type = "panel15"
	light_mask = "nt_food-light-mask"
	light_color = LIGHT_COLOR_LIGHT_CYAN
	product_slogans = "注意! 商品正在热销!;瞧瞧这实惠的价格!;饿了吗? 我也是- 等等，不，我收回前言!"
	product_categories = list(
		list(
			"name" = "小食",
			"icon" = "cookie",
			"products" = list(
				/obj/item/food/peanuts/random = 6,
				/obj/item/food/cnds/random = 6,
				/obj/item/food/pistachios = 6,
				/obj/item/food/cornchips/random = 6,
				/obj/item/food/sosjerky = 6,
				/obj/item/reagent_containers/cup/soda_cans/cola = 6,
				/obj/item/reagent_containers/cup/soda_cans/lemon_lime = 6,
				/obj/item/reagent_containers/cup/soda_cans/starkist = 6,
				/obj/item/reagent_containers/cup/soda_cans/pwr_game = 6,
			),
		),
		list(
			"name" = "正餐",
			"icon" = "pizza-slice",
			"products" = list(
				/obj/item/storage/box/foodpack/nt = 6,
				/obj/item/storage/box/foodpack/nt/burger = 6,
				/obj/item/storage/box/foodpack/nt/chicken_sammy = 6,
				/obj/item/food/vendor_tray_meal/side = 6,
				/obj/item/food/vendor_tray_meal/side/crackers_and_jam = 6,
				/obj/item/food/vendor_tray_meal/side/crackers_and_cheese = 6,
			),
		),
	)

	refill_canister = /obj/item/vending_refill/snack/imported
	default_price = PAYCHECK_CREW * 0.5
	extra_price = PAYCHECK_COMMAND
	payment_department = NO_FREEBIES

/obj/item/vending_refill/snack/imported
	machine_name = "NT食品特供"

/obj/machinery/vending/imported/yangyu
	name = "富登料亭"
	desc = "出售传统日料的自动售货机."
	icon_state = "yangyu_food"
	light_mask = "yangyu_food-light-mask"
	light_color = LIGHT_COLOR_FLARE
	product_slogans = "新鲜鲤鱼来自本地太空养殖!;仿龙虾寿司可供选择!;依据传统工艺精心制作!"
	product_categories = list(
		list(
			"name" = "小食",
			"icon" = "cookie",
			"products" = list(
				/obj/item/reagent_containers/cup/glass/dry_ramen/prepared = 6,
				/obj/item/reagent_containers/cup/glass/dry_ramen/prepared/hell = 6,
				/obj/item/food/vendor_snacks/rice_crackers = 6,
				/obj/item/food/vendor_snacks/mochi_ice_cream = 6,
				/obj/item/food/vendor_snacks/mochi_ice_cream/matcha = 6,
				/obj/item/reagent_containers/cup/glass/waterbottle/tea = 6,
				/obj/item/reagent_containers/cup/glass/waterbottle/tea/astra = 6,
				/obj/item/reagent_containers/cup/glass/waterbottle/tea/strawberry = 6,
				/obj/item/reagent_containers/cup/glass/waterbottle/tea/nip = 6,
			),
		),
		list(
			"name" = "正餐",
			"icon" = "pizza-slice",
			"products" = list(
				/obj/item/storage/box/foodpack/yangyu = 6,
				/obj/item/storage/box/foodpack/yangyu/sushi = 6,
				/obj/item/storage/box/foodpack/yangyu/beef_rice = 6,
				/obj/item/food/vendor_tray_meal/side/miso = 6,
				/obj/item/food/vendor_tray_meal/side/rice = 6,
				/obj/item/food/vendor_tray_meal/side/pickled_vegetables = 6,
			),
		),
	)

	refill_canister = /obj/item/vending_refill/snack/imported/yangyu
	initial_language_holder = /datum/language_holder/yangyu_vendor

/datum/language_holder/yangyu_vendor
	understood_languages = list(
		/datum/language/yangyu = list(LANGUAGE_ATOM),
		)
	spoken_languages = list(
		/datum/language/yangyu = list(LANGUAGE_ATOM),
		)

/obj/machinery/vending/imported/yangyu/examine_more(mob/user)
	. = ..()
	. += span_notice("似乎有人在贩卖机一侧写下了<i>\"不要相信寿司!\"</i>的话语.")
	return .

/obj/item/vending_refill/snack/imported/yangyu
	machine_name = "富登料亭"

/obj/machinery/vending/imported/mothic
	name = "游牧舰队口粮贸易机"
	desc = "游牧舰队上的自动贩卖机之一，尽管刻有舰队名字，但已经被改造成了可以接受信用点支付."
	icon_state = "moth_food"
	light_mask = "moth_food-light-mask"
	light_color = LIGHT_COLOR_HALOGEN
	product_slogans = "你要支援舰队，那就兑换口粮!;物美价廉的完美选择!;为舰队远行尽一份你自己的力量!"
	product_categories = list(
		list(
			"name" = "小食",
			"icon" = "cookie",
			"products" = list(
				/obj/item/food/vendor_snacks/mothmallow = 6,
				/obj/item/food/vendor_snacks/moth_bag = 6,
				/obj/item/food/vendor_snacks/moth_bag/fuel_jack = 6,
				/obj/item/food/vendor_snacks/moth_bag/cheesecake = 6,
				/obj/item/food/vendor_snacks/moth_bag/cheesecake/honey = 6,
				/obj/item/reagent_containers/cup/soda_cans/skyrat/lemonade = 6,
				/obj/item/reagent_containers/cup/soda_cans/skyrat/navy_rum = 6,
				/obj/item/reagent_containers/cup/soda_cans/skyrat/soda_water_moth = 6,
				/obj/item/reagent_containers/cup/soda_cans/skyrat/ginger_beer = 6,
			),
		),
		list(
			"name" = "正餐",
			"icon" = "pizza-slice",
			"products" = list(
				/obj/item/storage/box/foodpack/moth = 6,
				/obj/item/storage/box/foodpack/moth/baked_rice = 6,
				/obj/item/storage/box/foodpack/moth/fuel_jack = 6,
				/obj/item/food/vendor_tray_meal/side/moffin = 6,
				/obj/item/food/vendor_tray_meal/side/cornbread = 6,
				/obj/item/food/vendor_tray_meal/side/roasted_seeds = 6,
			),
		),
	)

	refill_canister = /obj/item/vending_refill/snack/imported/mothic
	initial_language_holder = /datum/language_holder/moffic_vendor

/datum/language_holder/moffic_vendor
	understood_languages = list(
		/datum/language/moffic = list(LANGUAGE_ATOM),
		)
	spoken_languages = list(
		/datum/language/moffic = list(LANGUAGE_ATOM),
		)

/obj/item/vending_refill/snack/imported/mothic
	machine_name = "游牧舰队口粮贸易机"

/obj/machinery/vending/imported/tiziran
	name = "缇兹兰美食专卖"
	desc = "一台出售可能来自缇兹兰的热门美食的售货机"
	icon_state = "tizira_food"
	light_mask = "tizira_food-light-mask"
	light_color = LIGHT_COLOR_FIRE
	product_slogans = "我们承诺食材均来自首都本地，货真价实!;精选稀有海水捕捞鱼类!;所有肉类菜品均附赠月鱼酱汁!"
	product_categories = list(
		list(
			"name" = "小食",
			"icon" = "cookie",
			"products" = list(
				/obj/item/food/chips/shrimp = 6,
				/obj/item/food/vendor_snacks/lizard_bag = 6,
				/obj/item/food/vendor_snacks/lizard_bag/moon_jerky = 6,
				/obj/item/food/vendor_snacks/lizard_box = 6,
				/obj/item/food/vendor_snacks/lizard_box/sweet_roll = 6,
				/obj/item/reagent_containers/cup/glass/bottle/mushi_kombucha = 6,
				/obj/item/reagent_containers/cup/glass/waterbottle/tea/mushroom = 6,
				/obj/item/reagent_containers/cup/soda_cans/skyrat/kortara = 6,
			),
		),
		list(
			"name" = "主餐",
			"icon" = "pizza-slice",
			"products" = list(
				/obj/item/storage/box/foodpack/tizira = 6,
				/obj/item/storage/box/foodpack/tizira/roll = 6,
				/obj/item/storage/box/foodpack/tizira/stir_fry = 6,
				/obj/item/food/vendor_tray_meal/side/root_crackers = 6,
				/obj/item/food/vendor_tray_meal/side/korta_brittle = 6,
				/obj/item/food/vendor_tray_meal/side/crispy_headcheese = 6,
			),
		),
	)

	refill_canister = /obj/item/vending_refill/snack/imported/tiziran
	initial_language_holder = /datum/language_holder/draconic_vendor

/datum/language_holder/draconic_vendor
	understood_languages = list(
		/datum/language/draconic = list(LANGUAGE_ATOM),
		)
	spoken_languages = list(
		/datum/language/draconic = list(LANGUAGE_ATOM),
		)

/obj/item/vending_refill/snack/imported/tiziran
	machine_name = "缇兹兰美食专卖"
