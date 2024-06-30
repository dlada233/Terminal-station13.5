/datum/market_item/weapon
	category = "武器"
	abstract_path = /datum/market_item/weapon

/datum/market_item/weapon/bear_trap
	name = "捕熊陷阱"
	desc = "用这个经济实惠的陷阱工具让清洁工知道他活在什么样的游戏里."
	item = /obj/item/restraints/legcuffs/beartrap

	price_min = CARGO_CRATE_VALUE * 1.5
	price_max = CARGO_CRATE_VALUE * 2.75
	stock_max = 3
	availability_prob = 40

/datum/market_item/weapon/shotgun_dart
	name = "化学霰弹"
	desc = "这些方便的霰弹可以装载任何化学物质，用霰弹枪射击! \
	带着笑容向你的朋友恶作剧! \
	不建议用于商业用途."
	item = /obj/item/ammo_casing/shotgun/dart

	price_min = CARGO_CRATE_VALUE * 0.05
	price_max = CARGO_CRATE_VALUE * 0.25
	stock_min = 10
	stock_max = 60
	availability_prob = 40

/datum/market_item/weapon/bone_spear
	name = "骨矛"
	desc = "正宗的部落长矛，百分百真大骨！值得任何价格，尤其你是穴居人的话."
	item = /obj/item/spear/bonespear

	price_min = CARGO_CRATE_VALUE
	price_max = CARGO_CRATE_VALUE * 1.5
	stock_max = 3
	availability_prob = 60

/datum/market_item/weapon/chainsaw
	name = "电锯"
	desc = "是伐木工人最好的朋友，非常适合高效地砍伐树木和四肢."
	item = /obj/item/chainsaw

	price_min = CARGO_CRATE_VALUE * 1.75
	price_max = CARGO_CRATE_VALUE * 3
	stock_max = 1
	availability_prob = 35

/datum/market_item/weapon/switchblade
	name = "弹簧刀"
	desc = "Tunnel Snakes rule!"
	item = /obj/item/switchblade

	price_min = CARGO_CRATE_VALUE * 1.25
	price_max = CARGO_CRATE_VALUE * 1.75
	stock_max = 3
	availability_prob = 45

/datum/market_item/weapon/emp_grenade
	name = "EMP 手榴弹"
	desc = "使用这个手榴弹做出一番惊天壮举."
	item = /obj/item/grenade/empgrenade

	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE * 2
	stock_max = 2
	availability_prob = 50

/datum/market_item/weapon/fisher
	name = "SC/FISHER 破坏者手枪"
	desc = "这是一款可以自充电的小型手枪，可以暂时干扰手电筒和安保摄像头，也可以在近战中使用."
	item = /obj/item/gun/energy/recharge/fisher

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	stock_max = 1
	availability_prob = 75

/datum/market_item/weapon/dimensional_bomb
	name = "Multi-Dimensional Bomb Core"
	desc = "A special bomb core, one of a kind, for all your 'terraforming gone wrong' purposes."
	item = /obj/item/bombcore/dimensional
	price_min = CARGO_CRATE_VALUE * 40
	price_max = CARGO_CRATE_VALUE * 50
	stock_max = 1
	availability_prob = 15
