/obj/item/ammo_box/magazine/m10mm/rifle
	name = "步枪弹匣(10mm)"
	desc = "装载旧式步枪上的弹匣."
	icon_state = "75-full"
	base_icon_state = "75"
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 10

/obj/item/ammo_box/magazine/m10mm/rifle/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[LAZYLEN(stored_ammo) ? "full" : "empty"]"

/obj/item/ammo_box/magazine/m223
	name = "顶装弹匣 (.223)"
	icon_state = ".223"
	ammo_type = /obj/item/ammo_casing/a223
	caliber = CALIBER_A223
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/m223/phasic
	name = "顶装弹匣 (.223 相位弹)"
	ammo_type = /obj/item/ammo_casing/a223/phasic
