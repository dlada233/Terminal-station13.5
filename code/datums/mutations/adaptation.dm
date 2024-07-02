/datum/mutation/human/temperature_adaptation
	name = "温度适应性"
	desc = "一种奇怪的变异，使宿主免受极端温度的损伤，但无法抵御真空环境."
	quality = POSITIVE
	difficulty = 16
	text_gain_indication = "<span class='notice'>你感觉身体很暖!</span>"
	instability = POSITIVE_INSTABILITY_MAJOR
	conflicts = list(/datum/mutation/human/pressure_adaptation)

/datum/mutation/human/temperature_adaptation/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/mob/effects/genetics.dmi', "fire", -MUTATIONS_LAYER))

/datum/mutation/human/temperature_adaptation/get_visual_indicator()
	return visual_indicators[type][1]

/datum/mutation/human/temperature_adaptation/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.add_traits(list(TRAIT_RESISTCOLD, TRAIT_RESISTHEAT), GENETIC_MUTATION)

/datum/mutation/human/temperature_adaptation/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.remove_traits(list(TRAIT_RESISTCOLD, TRAIT_RESISTHEAT), GENETIC_MUTATION)

/datum/mutation/human/pressure_adaptation
	name = "压力适应性"
	desc = "一种奇怪的变异，使宿主免受高压和低压环境的损伤，但无法抵御极端温度，包括了太空的超低温."
	quality = POSITIVE
	difficulty = 16
	text_gain_indication = "<span class='notice'>你感觉身体变得麻木!</span>"
	instability = POSITIVE_INSTABILITY_MAJOR
	conflicts = list(/datum/mutation/human/temperature_adaptation)

/datum/mutation/human/pressure_adaptation/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/mob/effects/genetics.dmi', "pressure", -MUTATIONS_LAYER))

/datum/mutation/human/pressure_adaptation/get_visual_indicator()
	return visual_indicators[type][1]

/datum/mutation/human/pressure_adaptation/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.add_traits(list(TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTHIGHPRESSURE), GENETIC_MUTATION)

/datum/mutation/human/pressure_adaptation/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.remove_traits(list(TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTHIGHPRESSURE), GENETIC_MUTATION)
