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
	name = "杜拉棉背心"
	desc = "不要相信他们告诉你这些东西是\"材质像石棉一样\"或\"因安全隐患而下架\".这可能就是稳健行动和报复行动的区别."
	item = /obj/item/clothing/suit/armor/vest/durathread

	price_min = CARGO_CRATE_VALUE
	price_max = CARGO_CRATE_VALUE * 2
	stock_max = 4
	availability_prob = 50

/datum/market_item/clothing/durathread_helmet
	name = "杜拉棉头盔"
	desc = "顾客老是问我为什么用装甲织物制成就能叫头盔，而我总是说一句话：不退款."
	item = /obj/item/clothing/head/helmet/durathread

	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	stock_max = 4
	availability_prob = 50

/datum/market_item/clothing/full_spacesuit_set
	name = "纳米传讯牌太空服"
	desc = "几箱\"老式\"太空服从太空卡车上掉了下来."
	item = /obj/item/storage/box

	price_min = CARGO_CRATE_VALUE * 7.5
	price_max = CARGO_CRATE_VALUE * 20
	stock_max = 3
	availability_prob = 30

/datum/market_item/clothing/full_spacesuit_set/spawn_item(loc)
	var/obj/item/storage/box/B = ..()
	B.name = "太空服盒"
	B.desc = "上面印有NT标志."
	new /obj/item/clothing/suit/space(B)
	new /obj/item/clothing/head/helmet/space(B)
	return B

/datum/market_item/clothing/chameleon_hat
	name = "变色龙帽"
	desc = "这个方便的头戴设备可以伪装成任何你想要的帽子，未经质检."
	item = /obj/item/clothing/head/chameleon/broken

	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	stock_max = 2
	availability_prob = 70

/datum/market_item/clothing/rocket_boots
	name = "火箭靴"
	desc = "我们找到了一双跳跃靴，然后超频了一下，不承担任何用户因此而造成身体严重伤害的责任."
	item = /obj/item/clothing/shoes/bhop/rocket

	price_min = CARGO_CRATE_VALUE * 5
	price_max = CARGO_CRATE_VALUE * 15
	stock_max = 1
	availability_prob = 40

/datum/market_item/clothing/anti_sec_pin
	name = "亡命胸针"
	desc = "红色限量版时尚别针，向纳米传讯的敌人宣示你的忠诚. \
	内含RFID芯片可以干扰普通扫描设备, 来确保他们知道你是玩真的.和你的朋友分享吧!"
	item = /obj/item/clothing/accessory/anti_sec_pin

	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE * 1.5
	stock_max = 5
	availability_prob = 70
