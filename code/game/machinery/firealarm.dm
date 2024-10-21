/obj/item/electronics/firealarm
	name = "火警铃电路板"
	desc = "火警电路，可以应对高达40摄氏度的热量."

/obj/item/wallframe/firealarm
	name = "火警铃框架"
	desc = "等待建造成火警铃."
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "fire_bitem"
	result_path = /obj/machinery/firealarm
	pixel_shift = 26

/obj/machinery/firealarm
	name = "火警铃"
	desc = "紧急情况才拉，也就是说，一直拉它."
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "fire0"
	max_integrity = 250
	integrity_failure = 0.4
	armor_type = /datum/armor/machinery_firealarm
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.05
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.02
	power_channel = AREA_USAGE_ENVIRON
	resistance_flags = FIRE_PROOF

	light_power = 1
	light_range = 1.6
	light_color = LIGHT_COLOR_ELECTRIC_CYAN

	//We want to use area sensitivity, let us
	always_area_sensitive = TRUE
	///Buildstate for contruction steps
	var/buildstage = FIRE_ALARM_BUILD_SECURED
	///Our home area, set in Init. Due to loading step order, this seems to be null very early in the server setup process, which is why some procs use `my_area?` for var or list checks.
	var/area/my_area = null
	///looping sound datum for our fire alarm siren.
	var/datum/looping_sound/firealarm/soundloop

/datum/armor/machinery_firealarm
	fire = 90
	acid = 30

/obj/machinery/firealarm/Initialize(mapload, dir, building)
	. = ..()
	id_tag = assign_random_name()
	if(building)
		buildstage = FIRE_ALARM_BUILD_NO_CIRCUIT
		set_panel_open(TRUE)
	if(name == initial(name))
		update_name()
	my_area = get_area(src)
	LAZYADD(my_area.firealarms, src)

	AddElement(/datum/element/atmos_sensitive, mapload)
	RegisterSignal(SSsecurity_level, COMSIG_SECURITY_LEVEL_CHANGED, PROC_REF(check_security_level))
	soundloop = new(src, FALSE)

	AddComponent(/datum/component/usb_port, list(
		/obj/item/circuit_component/firealarm,
	))

	AddElement( \
		/datum/element/contextual_screentip_bare_hands, \
		lmb_text = "开启", \
		rmb_text = "关闭", \
	)

	AddComponent( \
		/datum/component/redirect_attack_hand_from_turf, \
		screentip_texts = list( \
			lmb_text = "开启警铃", \
			rmb_text = "关闭警铃", \
		), \
	)

	var/static/list/hovering_mob_typechecks = list(
		/mob/living/silicon = list(
			SCREENTIP_CONTEXT_CTRL_LMB = "开关自动温度感应",
		)
	)
	AddElement(/datum/element/contextual_screentip_mob_typechecks, hovering_mob_typechecks)
	find_and_hang_on_wall()
	update_appearance()


/obj/machinery/firealarm/Destroy()
	if(my_area)
		LAZYREMOVE(my_area.firealarms, src)
		my_area = null
	QDEL_NULL(soundloop)
	return ..()

// Area sensitivity is traditionally tied directly to power use, as an optimization
// But since we want it for fire reacting, we disregard that
/obj/machinery/firealarm/setup_area_power_relationship()
	. = ..()
	if(!.)
		return
	var/area/our_area = get_area(src)
	RegisterSignal(our_area, COMSIG_AREA_FIRE_CHANGED, PROC_REF(handle_fire))
	handle_fire(our_area, our_area.fire)

/obj/machinery/firealarm/on_enter_area(datum/source, area/area_to_register)
	//were already registered to an area. exit from here first before entering into an new area
	if(!isnull(my_area))
		return
	. = ..()

	my_area = area_to_register
	LAZYADD(my_area.firealarms, src)

	RegisterSignal(area_to_register, COMSIG_AREA_FIRE_CHANGED, PROC_REF(handle_fire))
	handle_fire(area_to_register, area_to_register.fire)
	update_appearance()

/obj/machinery/firealarm/update_name(updates)
	. = ..()
	name = "[get_area_name(my_area)] [initial(name)] [id_tag]"

/obj/machinery/firealarm/on_exit_area(datum/source, area/area_to_unregister)
	//we cannot unregister from an area we never registered to in the first place
	if(my_area != area_to_unregister)
		return
	. = ..()

	UnregisterSignal(area_to_unregister, COMSIG_AREA_FIRE_CHANGED)
	LAZYREMOVE(my_area.firealarms, src)
	my_area = null

/obj/machinery/firealarm/proc/handle_fire(area/source, new_fire)
	SIGNAL_HANDLER
	set_status()

/**
 * Sets the sound state, and then calls update_icon()
 *
 * This proc exists to be called by areas and firelocks
 * so that it may update its icon and start or stop playing
 * the alarm sound based on the state of an area variable.
 */
/obj/machinery/firealarm/proc/set_status()
	if(!(my_area.fire || LAZYLEN(my_area.active_firelocks)) || (obj_flags & EMAGGED))
		soundloop.stop()
	update_appearance()

/obj/machinery/firealarm/update_appearance(updates)
	. = ..()
	if((my_area?.fire || LAZYLEN(my_area?.active_firelocks)) && !(obj_flags & EMAGGED) && !(machine_stat & (BROKEN|NOPOWER)))
		set_light(l_range = 2.5, l_power = 1.5)
	else
		set_light(l_range = 1.6, l_power = 1)

/obj/machinery/firealarm/update_icon_state()
	if(panel_open)
		icon_state = "fire_b[buildstage]"
		return ..()
	if(machine_stat & BROKEN)
		icon_state = "firex"
		return ..()
	icon_state = "fire0"
	return ..()

/obj/machinery/firealarm/update_overlays()
	. = ..()
	if(machine_stat & NOPOWER)
		return

	if(panel_open)
		return

	if(obj_flags & EMAGGED)
		. += mutable_appearance(icon, "fire_emag")
		. += emissive_appearance(icon, "fire_emag_e", src, alpha = src.alpha)
		set_light(l_color = LIGHT_COLOR_BLUE)

	else if(!(my_area?.fire || LAZYLEN(my_area?.active_firelocks)))
		if(my_area?.fire_detect) //If this is false, someone disabled it. Leave the light missing, a good hint to anyone paying attention.
			if(is_station_level(z))
				var/current_level = SSsecurity_level.get_current_level_as_number()
				. += mutable_appearance(icon, "fire_[current_level]")
				. += emissive_appearance(icon, "fire_level_e", src, alpha = src.alpha)
				switch(current_level)
					if(SEC_LEVEL_GREEN)
						set_light(l_color = LIGHT_COLOR_BLUEGREEN)
					if(SEC_LEVEL_BLUE)
						set_light(l_color = LIGHT_COLOR_ELECTRIC_CYAN)
					if(SEC_LEVEL_RED)
						set_light(l_color = LIGHT_COLOR_FLARE)
					if(SEC_LEVEL_DELTA)
						set_light(l_color = LIGHT_COLOR_INTENSE_RED)
					//SKYRAT EDIT ADDITION BEGIN - ADDITIONAL ALERT LEVELS
					if(SEC_LEVEL_VIOLET)
						set_light(l_color = COLOR_VIOLET)
					if(SEC_LEVEL_ORANGE)
						set_light(l_color = LIGHT_COLOR_ORANGE)
					if(SEC_LEVEL_AMBER)
						set_light(l_color = LIGHT_COLOR_DIM_YELLOW)
					if(SEC_LEVEL_EPSILON)
						set_light(l_color = COLOR_ASSEMBLY_WHITE)
					if(SEC_LEVEL_GAMMA)
						set_light(l_color = COLOR_ASSEMBLY_PURPLE)
					//SKYRAT EDIT ADDITION END
			else
				. += mutable_appearance(icon, "fire_offstation")
				. += emissive_appearance(icon, "fire_level_e", src, alpha = src.alpha)
				set_light(l_color = LIGHT_COLOR_FAINT_BLUE)
		else
			. += mutable_appearance(icon, "fire_disabled")
			. += emissive_appearance(icon, "fire_level_e", src, alpha = src.alpha)
			set_light(l_color = COLOR_WHITE)

	else if(my_area?.fire_detect && my_area?.fire)
		. += mutable_appearance(icon, "fire_alerting")
		. += emissive_appearance(icon, "fire_alerting_e", src, alpha = src.alpha)
		set_light(l_color = LIGHT_COLOR_INTENSE_RED)
	else
		. += mutable_appearance(icon, "fire_alerting")
		. += emissive_appearance(icon, "fire_alerting_e", src, alpha = src.alpha)
		set_light(l_color = LIGHT_COLOR_INTENSE_RED)

/obj/machinery/firealarm/emp_act(severity)
	. = ..()

	if (. & EMP_PROTECT_SELF)
		return

	if(prob(50 / severity))
		alarm()

/obj/machinery/firealarm/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	update_appearance()
	visible_message(span_warning("[src]里飞溅出火花!"))
	if(user)
		balloon_alert(user, "扬声器已禁用")
		user.log_message("emagged [src].", LOG_ATTACK)
	playsound(src, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	set_status()
	return TRUE

/**
 * Signal handler for checking if we should update fire alarm appearance accordingly to a newly set security level
 *
 * Arguments:
 * * source The datum source of the signal
 * * new_level The new security level that is in effect
 */
/obj/machinery/firealarm/proc/check_security_level(datum/source, new_level)
	SIGNAL_HANDLER

	if(is_station_level(z))
		update_appearance()

/**
 * Sounds the fire alarm and closes all firelocks in the area. Also tells the area to color the lights red.
 *
 * Arguments:
 * * mob/user is the user that pulled the alarm.
 */
/obj/machinery/firealarm/proc/alarm(mob/user)
	if(!is_operational)
		return

	if(my_area.fire)
		return //area alarm already active
	my_area.alarm_manager.send_alarm(ALARM_FIRE, my_area)
	// This'll setup our visual effects, so we only need to worry about the alarm
	for(var/obj/machinery/door/firedoor/firelock in my_area.firedoors)
		firelock.activate(FIRELOCK_ALARM_TYPE_GENERIC)
	if(user)
		balloon_alert(user, "警报触发!")
		user.log_message("triggered a fire alarm.", LOG_GAME)
	my_area.fault_status = AREA_FAULT_MANUAL
	my_area.fault_location = name
	soundloop.start() //Manually pulled fire alarms will make the sound, rather than the doors.
	SEND_SIGNAL(src, COMSIG_FIREALARM_ON_TRIGGER)
	update_use_power(ACTIVE_POWER_USE)

/**
 * Resets all firelocks in the area. Also tells the area to disable alarm lighting, if it was enabled.
 *
 * Arguments:
 * * mob/user is the user that reset the alarm.
 */
/obj/machinery/firealarm/proc/reset(mob/user)
	if(!is_operational)
		return
	my_area.alarm_manager.clear_alarm(ALARM_FIRE, my_area)
	// Clears all fire doors and their effects for now
	// They'll reclose if there's a problem
	for(var/obj/machinery/door/firedoor/firelock in my_area.firedoors)
		firelock.crack_open()
	if(user)
		balloon_alert(user, "重置火警铃")
		user.log_message("reset a fire alarm.", LOG_GAME)
	soundloop.stop()
	SEND_SIGNAL(src, COMSIG_FIREALARM_ON_RESET)
	update_use_power(IDLE_POWER_USE)

/obj/machinery/firealarm/attack_hand(mob/user, list/modifiers)
	if(buildstage != FIRE_ALARM_BUILD_SECURED)
		return
	. = ..()
	add_fingerprint(user)
	alarm(user)

/obj/machinery/firealarm/attack_hand_secondary(mob/user, list/modifiers)
	if(buildstage != FIRE_ALARM_BUILD_SECURED)
		return ..()
	add_fingerprint(user)
	reset(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/firealarm/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/firealarm/attack_ai_secondary(mob/user)
	return attack_hand_secondary(user)

/obj/machinery/firealarm/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/firealarm/attack_robot_secondary(mob/user)
	return attack_hand_secondary(user)

/obj/machinery/firealarm/attackby(obj/item/tool, mob/living/user, params)
	add_fingerprint(user)

	if(tool.tool_behaviour == TOOL_SCREWDRIVER && buildstage == FIRE_ALARM_BUILD_SECURED)
		tool.play_tool_sound(src)
		toggle_panel_open()
		to_chat(user, span_notice("线缆被[panel_open ? "暴露在外" : "隐藏得很好"]."))
		update_appearance()
		return

	if(panel_open)

		if(tool.tool_behaviour == TOOL_WELDER && !user.combat_mode)
			if(atom_integrity < max_integrity)
				if(!tool.tool_start_check(user, amount=1))
					return

				to_chat(user, span_notice("你开始修理[src]..."))
				if(tool.use_tool(src, user, 40, volume=50))
					atom_integrity = max_integrity
					to_chat(user, span_notice("你修理好了[src]."))
			else
				to_chat(user, span_warning("[src]状态良好!"))
			return

		switch(buildstage)
			if(2)
				if(tool.tool_behaviour == TOOL_MULTITOOL)
					toggle_fire_detect(user)
					return
				if(tool.tool_behaviour == TOOL_WIRECUTTER)
					buildstage = FIRE_ALARM_BUILD_NO_WIRES
					tool.play_tool_sound(src)
					new /obj/item/stack/cable_coil(user.loc, 5)
					to_chat(user, span_notice("你剪断[src]的线缆."))
					update_appearance()
					return

				else if(tool.force) //hit and turn it on
					..()
					var/area/area = get_area(src)
					if(!area.fire)
						alarm()
					return

			if(1)
				if(istype(tool, /obj/item/stack/cable_coil))
					var/obj/item/stack/cable_coil/coil = tool
					if(coil.get_amount() < 5)
						to_chat(user, span_warning("你需要更多的电线来做这个!"))
					else
						coil.use(5)
						buildstage = FIRE_ALARM_BUILD_SECURED
						to_chat(user, span_notice("你为[src]接线."))
						update_appearance()
					return

				else if(tool.tool_behaviour == TOOL_CROWBAR)
					user.visible_message(span_notice("[user.name]移除了[src.name]的电子元件."), \
										span_notice("你开始撬出电子元件..."))
					if(tool.use_tool(src, user, 20, volume=50))
						if(buildstage == FIRE_ALARM_BUILD_NO_WIRES)
							if(machine_stat & BROKEN)
								to_chat(user, span_notice("你取出了损坏的电路板."))
								set_machine_stat(machine_stat & ~BROKEN)
							else
								to_chat(user, span_notice("你撬出了电路板."))
								new /obj/item/electronics/firealarm(user.loc)
							buildstage = FIRE_ALARM_BUILD_NO_CIRCUIT
							update_appearance()
					return
			if(0)
				if(istype(tool, /obj/item/electronics/firealarm))
					to_chat(user, span_notice("你插入电路板."))
					qdel(tool)
					buildstage = FIRE_ALARM_BUILD_NO_WIRES
					update_appearance()
					return

				else if(istype(tool, /obj/item/electroadaptive_pseudocircuit))
					var/obj/item/electroadaptive_pseudocircuit/pseudoc = tool
					if(!pseudoc.adapt_circuit(user, circuit_cost = 0.015 * STANDARD_CELL_CHARGE))
						return
					user.visible_message(span_notice("[user]生产了一块电路板并将其放入[src]."), \
					span_notice("你编写了火警铃电路板并将其插入框架中."))
					buildstage = FIRE_ALARM_BUILD_NO_WIRES
					update_appearance()
					return

				else if(tool.tool_behaviour == TOOL_WRENCH)
					user.visible_message(span_notice("[user]移除了墙上的火警铃框架."), \
						span_notice("你移除了墙上的火警铃框架."))
					var/obj/item/wallframe/firealarm/frame = new /obj/item/wallframe/firealarm()
					frame.forceMove(user.drop_location())
					tool.play_tool_sound(src)
					qdel(src)
					return
	return ..()

/obj/machinery/firealarm/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if((buildstage == FIRE_ALARM_BUILD_NO_CIRCUIT) && (the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return list("delay" = 2 SECONDS, "cost" = 1)
	return FALSE

/obj/machinery/firealarm/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	switch(rcd_data["[RCD_DESIGN_MODE]"])
		if(RCD_WALLFRAME)
			balloon_alert(user, "电路板已安装")
			buildstage = FIRE_ALARM_BUILD_NO_WIRES
			update_appearance()
			return TRUE
	return FALSE

/obj/machinery/firealarm/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.) //damage received
		if(atom_integrity > 0 && !(machine_stat & BROKEN) && buildstage != FIRE_ALARM_BUILD_NO_CIRCUIT)
			if(prob(33) && buildstage == FIRE_ALARM_BUILD_SECURED) //require fully wired electronics to set of the alarms
				alarm()

/obj/machinery/firealarm/singularity_pull(S, current_size)
	if (current_size >= STAGE_FIVE) // If the singulo is strong enough to pull anchored objects, the fire alarm experiences integrity failure
		deconstruct()
	return ..()

/obj/machinery/firealarm/atom_break(damage_flag)
	if(buildstage == FIRE_ALARM_BUILD_NO_CIRCUIT) //can't break the electronics if there isn't any inside.
		return
	return ..()

/obj/machinery/firealarm/on_deconstruction(disassembled)
	new /obj/item/stack/sheet/iron(loc, 1)
	if(buildstage > FIRE_ALARM_BUILD_NO_CIRCUIT)
		var/obj/item/item = new /obj/item/electronics/firealarm(loc)
		if(!disassembled)
			item.update_integrity(item.max_integrity * 0.5)
	if(buildstage > FIRE_ALARM_BUILD_NO_WIRES)
		new /obj/item/stack/cable_coil(loc, 3)

// Allows users to examine the state of the thermal sensor
/obj/machinery/firealarm/examine(mob/user)
	. = ..()
	if((my_area?.fire || LAZYLEN(my_area?.active_firelocks)))
		. += "局部地区警示灯在闪烁."
		. += "问题地区位于[my_area.fault_location] ([my_area.fault_status == AREA_FAULT_AUTOMATIC ? "自动检测" : "手动触发"])."
		if(is_station_level(z))
			. += "空间站的安全警报等级为[SSsecurity_level.get_current_level_as_text()]."
		. += "<b>左键</b>启动该区域的所有防火门."
		. += "<b>右键</b>重置该区域的所有防火门."
	else
		if(is_station_level(z))
			. += "空间站的安全警报等级为[SSsecurity_level.get_current_level_as_text()]."
		. += "局部地区温度检测灯[my_area.fire_detect ? "亮起" : "熄灭着"]."
		. += "<b>左键</b>启动该区域的所有防火门."

// Allows Silicons to disable thermal sensor
/obj/machinery/firealarm/BorgCtrlClick(mob/living/silicon/robot/user)
	if(get_dist(src,user) <= user.interaction_range && !(user.control_disabled))
		AICtrlClick(user)
		return
	return ..()

/obj/machinery/firealarm/AICtrlClick(mob/living/silicon/robot/user)
	if(obj_flags & EMAGGED)
		to_chat(user, span_warning("[src]的控制电路似乎出现了故障."))
		return
	toggle_fire_detect(user)

/obj/machinery/firealarm/proc/toggle_fire_detect(mob/user)
	my_area.fire_detect = !my_area.fire_detect
	for(var/obj/machinery/firealarm/fire_panel in my_area.firealarms)
		fire_panel.update_icon()
	if (user)
		balloon_alert(user, "温度传感器[my_area.fire_detect ? "已开启" : "已关闭"]")
		user.log_message("[ my_area.fire_detect ? "enabled" : "disabled" ] firelock sensors using [src].", LOG_GAME)

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/firealarm, 26)

/*
 * Return of Party button
 */

/area
	var/party = FALSE

/obj/machinery/firealarm/partyalarm
	name = "\improper 趴体按钮"
	desc = "古巴皮特在屋里!"
	var/static/party_overlay

/obj/machinery/firealarm/partyalarm/reset()
	if (machine_stat & (NOPOWER|BROKEN))
		return
	var/area/area = get_area(src)
	if (!area || !area.party)
		return
	area.party = FALSE
	area.cut_overlay(party_overlay)

/obj/machinery/firealarm/partyalarm/alarm()
	if (machine_stat & (NOPOWER|BROKEN))
		return
	var/area/area = get_area(src)
	if (!area || area.party || area.name == "太空")
		return
	area.party = TRUE
	if (!party_overlay)
		party_overlay = iconstate2appearance('icons/area/areas_misc.dmi', "party")
	area.add_overlay(party_overlay)

/obj/item/circuit_component/firealarm
	display_name = "火警铃"
	desc = "允许你与火警铃进行交互."

	var/datum/port/input/alarm_trigger
	var/datum/port/input/reset_trigger

	/// Returns a boolean value of 0 or 1 if the fire alarm is on or not.
	var/datum/port/output/is_on
	/// Returns when the alarm is turned on
	var/datum/port/output/triggered
	/// Returns when the alarm is turned off
	var/datum/port/output/reset

	var/obj/machinery/firealarm/attached_alarm

/obj/item/circuit_component/firealarm/populate_ports()
	alarm_trigger = add_input_port("Set", PORT_TYPE_SIGNAL)
	reset_trigger = add_input_port("Reset", PORT_TYPE_SIGNAL)

	is_on = add_output_port("Is On", PORT_TYPE_NUMBER)
	triggered = add_output_port("Triggered", PORT_TYPE_SIGNAL)
	reset = add_output_port("Reset", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/firealarm/register_usb_parent(atom/movable/parent)
	. = ..()
	if(istype(parent, /obj/machinery/firealarm))
		attached_alarm = parent
		RegisterSignal(parent, COMSIG_FIREALARM_ON_TRIGGER, PROC_REF(on_firealarm_triggered))
		RegisterSignal(parent, COMSIG_FIREALARM_ON_RESET, PROC_REF(on_firealarm_reset))

/obj/item/circuit_component/firealarm/unregister_usb_parent(atom/movable/parent)
	attached_alarm = null
	UnregisterSignal(parent, COMSIG_FIREALARM_ON_TRIGGER)
	UnregisterSignal(parent, COMSIG_FIREALARM_ON_RESET)
	return ..()

/obj/item/circuit_component/firealarm/proc/on_firealarm_triggered(datum/source)
	SIGNAL_HANDLER
	is_on.set_output(1)
	triggered.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/firealarm/proc/on_firealarm_reset(datum/source)
	SIGNAL_HANDLER
	is_on.set_output(0)
	reset.set_output(COMPONENT_SIGNAL)


/obj/item/circuit_component/firealarm/input_received(datum/port/input/port)
	if(COMPONENT_TRIGGERED_BY(alarm_trigger, port))
		attached_alarm?.alarm()

	if(COMPONENT_TRIGGERED_BY(reset_trigger, port))
		attached_alarm?.reset()
