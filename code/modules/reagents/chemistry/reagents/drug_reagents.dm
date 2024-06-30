/datum/reagent/drug
	name = "Drug"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "bitterness"
	var/trippy = TRUE //Does this drug make you trip?

/datum/reagent/drug/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	if(trippy)
		affected_mob.clear_mood_event("[type]_high")

/datum/reagent/drug/space_drugs
	name = "Space Drugs-太空毒品"
	description = "用作毒品的非法化合物."
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 30
	ph = 9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/hallucinogens = 10) //4 per 2 seconds

/datum/reagent/drug/space_drugs/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.set_drugginess(30 SECONDS * REM * seconds_per_tick)
	if(isturf(affected_mob.loc) && !isspaceturf(affected_mob.loc) && !HAS_TRAIT(affected_mob, TRAIT_IMMOBILIZED) && SPT_PROB(5, seconds_per_tick))
		step(affected_mob, pick(GLOB.cardinals))
	if(SPT_PROB(3.5, seconds_per_tick))
		affected_mob.emote(pick("twitch","drool","moan","giggle"))

/datum/reagent/drug/space_drugs/overdose_start(mob/living/affected_mob)
	. = ..()
	to_chat(affected_mob, span_userdanger("你绊倒了!"))
	affected_mob.add_mood_event("[type]_overdose", /datum/mood_event/overdose, name)

/datum/reagent/drug/space_drugs/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/hallucination_duration_in_seconds = (affected_mob.get_timed_status_effect_duration(/datum/status_effect/hallucination) / 10)
	if(hallucination_duration_in_seconds < volume && SPT_PROB(10, seconds_per_tick))
		affected_mob.adjust_hallucinations(10 SECONDS)

/datum/reagent/drug/cannabis
	name = "Cannabis-大麻素"
	description = "从大麻植物中提取的一种精神药物，用于娱乐目的."
	color = "#059033"
	overdose_threshold = INFINITY
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	metabolization_rate = 0.125 * REAGENTS_METABOLISM

/datum/reagent/drug/cannabis/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.apply_status_effect(/datum/status_effect/stoned)
	if(SPT_PROB(1, seconds_per_tick))
		var/smoke_message = pick("你感到放松.","你感到平静.","你觉得口干.","你可以喝点水.","你的心跳很快.","你感到笨拙.","你渴望垃圾食品.","你注意到你的动作变慢了.")
		to_chat(affected_mob, "<span class='notice'>[smoke_message]</span>")
	if(SPT_PROB(2, seconds_per_tick))
		affected_mob.emote(pick("smile","laugh","giggle"))
	affected_mob.adjust_nutrition(-0.15 * REM * seconds_per_tick) //munchies
	if(SPT_PROB(4, seconds_per_tick) && affected_mob.body_position == LYING_DOWN && !affected_mob.IsSleeping()) //chance to fall asleep if lying down
		to_chat(affected_mob, "<span class='warning'>你打瞌睡了...</span>")
		affected_mob.Sleeping(10 SECONDS)
	if(SPT_PROB(4, seconds_per_tick) && affected_mob.buckled && affected_mob.body_position != LYING_DOWN && !affected_mob.IsParalyzed()) //chance to be couchlocked if sitting
		to_chat(affected_mob, "<span class='warning'>太舒服了，动都动不了...</span>")
		affected_mob.Paralyze(10 SECONDS)

/datum/reagent/drug/nicotine
	name = "Nicotine-尼古丁"
	description = "轻微减少眩晕时间，如果服用过量，会造成毒素和氧气损伤."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	taste_description = "烟"
	trippy = FALSE
	overdose_threshold = 15
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	ph = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/nicotine = 18) // 7.2 per 2 seconds

	//Nicotine is used as a pesticide IRL.
/datum/reagent/drug/nicotine/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(round(volume))
	mytray.adjust_pestlevel(-rand(1, 2))

/datum/reagent/drug/nicotine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(0.5, seconds_per_tick))
		var/smoke_message = pick("你感到放松.", "你感到平静.","你感到警觉.","你觉得很粗糙.")
		to_chat(affected_mob, span_notice("[smoke_message]"))
	affected_mob.add_mood_event("smoked", /datum/mood_event/smoked)
	affected_mob.remove_status_effect(/datum/status_effect/jitter)
	affected_mob.AdjustAllImmobility(-50 * REM * seconds_per_tick)

	return UPDATE_MOB_HEALTH

/datum/reagent/drug/nicotine/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustToxLoss(0.1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustOxyLoss(1.1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/krokodil
	name = "Krokodil-二氢脱氧吗啡"
	description = "让你冷静下来，如果过量服用，会对大脑造成严重损害，还会产生毒素."
	reagent_state = LIQUID
	color = "#0064B4"
	overdose_threshold = 20
	ph = 9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/opioids = 18) //7.2 per 2 seconds


/datum/reagent/drug/krokodil/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/high_message = pick("你感到平静.", "你感到镇定.", "你觉得你需要放松.")
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[high_message]"))
	affected_mob.add_mood_event("smacked out", /datum/mood_event/narcotic_heavy)
	if(current_cycle == 36 && creation_purity <= 0.6)
		if(!istype(affected_mob.dna.species, /datum/species/human/krokodil_addict))
			to_chat(affected_mob, span_userdanger("你的毛发很容易脱落!"))
			var/mob/living/carbon/human/affected_human = affected_mob
			affected_human.set_facial_hairstyle("Shaved", update = FALSE)
			affected_human.set_hairstyle("Bald", update = FALSE)
			affected_mob.set_species(/datum/species/human/krokodil_addict)
			if(affected_mob.adjustBruteLoss(50 * REM, updating_health = FALSE, required_bodytype = affected_bodytype)) // holy shit your skin just FELL THE FUCK OFF
				return UPDATE_MOB_HEALTH

/datum/reagent/drug/krokodil/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.25 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	need_mob_update = affected_mob.adjustToxLoss(0.25 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/methamphetamine
	name = "Methamphetamine-冰毒"
	description = "减少晕眩时间约300%，加速使用者，并允许使用者快速恢复耐力，同时造成少量脑损伤；如果服用过量，受试者将随机移动，随机大笑，掉落物品，并遭受毒素和脑损伤；如果上瘾，受试者会不断地颤抖和流口水，然后变得头晕，失去运动控制，最终遭受严重的毒素损害."
	reagent_state = LIQUID
	color = "#78C8FA" //best case scenario is the "default", gets muddled depending on purity
	overdose_threshold = 20
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	ph = 5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/stimulants = 12) //4.8 per 2 seconds
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/drug/methamphetamine/on_new(data)
	. = ..()
	//the more pure, the less non-blue colors get involved - best case scenario is rgb(135, 200, 250) AKA #78C8FA
	//worst case scenario is rgb(250, 250, 250) AKA #FAFAFA
	//minimum purity of meth is 50%, therefore we base values on that
	var/effective_impurity = min(1, (1 - creation_purity)/0.5)
	//yes i know that purity doesn't actually affect how meth works at all but this is so funny
	color = BlendRGB(initial(color), "#FAFAFA", effective_impurity)

//we need to update the color whenever purity gets changed
/datum/reagent/drug/methamphetamine/on_merge(data, amount)
	. = ..()
	var/effective_impurity = min(1, (1 - creation_purity)/0.5)
	color = BlendRGB(initial(color), "#FAFAFA", effective_impurity)

/datum/reagent/drug/methamphetamine/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.add_movespeed_modifier(/datum/movespeed_modifier/reagent/methamphetamine)

/datum/reagent/drug/methamphetamine/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/methamphetamine)

/datum/reagent/drug/methamphetamine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/high_message = pick("你感到亢奋.", "你觉得你需要更快一点.", "你觉得你可以掌控世界.")
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[high_message]"))
	affected_mob.add_mood_event("tweaking", /datum/mood_event/stimulant_medium)
	affected_mob.AdjustAllImmobility(-40 * REM * seconds_per_tick)
	var/need_mob_update
	need_mob_update = affected_mob.adjustStaminaLoss(-2 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
	affected_mob.set_jitter_if_lower(4 SECONDS * REM * seconds_per_tick)
	need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(1, 4) * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(need_mob_update)
		. = UPDATE_MOB_HEALTH
	if(SPT_PROB(2.5, seconds_per_tick))
		affected_mob.emote(pick("twitch", "shiver"))

/datum/reagent/drug/methamphetamine/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!HAS_TRAIT(affected_mob, TRAIT_IMMOBILIZED) && !ismovable(affected_mob.loc))
		for(var/i in 1 to round(4 * REM * seconds_per_tick, 1))
			step(affected_mob, pick(GLOB.cardinals))
	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.emote("laugh")
	if(SPT_PROB(18, seconds_per_tick))
		affected_mob.visible_message(span_danger("[affected_mob]的手翻了出来到处乱挥!"))
		affected_mob.drop_all_held_items()
	var/need_mob_update
	need_mob_update = affected_mob.adjustToxLoss(1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, (rand(5, 10) / 10) * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/bath_salts
	name = "Bath Salts-浴盐"
	description = "使你不受昏迷影响，并获得耐力恢复buff，但你将成为一个几乎无法控制的流浪汉疯子."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 20
	taste_description = "盐" // because they're bathsalts?
	addiction_types = list(/datum/addiction/stimulants = 25)  //8 per 2 seconds
	ph = 8.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	metabolized_traits = list(TRAIT_STUNIMMUNE, TRAIT_SLEEPIMMUNE, TRAIT_ANALGESIA, TRAIT_STIMULATED)
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/drug/bath_salts/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if(iscarbon(affected_mob))
		var/mob/living/carbon/carbon_mob = affected_mob
		rage = new()
		carbon_mob.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/drug/bath_salts/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	if(rage)
		QDEL_NULL(rage)

/datum/reagent/drug/bath_salts/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/high_message = pick("你感到精神振奋.", "你感到一切就绪.", "你觉得你可以把它推到极限.")
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[high_message]"))
	affected_mob.add_mood_event("salted", /datum/mood_event/stimulant_heavy)
	var/need_mob_update
	need_mob_update = affected_mob.adjustStaminaLoss(-5 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 4 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	affected_mob.adjust_hallucinations(10 SECONDS * REM * seconds_per_tick)
	if(need_mob_update)
		. = UPDATE_MOB_HEALTH
	if(!HAS_TRAIT(affected_mob, TRAIT_IMMOBILIZED) && !ismovable(affected_mob.loc))
		step(affected_mob, pick(GLOB.cardinals))
		step(affected_mob, pick(GLOB.cardinals))

/datum/reagent/drug/bath_salts/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_hallucinations(10 SECONDS * REM * seconds_per_tick)
	if(!HAS_TRAIT(affected_mob, TRAIT_IMMOBILIZED) && !ismovable(affected_mob.loc))
		for(var/i in 1 to round(8 * REM * seconds_per_tick, 1))
			step(affected_mob, pick(GLOB.cardinals))
	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.emote(pick("twitch","drool","moan"))
	if(SPT_PROB(28, seconds_per_tick))
		affected_mob.drop_all_held_items()

/datum/reagent/drug/aranesp
	name = "Aranesp-阿拉内普"
	description = "让你振作起来，让你继续前进，并迅速恢复耐力伤害，副作用包括呼吸困难和中毒."
	reagent_state = LIQUID
	color = "#78FFF0"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/stimulants = 8)
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/drug/aranesp/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/high_message = pick("你感到精神振奋.", "你感到一切就绪.", "你觉得你可以把它推到极限.")
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[high_message]"))
	var/need_mob_update
	need_mob_update = affected_mob.adjustStaminaLoss(-18 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustToxLoss(0.5 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	if(SPT_PROB(30, seconds_per_tick))
		affected_mob.losebreath++
		need_mob_update += affected_mob.adjustOxyLoss(1, FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/happiness
	name = "Happiness-快活剂"
	description = "让你产生迷魂药般的麻木感并造成轻微的脑损伤，很容易上瘾，如果过量服用会导致突然的情绪波动."
	reagent_state = LIQUID
	color = "#EE35FF"
	overdose_threshold = 20
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	taste_description = "paint thinner"
	addiction_types = list(/datum/addiction/hallucinogens = 18)
	metabolized_traits = list(TRAIT_FEARLESS, TRAIT_ANALGESIA)

/datum/reagent/drug/happiness/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.add_mood_event("happiness_drug", /datum/mood_event/happiness_drug)

/datum/reagent/drug/happiness/on_mob_delete(mob/living/affected_mob)
	. = ..()
	affected_mob.clear_mood_event("happiness_drug")

/datum/reagent/drug/happiness/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.remove_status_effect(/datum/status_effect/jitter)
	affected_mob.remove_status_effect(/datum/status_effect/confusion)
	affected_mob.disgust = 0
	if(affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/happiness/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(16, seconds_per_tick))
		var/reaction = rand(1,3)
		switch(reaction)
			if(1)
				affected_mob.emote("laugh")
				affected_mob.add_mood_event("happiness_drug", /datum/mood_event/happiness_drug_good_od)
			if(2)
				affected_mob.emote("sway")
				affected_mob.set_dizzy_if_lower(50 SECONDS)
			if(3)
				affected_mob.emote("frown")
				affected_mob.add_mood_event("happiness_drug", /datum/mood_event/happiness_drug_bad_od)
	if(affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/pumpup
	name = "Pump-Up-涌力"
	description = "挑战世界!一种见效快、效果强的毒品，能让你的承受能力达到极限."
	reagent_state = LIQUID
	color = "#e38e44"
	metabolization_rate = 2 * REAGENTS_METABOLISM
	overdose_threshold = 30
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/stimulants = 6) //2.6 per 2 seconds
	metabolized_traits = list(TRAIT_BATON_RESISTANCE, TRAIT_ANALGESIA, TRAIT_STIMULATED)

/datum/reagent/drug/pumpup/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	var/obj/item/organ/internal/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_MAINTENANCE_METABOLISM))
		affected_mob.add_mood_event("maintenance_fun", /datum/mood_event/maintenance_high)
		metabolization_rate *= 0.8

/datum/reagent/drug/pumpup/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.set_jitter_if_lower(10 SECONDS * REM * seconds_per_tick)

	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[pick("Go! Go! GO!", "你感到一切就绪...", "你觉得自己无敌...")]"))
	if(SPT_PROB(7.5, seconds_per_tick))
		affected_mob.losebreath++
		affected_mob.adjustToxLoss(2, updating_health = FALSE, required_biotype = affected_biotype)
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/pumpup/overdose_start(mob/living/affected_mob)
	. = ..()
	to_chat(affected_mob, span_userdanger("你不停地颤抖，心跳越来越快..."))

/datum/reagent/drug/pumpup/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.set_jitter_if_lower(10 SECONDS * REM * seconds_per_tick)
	var/need_mob_update
	if(SPT_PROB(2.5, seconds_per_tick))
		affected_mob.drop_all_held_items()
	if(SPT_PROB(7.5, seconds_per_tick))
		affected_mob.emote(pick("twitch","drool"))
	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.losebreath++
		affected_mob.adjustStaminaLoss(4, updating_stamina = FALSE, required_biotype = affected_biotype)
		need_mob_update = TRUE
	if(SPT_PROB(7.5, seconds_per_tick))
		need_mob_update += affected_mob.adjustToxLoss(2, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/maint
	name = "Maintenance Drugs-管道毒品"
	chemical_flags = NONE

/datum/reagent/drug/maint/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if(!iscarbon(affected_mob))
		return

	var/mob/living/carbon/carbon_mob = affected_mob
	var/obj/item/organ/internal/liver/liver = carbon_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if(HAS_TRAIT(liver, TRAIT_MAINTENANCE_METABOLISM))
		carbon_mob.add_mood_event("maintenance_fun", /datum/mood_event/maintenance_high)
		metabolization_rate *= 0.8

/datum/reagent/drug/maint/powder
	name = "Maintenance Powder-管道粉"
	description = "一种不知名的粉末，很可能是助手、无聊的化学家...或者自己煮的；它是一种精炼的焦油，可以提高你的智力，让你更快地学习东西."
	reagent_state = SOLID
	color = "#ffffff"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 15
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/maintenance_drugs = 14)

/datum/reagent/drug/maint/powder/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.1 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	// 5x if you want to OD, you can potentially go higher, but good luck managing the brain damage.
	var/amt = max(round(volume/3, 0.1), 1)
	affected_mob?.mind?.experience_multiplier_reasons |= type
	affected_mob?.mind?.experience_multiplier_reasons[type] = amt * REM * seconds_per_tick

/datum/reagent/drug/maint/powder/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob?.mind?.experience_multiplier_reasons[type] = null
	affected_mob?.mind?.experience_multiplier_reasons -= type

/datum/reagent/drug/maint/powder/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 6 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/maint/sludge
	name = "Maintenance Sludge-管道泥"
	description = "你很可能从一个助手、一个无聊的化学家那里得到一堆不知名的污泥...或者自己煮的；它只提炼了一半，使你更能抵抗伤口，但也会导致毒素积累."
	reagent_state = LIQUID
	color = "#203d2c"
	metabolization_rate = 2 * REAGENTS_METABOLISM
	overdose_threshold = 25
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/maintenance_drugs = 8)
	metabolized_traits = list(TRAIT_HARDLY_WOUNDED, TRAIT_ANALGESIA)

/datum/reagent/drug/maint/sludge/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustToxLoss(0.5 * REM * seconds_per_tick, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/maint/sludge/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!iscarbon(affected_mob))
		return
	var/mob/living/carbon/carbie = affected_mob
	//You will be vomiting so the damage is really for a few ticks before you flush it out of your system
	var/need_mob_update
	need_mob_update = carbie.adjustToxLoss(1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	if(SPT_PROB(5, seconds_per_tick))
		need_mob_update += carbie.adjustToxLoss(5, required_biotype = affected_biotype, updating_health = FALSE)
		carbie.vomit(VOMIT_CATEGORY_DEFAULT)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/maint/tar
	name = "Maintenance Tar-管道油"
	description = "一个不知名的焦油，你很可能从一个助手，一个无聊的化学家那里得到...或者自己煮的，像是生沥青，直接从地板上取下来的，它可以帮助你以肝损伤为代价逃离糟糕的情况."
	reagent_state = LIQUID
	color = COLOR_BLACK
	overdose_threshold = 30
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/maintenance_drugs = 5)

/datum/reagent/drug/maint/tar/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.AdjustAllImmobility(-10 * REM * seconds_per_tick)
	affected_mob.adjustOrganLoss(ORGAN_SLOT_LIVER, 1.5 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	return UPDATE_MOB_HEALTH

/datum/reagent/drug/maint/tar/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_update
	need_update = affected_mob.adjustToxLoss(5 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	need_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_LIVER, 3 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(need_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/mushroomhallucinogen
	name = "Mushroom Hallucinogen-蘑菇致幻剂"
	description = "从某种蘑菇中提取的强效致幻剂."
	color = "#E700E7" // rgb: 231, 0, 231
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	taste_description = "蘑菇"
	ph = 11
	overdose_threshold = 30
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/hallucinogens = 12)

/datum/reagent/drug/mushroomhallucinogen/on_mob_life(mob/living/carbon/psychonaut, seconds_per_tick, times_fired)
	. = ..()
	psychonaut.set_slurring_if_lower(1 SECONDS * REM * seconds_per_tick)

	switch(current_cycle)
		if(2 to 6)
			if(SPT_PROB(5, seconds_per_tick))
				psychonaut.emote(pick("twitch","giggle"))
		if(6 to 11)
			psychonaut.set_jitter_if_lower(20 SECONDS * REM * seconds_per_tick)
			if(SPT_PROB(10, seconds_per_tick))
				psychonaut.emote(pick("twitch","giggle"))
		if (11 to INFINITY)
			psychonaut.set_jitter_if_lower(40 SECONDS * REM * seconds_per_tick)
			if(SPT_PROB(16, seconds_per_tick))
				psychonaut.emote(pick("twitch","giggle"))

/datum/reagent/drug/mushroomhallucinogen/on_mob_metabolize(mob/living/psychonaut)
	. = ..()

	psychonaut.add_mood_event("tripping", /datum/mood_event/high)
	if(!psychonaut.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = psychonaut.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	var/list/col_filter_identity = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	var/list/col_filter_green = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.333,0,0,0)
	var/list/col_filter_blue = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.666,0,0,0)
	var/list/col_filter_red = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 1.000,0,0,0) //visually this is identical to the identity

	game_plane_master_controller.add_filter("rainbow", 10, color_matrix_filter(col_filter_red, FILTER_COLOR_HSL))

	for(var/filter in game_plane_master_controller.get_filters("rainbow"))
		animate(filter, color = col_filter_identity, time = 0 SECONDS, loop = -1, flags = ANIMATION_PARALLEL)
		animate(color = col_filter_green, time = 4 SECONDS)
		animate(color = col_filter_blue, time = 4 SECONDS)
		animate(color = col_filter_red, time = 4 SECONDS)

	game_plane_master_controller.add_filter("psilocybin_wave", 1, list("type" = "wave", "size" = 2, "x" = 32, "y" = 32))

	for(var/filter in game_plane_master_controller.get_filters("psilocybin_wave"))
		animate(filter, time = 64 SECONDS, loop = -1, easing = LINEAR_EASING, offset = 32, flags = ANIMATION_PARALLEL)

/datum/reagent/drug/mushroomhallucinogen/on_mob_end_metabolize(mob/living/psychonaut)
	. = ..()
	psychonaut.clear_mood_event("tripping")
	if(!psychonaut.hud_used)
		return
	var/atom/movable/plane_master_controller/game_plane_master_controller = psychonaut.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.remove_filter("rainbow")
	game_plane_master_controller.remove_filter("psilocybin_wave")

/datum/reagent/drug/mushroomhallucinogen/overdose_process(mob/living/psychonaut, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(10, seconds_per_tick))
		psychonaut.emote(pick("twitch","drool","moan"))

	if(SPT_PROB(10, seconds_per_tick))
		psychonaut.apply_status_effect(/datum/status_effect/tower_of_babel)

/datum/reagent/drug/blastoff
	name = "bLaStOoF"
	description = "这是一种专为参加疯狂派对的人准备的药物，据说可以提高他们在舞池中的舞技，大多数老年人都对这东西感到恐惧，也许是因为月球迪斯科舞厅事件在他们的大脑中烙下了不可磨灭的印记."
	reagent_state = LIQUID
	color = "#9015a9"
	taste_description = "清洁剂"
	ph = 5
	overdose_threshold = 30
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/hallucinogens = 15)
	metabolized_traits = list(TRAIT_STIMULATED)
	///How many flips have we done so far?
	var/flip_count = 0
	///How many spin have we done so far?
	var/spin_count = 0
	///How many flips for a super flip?
	var/super_flip_requirement = 3

/datum/reagent/drug/blastoff/on_mob_metabolize(mob/living/dancer)
	. = ..()

	dancer.add_mood_event("vibing", /datum/mood_event/high)
	RegisterSignal(dancer, COMSIG_MOB_EMOTED("flip"), PROC_REF(on_flip))
	RegisterSignal(dancer, COMSIG_MOB_EMOTED("spin"), PROC_REF(on_spin))

	if(!dancer.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = dancer.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	var/list/col_filter_blue = list(0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.764,0,0,0) //most blue color
	var/list/col_filter_mid = list(0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.832,0,0,0) //red/blue mix midpoint
	var/list/col_filter_red = list(0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.900,0,0,0) //most red color

	game_plane_master_controller.add_filter("blastoff_filter", 10, color_matrix_filter(col_filter_mid, FILTER_COLOR_HCY))
	game_plane_master_controller.add_filter("blastoff_wave", 1, list("type" = "wave", "x" = 32, "y" = 32))


	for(var/filter in game_plane_master_controller.get_filters("blastoff_filter"))
		animate(filter, color = col_filter_blue, time = 3 SECONDS, loop = -1, flags = ANIMATION_PARALLEL)
		animate(color = col_filter_mid, time = 3 SECONDS)
		animate(color = col_filter_red, time = 3 SECONDS)
		animate(color = col_filter_mid, time = 3 SECONDS)

	for(var/filter in game_plane_master_controller.get_filters("blastoff_wave"))
		animate(filter, time = 32 SECONDS, loop = -1, easing = LINEAR_EASING, offset = 32, flags = ANIMATION_PARALLEL)

	dancer.sound_environment_override = SOUND_ENVIRONMENT_PSYCHOTIC

/datum/reagent/drug/blastoff/on_mob_end_metabolize(mob/living/dancer)
	. = ..()

	dancer.clear_mood_event("vibing")
	UnregisterSignal(dancer, COMSIG_MOB_EMOTED("flip"))
	UnregisterSignal(dancer, COMSIG_MOB_EMOTED("spin"))

	if(!dancer.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = dancer.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	game_plane_master_controller.remove_filter("blastoff_filter")
	game_plane_master_controller.remove_filter("blastoff_wave")
	dancer.sound_environment_override = NONE

/datum/reagent/drug/blastoff/on_mob_life(mob/living/carbon/dancer, seconds_per_tick, times_fired)
	. = ..()
	if(dancer.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.3 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		. = UPDATE_MOB_HEALTH
	dancer.AdjustKnockdown(-20)

	if(SPT_PROB(BLASTOFF_DANCE_MOVE_CHANCE_PER_UNIT * volume, seconds_per_tick))
		dancer.emote("flip")

/datum/reagent/drug/blastoff/overdose_process(mob/living/dancer, seconds_per_tick, times_fired)
	. = ..()
	if(dancer.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.3 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		. = UPDATE_MOB_HEALTH

	if(SPT_PROB(BLASTOFF_DANCE_MOVE_CHANCE_PER_UNIT * volume, seconds_per_tick))
		dancer.emote("spin")

///This proc listens to the flip signal and throws the mob every third flip
/datum/reagent/drug/blastoff/proc/on_flip()
	SIGNAL_HANDLER

	if(!iscarbon(holder.my_atom))
		return
	var/mob/living/carbon/dancer = holder.my_atom

	flip_count++
	if(flip_count < BLASTOFF_DANCE_MOVES_PER_SUPER_MOVE)
		return
	flip_count = 0
	var/atom/throw_target = get_edge_target_turf(dancer, dancer.dir)  //Do a super flip
	dancer.SpinAnimation(speed = 3, loops = 3)
	dancer.visible_message(span_notice("[dancer]做了一个夸张的翻跟头!"), span_nicegreen("你做了一个夸张的翻跟头!"))
	dancer.throw_at(throw_target, range = 6, speed = overdosed ? 4 : 1)

///This proc listens to the 旋转 signal and throws the mob every third 旋转
/datum/reagent/drug/blastoff/proc/on_spin()
	SIGNAL_HANDLER

	if(!iscarbon(holder.my_atom))
		return
	var/mob/living/carbon/dancer = holder.my_atom

	spin_count++
	if(spin_count < BLASTOFF_DANCE_MOVES_PER_SUPER_MOVE)
		return
	spin_count = 0 //Do a super 旋转.
	dancer.visible_message(span_danger("[dancer]剧烈旋转!"), span_danger("你剧烈旋转!"))
	dancer.spin(30, 2)
	if(dancer.disgust < 40)
		dancer.adjust_disgust(10)
	if(!dancer.pulledby)
		return
	var/dancer_turf = get_turf(dancer)
	var/atom/movable/dance_partner = dancer.pulledby
	dance_partner.visible_message(span_danger("[dance_partner]试图抓住[dancer]，但被甩了回来!"), span_danger("你试图抓住[dancer]，但你被甩了回来!"), null, COMBAT_MESSAGE_RANGE)
	var/throwtarget = get_edge_target_turf(dancer_turf, get_dir(dancer_turf, get_step_away(dance_partner, dancer_turf)))
	if(overdosed)
		dance_partner.throw_at(target = throwtarget, range = 7, speed = 4)
	else
		dance_partner.throw_at(target = throwtarget, range = 4, speed = 1) //superspeed

/datum/reagent/drug/saturnx
	name = "Saturn-X-土星X"
	description = "这种化合物最初是在隐形技术的初期发现的，当时被认为是一种很有前途的候选药剂；但在研究人员发现了包括思维障碍和肝毒性在内的一系列相关安全问题后，该药物被撤回考虑."
	reagent_state = SOLID
	taste_description = "metallic bitterness"
	color = "#638b9b"
	overdose_threshold = 25
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/maintenance_drugs = 20)

/datum/reagent/drug/saturnx/on_mob_life(mob/living/carbon/invisible_man, seconds_per_tick, times_fired)
	. = ..()
	if(invisible_man.adjustOrganLoss(ORGAN_SLOT_LIVER, 0.3 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/saturnx/on_mob_metabolize(mob/living/invisible_man)
	. = ..()
	playsound(invisible_man, 'sound/chemistry/saturnx_fade.ogg', 40)
	to_chat(invisible_man, span_nicegreen("当你的身体突然变得透明时，你感到皮肤上到处都是针!"))
	addtimer(CALLBACK(src, PROC_REF(turn_man_invisible), invisible_man), 1 SECONDS) //just a quick delay to synch up the sound.
	if(!invisible_man.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = invisible_man.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	var/list/col_filter_full = list(1,0,0,0, 0,1.00,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	var/list/col_filter_twothird = list(1,0,0,0, 0,0.68,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	var/list/col_filter_half = list(1,0,0,0, 0,0.42,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	var/list/col_filter_empty = list(1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)

	game_plane_master_controller.add_filter("saturnx_filter", 10, color_matrix_filter(col_filter_twothird, FILTER_COLOR_HCY))

	for(var/filter in game_plane_master_controller.get_filters("saturnx_filter"))
		animate(filter, loop = -1, color = col_filter_full, time = 4 SECONDS, easing = CIRCULAR_EASING|EASE_IN, flags = ANIMATION_PARALLEL)
		//uneven so we spend slightly less time with bright colors
		animate(color = col_filter_twothird, time = 6 SECONDS, easing = LINEAR_EASING)
		animate(color = col_filter_half, time = 3 SECONDS, easing = LINEAR_EASING)
		animate(color = col_filter_empty, time = 2 SECONDS, easing = CIRCULAR_EASING|EASE_OUT)
		animate(color = col_filter_half, time = 24 SECONDS, easing = CIRCULAR_EASING|EASE_IN)
		animate(color = col_filter_twothird, time = 12 SECONDS, easing = LINEAR_EASING)

	game_plane_master_controller.add_filter("saturnx_blur", 1, list("type" = "radial_blur", "size" = 0))

	for(var/filter in game_plane_master_controller.get_filters("saturnx_blur"))
		animate(filter, loop = -1, size = 0.04, time = 2 SECONDS, easing = ELASTIC_EASING|EASE_OUT, flags = ANIMATION_PARALLEL)
		animate(size = 0, time = 6 SECONDS, easing = CIRCULAR_EASING|EASE_IN)

///This proc turns the living mob passed as the arg "invisible_man"s invisible by giving him the invisible man trait and updating his body, this changes the sprite of all his organic limbs to a 1 alpha version.
/datum/reagent/drug/saturnx/proc/turn_man_invisible(mob/living/carbon/invisible_man, requires_liver = TRUE)
	if(requires_liver)
		if(!invisible_man.get_organ_slot(ORGAN_SLOT_LIVER))
			return
		if(invisible_man.undergoing_liver_failure())
			return
		if(HAS_TRAIT(invisible_man, TRAIT_LIVERLESS_METABOLISM))
			return
	if(invisible_man.has_status_effect(/datum/status_effect/grouped/stasis))
		return

	invisible_man.add_traits(list(TRAIT_INVISIBLE_MAN, TRAIT_HIDE_EXTERNAL_ORGANS, TRAIT_NO_BLOOD_OVERLAY), type)

	invisible_man.update_body()
	invisible_man.remove_from_all_data_huds()
	invisible_man.sound_environment_override = SOUND_ENVIROMENT_PHASED

/datum/reagent/drug/saturnx/on_mob_end_metabolize(mob/living/carbon/invisible_man)
	. = ..()
	if(HAS_TRAIT_FROM(invisible_man, TRAIT_INVISIBLE_MAN, type))
		invisible_man.add_to_all_human_data_huds() //Is this safe, what do you think, Floyd?
		invisible_man.remove_traits(list(TRAIT_INVISIBLE_MAN, TRAIT_HIDE_EXTERNAL_ORGANS, TRAIT_NO_BLOOD_OVERLAY), type)

		to_chat(invisible_man, span_notice("色彩再次回到你的身体."))

	invisible_man.update_body()
	invisible_man.sound_environment_override = NONE

	if(!invisible_man.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = invisible_man.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.remove_filter("saturnx_filter")
	game_plane_master_controller.remove_filter("saturnx_blur")

/datum/reagent/drug/saturnx/overdose_process(mob/living/invisible_man, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(7.5, seconds_per_tick))
		invisible_man.emote("giggle")
	if(SPT_PROB(5, seconds_per_tick))
		invisible_man.emote("laugh")
	if(invisible_man.adjustOrganLoss(ORGAN_SLOT_LIVER, 0.4 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/saturnx/stable
	name = "Stabilized Saturn-X-稳定土星X"
	description = "一种源自土星x化合物的化学提取物，稳定且更安全的战术版；配方被发现后，原计划大规模生产，但负责人消失后，该计划破裂，再也没有出现过."
	metabolization_rate = 0.15 * REAGENTS_METABOLISM
	overdose_threshold = 50
	addiction_types = list(/datum/addiction/maintenance_drugs = 35)

/datum/reagent/drug/kronkaine
	name = "Kronkaine-可卡因"
	description = "一种来自银河系边缘的非法兴奋剂，据说，平均一个可卡因成瘾者造成的犯罪损失相当于5个抢劫犯、2个流氓和1个职业毒品贩子的总和."
	reagent_state = SOLID
	color = "#FAFAFA"
	taste_description = "麻木痛苦"
	ph = 8
	overdose_threshold = 20
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/stimulants = 20)
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/drug/kronkaine/on_new(data)
	. = ..()
	// Kronkaine also makes for a great fishing bait (found in "natural" baits)
	if(!istype(holder?.my_atom, /obj/item/food))
		return
	ADD_TRAIT(holder.my_atom, TRAIT_GREAT_QUALITY_BAIT, type)
	RegisterSignal(holder, COMSIG_REAGENTS_CLEAR_REAGENTS, PROC_REF(on_reagents_clear))
	RegisterSignal(holder, COMSIG_REAGENTS_DEL_REAGENT, PROC_REF(on_reagent_delete))

/datum/reagent/drug/kronkaine/proc/on_reagents_clear(datum/reagents/reagents)
	SIGNAL_HANDLER
	REMOVE_TRAIT(holder.my_atom, TRAIT_GREAT_QUALITY_BAIT, type)

/datum/reagent/drug/kronkaine/proc/on_reagent_delete(datum/reagents/reagents, datum/reagent/deleted_reagent)
	SIGNAL_HANDLER
	if(deleted_reagent == src)
		REMOVE_TRAIT(holder.my_atom, TRAIT_GREAT_QUALITY_BAIT, type)

/datum/reagent/drug/kronkaine/on_mob_metabolize(mob/living/kronkaine_fiend)
	. = ..()
	kronkaine_fiend.add_actionspeed_modifier(/datum/actionspeed_modifier/kronkaine)
	kronkaine_fiend.sound_environment_override = SOUND_ENVIRONMENT_HANGAR

/datum/reagent/drug/kronkaine/on_mob_end_metabolize(mob/living/kronkaine_fiend)
	. = ..()
	kronkaine_fiend.remove_actionspeed_modifier(/datum/actionspeed_modifier/kronkaine)
	kronkaine_fiend.sound_environment_override = NONE

/datum/reagent/drug/kronkaine/on_transfer(atom/kronkaine_receptacle, methods, trans_volume)
	. = ..()
	if(!iscarbon(kronkaine_receptacle))
		return
	var/mob/living/carbon/druggo = kronkaine_receptacle
	if(druggo.adjustStaminaLoss(-4 * trans_volume, updating_stamina = FALSE))
		return UPDATE_MOB_HEALTH
	//I wish i could give it some kind of bonus when smoked, but we don't have an INHALE method.

/datum/reagent/drug/kronkaine/on_mob_life(mob/living/carbon/kronkaine_fiend, seconds_per_tick, times_fired)
	. = ..()
	kronkaine_fiend.add_mood_event("tweaking", /datum/mood_event/stimulant_medium)
	if(kronkaine_fiend.adjustOrganLoss(ORGAN_SLOT_HEART, 0.4 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		. = UPDATE_MOB_HEALTH
	kronkaine_fiend.set_jitter_if_lower(20 SECONDS * REM * seconds_per_tick)
	kronkaine_fiend.AdjustSleeping(-20 * REM * seconds_per_tick)
	kronkaine_fiend.adjust_drowsiness(-10 SECONDS * REM * seconds_per_tick)
	if(volume < 10)
		return
	for(var/possible_purger in kronkaine_fiend.reagents.reagent_list)
		if(istype(possible_purger, /datum/reagent/medicine/c2/multiver) || istype(possible_purger, /datum/reagent/medicine/haloperidol))
			kronkaine_fiend.ForceContractDisease(new /datum/disease/adrenal_crisis(), FALSE, TRUE) //We punish players for purging, since unchecked purging would allow players to reap the stamina healing benefits without any drawbacks. This also has the benefit of making haloperidol a counter, like it is supposed to be.
			break

/datum/reagent/drug/kronkaine/overdose_process(mob/living/kronkaine_fiend, seconds_per_tick, times_fired)
	. = ..()
	if(kronkaine_fiend.adjustOrganLoss(ORGAN_SLOT_HEART, 1 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		. = UPDATE_MOB_HEALTH
	kronkaine_fiend.set_jitter_if_lower(20 SECONDS * REM * seconds_per_tick)
	if(SPT_PROB(10, seconds_per_tick))
		to_chat(kronkaine_fiend, span_danger(pick("你感觉你的心脏要爆炸了!", "你的耳朵在响!", "你汗流浃背!", "你咬紧牙关，磨牙.", "你感到胸口刺痛.")))

///dirty kronkaine, aka gore. far worse overdose effects.
/datum/reagent/drug/kronkaine/gore
	name = "Gore-戈尔"
	description = "干克卡因，你一定很蠢才会接受这个."
	color = "#ffbebe" // kronkaine but with some red
	ph = 4
	chemical_flags = NONE

/datum/reagent/drug/kronkaine/gore/overdose_start(mob/living/gored)
	. = ..()
	gored.visible_message(
		span_danger("[gored]在血淋淋中爆炸!"),
		span_userdanger("GORE! GORE! GORE! YOU'RE GORE! TOO MUCH GORE! YOU'RE GORE! GORE! IT'S OVER! GORE! GORE! YOU'RE GORE! TOO MUCH G-"),
	)
	new /obj/structure/bouncy_castle(gored.loc, gored)
	gored.gib()
