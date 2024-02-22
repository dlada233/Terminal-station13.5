/obj/item/ammo_box/magazine/m10mm
	name = "手枪弹匣 (10mm)"
	desc = "一把枪的弹匣."
	icon_state = "9x19p"
	base_icon_state = "9x19p"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = CALIBER_10MM
	max_ammo = 8
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE

/obj/item/ammo_box/magazine/m10mm/fire
	name = "手枪弹匣 (10mm燃烧弹)"
	icon_state = "9x19pI"
	base_icon_state = "9x19pI"
	desc = "10毫米手枪弹匣. 装着可以点燃目标的燃烧弹."
	ammo_type = /obj/item/ammo_casing/c10mm/fire

/obj/item/ammo_box/magazine/m10mm/hp
	name = "手枪弹匣 (10mm HP)"
	icon_state = "9x19pH"
	base_icon_state = "9x19pH"
	desc= "10毫米手枪弹匣. 装着空尖弹，对无甲目标非常有效，对护甲则乏力."
	ammo_type = /obj/item/ammo_casing/c10mm/hp

/obj/item/ammo_box/magazine/m10mm/ap
	name = "手枪弹匣 (10mm AP)"
	icon_state = "9x19pA"
	base_icon_state = "9x19pA"
	desc= "10毫米手枪弹匣. 装着穿甲弹，对护甲具有相当强的穿透力，对无甲目标则乏力."
	ammo_type = /obj/item/ammo_casing/c10mm/ap

/obj/item/ammo_box/magazine/m45
	name = "手枪弹匣 (.45)"
	icon_state = "45-8"
	base_icon_state = "45"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = CALIBER_45
	max_ammo = 8
	multiple_sprites = AMMO_BOX_PER_BULLET
	multiple_sprite_use_base = TRUE

/obj/item/ammo_box/magazine/m9mm
	name = "手枪弹匣 (9mm)"
	icon_state = "9x19p"
	base_icon_state = "9x19p"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 8
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE

/obj/item/ammo_box/magazine/m9mm/fire
	name = "手枪弹匣 (9mm燃烧弹)"
	icon_state = "9x19pI"
	base_icon_state = "9x19pI"
	desc = "9mm手枪弹匣. 装着可以点燃目标的燃烧弹."
	ammo_type = /obj/item/ammo_casing/c9mm/fire

/obj/item/ammo_box/magazine/m9mm/hp
	name = "手枪弹匣 (9mm HP)"
	icon_state = "9x19pH"
	base_icon_state = "9x19pH"
	desc= "9mm手枪弹匣. 装着空尖弹，对无甲目标非常有效，对护甲则乏力."
	ammo_type = /obj/item/ammo_casing/c9mm/hp

/obj/item/ammo_box/magazine/m9mm/ap
	name = "手枪弹匣 (9mm AP)"
	icon_state = "9x19pA"
	base_icon_state = "9x19pA"
	desc= "9mm手枪弹匣. 装着穿甲弹，对护甲具有相当强的穿透力，对无甲目标则乏力."
	ammo_type = /obj/item/ammo_casing/c9mm/ap

/obj/item/ammo_box/magazine/m9mm_aps
	name = "斯捷奇金手枪弹匣 (9mm)"
	icon_state = "9mmaps-15"
	base_icon_state = "9mmaps"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 15

/obj/item/ammo_box/magazine/m9mm_aps/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 5)]"

/obj/item/ammo_box/magazine/m9mm_aps/fire
	name = "斯捷奇金手枪弹匣 (9mm incendiary)"
	ammo_type = /obj/item/ammo_casing/c9mm/fire
	max_ammo = 15

/obj/item/ammo_box/magazine/m9mm_aps/hp
	name = "斯捷奇金手枪弹匣 (9mm HP)"
	ammo_type = /obj/item/ammo_casing/c9mm/hp
	max_ammo = 15

/obj/item/ammo_box/magazine/m9mm_aps/ap
	name = "斯捷奇金手枪弹匣 (9mm AP)"
	ammo_type = /obj/item/ammo_casing/c9mm/ap
	max_ammo = 15

/obj/item/ammo_box/magazine/m50
	name = "手枪弹匣 (.50ae)"
	icon_state = "50ae"
	ammo_type = /obj/item/ammo_casing/a50ae
	caliber = CALIBER_50AE
	max_ammo = 7
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/ammo_box/magazine/r10mm
	name = "皇家之鹰弹匣 (10mm死神弹)"
	icon_state = "r10mm-8"
	base_icon_state = "r10mm"
	ammo_type = /obj/item/ammo_casing/c10mm/reaper
	caliber = CALIBER_10MM
	max_ammo = 8
	multiple_sprites = AMMO_BOX_PER_BULLET
	multiple_sprite_use_base = TRUE
