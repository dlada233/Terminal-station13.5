/obj/machinery/abductor/experiment
	name = "实验机器"
	desc = "可容纳一个人的大型机器，拥有复杂的手术配置."
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "experiment-open"
	density = FALSE
	state_open = TRUE
	var/points = 0
	var/credits = 0
	var/list/history
	var/list/abductee_minds
	/// Machine feedback message
	var/flash = "等待对象."
	var/obj/machinery/abductor/console/console
	var/message_cooldown = 0
	var/breakout_time = 450

/obj/machinery/abductor/experiment/Destroy()
	if(console)
		console.experiment = null
		console = null
	return ..()

/obj/machinery/abductor/experiment/MouseDrop_T(mob/target, mob/user)
	if(user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_UI_BLOCKED) || !Adjacent(user) || !target.Adjacent(user) || !ishuman(target))
		return
	if(isabductor(target))
		return
	close_machine(target)

/obj/machinery/abductor/experiment/open_machine(drop = TRUE, density_to_set = FALSE)
	if(!state_open && !panel_open)
		..()

/obj/machinery/abductor/experiment/close_machine(mob/target, density_to_set = TRUE)
	for(var/A in loc)
		if(isabductor(A))
			return
	if(state_open && !panel_open)
		..(target)

/obj/machinery/abductor/experiment/relaymove(mob/living/user, direction)
	if(user.stat != CONSCIOUS)
		return
	if(message_cooldown <= world.time)
		message_cooldown = world.time + 50
		to_chat(user, span_warning("[src]的门移不动!"))

/obj/machinery/abductor/experiment/container_resist_act(mob/living/user)
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(span_notice("你看到[user]在踢[src]的门!"), \
		span_notice("你背靠[src]开始把门推开... (这大约需要[DisplayTimeText(breakout_time)].)"), \
		span_hear("你听到来自[src]的金属嘎吱声."))
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src || state_open)
			return
		user.visible_message(span_warning("[user]成功从[src]中逃脱了!"), \
			span_notice("你成功从[src]中逃脱了!"))
		open_machine()

/obj/machinery/abductor/experiment/ui_status(mob/user, datum/ui_state/state)
	if(user == occupant)
		return UI_CLOSE
	return ..()

/obj/machinery/abductor/experiment/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/abductor/experiment/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ProbingConsole", name)
		ui.open()

/obj/machinery/abductor/experiment/ui_data(mob/user)
	var/list/data = list()
	data["open"] = state_open
	data["feedback"] = flash
	data["occupant"] = occupant ? TRUE : FALSE
	data["occupant_name"] = null
	data["occupant_status"] = null
	if(occupant)
		var/mob/living/mob_occupant = occupant
		data["occupant_name"] = mob_occupant.name
		data["occupant_status"] = mob_occupant.stat
	return data

/obj/machinery/abductor/experiment/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("door")
			if(state_open)
				close_machine()
				return TRUE
			else
				open_machine()
				return TRUE
		if("experiment")
			if(!occupant)
				return
			var/mob/living/mob_occupant = occupant
			if(mob_occupant.stat == DEAD)
				return
			flash = experiment(mob_occupant, params["experiment_type"], usr)
			return TRUE

/**
 * experiment: Performs selected experiment on occupant mob, resulting in a point reward on success
 *
 * Arguments:
 * * occupant The mob inside the machine
 * * type The type of experiment to be performed
 * * user The mob starting the experiment
 */
/obj/machinery/abductor/experiment/proc/experiment(mob/living/carbon/human/occupant, type, mob/user)
	LAZYINITLIST(history)

	if(!istype(occupant))
		stack_trace("Abductor '[name]' called /proc/experiment with unexpected occupant ([occupant])")

	if(!ishuman(occupant)) //We shouldn't be processing anything other than humans
		return "不是人类!"

	var/datum/antagonist/abductor/user_abductor = user.mind.has_antag_datum(/datum/antagonist/abductor)
	if(!user_abductor)
		return "授权失败，立刻联系母舰."

	var/point_reward = 0
	if(!occupant)
		return "无效或缺失样本."
	if(occupant in history)
		return "样本已在数据库中."
	if(occupant.stat == DEAD)
		say("样本已死亡 - 请提供新鲜样本.")
		return "样本已死亡."
	var/obj/item/organ/internal/heart/gland/GlandTest = locate() in occupant.organs
	if(!GlandTest)
		say("未检测到实验性解剖手术!")
		return "未检测到腺体!"
	if(occupant.mind != null && occupant.ckey != null)
		LAZYINITLIST(abductee_minds)
		LAZYADD(history, occupant)
		LAZYADD(abductee_minds, occupant.mind)
		say("样本处理中...")
		sleep(0.5 SECONDS)
		switch(text2num(type))
			if(1)
				to_chat(occupant, span_warning("你感觉被侵犯了."))
			if(2)
				to_chat(occupant, span_warning("你感到自己被肢解，又被重新组装起来了."))
			if(3)
				to_chat(occupant, span_warning("你感到被密切注视着."))
		sleep(0.5 SECONDS)
		user_abductor.team.abductees += occupant.mind
		occupant.mind.add_antag_datum(/datum/antagonist/abductee)

		for(var/obj/item/organ/internal/heart/gland/G in occupant.organs)
			G.Start()
			point_reward++
		if(point_reward > 0)
			open_machine()
			send_back(occupant)
			playsound(src.loc, 'sound/machines/ding.ogg', 50, TRUE)
			points += point_reward
			credits += point_reward
			return "实验成功! [point_reward]新数据点已收集."
		else
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
			return "实验失败! 未检测到移植器官."
	else
		say("大脑活动停止 - 处置样本...")
		open_machine()
		send_back(occupant)
		return "样本脑死亡 - 已处置."

/**
 * send_back: Sends a mob back to a selected teleport location if safe
 *
 * Arguments:
 * * H The human mob to be sent back
 */
/obj/machinery/abductor/experiment/proc/send_back(mob/living/carbon/human/H)
	H.Sleeping(160)
	H.uncuff()
	if(console && console.pad && console.pad.teleport_target)
		H.forceMove(console.pad.teleport_target)
		return
	//Area not chosen / It's not safe area - teleport to arrivals
	SSjob.SendToLateJoin(H, FALSE)
	return

/obj/machinery/abductor/experiment/update_icon_state()
	icon_state = "experiment[state_open ? "-open" : null]"
	return ..()
