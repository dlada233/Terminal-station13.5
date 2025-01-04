/obj/machinery/vending/coffee
	name = "\improper 最佳热饮"
	desc = "出售热饮的贩卖机."
	product_ads = "来一杯吧!;喝一杯吧!;有益身体健康!;何不来杯热咖啡?;我很想喝杯咖啡!;全银河最好的咖啡豆.;只给你最好的咖啡.;无与伦比的美味咖啡.;我爱咖啡，你呢?;咖啡助你工作!;喝点茶吧.;我们希望你也是最佳!;试试我们的新可可!;管理阴谋"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	panel_type = "panel9"
	products = list(
		/obj/item/reagent_containers/cup/glass/coffee = 6,
		/obj/item/reagent_containers/cup/glass/mug/tea = 6,
		/obj/item/reagent_containers/cup/glass/mug/coco = 3,
	)
	contraband = list(
		/obj/item/reagent_containers/cup/glass/ice = 12,
	)
	refill_canister = /obj/item/vending_refill/coffee
	default_price = PAYCHECK_LOWER
	extra_price = PAYCHECK_CREW
	payment_department = ACCOUNT_SRV
	light_mask = "coffee-light-mask"
	light_color = COLOR_DARK_MODERATE_ORANGE

/obj/item/vending_refill/coffee
	machine_name = "最佳热饮"
	icon_state = "refill_joe"
