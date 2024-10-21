/obj/machinery/recharger
	name = "武器充电器"
	icon = 'icons/obj/machines/sec.dmi'
	icon_state = "recharger"
	base_icon_state = "recharger"
	desc = "用于为能量武器、PDA或其他设备充能."
	circuit = /obj/item/circuitboard/machine/recharger
	pass_flags = PASSTABLE
	var/obj/item/charging = null
	var/recharge_coeff = 1
	var/using_power = FALSE //Did we put power into "charging" last process()?
	///Did we finish recharging the currently inserted item?
	var/finished_recharging = FALSE

	var/static/list/allowed_devices = typecacheof(list(
		/obj/item/stock_parts/cell/microfusion, //SKYRAT EDIT ADDITION
		/obj/item/gun/microfusion, // SKYRAT EDIT ADDITION
		/obj/item/gun/energy,
		/obj/item/melee/baton/security,
		/obj/item/ammo_box/magazine/recharge,
		/obj/item/modular_computer,
	))

/obj/machinery/recharger/RefreshParts()
	. = ..()
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		recharge_coeff = capacitor.tier

/obj/machinery/recharger/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += span_warning("你离的太远，无法看清[src]的情况!")
		return

	if(charging)
		. += {"[span_notice("[src]内含:")]
		[span_notice("- [charging].")]"}

	if(machine_stat & (NOPOWER|BROKEN))
		return
	var/status_display_message_shown = FALSE
	if(using_power)
		status_display_message_shown = TRUE
		. += span_notice("状态读数显示:")
		. += span_notice("- 充电效率: <b>[recharge_coeff*100]%</b>.")

	if(isnull(charging))
		return
	if(!status_display_message_shown)
		. += span_notice("状态读数显示:")

	var/obj/item/stock_parts/cell/charging_cell = charging.get_cell()
	if(charging_cell)
		. += span_notice("- [charging]的电池已充至 <b>[charging_cell.percent()]%</b>.")
		return
	if(istype(charging, /obj/item/ammo_box/magazine/recharge))
		var/obj/item/ammo_box/magazine/recharge/power_pack = charging
		. += span_notice("- [charging]的电池已充至 <b>[PERCENT(power_pack.stored_ammo.len/power_pack.max_ammo)]%</b>.")
		return
	. += span_notice("- [charging]为报告功率水平.")

/obj/machinery/recharger/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(is_type_in_typecache(arrived, allowed_devices))
		charging = arrived
		START_PROCESSING(SSmachines, src)
		update_use_power(ACTIVE_POWER_USE)
		finished_recharging = FALSE
		using_power = TRUE
		update_appearance()
	return ..()

/obj/machinery/recharger/Exited(atom/movable/gone, direction)
	if(gone == charging)
		if(!QDELING(charging))
			charging.update_appearance()
		charging = null
		update_use_power(IDLE_POWER_USE)
		using_power = FALSE
		update_appearance()
	return ..()

/obj/machinery/recharger/attackby(obj/item/attacking_item, mob/user, params)
	if(!is_type_in_typecache(attacking_item, allowed_devices))
		return ..()

	if(!anchored)
		to_chat(user, span_notice("[src]没有被连接到任何东西上!"))
		return TRUE
	if(charging || panel_open)
		return TRUE

	var/area/our_area = get_area(src) //Check to make sure user's not in space doing it, and that the area got proper power.
	if(!isarea(our_area) || our_area.power_equip == 0)
		to_chat(user, span_notice("[src]闪烁红灯，当你插入[attacking_item]时."))
		return TRUE

	if (istype(attacking_item, /obj/item/gun/energy))
		var/obj/item/gun/energy/energy_gun = attacking_item
		if(!energy_gun.can_charge)
			to_chat(user, span_notice("你的枪没有充电接口."))
			return TRUE

	//SKYRAT EDIT ADDITION
	if (istype(attacking_item, /obj/item/gun/microfusion))
		var/obj/item/gun/microfusion/microfusion_gun = attacking_item
		if(microfusion_gun.cell?.chargerate <= 0)
			to_chat(user, span_notice("[microfusion_gun]无法被充能!"))
			return TRUE

	if (istype(attacking_item, /obj/item/stock_parts/cell/microfusion))
		var/obj/item/stock_parts/cell/microfusion/inserting_cell = attacking_item
		if(inserting_cell.chargerate <= 0)
			to_chat(user, span_notice("[inserting_cell]无法被充能!"))
			return TRUE
	//SKYRAT EDIT END

	user.transferItemToLoc(attacking_item, src)
	return TRUE

/obj/machinery/recharger/wrench_act(mob/living/user, obj/item/tool)
	if(charging)
		to_chat(user, span_notice("先移除里面的充电物!"))
		return ITEM_INTERACT_BLOCKING
	set_anchored(!anchored)
	power_change()
	to_chat(user, span_notice("你[anchored ? "接上" : "断开"][src]."))
	tool.play_tool_sound(src)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/recharger/screwdriver_act(mob/living/user, obj/item/tool)
	if(!anchored || charging)
		return ITEM_INTERACT_BLOCKING
	. = default_deconstruction_screwdriver(user, base_icon_state, base_icon_state, tool)
	if(.)
		update_appearance()

/obj/machinery/recharger/crowbar_act(mob/living/user, obj/item/tool)
	return (!anchored || charging) ? ITEM_INTERACT_BLOCKING : default_deconstruction_crowbar(tool)

/obj/machinery/recharger/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	add_fingerprint(user)
	if(isnull(charging) || user.put_in_hands(charging))
		return
	charging.forceMove(drop_location())

/obj/machinery/recharger/attack_tk(mob/user)
	if(isnull(charging))
		return
	charging.forceMove(drop_location())
	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/machinery/recharger/process(seconds_per_tick)
	if(machine_stat & (NOPOWER|BROKEN) || !anchored)
		return PROCESS_KILL

	using_power = FALSE
	if(isnull(charging))
		return PROCESS_KILL
	var/obj/item/stock_parts/cell/charging_cell = charging.get_cell()
	if(charging_cell)
		if(charging_cell.charge < charging_cell.maxcharge)
			charge_cell(charging_cell.chargerate * recharge_coeff * seconds_per_tick, charging_cell)
			using_power = TRUE
		update_appearance()

	if(istype(charging, /obj/item/ammo_box/magazine/recharge)) //if you add any more snowflake ones, make sure to update the examine messages too.
		var/obj/item/ammo_box/magazine/recharge/power_pack = charging
		if(power_pack.stored_ammo.len < power_pack.max_ammo)
			power_pack.stored_ammo += new power_pack.ammo_type(power_pack)
			use_energy(active_power_usage * recharge_coeff * seconds_per_tick)
			using_power = TRUE
		update_appearance()
		return
	if(!using_power && !finished_recharging) //Inserted thing is at max charge/ammo, notify those around us
		finished_recharging = TRUE
		playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
		say("[charging]已充满!")

/obj/machinery/recharger/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_CONTENTS)
		return
	if((machine_stat & (NOPOWER|BROKEN)) || !anchored)
		return
	if(istype(charging, /obj/item/gun/energy))
		var/obj/item/gun/energy/energy_gun = charging
		if(energy_gun.cell)
			energy_gun.cell.emp_act(severity)

	else if(istype(charging, /obj/item/melee/baton/security))
		var/obj/item/melee/baton/security/batong = charging
		if(batong.cell)
			batong.cell.charge = 0

/obj/machinery/recharger/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN) || !anchored)
		return
	if(panel_open)
		. += mutable_appearance(icon, "[base_icon_state]-open", alpha = src.alpha)
		return

	var/icon_to_use = "[base_icon_state]-[isnull(charging) ? "empty" : (using_power ? "charging" : "full")]"
	. += mutable_appearance(icon, icon_to_use, alpha = src.alpha)
	. += emissive_appearance(icon, icon_to_use, src, alpha = src.alpha)
