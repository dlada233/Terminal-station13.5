/obj/machinery/vending/boozeomat
	name = "\improper 波露酒市"
	desc = "一项技术奇迹，据说能在你提出要求的瞬间调制出想要的任何饮品."
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	panel_type = "panel22"

	product_categories = list(
		list(
			"name" = "酒精",
			"icon" = "wine-bottle",
			"products" = list(
				/obj/item/reagent_containers/cup/glass/bottle/curacao = 5,
				/obj/item/reagent_containers/cup/glass/bottle/applejack = 5,
				/obj/item/reagent_containers/cup/glass/bottle/wine_voltaic = 5,
				/obj/item/reagent_containers/cup/glass/bottle/tequila = 5,
				/obj/item/reagent_containers/cup/glass/bottle/rum = 5,
				/obj/item/reagent_containers/cup/glass/bottle/cognac = 5,
				/obj/item/reagent_containers/cup/glass/bottle/wine = 5,
				/obj/item/reagent_containers/cup/glass/bottle/absinthe = 5,
				/obj/item/reagent_containers/cup/glass/bottle/vermouth = 5,
				/obj/item/reagent_containers/cup/glass/bottle/gin = 5,
				/obj/item/reagent_containers/cup/glass/bottle/grenadine = 4,
				/obj/item/reagent_containers/cup/glass/bottle/hcider = 5,
				/obj/item/reagent_containers/cup/glass/bottle/amaretto = 5,
				/obj/item/reagent_containers/cup/glass/bottle/ale = 6,
				/obj/item/reagent_containers/cup/glass/bottle/grappa = 5,
				/obj/item/reagent_containers/cup/glass/bottle/navy_rum = 5,
				/obj/item/reagent_containers/cup/glass/bottle/maltliquor = 6,
				/obj/item/reagent_containers/cup/glass/bottle/kahlua = 5,
				/obj/item/reagent_containers/cup/glass/bottle/sake = 5,
				/obj/item/reagent_containers/cup/glass/bottle/beer = 6,
				/obj/item/reagent_containers/cup/glass/bottle/vodka = 5,
				/obj/item/reagent_containers/cup/glass/bottle/whiskey = 5,
				/obj/item/reagent_containers/cup/glass/bottle/coconut_rum = 5,
				/obj/item/reagent_containers/cup/glass/bottle/yuyake = 5,
				/obj/item/reagent_containers/cup/glass/bottle/shochu = 5,
				/obj/item/reagent_containers/cup/soda_cans/beer = 10,
				/obj/item/reagent_containers/cup/soda_cans/beer/rice = 10,
			),
		),

		list(
			"name" = "不含酒精",
			"icon" = "bottle-water",
			"products" = list(
				/obj/item/reagent_containers/cup/glass/ice = 10,
				/obj/item/reagent_containers/cup/glass/bottle/juice/limejuice = 4,
				/obj/item/reagent_containers/cup/glass/bottle/juice/menthol = 4,
				/obj/item/reagent_containers/cup/glass/bottle/juice/cream = 4,
				/obj/item/reagent_containers/cup/glass/bottle/juice/orangejuice = 4,
				/obj/item/reagent_containers/cup/glass/bottle/juice/tomatojuice = 4,
				/obj/item/reagent_containers/cup/soda_cans/sodawater = 15,
				/obj/item/reagent_containers/cup/soda_cans/sol_dry = 8,
				/obj/item/reagent_containers/cup/soda_cans/cola = 8,
				/obj/item/reagent_containers/cup/soda_cans/tonic = 8,
				/obj/item/reagent_containers/cup/glass/bottle/hakka_mate = 5,
				/obj/item/reagent_containers/cup/soda_cans/melon_soda = 5,
			),
		),

		list(
			"name" = "玻璃器皿",
			"icon" = "wine-glass",
			"products" = list(
				/obj/item/reagent_containers/cup/glass/drinkingglass = 30,
				/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass = 12,
				/obj/item/reagent_containers/cup/glass/flask = 3,
				/obj/item/reagent_containers/cup/glass/bottle = 15,
				/obj/item/reagent_containers/cup/glass/bottle/small = 15,
			),
		),
	)

	contraband = list(
		/obj/item/reagent_containers/cup/glass/mug/tea = 12,
		/obj/item/reagent_containers/cup/glass/bottle/fernet = 5,
	)
	premium = list(
		/obj/item/reagent_containers/cup/bottle/ethanol = 4,
		/obj/item/reagent_containers/cup/glass/bottle/champagne = 5,
		/obj/item/reagent_containers/cup/glass/bottle/trappist = 5,
		/obj/item/reagent_containers/cup/glass/bottle/bitters = 5,
	)

	product_slogans = "我希望没人要我来泡该死的茶...;酒是人类的好朋友. 你会抛弃朋友吗?;非常乐意为您服务!;这个站点难道没人口渴吗?"
	product_ads = "喝呀!;豪饮对你有益!;酒是人类最好的朋友.;非常乐意为您服务!;想来杯冰啤酒吗?;没什么能像酒一样治愈你!;喝一口吧!;来一口吧!;来一口啤酒吧!;啤酒对你有益!;只提供优质酒精!;自2053以来的最好的酒!;获奖葡萄酒!;最大酒精度!;人爱啤酒.;为进步干杯!"
	req_access = list(ACCESS_BAR)
	refill_canister = /obj/item/vending_refill/boozeomat
	default_price = PAYCHECK_CREW * 0.9
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SRV
	light_mask = "boozeomat-light-mask"

/obj/machinery/vending/boozeomat/all_access
	desc = "一项技术奇迹，据说能在你提出要求的瞬间调制出想要的任何饮品. 这一台看起来解除了权限限制."
	req_access = null

/obj/machinery/vending/boozeomat/syndicate_access
	req_access = list(ACCESS_SYNDICATE)
	age_restrictions = FALSE
	initial_language_holder = /datum/language_holder/syndicate

/obj/item/vending_refill/boozeomat
	machine_name = "波露酒市"
	icon_state = "refill_booze"
