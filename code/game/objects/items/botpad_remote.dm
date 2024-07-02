/obj/item/botpad_remote
	name = "机器人发射板控制器"
	desc = "使用此装置控制连接的机器人平台."
	desc_controls = "左键发射，右键召回."
	icon = 'icons/obj/devices/remote.dmi'
	icon_state = "botpad_controller"
	w_class = WEIGHT_CLASS_SMALL
	// ID of the remote, used for linking up
	var/id = "botlauncher"
	var/obj/machinery/botpad/connected_botpad

/obj/item/botpad_remote/Destroy()
	if(connected_botpad)
		connected_botpad.connected_remote = null
		connected_botpad = null
	return ..()

/obj/item/botpad_remote/attack_self(mob/living/user)
	playsound(src, SFX_TERMINAL_TYPE, 25, FALSE)
	try_launch(user)
	return

/obj/item/botpad_remote/attack_self_secondary(mob/living/user)
	playsound(src, SFX_TERMINAL_TYPE, 25, FALSE)
	if(connected_botpad)
		connected_botpad.recall(user)
		return
	user?.balloon_alert(user, "未连接机器人发射板!")
	return

/obj/item/botpad_remote/multitool_act(mob/living/user, obj/item/tool)
	if(!multitool_check_buffer(user, tool))
		return
	var/obj/item/multitool/multitool = tool
	if(istype(multitool.buffer, /obj/machinery/botpad))
		var/obj/machinery/botpad/buffered_remote = multitool.buffer
		if(buffered_remote == connected_botpad)
			to_chat(user, span_warning("控制器无法连接到已连接的机器人发射板!"))
		else if(!connected_botpad && istype(buffered_remote, /obj/machinery/botpad))
			connected_botpad = buffered_remote
			connected_botpad.connected_remote = src
			connected_botpad.id = id
			multitool.set_buffer(null)
			to_chat(user, span_notice("你将控制器连接到[multitool.name]数据缓冲区的机器人发射板."))
		else
			to_chat(user, span_warning("无法上传数据!"))

/obj/item/botpad_remote/proc/try_launch(mob/living/user)
	if(!connected_botpad)
		user?.balloon_alert(user, "未连接机器人发射板!")
		return
	if(connected_botpad.panel_open)
		user?.balloon_alert(user, "先关闭面板!")
		return
	if(!(locate(/mob/living) in get_turf(connected_botpad)))
		user?.balloon_alert(user, "发射板上未检测到机器人!")
		return
	connected_botpad.launch(user)
