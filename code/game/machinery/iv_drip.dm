///IV drip operation mode when it sucks blood from the object
#define IV_TAKING 0
///IV drip operation mode when it injects reagents into the object
#define IV_INJECTING 1
///What the transfer rate value is rounded to
#define IV_TRANSFER_RATE_STEP 0.01
///Minimum possible IV drip transfer rate in units per second
#define MIN_IV_TRANSFER_RATE 0
///Maximum possible IV drip transfer rate in units per second
#define MAX_IV_TRANSFER_RATE 5
///Default IV drip transfer rate in units per second
#define DEFAULT_IV_TRANSFER_RATE 5
//Alert shown to mob the IV is still connected
#define ALERT_IV_CONNECTED "iv_connected"

///Universal IV that can drain blood or feed reagents over a period of time from or to a replaceable container
/obj/machinery/iv_drip
	name = "\improper 静脉输液架"
	desc = "带有高级输液泵，既可以抽取血液，也可以注射液体."
	icon = 'icons/obj/medical/iv_drip.dmi'
	icon_state = "iv_drip"
	base_icon_state = "iv_drip"
	anchored = FALSE
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	use_power = NO_POWER_USE
	interaction_flags_mouse_drop = NEED_HANDS

	///What are we sticking our needle in?
	var/atom/attached
	///Are we donating or injecting?
	var/mode = IV_INJECTING
	///The chemicals flow speed
	var/transfer_rate = DEFAULT_IV_TRANSFER_RATE
	///Internal beaker
	var/obj/item/reagent_container
	///Set false to block beaker use and instead use an internal reagent holder
	var/use_internal_storage = FALSE
	///If we're using the internal container, fill us UP with the below : list(/datum/reagent/water = 5000)
	var/internal_list_reagents
	///How many reagents can we hold?
	var/internal_volume_maximum = 100
	// If the blood draining tab should be greyed out
	var/inject_only = FALSE

/obj/machinery/iv_drip/Initialize(mapload)
	. = ..()
	if(use_internal_storage)
		create_reagents(internal_volume_maximum, TRANSPARENT)
		if(internal_list_reagents)
			reagents.add_reagent_list(internal_list_reagents)
	interaction_flags_machine |= INTERACT_MACHINE_OFFLINE
	register_context()
	update_appearance(UPDATE_ICON)
	AddElement(/datum/element/noisy_movement)

/obj/machinery/iv_drip/Destroy()
	attached = null
	QDEL_NULL(reagent_container)
	return ..()

/obj/machinery/iv_drip/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "IVDrip", name)
		ui.open()

/obj/machinery/iv_drip/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(attached)
		context[SCREENTIP_CONTEXT_RMB] = "拔出针头"
	else if(reagent_container && !use_internal_storage)
		context[SCREENTIP_CONTEXT_RMB] = "取出输液容器"
	else if(!inject_only)
		context[SCREENTIP_CONTEXT_RMB] = "改变方向"

	if(transfer_rate > MIN_IV_TRANSFER_RATE)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "设定流量为最小值"
	else
		context[SCREENTIP_CONTEXT_ALT_LMB] = "设定流量为最大值"

	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/iv_drip/ui_static_data(mob/user)
	. = list()
	.["transferStep"] = IV_TRANSFER_RATE_STEP
	.["maxTransferRate"] = MAX_IV_TRANSFER_RATE
	.["minTransferRate"] = MIN_IV_TRANSFER_RATE

/obj/machinery/iv_drip/ui_data(mob/user)
	. = list()

	.["hasInternalStorage"] = use_internal_storage
	.["hasContainer"] = reagent_container ? TRUE : FALSE
	.["canRemoveContainer"] = !use_internal_storage

	.["mode"] = mode == IV_INJECTING ? TRUE : FALSE
	.["canDraw"] = inject_only || (attached && !isliving(attached)) ? FALSE : TRUE
	.["transferRate"] = transfer_rate

	.["hasObjectAttached"] = attached ? TRUE : FALSE
	if(attached)
		.["objectName"] = attached.name

	var/datum/reagents/drip_reagents = get_reagents()
	if(drip_reagents)
		.["containerCurrentVolume"] = round(drip_reagents.total_volume, IV_TRANSFER_RATE_STEP)
		.["containerMaxVolume"] = drip_reagents.maximum_volume
		.["containerReagentColor"] = mix_color_from_reagents(drip_reagents.reagent_list)

/obj/machinery/iv_drip/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("changeMode")
			toggle_mode()
			return TRUE
		if("eject")
			eject_beaker()
			return TRUE
		if("detach")
			detach_iv()
			return TRUE
		if("changeRate")
			set_transfer_rate(text2num(params["rate"]))
			return TRUE

/// Sets the transfer rate to the provided value
/obj/machinery/iv_drip/proc/set_transfer_rate(new_rate)
	transfer_rate = round(clamp(new_rate, MIN_IV_TRANSFER_RATE, MAX_IV_TRANSFER_RATE), IV_TRANSFER_RATE_STEP)
	update_appearance(UPDATE_ICON)

/obj/machinery/iv_drip/update_icon_state()
	if(transfer_rate > 0 && attached)
		icon_state = "[base_icon_state]_[mode ? "injecting" : "donating"]"
	else
		icon_state = "[base_icon_state]_[mode ? "injectidle" : "donateidle"]"
	return ..()

/obj/machinery/iv_drip/update_overlays()
	. = ..()

	if(!reagent_container)
		return

	. += attached ? "beakeractive" : "beakeridle"
	var/datum/reagents/container_reagents = get_reagents()
	if(!container_reagents)
		return

	//The thresholds used to determine the reagent fill icon
	var/static/list/fill_icon_thresholds = list(0, 10, 25, 50, 75, 80, 90)

	var/threshold = null
	for(var/i in 1 to fill_icon_thresholds.len)
		if(ROUND_UP(100 * container_reagents.total_volume / container_reagents.maximum_volume) >= fill_icon_thresholds[i])
			threshold = i

	if(threshold)
		var/fill_name = "reagent[fill_icon_thresholds[threshold]]"
		var/mutable_appearance/filling = mutable_appearance(icon, fill_name)
		filling.color = mix_color_from_reagents(container_reagents.reagent_list)
		. += filling

/obj/machinery/iv_drip/mouse_drop_dragged(atom/target, mob/user)
	if(!isliving(user))
		to_chat(user, span_warning("你不能这么做!"))
		return
	if(!get_reagents())
		to_chat(user, span_warning("没有东西与输液架连接!"))
		return
	if(!target.is_injectable(user))
		to_chat(user, span_warning("无法注射该对象!"))
		return
	if(attached)
		visible_message(span_warning("[attached]与[src]分离."))
		attached = null
		update_appearance(UPDATE_ICON)
	user.visible_message(span_warning("[user]将[src]与[target]相连."), span_notice("你将[src]与[target]相连."))
	attach_iv(target, user)

/obj/machinery/iv_drip/attackby(obj/item/W, mob/user, params)
	if(use_internal_storage)
		return ..()

	//Typecache of containers we accept
	var/static/list/drip_containers = typecacheof(list(
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/cup,
		/obj/item/reagent_containers/chem_pack,
	))

	if(is_type_in_typecache(W, drip_containers) || IS_EDIBLE(W))
		if(reagent_container)
			to_chat(user, span_warning("[reagent_container]已经被挂载到了[src]!"))
			return
		if(!user.transferItemToLoc(W, src))
			return
		reagent_container = W
		to_chat(user, span_notice("你把[W]挂载到[src]."))
		user.log_message("attached a [W] to [src] at [AREACOORD(src)] containing ([reagent_container.reagents.get_reagent_log_string()])", LOG_ATTACK)
		add_fingerprint(user)
		update_appearance(UPDATE_ICON)
		return
	else
		return ..()


/obj/machinery/iv_drip/click_alt(mob/user)
	set_transfer_rate(transfer_rate > MIN_IV_TRANSFER_RATE ? MIN_IV_TRANSFER_RATE : MAX_IV_TRANSFER_RATE)
	return CLICK_ACTION_SUCCESS

/obj/machinery/iv_drip/on_deconstruction(disassembled = TRUE)
	new /obj/item/stack/sheet/iron(loc)

/obj/machinery/iv_drip/process(seconds_per_tick)
	if(!attached)
		return PROCESS_KILL

	if(!(get_dist(src, attached) <= 1 && isturf(attached.loc)))
		if(isliving(attached))
			var/mob/living/carbon/attached_mob = attached
			to_chat(attached, span_userdanger("你身上的静脉注射针头被挣断，留下了一道开放性的出血伤口!"))
			var/list/arm_zones = shuffle(list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM))
			var/obj/item/bodypart/chosen_limb = attached_mob.get_bodypart(arm_zones[1]) || attached_mob.get_bodypart(arm_zones[2]) || attached_mob.get_bodypart(BODY_ZONE_CHEST)
			chosen_limb.receive_damage(3)
			attached_mob.cause_wound_of_type_and_severity(WOUND_PIERCE, chosen_limb, WOUND_SEVERITY_MODERATE, wound_source = "IV needle")
		else
			visible_message(span_warning("[attached]与[src]分离."))
		detach_iv()
		return PROCESS_KILL

	var/datum/reagents/drip_reagents = get_reagents()
	if(!drip_reagents)
		return PROCESS_KILL

	if(!transfer_rate)
		return

	// Give reagents
	if(mode)
		if(drip_reagents.total_volume)
			drip_reagents.trans_to(attached, transfer_rate * seconds_per_tick, methods = INJECT, show_message = FALSE) //make reagents reacts, but don't spam messages
			update_appearance(UPDATE_ICON)

	// Take blood
	else if (isliving(attached))
		var/mob/living/attached_mob = attached
		var/amount = min(transfer_rate * seconds_per_tick, drip_reagents.maximum_volume - drip_reagents.total_volume)
		// If the beaker is full, ping
		if(!amount)
			set_transfer_rate(MIN_IV_TRANSFER_RATE)
			audible_message(span_hear("[src]响了一声."))
			return

		// If the human is losing too much blood, beep.
		if(attached_mob.blood_volume < BLOOD_VOLUME_SAFE && prob(5))
			audible_message(span_hear("[src]大声警报."))
			playsound(loc, 'sound/machines/twobeep_high.ogg', 50, TRUE)
		var/atom/movable/target = use_internal_storage ? src : reagent_container
		attached_mob.transfer_blood_to(target, amount)
		update_appearance(UPDATE_ICON)

/obj/machinery/iv_drip/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!ishuman(user))
		return
	if(attached)
		visible_message(span_notice("[attached]与[src]分离."))
		detach_iv()
	else if(reagent_container)
		eject_beaker(user)
	else
		toggle_mode()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

///called when an IV is attached
/obj/machinery/iv_drip/proc/attach_iv(atom/target, mob/user)
	if(isliving(target))
		user.visible_message(span_warning("[usr]开始将[src]与[target]相连..."), span_warning("你开始将[src]与[target]相连."))
		if(!do_after(usr, 1 SECONDS, target))
			return
	else
		mode = IV_INJECTING
	usr.visible_message(span_warning("[usr]将[src]与[target]相连."), span_notice("你将[src]与[target]相连."))
	var/datum/reagents/container = get_reagents()
	log_combat(usr, target, "attached", src, "containing: ([container.get_reagent_log_string()])")
	add_fingerprint(usr)
	if(isliving(target))
		var/mob/living/target_mob = target
		target_mob.throw_alert(ALERT_IV_CONNECTED, /atom/movable/screen/alert/iv_connected)
	attached = target
	START_PROCESSING(SSmachines, src)
	update_appearance(UPDATE_ICON)

	SEND_SIGNAL(src, COMSIG_IV_ATTACH, target)

///Called when an iv is detached. doesnt include chat stuff because there's multiple options and its better handled by the caller
/obj/machinery/iv_drip/proc/detach_iv()
	if(attached)
		visible_message(span_notice("[attached]与[src]分离."))
		if(isliving(attached))
			var/mob/living/attached_mob = attached
			attached_mob.clear_alert(ALERT_IV_CONNECTED, /atom/movable/screen/alert/iv_connected)
	SEND_SIGNAL(src, COMSIG_IV_DETACH, attached)
	attached = null
	update_appearance(UPDATE_ICON)

/// Get the reagents used by IV drip
/obj/machinery/iv_drip/proc/get_reagents()
	return use_internal_storage ? reagents : reagent_container?.reagents

/obj/machinery/iv_drip/verb/eject_beaker()
	set category = "物件"
	set name = "移除液体容器"
	set src in view(1)

	if(!isliving(usr))
		to_chat(usr, span_warning("你不能这么做!"))
		return
	if(!usr.can_perform_action(src))
		return
	if(usr.incapacitated())
		return
	if(reagent_container)
		if(attached)
			visible_message(span_warning("[attached]与[src]分离."))
			detach_iv()
		reagent_container.forceMove(drop_location())
		reagent_container = null
		update_appearance(UPDATE_ICON)

/obj/machinery/iv_drip/verb/toggle_mode()
	set category = "物件"
	set name = "切换模式"
	set src in view(1)

	if(!isliving(usr))
		to_chat(usr, span_warning("你不能这么做!"))
		return
	if(!usr.can_perform_action(src) || usr.incapacitated())
		return
	if(inject_only)
		mode = IV_INJECTING
		return
	// Prevent blood draining from non-living
	if(attached && !isliving(attached))
		mode = IV_INJECTING
		return
	mode = !mode
	update_appearance(UPDATE_ICON)
	to_chat(usr, span_notice("输液架现在是[mode ? "注射" : "抽血"]模式."))

/obj/machinery/iv_drip/examine(mob/user)
	. = ..()
	if(get_dist(user, src) > 2)
		return
	. += "[src]正在[mode ? "注射" : "抽血"]."
	if(reagent_container)
		if(reagent_container.reagents && reagent_container.reagents.reagent_list.len)
			. += span_notice("所连容器是装有[reagent_container.reagents.total_volume]u液体的[reagent_container].")
		else
			. += span_notice("所连容器空的[reagent_container.name].")
	else if(use_internal_storage)
		. += span_notice("它有一个内部化学物质储存装置.")
	else
		. += span_notice("无化学物质相连.")
	. += span_notice("[attached ? attached : "没有什么"]已连接.")

/datum/crafting_recipe/iv_drip
	name = "静脉输液架"
	result = /obj/machinery/iv_drip
	time = 30
	tool_behaviors = list(TOOL_SCREWDRIVER)
	reqs = list(
		/obj/item/stack/rods = 2,
		/obj/item/stack/sheet/plastic = 1,
		/obj/item/reagent_containers/syringe = 1,
	)
	category = CAT_CHEMISTRY

/obj/machinery/iv_drip/saline
	name = "盐水点滴"
	desc = "一个可以无限量打点滴的生理盐水储罐，旨在为医院提供不耗尽的盐水. 配有一台看起来很吓人的泵，用于将盐水转移到容器里，直接给人用可能是个坏主意."
	icon_state = "saline"
	base_icon_state = "saline"
	density = TRUE
	inject_only = TRUE

	use_internal_storage = TRUE
	internal_list_reagents = list(/datum/reagent/medicine/salglu_solution = 5000)
	internal_volume_maximum = 5000

/obj/machinery/iv_drip/saline/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	. = ..()

/atom/movable/screen/alert/iv_connected
	name = "输液连线"
	desc = "你手臂上已经连上了输液线，离开前记得取下或直接拖着输液架走，否则针头将会撕裂你的皮肉!"
	icon_state = ALERT_IV_CONNECTED

#undef IV_TAKING
#undef IV_INJECTING

#undef MIN_IV_TRANSFER_RATE
#undef MAX_IV_TRANSFER_RATE

#undef IV_TRANSFER_RATE_STEP

#undef ALERT_IV_CONNECTED

#undef DEFAULT_IV_TRANSFER_RATE
