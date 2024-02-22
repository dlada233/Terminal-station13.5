// 7mm (SAW)

/obj/item/ammo_casing/m7mm
	name = "7mm子弹"
	desc = "一颗7mm子弹."
	icon_state = "762-casing"
	caliber = CALIBER_A7MM
	projectile_type = /obj/projectile/bullet/a7mm

/obj/item/ammo_casing/m7mm/ap
	name = "7mm穿甲弹"
	desc = "一颗7mm穿甲弹，尖头硬芯的设计让其能穿透装甲."
	projectile_type = /obj/projectile/bullet/a7mm/ap

/obj/item/ammo_casing/m7mm/hollow
	name = "7mm空尖弹"
	desc = "一颗7mm空尖弹，旨在对非装甲目标造成更大的伤害."
	projectile_type = /obj/projectile/bullet/a7mm/hp

/obj/item/ammo_casing/m7mm/incen
	name = "7mm燃烧弹"
	desc = "一颗7mm燃烧弹，子弹顶部装有化学物质胶囊，当命中时会与大气反应并产生火球吞没目标."
	projectile_type = /obj/projectile/bullet/incendiary/a7mm

/obj/item/ammo_casing/m7mm/match
	name = "7mm竞赛弹"
	desc = "一颗7mm竞赛弹，是在非常严格的公差范围内制造出来的，你可以使用它来玩一些花式射击."
	projectile_type = /obj/projectile/bullet/a7mm/match

/obj/item/ammo_casing/m7mm/bouncy
	name = "7mm橡胶弹"
	desc = "一颗7mm橡胶弹，有着灾难性的制造标准，在走廊上喷射它将引起众怒."
	projectile_type = /obj/projectile/bullet/a7mm/bouncy
