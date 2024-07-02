// Sidepaths for knowledge between Cosmos and Ash.

/datum/heretic_knowledge/summon/fire_shark
	name = "炎鲨-Fire shark"
	desc = "你可以将一团灰烬、一块肝和一块等离子嬗变出一只火鲨. \
		火鲨在群体行动时迅捷且致命，但也很容易死掉. 它们对烧伤有很强的抗性. \
		攻击时向目标体内注射燃素，并在杀死目标后产生等离子."
	gain_text = "星云摇篮冷寂无边，但并非死气沉沉，光与热掠过最深的黑暗，捕食者静待以猎杀."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/cosmic_runes,
		/datum/heretic_knowledge/spell/ash_passage,
	)
	required_atoms = list(
		/obj/effect/decal/cleanable/ash = 1,
		/obj/item/organ/internal/liver = 1,
		/obj/item/stack/sheet/mineral/plasma = 1,
	)
	mob_to_summon = /mob/living/basic/heretic_summon/fire_shark
	cost = 1
	route = PATH_SIDE
	poll_ignore_define = POLL_IGNORE_FIRE_SHARK

/datum/heretic_knowledge/spell/space_phase
	name = "太空相位"
	desc = "赐予你太空相位，一个能让你在太空中自由移动的咒语. \
		你只能在太空或装饰性地块上进出相位空间."
	gain_text = "你发现你能像在尘埃中遁行那般游弋太空."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/star_blast,
		/datum/heretic_knowledge/mad_mask,
	)
	spell_to_add = /datum/action/cooldown/spell/jaunt/space_crawl
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/eldritch_coin
	name = "诡奇硬币-Eldritch coin"
	desc = "你可以将一块等离子体和一颗钻石嬗变成一枚诡奇硬币. \
		抛出硬币，当硬币正面朝上时，它会打开或关闭附近的门；当硬币反面朝上时，它会拴住或打开附近的门. \
		如果将硬币插入气闸门，它会EMGA气闸门并摧毁硬币自身."
	gain_text = "漫宿盈满了罪恶，而贪婪在里面有特殊的分量."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/cosmic_expansion,
		/datum/heretic_knowledge/spell/flame_birth,
	)
	required_atoms = list(
		/obj/item/stack/sheet/mineral/diamond = 1,
		/obj/item/stack/sheet/mineral/plasma = 1,
	)
	result_atoms = list(/obj/item/coin/eldritch)
	cost = 1
	route = PATH_SIDE
