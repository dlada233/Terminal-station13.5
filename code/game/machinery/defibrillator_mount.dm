//Holds defibs does NOT recharge them
//You can activate the mount with an empty hand to grab the paddles
//Not being adjacent will cause the paddles to snap back
/obj/machinery/defibrillator_mount
	name = "除颤器壁挂架"
	desc = "可装载除颤器. 如果安装好你能取下电极板用."
	icon = 'icons/obj/machines/defib_mount.dmi'
	icon_state = "defibrillator_mount"
	density = FALSE
	use_power = NO_POWER_USE
	active_power_usage = 40 * BASE_MACHINE_ACTIVE_CONSUMPTION
	power_channel = AREA_USAGE_EQUIP
	req_one_access = list(ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_SECURITY) //used to control clamps
	processing_flags = NONE
/// The mount's defib
	var/obj/item/defibrillator/defib
/// if true, and a defib is loaded, it can't be removed without unlocking the clamps
	var/clamps_locked = FALSE
/// the type of wallframe it 'disassembles' into
	var/wallframe_type = /obj/item/wallframe/defib_mount

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/defibrillator_mount, 28)

/obj/machinery/defibrillator_mount/loaded/Initialize(mapload) //loaded subtype for mapping use
	. = ..()
	defib = new/obj/item/defibrillator/loaded(src)
	find_and_hang_on_wall()

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/defibrillator_mount, 28)

/obj/machinery/defibrillator_mount/Destroy()
	QDEL_NULL(defib)
	return ..()

/obj/machinery/defibrillator_mount/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == defib)
		// Make sure processing ends before the defib is nulled
		end_processing()
		defib = null
		update_appearance()

/obj/machinery/defibrillator_mount/examine(mob/user)
	. = ..()
	if(defib)
		. += span_notice("除颤器安装在里面. Alt加左键取下它.")
		if(SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_RED)
			. += span_notice("由于安全情况，你可以刷动任何ID来解锁其锁定夹.")
		else
			. += span_notice("滑动任何带有访问权限的ID可以[clamps_locked ? "解锁" : "锁定"]其锁定夹.")

/obj/machinery/defibrillator_mount/update_overlays()
	. = ..()
	if(isnull(defib))
		return

	var/mutable_appearance/defib_overlay = mutable_appearance(icon, "defib", layer = layer+0.01, offset_spokesman = src)

	if(defib.powered)
		var/obj/item/stock_parts/cell/cell = defib.cell
		var/mutable_appearance/safety = mutable_appearance(icon, defib.safety ? "online" : "emagged", offset_spokesman = src)
		var/mutable_appearance/charge_overlay = mutable_appearance(icon, "charge[CEILING((cell.charge / cell.maxcharge) * 4, 1) * 25]", offset_spokesman = src)

		defib_overlay.overlays += list(safety, charge_overlay)

	if(clamps_locked)
		var/mutable_appearance/clamps = mutable_appearance(icon, "clamps", offset_spokesman = src)
		defib_overlay.overlays += clamps

	. += defib_overlay

//defib interaction
/obj/machinery/defibrillator_mount/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!defib)
		to_chat(user, span_warning("里面没有装载除颤器设备!"))
		return
	if(defib.paddles.loc != defib)
		to_chat(user, span_warning("[defib.paddles.loc == user ? "你已经" : "其他人"]使用了[defib]的电极板!"))
		return
	if(!in_range(src, user))
		to_chat(user, span_warning("[defib]的电极板伸的太远，从你手中脱落!"))
		return
	user.put_in_hands(defib.paddles)

/obj/machinery/defibrillator_mount/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/defibrillator))
		if(defib)
			to_chat(user, span_warning("[src]里已经有一台除颤器了!"))
			return
		var/obj/item/defibrillator/D = I
		if(!D.get_cell())
			to_chat(user, span_warning("只有包含电池的除颤器可以连接到[src]!"))
			return
		if(HAS_TRAIT(I, TRAIT_NODROP) || !user.transferItemToLoc(I, src))
			to_chat(user, span_warning("[I]粘在了你的手上!"))
			return
		user.visible_message(span_notice("[user]将[I]连接到[src]!"), \
		span_notice("你将[I]放回支架, 卡入到位."))
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		// Make sure the defib is set before processing begins.
		defib = I
		begin_processing()
		update_appearance()
		return
	else if(defib && I == defib.paddles)
		defib.paddles.snap_back()
		return
	var/obj/item/card/id = I.GetID()
	if(id)
		if(check_access(id) || SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_RED) //anyone can toggle the clamps in red alert!
			if(!defib)
				to_chat(user, span_warning("没有除颤器，也无法使用锁定夹."))
				return
			clamps_locked = !clamps_locked
			to_chat(user, span_notice("锁定夹[clamps_locked ? "" : "解除"]接合."))
			update_appearance()
		else
			to_chat(user, span_warning("访问权限不足."))
		return
	..()

/obj/machinery/defibrillator_mount/multitool_act(mob/living/user, obj/item/multitool)
	..()
	if(!defib)
		to_chat(user, span_warning("没有除颤器可以夹住!"))
		return TRUE
	if(!clamps_locked)
		to_chat(user, span_warning("[src]的锁定夹已经松开了!"))
		return TRUE
	user.visible_message(span_notice("[user]将[multitool]放入[src]的ID卡槽内..."), \
	span_notice("你开始超驰[src]的锁定夹..."))
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	if(!do_after(user, 10 SECONDS, target = src) || !clamps_locked)
		return
	user.visible_message(span_notice("[user]脉冲[multitool], [src]的锁定夹向上滑动."), \
	span_notice("你超驰了[src]的锁定夹!"))
	playsound(src, 'sound/machines/locktoggle.ogg', 50, TRUE)
	clamps_locked = FALSE
	update_appearance()
	return TRUE

/obj/machinery/defibrillator_mount/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(!wallframe_type)
		return ..()
	if(user.combat_mode)
		return ..()
	if(defib)
		to_chat(user, span_warning("当里面装载有除颤器时，壁挂框架不能被拆除."))
		..()
		return TRUE
	new wallframe_type(get_turf(src))
	qdel(src)
	tool.play_tool_sound(user)
	to_chat(user, span_notice("你从墙上取下[src]."))
	return TRUE

/obj/machinery/defibrillator_mount/click_alt(mob/living/carbon/user)
	if(!defib)
		to_chat(user, span_warning("里面压根没有除颤器."))
		return CLICK_ACTION_BLOCKING
	if(clamps_locked)
		to_chat(user, span_warning("你试图取出[defib], 但里面的锁定夹锁得很紧!"))
		return CLICK_ACTION_BLOCKING
	if(!user.put_in_hands(defib))
		to_chat(user, span_warning("你需要一只空手!"))
		user.visible_message(span_notice("[user]将[defib]从[src]上取下, 并将其扔到了地板上."), \
		span_notice("你从[src]取出[defib], 断开充电线，并将其扔到了地板上."))
	else
		user.visible_message(span_notice("[user]将[defib]与[src]断开."), \
		span_notice("你将[defib]从[src]里取下，并断开了充电线."))
	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	return CLICK_ACTION_SUCCESS

/obj/machinery/defibrillator_mount/charging
	name = "PENLITE除颤器壁挂架"
	desc = "可装载除颤器，方便快捷使用. PENLITE版本还能让内部除颤器缓慢充电."
	icon_state = "penlite_mount"
	use_power = IDLE_POWER_USE
	wallframe_type = /obj/item/wallframe/defib_mount/charging


/obj/machinery/defibrillator_mount/charging/Initialize(mapload)
	. = ..()
	if(is_operational)
		begin_processing()


/obj/machinery/defibrillator_mount/charging/on_set_is_operational(old_value)
	if(old_value) //Turned off
		end_processing()
	else //Turned on
		begin_processing()


/obj/machinery/defibrillator_mount/charging/process(seconds_per_tick)
	var/obj/item/stock_parts/cell/cell = get_cell()
	if(!cell || !is_operational)
		return PROCESS_KILL
	if(cell.charge < cell.maxcharge)
		charge_cell(active_power_usage * seconds_per_tick, cell)
		defib.update_power()

//wallframe, for attaching the mounts easily
/obj/item/wallframe/defib_mount
	name = "未连接的除颤器壁挂架"
	desc = "除颤器壁挂框架，一旦放置，可以用扳手将其拆除."
	icon = 'icons/obj/machines/defib_mount.dmi'
	icon_state = "defibrillator_mount"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	w_class = WEIGHT_CLASS_BULKY
	result_path = /obj/machinery/defibrillator_mount
	pixel_shift = 28

/obj/item/wallframe/defib_mount/charging
	name = "未连接的PENLITE除颤器壁挂架"
	desc = "PENLITE除颤器框架. 这个版本可以为内部除颤器缓慢充电."
	icon_state = "penlite_mount"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass = SMALL_MATERIAL_AMOUNT, /datum/material/silver = SMALL_MATERIAL_AMOUNT * 0.5)
	result_path = /obj/machinery/defibrillator_mount/charging

//mobile defib

/obj/machinery/defibrillator_mount/mobile
	name = "移动式除颤器支架"
	icon_state = "mobile"
	anchored = FALSE
	density = TRUE

/obj/machinery/defibrillator_mount/mobile/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noisy_movement)

/obj/machinery/defibrillator_mount/mobile/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return ..()
	if(defib)
		to_chat(user, span_warning("装载除颤器时，支架无法被拆除!"))
		..()
		return TRUE
	balloon_alert(user, "拆除中...")
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 5 SECONDS))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, vary = TRUE)
		deconstruct()
	return TRUE

/obj/machinery/defibrillator_mount/mobile/on_deconstruction(disassembled)
	if(disassembled)
		new /obj/item/stack/sheet/iron(drop_location(), 5)
		new /obj/item/stack/sheet/mineral/silver(drop_location(), 1)
		new /obj/item/stack/cable_coil(drop_location(), 15)
	else
		new /obj/item/stack/sheet/iron(drop_location(), 5)
