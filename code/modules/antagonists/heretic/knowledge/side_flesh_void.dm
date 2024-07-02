// Sidepaths for knowledge between Flesh and Void.

/datum/heretic_knowledge/void_cloak
	name = "虚空斗篷-Void cloak"
	desc = "你能将一块玻璃碎片、一张床单和任意外层衣物嬗变成虚空斗篷. \
		当戴上兜帽，这件斗篷让你完全隐形，当放下兜帽时，斗篷可以视作焦点. \
		这件斗篷也提供不错的护甲和储存空间，足以容纳你的一把刀刃，各种仪式道具（如器官）和一些异教徒小道具."
	gain_text = "猫头鹰守护实际难以言明，但存在于见解中的事物，这个世界上的有太多事物都是如此."
	next_knowledge = list(
		/datum/heretic_knowledge/limited_amount/flesh_ghoul,
		/datum/heretic_knowledge/cold_snap,
	)
	required_atoms = list(
		/obj/item/shard = 1,
		/obj/item/clothing/suit = 1,
		/obj/item/bedsheet = 1,
	)
	result_atoms = list(/obj/item/clothing/suit/hooded/cultrobes/void)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/spell/blood_siphon
	name = "吸血术"
	desc = "赐予你吸血术的咒语，让你能吸取目标的血液和生命力，同时有机会将你的重伤口转移到目标身上."
	gain_text = "\"不管是谁，都会一样流血.\" 元帅如是说."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/void_phase,
		/datum/heretic_knowledge/summon/raw_prophet,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/blood_siphon
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/spell/cleave
	name = "出血斩"
	desc = "赐予你出血斩，一种范围咒语，使受影响的目标大量流血或失血."
	gain_text = "起初我不是很懂这些战争手段，但祭司告诉我必须得使用它们，他说我很快就能掌握它们."
	next_knowledge = list(
		/datum/heretic_knowledge/summon/stalker,
		/datum/heretic_knowledge/spell/void_pull,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/cleave
	cost = 1
	route = PATH_SIDE
