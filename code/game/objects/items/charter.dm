/obj/item/station_charter
	name = "空间站宪章"
	icon = 'icons/obj/scrolls.dmi'
	icon_state = "charter"
	desc = "一份官方文件，赋予舰长对空间站及其周边空间的治理权."
	var/used = FALSE
	var/name_type = "station"

	var/unlimited_uses = FALSE
	var/ignores_timeout = FALSE
	var/response_timer_id = null
	var/approval_time = 600

	var/static/regex/standard_station_regex

/obj/item/station_charter/Initialize(mapload)
	. = ..()
	if(!standard_station_regex)
		var/prefixes = jointext(GLOB.station_prefixes, "|")
		var/names = jointext(GLOB.station_names, "|")
		var/suffixes = jointext(GLOB.station_suffixes, "|")
		var/numerals = jointext(GLOB.station_numerals, "|")
		var/regexstr = "^(([prefixes]) )?(([names]) ?)([suffixes]) ([numerals])$"
		standard_station_regex = new(regexstr)

/obj/item/station_charter/attack_self(mob/living/user)
	if(used)
		to_chat(user, span_warning("[name_type]已经被命名了!"))
		return
	if(!ignores_timeout && (world.time-SSticker.round_start_time > STATION_RENAME_TIME_LIMIT)) //5 minutes
		to_chat(user, span_warning("船员已经进入工作状态了，现在重命名[name_type]可能不太好."))
		return
	if(response_timer_id)
		to_chat(user, span_warning("还在等待公司高层批准你的改名申请."))
		return

	var/new_name = tgui_input_text(user, "你想给[station_name()]重新取名吗？ \
		请注意，特别糟糕的名字可能会被公司高层拒绝； \
		而符合标准格式的名字将 \
		被自动批准.", "Station Name", max_length = MAX_CHARTER_LEN)

	if(response_timer_id)
		to_chat(user, span_warning("还在等待公司高层批准你改名的申请."))
		return

	if(!new_name)
		return
	user.log_message("已申请将该站命名为 \
		[new_name]", LOG_GAME)

	if(standard_station_regex.Find(new_name))
		to_chat(user, span_notice("你的改名申请已经被自动批准."))
		rename_station(new_name, user.name, user.real_name, key_name(user))
		return

	to_chat(user, span_notice("你的改名申请已经发往公司高层等待批准了."))
	// Autoapproves after a certain time
	response_timer_id = addtimer(CALLBACK(src, PROC_REF(rename_station), new_name, user.name, user.real_name, key_name(user)), approval_time, TIMER_STOPPABLE)
	to_chat(GLOB.admins, span_adminnotice("<b><font color=orange>站点重命名:</font></b>[ADMIN_LOOKUPFLW(user)] 申请将 [name_type] 改名为 [new_name] (will autoapprove in [DisplayTimeText(approval_time)]). [ADMIN_SMITE(user)] (<A HREF='?_src_=holder;[HrefToken(forceGlobal = TRUE)];reject_custom_name=[REF(src)]'>REJECT</A>) [ADMIN_CENTCOM_REPLY(user)]"))
	for(var/client/admin_client in GLOB.admins)
		if(admin_client.prefs.toggles & SOUND_ADMINHELP)
			window_flash(admin_client, ignorepref = TRUE)
			SEND_SOUND(admin_client, sound('sound/effects/gong.ogg'))

/obj/item/station_charter/proc/reject_proposed(user)
	if(!user)
		return
	if(!response_timer_id)
		return
	var/turf/T = get_turf(src)
	T.visible_message("<span class='warning'>改名申请已从 \
		[src]消失; 看起来是被驳回了.</span>")
	var/m = "[key_name(user)] 已驳回改名申请."

	message_admins(m)
	log_admin(m)

	deltimer(response_timer_id)
	response_timer_id = null

/obj/item/station_charter/proc/rename_station(designation, uname, ureal_name, ukey)
	set_station_name(designation)
	minor_announce("[ureal_name] 已将站点更名为 [html_decode(station_name())]", "舰长诏曰") //decode station_name to avoid minor_announce double encode
	log_game("[ukey] has renamed the station as [station_name()].")

	name = "[station_name()]的空间站宪章"
	desc = "一份官方文件, \
		将[station_name()]以及周围区域的治理委托给舰长[uname]."
	SSblackbox.record_feedback("text", "station_renames", 1, "[station_name()]")
	if(!unlimited_uses)
		used = TRUE

/obj/item/station_charter/admin
	unlimited_uses = TRUE
	ignores_timeout = TRUE


/obj/item/station_charter/banner
	name = "\improper 纳米传讯旗帜"
	icon = 'icons/obj/banner.dmi'
	name_type = "planet"
	icon_state = "banner"
	inhand_icon_state = "banner"
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'
	desc = "一个用来认领天体所有权的狡猾装置."
	w_class = WEIGHT_CLASS_HUGE
	force = 15

/obj/item/station_charter/banner/rename_station(designation, uname, ureal_name, ukey)
	set_station_name(designation)
	minor_announce("[ureal_name]将[name_type]改名为[html_decode(station_name())]", "舰长诏曰") //decode station_name to avoid minor_announce double encode
	log_game("[ukey] has renamed the [name_type] as [station_name()].")
	name = "[station_name()]之旗"
	desc = "旗帜上有Nanotrasen-纳米传讯的官方图章, 表明[station_name()]已经由舰长[uname]以纳米传讯公司名义管理."
	SSblackbox.record_feedback("text", "station_renames", 1, "[station_name()]")
	if(!unlimited_uses)
		used = TRUE
