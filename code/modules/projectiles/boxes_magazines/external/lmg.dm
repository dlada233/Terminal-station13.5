/obj/item/ammo_box/magazine/m7mm
	name = "弹药盒 (7mm)"
	icon_state = "a7mm-50"
	ammo_type = /obj/item/ammo_casing/m7mm
	caliber = CALIBER_A7MM
	max_ammo = 50

/obj/item/ammo_box/magazine/m7mm/hollow
	name = "弹药盒 (7mm空尖弹)"
	ammo_type = /obj/item/ammo_casing/m7mm/hollow

/obj/item/ammo_box/magazine/m7mm/ap
	name = "弹药盒 (7mm穿甲弹)"
	ammo_type = /obj/item/ammo_casing/m7mm/ap

/obj/item/ammo_box/magazine/m7mm/incen
	name = "弹药盒 (7mm燃烧弹)"
	ammo_type = /obj/item/ammo_casing/m7mm/incen

/obj/item/ammo_box/magazine/m7mm/match
	name = "弹药盒 (7mm竞赛弹)"
	ammo_type = /obj/item/ammo_casing/m7mm/match

/obj/item/ammo_box/magazine/m7mm/bouncy
	name = "弹药盒 (7mm橡胶弹)"
	ammo_type = /obj/item/ammo_casing/m7mm/bouncy

/obj/item/ammo_box/magazine/m7mm/bouncy/hicap
	name = "高容量弹药盒 (7mm橡胶弹)"
	max_ammo = 150

/obj/item/ammo_box/magazine/m7mm/update_icon_state()
	. = ..()
	icon_state = "a7mm-[min(round(ammo_count(), 10), 50)]" //Min is used to prevent high capacity magazines from attempting to get sprites with larger capacities
