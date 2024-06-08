/datum/antagonist/santa
	name = "\improper 圣诞老人"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	suicide_cry = "圣诞节万岁!!"

/datum/antagonist/santa/on_gain()
	. = ..()
	give_equipment()
	give_objective()

	owner.add_traits(list(TRAIT_CANNOT_OPEN_PRESENTS, TRAIT_PRESENT_VISION), TRAIT_SANTA)

/datum/antagonist/santa/greet()
	. = ..()
	to_chat(owner, span_boldannounce("你的目标是给这个空间站的大伙带来欢乐. 你有一个神奇的袋子，只要持有就会源源不断地生成礼物! 你可以检查一下礼物，看看里面是什么，以确保你把合适的礼物送给了合适的人."))

/datum/antagonist/santa/proc/give_equipment()
	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		H.equipOutfit(/datum/outfit/santa)
		H.dna.update_dna_identity()

	var/datum/action/cooldown/spell/teleport/area_teleport/wizard/santa/teleport = new(owner)
	teleport.Grant(H)

/datum/antagonist/santa/proc/give_objective()
	var/datum/objective/santa_objective = new()
	santa_objective.explanation_text = "给空间站带来欢乐与礼物!"
	santa_objective.completed = TRUE //lets cut our santas some slack.
	santa_objective.owner = owner
	objectives |= santa_objective
