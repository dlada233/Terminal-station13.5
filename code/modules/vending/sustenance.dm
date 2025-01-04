/obj/machinery/vending/sustenance
	name = "\improper 维生货机"
	desc = "根据NT囚犯道德待遇协议第47-C条规定，提供售卖食物的自动贩卖机."
	product_slogans = "享受你的食物.;足够的卡路里来支持剧烈的劳动."
	product_ads = "满足健康.;高产大量豆腐!;好吃! 太好吃了!;吃饭.;你需要食物来维持生命!;即使是囚犯每天也会有面包!;多来点玉米糖!;来试试新的冰杯!"
	light_mask = "snack-light-mask"
	icon_state = "sustenance"
	panel_type = "panel2"
	products = list(
		/obj/item/food/tofu/prison = 24,
		/obj/item/food/breadslice/moldy = 15,
		/obj/item/reagent_containers/cup/glass/ice/prison = 12,
		/obj/item/food/candy_corn/prison = 6,
		/obj/item/kitchen/spoon/plastic = 6,
	)
	contraband = list(
		/obj/item/knife = 6,
		/obj/item/kitchen/spoon = 6,
		/obj/item/reagent_containers/cup/glass/coffee = 12,
		/obj/item/tank/internals/emergency_oxygen = 6,
		/obj/item/clothing/mask/breath = 6,
	)

	refill_canister = /obj/item/vending_refill/sustenance
	default_price = PAYCHECK_LOWER
	extra_price = PAYCHECK_LOWER * 0.6
	payment_department = NO_FREEBIES

/obj/item/vending_refill/sustenance
	machine_name = "维生货机"
	icon_state = "refill_snack"

//Labor camp subtype that uses labor points obtained from mining and processing ore
/obj/machinery/vending/sustenance/labor_camp
	name = "\improper 劳改营维生货机"
	desc = "根据NT囚犯道德待遇协议第47-C条规定，提供售卖食物的自动贩卖机. \
			如果作为罪犯，则会改用劳改点数兑换."
	icon_state = "sustenance_labor"
	onstation_override = TRUE
	displayed_currency_icon = "digging"
	displayed_currency_name = " LP"

/obj/machinery/vending/sustenance/interact(mob/user)
	if(isliving(user))
		var/mob/living/living_user = user
		if(!(machine_stat & NOPOWER) && !istype(living_user.get_idcard(TRUE), /obj/item/card/id/advanced/prisoner))
			speak("未检测到囚犯账户，不允许贩卖.")
			return
	return ..()

/obj/machinery/vending/sustenance/labor_camp/proceed_payment(obj/item/card/id/paying_id_card, mob/living/mob_paying, datum/data/vending_product/product_to_vend, price_to_use)
	if(!istype(paying_id_card, /obj/item/card/id/advanced/prisoner))
		speak("我不接受贿赂! 使用劳改积分来兑换!")
		return FALSE
	var/obj/item/card/id/advanced/prisoner/paying_scum_id = paying_id_card
	if(coin_records.Find(product_to_vend) || hidden_records.Find(product_to_vend))
		price_to_use = product_to_vend.custom_premium_price ? product_to_vend.custom_premium_price : extra_price
	if(LAZYLEN(product_to_vend.returned_products))
		price_to_use = 0 //returned items are free
	if(price_to_use && !(paying_scum_id.points >= price_to_use)) //not enough good prisoner points
		speak("你没有足够的点数来兑换[product_to_vend.name].")
		flick(icon_deny, src)
		vend_ready = TRUE
		return FALSE

	paying_scum_id.points -= price_to_use
	return TRUE

/obj/machinery/vending/sustenance/labor_camp/fetch_balance_to_use(obj/item/card/id/passed_id)
	if(!istype(passed_id, /obj/item/card/id/advanced/prisoner))
		return null //no points balance - no balance at all
	var/obj/item/card/id/advanced/prisoner/paying_scum_id = passed_id
	return paying_scum_id.points
