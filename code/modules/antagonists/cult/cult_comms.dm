// Contains cult communion, guide, and cult master abilities

/datum/action/innate/cult
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	buttontooltipstyle = "cult"
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS
	ranged_mousepointer = 'icons/effects/mouse_pointers/cult_target.dmi'

/datum/action/innate/cult/IsAvailable(feedback = FALSE)
	if(!IS_CULTIST(owner))
		return FALSE
	return ..()

/datum/action/innate/cult/comm
	name = "群语"
	desc = "发出所有血教徒都能听到的耳语.<br><b>注意:</b>附近的非血教徒仍然能听到你的声音."
	button_icon_state = "cult_comms"
	// Unholy words dont require hands or mobility
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_CONSCIOUS

/datum/action/innate/cult/comm/IsAvailable(feedback = FALSE)
	if(isshade(owner) && IS_CULTIST(owner))
		return TRUE
	return ..()

/datum/action/innate/cult/comm/Activate()
	var/input = tgui_input_text(usr, "给其他教徒的消息", "血之音")
	if(!input || !IsAvailable(feedback = TRUE))
		return

	var/list/filter_result = CAN_BYPASS_FILTER(usr) ? null : is_ic_filtered(input)
	if(filter_result)
		REPORT_CHAT_FILTER_TO_USER(usr, filter_result)
		return

	var/list/soft_filter_result = CAN_BYPASS_FILTER(usr) ? null : is_soft_ic_filtered(input)
	if(soft_filter_result)
		if(tgui_alert(usr,"你的信息包含有 \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\". \"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\"， 你确定想要说出去吗?", "软屏蔽词", list("Yes", "No")) != "Yes")
			return
		message_admins("[ADMIN_LOOKUPFLW(usr)] 已经通过了 \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" 的软屏蔽词过滤器，他们可能使用了不允许的术语 消息: \"[html_encode(input)]\"")
		log_admin_private("[key_name(usr)] 已经通过了 \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" 的软屏蔽词过滤器，他们可能使用了不允许的术语 消息: \"[input]\"")
	cultist_commune(usr, input)

/datum/action/innate/cult/comm/proc/cultist_commune(mob/living/user, message)
	var/my_message
	if(!message || !user.mind)
		return
	user.whisper("O bidai nabora se[pick("'","`")]sma!", language = /datum/language/common)
	user.whisper(html_decode(message), filterproof = TRUE)
	var/title = "教徒"
	var/span = "cult italic"
	var/datum/antagonist/cult/cult_datum = user.mind.has_antag_datum(/datum/antagonist/cult)
	if(cult_datum.is_cult_leader())
		span = "cultlarge"
		title = "教主"
	else if(!ishuman(user))
		title = "建筑者"
	my_message = "<span class='[span]'><b>[title] [findtextEx(user.name, user.real_name) ? user.name : "[user.real_name] (作为 [user.name])"]:</b> [message]</span>"
	for(var/mob/M as anything in GLOB.player_list)
		if(IS_CULTIST(M))
			to_chat(M, my_message)
		else if(M in GLOB.dead_mob_list)
			var/link = FOLLOW_LINK(M, user)
			to_chat(M, "[link] [my_message]")

	user.log_talk(message, LOG_SAY, tag="cult")

/datum/action/innate/cult/comm/spirit
	name = "心灵群语"
	desc = "传达来自灵界的信息，所有的教徒都能听到."

/datum/action/innate/cult/comm/spirit/IsAvailable(feedback = FALSE)
	if(IS_CULTIST(owner.mind.current))
		return TRUE
	return ..()

/datum/action/innate/cult/comm/spirit/cultist_commune(mob/living/user, message)
	var/my_message
	if(!message)
		return
	my_message = span_cultboldtalic("The [user.name]: [message]")
	for(var/mob/player_list as anything in GLOB.player_list)
		if(IS_CULTIST(player_list))
			to_chat(player_list, my_message)
		else if(player_list in GLOB.dead_mob_list)
			var/link = FOLLOW_LINK(player_list, user)
			to_chat(player_list, "[link] [my_message]")

/datum/action/innate/cult/mastervote
	name = "宣示领袖地位"
	button_icon_state = "cultvote"
	// So you can use it while your hands are cuffed or you are bucked
	// If you want to assert your leadership while handcuffed to a chair, be my guest
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED

/datum/action/innate/cult/mastervote/IsAvailable(feedback = FALSE)
	if(!owner || !owner.mind)
		return FALSE
	var/datum/antagonist/cult/C = owner.mind.has_antag_datum(/datum/antagonist/cult,TRUE)
	if(!C || C.cult_team.cult_vote_called || !ishuman(owner))
		return FALSE
	return ..()

/datum/action/innate/cult/mastervote/Activate()
	var/choice = tgui_alert(owner, "领袖责任重大，若要成功胜任这一角色，需要具备专业的沟通技巧和充分的经验. 你确定吗?",, list("Yes", "No"))
	if(choice == "Yes" && IsAvailable())
		var/datum/antagonist/cult/C = owner.mind.has_antag_datum(/datum/antagonist/cult,TRUE)
		pollCultists(owner,C.cult_team)

/proc/pollCultists(mob/living/Nominee, datum/team/cult/team) //Cult Master Poll
	if(world.time < CULT_POLL_WAIT)
		to_chat(Nominee, "在每个人都还在适应的时候选择领导者还为时过早，请在[DisplayTimeText(CULT_POLL_WAIT-world.time)]内再试一次。")
		return
	team.cult_vote_called = TRUE //somebody's trying to be a master, make sure we don't let anyone else try
	for(var/datum/mind/B in team.members)
		if(B.current)
			B.current.update_mob_action_buttons()
			if(!B.current.incapacitated())
				SEND_SOUND(B.current, 'sound/hallucinations/im_here1.ogg')
				to_chat(B.current, span_cultlarge("教徒[Nominee]宣称自己可以领导血教. 投票将在不久后举行."))
	sleep(10 SECONDS)
	var/list/asked_cultists = list()
	for(var/datum/mind/B in team.members)
		if(B.current && B.current != Nominee && !B.current.incapacitated())
			SEND_SOUND(B.current, 'sound/magic/exit_blood.ogg')
			asked_cultists += B.current
	var/list/yes_voters = SSpolling.poll_candidates("[Nominee]希望自己可以领导血教，你愿意支持这个人吗?", poll_time = 30 SECONDS, group = asked_cultists, pic_source = Nominee, role_name_text = "血教教主")
	if(QDELETED(Nominee) || Nominee.incapacitated())
		team.cult_vote_called = FALSE
		for(var/datum/mind/B in team.members)
			if(B.current)
				B.current.update_mob_action_buttons()
				if(!B.current.incapacitated())
					to_chat(B.current,span_cultlarge("[Nominee]在争取教徒支持的过程中死亡!"))
		return FALSE
	if(!Nominee.mind)
		team.cult_vote_called = FALSE
		for(var/datum/mind/B in team.members)
			if(B.current)
				B.current.update_mob_action_buttons()
				if(!B.current.incapacitated())
					to_chat(B.current,span_cultlarge("[Nominee]在争取教徒支持的过程中患上了紧张性精神症!"))
		return FALSE
	if(LAZYLEN(yes_voters) <= LAZYLEN(asked_cultists) * 0.5)
		team.cult_vote_called = FALSE
		for(var/datum/mind/B in team.members)
			if(B.current)
				B.current.update_mob_action_buttons()
				if(!B.current.incapacitated())
					to_chat(B.current, span_cultlarge("[Nominee]无法争取到教徒支持，将继续担任教徒."))
		return FALSE
	var/datum/antagonist/cult/cult_datum = Nominee.mind.has_antag_datum(/datum/antagonist/cult)
	if(!cult_datum.make_cult_leader())
		CRASH("[cult_datum.owner.current] was supposed to turn into the leader, but they didn't for some reason. This isn't supposed to happen unless an Admin messed with it.")
	return TRUE

/datum/action/innate/cult/master/IsAvailable(feedback = FALSE)
	if(!owner.mind || GLOB.cult_narsie)
		return FALSE
	var/datum/antagonist/cult/cult_datum = owner.mind.has_antag_datum(/datum/antagonist/cult)
	if(!cult_datum.is_cult_leader())
		return FALSE
	return ..()

/datum/action/innate/cult/master/finalreck
	name = "最终审判"
	desc = "只能用一次的法术，可以将整个血教传送到教主所在位置."
	button_icon_state = "sintouch"

/datum/action/innate/cult/master/finalreck/Activate()
	var/datum/antagonist/cult/antag = owner.mind.has_antag_datum(/datum/antagonist/cult,TRUE)
	if(!antag)
		return
	var/place = get_area(owner)
	var/datum/objective/eldergod/summon_objective = locate() in antag.cult_team.objectives
	if(place in summon_objective.summon_spots)//cant do final reckoning in the summon area to prevent abuse, you'll need to get everyone to stand on the circle!
		to_chat(owner, span_cultlarge("这里的帷幕太弱!移动到一个足够坚实的地方来施展这个法术."))
		return
	for(var/i in 1 to 4)
		chant(i)
		var/list/destinations = list()
		for(var/turf/T in orange(1, owner))
			if(!T.is_blocked_turf(TRUE))
				destinations += T
		if(!LAZYLEN(destinations))
			to_chat(owner, span_warning("你需要更多的空间来召唤你的教众!"))
			return
		if(do_after(owner, 30, target = owner))
			for(var/datum/mind/B in antag.cult_team.members)
				if(B.current && B.current.stat != DEAD)
					var/turf/mobloc = get_turf(B.current)
					switch(i)
						if(1)
							new /obj/effect/temp_visual/cult/sparks(mobloc, B.current.dir)
							playsound(mobloc, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
						if(2)
							new /obj/effect/temp_visual/dir_setting/cult/phase/out(mobloc, B.current.dir)
							playsound(mobloc, SFX_SPARKS, 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
						if(3)
							new /obj/effect/temp_visual/dir_setting/cult/phase(mobloc, B.current.dir)
							playsound(mobloc, SFX_SPARKS, 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
						if(4)
							playsound(mobloc, 'sound/magic/exit_blood.ogg', 100, TRUE)
							if(B.current != owner)
								var/turf/final = pick(destinations)
								if(istype(B.current.loc, /obj/item/soulstone))
									var/obj/item/soulstone/S = B.current.loc
									S.release_shades(owner)
								B.current.setDir(SOUTH)
								new /obj/effect/temp_visual/cult/blood(final)
								addtimer(CALLBACK(B.current, TYPE_PROC_REF(/mob/, reckon), final), 10)
		else
			return
	antag.cult_team.reckoning_complete = TRUE
	Remove(owner)

/mob/proc/reckon(turf/final)
	new /obj/effect/temp_visual/cult/blood/out(get_turf(src))
	forceMove(final)

/datum/action/innate/cult/master/finalreck/proc/chant(chant_number)
	switch(chant_number)
		if(1)
			owner.say("C'arta forbici!", language = /datum/language/common, forced = "cult invocation")
		if(2)
			owner.say("Pleggh e'ntrath!", language = /datum/language/common, forced = "cult invocation")
			playsound(get_turf(owner),'sound/magic/clockwork/narsie_attack.ogg', 50, TRUE)
		if(3)
			owner.say("Barhah hra zar'garis!", language = /datum/language/common, forced = "cult invocation")
			playsound(get_turf(owner),'sound/magic/clockwork/narsie_attack.ogg', 75, TRUE)
		if(4)
			owner.say("N'ath reth sh'yro eth d'rekkathnor!!!", language = /datum/language/common, forced = "cult invocation")
			playsound(get_turf(owner),'sound/magic/clockwork/narsie_attack.ogg', 100, TRUE)

/datum/action/innate/cult/master/cultmark
	name = "标记目标"
	desc = "为血教标记一个目标."
	button_icon_state = "cult_mark"
	click_action = TRUE
	enable_text = span_cult("你准备好为血教标记目标了. <b>单击目标来标记!</b>")
	disable_text = span_cult("你取消了标记仪式.")
	/// The duration of the mark itself
	var/cult_mark_duration = 90 SECONDS
	/// The duration of the cooldown for cult marks
	var/cult_mark_cooldown_duration = 2 MINUTES
	/// The actual cooldown tracked of the action
	COOLDOWN_DECLARE(cult_mark_cooldown)

/datum/action/innate/cult/master/cultmark/IsAvailable(feedback = FALSE)
	return ..() && COOLDOWN_FINISHED(src, cult_mark_cooldown)

/datum/action/innate/cult/master/cultmark/InterceptClickOn(mob/caller, params, atom/clicked_on)
	var/turf/caller_turf = get_turf(caller)
	if(!isturf(caller_turf))
		return FALSE

	if(!(clicked_on in view(7, caller_turf)))
		return FALSE

	return ..()

/datum/action/innate/cult/master/cultmark/do_ability(mob/living/caller, atom/clicked_on)
	var/datum/antagonist/cult/cultist = caller.mind.has_antag_datum(/datum/antagonist/cult, TRUE)
	if(!cultist)
		CRASH("[type] was casted by someone without a cult antag datum.")

	var/datum/team/cult/cult_team = cultist.get_team()
	if(!cult_team)
		CRASH("[type] was casted by a cultist without a cult team datum.")

	if(cult_team.blood_target)
		to_chat(caller, span_cult("血教指定了目标!"))
		return FALSE

	if(cult_team.set_blood_target(clicked_on, caller, cult_mark_duration))
		unset_ranged_ability(caller, span_cult("标记仪式成功! 它将持续[DisplayTimeText(cult_mark_duration)]秒."))
		COOLDOWN_START(src, cult_mark_cooldown, cult_mark_cooldown_duration)
		build_all_button_icons()
		addtimer(CALLBACK(src, PROC_REF(build_all_button_icons)), cult_mark_cooldown_duration + 1)
		return TRUE

	unset_ranged_ability(caller, span_cult("标记仪式失败了!"))
	return TRUE

/datum/action/innate/cult/ghostmark //Ghost version
	name = "为血教标记"
	desc = "标记你环绕的东西，让整个血教都能追踪."
	button_icon_state = "cult_mark"
	check_flags = NONE
	/// The duration of the mark on the target
	var/cult_mark_duration = 60 SECONDS
	/// The cooldown between marks - the ability can be used in between cooldowns, but can't mark (only clear)
	var/cult_mark_cooldown_duration = 60 SECONDS
	/// The actual cooldown tracked of the action
	COOLDOWN_DECLARE(cult_mark_cooldown)

/datum/action/innate/cult/ghostmark/IsAvailable(feedback = FALSE)
	return ..() && isobserver(owner)

/datum/action/innate/cult/ghostmark/Activate()
	var/datum/antagonist/cult/cultist = owner.mind?.has_antag_datum(/datum/antagonist/cult, TRUE)
	if(!cultist)
		CRASH("[type] was casted by someone without a cult antag datum.")

	var/datum/team/cult/cult_team = cultist.get_team()
	if(!cult_team)
		CRASH("[type] was casted by a cultist without a cult team datum.")

	if(cult_team.blood_target)
		if(!COOLDOWN_FINISHED(src, cult_mark_cooldown))
			cult_team.unset_blood_target_and_timer()
			to_chat(owner, span_cultbold("你清除了血教的目标!"))
			return TRUE

		to_chat(owner, span_cultbold("血教已经指定了目标"))
		return FALSE

	if(!COOLDOWN_FINISHED(src, cult_mark_cooldown))
		to_chat(owner, span_cultbold("你还没准备好标记目标!"))
		return FALSE

	var/atom/mark_target = owner.orbiting?.parent || get_turf(owner)
	if(!mark_target)
		return FALSE

	if(cult_team.set_blood_target(mark_target, owner, 60 SECONDS))
		to_chat(owner, span_cultbold("你为血教标记了[mark_target]! 它将持续[DisplayTimeText(cult_mark_duration)]."))
		COOLDOWN_START(src, cult_mark_cooldown, cult_mark_cooldown_duration)
		build_all_button_icons(UPDATE_BUTTON_NAME|UPDATE_BUTTON_ICON)
		addtimer(CALLBACK(src, PROC_REF(reset_button)), cult_mark_cooldown_duration + 1)
		return TRUE

	to_chat(owner, span_cult("标记失败!"))
	return FALSE

/datum/action/innate/cult/ghostmark/update_button_name(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(COOLDOWN_FINISHED(src, cult_mark_duration))
		name = initial(name)
		desc = initial(desc)
	else
		name = "清除血教标记"
		desc = "移除你之前的血教标记."

	return ..()

/datum/action/innate/cult/ghostmark/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(COOLDOWN_FINISHED(src, cult_mark_duration))
		button_icon_state = initial(button_icon_state)
	else
		button_icon_state = "emp"

	return ..()

/datum/action/innate/cult/ghostmark/proc/reset_button()
	if(QDELETED(owner) || QDELETED(src))
		return

	SEND_SOUND(owner, 'sound/magic/enter_blood.ogg')
	to_chat(owner, span_cultbold("你移除了之前的血教标记，现在你准备好标记一个新的了."))
	build_all_button_icons(UPDATE_BUTTON_NAME|UPDATE_BUTTON_ICON)

//////// ELDRITCH PULSE /////////

/datum/action/innate/cult/master/pulse
	name = "邪恶脉充"
	desc = "紧抓一名教徒或血教建筑，将其传送到附近的位置."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "arcane_barrage"
	click_action = TRUE
	enable_text = span_cult("你准备撕裂现实的结构... <b>单击目标以紧抓!</b>")
	disable_text = span_cult("你取消准备.")
	/// Weakref to whoever we're currently about to toss
	var/datum/weakref/throwee_ref
	/// Cooldown of the ability
	var/pulse_cooldown_duration = 15 SECONDS
	/// The actual cooldown tracked of the action
	COOLDOWN_DECLARE(pulse_cooldown)

/datum/action/innate/cult/master/pulse/IsAvailable(feedback = FALSE)
	return ..() && COOLDOWN_FINISHED(src, pulse_cooldown)

/datum/action/innate/cult/master/pulse/InterceptClickOn(mob/living/caller, params, atom/clicked_on)
	var/turf/caller_turf = get_turf(caller)
	if(!isturf(caller_turf))
		return FALSE

	if(!(clicked_on in view(7, caller_turf)))
		return FALSE

	if(clicked_on == caller)
		return FALSE

	return ..()

/datum/action/innate/cult/master/pulse/do_ability(mob/living/caller, atom/clicked_on)
	var/atom/throwee = throwee_ref?.resolve()

	if(QDELETED(throwee))
		to_chat(caller, span_cult("你丢失了目标!"))
		throwee = null
		throwee_ref = null
		return FALSE

	if(throwee)
		if(get_dist(throwee, clicked_on) >= 16)
			to_chat(caller, span_cult("你无法传送这么远!"))
			return FALSE

		var/turf/throwee_turf = get_turf(throwee)

		playsound(throwee_turf, 'sound/magic/exit_blood.ogg')
		new /obj/effect/temp_visual/cult/sparks(throwee_turf, caller.dir)
		throwee.visible_message(
			span_warning("一股魔力脉冲将[throwee]吹走了!"),
			span_cult("一股魔力脉冲将你吹走了..."),
		)

		if(!do_teleport(throwee, clicked_on, channel = TELEPORT_CHANNEL_CULT))
			to_chat(caller, span_cult("传送失败了!"))
			throwee.visible_message(
				span_warning("...不过他们不会走很远"),
				span_cult("...不过你好像没走很远."),
			)
			return FALSE

		throwee_turf.Beam(clicked_on, icon_state = "sendbeam", time = 0.4 SECONDS)
		new /obj/effect/temp_visual/cult/sparks(get_turf(clicked_on), caller.dir)
		throwee.visible_message(
			span_warning("[throwee]突然被一股魔法脉冲吹了出来!"),
			span_cult("...你出现在了别处."),
		)

		COOLDOWN_START(src, pulse_cooldown, pulse_cooldown_duration)
		to_chat(caller, span_cult("当你移动[throwee]穿过时间与空间时，血魔法的能量在你体内澎湃浪涌."))
		caller.click_intercept = null
		throwee_ref = null
		build_all_button_icons()
		addtimer(CALLBACK(src, PROC_REF(build_all_button_icons)), pulse_cooldown_duration + 1)

		return TRUE

	else
		if(isliving(clicked_on))
			var/mob/living/living_clicked = clicked_on
			if(!IS_CULTIST(living_clicked))
				return FALSE
			SEND_SOUND(caller, sound('sound/weapons/thudswoosh.ogg'))
			to_chat(caller, span_cultbold("你用心灵的眼睛看穿帷幕，紧抓住了[clicked_on]! <b>点击附近的地方将其传送!</b>"))
			throwee_ref = WEAKREF(clicked_on)
			return TRUE

		if(istype(clicked_on, /obj/structure/destructible/cult))
			to_chat(caller, span_cultbold("你用心灵的眼睛看穿帷幕，抬起了[clicked_on]! <b>点击附近的地方将其传送!</b>"))
			throwee_ref = WEAKREF(clicked_on)
			return TRUE

	return FALSE
