/obj/item/ammo_box/magazine/recharge
	name = "电池包"
	desc = "一种可充电、可拆卸的电池，用作激光步枪的弹匣."
	icon_state = "oldrifle-20"
	base_icon_state = "oldrifle"
	ammo_type = /obj/item/ammo_casing/laser
	caliber = CALIBER_LASER
	max_ammo = 20

/obj/item/ammo_box/magazine/recharge/update_desc()
	. = ..()
	desc = "[initial(desc)] 还剩余[stored_ammo.len]发."

/obj/item/ammo_box/magazine/recharge/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 4)]"

/obj/item/ammo_box/magazine/recharge/attack_self() //No popping out the "bullets"
	return
