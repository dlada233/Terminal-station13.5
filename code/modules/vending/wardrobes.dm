GLOBAL_VAR_INIT(roaches_deployed, FALSE)
#define MOTHROACH_START_CHANCE 5
#define MAX_MOTHROACH_AMOUNT 3

/obj/item/vending_refill/wardrobe
	icon_state = "refill_clothes"

/obj/machinery/vending/wardrobe
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND
	payment_department = NO_FREEBIES
	panel_type = "panel19"
	light_mask = "wardrobe-light-mask"

/obj/machinery/vending/wardrobe/Initialize(mapload)
	. = ..()
	if(!mapload)
		return
	if(GLOB.roaches_deployed || !is_station_level(z) || !prob(MOTHROACH_START_CHANCE))
		return
	for(var/count in 1 to rand(1, MAX_MOTHROACH_AMOUNT))
		new /mob/living/basic/mothroach(src)
	GLOB.roaches_deployed = TRUE


/obj/machinery/vending/wardrobe/on_dispense(obj/item/clothing/food)
	if(!istype(food))
		return
	for(var/mob/living/basic/mothroach/roach in contents)
		food.take_damage(food.get_integrity() * 0.5)

/obj/machinery/vending/wardrobe/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	for(var/mob/living/basic/mothroach/roach in contents)
		roach.ai_controller.set_blackboard_key(BB_BASIC_MOB_FLEE_TARGET, src) //scatter away!
		roach.forceMove(drop_location())

/obj/machinery/vending/wardrobe/sec_wardrobe
	name = "\improper 安保衣铺"
	desc = "出售安保相关的贩卖机."
	icon_state = "secdrobe"
	product_ads = "以时尚之姿痛击罪犯!;红衣掩血迹!;你有权追求时尚!;现在你可以成为你一直想成为的时尚警察了!"
	vend_reply = "感谢使用安保衣铺!"
	/* SKYRAT EDIT - LISTS OVERRIDDEN IN 'modular_skyrat\modules\sec_haul\code\misc\vending.dm'
	products = list(
		/obj/item/clothing/head/beret/sec = 3,
		/obj/item/clothing/head/soft/sec = 3,
		/obj/item/clothing/mask/bandana/striped/security = 3,
		/obj/item/clothing/under/rank/security/officer = 3,
		/obj/item/clothing/under/rank/security/officer/skirt = 3,
		/obj/item/clothing/under/rank/security/officer/grey = 3,
		/obj/item/clothing/under/pants/slacks = 3,
		/obj/item/clothing/under/rank/security/officer/blueshirt = 3,
		/obj/item/clothing/suit/armor/vest/secjacket = 3,
		/obj/item/clothing/suit/hooded/wintercoat/security = 3,
		/obj/item/clothing/suit/armor/vest = 3,
		/obj/item/clothing/gloves/color/black = 3,
		/obj/item/clothing/shoes/jackboots/sec = 3,
		/obj/item/storage/backpack/security = 3,
		/obj/item/storage/backpack/satchel/sec = 3,
		/obj/item/storage/backpack/duffelbag/sec = 3,
		/obj/item/storage/backpack/messenger/sec = 3,
	)
	premium = list(
		/obj/item/clothing/under/rank/security/officer/formal = 3,
		/obj/item/clothing/suit/jacket/officer/blue = 3,
		/obj/item/clothing/head/beret/sec/navyofficer = 3,
		)
	*/
	refill_canister = /obj/item/vending_refill/wardrobe/sec_wardrobe
	payment_department = ACCOUNT_SEC
	light_color = COLOR_MOSTLY_PURE_RED

/obj/item/vending_refill/wardrobe/sec_wardrobe
	machine_name = "安保衣铺"

/obj/machinery/vending/wardrobe/medi_wardrobe
	name = "\improper 医疗衣铺"
	desc = "向医务人员出售衣物的自动贩卖机."
	icon_state = "medidrobe"
	product_ads = "让血迹看起来更时尚!!"
	vend_reply = "感谢使用医疗衣铺!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 4,
		/obj/item/clothing/head/costume/nursehat = 4,
		/obj/item/clothing/head/beret/medical = 4,
		/obj/item/clothing/head/utility/surgerycap = 4,
		/obj/item/clothing/head/utility/surgerycap/purple = 4,
		/obj/item/clothing/head/utility/surgerycap/green = 4,
		/obj/item/clothing/head/beret/medical/paramedic = 4,
		/obj/item/clothing/head/soft/paramedic = 4,
		/obj/item/clothing/head/utility/head_mirror = 4,
		/obj/item/clothing/mask/bandana/striped/medical = 4,
		/obj/item/clothing/mask/surgical = 4,
		/obj/item/clothing/under/rank/medical/doctor = 4,
		/obj/item/clothing/under/rank/medical/doctor/skirt = 4,
		/obj/item/clothing/under/rank/medical/scrubs/blue = 4,
		/obj/item/clothing/under/rank/medical/scrubs/green = 4,
		/obj/item/clothing/under/rank/medical/scrubs/purple = 4,
		/obj/item/clothing/under/rank/medical/paramedic = 4,
		/obj/item/clothing/under/rank/medical/paramedic/skirt = 4,
		/obj/item/clothing/suit/toggle/labcoat = 4,
		/obj/item/clothing/suit/toggle/labcoat/paramedic = 4,
		/obj/item/clothing/suit/apron/surgical = 4,
		/obj/item/clothing/suit/hooded/wintercoat/medical = 4,
		/obj/item/clothing/suit/hooded/wintercoat/medical/paramedic = 4,
		/obj/item/clothing/shoes/sneakers/white = 4,
		/obj/item/clothing/shoes/sneakers/blue = 4,
		/obj/item/clothing/gloves/latex/nitrile = 4,
		/obj/item/clothing/gloves/latex = 4,
		/obj/item/storage/backpack/duffelbag/med = 4,
		/obj/item/storage/backpack/medic = 4,
		/obj/item/storage/backpack/satchel/med = 4,
		/obj/item/storage/backpack/messenger/med = 4,
		/obj/item/radio/headset/headset_med = 4,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/medi_wardrobe
	payment_department = ACCOUNT_MED

/obj/item/vending_refill/wardrobe/medi_wardrobe
	machine_name = "医疗衣铺"

/obj/machinery/vending/wardrobe/engi_wardrobe
	name = "工程衣铺"
	desc = "出售工业级服装的自动贩卖机."
	icon_state = "engidrobe"
	product_ads = "保证你的脚不受工业事故的伤害!;害怕黄色? 穿上黄色套装!"
	vend_reply = "感谢使用工程衣铺!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 3,
		/obj/item/clothing/head/utility/hardhat = 3,
		/obj/item/clothing/head/utility/hardhat/welding = 3,
		/obj/item/clothing/head/beret/engi = 3,
		/obj/item/clothing/mask/bandana/striped/engineering = 3,
		/obj/item/clothing/under/rank/engineering/engineer = 3,
		/obj/item/clothing/under/rank/engineering/engineer/skirt = 3,
		/obj/item/clothing/under/rank/engineering/engineer/hazard = 3,
		/obj/item/clothing/suit/hazardvest = 3,
		/obj/item/clothing/suit/hooded/wintercoat/engineering = 3,
		/obj/item/clothing/shoes/workboots = 3,
		/obj/item/storage/backpack/industrial = 3,
		/obj/item/storage/backpack/satchel/eng = 3,
		/obj/item/storage/backpack/duffelbag/engineering = 3,
		/obj/item/storage/backpack/messenger/eng = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/engi_wardrobe
	payment_department = ACCOUNT_ENG
	light_color = COLOR_VIVID_YELLOW

/obj/item/vending_refill/wardrobe/engi_wardrobe
	machine_name = "工程衣铺"

/obj/machinery/vending/wardrobe/atmos_wardrobe
	name = "大气衣铺"
	desc = "这台稀有的贩卖机出售大气技术员的服装."
	icon_state = "atmosdrobe"
	product_ads = "来这里得到易燃服装!!!"
	vend_reply = "感谢使用大气衣铺!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 3,
		/obj/item/clothing/under/rank/engineering/atmospheric_technician = 3,
		/obj/item/clothing/under/rank/engineering/atmospheric_technician/skirt = 3,
		/obj/item/clothing/suit/atmos_overalls = 3,
		/obj/item/clothing/suit/hooded/wintercoat/engineering/atmos = 3,
		/obj/item/clothing/shoes/sneakers/black = 3,
		/obj/item/storage/backpack/satchel/eng = 3,
		/obj/item/storage/backpack/industrial = 3,
		/obj/item/storage/backpack/duffelbag/engineering = 3,
		/obj/item/storage/backpack/messenger/eng = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/atmos_wardrobe
	payment_department = ACCOUNT_ENG
	light_color = COLOR_VIVID_YELLOW

/obj/item/vending_refill/wardrobe/atmos_wardrobe
	machine_name = "大气衣铺"

/obj/machinery/vending/wardrobe/cargo_wardrobe
	name = "货仓衣铺"
	desc = "出售货仓人员衣服的贩卖机."
	icon_state = "cargodrobe"
	product_ads = "升级衣装!;舒适短裤，现在就买吧!"
	vend_reply = "感谢使用货仓衣铺!"
	products = list(
		/obj/item/clothing/head/beret/cargo = 3,
		/obj/item/clothing/mask/bandana/striped/cargo = 3,
		/obj/item/clothing/head/soft = 3,
		/obj/item/clothing/under/rank/cargo/tech = 3,
		/obj/item/clothing/under/rank/cargo/tech/skirt = 3,
		/obj/item/clothing/under/rank/cargo/tech/alt = 3,
		/obj/item/clothing/under/rank/cargo/tech/skirt/alt = 3,
		/obj/item/clothing/suit/toggle/cargo_tech = 3,
		/obj/item/clothing/suit/hooded/wintercoat/cargo = 3,
		/obj/item/clothing/gloves/fingerless = 3,
		/obj/item/clothing/shoes/sneakers/black = 3,
		/obj/item/storage/backpack = 3,
		/obj/item/storage/backpack/satchel = 3,
		/obj/item/storage/backpack/satchel/leather = 3,
		/obj/item/storage/backpack/duffelbag = 3,
		/obj/item/storage/backpack/messenger = 3,
		/obj/item/storage/bag/mail = 3,
		/obj/item/radio/headset/headset_cargo = 3,
		/obj/item/clothing/accessory/pocketprotector = 3,
		/obj/item/clothing/head/utility/hardhat/orange = 3,
		/obj/item/clothing/suit/hazardvest = 3,
	)
	premium = list(
		/obj/item/clothing/head/costume/mailman = 1,
		/obj/item/clothing/under/misc/mailman = 1,
		/obj/item/clothing/under/rank/cargo/miner = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/cargo_wardrobe
	payment_department = ACCOUNT_CAR

/obj/item/vending_refill/wardrobe/cargo_wardrobe
	machine_name = "货仓衣铺"

/obj/machinery/vending/wardrobe/robo_wardrobe
	name = "机械衣铺"
	desc = "为机械学家们出售衣服."
	icon_state = "robodrobe"
	product_ads = "设定我为TRUE，定义你自己!;0110001101101100011011110111010001101000011001010111001101101000011001010111001001100101"
	vend_reply = "感谢使用机械衣铺!"
	products = list(
		/obj/item/clothing/glasses/hud/diagnostic = 2,
		/obj/item/clothing/head/soft/black = 2,
		/obj/item/clothing/mask/bandana/skull/black = 2,
		/obj/item/clothing/under/rank/rnd/roboticist = 2,
		/obj/item/clothing/under/rank/rnd/roboticist/skirt = 2,
		/obj/item/clothing/suit/toggle/labcoat/roboticist = 2,
		/obj/item/clothing/suit/hooded/wintercoat/science/robotics = 2,
		/obj/item/clothing/gloves/fingerless = 2,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/storage/backpack/science = 3,
		/obj/item/storage/backpack/satchel/science = 3,
		/obj/item/storage/backpack/duffelbag/science = 3,
		/obj/item/storage/backpack/messenger/science = 3,
		/obj/item/radio/headset/headset_sci = 2,
	)
	contraband = list(
		/obj/item/clothing/under/costume/mech_suit = 2,
		/obj/item/clothing/suit/hooded/techpriest = 2,
		/obj/item/organ/internal/tongue/robot = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/robo_wardrobe
	extra_price = PAYCHECK_COMMAND * 1.2
	payment_department = ACCOUNT_SCI

/obj/item/vending_refill/wardrobe/robo_wardrobe
	machine_name = "机械衣铺"

/obj/machinery/vending/wardrobe/science_wardrobe
	name = "科研衣铺"
	desc = "出售科研人员衣物的简单售货机，由太空古巴人代言."
	icon_state = "scidrobe"
	product_ads = "渴望等离子体烧焦肉体？现在就购买科研服装!;用10%的助剂制成，这样你就不用担心失去你的手臂了!"
	vend_reply = "感谢使用科研衣铺!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 3,
		/obj/item/clothing/head/beret/science = 3,
		/obj/item/clothing/mask/gas = 3,
		/obj/item/clothing/mask/bandana/striped/science = 3,
		/obj/item/clothing/under/rank/rnd/scientist = 3,
		/obj/item/clothing/under/rank/rnd/scientist/skirt = 3,
		/obj/item/clothing/suit/toggle/labcoat/science = 3,
		/obj/item/clothing/suit/hooded/wintercoat/science = 3,
		/obj/item/clothing/gloves/latex = 3,
		/obj/item/clothing/shoes/sneakers/white = 3,
		/obj/item/storage/backpack/science = 3,
		/obj/item/storage/backpack/satchel/science = 3,
		/obj/item/storage/backpack/duffelbag/science = 3,
		/obj/item/storage/backpack/messenger/science = 3,
		/obj/item/radio/headset/headset_sci = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/science_wardrobe
	payment_department = ACCOUNT_SCI
/obj/item/vending_refill/wardrobe/science_wardrobe
	machine_name = "科研衣铺"

/obj/machinery/vending/wardrobe/hydro_wardrobe
	name = "水培衣铺"
	desc = "出售与植物学相关的衣服装备的贩卖机."
	icon_state = "hydrobe"
	product_ads = "喜爱泥土的味道? 购买我们的衣服吧!;在这里购买与你园艺技能相符的衣服!"
	vend_reply = "感谢使用水培衣铺!"
	products = list(
		/obj/item/clothing/accessory/armband/hydro = 3,
		/obj/item/clothing/mask/bandana/striped/botany = 3,
		/obj/item/clothing/under/rank/civilian/hydroponics = 3,
		/obj/item/clothing/under/rank/civilian/hydroponics/skirt = 3,
		/obj/item/clothing/suit/apron = 3,
		/obj/item/clothing/suit/apron/overalls = 3,
		/obj/item/clothing/suit/apron/waders = 3,
		/obj/item/clothing/suit/hooded/wintercoat/hydro = 3,
		/obj/item/storage/backpack/botany = 3,
		/obj/item/storage/backpack/satchel/hyd = 3,
		/obj/item/storage/backpack/duffelbag/hydroponics = 3,
		/obj/item/storage/backpack/messenger/hyd = 3,
		/obj/item/radio/headset/headset_srv = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/hydro_wardrobe
	payment_department = ACCOUNT_SRV
	light_color = LIGHT_COLOR_ELECTRIC_GREEN

/obj/item/vending_refill/wardrobe/hydro_wardrobe
	machine_name = "水培衣铺"

/obj/machinery/vending/wardrobe/curator_wardrobe
	name = "馆长衣铺"
	desc = "存货较少的贩卖机，只卖给馆长和图书管理员."
	icon_state = "curadrobe"
	product_ads = "眼镜装点你的双眸，文学滋养你的灵魂，馆长衣铺应有尽有!; 馆长衣铺系列的精美钢笔，让你的图书馆宾客印象深刻，为之着迷!"
	vend_reply = "感谢使用馆长衣铺!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 2,
		/obj/item/pen = 4,
		/obj/item/pen/red = 2,
		/obj/item/pen/blue = 2,
		/obj/item/pen/fourcolor = 1,
		/obj/item/pen/fountain = 2,
		/obj/item/clothing/glasses/regular = 2,
		/obj/item/clothing/glasses/regular/jamjar = 1,
		/obj/item/clothing/under/rank/civilian/curator = 1,
		/obj/item/clothing/under/rank/civilian/curator/skirt = 1,
		/obj/item/clothing/under/rank/captain/suit = 1,
		/obj/item/clothing/under/rank/captain/suit/skirt = 1,
		/obj/item/clothing/under/rank/civilian/head_of_personnel/suit = 1,
		/obj/item/clothing/under/rank/civilian/head_of_personnel/suit/skirt = 1,
		/obj/item/clothing/suit/toggle/lawyer/greyscale = 1,
		/obj/item/storage/backpack/satchel/explorer = 1,
		/obj/item/storage/backpack/messenger/explorer = 1,
		/obj/item/storage/bag/books = 1,
		/obj/item/radio/headset/headset_srv = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/curator_wardrobe
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/wardrobe/curator_wardrobe
	machine_name = "馆长衣铺"

/obj/machinery/vending/wardrobe/coroner_wardrobe
	name = "停尸房衣铺"
	desc = "虚无主义者的最爱."
	icon_state = "coroner_drobe"
	product_ads = "活着就是美好的一天!;我的白天在你夜晚时开始!;他们竟称这为夕阳产业!;等你死了我们会再见的!"
	vend_reply = "记住 \"买一送一\" 的停尸优惠服务!"
	products = list(
		/obj/item/cautery/cruel = 1,
		/obj/item/clothing/gloves/latex/coroner = 1,
		/obj/item/clothing/head/utility/surgerycap/black = 1,
		/obj/item/clothing/mask/surgical = 1,
		/obj/item/clothing/shoes/sneakers/black = 1,
		/obj/item/clothing/suit/apron/surgical = 1,
		/obj/item/clothing/suit/hooded/wintercoat/medical/coroner = 1,
		/obj/item/clothing/suit/toggle/labcoat/coroner = 1,
		/obj/item/clothing/under/rank/medical/coroner = 1,
		/obj/item/clothing/under/rank/medical/coroner/skirt = 1,
		/obj/item/clothing/under/rank/medical/scrubs/coroner = 1,
		/obj/item/hemostat/cruel = 1,
		/obj/item/radio/headset/headset_srvmed = 2,
		/obj/item/retractor/cruel = 1,
		/obj/item/scalpel/cruel = 1,
		/obj/item/storage/backpack/coroner = 1,
		/obj/item/storage/backpack/duffelbag/coroner = 1,
		/obj/item/storage/backpack/messenger/coroner = 1,
		/obj/item/storage/backpack/satchel/coroner = 1,
		/obj/item/storage/box/bodybags = 3,
		/obj/item/toy/crayon/white = 2,
	)
	contraband = list(
		/obj/item/knife/ritual = 1,
		/obj/item/scythe = 1,
		/obj/item/storage/fancy/pickles_jar = 1,
		/obj/item/table_clock = 1,
	)
	premium = list(
		/obj/item/autopsy_scanner = 1,
		/obj/item/storage/medkit/coroner = 1,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/coroner_wardrobe
	payment_department = ACCOUNT_MED

/obj/item/vending_refill/wardrobe/coroner_wardrobe
	machine_name = "停尸房衣铺"

/obj/machinery/vending/wardrobe/bar_wardrobe
	name = "酒吧衣铺"
	desc = "时尚贩卖机出售最时尚的酒吧服装!"
	icon_state = "bardrobe"
	product_ads = "保证不会被洒出的饮料弄脏!"
	vend_reply = "感谢使用酒吧衣铺!"
	products = list(
		/obj/item/clothing/glasses/sunglasses/reagent = 1,
		/obj/item/clothing/accessory/waistcoat = 2,
		/obj/item/clothing/head/hats/tophat = 2,
		/obj/item/clothing/head/soft/black = 2,
		/obj/item/clothing/neck/petcollar = 1,
		/obj/item/clothing/neck/bowtie = 2,
		/obj/item/clothing/under/costume/buttondown/slacks/service = 2,
		/obj/item/clothing/under/costume/buttondown/skirt/service = 2,
		/obj/item/clothing/under/rank/civilian/purple_bartender = 2,
		/obj/item/clothing/suit/toggle/lawyer/greyscale = 1,
		/obj/item/clothing/suit/armor/vest/alt = 1,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/storage/belt/bandolier = 1,
		/obj/item/storage/bag/money = 2,
		/obj/item/storage/dice/hazard = 1,
		/obj/item/storage/box/beanbag = 1,
		/obj/item/circuitboard/machine/dish_drive = 1,
		/obj/item/reagent_containers/cup/rag = 2,
		/obj/item/radio/headset/headset_srv = 2,
	)
	premium = list(
		/obj/item/storage/box/dishdrive = 1,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/bar_wardrobe
	payment_department = ACCOUNT_MED
	extra_price = PAYCHECK_COMMAND
/obj/item/vending_refill/wardrobe/bar_wardrobe
	machine_name = "酒吧衣铺"

/obj/machinery/vending/wardrobe/chef_wardrobe
	name = "厨房衣铺"
	desc = "不会出售肉类，但会卖厨师相关的衣服"
	icon_state = "chefdrobe"
	product_ads = "我们的衣服保证能保护你不被食物弄脏!"
	vend_reply = "感谢使用厨房衣铺!"
	products = list(
		/obj/item/clothing/accessory/waistcoat = 2,
		/obj/item/clothing/head/soft/mime = 2,
		/obj/item/clothing/head/utility/chefhat = 2,
		/obj/item/clothing/under/costume/buttondown/slacks/service = 2,
		/obj/item/clothing/under/costume/buttondown/skirt/service = 2,
		/obj/item/clothing/under/rank/civilian/cookjorts = 2,
		/obj/item/clothing/under/suit/waiter = 2,
		/obj/item/clothing/suit/apron/chef = 2,
		/obj/item/clothing/suit/toggle/chef = 2,
		/obj/item/clothing/suit/hooded/wintercoat = 2,
		/obj/item/clothing/shoes/cookflops = 2,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/storage/box/mousetraps = 2,
		/obj/item/circuitboard/machine/dish_drive = 1,
		/obj/item/reagent_containers/cup/rag = 2,
		/obj/item/radio/headset/headset_srv = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/chef_wardrobe
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/wardrobe/chef_wardrobe
	machine_name = "厨房衣铺"

/obj/machinery/vending/wardrobe/jani_wardrobe
	name = "清洁衣铺"
	desc = "出售清洁工衣服的贩卖机."
	icon_state = "janidrobe"
	product_ads = "快来拿你的清洁工服装，现在到处都是蜥蜴清洁工的代言!"
	vend_reply = "感谢使用清洁衣铺!"
	products = list(
		/obj/item/clothing/head/soft/purple = 2,
		/obj/item/clothing/mask/bandana/purple = 2,
		/obj/item/clothing/under/rank/civilian/janitor = 2,
		/obj/item/clothing/under/rank/civilian/janitor/skirt = 2,
		/obj/item/clothing/suit/hooded/wintercoat/janitor = 2,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/clothing/gloves/color/black = 2,
		/obj/item/clothing/shoes/galoshes = 2,
		/obj/item/storage/belt/janitor = 2,
		/obj/item/watertank/janitor = 1,
		/obj/item/flashlight = 2,
		/obj/item/pushbroom = 2,
		/obj/item/paint/paint_remover = 2,
		/obj/item/melee/flyswatter = 2,
		/obj/item/clothing/suit/caution = 6,
		/obj/item/holosign_creator = 2,
		/obj/item/lightreplacer = 2,
		/obj/item/soap/nanotrasen = 2,
		/obj/item/storage/bag/trash = 2,
		/obj/item/plunger = 2,
		/obj/item/wirebrush = 2,
		/obj/item/radio/headset/headset_srv = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/jani_wardrobe
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND * 0.8
	payment_department = ACCOUNT_SRV
	light_color = COLOR_STRONG_MAGENTA

/obj/item/vending_refill/wardrobe/jani_wardrobe
	machine_name = "清洁衣铺"

/obj/machinery/vending/wardrobe/law_wardrobe
	name = "律师衣铺"
	desc = "异议! 这个贩卖机能体现出法制...还有律师服."
	icon_state = "lawdrobe"
	product_ads = "异议! 为自己争取正义!"
	vend_reply = "感谢使用律师衣铺!"
	products = list(
		/obj/item/clothing/accessory/lawyers_badge = 2,
		/obj/item/clothing/neck/tie = 3,
		/obj/item/clothing/under/rank/civilian/lawyer/bluesuit = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt = 1,
		/obj/item/clothing/suit/toggle/lawyer = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/purpsuit = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt = 1,
		/obj/item/clothing/suit/toggle/lawyer/purple = 1,
		/obj/item/clothing/under/costume/buttondown/slacks/service = 1,
		/obj/item/clothing/under/costume/buttondown/skirt/service = 1,
		/obj/item/clothing/suit/toggle/lawyer/black = 1,
		/obj/item/clothing/suit/toggle/lawyer/greyscale = 1,
		/obj/item/clothing/under/suit/black = 1,
		/obj/item/clothing/under/suit/black/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/beige = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/beige/skirt = 1,
		/obj/item/clothing/under/suit/black_really = 1,
		/obj/item/clothing/under/suit/black_really/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/blue = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/blue/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/red = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/red/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/black = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/black/skirt = 1,
		/obj/item/clothing/shoes/laceup = 2,
		/obj/item/radio/headset/headset_srv = 2,
		/obj/item/storage/box/evidence = 2,
		/obj/item/fish_feed = 1,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/law_wardrobe
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/wardrobe/law_wardrobe
	machine_name = "律师衣铺"

/obj/machinery/vending/wardrobe/chap_wardrobe
	name = "宗教衣铺"
	desc = "神希望你购买."
	icon_state = "chapdrobe"
	product_ads = "遭遇邪教和亡灵骚扰? 那就来这里穿得像个圣人!;衣服穿给穿衣服的人!"
	vend_reply = "感谢使用宗教衣铺!"
	products = list(
		/obj/item/choice_beacon/holy = 1,
		/obj/item/clothing/accessory/pocketprotector/cosmetology = 1,
		/obj/item/clothing/under/rank/civilian/chaplain = 1,
		/obj/item/clothing/under/rank/civilian/chaplain/skirt = 2,
		/obj/item/clothing/shoes/sneakers/black = 1,
		/obj/item/clothing/suit/chaplainsuit/nun = 1,
		/obj/item/clothing/head/chaplain/nun_hood = 1,
		/obj/item/clothing/suit/chaplainsuit/holidaypriest = 1,
		/obj/item/clothing/suit/hooded/chaplainsuit/monkhabit = 1,
		/obj/item/clothing/head/chaplain/kippah = 3,
		/obj/item/clothing/suit/chaplainsuit/whiterobe = 1,
		/obj/item/clothing/head/chaplain/taqiyah/white = 1,
		/obj/item/clothing/head/chaplain/taqiyah/red = 3,
		/obj/item/clothing/suit/chaplainsuit/monkrobeeast = 1,
		/obj/item/clothing/head/rasta = 1,
		/obj/item/clothing/suit/chaplainsuit/shrinehand = 1,
		/obj/item/storage/backpack/cultpack = 1,
		/obj/item/storage/fancy/candle_box = 2,
		/obj/item/radio/headset/headset_srv = 2,
		/obj/item/clothing/suit/chaplainsuit/habit = 1,
		/obj/item/clothing/head/chaplain/habit_veil = 1,
	)
	contraband = list(
		/obj/item/toy/plush/ratplush = 1,
		/obj/item/toy/plush/narplush = 1,
		/obj/item/clothing/head/chaplain/medievaljewhat = 3,
		/obj/item/clothing/head/chaplain/clownmitre = 1,
		/obj/item/clothing/suit/chaplainsuit/clownpriest = 1,
	)
	premium = list(
		/obj/item/clothing/head/chaplain/bishopmitre = 1,
		/obj/item/clothing/suit/chaplainsuit/bishoprobe = 1,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/chap_wardrobe
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/wardrobe/chap_wardrobe
	machine_name = "宗教衣铺"

/obj/machinery/vending/wardrobe/chem_wardrobe
	name = "化学衣铺"
	desc = "出售化学相关衣物的贩卖机."
	icon_state = "chemdrobe"
	product_ads = "我们的服装防酸能力提高了0.5%! 现在就来购买!"
	vend_reply = "感谢使用化学衣铺!"
	products = list(
		/obj/item/clothing/head/beret/medical = 2,
		/obj/item/clothing/under/rank/medical/chemist = 2,
		/obj/item/clothing/under/rank/medical/chemist/skirt = 2,
		/obj/item/clothing/suit/toggle/labcoat/chemist = 2,
		/obj/item/clothing/suit/hooded/wintercoat/medical/chemistry = 2,
		/obj/item/clothing/gloves/latex = 2,
		/obj/item/clothing/shoes/sneakers/white = 2,
		/obj/item/storage/backpack/chemistry = 2,
		/obj/item/storage/backpack/satchel/chem = 2,
		/obj/item/storage/backpack/duffelbag/chemistry = 2,
		/obj/item/storage/backpack/messenger/chem = 2,
		/obj/item/storage/bag/chemistry = 2,
		/obj/item/ph_booklet = 3,
		/obj/item/radio/headset/headset_med = 2,
	)
	contraband = list(
		/obj/item/reagent_containers/spray/syndicate = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/chem_wardrobe
	payment_department = ACCOUNT_MED

/obj/item/vending_refill/wardrobe/chem_wardrobe
	machine_name = "化学衣铺"

/obj/machinery/vending/wardrobe/gene_wardrobe
	name = "基因衣铺"
	desc = "出售基因学相关衣物的贩卖机."
	icon_state = "genedrobe"
	product_ads = "适合身为疯狂科学家的你!"
	vend_reply = "感谢使用基因衣铺!"
	products = list(
		/obj/item/clothing/under/rank/rnd/geneticist = 2,
		/obj/item/clothing/under/rank/rnd/geneticist/skirt = 2,
		/obj/item/clothing/suit/toggle/labcoat/genetics = 2,
		/obj/item/clothing/suit/hooded/wintercoat/science/genetics = 2,
		/obj/item/clothing/gloves/latex = 2,
		/obj/item/clothing/shoes/sneakers/white = 2,
		/obj/item/storage/backpack/genetics = 2,
		/obj/item/storage/backpack/satchel/gen = 2,
		/obj/item/storage/backpack/duffelbag/genetics = 2,
		/obj/item/storage/backpack/messenger/gen = 2,
		/obj/item/radio/headset/headset_sci = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/gene_wardrobe
	payment_department = ACCOUNT_SCI

/obj/item/vending_refill/wardrobe/gene_wardrobe
	machine_name = "基因衣铺"

/obj/machinery/vending/wardrobe/viro_wardrobe
	name = "病毒衣铺"
	desc = "出售病毒学相关衣物的贩卖机"
	icon_state = "virodrobe"
	product_ads = " 病毒让你不舒服？快升级到消毒服装!"
	vend_reply = "感谢使用病毒衣铺"
	products = list(
		/obj/item/clothing/mask/surgical = 2,
		/obj/item/clothing/under/rank/medical/virologist = 2,
		/obj/item/clothing/under/rank/medical/virologist/skirt = 2,
		/obj/item/clothing/head/beret/medical = 2,
		/obj/item/clothing/shoes/sneakers/white = 2,
		/obj/item/clothing/suit/toggle/labcoat/virologist = 2,
		/obj/item/clothing/suit/hooded/wintercoat/medical/viro = 2,
		/obj/item/clothing/gloves/latex = 2,
		/obj/item/storage/backpack/virology = 2,
		/obj/item/storage/backpack/satchel/vir = 2,
		/obj/item/storage/backpack/duffelbag/virology = 2,
		/obj/item/storage/backpack/messenger/vir = 2,
		/obj/item/radio/headset/headset_med = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/viro_wardrobe
	payment_department = ACCOUNT_MED

/obj/item/vending_refill/wardrobe/viro_wardrobe
	machine_name = "病毒衣铺"

/obj/machinery/vending/wardrobe/det_wardrobe
	name = "\improper 侦探衣铺"
	desc = "能满足你作为侦探的一切需求."
	icon_state = "detdrobe"
	product_ads = "把你聪明的演绎法运用到衣装上!"
	vend_reply = "感谢使用侦探衣铺!"
	products = list(
		/obj/item/clothing/head/fedora/det_hat = 2,
		/obj/item/clothing/under/rank/security/detective = 2,
		/obj/item/clothing/under/rank/security/detective/skirt = 2,
		/obj/item/clothing/suit/jacket/det_suit = 2,
		/obj/item/clothing/suit/jacket/det_suit/brown = 2,
		/obj/item/clothing/shoes/sneakers/brown = 2,
		/obj/item/clothing/gloves/latex = 2,
		/obj/item/clothing/gloves/color/black = 2,
		/obj/item/clothing/accessory/waistcoat = 2,
		/obj/item/clothing/under/rank/security/detective/noir = 2,
		/obj/item/clothing/under/rank/security/detective/noir/skirt = 2,
		/obj/item/clothing/shoes/laceup = 2,
		/obj/item/clothing/head/fedora = 2,
		/obj/item/clothing/suit/jacket/det_suit/dark = 1,
		/obj/item/clothing/suit/jacket/det_suit/noir = 1,
		/obj/item/clothing/neck/tie/disco = 1,
		/obj/item/clothing/under/rank/security/detective/disco = 1,
		/obj/item/clothing/suit/jacket/det_suit/disco = 1,
		/obj/item/clothing/shoes/discoshoes = 1,
		/obj/item/clothing/glasses/regular/kim = 1,
		/obj/item/clothing/under/rank/security/detective/kim = 1,
		/obj/item/clothing/suit/jacket/det_suit/kim = 1,
		/obj/item/clothing/gloves/kim = 1,
		/obj/item/clothing/shoes/kim = 1,
		/obj/item/reagent_containers/cup/glass/flask/det = 2,
		/obj/item/storage/fancy/cigarettes = 5,
		/obj/item/storage/fancy/cigarettes/cigpack_candy = 5,
	)
	premium = list(
		/obj/item/clothing/head/flatcap = 1,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/det_wardrobe
	extra_price = PAYCHECK_COMMAND * 1.75
	payment_department = ACCOUNT_SEC

/obj/item/vending_refill/wardrobe/det_wardrobe
	machine_name = "侦探衣铺"

/obj/machinery/vending/wardrobe/cent_wardrobe
	name = "\improper 中央衣铺"
	desc = "一台独一无二的自动售货机，满足你所有的审美需求!"
	icon_state = "centdrobe"
	product_ads = "让ERT们看看谁是简报室里最靓的崽！"
	vend_reply = "感谢使用中央衣铺!"
	products = list(
		/obj/item/clothing/glasses/sunglasses = 3,
		/obj/item/clothing/head/hats/centcom_cap = 3,
		/obj/item/clothing/head/hats/centhat = 3,
		/obj/item/clothing/head/hats/intern = 3,
		/obj/item/clothing/under/rank/centcom/commander = 3,
		/obj/item/clothing/under/rank/centcom/centcom_skirt = 3,
		/obj/item/clothing/under/rank/centcom/intern = 3,
		/obj/item/clothing/under/rank/centcom/official = 3,
		/obj/item/clothing/under/rank/centcom/officer = 3,
		/obj/item/clothing/under/rank/centcom/officer_skirt = 3,
		/obj/item/clothing/suit/armor/centcom_formal = 3,
		/obj/item/clothing/suit/space/officer = 3,
		/obj/item/clothing/suit/hooded/wintercoat/centcom = 3,
		/obj/item/clothing/shoes/laceup = 3,
		/obj/item/clothing/shoes/jackboots = 3,
		/obj/item/clothing/gloves/combat = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/cent_wardrobe

/obj/item/vending_refill/wardrobe/cent_wardrobe
	machine_name = "中央衣铺"
	light_color = LIGHT_COLOR_ELECTRIC_GREEN

#undef MOTHROACH_START_CHANCE
#undef MAX_MOTHROACH_AMOUNT
