/obj/item/supplypod_beacon
	name = "补给舱信标"
	desc = "一个可以连接到特快供应控制台，进行补给舱精确投送的装置. Alt+左键以取消连接."
	icon = 'icons/obj/devices/tracker.dmi'
	icon_state = "supplypod_beacon"
	inhand_icon_state = "radio"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	armor_type = /datum/armor/supplypod_beacon
	resistance_flags = FIRE_PROOF
	interaction_flags_click = ALLOW_SILICON_REACH
	/// The linked console
	var/obj/machinery/computer/cargo/express/express_console
	/// If linked
	var/linked = FALSE
	/// If this is ready to launch
	var/ready = FALSE
	/// If it's been launched
	var/launched = FALSE

/datum/armor/supplypod_beacon
		bomb = 100
		fire = 100

/obj/item/supplypod_beacon/proc/update_status(consoleStatus)
	switch(consoleStatus)
		if (SP_LINKED)
			linked = TRUE
			playsound(src,'sound/machines/twobeep.ogg',50,FALSE)
		if (SP_READY)
			ready = TRUE
		if (SP_LAUNCH)
			launched = TRUE
			playsound(src,'sound/machines/triple_beep.ogg',50,FALSE)
			playsound(src,'sound/machines/warning-buzzer.ogg',50,FALSE)
			addtimer(CALLBACK(src, PROC_REF(endLaunch)), 33)//wait 3.3 seconds (time it takes for supplypod to land), then update icon
		if (SP_UNLINK)
			linked = FALSE
			playsound(src,'sound/machines/synth_no.ogg',50,FALSE)
		if (SP_UNREADY)
			ready = FALSE
	update_appearance()

/obj/item/supplypod_beacon/update_overlays()
	. = ..()
	if(launched)
		. += "sp_green"
		return
	if(ready)
		. += "sp_yellow"
		return
	if(linked)
		. += "sp_orange"
		return

/obj/item/supplypod_beacon/proc/endLaunch()
	launched = FALSE
	update_status()

/obj/item/supplypod_beacon/examine(user)
	. = ..()
	. += span_notice("它看起来有几个锚定栓.")
	if(!express_console)
		. += span_notice("[src]当前未连接到特快供应控制台.")
	else
		. += span_notice("Alt+左键可解除将其从特快供应控制台的连接.")

/obj/item/supplypod_beacon/Destroy()
	if(express_console)
		express_console.beacon = null
	return ..()

/obj/item/supplypod_beacon/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/item/supplypod_beacon/proc/unlink_console()
	if(express_console)
		express_console.beacon = null
		express_console = null
	update_status(SP_UNLINK)
	update_status(SP_UNREADY)

/obj/item/supplypod_beacon/proc/link_console(obj/machinery/computer/cargo/express/C, mob/living/user)
	if (C.beacon)//if new console has a beacon, then...
		C.beacon.unlink_console()//unlink the old beacon from new console
	if (express_console)//if this beacon has an express console
		express_console.beacon = null//remove the connection the expressconsole has from beacons
	express_console = C//set the linked console var to the console
	express_console.beacon = src//out with the old in with the news
	update_status(SP_LINKED)
	if (express_console.usingBeacon)
		update_status(SP_READY)
	to_chat(user, span_notice("[src]连接到[C]."))

/obj/item/supplypod_beacon/click_alt(mob/user)
	if(!express_console)
		to_chat(user, span_alert("当前没有链接的控制台."))
		return CLICK_ACTION_BLOCKING
	unlink_console()
	return CLICK_ACTION_SUCCESS

/obj/item/supplypod_beacon/attackby(obj/item/W, mob/user)
	if(IS_WRITING_UTENSIL(W)) //give a tag that is visible from the linked express console
		return ..()
	var/new_beacon_name = tgui_input_text(user, "你想要设置什么标签?", "信标标签", max_length = MAX_NAME_LEN)
	if(isnull(new_beacon_name))
		return
	if(!user.can_perform_action(src))
		return
	name += " ([tag])"
