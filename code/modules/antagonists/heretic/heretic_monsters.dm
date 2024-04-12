///Tracking reasons
/datum/antagonist/heretic_monster
	name = "\improper 邪恶恐惧"
	roundend_category = "Heretics"
	antagpanel_category = ANTAG_GROUP_HORRORS
	antag_moodlet = /datum/mood_event/heretics
	job_rank = ROLE_HERETIC
	antag_hud_name = "heretic_beast"
	suicide_cry = "我的主人在对我微笑!!"
	show_in_antagpanel = FALSE
	/// Our master (a heretic)'s mind.
	var/datum/mind/master

/datum/antagonist/heretic_monster/on_gain()
	. = ..()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ecult_op.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)//subject to change

/datum/antagonist/heretic_monster/on_removal()
	if(!silent)
		if(master?.current)
			to_chat(master.current, span_warning("[owner]的要素，你的仆从，从你的脑海中消失了."))
		if(owner.current)
			to_chat(owner.current, span_deconversion_message("你的思维开始充斥阴霾 - 你的主人不再[master ? "是[master]":""]，你自由了!"))
			owner.current.visible_message(span_deconversion_message("[owner.current]看起来挣脱了漫宿的束缚!"), ignored_mobs = owner.current)

	master = null
	return ..()

/*
 * Set our [master] var to a new mind.
 */
/datum/antagonist/heretic_monster/proc/set_owner(datum/mind/master)
	src.master = master

	var/datum/objective/master_obj = new()
	master_obj.owner = owner
	master_obj.explanation_text = "帮助你的主人."
	master_obj.completed = TRUE

	objectives += master_obj
	owner.announce_objectives()
	to_chat(owner, span_boldnotice("你是一个通过漫宿之门到达本位面的[ishuman(owner.current) ? "呆滞的复生尸体":"恐怕的创造物"]."))
	to_chat(owner, span_notice("全力协助你的主人[master]."))
