/obj/machinery/vending/games
	name = "\improper 好快活"
	desc = "出售一些东西，一些船长和人事部长可能不乐意看到你在工作时摆弄的东西."
	product_ads = "逃进快乐的世界!;小赌怡情!;终结你的友情!;主动出击!;精灵与矮人!;偏执的电脑!;完全不是撒旦!;快乐永不结束!"
	icon_state = "games"
	panel_type = "panel4"
	product_categories = list(
		list(
			"name" = "卡牌",
			"icon" = "diamond",
			"products" = list(
				/obj/item/toy/cards/deck = 5,
				/obj/item/toy/cards/deck/blank = 3,
				/obj/item/toy/cards/deck/blank/black = 3,
				/obj/item/toy/cards/deck/cas = 3,
				/obj/item/toy/cards/deck/cas/black = 3,
				/obj/item/toy/cards/deck/kotahi = 3,
				/obj/item/toy/cards/deck/tarot = 3,
				/obj/item/toy/cards/deck/wizoff = 3,
			),
		),
		list(
			"name" = "玩具",
			"icon" = "hat-wizard",
			"products" = list(
				/obj/item/toy/captainsaid = 1,
				/obj/item/toy/intento = 3,
				/obj/item/storage/box/tail_pin = 1,
			),
		),
		list(
			"name" = "美术",
			"icon" = "palette",
			"products" = list(
				/obj/item/storage/crayons = 2,
				/obj/item/chisel = 3,
				/obj/item/paint_palette = 3,
				/obj/item/canvas/nineteen_nineteen = 5,
				/obj/item/canvas/twentythree_nineteen = 5,
				/obj/item/canvas/twentythree_twentythree = 5,
				/obj/item/canvas/twentyfour_twentyfour = 5,
				/obj/item/canvas/thirtysix_twentyfour = 3,
				/obj/item/canvas/fortyfive_twentyseven = 3,
				/obj/item/wallframe/painting/large = 5,
				/obj/item/stack/pipe_cleaner_coil/random = 10,
			),
		),
		list(
			"name" = "技能芯片",
			"icon" = "floppy-disk",
			"products" = list(
				/obj/item/skillchip/appraiser = 2,
				/obj/item/skillchip/basketweaving = 2,
				/obj/item/skillchip/bonsai = 2,
				/obj/item/skillchip/intj = 2,
				/obj/item/skillchip/light_remover = 2,
				/obj/item/skillchip/master_angler = 2,
				/obj/item/skillchip/sabrage = 2,
				/obj/item/skillchip/useless_adapter = 5,
				/obj/item/skillchip/wine_taster = 2,
			),
		),
		list(
			"name" = "其他",
			"icon" = "star",
			"products" = list(
				/obj/item/camera = 3,
				/obj/item/camera_film = 5,
				/obj/item/cardpack/resin = 20, //Both card packs have had their count raised to 20 from 10 until card persistance is implimented.
				/obj/item/cardpack/series_one = 20,
				/obj/item/dyespray = 3,
				/obj/item/hourglass = 2,
				/obj/item/instrument/piano_synth/headphones = 4,
				/obj/item/razor = 3,
				/obj/item/storage/card_binder = 10,
				/obj/item/storage/dice = 10,
			),
		),
	)
	contraband = list(
		/obj/item/dice/fudge = 9,
		/obj/item/clothing/shoes/wheelys/skishoes = 4,
		/obj/item/instrument/musicalmoth = 1,
		/obj/item/gun/ballistic/revolver/russian = 1, //the most dangerous game
	)
	premium = list(
		/obj/item/disk/holodisk = 5,
		/obj/item/rcl = 2,
		/obj/item/airlock_painter = 1,
		/obj/item/clothing/shoes/wheelys/rollerskates= 3,
		/obj/item/melee/skateboard/pro = 3,
		/obj/item/melee/skateboard/hoverboard = 1,
	)
	refill_canister = /obj/item/vending_refill/games
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND * 1.25
	payment_department = ACCOUNT_SRV
	light_mask = "games-light-mask"

/obj/item/vending_refill/games
	machine_name = "\improper 好快活"
	icon_state = "refill_games"
