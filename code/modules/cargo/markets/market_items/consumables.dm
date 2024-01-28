/datum/market_item/consumable
	category = "消耗品"

/datum/market_item/consumable/clown_tears
	name = "一瓶小丑之泪"
	desc = "从哭泣的博金斯悲剧厨房的保证的新鲜眼泪."
	item = /obj/item/reagent_containers/cup/bottle/clownstears
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2.6
	price_max = CARGO_CRATE_VALUE * 3
	availability_prob = 10

/datum/market_item/consumable/donk_pocket_box
	name = "一盒口袋饼"
	desc = "一个包装精美的盒子，里面装着每个太空人最喜欢的零食."
	item = /obj/item/storage/box/donkpockets

	stock_min = 2
	stock_max = 5
	price_min = CARGO_CRATE_VALUE * 1.625
	price_max = CARGO_CRATE_VALUE * 2
	availability_prob = 80

/datum/market_item/consumable/suspicious_pills
	name = "一瓶可疑的药丸"
	desc = "一种随机的随机豪华混合药物，一定会让你脸上露出笑容!"
	item = /obj/item/storage/pill_bottle

	stock_min = 2
	stock_max = 3
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 3.5
	availability_prob = 50

/datum/market_item/consumable/suspicious_pills/spawn_item(loc)
	var/pillbottle = pick(list(/obj/item/storage/pill_bottle/zoom,
				/obj/item/storage/pill_bottle/happy,
				/obj/item/storage/pill_bottle/lsd,
				/obj/item/storage/pill_bottle/aranesp,
				/obj/item/storage/pill_bottle/stimulant))
	return new pillbottle(loc)

/datum/market_item/consumable/floor_pill
	name = "奇怪的药丸"
	desc = "维修管道中的俄罗斯轮盘赌."
	item = /obj/item/reagent_containers/pill/maintenance

	stock_min = 5
	stock_max = 35
	price_min = CARGO_CRATE_VALUE * 0.05
	price_max = CARGO_CRATE_VALUE * 0.3
	availability_prob = 50

/datum/market_item/consumable/pumpup
	name = "管道兴奋剂"
	desc = "用这个抵抗任何警棍击晕."
	item = /obj/item/reagent_containers/hypospray/medipen/pumpup

	stock_max = 3
	price_min = CARGO_CRATE_VALUE * 0.25
	price_max = CARGO_CRATE_VALUE * 0.75
	availability_prob = 90
