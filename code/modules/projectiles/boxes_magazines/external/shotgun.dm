/obj/item/ammo_box/magazine/m12g
	name = "霰弹弹匣(12g鹿弹)"
	desc = "A drum magazine."
	icon_state = "m12gb"
	base_icon_state = "m12gb"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	caliber = CALIBER_SHOTGUN
	max_ammo = 8
	casing_phrasing = "shell"

/obj/item/ammo_box/magazine/m12g/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[CEILING(ammo_count(FALSE)/8, 1)*8]"

/obj/item/ammo_box/magazine/m12g/stun
	name = "霰弹弹匣(12g泰瑟弹)"
	base_icon_state = "m12gs"
	ammo_type = /obj/item/ammo_casing/shotgun/stunslug

/obj/item/ammo_box/magazine/m12g/slug
	name = "霰弹弹匣(12g霰弹)"
	base_icon_state = "m12gsl"
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_box/magazine/m12g/dragon
	name = "霰弹弹匣(12g龙息弹)"
	base_icon_state = "m12gf"
	ammo_type = /obj/item/ammo_casing/shotgun/dragonsbreath

/obj/item/ammo_box/magazine/m12g/bioterror
	name = "霰弹弹匣(12g生化弹)"
	base_icon_state = "m12gt"
	ammo_type = /obj/item/ammo_casing/shotgun/dart/bioterror

/obj/item/ammo_box/magazine/m12g/meteor
	name = "霰弹弹匣(12g流星弹)"
	base_icon_state = "m12gbc"
	ammo_type = /obj/item/ammo_casing/shotgun/meteorslug
