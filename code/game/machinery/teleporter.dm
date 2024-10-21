/obj/machinery/teleport
	name = "传送"
	icon = 'icons/obj/machines/teleporter.dmi'
	density = TRUE

/obj/machinery/teleport/hub
	name = "传送枢纽"
	desc = "远距离传送机器的枢纽."
	icon_state = "tele0"
	base_icon_state = "tele"
	circuit = /obj/item/circuitboard/machine/teleporter_hub
	var/accuracy = 0
	var/obj/machinery/teleport/station/power_station
	var/calibrated = FALSE//Calibration prevents mutation

/obj/machinery/teleport/hub/Initialize(mapload)
	. = ..()
	link_power_station()

/obj/machinery/teleport/hub/Destroy()
	if (power_station)
		power_station.teleporter_hub = null
		power_station = null
	return ..()

/obj/machinery/teleport/hub/RefreshParts()
	. = ..()
	var/A = 0
	for(var/datum/stock_part/matter_bin/matter_bin in component_parts)
		A += matter_bin.tier
	accuracy = A

/obj/machinery/teleport/hub/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("状态显示: 故障概率降低了 <b>[(accuracy*25)-25]%</b>.")

/obj/machinery/teleport/hub/proc/link_power_station()
	if(power_station)
		return
	for(var/direction in GLOB.cardinals)
		power_station = locate(/obj/machinery/teleport/station, get_step(src, direction))
		if(power_station)
			power_station.link_console_and_hub()
			break
	return power_station

/obj/machinery/teleport/hub/Bumped(atom/movable/AM)
	if(is_centcom_level(z))
		to_chat(AM, span_warning("你不能使用这个!"))
		return
	if(is_ready())
		teleport(AM)

/obj/machinery/teleport/hub/attackby(obj/item/W, mob/user, params)
	if(default_deconstruction_screwdriver(user, "tele-o", "tele0", W))
		if(power_station?.engaged)
			power_station.engaged = 0 //hub with panel open is off, so the station must be informed.
			update_appearance()
		return
	if(default_deconstruction_crowbar(W))
		return
	return ..()

/obj/machinery/teleport/hub/proc/teleport(atom/movable/M as mob|obj, turf/T)
	var/obj/machinery/computer/teleporter/com = power_station.teleporter_console
	if (QDELETED(com))
		return
	var/atom/target
	if(com.target_ref)
		target = com.target_ref.resolve()
	if (!target)
		com.target_ref = null
		visible_message(span_alert("无法对锁定的坐标进行验证，请恢复坐标网络."))
		return
	if(!ismovable(M))
		return
	var/turf/start_turf = get_turf(M)
	if(!do_teleport(M, target, channel = TELEPORT_CHANNEL_BLUESPACE))
		return
	playsound(loc, SFX_PORTAL_ENTER, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	use_energy(active_power_usage)
	new /obj/effect/temp_visual/portal_animation(start_turf, src, M)
	if(!calibrated && ishuman(M) && prob(30 - ((accuracy) * 10))) //oh dear a problem
		var/mob/living/carbon/human/human = M
		if(!(human.mob_biotypes & (MOB_ROBOTIC|MOB_MINERAL|MOB_UNDEAD|MOB_SPIRIT)))
			var/datum/species/species_to_transform = /datum/species/fly
			if(check_holidays(MOTH_WEEK))
				species_to_transform = /datum/species/moth
			if(human.dna && human.dna.species.id != initial(species_to_transform.id))
				to_chat(M, span_hear("你听到耳边嗡嗡响."))
				human.set_species(species_to_transform)
				human.log_message("was turned into a [initial(species_to_transform.name)] through [src].", LOG_GAME)
	calibrated = FALSE

/obj/machinery/teleport/hub/update_icon_state()
	icon_state = "[base_icon_state][panel_open ? "-o" : (is_ready() ? 1 : 0)]"
	return ..()

/obj/machinery/teleport/hub/proc/is_ready()
	. = !panel_open && !(machine_stat & (BROKEN|NOPOWER)) && power_station && power_station.engaged && !(power_station.machine_stat & (BROKEN|NOPOWER))

/obj/machinery/teleport/hub/syndicate/Initialize(mapload)
	. = ..()
	var/obj/item/stock_parts/matter_bin/super/super_bin = new(src)
	LAZYADD(component_parts, super_bin)
	RefreshParts()

/obj/machinery/teleport/station
	name = "传送站"
	desc = "蓝空传送机的电源控制站，用于切换电源，可以进行试传送来防止故障."
	icon_state = "controller"
	base_icon_state = "controller"
	circuit = /obj/item/circuitboard/machine/teleporter_station
	var/engaged = FALSE
	var/obj/machinery/computer/teleporter/teleporter_console
	var/obj/machinery/teleport/hub/teleporter_hub
	var/list/linked_stations = list()
	var/efficiency = 0

/obj/machinery/teleport/station/Initialize(mapload)
	. = ..()
	link_console_and_hub()

/obj/machinery/teleport/station/RefreshParts()
	. = ..()
	var/E
	for(var/datum/stock_part/capacitor/C in component_parts)
		E += C.tier
	efficiency = E - 1

/obj/machinery/teleport/station/examine(mob/user)
	. = ..()
	if(!panel_open)
		. += span_notice("检修盖被<i>螺丝</i>锁住了.")
	else
		. += span_notice("<i>连接</i>设备现在能够用多功能工具<i>扫描到</i>.")
	if(in_range(user, src) || isobserver(user))
		. += span_notice("状态显示: 此传送站可以连接到<b>[efficiency]</b>个其他传送站.")

/obj/machinery/teleport/station/proc/link_console_and_hub()
	for(var/direction in GLOB.cardinals)
		teleporter_hub = locate(/obj/machinery/teleport/hub, get_step(src, direction))
		if(teleporter_hub)
			teleporter_hub.link_power_station()
			break
	for(var/direction in GLOB.cardinals)
		teleporter_console = locate(/obj/machinery/computer/teleporter, get_step(src, direction))
		if(teleporter_console)
			teleporter_console.link_power_station()
			break
	return teleporter_hub && teleporter_console


/obj/machinery/teleport/station/Destroy()
	if(teleporter_hub)
		teleporter_hub.power_station = null
		teleporter_hub.update_appearance()
		teleporter_hub = null
	if (teleporter_console)
		teleporter_console.power_station = null
		teleporter_console = null
	return ..()

/obj/machinery/teleport/station/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_MULTITOOL)
		if(!multitool_check_buffer(user, W))
			return
		var/obj/item/multitool/M = W
		if(panel_open)
			M.set_buffer(src)
			balloon_alert(user, "已保存到多功能工具缓冲区")
		else
			if(M.buffer && istype(M.buffer, /obj/machinery/teleport/station) && M.buffer != src)
				if(linked_stations.len < efficiency)
					linked_stations.Add(M.buffer)
					M.set_buffer(null)
					balloon_alert(user, "已从缓冲区上传数据")
				else
					to_chat(user, span_alert("本传送站无法容纳更多信息，请尝试更换更好的组件."))
		return
	else if(default_deconstruction_screwdriver(user, "controller-o", "controller", W))
		update_appearance()
		return

	else if(default_deconstruction_crowbar(W))
		return
	else
		return ..()

/obj/machinery/teleport/station/interact(mob/user)
	toggle(user)

/obj/machinery/teleport/station/proc/toggle(mob/user)
	if(machine_stat & (BROKEN|NOPOWER) || !teleporter_hub || !teleporter_console )
		return
	if (teleporter_console.target_ref?.resolve())
		if(teleporter_hub.panel_open || teleporter_hub.machine_stat & (BROKEN|NOPOWER))
			to_chat(user, span_alert("传送枢纽没有响应."))
		else
			engaged = !engaged
			use_energy(active_power_usage)
			to_chat(user, span_notice("传送功能[engaged ? "开启" : "关闭"]!"))
	else
		teleporter_console.target_ref = null
		to_chat(user, span_alert("未检测到目标."))
		engaged = FALSE
	teleporter_hub.update_appearance()
	add_fingerprint(user)

/obj/machinery/teleport/station/power_change()
	. = ..()
	if(teleporter_hub)
		teleporter_hub.update_appearance()

/obj/machinery/teleport/station/update_icon_state()
	if(panel_open)
		icon_state = "[base_icon_state]-o"
		return ..()
	if(machine_stat & (BROKEN|NOPOWER))
		icon_state = "[base_icon_state]-p"
		return ..()
	if(teleporter_console?.calibrating)
		icon_state = "[base_icon_state]-c"
		return ..()
	icon_state = base_icon_state
	return ..()
