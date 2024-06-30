// Sidepaths for knowledge between Knock and Flesh.
/datum/heretic_knowledge/spell/opening_blast
	name = "绝望之潮"
	desc = "赐予你绝望之潮，只能在被束缚的时候使用，它能解除你的束缚，同时击退并击倒附近的人并施加漫宿之握."
	gain_text = "我的镣铐在暗的暴怒下瓦解，脆弱的束缚在我的力量前不值一提."
	next_knowledge = list(
		/datum/heretic_knowledge/summon/raw_prophet,
		/datum/heretic_knowledge/spell/burglar_finesse,
	)
	spell_to_add = /datum/action/cooldown/spell/aoe/wave_of_desperation
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/spell/apetra_vulnera
	name = "皮开肉绽" // Apetra Vulnera 拉丁语
	desc = "赐予你阿皮托符多拉，使目标的所有受创伤超过15点的身体部位大量出血，如果没有部位符合条件，则随机让一个部位重伤."
	gain_text = "肉开了，血洒了. 我的主人要祭品，我要满足它."
	next_knowledge = list(
		/datum/heretic_knowledge/summon/stalker,
		/datum/heretic_knowledge/spell/caretaker_refuge,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/apetra_vulnera
	cost = 1
	route = PATH_SIDE
