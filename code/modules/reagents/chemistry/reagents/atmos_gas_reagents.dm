/datum/reagent/freon
	name = "Freon-氟利昂"
	description = "强效吸热气体."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because nitrium/freon/hypernoblium are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "灼烧"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/freon/on_mob_metabolize(mob/living/breather)
	. = ..()
	breather.add_movespeed_modifier(/datum/movespeed_modifier/reagent/freon)

/datum/reagent/freon/on_mob_end_metabolize(mob/living/breather)
	. = ..()
	breather.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/freon)

/datum/reagent/halon
	name = "Halon-哈龙"
	description = "一种灭火气体，可以除去氧气并使该区域降温."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5
	color = "90560B"
	taste_description = "薄荷"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/halon/on_mob_metabolize(mob/living/breather)
	. = ..()
	breather.add_movespeed_modifier(/datum/movespeed_modifier/reagent/halon)
	ADD_TRAIT(breather, TRAIT_RESISTHEAT, type)

/datum/reagent/halon/on_mob_end_metabolize(mob/living/breather)
	. = ..()
	breather.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/halon)
	REMOVE_TRAIT(breather, TRAIT_RESISTHEAT, type)

/datum/reagent/healium
	name = "Healium-疗气"
	description = "一种具有治疗功效的强效安眠气体."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5
	color = "90560B"
	taste_description = "橡胶"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/healium/on_mob_end_metabolize(mob/living/breather)
	. = ..()
	breather.SetSleeping(1 SECONDS)

/datum/reagent/healium/on_mob_life(mob/living/breather, seconds_per_tick, times_fired)
	. = ..()
	breather.SetSleeping(30 SECONDS)
	var/need_mob_update
	need_mob_update = breather.adjustFireLoss(-2 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += breather.adjustToxLoss(-5 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += breather.adjustBruteLoss(-2 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/hypernoblium
	name = "Hyper-Noblium-超铌"
	description = "一种抑制气体，可以阻止吸入者的气体反应."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because nitrium/freon/hyper-nob are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "灸冷"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/hypernoblium/on_mob_life(mob/living/carbon/breather, seconds_per_tick, times_fired)
	. = ..()
	if(isplasmaman(breather))
		breather.set_timed_status_effect(10 SECONDS * REM * seconds_per_tick, /datum/status_effect/hypernob_protection)

/datum/reagent/nitrium_high_metabolization
	name = "Nitrosyl plasmide"
	description = "这是一种高度反应性的副产品，它会让你无法入睡，同时随着时间的推移，毒素的损害会越来越大."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because nitrium/freon/hypernoblium are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "E1A116"
	taste_description = "酸"
	ph = 1.8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	addiction_types = list(/datum/addiction/stimulants = 14)

/datum/reagent/nitrium_high_metabolization/on_mob_metabolize(mob/living/breather)
	. = ..()
	ADD_TRAIT(breather, TRAIT_SLEEPIMMUNE, type)

/datum/reagent/nitrium_high_metabolization/on_mob_end_metabolize(mob/living/breather)
	. = ..()
	REMOVE_TRAIT(breather, TRAIT_SLEEPIMMUNE, type)

/datum/reagent/nitrium_high_metabolization/on_mob_life(mob/living/carbon/breather, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = breather.adjustStaminaLoss(-2 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
	need_mob_update += breather.adjustToxLoss(0.1 * (current_cycle-1) * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype) // 1 toxin damage per cycle at cycle 10
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/nitrium_low_metabolization
	name = "Nitrium-亚硝基兴奋气"
	description = "一种高活性气体，能让你感觉更快."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because nitrium/freon/hypernoblium are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "灼烧"
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/nitrium_low_metabolization/on_mob_metabolize(mob/living/breather)
	. = ..()
	breather.add_movespeed_modifier(/datum/movespeed_modifier/reagent/nitrium)

/datum/reagent/nitrium_low_metabolization/on_mob_end_metabolize(mob/living/breather)
	. = ..()
	breather.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/nitrium)

/datum/reagent/pluoxium
	name = "Pluoxium-钷"
	description = "这种气体的肺扩散效率是氧气的八倍，对睡眠中的病人有器官愈合作用."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5
	color = "#808080"
	taste_description = "辐照空气"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/pluoxium/on_mob_life(mob/living/carbon/breather, seconds_per_tick, times_fired)
	. = ..()
	if(!HAS_TRAIT(breather, TRAIT_KNOCKEDOUT))
		return

	for(var/obj/item/organ/organ_being_healed as anything in breather.organs)
		if(!organ_being_healed.damage)
			continue

		if(organ_being_healed.apply_organ_damage(-0.5 * REM * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC))
			. = UPDATE_MOB_HEALTH

/datum/reagent/zauker
	name = "Zauker-瘴气"
	description = "一种对所有生物都有毒的不稳定气体."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5
	color = "90560B"
	taste_description = "苦"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE
	affected_biotype = MOB_ORGANIC | MOB_MINERAL | MOB_PLANT // "toxic to all living beings"
	affected_respiration_type = ALL

/datum/reagent/zauker/on_mob_life(mob/living/breather, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = breather.adjustBruteLoss(6 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += breather.adjustOxyLoss(1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	need_mob_update += breather.adjustFireLoss(2 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += breather.adjustToxLoss(2 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH
