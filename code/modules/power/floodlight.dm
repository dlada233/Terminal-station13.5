
#define FLOODLIGHT_OFF 1
#define FLOODLIGHT_LOW 2
#define FLOODLIGHT_MED 3
#define FLOODLIGHT_HIGH 4

/obj/structure/floodlight_frame
	name = "泛光灯框架"
	desc = "一种金属框架，需要电线和灯管才能成为泛光灯."
	max_integrity = 100
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floodlight_c1"
	density = TRUE

	var/state = FLOODLIGHT_NEEDS_WIRES

/obj/structure/floodlight_frame/Initialize(mapload)
	. = ..()
	register_context()

/obj/structure/floodlight_frame/add_context(
	atom/source,
	list/context,
	obj/item/held_item,
	mob/living/user,
)

	if(isnull(held_item))
		return NONE

	var/message = null
	if(state == FLOODLIGHT_NEEDS_WIRES)
		if(istype(held_item, /obj/item/stack/cable_coil))
			message = "添加电线"
		else if(held_item.tool_behaviour == TOOL_WRENCH)
			message = "拆除框架"

	else if(state == FLOODLIGHT_NEEDS_SECURING)
		if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
			message = "固定电线"
		else if(held_item.tool_behaviour == TOOL_WIRECUTTER)
			message = "拆剪电线"

	else if(state == FLOODLIGHT_NEEDS_LIGHTS)
		if(istype(held_item, /obj/item/light/tube))
			message = "添加灯管"
		else if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
			message = "接触电线固定"

	if(isnull(message))
		return NONE
	context[SCREENTIP_CONTEXT_LMB] = message
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/floodlight_frame/examine(mob/user)
	. = ..()
	if(state == FLOODLIGHT_NEEDS_WIRES)
		. += span_notice("它需要添加[EXAMINE_HINT("5根电线")].")
		. += span_notice("它可以用[EXAMINE_HINT("扳手")]来拆解.")
	else if(state == FLOODLIGHT_NEEDS_SECURING)
		. += span_notice("它需要用[EXAMINE_HINT("螺丝刀")]来固定电线.")
		. += span_notice("它的电线可以用[EXAMINE_HINT("剪线钳")]来拆剪掉.")
	else if(state == FLOODLIGHT_NEEDS_LIGHTS)
		. += span_notice("它需要添加[EXAMINE_HINT("灯管")]来完成它.")
		. += span_notice("它的电线可以用[EXAMINE_HINT("螺丝刀")]来接触固定.")

/obj/structure/floodlight_frame/screwdriver_act(mob/living/user, obj/item/O)
	. = ..()
	if(state == FLOODLIGHT_NEEDS_SECURING)
		icon_state = "floodlight_c3"
		state = FLOODLIGHT_NEEDS_LIGHTS
		return TRUE
	else if(state == FLOODLIGHT_NEEDS_LIGHTS)
		icon_state = "floodlight_c2"
		state = FLOODLIGHT_NEEDS_SECURING
		return TRUE
	return FALSE

/obj/structure/floodlight_frame/wrench_act(mob/living/user, obj/item/tool)
	if(state != FLOODLIGHT_NEEDS_WIRES)
		return FALSE

	if(!tool.use_tool(src, user, 30, volume=50))
		return TRUE
	new /obj/item/stack/sheet/iron(loc, 5)
	qdel(src)

	return TRUE

/obj/structure/floodlight_frame/wirecutter_act(mob/living/user, obj/item/tool)
	if(state != FLOODLIGHT_NEEDS_SECURING)
		return FALSE

	icon_state = "floodlight_c1"
	state = FLOODLIGHT_NEEDS_WIRES
	new /obj/item/stack/cable_coil(loc, 5)

	return TRUE

/obj/structure/floodlight_frame/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/stack/cable_coil) && state == FLOODLIGHT_NEEDS_WIRES)
		var/obj/item/stack/S = O
		if(S.use(5))
			icon_state = "floodlight_c2"
			state = FLOODLIGHT_NEEDS_SECURING
			return
		else
			balloon_alert(user, "需要5根电线!")
			return

	if(istype(O, /obj/item/light/tube))
		var/obj/item/light/tube/L = O
		if(state == FLOODLIGHT_NEEDS_LIGHTS && L.status != 2) //Ready for a light tube, and not broken.
			new /obj/machinery/power/floodlight(loc)
			qdel(src)
			qdel(O)
			return
		else //A minute of silence for all the accidentally broken light tubes.
			balloon_alert(user, "灯管已破碎!")
			return
	..()

/obj/structure/floodlight_frame/completed
	name = "泛光灯框架"
	desc = "一个光秃秃的金属框架，看起来像一个泛光灯的，需要一个灯管来完成."
	icon_state = "floodlight_c3"
	state = FLOODLIGHT_NEEDS_LIGHTS

/obj/machinery/power/floodlight
	name = "泛光灯"
	desc = "一根杆子，上面装有能发出强光的灯管，由于其高功耗，它必须直接接到地线上去."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floodlight"
	density = TRUE
	max_integrity = 100
	integrity_failure = 0.8
	idle_power_usage = 0
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION
	anchored = FALSE
	light_power = 1.75
	can_change_cable_layer = TRUE

	/// List of power usage multipliers
	var/list/light_setting_list = list(0, 5, 10, 15)
	/// Constant coeff. for power usage
	var/light_power_coefficient = 200
	/// Intensity of the floodlight.
	var/setting = FLOODLIGHT_OFF

/obj/machinery/power/floodlight/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_OBJ_PAINTED, TYPE_PROC_REF(/obj/machinery/power/floodlight, on_color_change))  //update light color when color changes
	RegisterSignal(src, COMSIG_HIT_BY_SABOTEUR, PROC_REF(on_saboteur))
	register_context()

/obj/machinery/power/floodlight/proc/on_color_change(obj/machinery/power/flood_light, mob/user, obj/item/toy/crayon/spraycan/spraycan, is_dark_color)
	SIGNAL_HANDLER
	if(!spraycan.actually_paints)
		return

	if(setting > FLOODLIGHT_OFF)
		update_light_state()

/obj/machinery/power/floodlight/Destroy()
	UnregisterSignal(src, COMSIG_OBJ_PAINTED)
	. = ..()

/// change light color during operation
/obj/machinery/power/floodlight/proc/update_light_state()
	var/light_color =  NONSENSICAL_VALUE
	if(!isnull(color))
		light_color = color
	set_light(light_setting_list[setting], light_power, light_color)

/obj/machinery/power/floodlight/add_context(
	atom/source,
	list/context,
	obj/item/held_item,
	mob/living/user,
)

	if(isnull(held_item))
		if(panel_open)
			context[SCREENTIP_CONTEXT_LMB] = "移除照明"
			return CONTEXTUAL_SCREENTIP_SET
		return NONE

	var/message = null
	if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
		message = "打开面板"
	else if(held_item.tool_behaviour == TOOL_WRENCH)
		message = anchored ? "解除固定" : "固定"

	if(isnull(message))
		return NONE
	context[SCREENTIP_CONTEXT_LMB] = message
	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/power/floodlight/examine(mob/user)
	. = ..()
	if(!anchored)
		. += span_notice("它需要被固定在电缆上.")
	else
		. += span_notice("它的功率等级为[setting].")
	if(panel_open)
		. += span_notice("它的维护口是开着的，可以用[EXAMINE_HINT("螺丝刀")]关上.")
		. += span_notice("它的灯管可以用[EXAMINE_HINT("手")]移除.")
	else
		. += span_notice("它的维护口是关着的，可以用[EXAMINE_HINT("螺丝刀")]打开.")

/obj/machinery/power/floodlight/process()
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = locate() in T
	if(!C && powernet)
		disconnect_from_network()
	if(setting > FLOODLIGHT_OFF) //If on
		if(avail(active_power_usage))
			add_load(active_power_usage)
		else
			change_setting(FLOODLIGHT_OFF)
	else if(avail(idle_power_usage))
		add_load(idle_power_usage)

/obj/machinery/power/floodlight/proc/change_setting(newval, mob/user)
	if((newval < FLOODLIGHT_OFF) || (newval > light_setting_list.len))
		return

	setting = newval
	active_power_usage = light_setting_list[setting] * light_power_coefficient
	if(!avail(active_power_usage) && setting > FLOODLIGHT_OFF)
		return change_setting(setting - 1)
	update_light_state()
	var/setting_text = ""
	if(setting > FLOODLIGHT_OFF)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)
	switch(setting)
		if(FLOODLIGHT_OFF)
			setting_text = "关"
		if(FLOODLIGHT_LOW)
			setting_text = "低功率"
		if(FLOODLIGHT_MED)
			setting_text = "标准功率"
		if(FLOODLIGHT_HIGH)
			setting_text = "高功率"
	if(user)
		to_chat(user, span_notice("你切换[src]到[setting_text]."))

/obj/machinery/power/floodlight/cable_layer_change_checks(mob/living/user, obj/item/tool)
	if(anchored)
		balloon_alert(user, "先解除固定!")
		return FALSE
	return TRUE

/obj/machinery/power/floodlight/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	change_setting(FLOODLIGHT_OFF)
	if(anchored)
		connect_to_network()
	else
		disconnect_from_network()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/floodlight/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	change_setting(FLOODLIGHT_OFF)
	panel_open = TRUE
	balloon_alert(user, "打开面板")
	return TRUE

/obj/machinery/power/floodlight/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(panel_open)
		var/obj/structure/floodlight_frame/floodlight_frame = new(loc)
		floodlight_frame.state = FLOODLIGHT_NEEDS_LIGHTS

		var/obj/item/light/tube/light_tube = new(loc)
		user.put_in_active_hand(light_tube)

		qdel(src)

	var/current = setting
	if(current == FLOODLIGHT_OFF)
		current = light_setting_list.len
	else
		current--
	change_setting(current, user)

/obj/machinery/power/floodlight/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/power/floodlight/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/power/floodlight/proc/on_saboteur(datum/source, disrupt_duration)
	SIGNAL_HANDLER
	atom_break(ENERGY) // technically,
	return COMSIG_SABOTEUR_SUCCESS

/obj/machinery/power/floodlight/atom_break(damage_flag)
	. = ..()
	if(!.)
		return
	playsound(loc, 'sound/effects/glassbr3.ogg', 100, TRUE)

	var/obj/structure/floodlight_frame/floodlight_frame = new(loc)
	floodlight_frame.state = FLOODLIGHT_NEEDS_LIGHTS
	var/obj/item/light/tube/our_light = new(loc)
	our_light.shatter()

	qdel(src)

/obj/machinery/power/floodlight/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	playsound(src, 'sound/effects/glasshit.ogg', 75, TRUE)

#undef FLOODLIGHT_OFF
#undef FLOODLIGHT_LOW
#undef FLOODLIGHT_MED
#undef FLOODLIGHT_HIGH
