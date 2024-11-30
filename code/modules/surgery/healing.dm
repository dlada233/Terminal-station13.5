/datum/surgery/healing
	target_mobtypes = list(/mob/living)
	requires_bodypart_type = BODYTYPE_ORGANIC //SKYRAT EDIT CHANGE - ORIGINAL VALUE: requires_bodypart_type = FALSE
	replaced_by = /datum/surgery
	surgery_flags = SURGERY_IGNORE_CLOTHES | SURGERY_REQUIRE_RESTING
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/heal,
		/datum/surgery_step/close,
	)

	var/healing_step_type
	var/antispam = FALSE

/datum/surgery/healing/can_start(mob/user, mob/living/patient)
	. = ..()
	if(!.)
		return .
	if(!(patient.mob_biotypes & (MOB_ORGANIC|MOB_HUMANOID)))
		return FALSE
	return .

/datum/surgery/healing/New(surgery_target, surgery_location, surgery_bodypart)
	..()
	if(healing_step_type)
		steps = list(
			/datum/surgery_step/incise/nobleed,
			healing_step_type, //hehe cheeky
			/datum/surgery_step/close,
		)

/datum/surgery_step/heal
	name = "修补身体 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 65,
		TOOL_WIRECUTTER = 60,
		/obj/item/pen = 55)
	repeatable = TRUE
	time = 25
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	var/brutehealing = 0
	var/burnhealing = 0
	var/brute_multiplier = 0 //multiplies the damage that the patient has. if 0 the patient wont get any additional healing from the damage he has.
	var/burn_multiplier = 0

/// Returns a string letting the surgeon know roughly how much longer the surgery is estimated to take at the going rate
/datum/surgery_step/heal/proc/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	return

/datum/surgery_step/heal/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/woundtype
	if(brutehealing && burnhealing)
		woundtype = "重伤口"
	else if(brutehealing)
		woundtype = "创伤"
	else //why are you trying to 0,0...?
		woundtype = "烧伤"
	if(istype(surgery,/datum/surgery/healing))
		var/datum/surgery/healing/the_surgery = surgery
		if(!the_surgery.antispam)
			display_results(
				user,
				target,
				span_notice("你尝试修补了[target]的一些[woundtype]. "),
				span_notice("[user]尝试修补了[target]的一些[woundtype]. "),
				span_notice("[user]尝试修补了[target]的一些[woundtype]. "),
			)
		display_pain(target, "你的[woundtype]疼得要命！")

/datum/surgery_step/heal/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	if(!..())
		return
	while((brutehealing && target.getBruteLoss()) || (burnhealing && target.getFireLoss()))
		if(!..())
			break

/datum/surgery_step/heal/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/user_msg = "你成功修复了[target]的一些伤口" //无句号，为“addons”添加初始空格
	var/target_msg = "[user]修复了[target]的一些伤口" //同上
	var/brute_healed = brutehealing
	var/burn_healed = burnhealing
	var/dead_patient = FALSE
	if(target.stat == DEAD) //dead patients get way less additional heal from the damage they have.
		brute_healed += round((target.getBruteLoss() * (brute_multiplier * 0.2)),0.1)
		burn_healed += round((target.getFireLoss() * (burn_multiplier * 0.2)),0.1)
		dead_patient = TRUE
	else
		brute_healed += round((target.getBruteLoss() * brute_multiplier),0.1)
		burn_healed += round((target.getFireLoss() * burn_multiplier),0.1)
		dead_patient = FALSE
	if(!get_location_accessible(target, target_zone))
		brute_healed *= 0.55
		burn_healed *= 0.55
		user_msg += "，由于对象穿着衣服，你只能尽可能地处理"
		target_msg += "，由于对象穿着衣服，只能尽可能地处理"
	target.heal_bodypart_damage(brute_healed,burn_healed)

	user_msg += get_progress(user, target, brute_healed, burn_healed)

	if(HAS_MIND_TRAIT(user, TRAIT_MORBID) && ishuman(user) && !dead_patient) //Morbid folk don't care about tending the dead as much as tending the living
		var/mob/living/carbon/human/morbid_weirdo = user
		morbid_weirdo.add_mood_event("morbid_tend_wounds", /datum/mood_event/morbid_tend_wounds)

	display_results(
		user,
		target,
		span_notice("[user_msg]."),
		span_notice("[target_msg]."),
		span_notice("[target_msg]."),
	)
	if(istype(surgery, /datum/surgery/healing))
		var/datum/surgery/healing/the_surgery = surgery
		the_surgery.antispam = TRUE
	return ..()

/datum/surgery_step/heal/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("你搞砸了！"),
		span_warning("[user]搞砸了！"),
		span_notice("[user]修复了[target]的一些伤口. "),
		target_detailed = TRUE,
	)
	var/brute_dealt = brutehealing * 0.8
	var/burn_dealt = burnhealing * 0.8
	brute_dealt += round((target.getBruteLoss() * (brute_multiplier * 0.5)),0.1)
	burn_dealt += round((target.getFireLoss() * (burn_multiplier * 0.5)),0.1)
	target.take_bodypart_damage(brute_dealt, burn_dealt, wound_bonus=CANT_WOUND)
	return FALSE

/***************************BRUTE***************************/
/datum/surgery/healing/brute
	name = "治疗伤口（创伤）"

/datum/surgery/healing/brute/basic
	name = "治疗伤口（创伤，基础）"
	replaced_by = /datum/surgery/healing/brute/upgraded
	healing_step_type = /datum/surgery_step/heal/brute/basic
	desc = "一种为伤者提供基础治疗的手术程序，用于处理粗暴伤害. 当伤者受重伤时，治愈效果会稍强. "

/datum/surgery/healing/brute/upgraded
	name = "治疗伤口（创伤，高级）"
	replaced_by = /datum/surgery/healing/brute/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded
	desc = "一种为伤者提供高级治疗的手术程序，用于处理粗暴伤害. 当伤者受重伤时，治愈效果更强. "

/datum/surgery/healing/brute/upgraded/femto
	name = "治疗伤口（创伤，实验性）"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded/femto
	desc = "一种为伤者提供实验性治疗的手术程序，用于处理粗暴伤害. 当伤者受重伤时，治愈效果显著增强. "

/********************BRUTE STEPS********************/
/datum/surgery_step/heal/brute/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	if(!brute_healed)
		return

	var/estimated_remaining_steps = target.getBruteLoss() / brute_healed
	var/progress_text

	if(locate(/obj/item/healthanalyzer) in user.held_items)
		progress_text = ". 剩余创伤：<font color='#ff3333'>[target.getBruteLoss()]</font>"
	else
		switch(estimated_remaining_steps)
			if(-INFINITY to 1)
				return
			if(1 to 3)
				progress_text = "，正在缝合最后几处擦伤"
			if(3 to 6)
				progress_text = "，正在数着还剩几处创伤需要治疗"
			if(6 to 9)
				progress_text = "，继续全力治疗伤者的严重撕裂伤"
			if(9 to 12)
				progress_text = "，稳住自己，准备迎接漫长的手术"
			if(12 to 15)
				progress_text = "，尽管伤者看起来仍然更像肉泥而不是一个人"
			if(15 to INFINITY)
				progress_text = "，尽管你觉得自己只是在治疗伤者被打烂的身体上略微有所进展"

	return progress_text

/datum/surgery_step/heal/brute/basic
	name = "护理创伤 (止血钳)"
	brutehealing = 5
	brute_multiplier = 0.07

/datum/surgery_step/heal/brute/upgraded
	brutehealing = 5
	brute_multiplier = 0.1

/datum/surgery_step/heal/brute/upgraded/femto
	brutehealing = 5
	brute_multiplier = 0.2

/***************************BURN***************************/
/datum/surgery/healing/burn
	name = "治疗伤口（烧伤）"

/datum/surgery/healing/burn/basic
	name = "治疗伤口（烧伤，基础）"
	replaced_by = /datum/surgery/healing/burn/upgraded
	healing_step_type = /datum/surgery_step/heal/burn/basic
	desc = "一种为伤者提供基础治疗的手术程序，用于处理烧伤. 当伤者受重伤时，治愈效果会稍强. "

/datum/surgery/healing/burn/upgraded
	name = "治疗伤口（烧伤，高级）"
	replaced_by = /datum/surgery/healing/burn/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded
	desc = "一种为伤者提供高级治疗的手术程序，用于处理烧伤. 当伤者受重伤时，治愈效果更强. "

/datum/surgery/healing/burn/upgraded/femto
	name = "治疗伤口（烧伤，实验性）"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded/femto
	desc = "一种为伤者提供实验性治疗的手术程序，用于处理烧伤. 当伤者受重伤时，治愈效果显著增强. "

/********************BURN STEPS********************/
/datum/surgery_step/heal/burn/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	if(!burn_healed)
		return
	var/estimated_remaining_steps = target.getFireLoss() / burn_healed
	var/progress_text

	if(locate(/obj/item/healthanalyzer) in user.held_items)
		progress_text = ". 剩余烧伤：<font color='#ff9933'>[target.getFireLoss()]</font>"
	else
		switch(estimated_remaining_steps)
			if(-INFINITY to 1)
				return
			if(1 to 3)
				progress_text = "，正在处理最后几处焦痕"
			if(3 to 6)
				progress_text = "，正在数着还剩几处水泡需要治疗"
			if(6 to 9)
				progress_text = "，继续全力治疗伤者的严重烧伤"
			if(9 to 12)
				progress_text = "，稳住自己，准备迎接漫长的手术"
			if(12 to 15)
				progress_text = "，尽管伤者看起来仍然更像烧焦的牛排而不是一个人"
			if(15 to INFINITY)
				progress_text = "，尽管你觉得自己只是在治疗伤者烧焦的身体上略微有所进展"

	return progress_text

/datum/surgery_step/heal/burn/basic
	name = "护理烧伤 (止血钳)"
	burnhealing = 5
	burn_multiplier = 0.07

/datum/surgery_step/heal/burn/upgraded
	burnhealing = 5
	burn_multiplier = 0.1

/datum/surgery_step/heal/burn/upgraded/femto
	burnhealing = 5
	burn_multiplier = 0.2

/***************************COMBO***************************/
/datum/surgery/healing/combo


/datum/surgery/healing/combo
	name = "治疗伤口（混合，基础）"
	replaced_by = /datum/surgery/healing/combo/upgraded
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/combo
	desc = "一种为伤者提供基础治疗的手术程序，用于治疗烧伤和钝器伤. 当伤者受重伤时，治愈效果会稍强. "

/datum/surgery/healing/combo/upgraded
	name = "治疗伤口（混合，高级）"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	healing_step_type = /datum/surgery_step/heal/combo/upgraded
	desc = "一种为伤者提供高级治疗的手术程序，用于治疗烧伤和钝器伤. 当伤者受重伤时，治愈效果更强. "

/datum/surgery/healing/combo/upgraded/femto
	name = "治疗伤口（混合，实验性）"
	replaced_by = null
	healing_step_type = /datum/surgery_step/heal/combo/upgraded/femto
	desc = "一种为伤者提供实验性治疗的手术程序，用于治疗烧伤和钝器伤. 当伤者受重伤时，治愈效果显著增强. "

/********************COMBO STEPS********************/
/datum/surgery_step/heal/combo/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	var/estimated_remaining_steps = 0
	if(brute_healed > 0)
		estimated_remaining_steps = max(0, (target.getBruteLoss() / brute_healed))
	if(burn_healed > 0)
		estimated_remaining_steps = max(estimated_remaining_steps, (target.getFireLoss() / burn_healed)) // whichever is higher between brute or burn steps

	var/progress_text

	if(locate(/obj/item/healthanalyzer) in user.held_items)
		if(target.getBruteLoss())
			progress_text = ". 剩余钝器伤：<font color='#ff3333'>[target.getBruteLoss()]</font>"
		if(target.getFireLoss())
			progress_text += ". 剩余烧伤：<font color='#ff9933'>[target.getFireLoss()]</font>"
	else
		switch(estimated_remaining_steps)
			if(-INFINITY to 1)
				return
			if(1 to 3)
				progress_text = "，正在处理最后几处损伤迹象"
			if(3 to 6)
				progress_text = "，正在数着还剩几处创伤需要治疗"
			if(6 to 9)
				progress_text = "，继续全力治疗[target.p_their()]的严重伤势"
			if(9 to 12)
				progress_text = "，稳住自己，准备迎接漫长的手术"
			if(12 to 15)
				progress_text = "，尽管[target.p_they()]看起来仍然更像被压烂的婴儿食品而不是一个人"
			if(15 to INFINITY)
				progress_text = "，尽管你觉得自己只是在治疗[target.p_their()]破碎的身体上略微有所进展"

	return progress_text

/datum/surgery_step/heal/combo
	name = "护理外伤 (止血钳)"
	brutehealing = 3
	burnhealing = 3
	brute_multiplier = 0.07
	burn_multiplier = 0.07
	time = 10

/datum/surgery_step/heal/combo/upgraded
	brutehealing = 3
	burnhealing = 3
	brute_multiplier = 0.1
	burn_multiplier = 0.1

/datum/surgery_step/heal/combo/upgraded/femto
	brutehealing = 1
	burnhealing = 1
	brute_multiplier = 0.4
	burn_multiplier = 0.4

/datum/surgery_step/heal/combo/upgraded/femto/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("你搞砸了!"),
		span_warning("[user]搞砸了!"),
		span_notice("[user]修复了一些[target]的伤口."),
		target_detailed = TRUE,
	)
	target.take_bodypart_damage(5,5)
