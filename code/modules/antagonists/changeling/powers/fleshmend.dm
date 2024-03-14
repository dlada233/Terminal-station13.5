/datum/action/changeling/fleshmend
	name = "补肉"
	desc = "我们迅速再生肉体，治愈烧伤、创伤和窒息伤，同时隐藏所有的伤疤. 花费20点化学物质."
	helptext = "若我们着了火则无法进行治疗，并且也不能再生肢体或血液. 但该能力可以在失去意识的状态下使用."
	button_icon_state = "fleshmend"
	chemical_cost = 20
	dna_cost = 2
	req_stat = HARD_CRIT

//Starts healing you every second for 10 seconds.
//Can be used whilst unconscious.
/datum/action/changeling/fleshmend/sting_action(mob/living/user)
	if(user.has_status_effect(/datum/status_effect/fleshmend))
		user.balloon_alert(user, "已经在再生了!")
		return
	..()
	to_chat(user, span_notice("我们开始迅速再生."))
	user.apply_status_effect(/datum/status_effect/fleshmend)
	return TRUE

//Check buffs.dm for the fleshmend status effect code
