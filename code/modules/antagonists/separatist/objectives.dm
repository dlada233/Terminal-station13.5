/datum/objective/destroy_nation
	name = "摧毁国家"
	explanation_text = "确保敌对国家的任何成员都无法幸存逃脱！"
	team_explanation_text = "确保敌对国家的任何成员都无法幸存逃脱！"
	var/datum/team/nation/target_team

/datum/objective/destroy_nation/New(text, target_department)
	. = ..()
	target_team = target_department
	update_explanation_text()

/datum/objective/destroy_nation/Destroy()
	target_team = null
	. = ..()

/datum/objective/destroy_nation/update_explanation_text()
	. = ..()
	if(target_team)
		explanation_text = "确保国家[target_team] ([target_team.department.department_name])的任何成员都无法幸存逃脱！"
	else
		explanation_text = "自由目标"

/datum/objective/destroy_nation/check_completion()
	if(!target_team)
		return TRUE

	for(var/datum/antagonist/separatist/separatist_datum in GLOB.antagonists)
		if(separatist_datum.nation.department != target_team.department) // 一个分裂者，但不是我们需要摧毁的部门的一部分
			continue
		var/datum/mind/target = separatist_datum.owner
		if(target && considered_alive(target) && (target.current.onCentCom() || target.current.onSyndieBase()))
			return FALSE // 至少有一个成员逃脱了
	return TRUE

/datum/objective/separatist_fluff

/datum/objective/separatist_fluff/New(text, nation_name)
	explanation_text = pick(list(
		"整个站点必须因享受[nation_name]服务而缴税. ",
		"到处制作你们光荣领袖的雕像，如果没有，就在你们之中选择一个加冕！",
		"[nation_name]必须装点得富丽堂皇. ",
		"尽可能损坏站点的大部分区域，让它处于失修状态. [nation_name]必须是和平与繁荣的典范！",
		"加固[nation_name]以防范外界危险. ",
		"确保[nation_name]完全独立自主，不需要依赖其他部门提供电力或任何服务！",
		"在站点最需要你们的时候拯救它. [nation_name]将被视为守护者. ",
		"武装起来. [nation_name]的公民有持有武器的权利. ",
	))
	..()

/datum/objective/separatist_fluff/check_completion()
	return TRUE

/datum/objective/united_nations
	explanation_text = "维护站点上的和平. 确保每个国家在回合结束时都有活着的代表. "
	team_explanation_text = "维护站点上的和平. 确保每个国家在回合结束时都有活着的代表. "

/datum/objective/united_nations/check_completion()
	var/list/all_separatists = list()
	var/list/alive_separatists = list()

	for(var/datum/team/nation/separatist_team in GLOB.antagonist_teams)
		all_separatists |= separatist_team.department
		for(var/datum/mind/separatist as anything in separatist_team.members)
			if(considered_escaped(separatist))
				alive_separatists |= separatist_team.department
				break

	return length(all_separatists) == length(alive_separatists)
