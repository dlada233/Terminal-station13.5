/obj/machinery/computer/security/telescreen
	name = "\improper 监控屏"
	desc = "用于观看空旷的竞技场."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "telescreen"
	icon_keyboard = null
	icon_screen = null
	layer = SIGN_LAYER
	network = list(CAMERANET_NETWORK_THUNDERDOME)
	density = FALSE
	circuit = null
	light_power = 0
	/// The kind of wallframe that this telescreen drops
	var/frame_type = /obj/item/wallframe/telescreen

/obj/item/wallframe/telescreen
	name = "监控屏框架"
	desc = "壁挂式的监控屏框架."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "telescreen"
	result_path = /obj/machinery/computer/security/telescreen
	pixel_shift = 32

/obj/machinery/computer/security/telescreen/on_deconstruction(disassembled)
	new frame_type(loc)

/obj/machinery/computer/security/telescreen/update_icon_state()
	icon_state = initial(icon_state)
	if(machine_stat & BROKEN)
		icon_state += "b"
	return ..()

/obj/machinery/computer/security/telescreen/entertainment
	name = "观影屏"
	desc = "妈的, 这东西最好有 /tg/ 频道可看."
	icon = 'icons/obj/machines/status_display.dmi'
	icon_state = "entertainment_blank"
	network = list()
	density = FALSE
	circuit = null
	interaction_flags_atom = INTERACT_ATOM_UI_INTERACT | INTERACT_ATOM_NO_FINGERPRINT_INTERACT | INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND | INTERACT_MACHINE_REQUIRES_SIGHT
	frame_type = /obj/item/wallframe/telescreen/entertainment
	var/icon_state_off = "entertainment_blank"
	var/icon_state_on = "entertainment"

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/computer/security/telescreen/entertainment, 32)

/obj/item/wallframe/telescreen/entertainment
	name = "观影屏框架"
	icon = 'icons/obj/machines/status_display.dmi'
	icon_state = "entertainment_blank"
	result_path = /obj/machinery/computer/security/telescreen/entertainment

/obj/machinery/computer/security/telescreen/entertainment/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_CLICK, PROC_REF(BigClick))
	find_and_hang_on_wall()

// Bypass clickchain to allow humans to use the telescreen from a distance
/obj/machinery/computer/security/telescreen/entertainment/proc/BigClick()
	SIGNAL_HANDLER

	if(!network.len)
		balloon_alert(usr, "nothing on TV!")
		return

	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, interact), usr)

///Sets the monitor's icon to the selected state, and says an announcement
/obj/machinery/computer/security/telescreen/entertainment/proc/notify(on, announcement)
	if(on && icon_state == icon_state_off)
		icon_state = icon_state_on
	else
		icon_state = icon_state_off
	if(announcement)
		say(announcement)

/// Adds a camera network ID to the entertainment monitor, and turns off the monitor if network list is empty
/obj/machinery/computer/security/telescreen/entertainment/proc/update_shows(is_show_active, tv_show_id, announcement)
	if(!network)
		return

	if(is_show_active)
		network |= tv_show_id
	else
		network -= tv_show_id

	notify(network.len, announcement)

/**
 * Adds a camera network to all entertainment monitors.
 *
 * * camera_net - The camera network ID to add to the monitors.
 * * announcement - Optional, what announcement to make when the show starts.
 */
/proc/start_broadcasting_network(camera_net, announcement)
	for(var/obj/machinery/computer/security/telescreen/entertainment/tv as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/computer/security/telescreen/entertainment))
		tv.update_shows(
			is_show_active = TRUE,
			tv_show_id = camera_net,
			announcement = announcement,
		)

/**
 * Removes a camera network from all entertainment monitors.
 *
 * * camera_net - The camera network ID to remove from the monitors.
 * * announcement - Optional, what announcement to make when the show ends.
 */
/proc/stop_broadcasting_network(camera_net, announcement)
	for(var/obj/machinery/computer/security/telescreen/entertainment/tv as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/computer/security/telescreen/entertainment))
		tv.update_shows(
			is_show_active = FALSE,
			tv_show_id = camera_net,
			announcement = announcement,
		)

/**
 * Sets the camera network status on all entertainment monitors.
 * A way to force a network to a status if you are unsure of the current state.
 *
 * * camera_net - The camera network ID to set on the monitors.
 * * is_show_active - Whether the show is active or not.
 * * announcement - Optional, what announcement to make.
 * Note this announcement will be made regardless of the current state of the show:
 * This means if it's currently on and you set it to on, the announcement will still be made.
 * Likewise, there's no way to differentiate off -> on and on -> off, unless you handle that yourself.
 */
/proc/set_network_broadcast_status(camera_net, is_show_active, announcement)
	for(var/obj/machinery/computer/security/telescreen/entertainment/tv as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/computer/security/telescreen/entertainment))
		tv.update_shows(
			is_show_active = is_show_active,
			tv_show_id = camera_net,
			announcement = announcement,
		)

/obj/machinery/computer/security/telescreen/rd
	name = "\improper 科研主管的监控屏"
	desc = "用来在安全的办公室监视AI和科研部门的怪胎们."
	network = list(
		CAMERANET_NETWORK_RD,
		CAMERANET_NETWORK_AI_CORE,
		CAMERANET_NETWORK_AI_UPLOAD,
		CAMERANET_NETWORK_MINISAT,
		CAMERANET_NETWORK_XENOBIOLOGY,
		CAMERANET_NETWORK_TEST_CHAMBER,
		CAMERANET_NETWORK_ORDNANCE,
	)
	frame_type = /obj/item/wallframe/telescreen/rd

/obj/item/wallframe/telescreen/rd
	name = "\improper 科研主管监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/rd

/obj/machinery/computer/security/telescreen/research
	name = "科研监控屏"
	desc = "可以接入科研部门摄像头网络的监控屏."
	network = list(CAMERANET_NETWORK_RD)
	frame_type = /obj/item/wallframe/telescreen/research

/obj/item/wallframe/telescreen/research
	name = "科研监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/research

/obj/machinery/computer/security/telescreen/ce
	name = "\improper 工程部长的监控屏"
	desc = "用于监控发电引擎，电信以及迷你卫星."
	network = list(CAMERANET_NETWORK_ENGINE, CAMERANET_NETWORK_TELECOMMS, CAMERANET_NETWORK_MINISAT)
	frame_type = /obj/item/wallframe/telescreen/ce

/obj/item/wallframe/telescreen/ce
	name = "\improper 工程部长监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/ce

/obj/machinery/computer/security/telescreen/cmo
	name = "\improper 医疗部长的监控屏"
	desc = "用于访问医疗部门摄像头网络."
	network = list(CAMERANET_NETWORK_MEDBAY)
	frame_type = /obj/item/wallframe/telescreen/cmo

/obj/item/wallframe/telescreen/cmo
	name = "\improper 医疗部长监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/cmo

/obj/machinery/computer/security/telescreen/vault
	name = "金库监控屏"
	desc = "可以访问金库内的摄像头."
	network = list(CAMERANET_NETWORK_VAULT)
	frame_type = /obj/item/wallframe/telescreen/vault

/obj/item/wallframe/telescreen/vault
	name = "金库监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/vault

/obj/machinery/computer/security/telescreen/ordnance
	name = "炸弹试验场地监控屏"
	desc = "可以访问炸弹试验场地内的摄像头."
	network = list(CAMERANET_NETWORK_ORDNANCE)
	frame_type = /obj/item/wallframe/telescreen/ordnance

/obj/item/wallframe/telescreen/ordnance
	name = "炸弹试验场地监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/ordnance

/obj/machinery/computer/security/telescreen/engine
	name = "发电引擎监控屏"
	desc = "可以访问发电引擎摄像头的监控屏."
	network = list(CAMERANET_NETWORK_ENGINE)
	frame_type = /obj/item/wallframe/telescreen/engine

/obj/item/wallframe/telescreen/engine
	name = "发电引擎监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/engine

/obj/machinery/computer/security/telescreen/turbine
	name = "涡轮机监控屏"
	desc = "可以访问涡轮机摄像头的监控屏."
	network = list(CAMERANET_NETWORK_TURBINE)
	frame_type = /obj/item/wallframe/telescreen/turbine

/obj/item/wallframe/telescreen/turbine
	name = "涡轮机监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/turbine

/obj/machinery/computer/security/telescreen/interrogation
	name = "审讯室监控屏"
	desc = "用来访问审讯室内的摄像头."
	network = list(CAMERANET_NETWORK_INTERROGATION)
	frame_type = /obj/item/wallframe/telescreen/interrogation

/obj/item/wallframe/telescreen/interrogation
	name = "审讯室监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/interrogation

/obj/machinery/computer/security/telescreen/prison
	name = "监狱监控屏"
	desc = "用来访问监狱摄像头."
	network = list(CAMERANET_NETWORK_PRISON)
	frame_type = /obj/item/wallframe/telescreen/prison

/obj/item/wallframe/telescreen/prison
	name = "监狱监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/prison

/obj/machinery/computer/security/telescreen/auxbase
	name = "辅助基地监控屏"
	desc = "用于访问辅助基地的摄像头."
	network = list(CAMERANET_NETWORK_AUXBASE)
	frame_type = /obj/item/wallframe/telescreen/auxbase

/obj/item/wallframe/telescreen/auxbase
	name = "辅助基地监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/auxbase

/obj/machinery/computer/security/telescreen/minisat
	name = "迷你卫星监控屏"
	desc = "用于访问迷你卫星的摄像头."
	network = list(CAMERANET_NETWORK_MINISAT)
	frame_type = /obj/item/wallframe/telescreen/minisat

/obj/item/wallframe/telescreen/minisat
	name = "迷你卫星监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/minisat

/obj/machinery/computer/security/telescreen/aiupload
	name = "\improper AI上传监控屏"
	desc = "用于访问AI上传摄像头."
	network = list(CAMERANET_NETWORK_AI_UPLOAD)
	frame_type = /obj/item/wallframe/telescreen/aiupload

/obj/item/wallframe/telescreen/aiupload
	name = "\improper AI上传监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/aiupload

/obj/machinery/computer/security/telescreen/bar
	name = "酒吧监控屏"
	desc = "用于访问酒吧内摄像头."
	network = list(CAMERANET_NETWORK_BAR)
	frame_type = /obj/item/wallframe/telescreen/bar

/obj/item/wallframe/telescreen/bar
	name = "酒吧监控屏框架"
	result_path = /obj/machinery/computer/security/telescreen/bar


/// A button that adds a camera network to the entertainment monitors
/obj/machinery/button/showtime
	name = "雷霆竞技场开播按钮"
	desc = "按下按钮允许观影屏开始播放大型比赛."
	device_type = /obj/item/assembly/control/showtime
	req_access = list()
	id = "showtime_1"

/obj/machinery/button/showtime/Initialize(mapload)
	. = ..()
	if(device)
		var/obj/item/assembly/control/showtime/ours = device
		ours.id = id

/obj/item/assembly/control/showtime
	name = "开播控制器"
	desc = "用于远程控制观影屏."
	/// Stores if the show associated with this controller is active or not
	var/is_show_active = FALSE
	/// The camera network id this controller toggles
	var/tv_network_id = "thunder"
	/// The display TV show name
	var/tv_show_name = "雷霆竞技场"
	/// List of phrases the entertainment console may say when the show begins
	var/list/tv_starters = list(
		"勇敢的壮举在雷霆竞技场上演!",
		"两边人进去，只有一边出来! 现在加入观看!",
		"你从未见过的暴力!",
		"场景! 镜头! 观众! 现在加入观看!",
	)
	/// List of phrases the entertainment console may say when the show ends
	var/list/tv_enders = list(
		"感谢您收看这场厮杀!",
		"多么精彩!我们保证下一场会更好!",
		"为雷霆竞技场之战欢庆吧!",
		"这场表演由纳米传讯冠名播出.",
	)

/obj/item/assembly/control/showtime/activate()
	is_show_active = !is_show_active
	say("[tv_show_name]节目[is_show_active ? "开始了" : "结束了"]")
	var/announcement = is_show_active ? pick(tv_starters) : pick(tv_enders)
	set_network_broadcast_status(tv_network_id, is_show_active, announcement)
