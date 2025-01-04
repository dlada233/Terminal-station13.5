/obj/machinery/vending/hydronutrients
	name = "\improper 肥力满满"
	desc = "植物营养品贩卖机."
	product_slogans = "很高兴不用再全天然自然施肥了?;现在臭味减少了50%!;植物也值得我们关爱!"
	product_ads = "我们爱植物!;难道你不想拥有一些吗?;我们拥有史上最绿的拇指.;我们喜欢大植物.;柔软的土壤..."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	panel_type = "panel2"
	light_mask = "nutri-light-mask"
	products = list(
		/obj/item/cultivator = 3,
		/obj/item/plant_analyzer = 4,
		/obj/item/reagent_containers/cup/bottle/nutrient/ez = 30,
		/obj/item/reagent_containers/cup/bottle/nutrient/l4z = 20,
		/obj/item/reagent_containers/cup/bottle/nutrient/rh = 10,
		/obj/item/reagent_containers/spray/pestspray = 20,
		/obj/item/reagent_containers/syringe = 5,
		/obj/item/secateurs = 3,
		/obj/item/shovel/spade = 3,
		/obj/item/storage/bag/plants = 5,
	)
	contraband = list(
		/obj/item/reagent_containers/cup/bottle/ammonia = 10,
		/obj/item/reagent_containers/cup/bottle/diethylamine = 5,
		/obj/item/reagent_containers/cup/bottle/saltpetre = 5,
	)
	refill_canister = /obj/item/vending_refill/hydronutrients
	default_price = PAYCHECK_CREW * 0.8
	extra_price = PAYCHECK_COMMAND * 0.8
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/hydronutrients
	machine_name = "肥力满满"
	icon_state = "refill_plant"
