/obj/item/ammo_box/magazine/internal/cylinder/rev38
	name = "侦探左轮弹巢"
	ammo_type = /obj/item/ammo_casing/c38
	caliber = CALIBER_38
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/cylinder/rev762
	name = "纳甘左轮弹巢"
	ammo_type = /obj/item/ammo_casing/n762
	caliber = CALIBER_N762
	max_ammo = 7

/obj/item/ammo_box/magazine/internal/cylinder/rus357
	name = "俄制左轮弹巢"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = CALIBER_357
	max_ammo = 6
	multiload = FALSE
	start_empty = TRUE

/obj/item/ammo_box/magazine/internal/cylinder/rus357/Initialize(mapload)
	. = ..()
	for (var/i in 1 to max_ammo - 1)
		stored_ammo += new /obj/item/ammo_casing/a357/spent(src)
	stored_ammo += new /obj/item/ammo_casing/a357(src)
