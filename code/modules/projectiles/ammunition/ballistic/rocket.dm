/obj/item/ammo_casing/rocket
	name = "PM-9HE"
	desc = "一枚84毫米高爆火箭弹，只需祈祷并向人群发射."
	caliber = CALIBER_84MM
	icon_state = "srm-8"
	base_icon_state = "srm-8"
	projectile_type = /obj/projectile/bullet/rocket

/obj/item/ammo_casing/rocket/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/rocket/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]"

/obj/item/ammo_casing/rocket/heap
	name = "PM-9HEAP"
	desc = "一枚84毫米高爆通用火箭弹，当你只是想让某物消失时."
	icon_state = "84mm-heap"
	base_icon_state = "84mm-heap"
	projectile_type = /obj/projectile/bullet/rocket/heap

/obj/item/ammo_casing/rocket/weak
	name = "\improper HE 低当量标枪火箭弹"
	desc = "一枚84毫米高爆火箭弹，这一枚威力没那么大."
	icon_state = "low_yield_rocket"
	base_icon_state = "low_yield_rocket"
	projectile_type = /obj/projectile/bullet/rocket/weak

/obj/item/ammo_casing/rocket/reverse
	projectile_type = /obj/projectile/bullet/rocket/reverse

/obj/item/ammo_casing/a75
	desc = "一颗.75子弹."
	caliber = CALIBER_75
	icon_state = "s-casing-live"
	base_icon_state = "s-casing-live"
	projectile_type = /obj/projectile/bullet/gyro

/obj/item/ammo_casing/a75/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/a75/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]"
