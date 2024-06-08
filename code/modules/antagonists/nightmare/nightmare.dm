/datum/antagonist/nightmare
	name = "\improper 梦魇"
	antagpanel_category = ANTAG_GROUP_ABOMINATIONS // 反派组：畸变
	job_rank = ROLE_NIGHTMARE // 角色：梦魇
	show_in_antagpanel = FALSE // 不在反派面板中显示
	show_name_in_check_antagonists = TRUE // 在反派检查中显示名字
	show_to_ghosts = TRUE // 向幽灵显示
	ui_name = "AntagInfoNightmare" // 用户界面名称：AntagInfoNightmare
	suicide_cry = "为了黑暗！！" // 自杀喊叫
	preview_outfit = /datum/outfit/nightmare // 预览服装

/datum/antagonist/nightmare/greet()
	. = ..()
	owner.announce_objectives() // 宣布目标

/datum/antagonist/nightmare/on_gain()
	forge_objectives() // 锻造目标
	. = ..()

/datum/outfit/nightmare
	name = "梦魇（仅供预览）"

/datum/outfit/nightmare/post_equip(mob/living/carbon/human/human, visualsOnly)
	human.set_species(/datum/species/shadow/nightmare) // 设置种族为梦魇

/datum/objective/nightmare_fluff

/datum/objective/nightmare_fluff/New()
	var/list/explanation_texts = list(
		"吞噬空间站最后的光芒.",
		"对日行者进行审判.",
		"熄灭这鬼地方的火焰.",
		"揭示阴影的真正本质.",
		"从阴影中，一切都将灭亡.",
		"用刀剑或火焰召唤夜幕.",
		"将黑暗带入光明."
	)
	explanation_text = pick(explanation_texts) // 从解释文本中随机选择一个
	..()

/datum/objective/nightmare_fluff/check_completion()
	return owner.current.stat != DEAD // 检查完成条件，主人当前状态不为死亡

/datum/antagonist/nightmare/forge_objectives()
	var/datum/objective/nightmare_fluff/objective = new
	objective.owner = owner // 设置目标的主人
	objectives += objective // 添加目标

