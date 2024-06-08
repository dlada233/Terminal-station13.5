/datum/traitor_objective/ultimate/battlecruiser
	name = "向附近的辛迪加战巡舰透露空间站坐标"
	description = "使用一个特殊的上传卡片在通讯终端上发送空间站的坐标到附近的战巡舰.\
	当战巡舰到达时，你可能需要向战巡舰船员表明你的辛迪加身份——因为他们的目标是摧毁整个空间站."

	/// 检查我们是否已经将卡片发送给叛徒.
	var/sent_accesscard = FALSE
	/// 我们被分配到的战巡舰团队
	var/datum/team/battlecruiser/team

/datum/traitor_objective/ultimate/battlecruiser/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	// 没有空余的空间来加载战巡舰...
	if(SSmapping.is_planetary())
		return FALSE

	return TRUE

/datum/traitor_objective/ultimate/battlecruiser/on_objective_taken(mob/user)
	. = ..()
	team = new()
	var/obj/machinery/nuclearbomb/selfdestruct/nuke = locate() in SSmachines.get_machines_by_type(/obj/machinery/nuclearbomb/selfdestruct)
	if(nuke.r_code == NUKE_CODE_UNSET)
		nuke.r_code = random_nukecode()
	team.nuke = nuke
	team.update_objectives()
	handler.owner.add_antag_datum(/datum/antagonist/battlecruiser/ally, team)

/datum/traitor_objective/ultimate/battlecruiser/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!sent_accesscard)
		buttons += add_ui_button("", "按下此按钮将生成一个上传卡片，你可以在通讯终端上使用它来联系舰队.", "phone", "card")
	return buttons

/datum/traitor_objective/ultimate/battlecruiser/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if("card")
			if(sent_accesscard)
				return
			sent_accesscard = TRUE
			var/obj/item/card/emag/battlecruiser/emag_card = new()
			emag_card.team = team
			podspawn(list(
				"target" = get_turf(user),
				"style" = STYLE_SYNDICATE,
				"spawn" = emag_card,
			))
