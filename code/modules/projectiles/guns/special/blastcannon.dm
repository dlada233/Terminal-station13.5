/// How much to scale the explosion ranges for blastcannon shots.
#define BLASTCANNON_RANGE_EXP (1 / GLOB.DYN_EX_SCALE)
/// How much to scale the explosion ranges for blastcannon shots.
#define BLASTCANNON_RANGE_SCALE PI


/**
 * A gun that consumes a TTV to shoot an projectile with equivalent power.
 *
 * It's basically an immovable rod launcher.
 */
/obj/item/gun/blastcannon
	name = "爆裂加农炮"
	desc = "令人震惊的便携武器，用于将炸弹的爆炸能量集中到一个狭窄的爆破波中，同时又便携到可以装进包里."
	icon = 'icons/obj/weapons/guns/wide_guns.dmi'
	icon_state = "blastcannon_empty"
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	inhand_x_dimension = 64
	base_pixel_x = -2
	pixel_x = -2
	inhand_icon_state = "blastcannon_empty"
	base_icon_state = "blastcannon"
	w_class = WEIGHT_CLASS_NORMAL
	force = 10
	fire_sound = 'sound/weapons/blastcannon.ogg'
	item_flags = NONE
	clumsy_check = FALSE
	randomspread = FALSE

	// Firing data.
	/// The person who opened the valve on the TTV loaded into this.
	var/datum/weakref/cached_firer
	/// The target from the last click.
	var/datum/weakref/cached_target
	/// The modifiers from the last click.
	var/cached_modifiers

	// Explosion data:
	/// The TTV this contains that will be used to create the projectile
	var/obj/item/transfer_valve/bomb

	// For debugging/badminry
	/// Whether you can fire this without a bomb.
	var/bombcheck = TRUE
	/// The range this defaults to without a bomb for debugging and badminry
	var/debug_power = 0


/obj/item/gun/blastcannon/Initialize(mapload)
	. = ..()
	if(!pin)
		pin = new
	RegisterSignal(src, COMSIG_ATOM_INTERNAL_EXPLOSION, PROC_REF(channel_blastwave))
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/gun/blastcannon/Destroy()
	if(bomb)
		QDEL_NULL(bomb)
	UnregisterSignal(src, COMSIG_ATOM_INTERNAL_EXPLOSION)
	cached_firer = null
	cached_target = null
	return ..()

/obj/item/gun/blastcannon/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == bomb)
		bomb = null
		update_appearance()

/obj/item/gun/blastcannon/assume_air(datum/gas_mixture/giver)
	qdel(giver)
	return null // Required to make the TTV not vent gas directly into the firer.

/obj/item/gun/blastcannon/examine(mob/user)
	. = ..()
	if(bomb)
		. += span_notice("一个炸弹已经装进去了.")

/obj/item/gun/blastcannon/attack_self(mob/user)
	if(bomb)
		bomb.forceMove(user.loc)
		user.put_in_hands(bomb)
		user.visible_message(span_warning("[user]从[src]拆出[bomb]."))
		bomb = null
	update_appearance()
	return ..()

/obj/item/gun/blastcannon/update_icon_state()
	icon_state = "[base_icon_state]_[bomb ? "loaded" : "empty"]"
	inhand_icon_state = icon_state
	return ..()

/obj/item/gun/blastcannon/attackby(obj/item/transfer_valve/bomb_to_attach, mob/user)
	if(!istype(bomb_to_attach))
		return ..()

	if(bomb)
		to_chat(user, span_warning("[bomb]已经连接到[src]!"))
		return
	if(!bomb_to_attach.ready())
		to_chat(user, span_warning("不完整的炸弹有什么用?"))
		return FALSE
	if(!user.transferItemToLoc(bomb_to_attach, src))
		to_chat(user, span_warning("[bomb_to_attach]好像粘在你手上了!"))
		return FALSE

	user.visible_message(span_warning("[user]连接[bomb_to_attach]到[src]!"))
	bomb = bomb_to_attach
	update_appearance()
	return TRUE

/obj/item/gun/blastcannon/afterattack(atom/target, mob/user, flag, params)
	. |= AFTERATTACK_PROCESSED_ITEM

	if((!bomb && bombcheck) || !target || (get_dist(get_turf(target), get_turf(user)) <= 2))
		return ..()

	cached_target = WEAKREF(target)
	cached_modifiers = params
	if(bomb?.valve_open)
		user.visible_message(
			span_danger("[user]用[src]指向[target]!"),
			span_danger("你用[src]指向[target]!")
		)
		return

	cached_firer = WEAKREF(user)
	if(!bomb)
		fire_debug(target, user, flag, params)
		return

	playsound(src, dry_fire_sound, 30, TRUE) // *click
	user.visible_message(
		span_danger("[user]激活[src]的[bomb]，并将枪口指向了[target]!"),
		span_danger("你激活[src]的[bomb]，并将枪口指向了[target]!")
	)
	var/turf/current_turf = get_turf(src)
	var/turf/target_turf = get_turf(target)
	message_admins("爆裂加农炮转移阀被[ADMIN_LOOKUPFLW(user)]在[ADMIN_VERBOSEJMP(current_turf)]打开，并瞄向了[ADMIN_VERBOSEJMP(target_turf)] (target).")
	user.log_message("打开了爆裂加农炮转移阀被[AREACOORD(current_turf)]并瞄向了[AREACOORD(target_turf)] (target).", LOG_GAME)
	bomb.toggle_valve()
	update_appearance()
	return


/**
 * Channels an internal explosion into a blastwave projectile.
 *
 * Arguments:
 * - [blastwave_data][/list]: A list containing all of the data for the blastwave.
 */
/obj/item/gun/blastcannon/proc/channel_blastwave(atom/source, list/arguments)
	SIGNAL_HANDLER
	. = COMSIG_CANCEL_EXPLOSION

	var/heavy = (arguments[EXARG_KEY_DEV_RANGE]**BLASTCANNON_RANGE_EXP) * BLASTCANNON_RANGE_SCALE
	var/medium = (arguments[EXARG_KEY_HEAVY_RANGE]**BLASTCANNON_RANGE_EXP) * BLASTCANNON_RANGE_SCALE
	var/light = (arguments[EXARG_KEY_LIGHT_RANGE]**BLASTCANNON_RANGE_EXP) * BLASTCANNON_RANGE_SCALE
	var/range = max(heavy, medium, light, 0)
	if(!range)
		visible_message(span_warning("[src]发出了\"砰\"的一声."))
		return

	if(!ismob(loc))
		INVOKE_ASYNC(src, PROC_REF(fire_dropped), heavy, medium, light)
		return

	var/mob/holding = loc
	var/target = cached_target?.resolve()
	if(target && (holding.get_active_held_item() == src) && cached_firer && (holding == cached_firer.resolve()))
		INVOKE_ASYNC(src, PROC_REF(fire_intentionally), target, holding, heavy, medium, light, cached_modifiers)
	else
		INVOKE_ASYNC(src, PROC_REF(fire_accidentally), holding, heavy, medium, light)
	return

/**
 * Prepares and fires a blastwave.
 *
 * Arguments:
 * - [target][/atom]: The thing that the blastwave is being fired at.
 * - heavy: The devastation range of the blastwave.
 * - medium: The heavy impact range of the blastwave.
 * - light: The light impact range of the blastwave.
 * - modifiers: Modifiers as a string used while firing this.
 * - spread: How inaccurate the blastwave is.
 */
/obj/item/gun/blastcannon/proc/fire_blastwave(atom/target, heavy, medium, light, modifiers, spread = 0)
	var/turf/start_turf = get_turf(src)

	var/cap_multiplier = SSmapping.level_trait(start_turf.z, ZTRAIT_BOMBCAP_MULTIPLIER)
	if(isnull(cap_multiplier))
		cap_multiplier = 1
	var/capped_heavy = min(GLOB.MAX_EX_DEVESTATION_RANGE * cap_multiplier, heavy)
	var/capped_medium = min(GLOB.MAX_EX_HEAVY_RANGE * cap_multiplier, medium)
	SSexplosions.shake_the_room(start_turf, max(heavy, medium, light, 0), (capped_heavy * 15) + (capped_medium * 20), capped_heavy, capped_medium)

	var/obj/projectile/blastwave/blastwave = new(loc, heavy, medium, light)
	blastwave.preparePixelProjectile(target, start_turf, params2list(modifiers), spread)
	blastwave.fire()
	cached_firer = null
	cached_target = null
	cached_modifiers = null
	return


/**
 * Handles firing the blastcannon intentionally at a specific target.
 *
 * Arguments:
 * - [firer][/mob]: The mob who is firing this weapon.
 * - [target][/atom]: The target we are firing the
 * - heavy: The devastation range of the blastwave.
 * - medium: The heavy impact range of the blastwave.
 * - light: The light impact range of the blastwave.
 * - modifiers: The modifier string to use when preparing the blastwave.
 */
/obj/item/gun/blastcannon/proc/fire_intentionally(atom/target, mob/firer, heavy, medium, light, modifiers)
	firer.visible_message(
		span_danger("[firer]向[target]释放出爆炸波!"),
		span_danger("你向[target]释放出爆炸波!")
	)
	var/turf/start_turf = get_turf(src)
	var/turf/target_turf = get_turf(target)
	message_admins("爆炸波 fired from [ADMIN_VERBOSEJMP(start_turf)] at [ADMIN_VERBOSEJMP(target_turf)] ([target]) by [ADMIN_LOOKUPFLW(firer)] with power [heavy]/[medium]/[light].")
	firer.log_message("fired a 爆炸波 from [AREACOORD(start_turf)] at [AREACOORD(target_turf)] ([target]) with power [heavy]/[medium]/[light].", LOG_GAME)
	firer.log_message("fired a 爆炸波 from [AREACOORD(start_turf)] at [AREACOORD(target_turf)] ([target]) with power [heavy]/[medium]/[light].", LOG_ATTACK, log_globally = FALSE)
	fire_blastwave(target, heavy, medium, light, modifiers)
	return

/**
 * Handles firing the blastcannon if it was handed to someone else between opening the valve and the bomb exploding.
 *
 * Arguments:
 * - [holder][/mob]: The person who happened to be holding the cannon when it went off.
 * - heavy: The devastation range of the blastwave.
 * - medium: The heavy impact range of the blastwave.
 * - light: The light impact range of the blastwave.
 */
/obj/item/gun/blastcannon/proc/fire_accidentally(mob/holder, heavy, medium, light)
	var/turf/target
	var/holding
	if(holder.is_holding(src))
		target = get_edge_target_turf(holder, holder.dir)
		holding = TRUE
	else
		target = get_edge_target_turf(holder, dir)
		holding = FALSE

	var/mob/firer = cached_firer?.resolve()
	var/turf/start_turf = get_turf(src)
	holder.visible_message(
		span_danger("[src]突然发出巨响[holding ? " 在[holder]的手中" : null]!"),
		span_danger("[src]突然发出巨响[holding ? " 在你的手中" : null]!")
	)
	message_admins("爆炸波 primed by [ADMIN_LOOKUPFLW(firer)] fired from [ADMIN_VERBOSEJMP(start_turf)] roughly towards [ADMIN_VERBOSEJMP(target)] while being held by [ADMIN_LOOKUPFLW(holder)] with power [heavy]/[medium]/[light].")
	log_game("爆炸波 primed by [key_name(firer)] fired from [AREACOORD(start_turf)] roughly towards [AREACOORD(target)] while being held by [key_name(holder)] with power [heavy]/[medium]/[light].")
	return fire_blastwave(target, heavy, medium, light, null, (90 * (rand() - 0.5))) // +- anywhere between 0 and 45 degrees

/**
 * Handles firing the blastcannon if it was dropped on the ground or shoved into a backpack.
 *
 * Arguments:
 * - heavy: The devastation range of the blastwave.
 * - medium: The heavy impact range of the blastwave.
 * - light: The light impact range of the blastwave.
 */
/obj/item/gun/blastcannon/proc/fire_dropped(heavy, medium, light)
	src.visible_message("<span class='danger'>[src]突然发出巨响!")
	var/turf/target = get_edge_target_turf(src, dir)
	var/mob/firer = cached_firer.resolve()
	var/turf/start_turf = get_turf(src)
	message_admins("爆炸波 primed by [ADMIN_LOOKUPFLW(firer)] fired from [ADMIN_VERBOSEJMP(start_turf)] roughly towards [ADMIN_VERBOSEJMP(target)] at [ADMIN_VERBOSEJMP(loc)] ([loc]) with power [heavy]/[medium]/[light].")
	log_game("爆炸波 primed by [key_name(firer)] fired from [AREACOORD(start_turf)] roughly towards [AREACOORD(target)] at [AREACOORD(loc)] ([loc]) with power [heavy]/[medium]/[light].")
	return fire_blastwave(target, heavy, medium, light, null, 360 * rand())

/**
 * Handles firing the blastcannon with debug power.
 *
 * Arguments:
 * - [target][/atom]: The thing the blastcannon is being fired at.
 * - [user][/mob]: The person firing the blastcannon.
 * - modifiers: A string containing click data.
 */
/obj/item/gun/blastcannon/proc/fire_debug(atom/target, mob/user, modifiers)
	fire_intentionally(target, user, debug_power * 0.25, debug_power * 0.5, debug_power, modifiers)
	return


/// The projectile used by the blastcannon
/obj/projectile/blastwave
	name = "爆炸波"
	icon_state = "blastwave"
	damage = 0
	armor_flag = BOMB // Doesn't actually have any functional purpose. But it makes sense.
	movement_type = FLYING
	projectile_phasing = ALL // just blows up the turfs lmao
	phasing_ignore_direct_target = TRUE // If we don't do this the blastcannon shot can be blocked by random items.
	/// The maximum distance this will inflict [EXPLODE_DEVASTATE]
	var/heavy_ex_range = 0
	/// The maximum distance this will inflict [EXPLODE_HEAVY]
	var/medium_ex_range = 0
	/// The maximum distance this will inflict [EXPLODE_LIGHT]
	var/light_ex_range = 0
	/// Whether or not to care about the explosion block of the things we are passing through.
	var/reactionary

/obj/projectile/blastwave/Initialize(mapload, heavy_ex_range, medium_ex_range, light_ex_range, reactionary = CONFIG_GET(flag/reactionary_explosions))
	range = max(heavy_ex_range, medium_ex_range, light_ex_range, 0)
	src.heavy_ex_range = heavy_ex_range
	src.medium_ex_range = medium_ex_range
	src.light_ex_range = light_ex_range
	src.reactionary = reactionary
	return ..()

// Though the projectile itself is not damaging its effects are
/obj/projectile/blastwave/is_hostile_projectile()
	return TRUE

/obj/projectile/blastwave/Range()
	. = ..()
	if(QDELETED(src))
		return

	var/decrement = 1
	var/atom/location = loc
	if (reactionary)
		decrement += location.explosive_resistance

	range = max(range - decrement + 1, 0) // Already decremented by 1 in the parent. Exists so that if we pass through something with negative block it extends the range.
	heavy_ex_range = max(heavy_ex_range - decrement, 0)
	medium_ex_range = max(medium_ex_range - decrement, 0)
	light_ex_range = max(light_ex_range - decrement, 0)

	if (heavy_ex_range)
		SSexplosions.highturf += location
	else if(medium_ex_range)
		SSexplosions.medturf += location
	else if(light_ex_range)
		SSexplosions.lowturf += location
	else
		qdel(src)
		return

/obj/projectile/blastwave/ex_act()
	return FALSE

#undef BLASTCANNON_RANGE_EXP
#undef BLASTCANNON_RANGE_SCALE
