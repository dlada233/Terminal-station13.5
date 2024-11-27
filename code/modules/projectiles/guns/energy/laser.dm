/obj/item/gun/energy/laser
	name = "光能枪"
	desc = "一种以能量为基础的光能枪，它发射出集中的光束，可以穿过玻璃和薄金属."
	icon_state = "laser"
	inhand_icon_state = "laser"
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun)
	ammo_x_offset = 1
	shaded_charge = 1

/obj/item/gun/energy/laser/Initialize(mapload)
	. = ..()
	// Only actual lasguns can be converted
	if(type != /obj/item/gun/energy/laser)
		return
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/xraylaser, /datum/crafting_recipe/hellgun, /datum/crafting_recipe/ioncarbine)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/gun/energy/laser/practice
	name = "练习光能枪"
	desc = "一种基本光能枪的改进版本，这种枪发射弱能量光束，专为打靶练习而设计."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/practice)
	clumsy_check = FALSE
	item_flags = NONE
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/energy/laser/retro
	name ="复古光能枪"
	icon_state = "retro"
	desc = "一种老式的基本光能枪，已经不再被纳米的部队使用. 它的优点在于致命、易维护，使其成为海盗和其他不法分子的最爱."
	ammo_x_offset = 3

/obj/item/gun/energy/laser/carbine
	name = "光能卡宾枪"
	desc = "一种改进型光能枪，射击速度快得多，但每次射击的威力也小得多."
	icon_state = "laser_carbine"
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun/carbine)

/obj/item/gun/energy/laser/carbine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.15 SECONDS, allow_akimbo = FALSE)

/obj/item/gun/energy/laser/carbine/practice
	name = "练习光能卡宾枪"
	desc = "这是光能卡宾枪的改进版本，它发射弱能量光束，专为打靶设计."
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun/carbine/practice)
	clumsy_check = FALSE
	item_flags = NONE
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/energy/laser/retro/old
	name ="光能枪"
	icon_state = "retro"
	desc = "由Nanotrasen公司开发的第一代光能枪，饱受弹药问题的困扰，但它的独特能力是可以在自充能. 你真的希望有人在你被冷冻期间发明了更好的光能枪."
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun/old)
	ammo_x_offset = 3

/obj/item/gun/energy/laser/hellgun
	name ="地狱火光能枪"
	desc = "在NT开始在其光能武器上安装调节器之前的产物，因其造成的可怕烧伤而臭名昭著，也因这种可怕的杀伤力遭到舆论指责并最终停产."
	icon_state = "hellgun"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/hellfire)

/obj/item/gun/energy/laser/captain
	name = "古董光能枪"
	icon_state = "caplaser"
	w_class = WEIGHT_CLASS_NORMAL
	inhand_icon_state = null
	desc = "这是一把古董光能枪，由顶尖工艺雕琢而成，还用了真皮与镀铬装饰，可达到能量峰值也意味着它也拥有不俗的威力.枪身上似乎还刻有将爆炸的十三号空间站图像."
	force = 10
	ammo_x_offset = 3
	selfcharge = 1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1
	ammo_type = list(/obj/item/ammo_casing/energy/laser/hellfire)

/obj/item/gun/energy/laser/captain/scattershot
	name = "先进散射光能枪"
	icon_state = "lasercannon"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "laser"
	desc = "一种工业级重型光能步枪，带有一个改进的光能透镜，可以将射击分散成多个更小的光束，并且还有自充电功能."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter, /obj/item/ammo_casing/energy/laser)
	shaded_charge = FALSE

/obj/item/gun/energy/laser/cyborg
	can_charge = FALSE
	desc = "一种基于能量的光能枪，可以依靠赛博格的内部电池供能，这就是自由的样子?"
	use_cyborg_cell = TRUE

/obj/item/gun/energy/laser/cyborg/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)

/obj/item/gun/energy/laser/scatter
	name = "散射光能枪"
	desc = "配备了散射装置的光能枪."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter, /obj/item/ammo_casing/energy/laser)

/obj/item/gun/energy/laser/scatter/shotty
	name = "光能霰弹枪"
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "cshotgun"
	inhand_icon_state = "shotgun"
	desc = "一把战斗古枪，改装上了内部光能量系统，可以在泰瑟枪和散射镇暴枪两种模式间切换."
	shaded_charge = 0
	pin = /obj/item/firing_pin/implant/mindshield
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter/disabler, /obj/item/ammo_casing/energy/electrode)
	automatic_charge_overlays = FALSE

///Laser Cannon

/obj/item/gun/energy/lasercannon
	name = "加速光能加农炮"
	desc = "一种先进的光能炮，目标越远，伤害越大."
	icon_state = "lasercannon"
	inhand_icon_state = "laser"
	worn_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/laser/accelerator)
	pin = null
	ammo_x_offset = 3

/obj/item/ammo_casing/energy/laser/accelerator
	projectile_type = /obj/projectile/beam/laser/accelerator
	select_name = "accelerator"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/projectile/beam/laser/accelerator
	name = "加速光弹"
	icon_state = "scatterlaser"
	range = 255
	damage = 6

/obj/projectile/beam/laser/accelerator/Range()
	..()
	damage += 7
	transform = 0
	transform *= 1 + (((damage - 6)/7) * 0.2)//20% larger per tile

///X-ray gun

/obj/item/gun/energy/xray
	name = "X射线枪"
	desc = "一种高功率能量枪，能够射出集中的X射线，可穿透多个软硬目标."
	icon_state = "xray"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/xray)
	ammo_x_offset = 3
////////Laser Tag////////////////////

/obj/item/gun/energy/laser/bluetag
	name = "玩具激光枪"
	icon_state = "bluetag"
	desc = "可以发射无害蓝色激光的复古激光枪!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/bluetag)
	item_flags = NONE
	clumsy_check = FALSE
	pin = /obj/item/firing_pin/tag/blue
	ammo_x_offset = 2
	selfcharge = TRUE
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/energy/laser/bluetag/hitscan
	ammo_type = list(/obj/item/ammo_casing/energy/laser/bluetag/hitscan)

/obj/item/gun/energy/laser/redtag
	name = "玩具激光枪"
	icon_state = "redtag"
	desc = "可以发射无害红色激光的复古激光枪!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/redtag)
	item_flags = NONE
	clumsy_check = FALSE
	pin = /obj/item/firing_pin/tag/red
	ammo_x_offset = 2
	selfcharge = TRUE
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/energy/laser/redtag/hitscan
	ammo_type = list(/obj/item/ammo_casing/energy/laser/redtag/hitscan)

// luxury shuttle funnies
/obj/item/firing_pin/paywall/luxury
	multi_payment = TRUE
	owned = TRUE
	payment_amount = 20

/obj/item/gun/energy/laser/luxurypaywall
	name = "奢华光能枪"
	desc = "需要20信用点才能发射的光能枪，用来向穷人射击."
	pin = /obj/item/firing_pin/paywall/luxury
