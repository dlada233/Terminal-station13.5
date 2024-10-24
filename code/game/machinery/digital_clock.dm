/obj/machinery/digital_clock
	name = "数字时钟"
	desc = "超前卫、时尚与先进的下一代数字时钟，据说由蓝空提供动力. 尽管在任何方面都比经典时钟好，但感觉总是不同，只是再也不像从前那样了..."
	icon_state = "digital_clock_base"
	icon = 'icons/obj/digital_clock.dmi'
	verb_say = "beeps"
	verb_ask = "bloops"
	verb_exclaim = "blares"
	density = FALSE
	layer = ABOVE_WINDOW_LAYER
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 4)

/obj/item/wallframe/digital_clock
	name = "数字时钟框架"
	desc = "用于建造数字时钟，它一般被挂在墙上."
	icon_state = "digital_clock_base"
	icon = 'icons/obj/digital_clock.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 4)
	result_path = /obj/machinery/digital_clock
	pixel_shift = 28

/obj/machinery/digital_clock/wrench_act_secondary(mob/living/user, obj/item/tool)
	. = ..()
	balloon_alert(user, "[anchored ? "解除" : ""]固定...")
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 6 SECONDS))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, vary = TRUE)
		balloon_alert(user, "[anchored ? "解除" : ""]固定完成")
		deconstruct()
		return TRUE

/obj/machinery/digital_clock/welder_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return
	if(atom_integrity >= max_integrity)
		balloon_alert(user, "它不需要修理!")
		return TRUE
	balloon_alert(user, "修理显示...")
	if(!tool.use_tool(src, user, 4 SECONDS, amount = 0, volume=50))
		return TRUE
	balloon_alert(user, "修理完成")
	atom_integrity = max_integrity
	set_machine_stat(machine_stat & ~BROKEN)
	update_appearance()
	return TRUE

/obj/machinery/digital_clock/multitool_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return
	if(!(obj_flags & EMAGGED))
		return
	balloon_alert(user, "重置...")
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 6 SECONDS))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, vary = TRUE)
		balloon_alert(user, "reset")
		obj_flags &= ~EMAGGED
		return TRUE

/obj/machinery/digital_clock/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	playsound(src, SFX_SPARKS, 100, vary = TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	do_sparks(3, cardinal_only = FALSE, source = src)
	obj_flags |= EMAGGED
	return TRUE

/obj/machinery/digital_clock/emp_act(severity)
	. = ..()
	emag_act()

/obj/machinery/digital_clock/on_deconstruction(disassembled)
	if(disassembled)
		new /obj/item/wallframe/digital_clock(drop_location())
	else
		new /obj/item/stack/sheet/iron(drop_location(), 2)
		new /obj/item/shard(drop_location())
		new /obj/item/shard(drop_location())

/obj/machinery/digital_clock/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSdigital_clock, src)
	find_and_hang_on_wall()

/obj/machinery/digital_clock/Destroy()
	STOP_PROCESSING(SSdigital_clock, src)
	return ..()

/obj/machinery/digital_clock/process(seconds_per_tick)
	if(machine_stat & NOPOWER)
		return
	update_appearance()


/obj/machinery/digital_clock/update_appearance(updates=ALL)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		set_light(0)
		return
	set_light(l_range = 1.5, l_power = 0.7, l_color = LIGHT_COLOR_BLUE) // blue light

/obj/machinery/digital_clock/update_overlays()
	. = ..()

	if(machine_stat & (NOPOWER|BROKEN))
		return
	. += update_time()
	return .

/obj/machinery/digital_clock/proc/update_time()
	var/station_minutes
	if(obj_flags & EMAGGED)
		station_minutes = rand(0, 99)
	else
		station_minutes = text2num(station_time_timestamp(format = "mm"))

	// tenth / the '3' in '31' / 31 -> 3.1 -> 3
	var/station_minute_tenth = station_minutes >= 10 ? round(station_minutes * 0.1) : 0
	// one / the '1' in '31' / 31 -> 31 - (3 * 10) -> 31 - 30 -> 1
	var/station_minute_one = station_minutes - (station_minute_tenth * 10)

	var/station_hours

	if(obj_flags & EMAGGED)
		station_hours = rand(0, 99)
	else
		station_hours = text2num(station_time_timestamp(format = "hh"))

	// one / the '1' in '12' / 12 -> 1.2 -> 1
	var/station_hours_tenth = station_minutes >= 10 ? round(station_hours * 0.1) : 0
	// tenth / the '2' in '12' / 12 -> 12 - (1 * 10) -> 12 - 10 -> 2
	var/station_hours_one = station_hours - (station_hours_tenth * 10)

	var/return_overlays = list()

	var/mutable_appearance/minute_one_overlay = mutable_appearance('icons/obj/digital_clock.dmi', "+[station_minute_one]")
	minute_one_overlay.pixel_w = 0
	return_overlays += minute_one_overlay

	var/mutable_appearance/minute_tenth_overlay = mutable_appearance('icons/obj/digital_clock.dmi', "+[station_minute_tenth]")
	minute_tenth_overlay.pixel_w = -4
	return_overlays += minute_tenth_overlay

	var/mutable_appearance/separator = mutable_appearance('icons/obj/digital_clock.dmi', "+separator")
	return_overlays += separator

	var/mutable_appearance/hour_one_overlay = mutable_appearance('icons/obj/digital_clock.dmi', "+[station_hours_one]")
	hour_one_overlay.pixel_w = -10
	return_overlays += hour_one_overlay

	var/mutable_appearance/hour_tenth_overlay = mutable_appearance('icons/obj/digital_clock.dmi', "+[station_hours_tenth]")
	hour_tenth_overlay.pixel_w = -14
	return_overlays += hour_tenth_overlay

	return return_overlays

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/digital_clock, 28)
