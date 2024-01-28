/datum/market_item/clothing
	category = "服装"

/datum/market_item/clothing/ninja_mask
	name = "太空忍者面具"
	desc = "除了防火防酸防摘取, 它本身没有什么特别的."
	item = /obj/item/clothing/mask/gas/ninja

	price_min = CARGO_CRATE_VALUE
	price_max = CARGO_CRATE_VALUE * 2.5
	stock_max = 3
	availability_prob = 40

/datum/market_item/clothing/durathread_vest
	name = "Durathread-皮革背心"
	desc = "不要相信他们告诉你这些东西\"石棉材质\"或\"出于安全考虑而从市场上撤下\"."
	item = /obj/item/clothing/suit/armor/vest/durathread

	price_min = CARGO_CRATE_VALUE
	price_max = CARGO_CRATE_VALUE * 2
	stock_max = 4
	availability_prob = 50

/datum/market_item/clothing/durathread_helmet
	name = "Durathread-皮革头盔"
	desc = "顾客问我为什么叫头盔，因为它只是由装甲织物制成的，而我总是说同样的话：不退款."
	item = /obj/item/clothing/head/helmet/durathread

	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	stock_max = 4
	availability_prob = 50

/datum/market_item/clothing/full_spacesuit_set
	name = "Nanotrasen牌太空服"
	desc = "几箱\"老式\"太空服从一辆太空卡车的后面掉了下来."
	item = /obj/item/storage/box

	price_min = CARGO_CRATE_VALUE * 7.5
	price_max = CARGO_CRATE_VALUE * 20
	stock_max = 3
	availability_prob = 30

/datum/market_item/clothing/full_spacesuit_set/spawn_item(loc)
	var/obj/item/storage/box/B = ..()
	B.name = "太空服盒"
	B.desc = "上面有NTlogo."
	new /obj/item/clothing/suit/space(B)
	new /obj/item/clothing/head/helmet/space(B)
	return B

/datum/market_item/clothing/chameleon_hat
	name = "变色龙帽"
	desc = "这个方便的头戴设备可以伪装成任何你想要的帽子，没有经过质检."
	item = /obj/item/clothing/head/chameleon/broken

	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	stock_max = 2
	availability_prob = 70

/datum/market_item/clothing/rocket_boots
	name = "火箭靴"
	desc = "我们找到了一双跳跃靴，然后超频了一下，对用户身体造成的严重伤害不承担任何责任."
	item = /obj/item/clothing/shoes/bhop/rocket

	price_min = CARGO_CRATE_VALUE * 5
	price_max = CARGO_CRATE_VALUE * 15
	stock_max = 1
	availability_prob = 40

/datum/market_item/clothing/anti_sec_pin
	name = "亡命胸针"
	desc = "红色限量版时尚别针，向Nanotrasen的敌人宣示你的忠诚. \
	内含RFID芯片可以干扰普通扫描设备, 来确保他们知道你是玩真的. 和你的朋友分享吧!"
	item = /obj/item/clothing/accessory/anti_sec_pin

	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE * 1.5
	stock_max = 5
	availability_prob = 70
