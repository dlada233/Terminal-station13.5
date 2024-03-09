/obj/item/organ/internal/heart/gland/mindshock
	abductor_hint = "神经串流解抑器. 被劫持者时不时会释放扰乱的心灵波，附近的人可能会眩晕、产生幻觉，或者受到随机的脑部损伤."
	cooldown_low = 40 SECONDS
	cooldown_high = 70 SECONDS
	uses = -1
	icon_state = "mindshock"
	mind_control_uses = 2
	mind_control_duration = 120 SECONDS
	var/list/mob/living/carbon/human/broadcasted_mobs = list()

/obj/item/organ/internal/heart/gland/mindshock/activate()
	to_chat(owner, span_notice("你感到头疼."))

	var/turf/owner_turf = get_turf(owner)
	for(var/mob/living/carbon/target in orange(4,owner_turf))
		if(target == owner)
			continue
		if(HAS_TRAIT(target, TRAIT_MINDSHIELD))
			to_chat(target, span_notice("你听到耳边传来微弱的嗡鸣声，但很快就消失了."))
			continue

		switch(pick(1,3))
			if(1)
				to_chat(target, span_userdanger("你听到头脑中一阵刺耳的嗡嗡声，将你的思绪彻底压制了！"))
				target.Stun(50)
			if(2)
				to_chat(target, span_warning("你听到脑中一阵恼人的嗡嗡声."))
				target.adjust_confusion(15 SECONDS)
				target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10, 160)
			if(3)
				target.adjust_hallucinations(120 SECONDS)

/obj/item/organ/internal/heart/gland/mindshock/mind_control(command, mob/living/user)
	if(!ownerCheck() || !mind_control_uses || active_mind_control)
		return FALSE
	mind_control_uses--
	for(var/mob/target_mob in oview(7, owner))
		if(!ishuman(target_mob))
			continue
		var/mob/living/carbon/human/target_human = target_mob
		if(target_human.stat)
			continue

		if(HAS_TRAIT(target_human, TRAIT_MINDSHIELD))
			to_chat(target_human, span_notice("你听到一阵低沉的嗡嗡声，仿佛有外物试图进入你的头脑，但这种噪音在几秒钟后便逐渐消失了."))
			continue

		broadcasted_mobs += target_human
		to_chat(target_human, span_userdanger("你突然感到一种无法抗拒的冲动，不得不去执行一个命令..."))
		to_chat(target_human, span_mind_control("[command]"))

		message_admins("[key_name(user)]从[key_name(owner)]向[key_name(target_human)]广播了一个劫持者心灵控制信息: [command]")
		user.log_message("[key_name(owner)]向[key_name(target_human)]广播了一个劫持者心灵控制信息: [command]", LOG_GAME)

		var/atom/movable/screen/alert/mind_control/mind_alert = target_human.throw_alert(ALERT_MIND_CONTROL, /atom/movable/screen/alert/mind_control)
		mind_alert.command = command

	if(LAZYLEN(broadcasted_mobs))
		active_mind_control = TRUE
		addtimer(CALLBACK(src, PROC_REF(clear_mind_control)), mind_control_duration)

	update_gland_hud()
	return TRUE

/obj/item/organ/internal/heart/gland/mindshock/clear_mind_control()
	if(!active_mind_control || !LAZYLEN(broadcasted_mobs))
		return FALSE
	for(var/target_mob in broadcasted_mobs)
		var/mob/living/carbon/human/target_human = target_mob
		to_chat(target_human, span_userdanger("你感觉到冲动逐渐消退并<b>完全忘记</b>了你之前的命令."))
		target_human.clear_alert(ALERT_MIND_CONTROL)
	active_mind_control = FALSE
	return TRUE
