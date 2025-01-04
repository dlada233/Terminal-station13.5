/obj/machinery/vending/security
	name = "\improper 武库维和装备站"
	desc = "一台武库维和装备出售贩卖机."
	product_ads = "打爆他们的头!;记住 - 伤害即治愈!;武装在此!;手铐!;不许动，渣滓!;兄弟别电我!;兄弟电他.;为什么不来个甜甜圈?"
	icon = 'modular_skyrat/modules/sec_haul/icons/vending/vending.dmi'
	products = list(
		/obj/item/restraints/handcuffs = 8,
		/obj/item/restraints/handcuffs/cable/zipties = 12,
		/obj/item/grenade/flashbang = 6,
		/obj/item/assembly/flash/handheld = 8,
		/obj/item/food/donut/plain = 12,
		/obj/item/storage/box/evidence = 6,
		/obj/item/flashlight/seclite = 6,
		/obj/item/restraints/legcuffs/bola/energy = 10,
		/obj/item/clothing/gloves/tackler/security = 5,
	)
	contraband = list(
		/obj/item/clothing/glasses/sunglasses = 2,
		/obj/item/storage/fancy/donut_box = 2,
	)
	premium = list(
		/obj/item/storage/belt/security/webbing = 5,
		/obj/item/storage/belt/security/webbing/peacekeeper = 5,
		/obj/item/coin/antagtoken = 1,
		/obj/item/clothing/head/helmet/blueshirt = 3,
		/obj/item/clothing/suit/armor/vest/blueshirt = 3,
		/obj/item/grenade/stingbang = 5,
		/obj/item/watertank/pepperspray = 2,
		/obj/item/storage/belt/holster/energy = 4,
		/obj/item/storage/box/holobadge = 1,
	)

/obj/item/vending_refill/security
	machine_name = "武库维和装备站"

/obj/machinery/vending/wardrobe/sec_wardrobe
	name = "\improper 维和服装站"
	desc = "一台自动贩卖机，里面装有洛普兰的 \"维和者\" 安保套件，包括标准化制服和一般装备."
	icon = 'modular_skyrat/modules/sec_haul/icons/vending/vending.dmi'
	light_mask = "sec-light-mask"
	icon_state = "peace"
	product_ads = "以时尚之姿痛击罪犯!;红衣掩血迹!;你有权追求时尚!;现在你可以成为你一直想成为的时尚警察了!"
	vend_reply = "Good luck, Peacekeeper!"
	products = list(/obj/item/clothing/suit/hooded/wintercoat/security = 5,
					/obj/item/clothing/suit/toggle/jacket/sec = 5,
					/obj/item/clothing/suit/armor/vest/peacekeeper/brit = 5,
					/obj/item/clothing/neck/security_cape = 5,
					/obj/item/clothing/neck/security_cape/armplate = 5,
					/obj/item/storage/backpack/security = 5,
					/obj/item/storage/backpack/satchel/sec = 5,
					/obj/item/storage/backpack/duffelbag/sec = 5,
					/obj/item/storage/backpack/duffelbag/sec = 5,
					/obj/item/clothing/under/rank/security/officer = 10,
					/obj/item/clothing/under/rank/security/officer/skirt = 10,
					/obj/item/clothing/under/rank/security/peacekeeper/skirt = 10,
					/obj/item/clothing/under/rank/security/peacekeeper/shortskirt = 10,
					/obj/item/clothing/under/rank/security/peacekeeper/miniskirt = 10,
					/obj/item/clothing/under/rank/security/peacekeeper/jumpsuit = 10,
					/obj/item/clothing/under/rank/security/peacekeeper = 10,
					/obj/item/clothing/under/rank/security/skyrat/utility = 3,
					/obj/item/clothing/shoes/jackboots/sec = 10,
					/obj/item/clothing/head/security_garrison = 10,
					/obj/item/clothing/head/security_cap = 10,
					/obj/item/clothing/head/beret/sec/peacekeeper = 5,
					/obj/item/clothing/head/helmet/sec/sol = 5,
					/obj/item/clothing/head/hats/warden/police/patrol = 5,
					/obj/item/clothing/head/costume/ushanka/sec = 10,
					/obj/item/clothing/gloves/color/black/security = 10,
					)
	premium = list( /obj/item/clothing/under/rank/security/officer/formal = 3,
					/obj/item/clothing/suit/jacket/officer/blue = 3,
					/obj/item/clothing/head/beret/sec/navyofficer = 3)
	payment_department = ACCOUNT_SEC
	light_color = COLOR_MODERATE_BLUE

/obj/item/vending_refill/wardrobe/sec_wardrobe
	machine_name = "维和服装站"

//List for the old one, for when its mapped in; curates it nicely, adds /redsec to the items, and also prevents some conflicts with the above vendor
/obj/machinery/vending/wardrobe/sec_wardrobe/red
	name = "\improper 安保衣铺"
	desc = "出售安保服装的自动贩卖机."
	product_ads = "以时尚之姿痛击罪犯!;红衣掩血迹!;你有权追求时尚!;现在你可以成为你一直想成为的时尚警察了!"
	vend_reply = "感谢使用安保衣铺!"
	icon = 'icons/obj/machines/vending.dmi'
	icon_state = "secdrobe"
	products = list(/obj/item/clothing/suit/hooded/wintercoat/security/redsec = 3,
					/obj/item/storage/backpack/security/redsec = 3,
					/obj/item/storage/backpack/satchel/sec/redsec = 3,
					/obj/item/storage/backpack/duffelbag/sec/redsec = 3,
					/obj/item/clothing/under/rank/security/officer/redsec = 3,
					/obj/item/clothing/shoes/jackboots = 3,
					/obj/item/clothing/head/beret/sec = 3,
					/obj/item/clothing/head/soft/sec = 3,
					/obj/item/clothing/mask/bandana/red = 3,
					/obj/item/clothing/gloves/color/black = 3,
					/obj/item/clothing/under/rank/security/officer/skirt = 3,
					/obj/item/clothing/under/rank/security/skyrat/utility/redsec = 3,
					/obj/item/clothing/suit/toggle/jacket/sec/old = 3,
					)
	premium = list( /obj/item/clothing/under/rank/security/officer/formal = 5,
					/obj/item/clothing/suit/jacket/officer/tan = 5,
					/obj/item/clothing/head/beret/sec/navyofficer = 5)
