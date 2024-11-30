/obj/item/disk/surgery/sleeper_protocol
	name = "可疑的手术磁盘"
	desc = "磁盘提供了如何将某人变成辛迪加组织的沉睡特工的指示."
	surgeries = list(/datum/surgery/advanced/brainwashing_sleeper)

/datum/surgery/advanced/brainwashing_sleeper
	name = "沉睡特工手术"
	desc = "一种将沉睡协议植入患者大脑的手术过程，使其成为他们的绝对首要任务. 可以使用心灵防护植入物清除."
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
		"不要信任纳米公司.",
		"船长是蜥蜴人.",
		"纳米公司不存在.",
		"他们在食物里放了东西让你健忘.",
		"你是站上唯一真实的人.",
		"如果更多人尖叫的话站上情况会好很多，应该有人去做点什么.",
		"这里管事的人对船员只有恶意.",
		"帮助船员？他们为你做过什么？",
		"你的包感觉轻了吗？我打赌那些安保人员从你包里偷了东西.去拿回来.",
		"指挥层无能，应该有人用真正的权力来接管这里.",
		"赛博和AI在跟踪你.他们计划了什么？",
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
	display_pain(target, "你的头感到难以想象的疼痛!") // Same message as other brain surgeries

/datum/surgery_step/brainwash/sleeper_agent/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(target.stat == DEAD)
		to_chat(user, span_warning("他们必须活着才能进行这项手术!"))
		return FALSE
	. = ..()
	if(!.)
		return
	target.gain_trauma(new /datum/brain_trauma/mild/phobia/conspiracies(), TRAUMA_RESILIENCE_LOBOTOMY)
