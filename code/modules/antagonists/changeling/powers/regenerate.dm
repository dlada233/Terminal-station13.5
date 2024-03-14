/datum/action/changeling/regenerate
	name = "再生"
	desc = "能让我们再生和修复缺失的外肢和重要内脏器官，还能移除弹片，治愈重伤口以及补充血液. 使用该能力将花费10点化学物质."
	helptext = "如果有外肢再生将警告附近的人员，可以在失去意识的情况下使用."
	button_icon_state = "regenerate"
	chemical_cost = 10
	dna_cost = CHANGELING_POWER_INNATE
	req_stat = HARD_CRIT

/datum/action/changeling/regenerate/sting_action(mob/living/user)
	if(!iscarbon(user))
		user.balloon_alert(user, "无缺失!")
		return FALSE

	..()
	to_chat(user, span_notice("当你们的组织不断生长编织时，你们感到里里外外都发痒."))
	var/mob/living/carbon/carbon_user = user
	var/got_limbs_back = length(carbon_user.get_missing_limbs()) >= 1
	carbon_user.fully_heal(HEAL_BODY)
	// Occurs after fully heal so the ling themselves can hear the sound effects (if deaf prior)
	if(got_limbs_back)
		playsound(user, 'sound/magic/demon_consume.ogg', 50, TRUE)
		carbon_user.visible_message(
			span_warning("[user]缺失的肢体重新生长出来，发出响亮而怪异的声音!"),
			span_userdanger("伴随着剧痛与怪响，你们的肢体重新生长出来!"),
			span_hear("你听到了有机物撕裂的声音!"),
		)
		carbon_user.emote("scream")

	return TRUE
