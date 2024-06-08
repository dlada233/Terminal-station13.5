
/**
 * 当空间站获胜时，任何仍然存活的头领革命者都会成为“国家的敌人”，一个小型的独立反派.
 * 他们要么选择离开并做自己的事情，要么尝试通过劫持来恢复他们的荣誉.
 */
/datum/antagonist/enemy_of_the_state
	name = "\improper 叛国者"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	hijack_speed = 2 // 他们没有太多事情可做
	suicide_cry = "为永恒的革命而战!!"

/datum/antagonist/enemy_of_the_state/forge_objectives()
	var/datum/objective/exile/exile_choice = new
	exile_choice.owner = owner
	exile_choice.objective_name = "抉择"
	objectives += exile_choice

	var/datum/objective/hijack/hijack_choice = new
	hijack_choice.owner = owner
	hijack_choice.objective_name = "抉择"
	objectives += hijack_choice

/datum/antagonist/enemy_of_the_state/on_gain()
	owner.add_memory(/datum/memory/revolution_rev_defeat)
	owner.special_role = "exiled headrev"
	forge_objectives()
	. = ..()

/datum/antagonist/enemy_of_the_state/greet()
	. = ..()
	to_chat(owner, span_userdanger("革命已经死亡. "))
	to_chat(owner, span_boldannounce("你对纳诺特拉森来说是叛国者. 你对辛迪加来说是一个悬而未决的问题. "))
	to_chat(owner, "<b>是时候过上你作为流亡者的生活了...或者以最后的壮举结束一切. </b>")
	owner.announce_objectives()

/datum/antagonist/enemy_of_the_state/roundend_report()
	var/list/report = list()

	if(!owner)
		CRASH("未指定所有者的反派数据")

	report += printplayer(owner)

	// 只需要完成一个目标，而不是所有目标

	var/option_chosen = FALSE
	var/badass = FALSE
	if(objectives.len)
		report += printobjectives(objectives)
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				option_chosen = TRUE
				if(istype(objective, /datum/objective/hijack))
					badass = TRUE
				break

	if(objectives.len == 0 || option_chosen)
		if(badass)
			report += "<span class='greentext big'>[name]的重大胜利</span>"
			report += "<B>[name]选择了强硬的方式，并劫持了船只！</B>"
		else
			report += "<span class='greentext big'>[name]的次等胜利</span>"
			report += "<B>[name]成功存活为流亡者！</B>"
	else
		report += "<span class='redtext big'>[name]失败了！</span>"

	return report.Join("<br>")
