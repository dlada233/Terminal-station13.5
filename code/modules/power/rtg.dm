// Radioisotope Thermoelectric Generator (RTG)
// Simple power generator that would replace "magic SMES" on various derelicts.

/obj/machinery/power/rtg
	name = "RTG-放射性同位素热电发电机"
	desc = "一种简单的核动力发电机，用于小型前哨，可以可靠地提供几十年的电力."
	icon = 'icons/obj/machines/engine/other.dmi'
	icon_state = "rtg"
	density = TRUE
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/machine/rtg

	// You can buckle someone to RTG, then open its panel. Fun stuff.
	can_buckle = TRUE
	buckle_lying = 0
	buckle_requires_restraints = TRUE

	var/power_gen = 1000 // Enough to power a single APC. 4000 output with T4 capacitor.

/obj/machinery/power/rtg/Initialize(mapload)
	. = ..()
	connect_to_network()

/obj/machinery/power/rtg/process()
	add_avail(power_to_energy(power_gen))

/obj/machinery/power/rtg/RefreshParts()
	. = ..()
	var/part_level = 0
	for(var/datum/stock_part/stock_part in component_parts)
		part_level += stock_part.tier

	power_gen = initial(power_gen) * part_level

/obj/machinery/power/rtg/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("状态读数: 发电机正生产<b>[power_gen*0.001]</b>kW.")

/obj/machinery/power/rtg/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-open", initial(icon_state), I))
		return
	else if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/power/rtg/advanced
	desc = "先进的RTG能够减缓同位素衰变，增加功率输出，但减少了寿命，它使用等离子体燃料的辐射收集器来进一步提高输出."
	power_gen = 1250 // 2500 on T1, 10000 on T4.
	circuit = /obj/item/circuitboard/machine/rtg/advanced

// Void Core, power source for Abductor ships and bases.
// Provides a lot of power, but tends to explode when mistreated.

/obj/machinery/power/rtg/abductor
	name = "虚空核心"
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "core"
	desc = "一种外星能源，能凭空产生能量."
	circuit = /obj/item/circuitboard/machine/abductor/core
	power_gen = 20000 // 280 000 at T1, 400 000 at T4. Starts at T4.
	can_buckle = FALSE
	pixel_y = 7
	var/going_kaboom = FALSE // Is it about to explode?

/obj/machinery/power/rtg/abductor/proc/overload()
	if(going_kaboom)
		return
	going_kaboom = TRUE
	visible_message(span_danger("[src]开始失去稳定，放出一阵火花!"),\
		span_hear("你听到一声巨大的电裂声!"))
	playsound(src.loc, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
	tesla_zap(source = src, zap_range = 5, power = power_gen * 20)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion), src, 2, 3, 4, null, 8), 10 SECONDS) // Not a normal explosion.

/obj/machinery/power/rtg/abductor/bullet_act(obj/projectile/Proj)
	. = ..()
	if(!going_kaboom && istype(Proj) && Proj.damage > 0 && ((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE)))
		log_bomber(Proj.firer, "triggered a", src, "explosion via projectile")
		overload()

/obj/machinery/power/rtg/abductor/blob_act(obj/structure/blob/B)
	overload()

/obj/machinery/power/rtg/abductor/ex_act()
	if(going_kaboom)
		qdel(src)
	else
		overload()

	return TRUE

/obj/machinery/power/rtg/abductor/fire_act(exposed_temperature, exposed_volume)
	overload()

/obj/machinery/power/rtg/abductor/zap_act(power, zap_flags)
	. = ..() //extend the zap
	if(zap_flags & ZAP_MACHINE_EXPLOSIVE)
		overload()

/obj/machinery/power/rtg/debug
	name = "Debug RTG"
	desc = "You really shouldn't be seeing this if you're not a coder or jannie."
	power_gen = 20000
	circuit = null

/obj/machinery/power/rtg/debug/RefreshParts()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/machinery/power/rtg/lavaland
	name = "拉瓦兰RTG"
	desc = "这个装置只有在接触拉瓦兰的有毒气体时才能工作."
	circuit = null
	power_gen = 1500
	anchored = TRUE
	resistance_flags = LAVA_PROOF

/obj/machinery/power/rtg/lavaland/Initialize(mapload)
	. = ..()
	var/turf/our_turf = get_turf(src)
	if(!islava(our_turf))
		power_gen = 0
	if(!is_mining_level(z))
		power_gen = 0

/obj/machinery/power/rtg/lavaland/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	var/turf/our_turf = get_turf(src)
	if(!islava(our_turf))
		power_gen = 0
		return
	if(!is_mining_level(z))
		power_gen = 0
		return
	power_gen = initial(power_gen)

/obj/machinery/power/rtg/old_station
	name = "老式RTG"
	desc = "一个非常古老的RTG，它似乎处于被摧毁的边缘"
	circuit = null
	power_gen = 750
	anchored = TRUE

/obj/machinery/power/rtg/old_station/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-open", initial(icon_state), I))
		to_chat(user,span_warning("你感到它在你的手中破碎!"))
		return
	else if(default_deconstruction_crowbar(I, user = user))
		return
	return ..()

/obj/machinery/power/rtg/old_station/default_deconstruction_crowbar(obj/item/crowbar, ignore_panel, custom_deconstruct, mob/user)
	to_chat(user,span_warning("它开始脱落了!"))
	if(!do_after(user, 3 SECONDS, src))
		return TRUE
	to_chat(user,span_notice("你觉得自己犯了个错误"))
	new /obj/effect/decal/cleanable/ash/large(loc)
	qdel(src)
