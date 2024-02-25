// 9mm (Makarov and Stechkin APS)

/obj/projectile/bullet/c9mm
	name = "9mm子弹"
	damage = 30
	embedding = list(embed_chance=15, fall_chance=3, jostle_chance=4, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.4, pain_mult=5, jostle_pain_mult=6, rip_time=10)

/obj/projectile/bullet/c9mm/ap
	name = "9mm穿甲弹"
	damage = 27
	armour_penetration = 40
	embedding = null
	shrapnel_type = null

/obj/projectile/bullet/c9mm/hp
	name = "9mm空尖弹"
	damage = 40
	weak_against_armour = TRUE

/obj/projectile/bullet/incendiary/c9mm
	name = "9mm燃烧弹"
	damage = 15
	fire_stacks = 2

// 10mm

/obj/projectile/bullet/c10mm
	name = "10mm子弹"
	damage = 40

/obj/projectile/bullet/c10mm/ap
	name = "10mm穿甲弹"
	damage = 35
	armour_penetration = 40

/obj/projectile/bullet/c10mm/hp
	name = "10mm空尖弹"
	damage = 50
	weak_against_armour = TRUE

/obj/projectile/bullet/incendiary/c10mm
	name = "10mm燃烧弹"
	damage = 20
	fire_stacks = 3

/obj/projectile/bullet/c10mm/reaper
	name = "10mm死神颗粒"
	damage = 50
	armour_penetration = 40
	tracer_type = /obj/effect/projectile/tracer/sniper
	impact_type = /obj/effect/projectile/impact/sniper
	muzzle_type = /obj/effect/projectile/muzzle/sniper
	hitscan = TRUE
	impact_effect_type = null
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = LIGHT_COLOR_DIM_YELLOW
	muzzle_flash_intensity = 5
	muzzle_flash_range = 1
	muzzle_flash_color_override = LIGHT_COLOR_DIM_YELLOW
	impact_light_intensity = 5
	impact_light_range = 1
	impact_light_color_override = LIGHT_COLOR_DIM_YELLOW
