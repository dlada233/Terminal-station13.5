GLOBAL_LIST_EMPTY(announcement_systems)

/obj/machinery/announcement_system
	density = TRUE
	name = "\improper 自动公告系统"
	desc = "一种自动广播系统，通过无线电处理小范围广播."
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "AAS_On"
	base_icon_state = "AAS"

	verb_say = "coldly states"
	verb_ask = "queries"
	verb_exclaim = "alarms"

	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.05

	circuit = /obj/item/circuitboard/machine/announcement_system

	var/obj/item/radio/headset/radio
	var/arrival = "%PERSON 现已作为 %RANK 参与工作."
	var/arrivalToggle = 1
	var/newhead = "%PERSON, %RANK, 是部门部长."
	var/newheadToggle = 1

	var/greenlight = "Light_Green"
	var/pinklight = "Light_Pink"
	var/errorlight = "Error_Red"

/obj/machinery/announcement_system/Initialize(mapload)
	. = ..()
	GLOB.announcement_systems += src
	radio = new /obj/item/radio/headset/silicon/ai(src)
	update_appearance()

/obj/machinery/announcement_system/update_icon_state()
	icon_state = "[base_icon_state]_[is_operational ? "On" : "Off"][panel_open ? "_Open" : null]"
	return ..()

/obj/machinery/announcement_system/update_overlays()
	. = ..()
	if(arrivalToggle)
		. += greenlight

	if(newheadToggle)
		. += pinklight

	if(machine_stat & BROKEN)
		. += errorlight

/obj/machinery/announcement_system/Destroy()
	QDEL_NULL(radio)
	GLOB.announcement_systems -= src //"OH GOD WHY ARE THERE 100,000 LISTED ANNOUNCEMENT SYSTEMS?!!"
	return ..()

/obj/machinery/announcement_system/screwdriver_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	toggle_panel_open()
	to_chat(user, span_notice("你[panel_open ? "打开" : "关上"][src]的检修舱口."))
	update_appearance()
	return TRUE

/obj/machinery/announcement_system/crowbar_act(mob/living/user, obj/item/tool)
	if(default_deconstruction_crowbar(tool))
		return TRUE

/obj/machinery/announcement_system/multitool_act(mob/living/user, obj/item/tool)
	if(!panel_open || !(machine_stat & BROKEN))
		return FALSE
	to_chat(user, span_notice("你重置了[src]的固件."))
	set_machine_stat(machine_stat & ~BROKEN)
	update_appearance()

/obj/machinery/announcement_system/proc/CompileText(str, user, rank) //replaces user-given variables with actual thingies.
	str = replacetext(str, "%PERSON", "[user]")
	str = replacetext(str, "%RANK", "[rank]")
	return str

/obj/machinery/announcement_system/proc/announce(message_type, user, rank, list/channels)
	if(!is_operational)
		return

	var/message

	if(message_type == "ARRIVAL" && arrivalToggle)
		message = CompileText(arrival, user, rank)
	else if(message_type == "NEWHEAD" && newheadToggle)
		message = CompileText(newhead, user, rank)
	else if(message_type == "ARRIVALS_BROKEN")
		message = "登站班轮已损坏. 正在停靠进行维修..."

	broadcast(message, channels)

/// Announces a new security officer joining over the radio
/obj/machinery/announcement_system/proc/announce_officer(mob/officer, department)
	if (!is_operational)
		return

	broadcast("官员 [officer.real_name] 已被指派到 [department].", list(RADIO_CHANNEL_SECURITY))

/// Sends a message to the appropriate channels.
/obj/machinery/announcement_system/proc/broadcast(message, list/channels)
	use_energy(active_power_usage)
	if(channels.len == 0)
		radio.talk_into(src, message, null)
	else
		for(var/channel in channels)
			radio.talk_into(src, message, channel)

/obj/machinery/announcement_system/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AutomatedAnnouncement")
		ui.open()

/obj/machinery/announcement_system/ui_data()
	var/list/data = list()
	data["arrival"] = arrival
	data["arrivalToggle"] = arrivalToggle
	data["newhead"] = newhead
	data["newheadToggle"] = newheadToggle
	return data

/obj/machinery/announcement_system/ui_act(action, param)
	. = ..()
	if(.)
		return
	if(!usr.can_perform_action(src, ALLOW_SILICON_REACH))
		return
	if(machine_stat & BROKEN)
		visible_message(span_warning("[src]嗡嗡响."), span_hear("你听到微弱的嗡嗡声."))
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, TRUE)
		return
	switch(action)
		if("ArrivalText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.can_perform_action(src, ALLOW_SILICON_REACH))
				return
			if(NewMessage)
				arrival = NewMessage
				usr.log_message("updated the arrivals announcement to: [NewMessage]", LOG_GAME)
		if("NewheadText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.can_perform_action(src, ALLOW_SILICON_REACH))
				return
			if(NewMessage)
				newhead = NewMessage
				usr.log_message("updated the head announcement to: [NewMessage]", LOG_GAME)
		if("NewheadToggle")
			newheadToggle = !newheadToggle
			update_appearance()
		if("ArrivalToggle")
			arrivalToggle = !arrivalToggle
			update_appearance()
	add_fingerprint(usr)

/obj/machinery/announcement_system/attack_robot(mob/living/silicon/user)
	. = attack_ai(user)

/obj/machinery/announcement_system/attack_ai(mob/user)
	if(!user.can_perform_action(src, ALLOW_SILICON_REACH))
		return
	if(machine_stat & BROKEN)
		to_chat(user, span_warning("[src]的固件似乎出现故障!"))
		return
	interact(user)

/obj/machinery/announcement_system/proc/act_up() //does funny breakage stuff
	if(!atom_break()) // if badmins flag this unbreakable or its already broken
		return

	arrival = pick("#!@%ERR-34%2 无法定位到@# JO# F*LE!", "严重错误 99.", "ERR)#: DA#AB@#E NOT F(*ND!")
	newhead = pick("OV#RL()D: \[UNKNOWN??\] DET*#CT)D!", "ER)#R - B*@ TEXT F*O(ND!", "AAS.exe 未响应. NanoOS 正在检索解决方案.")

/obj/machinery/announcement_system/emp_act(severity)
	. = ..()
	if(!(machine_stat & (NOPOWER|BROKEN)) && !(. & EMP_PROTECT_SELF))
		act_up()

/obj/machinery/announcement_system/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	act_up()
	balloon_alert(user, "公告字符串已损坏")
	return TRUE
