/obj/item/radio/intercom //ICON OVERRIDDEN IN SKYRAT AESTHETICS - SEE MODULE
	name = "空间站无线电"
	desc = "一个可靠的站内无线电设备，耳机无声时能随时投入使用."
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "intercom"
	anchored = TRUE
	w_class = WEIGHT_CLASS_BULKY
	canhear_range = 2
	dog_fashion = null
	unscrewed = FALSE
	item_flags = NO_BLOOD_ON_ITEM

	overlay_speaker_idle = "intercom_s"
	overlay_speaker_active = "intercom_receive"

	overlay_mic_idle = "intercom_m"
	overlay_mic_active = null

	///The icon of intercom while its turned off
	var/icon_off = "intercom-p"

/obj/item/radio/intercom/unscrewed
	unscrewed = TRUE

/obj/item/radio/intercom/prison
	name = "收听无线电"
	desc = "这是一个站内对讲设备，似乎经过改装，现在已不具备广播功能."
	icon_state = "intercom_prison"
	icon_off = "intercom_prison-p"

/obj/item/radio/intercom/prison/Initialize(mapload, ndir, building)
	. = ..()
	wires?.cut(WIRE_TX)

/obj/item/radio/intercom/Initialize(mapload, ndir, building)
	. = ..()
	var/area/current_area = get_area(src)
	if(!current_area)
		return
	RegisterSignal(current_area, COMSIG_AREA_POWER_CHANGE, PROC_REF(AreaPowerCheck))
	GLOB.intercoms_list += src
	if(!unscrewed)
		find_and_hang_on_wall(directional = TRUE, \
			custom_drop_callback = CALLBACK(src, PROC_REF(knock_down)))

/obj/item/radio/intercom/Destroy()
	. = ..()
	GLOB.intercoms_list -= src

/obj/item/radio/intercom/examine(mob/user)
	. = ..()
	. += span_notice("Use [MODE_TOKEN_INTERCOM] when nearby to speak into it.")
	if(!unscrewed)
		. += span_notice("It's <b>screwed</b> and secured to the wall.")
	else
		. += span_notice("It's <i>unscrewed</i> from the wall, and can be <b>detached</b>.")

	if(anonymize)
		. += span_notice("Speaking through this intercom will anonymize your voice.")

	if(freqlock == RADIO_FREQENCY_UNLOCKED)
		if(obj_flags & EMAGGED)
			. += span_warning("Its frequency lock has been shorted...")
	else
		. += span_notice("It has a frequency lock set to [frequency/10].")

/obj/item/radio/intercom/screwdriver_act(mob/living/user, obj/item/tool)
	if(unscrewed)
		user.visible_message(span_notice("[user] starts tightening [src]'s screws..."), span_notice("You start screwing in [src]..."))
		if(tool.use_tool(src, user, 30, volume=50))
			user.visible_message(span_notice("[user] tightens [src]'s screws!"), span_notice("You tighten [src]'s screws."))
			unscrewed = FALSE
	else
		user.visible_message(span_notice("[user] starts loosening [src]'s screws..."), span_notice("You start unscrewing [src]..."))
		if(tool.use_tool(src, user, 40, volume=50))
			user.visible_message(span_notice("[user] loosens [src]'s screws!"), span_notice("You unscrew [src], loosening it from the wall."))
			unscrewed = TRUE
	return TRUE

/obj/item/radio/intercom/wrench_act(mob/living/user, obj/item/tool)
	. = TRUE
	if(!unscrewed)
		to_chat(user, span_warning("You need to unscrew [src] from the wall first!"))
		return
	user.visible_message(span_notice("[user] starts unsecuring [src]..."), span_notice("You start unsecuring [src]..."))
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 80))
		user.visible_message(span_notice("[user] unsecures [src]!"), span_notice("You detach [src] from the wall."))
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		knock_down()

/**
 * Override attack_tk_grab instead of attack_tk because we actually want attack_tk's
 * functionality. What we DON'T want is attack_tk_grab attempting to pick up the
 * intercom as if it was an ordinary item.
 */
/obj/item/radio/intercom/attack_tk_grab(mob/user)
	interact(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/item/radio/intercom/attack_ai(mob/user)
	interact(user)

/obj/item/radio/intercom/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	interact(user)

/obj/item/radio/intercom/ui_state(mob/user)
	return GLOB.default_state

/obj/item/radio/intercom/can_receive(freq, list/levels)
	if(levels != RADIO_NO_Z_LEVEL_RESTRICTION)
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in levels))
			return FALSE

	if(freq == FREQ_SYNDICATE)
		if(!(syndie))
			return FALSE//Prevents broadcast of messages over devices lacking the encryption

	return TRUE

/obj/item/radio/intercom/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans, list/message_mods = list(), message_range)
	if(message_mods[RADIO_EXTENSION] == MODE_INTERCOM)
		return  // Avoid hearing the same thing twice
	return ..()

/obj/item/radio/intercom/emp_act(severity)
	. = ..() // Parent call here will set `on` to FALSE.
	update_appearance()

/obj/item/radio/intercom/end_emp_effect(curremp)
	. = ..()
	AreaPowerCheck() // Make sure the area/local APC is powered first before we actually turn back on.

/obj/item/radio/intercom/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()

	if(obj_flags & EMAGGED)
		return

	switch(freqlock)
		// Emagging an intercom with an emaggable lock will remove the lock
		if(RADIO_FREQENCY_EMAGGABLE_LOCK)
			balloon_alert(user, "frequency lock cleared")
			playsound(src, SFX_SPARKS, 75, TRUE, SILENCED_SOUND_EXTRARANGE)
			freqlock = RADIO_FREQENCY_UNLOCKED
			obj_flags |= EMAGGED
			return TRUE

		// A fully locked one will do nothing, as locked is intended to be used for stuff that should never be changed
		if(RADIO_FREQENCY_LOCKED)
			balloon_alert(user, "can't override frequency lock!")
			playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE, SILENCED_SOUND_EXTRARANGE)
			return

		// Emagging an unlocked one will do nothing, for now
		else
			return

/obj/item/radio/intercom/update_icon_state()
	icon_state = on ? initial(icon_state) : icon_off
	return ..()

/**
 * Proc called whenever the intercom's area loses or gains power. Responsible for setting the `on` variable and calling `update_icon()`.
 *
 * Normally called after the intercom's area receives the `COMSIG_AREA_POWER_CHANGE` signal, but it can also be called directly.
 * Arguments:
 * * source - the area that just had a power change.
 */
/obj/item/radio/intercom/proc/AreaPowerCheck(datum/source)
	SIGNAL_HANDLER
	var/area/current_area = get_area(src)
	if(!current_area)
		set_on(FALSE)
	else
		set_on(current_area.powered(AREA_USAGE_EQUIP)) // set "on" to the equipment power status of our area.
	update_appearance()

/**
 * Called by the wall mount component and reused during the tool deconstruction proc.
 */
/obj/item/radio/intercom/proc/knock_down()
	new/obj/item/wallframe/intercom(get_turf(src))
	qdel(src)

//Created through the autolathe or through deconstructing intercoms. Can be applied to wall to make a new intercom on it!
/obj/item/wallframe/intercom
	name = "无线电框架"
	desc = "一个随时可用的无线电，贴在墙上然后拧动螺栓！"
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "intercom"
	result_path = /obj/item/radio/intercom/unscrewed
	pixel_shift = 26
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.75, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.25)

MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom, 27)

/obj/item/radio/intercom/chapel
	name = "忏悔无线电"
	desc = "使用这个设备...来倾诉你犯下的诸多罪行吧,它能掩盖你的声音，确保你的秘密不被泄露."
	anonymize = TRUE
	freqlock = RADIO_FREQENCY_EMAGGABLE_LOCK

/obj/item/radio/intercom/chapel/Initialize(mapload, ndir, building)
	. = ..()
	set_frequency(1481)
	set_broadcasting(TRUE)

/obj/item/radio/intercom/command
	name = "指挥无线电"
	desc = "这是指挥部的特制自由频段无线电，它是一个多功能设备，可以调至任何频段，让你能够接入本无权访问的频道，此外，它还配备了内置语音放大器，确保通信清晰无误."
	icon_state = "intercom_command"
	freerange = TRUE
	command = TRUE
	icon_off = "intercom_command-p"

MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/prison, 27)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/chapel, 27)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/command, 27)
