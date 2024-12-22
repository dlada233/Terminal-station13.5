/mob/verb/pray(msg as text)
	set category = "IC.动作"
	set name = "祈祷"

	if(GLOB.say_disabled) //This is here to try to identify lag problems
		to_chat(usr, span_danger("当前说话被管理员禁止."), confidential = TRUE)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return
	log_prayer("[src.key]/([src.name]): [msg]")
	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			to_chat(usr, span_danger("你无法祈祷 (被禁言)."), confidential = TRUE)
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	var/mutable_appearance/cross = mutable_appearance('icons/obj/storage/book.dmi', "bible")
	var/font_color = "purple"
	var/prayer_type = "祈祷"
	var/deity
	if(usr.job == JOB_CHAPLAIN)
		cross.icon_state = "kingyellow"
		font_color = "blue"
		prayer_type = "牧师祈祷"
		if(GLOB.deity)
			deity = GLOB.deity
	else if(IS_CULTIST(usr))
		cross.icon_state = "tome"
		font_color = "red"
		prayer_type = "血教徒祈祷"
		deity = "Nar'Sie"
	else if(isliving(usr))
		var/mob/living/L = usr
		if(HAS_TRAIT(L, TRAIT_SPIRITUAL))
			cross.icon_state = "holylight"
			font_color = "blue"
			prayer_type = "虔诚者祈祷"

	var/msg_tmp = msg
	GLOB.requests.pray(usr.client, msg, usr.job == JOB_CHAPLAIN)
	msg = span_adminnotice("[icon2html(cross, GLOB.admins)]<b><font color=[font_color]>[prayer_type][deity ? " (向[deity])" : ""]: </font>[ADMIN_FULLMONTY(src)] [ADMIN_SC(src)]:</b> [span_linkify(msg)]")
	for(var/client/C in GLOB.admins)
		if(get_chat_toggles(C) & CHAT_PRAYER)
			to_chat(C, msg, type = MESSAGE_TYPE_PRAYER, confidential = TRUE)
	to_chat(usr, span_info("你向神祈祷: \"[msg_tmp]\""), confidential = TRUE)

	BLACKBOX_LOG_ADMIN_VERB("Prayer")


/// Used by communications consoles to message CentCom
/proc/message_centcom(text, mob/sender)
	var/msg = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	GLOB.requests.message_centcom(sender.client, msg)
	msg = span_adminnotice("<b><font color=orange>CENTCOM:</font>[ADMIN_FULLMONTY(sender)] [ADMIN_CENTCOM_REPLY(sender)]:</b> [msg]")
	for(var/client/staff as anything in GLOB.admins)
		if(staff?.prefs.read_preference(/datum/preference/toggle/comms_notification))
			SEND_SOUND(staff, sound('sound/misc/server-ready.ogg'))
	to_chat(GLOB.admins, msg, confidential = TRUE)
	for(var/obj/machinery/computer/communications/console in GLOB.shuttle_caller_list)
		console.override_cooldown()

/// Used by communications consoles to message the Syndicate
/proc/message_syndicate(text, mob/sender)
	var/msg = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	GLOB.requests.message_syndicate(sender.client, msg)
	msg = span_adminnotice("<b><font color=crimson>SYNDICATE:</font>[ADMIN_FULLMONTY(sender)] [ADMIN_SYNDICATE_REPLY(sender)]:</b> [msg]")
	for(var/client/staff as anything in GLOB.admins)
		if(staff?.prefs.read_preference(/datum/preference/toggle/comms_notification))
			SEND_SOUND(staff, sound('sound/misc/server-ready.ogg'))
	to_chat(GLOB.admins, msg, confidential = TRUE)
	for(var/obj/machinery/computer/communications/console in GLOB.shuttle_caller_list)
		console.override_cooldown()

/// Used by communications consoles to request the nuclear launch codes
/proc/nuke_request(text, mob/sender)
	var/msg = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	GLOB.requests.nuke_request(sender.client, msg)
	msg = span_adminnotice("<b><font color=orange>核代码请求:</font>[ADMIN_FULLMONTY(sender)] [ADMIN_CENTCOM_REPLY(sender)] [ADMIN_SET_SD_CODE]:</b> [msg]")
	for(var/client/staff as anything in GLOB.admins)
		SEND_SOUND(staff, sound('sound/misc/server-ready.ogg'))
	to_chat(GLOB.admins, msg, confidential = TRUE)
	for(var/obj/machinery/computer/communications/console in GLOB.shuttle_caller_list)
		console.override_cooldown()
