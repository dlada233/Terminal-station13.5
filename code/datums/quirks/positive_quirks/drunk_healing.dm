/datum/quirk/drunkhealing
	name = "Drunken Resilience-醉酒韧性"
	desc = "没有什么比一杯好酒更能让你感到快乐的了。每当你喝醉了，就能慢慢恢复你的伤口。."
	icon = FA_ICON_WINE_BOTTLE
	value = 8
	gain_text = span_notice("你感到喝上一杯对你有益健康.")
	lose_text = span_danger("你不再感到能靠酒精消去你的苦痛.")
	medical_record_text = "患者的肝脏代谢功能异常高效，能通过饮酒来促进伤口缓慢再生."
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/booze)

/datum/quirk/drunkhealing/process(seconds_per_tick)
	var/need_mob_update = FALSE
	switch(quirk_holder.get_drunk_amount())
		if (6 to 40)
			need_mob_update += quirk_holder.adjustBruteLoss(-0.1 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
			need_mob_update += quirk_holder.adjustFireLoss(-0.05 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
		if (41 to 60)
			need_mob_update += quirk_holder.adjustBruteLoss(-0.4 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
			need_mob_update += quirk_holder.adjustFireLoss(-0.2 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
		if (61 to INFINITY)
			need_mob_update += quirk_holder.adjustBruteLoss(-0.8 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
			need_mob_update += quirk_holder.adjustFireLoss(-0.4 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
	if(need_mob_update)
		quirk_holder.updatehealth()
