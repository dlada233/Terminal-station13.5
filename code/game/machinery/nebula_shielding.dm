///Machinery that block nebulas. This type is for convenience, you can set nebula shielding on other objects as well using add_to_nebula_shielding()
/obj/machinery/nebula_shielding
	density = TRUE

	icon = 'icons/obj/machines/nebula_shielding.dmi'
	pixel_x = -16

	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE

	///Strength of the shield we apply
	var/shielding_strength
	///The type of nebula that we shield against
	var/nebula_type
	///How much power we use every time we block the nebula's effects
	var/power_use_per_block = BASE_MACHINE_ACTIVE_CONSUMPTION * 2
	///State we use when actively blocking a nebula
	var/active_icon_state
	/// State for when we're broken and wont work anymore. Make sure to also set integrity_failure for this to work
	var/broken_icon_state

/obj/machinery/nebula_shielding/Initialize(mapload)
	. = ..()

	add_to_nebula_shielding(src, nebula_type, PROC_REF(get_nebula_shielding))

///Nebula is asking us how strong we are. Return our shield strength is all is well
/obj/machinery/nebula_shielding/proc/get_nebula_shielding()
	if(panel_open || (machine_stat & BROKEN))
		return
	if(!powered())
		update_appearance(UPDATE_ICON_STATE)
		return

	use_power_from_net(power_use_per_block)
	generate_reward()

	update_appearance(UPDATE_ICON_STATE)

	return shielding_strength

///Generate a resource for defending against the nebula
/obj/machinery/nebula_shielding/proc/generate_reward()
	return

/obj/machinery/nebula_shielding/update_icon_state()
	. = ..()

	if((machine_stat & BROKEN) && broken_icon_state)
		icon_state = broken_icon_state
	else if(!powered())
		icon_state = initial(icon_state)
	else
		icon_state = active_icon_state

///Short-lived nebula shielding sent by centcom in-case there hasn't been shielding for a while
/obj/machinery/nebula_shielding/emergency
	density = TRUE
	anchored = FALSE //so some handsome rogue could potentially move it off the station z-level
	shielding_strength = 999 //should block the nebula completely

	///How long we work untill we self-destruct
	var/detonate_in = 10 MINUTES

/obj/machinery/nebula_shielding/emergency/Initialize(mapload)
	. = ..()

	addtimer(CALLBACK(src, PROC_REF(self_destruct)), detonate_in)

///We don't live for very long, so self-destruct
/obj/machinery/nebula_shielding/emergency/proc/self_destruct()
	explosion(src, light_impact_range = 5, flame_range = 3, explosion_cause = src)
	qdel(src)

/obj/machinery/nebula_shielding/emergency/examine(mob/user)
	. = ..()

	. += span_notice("它将以[shielding_strength]的强度屏蔽星云[round(detonate_in / (1 MINUTES))]分钟.")

/obj/machinery/nebula_shielding/emergency/get_nebula_shielding()
	return shielding_strength //no strings attached, we will always produce shielding

/obj/machinery/nebula_shielding/emergency/generate_reward()
	return //no reward for you

///We shield against the radioactive nebula and passively generate tritium
/obj/machinery/nebula_shielding/radiation
	name = "放射性星云屏蔽仪"
	desc = "在产生一个磁场，保护空间站免受放射性星云影响."

	icon_state = "radioactive_shielding"
	active_icon_state = "radioactive_shielding_on"
	broken_icon_state = "radioactive_shielding_broken"

	circuit = /obj/item/circuitboard/machine/radioactive_nebula_shielding

	nebula_type = /datum/station_trait/nebula/hostile/radiation
	shielding_strength = 4

	integrity_failure = 0.4

/obj/machinery/nebula_shielding/radiation/examine(mob/user)
	. = ..()

	. += span_notice("被动地产生氚. 激活时提供[shielding_strength]级别的星云屏蔽.")

/obj/machinery/nebula_shielding/radiation/generate_reward()
	var/turf/open/turf = get_turf(src)
	if(isopenturf(turf))
		turf.atmos_spawn_air("[GAS_TRITIUM]=1;[TURF_TEMPERATURE(T20C)]")

/obj/machinery/nebula_shielding/radiation/attackby(obj/item/item, mob/user, params)
	if(default_deconstruction_screwdriver(user, initial(icon_state) + "_open", initial(icon_state), item))
		return

	if(default_deconstruction_crowbar(item))
		return

	return ..()

///Emergency shielding so people aren't permanently in a radstorm if shit goes very wrong in engineering
/obj/machinery/nebula_shielding/emergency/radiation
	name = "应急放射性星云屏蔽仪"
	desc = "在产生一个磁场，保护空间站免受放射性星云影响."

	icon = 'icons/obj/machines/engine/other.dmi'
	icon_state = "portgen1_1"
	pixel_x = 0

	nebula_type = /datum/station_trait/nebula/hostile/radiation

/obj/machinery/nebula_shielding/emergency/radiation/self_destruct()
	var/turf/open/turf = get_turf(src)
	if(isopenturf(turf))
		turf.atmos_spawn_air("[GAS_TRITIUM]=50;[TURF_TEMPERATURE(T20C)]") //causes a small tritium fire when combined with the explosion

	..()

/// Small explanation for engineering on how to set-up the radioactive nebula shielding
/obj/item/paper/fluff/radiation_nebula
	name = "有关放射性星云屏蔽"
	default_raw_text = {"超级重要!!!! <br>
		在重力发生器的天然屏蔽场被压垮前，设置好这些放射性星云屏蔽装置! <br>
		放射性星云屏蔽装置会不停地产生氚，因此在安装前确保对区域内做了适当的通风或隔离准备!
		从货仓处能订购来更多屏蔽装置的电路板，考虑下设置备用的屏蔽装置，以应对认为破坏、断电等情况.
	"}

/// Warns medical that they can't use radioactive resonance
/obj/item/paper/fluff/radiation_nebula_virologist
	name = "放射性共振"
	default_raw_text = {"重要!!!! <br>
		对身处星云中员工进行常规血液筛查时, 我们找不到任何有关名为'放射性共振'症状的痕迹. <br>
		星云内部有东西在干扰它, 要警惕更浅的病毒基因库.
	"}
