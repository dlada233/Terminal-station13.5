/obj/item/ammo_casing/energy
	name = "能量武器透镜"
	desc = "枪中使光能发射的部分."
	caliber = ENERGY
	projectile_type = /obj/projectile/energy
	slot_flags = null
	var/e_cost = LASER_SHOTS(10, STANDARD_CELL_CHARGE) //The amount of energy a cell needs to expend to create this shot.
	var/select_name = CALIBER_ENERGY
	fire_sound = 'sound/weapons/laser.ogg'
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/red
	var/select_color = FALSE //SKYRAT EDIT ADDITION - This is the color that shows up when selecting an ammo type. Disabled by default
