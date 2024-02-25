// .45 (M1911 & C20r)

/obj/projectile/bullet/c45
	name = ".45子弹"
	damage = 30
	wound_bonus = -10
	wound_falloff_tile = -10

/obj/projectile/bullet/c45/ap
	name = ".45穿甲弹"
	armour_penetration = 50

/obj/projectile/bullet/c45/hp
	name = ".45空尖弹"
	damage = 50
	weak_against_armour = TRUE

/obj/projectile/bullet/incendiary/c45
	name = ".45燃烧弹"
	damage = 15
	fire_stacks = 2

// 4.6x30mm (Autorifles)

/obj/projectile/bullet/c46x30mm
	name = "4.6x30mm子弹"
	damage = 20
	wound_bonus = -5
	bare_wound_bonus = 5
	embed_falloff_tile = -4

/obj/projectile/bullet/c46x30mm/ap
	name = "4.6x30mm穿甲弹"
	damage = 15
	armour_penetration = 40
	embedding = null

/obj/projectile/bullet/incendiary/c46x30mm
	name = "4.6x30mm燃烧弹"
	damage = 10
	fire_stacks = 1
