/datum/antagonist/survivalist
	name = "\improper 生存主义者"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	suicide_cry = "为了我自己!!"
	var/greet_message = ""

/datum/antagonist/survivalist/forge_objectives()
	var/datum/objective/survive/survive = new
	survive.owner = owner
	objectives += survive

/datum/antagonist/survivalist/on_gain()
	owner.special_role = "survivalist"
	forge_objectives()
	. = ..()

/datum/antagonist/survivalist/greet()
	. = ..()
	to_chat(owner, "<B>[greet_message]</B>")
	owner.announce_objectives()

/datum/antagonist/survivalist/guns
	greet_message = "你自己的安全高于一切，而确保你安全的唯一方法就是囤枪! 尽可能地囤枪! 用任何必要手段囤枪! 杀了所有妨碍你的人!"
	hardcore_random_bonus = TRUE

/datum/antagonist/survivalist/guns/forge_objectives()
	var/datum/objective/steal_n_of_type/summon_guns/guns = new
	guns.owner = owner
	objectives += guns
	..()

/datum/antagonist/survivalist/magic
	name = "业余魔法师"
	greet_message = "培养你的魔法才能! 尽可能地夺取魔法物品! 不择手段地夺取魔法物品! 杀了所有妨碍你的人!"
	hardcore_random_bonus = TRUE

/datum/antagonist/survivalist/magic/greet()
	. = ..()
	to_chat(owner, span_notice("作为一个出色的魔法师，你应该记住，魔法书用完就没有任何意义了."))

/datum/antagonist/survivalist/magic/forge_objectives()
	var/datum/objective/steal_n_of_type/summon_magic/magic = new
	magic.owner = owner
	objectives += magic
	..()

/datum/antagonist/survivalist/magic/on_gain()
	. = ..()
	ADD_TRAIT(owner, TRAIT_MAGICALLY_GIFTED, REF(src))

/datum/antagonist/survivalist/magic/on_removal()
	REMOVE_TRAIT(owner, TRAIT_MAGICALLY_GIFTED, REF(src))
	return..()
