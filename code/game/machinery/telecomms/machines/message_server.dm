// A decorational representation of SSblackbox, usually placed alongside the message server. Also contains a traitor theft item.
/obj/machinery/blackbox_recorder
	name = "黑匣子记录仪"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "blackbox"
	density = TRUE
	armor_type = /datum/armor/machinery_blackbox_recorder
	/// The object that's stored in the machine, which is to say, the blackbox itself.
	/// When it hasn't already been stolen, of course.
	var/obj/item/stored

/datum/armor/machinery_blackbox_recorder
	melee = 25
	bullet = 10
	laser = 10
	fire = 50
	acid = 70

/obj/machinery/blackbox_recorder/Initialize(mapload)
	. = ..()
	stored = new /obj/item/blackbox(src)

/obj/machinery/blackbox_recorder/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(stored)
		stored.forceMove(drop_location())
		if(Adjacent(user))
			user.put_in_hands(stored)
		stored = null
		to_chat(user, span_notice("你从[src]移除了黑匣子. 磁带停止了转动."))
		update_appearance()
		return
	else
		to_chat(user, span_warning("黑匣子不见了..."))
		return

/obj/machinery/blackbox_recorder/attackby(obj/item/attacking_item, mob/living/user, params)
	if(istype(attacking_item, /obj/item/blackbox))
		if(HAS_TRAIT(attacking_item, TRAIT_NODROP) || !user.transferItemToLoc(attacking_item, src))
			to_chat(user, span_warning("[attacking_item]粘在了你的手上!"))
			return
		user.visible_message(span_notice("[user]把[attacking_item]安进[src]!"), \
		span_notice("你将设备安进[src]. 磁带又开始转动."))
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		stored = attacking_item
		update_appearance()
		return
	return ..()

/obj/machinery/blackbox_recorder/Destroy()
	if(stored)
		stored.forceMove(loc)
		new /obj/effect/decal/cleanable/oil(loc)
	return ..()

/obj/machinery/blackbox_recorder/update_icon_state()
	icon_state = "blackbox[stored ? null : "_b"]"
	return ..()

/obj/item/blackbox
	name = "\proper 黑匣子"
	desc = "奇怪的“relic”, 能够记录超纬度至高点的数据，为了安全起见，它放在黑匣子记录仪里."
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "blackcube"
	inhand_icon_state = "blackcube"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF


/**
 * The equivalent of the server, for PDA and request console messages.
 * Without it, PDA and request console messages cannot be transmitted.
 * PDAs require the rest of the telecomms setup, but request consoles only
 * require the message server.
 */
/obj/machinery/telecomms/message_server
	name = "消息服务器"
	desc = "处理和路由PDA以及请求控制台消息的机器."
	icon_state = "message_server"
	telecomms_type = /obj/machinery/telecomms/message_server
	density = TRUE
	circuit = /obj/item/circuitboard/machine/telecomms/message_server

	/// A list of all the PDA messages that were intercepted and processed by
	/// this messaging server.
	var/list/datum/data_tablet_msg/pda_msgs = list()
	/// A list of all the Request Console messages that were intercepted and
	/// processed by this messaging server.
	var/list/datum/data_rc_msg/rc_msgs = list()
	/// The password of this messaging server.
	var/decryptkey = "password"
	/// Init reads this and adds world.time, then becomes 0 when that time has
	/// passed and the machine works.
	/// Basically, if it's not 0, it's calibrating and therefore non-functional.
	var/calibrating = 15 MINUTES


#define MESSAGE_SERVER_FUNCTIONING_MESSAGE "这是一条自动消息. 消息系统工作正常."

/obj/machinery/telecomms/message_server/Initialize(mapload)
	. = ..()
	if (calibrating)
		calibrating += world.time
		say("正在校准... 预计等待时间: [rand(3, 9)] 分钟.")
		pda_msgs += new /datum/data_tablet_msg("系统管理员", "系统", "这是一条自动消息. 系统校准开始于[station_time_timestamp()].")
	else
		pda_msgs += new /datum/data_tablet_msg("系统管理员", "系统", MESSAGE_SERVER_FUNCTIONING_MESSAGE)

/obj/machinery/telecomms/message_server/Destroy()
	for(var/obj/machinery/computer/message_monitor/monitor in GLOB.telecomms_list)
		if(monitor.linkedServer && monitor.linkedServer == src)
			monitor.linkedServer = null
	. = ..()

/obj/machinery/telecomms/message_server/examine(mob/user)
	. = ..()
	if(calibrating)
		. += span_warning("它仍在校准中.")

/obj/machinery/telecomms/message_server/process()
	. = ..()
	if(calibrating && calibrating <= world.time)
		calibrating = 0
		pda_msgs += new /datum/data_tablet_msg("系统管理员", "系统", MESSAGE_SERVER_FUNCTIONING_MESSAGE)

#undef MESSAGE_SERVER_FUNCTIONING_MESSAGE

/obj/machinery/telecomms/message_server/receive_information(datum/signal/subspace/messaging/signal, obj/machinery/telecomms/machine_from)
	// can't log non-message signals
	if(!istype(signal) || !signal.data["message"] || !on || calibrating)
		return

	// log the signal
	if(istype(signal, /datum/signal/subspace/messaging/tablet_message))
		var/datum/signal/subspace/messaging/tablet_message/PDAsignal = signal
		var/datum/data_tablet_msg/log_message = new(PDAsignal.format_target(), PDAsignal.format_sender(), PDAsignal.format_message(), PDAsignal.format_photo_path())
		pda_msgs += log_message
	else if(istype(signal, /datum/signal/subspace/messaging/rc))
		var/datum/data_rc_msg/msg = new(signal.data["receiving_department"], signal.data["sender_department"], signal.data["message"], signal.data["stamped"], signal.data["verified"], signal.data["priority"])
		if(signal.data["sender_department"]) // don't log messages not from a department but allow them to work
			rc_msgs += msg
	signal.data["reject"] = FALSE

	// pass it along to either the hub or the broadcaster
	if(!relay_information(signal, /obj/machinery/telecomms/hub))
		relay_information(signal, /obj/machinery/telecomms/broadcaster)

/obj/machinery/telecomms/message_server/update_overlays()
	. = ..()

	if(calibrating)
		. += "message_server_calibrate"

// Preset messaging server
/obj/machinery/telecomms/message_server/preset
	id = "消息服务器"
	network = "tcommsat"
	autolinkers = list("messaging")
	calibrating = 0

GLOBAL_VAR(preset_station_message_server_key)

/obj/machinery/telecomms/message_server/preset/Initialize(mapload)
	. = ..()
	// Just in case there are multiple preset messageservers somehow once the CE arrives,
	// we want those on the station to share the same preset default decrypt key shown in his memories.
	var/is_on_station = is_station_level(z)
	if(is_on_station && GLOB.preset_station_message_server_key)
		decryptkey = GLOB.preset_station_message_server_key
		return
	//Generate a random password for the message server
	decryptkey = pick("此", "如果", "之", "因为", "之于", "双", "你我", "来自", "去往", "单", "也", "微小", "落雪", "死亡", "醉酒", "玫瑰", "小鸭", "哎", "嘞")
	decryptkey += pick("钻石", "狗熊", "蘑菇", "助手", "小丑", "舰长", "蛋糕", "安保", "核武", "小", "大", "撤离", "明黄", "手套", "猿猴", "引擎", "核弹", "AI")
	decryptkey += "[rand(0, 9)]"
	if(is_on_station)
		GLOB.preset_station_message_server_key = decryptkey

// Root messaging signal datum
/datum/signal/subspace/messaging
	frequency = FREQ_COMMON
	server_type = /obj/machinery/telecomms/message_server

/datum/signal/subspace/messaging/New(init_source, init_data)
	source = init_source
	data = init_data
	var/turf/origin_turf = get_turf(source)
	levels = SSmapping.get_connected_levels(origin_turf)
	if(!("reject" in data))
		data["reject"] = TRUE

/datum/signal/subspace/messaging/copy()
	var/datum/signal/subspace/messaging/copy = new type(source, data.Copy())
	copy.original = src
	copy.levels = levels
	return copy

// Tablet message signal datum
/// Returns a string representing the target of this message, formatted properly.
/datum/signal/subspace/messaging/tablet_message/proc/format_target()
	if (data["everyone"])
		return "每个人"

	var/datum/computer_file/program/messenger/target_app = data["targets"][1]
	var/obj/item/modular_computer/target = target_app.computer
	return STRINGIFY_PDA_TARGET(target.saved_identification, target.saved_job)

/// Returns a string representing the sender of this message, formatted properly.
/datum/signal/subspace/messaging/tablet_message/proc/format_sender()
	var/display_name = get_messenger_name(locate(data["ref"]))
	return display_name ? display_name : STRINGIFY_PDA_TARGET(data["fakename"], data["fakejob"])

/// Returns the formatted message contained in this message. Use this to apply
/// any processing to it if it needs to be formatted in a specific way.
/datum/signal/subspace/messaging/tablet_message/proc/format_message()
	return data["message"]

/// Returns the formatted photo path contained in this message, if there's one.
/datum/signal/subspace/messaging/tablet_message/proc/format_photo_path()
	return data["photo"]

/datum/signal/subspace/messaging/tablet_message/broadcast()
	for (var/datum/computer_file/program/messenger/app in data["targets"])
		if(!QDELETED(app))
			app.receive_message(src)

// Request Console signal datum
/datum/signal/subspace/messaging/rc/broadcast()
	var/recipient_department = ckey(data["recipient_department"])
	for (var/obj/machinery/requests_console/console in GLOB.req_console_all)
		if(ckey(console.department) == recipient_department || (data["ore_update"] && console.receive_ore_updates))
			console.create_message(data)

/// Log datums stored by the message server.
/datum/data_tablet_msg
	/// Who sent the message.
	var/sender = "未指定"
	/// Who was targeted by the message.
	var/recipient = "未指定"
	/// The transfered message.
	var/message = "空白"
	/// The attached photo path, if any.
	var/picture_asset_key
	/// Whether or not it's an automated message. Defaults to `FALSE`.
	var/automated = FALSE


/datum/data_tablet_msg/New(param_rec, param_sender, param_message, param_photo)
	if(param_rec)
		recipient = param_rec
	if(param_sender)
		sender = param_sender
	if(param_message)
		message = param_message
	if(param_photo)
		picture_asset_key = param_photo


#define REQUEST_PRIORITY_NORMAL "正常"
#define REQUEST_PRIORITY_HIGH "高"
#define REQUEST_PRIORITY_EXTREME "极度"
#define REQUEST_PRIORITY_UNDETERMINED "未确定"


/datum/data_rc_msg
	/// The department that sent the request.
	var/sender_department = "未指定"
	/// The department that was targeted by the request.
	var/receiving_department = "未指定"
	/// The message of the request.
	var/message = "空白"
	/// The stamp that authenticated this message, if any.
	var/stamp = "未盖章的"
	/// The ID that authenticated this message, if any.
	var/id_auth = "未经验证的"
	/// The priority of this request.
	var/priority = REQUEST_PRIORITY_NORMAL

/datum/data_rc_msg/New(param_rec, param_sender, param_message, param_stamp, param_id_auth, param_priority)
	if(param_rec)
		receiving_department = param_rec
	if(param_sender)
		sender_department = param_sender
	if(param_message)
		message = param_message
	if(param_stamp)
		stamp = param_stamp
	if(param_id_auth)
		id_auth = param_id_auth
	if(param_priority)
		switch(param_priority)
			if(REQ_NORMAL_MESSAGE_PRIORITY)
				priority = REQUEST_PRIORITY_NORMAL
			if(REQ_HIGH_MESSAGE_PRIORITY)
				priority = REQUEST_PRIORITY_HIGH
			if(REQ_EXTREME_MESSAGE_PRIORITY)
				priority = REQUEST_PRIORITY_EXTREME
			else
				priority = REQUEST_PRIORITY_UNDETERMINED

#undef REQUEST_PRIORITY_NORMAL
#undef REQUEST_PRIORITY_HIGH
#undef REQUEST_PRIORITY_EXTREME
#undef REQUEST_PRIORITY_UNDETERMINED
