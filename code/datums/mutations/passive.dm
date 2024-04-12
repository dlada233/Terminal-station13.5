/datum/mutation/human/biotechcompat
	name = "生物技术兼容性"
	desc = "实验对象与技能芯片等生物技术更加兼容."
	quality = POSITIVE
	instability = 5

/datum/mutation/human/biotechcompat/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	owner.adjust_skillchip_complexity_modifier(1)

/datum/mutation/human/biotechcompat/on_losing(mob/living/carbon/human/owner)
	owner.adjust_skillchip_complexity_modifier(-1)
	return ..()

/datum/mutation/human/clever
	name = "聪慧"
	desc = "使受试者感觉稍微聪明一点。在智力水平低的样本中最有效."
	quality = POSITIVE
	instability = 20
	text_gain_indication = "<span class='danger'>你感觉更加智慧了一点.</span>"
	text_lose_indication = "<span class='danger'>你的头脑像是蒙上了薄雾.</span>"

/datum/mutation/human/clever/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.add_traits(list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LITERATE), GENETIC_MUTATION)

/datum/mutation/human/clever/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.remove_traits(list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LITERATE), GENETIC_MUTATION)
