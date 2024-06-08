/datum/traitor_objective_category/sleeper_protocol
	name = "休眠协议"
	objectives = list(
		/datum/traitor_objective/sleeper_protocol = 1,
		/datum/traitor_objective/sleeper_protocol/everybody = 1,
	)

/datum/traitor_objective/sleeper_protocol
	name = "对一名船员执行休眠协议"
	description = "按下下面的按钮，一个手术磁盘就会出现在你的手中，然后你可以依靠它对船员执行休眠协议. 如果磁盘被破坏，目标会失败. 此外该手术只适用于有知觉且活着的船员."

	progression_minimum = 0 MINUTES

	progression_reward = list(8 MINUTES, 15 MINUTES)
	telecrystal_reward = 1

	var/list/limited_to = list(
		JOB_CHIEF_MEDICAL_OFFICER,
		JOB_MEDICAL_DOCTOR,
		JOB_PARAMEDIC,
		JOB_VIROLOGIST,
		JOB_ROBOTICIST,
	)

	var/obj/item/disk/surgery/sleeper_protocol/disk

	var/mob/living/current_registered_mob

	var/inverted_limitation = FALSE

/datum/traitor_objective/sleeper_protocol/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!disk)
		buttons += add_ui_button("", "单击以获取手术磁盘到手中", "save", "summon_disk")
	return buttons

/datum/traitor_objective/sleeper_protocol/ui_perform_action(mob/living/user, action)
	switch(action)
		if("summon_disk")
			if(disk)
				return
			disk = new(user.drop_location())
			user.put_in_hands(disk)
			AddComponent(/datum/component/traitor_objective_register, disk, \
				fail_signals = list(COMSIG_QDELETING))

/datum/traitor_objective/sleeper_protocol/proc/on_surgery_success(datum/source, datum/surgery_step/step, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	SIGNAL_HANDLER
	if(istype(step, /datum/surgery_step/brainwash/sleeper_agent))
		succeed_objective()

/datum/traitor_objective/sleeper_protocol/can_generate_objective(datum/mind/generating_for, list/possible_duplicates)
	var/datum/job/job = generating_for.assigned_role
	if(!(job.title in limited_to) && !inverted_limitation)
		return FALSE
	if((job.title in limited_to) && inverted_limitation)
		return FALSE
	if(length(possible_duplicates) > 0)
		return FALSE
	return TRUE

/datum/traitor_objective/sleeper_protocol/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	AddComponent(/datum/component/traitor_objective_mind_tracker, generating_for, \
		signals = list(COMSIG_MOB_SURGERY_STEP_SUCCESS = PROC_REF(on_surgery_success)))
	return TRUE

/datum/traitor_objective/sleeper_protocol/ungenerate_objective()
	disk = null
/obj/item/disk/surgery/sleeper_protocol
	name = "可疑手术磁盘"
	desc = "这张磁盘提供了如何把人变成辛迪加潜在特工的手术资料."
	surgeries = list(/datum/surgery/advanced/brainwashing_sleeper)

/datum/surgery/advanced/brainwashing_sleeper
	name = "休眠特工手术"
	desc = "一种可以将休眠协议植入病人大脑的手术，使其成为他们的首要任务. 心盾植入物可以清除它."
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/brainwash/sleeper_agent,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/brainwashing_sleeper/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/organ/internal/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE
	return TRUE

/datum/surgery_step/brainwash/sleeper_agent
	time = 25 SECONDS
	var/static/list/possible_objectives = list(
		"你爱辛迪加.",
		"不要相信纳米传讯.",
		"舰长是蜥蜴人.",
		"纳米传讯不是真实的.",
		"他们在食物中放了某些东西让你健忘.",
		"你是整个空间站里唯一真实存在的人.",
		"如果有更多人惊觉就好了，应该有人做点什么.",
		"这里的负责人们对船员只有恶意.",
		"帮助船员?这些人又为你做过什么吗？",
		"你的包是不是拎起来变轻了？我敢说是那些安保从里面偷了东西. 去把它拿回来.",
		"指挥层无能，应该有真正的权威来接管这里.",
		"赛博和AI在跟踪你，它们在计划什么?",
	)

/datum/surgery_step/brainwash/sleeper_agent/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	objective = pick(possible_objectives)
	display_results(
		user,
		target,
		span_notice("你开始洗脑[target]..."),
		span_notice("[user]开始修复[target]的大脑."),
		span_notice("[user]开始对[target]的大脑进行手术."),
	)
	display_pain(target, "你的头承受着难以想象的痛苦!") // Same message as other brain surgeries

/datum/surgery_step/brainwash/sleeper_agent/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(target.stat == DEAD)
		to_chat(user, span_warning("他们必须活着才能做手术!"))
		return FALSE
	. = ..()
	if(!.)
		return
	target.gain_trauma(new /datum/brain_trauma/mild/phobia/conspiracies(), TRAUMA_RESILIENCE_LOBOTOMY)

/datum/traitor_objective/sleeper_protocol/everybody //Much harder for non-med and non-robo
	progression_minimum = 30 MINUTES
	progression_reward = list(8 MINUTES, 15 MINUTES)
	telecrystal_reward = 1

	inverted_limitation = TRUE
