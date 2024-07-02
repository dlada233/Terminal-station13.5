/obj/item/gun/energy/event_horizon
	name = "\improper 事件视界 无存光束步枪"
	desc = "在极度的傲慢和仇恨中，纳米传讯那疯狂的头脑终于得出这场军备竞赛的最终结论，这是一个武器化的黑洞，枪不过是搭载它的平台.\
		只要看到这个罪恶的存在就会明白，对利益的无底线追求已经将所有生命推向了一种可悲的结局————伴随现实本身而毁灭."
	icon = 'icons/obj/weapons/guns/energy.dmi'
	icon_state = "esniper"
	inhand_icon_state = null
	worn_icon_state = null
	fire_sound = 'sound/weapons/beam_sniper.ogg'
	slot_flags = ITEM_SLOT_BACK
	force = 20 //This is maybe the sanest part of this weapon.
	custom_materials = null
	recoil = 2
	ammo_x_offset = 3
	ammo_y_offset = 3
	modifystate = FALSE
	charge_sections = 1
	weapon_weight = WEAPON_HEAVY
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = list(/obj/item/ammo_casing/energy/event_horizon)
	selfcharge = TRUE
	self_charge_amount = STANDARD_ENERGY_GUN_SELF_CHARGE_RATE * 10

/obj/item/gun/energy/event_horizon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 4)

/obj/item/gun/energy/event_horizon/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)

	if(!HAS_TRAIT(user, TRAIT_USER_SCOPED))
		balloon_alert(user, "must be scoped!")
		return

	. = ..()
	message_admins("[ADMIN_LOOKUPFLW(user)] has fired an anti-existential beam at [ADMIN_VERBOSEJMP(user)].")

/obj/item/ammo_casing/energy/event_horizon
	projectile_type = /obj/projectile/beam/event_horizon
	select_name = "doomsday"
	e_cost = LASER_SHOTS(1, STANDARD_CELL_CHARGE)
	fire_sound = 'sound/weapons/beam_sniper.ogg'

/obj/projectile/beam/event_horizon
	name = "anti-existential beam"
	icon = null
	hitsound = 'sound/effects/explosion3.ogg'
	damage = 100 // Does it matter?
	damage_type = BURN
	armor_flag = ENERGY
	range = 150
	jitter = 20 SECONDS
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/tracer/beam_rifle

/obj/projectile/beam/event_horizon/on_hit(atom/target, blocked, pierce_hit)
	. = ..()

	// Where we droppin' boys?
	var/turf/rift_loc = get_turf(target)

	// Spawn our temporary rift, then activate it.
	var/obj/reality_tear/temporary/tear = new(rift_loc)
	tear.start_disaster()
	message_admins("[ADMIN_LOOKUPFLW(target)] has been hit by an anti-existential beam at [ADMIN_VERBOSEJMP(rift_loc)], creating a singularity.")
