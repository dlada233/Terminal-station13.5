#define CHALLENGE_TELECRYSTALS 280
#define CHALLENGE_TIME_LIMIT (5 MINUTES)
#define CHALLENGE_SHUTTLE_DELAY (25 MINUTES) // 25 minutes, so the ops have at least 5 minutes before the shuttle is callable.

GLOBAL_LIST_EMPTY(jam_on_wardec)

/obj/item/nuclear_challenge
	name = "宣战 (挑战模式)"
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "nukietalkie"
	inhand_icon_state = "nukietalkie"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	desc = "用来向目标发出战争声明，使你的飞船延迟出发20分钟，让他们为你即将到来的攻击做准备.  \
			这样大胆的举动会吸引辛迪加集团中强大的资助者的注意，他们将为你额外提供大量的TC水晶.  \
			必须在开始五分钟内宣战，否则资助者也会失去兴趣."
	var/declaring_war = FALSE
	var/uplink_type = /obj/item/uplink/nuclear

/obj/item/nuclear_challenge/attack_self(mob/living/user)
	if(!check_allowed(user))
		return

	declaring_war = TRUE
	var/are_you_sure = tgui_alert(user, "在向[station_name()]宣战之前，请和您的团队仔细商讨. 你确定要通知敌方船员吗? 你尚有[DisplayTimeText(CHALLENGE_TIME_LIMIT - world.time - SSticker.round_start_time)]来决定.", "宣战?", list("Yes", "No"))
	declaring_war = FALSE

	if(!check_allowed(user))
		return

	if(are_you_sure != "Yes")
		to_chat(user, span_notice("转念一想，给空间站的大家一个惊喜也不坏."))
		return

	var/war_declaration = "一支辛迪加外围小组宣布他们要用核武器彻底摧毁[station_name()]，并挑衅船员如果有能力就阻止他们."

	declaring_war = TRUE
	var/custom_threat = tgui_alert(user, "你想要自定义宣战内容吗?", "自定义?", list("Yes", "No"))
	declaring_war = FALSE

	if(!check_allowed(user))
		return

	if(custom_threat == "Yes")
		declaring_war = TRUE
		war_declaration = tgui_input_text(user, "输入你的自定义宣战内容", "宣战", multiline = TRUE, encode = FALSE)
		declaring_war = FALSE

	if(!check_allowed(user) || !war_declaration)
		return

	war_was_declared(user, memo = war_declaration)

///Admin only proc to bypass checks and force a war declaration. Button on antag panel.
/obj/item/nuclear_challenge/proc/force_war()
	var/are_you_sure = tgui_alert(usr, "你确定要强行宣战吗?[GLOB.player_list.len < CHALLENGE_MIN_PLAYERS ? " 注意，玩家数量低于最小数量需求." : ""]", "宣战?", list("Yes", "No"))

	if(are_you_sure != "Yes")
		return

	var/war_declaration = "一支辛迪加外围小组宣布他们要用核武器彻底摧毁[station_name()]，并挑衅船员如果有能力就阻止他们."

	var/custom_threat = tgui_alert(usr, "你想要自定义宣战内容吗?", "自定义?", list("Yes", "No"))

	if(custom_threat == "Yes")
		war_declaration = tgui_input_text(usr, "输入你的自定义宣战内容", "宣战", multiline = TRUE, encode = FALSE)

	if(!war_declaration)
		tgui_alert(usr, "宣战内容不可用.", "措辞不当")
		return

	for(var/obj/item/circuitboard/computer/syndicate_shuttle/board as anything in GLOB.syndicate_shuttle_boards)
		if(board.challenge)
			tgui_alert(usr, "已经宣战了!", "已经宣战了!")
			return

	war_was_declared(memo = war_declaration)

/obj/item/nuclear_challenge/proc/war_was_declared(mob/living/user, memo)
	priority_announce(
		text = memo,
		title = "宣战书",
		sound = 'sound/machines/alarm.ogg',
		has_important_message = TRUE,
		sender_override = "核作战前哨",
		color_override = "red",
	)
	if(user)
		to_chat(user, "你们已经引起集团内部强大势力的注意. 你的团队将获得额外的水晶.如果你们完成了任务，这将是一件伟大的成就.")

	distribute_tc()
	CONFIG_SET(number/shuttle_refuel_delay, max(CONFIG_GET(number/shuttle_refuel_delay), CHALLENGE_SHUTTLE_DELAY))
	SSblackbox.record_feedback("amount", "nuclear_challenge_mode", 1)

	for(var/obj/item/circuitboard/computer/syndicate_shuttle/board as anything in GLOB.syndicate_shuttle_boards)
		board.challenge = TRUE

	for(var/obj/machinery/computer/camera_advanced/shuttle_docker/dock as anything in GLOB.jam_on_wardec)
		dock.jammed = TRUE

	qdel(src)

/obj/item/nuclear_challenge/proc/distribute_tc()
	var/list/orphans = list()
	var/list/uplinks = list()

	for (var/datum/mind/M in get_antag_minds(/datum/antagonist/nukeop))
		if (iscyborg(M.current))
			continue
		var/datum/component/uplink/uplink = M.find_syndicate_uplink()
		if (!uplink)
			orphans += M.current
			continue
		uplinks += uplink

	var/tc_to_distribute = CHALLENGE_TELECRYSTALS
	var/tc_per_nukie = round(tc_to_distribute / (length(orphans)+length(uplinks)))

	for (var/datum/component/uplink/uplink in uplinks)
		uplink.uplink_handler.add_telecrystals(tc_per_nukie)
		tc_to_distribute -= tc_per_nukie

	for (var/mob/living/L in orphans)
		var/TC = new /obj/item/stack/telecrystal(L.drop_location(), tc_per_nukie)
		to_chat(L, span_warning("找不到你的上行链路，所以奖励给你的水晶已经被送到了你的[L.put_in_hands(TC) ? "手上" : "脚下"]."))
		tc_to_distribute -= tc_per_nukie

	if (tc_to_distribute > 0) // What shall we do with the remainder...
		for (var/mob/living/basic/carp/pet/cayenne/C in GLOB.mob_living_list)
			if (C.stat != DEAD)
				var/obj/item/stack/telecrystal/TC = new(C.drop_location(), tc_to_distribute)
				TC.throw_at(get_step(C, C.dir), 3, 3)
				C.visible_message(span_notice("[C]咳出了消化一半的晶体."),span_notice("你咳出了消化一半的的晶体!"))
				break


/obj/item/nuclear_challenge/proc/check_allowed(mob/living/user)
	if(declaring_war)
		to_chat(user, span_boldwarning("你已经在宣战了!下决心吧."))
		return FALSE
	if(GLOB.player_list.len < CHALLENGE_MIN_PLAYERS)
		to_chat(user, span_boldwarning("敌方船员太少，不值得宣战."))
		return FALSE
	if(!user.onSyndieBase())
		to_chat(user, span_boldwarning("你必须在你的基地内才能使用它."))
		return FALSE
	if(world.time - SSticker.round_start_time > CHALLENGE_TIME_LIMIT)
		to_chat(user, span_boldwarning("现在宣战已经太晚了，你的资助者已经忙着其他计划了. 将就着用手头的东西完成任务吧."))
		return FALSE
	for(var/obj/item/circuitboard/computer/syndicate_shuttle/board as anything in GLOB.syndicate_shuttle_boards)
		if(board.moved)
			to_chat(user, span_boldwarning("飞船已经开动了!你已丧失了宣战的权利."))
			return FALSE
		if(board.challenge)
			to_chat(user, span_boldwarning("已经宣战了!"))
			return FALSE
	return TRUE

/obj/item/nuclear_challenge/clownops
	uplink_type = /obj/item/uplink/clownop

/// Subtype that does nothing but plays the war op message. Intended for debugging
/obj/item/nuclear_challenge/literally_just_does_the_message
	name = "\"宣战\""
	desc = "这是一个辛迪加宣战书之类的东西，但它只播放响亮的声音和信息. 除此之外什么都没有."
	var/admin_only = TRUE

/obj/item/nuclear_challenge/literally_just_does_the_message/check_allowed(mob/living/user)
	if(admin_only && !check_rights_for(user.client, R_SPAWN|R_FUN|R_DEBUG))
		to_chat(user, span_hypnophrase("你不应该有这个!"))
		return FALSE

	return TRUE

/obj/item/nuclear_challenge/literally_just_does_the_message/war_was_declared(mob/living/user, memo)
#ifndef TESTING
	// Reminder for our friends the admins
	var/are_you_sure = tgui_alert(user, "最后提醒一下，假宣战是一个可怕的想法，会引发一系列事情，所以小心你在做什么.", "别这么做", list("I'm sure", "You're right"))
	if(are_you_sure != "I'm sure")
		return
#endif

	priority_announce(
		text = memo,
		title = "宣战书",
		sound = 'sound/machines/alarm.ogg',
		has_important_message = TRUE,
		sender_override = "核行动前哨",
		color_override = "red",
	)

/obj/item/nuclear_challenge/literally_just_does_the_message/distribute_tc()
	return

#undef CHALLENGE_TELECRYSTALS
#undef CHALLENGE_TIME_LIMIT
#undef CHALLENGE_SHUTTLE_DELAY
