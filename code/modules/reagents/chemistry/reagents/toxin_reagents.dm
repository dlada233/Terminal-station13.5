
//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

/datum/reagent/toxin
	name = "Toxin"
	description = "A toxic chemical."
	color = "#CF3600" // rgb: 207, 54, 0
	taste_description = "bitterness"
	taste_mult = 1.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	///The amount of toxin damage this will cause when metabolized (also used to calculate liver damage)
	var/toxpwr = 1.5
	///The amount to multiply the liver damage this toxin does by (Handled solely in liver code)
	var/liver_damage_multiplier = 1
	///won't produce a pain message when processed by liver/life() if there isn't another non-silent toxin present if true
	var/silent_toxin = FALSE
	///The afflicted must be above this health value in order for the toxin to deal damage
	var/health_required = -100

// Are you a bad enough dude to poison your own plants?
/datum/reagent/toxin/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(round(volume * 2))

/datum/reagent/toxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(toxpwr && affected_mob.health > health_required)
		if(affected_mob.adjustToxLoss(toxpwr * REM * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/toxin/amatoxin
	name = "Amatoxin-鹅膏毒素"
	description = "从某种蘑菇中提取的剧毒."
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 2.5
	taste_description = "蘑菇"
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutagen
	name = "Unstable Mutagen-不稳定突变剂"
	description = "可能会导致不可预测的突变，远离儿童."
	color = COLOR_VIBRANT_LIME
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	taste_description = "黏糊糊"
	taste_mult = 0.9
	ph = 2.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutagen/expose_mob(mob/living/carbon/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!exposed_mob.can_mutate())
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	if(((methods & VAPOR) && prob(min(33, reac_volume))) || (methods & (INGEST|PATCH|INJECT)))
		exposed_mob.random_mutate_unique_identity()
		exposed_mob.random_mutate_unique_features()
		if(prob(98))
			exposed_mob.easy_random_mutate(NEGATIVE+MINOR_NEGATIVE)
		else
			exposed_mob.easy_random_mutate(POSITIVE)
		exposed_mob.updateappearance()
		exposed_mob.domutcheck()

/datum/reagent/toxin/mutagen/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustToxLoss(0.5 * seconds_per_tick * REM, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/mutagen/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.mutation_roll(user)
	mytray.adjust_toxic(3) //It is still toxic, mind you, but not to the same degree.

#define LIQUID_PLASMA_BP (50+T0C)
#define LIQUID_PLASMA_IG (325+T0C)

/datum/reagent/toxin/plasma
	name = "Plasma-等离子"
	description = "液态的等离子体."
	taste_description = "苦"
	specific_heat = SPECIFIC_HEAT_PLASMA
	taste_mult = 1.5
	color = "#8228A0"
	toxpwr = 3
	material = /datum/material/plasma
	penetrates_skin = NONE
	ph = 4
	burning_temperature = 4500//plasma is hot!!
	burning_volume = 0.3//But burns fast
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/plasma/on_new(data)
	. = ..()
	RegisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE, PROC_REF(on_temp_change))

/datum/reagent/toxin/plasma/Destroy()
	UnregisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE)
	return ..()

/datum/reagent/toxin/plasma/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 2 * REM * seconds_per_tick)
	affected_mob.adjustPlasma(20 * REM * seconds_per_tick)

/datum/reagent/toxin/plasma/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	if(HAS_TRAIT(affected_mob, TRAIT_PLASMA_LOVER_METABOLISM)) // sometimes mobs can temporarily metabolize plasma (e.g. plasma fixation disease symptom)
		toxpwr = 0

/datum/reagent/toxin/plasma/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	toxpwr = initial(toxpwr)

/// Handles plasma boiling.
/datum/reagent/toxin/plasma/proc/on_temp_change(datum/reagents/_holder, old_temp)
	SIGNAL_HANDLER
	if(holder.chem_temp < LIQUID_PLASMA_BP)
		return
	if(!holder.my_atom)
		return
	if((holder.flags & SEALED_CONTAINER) && (holder.chem_temp < LIQUID_PLASMA_IG))
		return
	var/atom/A = holder.my_atom
	A.atmos_spawn_air("[GAS_PLASMA]=[volume];[TURF_TEMPERATURE(holder.chem_temp)]")
	holder.del_reagent(type)

/datum/reagent/toxin/plasma/expose_turf(turf/open/exposed_turf, reac_volume)
	if(!istype(exposed_turf))
		return
	var/temp = holder ? holder.chem_temp : T20C
	if(temp >= LIQUID_PLASMA_BP)
		exposed_turf.atmos_spawn_air("[GAS_PLASMA]=[reac_volume];[TURF_TEMPERATURE(temp)]")
	return ..()

#undef LIQUID_PLASMA_BP
#undef LIQUID_PLASMA_IG

/datum/reagent/toxin/plasma/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with plasma is stronger than fuel!
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.adjust_fire_stacks(reac_volume / 5)
		return

/datum/reagent/toxin/hot_ice
	name = "Hot Ice Slush-热冰浆"
	description = "价值不菲，给对的人."
	reagent_state = SOLID
	color = "#724cb8" // rgb: 114, 76, 184
	taste_description = "浓烟滚滚"
	specific_heat = SPECIFIC_HEAT_PLASMA
	toxpwr = 3
	material = /datum/material/hot_ice
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/hot_ice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 2 * REM * seconds_per_tick)
	affected_mob.adjustPlasma(20 * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-7 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * seconds_per_tick, affected_mob.get_body_temp_normal())
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/humi = affected_mob
		humi.adjust_coretemperature(-7 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/toxin/hot_ice/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	if(HAS_TRAIT(affected_mob, TRAIT_PLASMA_LOVER_METABOLISM))
		toxpwr = 0

/datum/reagent/toxin/hot_ice/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	toxpwr = initial(toxpwr)

/datum/reagent/toxin/lexorin
	name = "Lexorin-窒息毒药"
	description = "一种用于停止呼吸的强力毒药."
	color = "#7DC3A0"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	taste_description = "酸"
	ph = 1.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/lexorin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!HAS_TRAIT(affected_mob, TRAIT_NOBREATH))
		affected_mob.adjustOxyLoss(5 * REM * normalise_creation_purity() * seconds_per_tick, FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		affected_mob.losebreath += 2 * REM * normalise_creation_purity() * seconds_per_tick
		. = UPDATE_MOB_HEALTH
		if(SPT_PROB(10, seconds_per_tick))
			affected_mob.emote("gasp")

/datum/reagent/toxin/lexorin/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	RegisterSignal(affected_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(block_breath))

/datum/reagent/toxin/lexorin/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	UnregisterSignal(affected_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(block_breath))

/datum/reagent/toxin/lexorin/proc/block_breath(mob/living/source)
	SIGNAL_HANDLER
	return COMSIG_CARBON_BLOCK_BREATH

/datum/reagent/toxin/slimejelly
	name = "史莱姆胶"
	description = "一种粘稠的半液体，由现存最致命的生命形式之一产生，如此真实."
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0
	taste_description = "黏糊糊"
	taste_mult = 1.3
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/slimejelly/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(5, seconds_per_tick))
		to_chat(affected_mob, span_danger("你的内脏在燃烧!"))
		if(affected_mob.adjustToxLoss(rand(20, 60), updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH
	else if(SPT_PROB(23, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(5))
			return UPDATE_MOB_HEALTH

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin-鲤鱼毒"
	description = "一种由可怕的鲤鱼产生的致命的神经毒素."
	silent_toxin = TRUE
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 1
	taste_description = "鱼"
	ph = 12
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder-僵尸粉"
	description = "一种强烈的神经毒素，能让人进入死亡状态."
	silent_toxin = TRUE
	reagent_state = SOLID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5
	taste_description = "死亡"
	penetrates_skin = NONE
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/zombiepowder/on_mob_metabolize(mob/living/holder_mob)
	. = ..()
	holder_mob.adjustOxyLoss(0.5*REM, FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if((data?["method"] & INGEST) && holder_mob.stat != DEAD)
		holder_mob.fakedeath(type)

/datum/reagent/toxin/zombiepowder/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.cure_fakedeath(type)

/datum/reagent/toxin/zombiepowder/on_transfer(atom/target_atom, methods, trans_volume)
	. = ..()
	var/datum/reagent/zombiepowder = target_atom.reagents.has_reagent(/datum/reagent/toxin/zombiepowder)
	if(!zombiepowder || !(methods & INGEST))
		return
	LAZYINITLIST(zombiepowder.data)
	zombiepowder.data["method"] |= INGEST

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(HAS_TRAIT(affected_mob, TRAIT_FAKEDEATH) && HAS_TRAIT(affected_mob, TRAIT_DEATHCOMA))
		return
	var/need_mob_update
	switch(current_cycle)
		if(2 to 6)
			affected_mob.adjust_confusion(1 SECONDS * REM * seconds_per_tick)
			affected_mob.adjust_drowsiness(2 SECONDS * REM * seconds_per_tick)
			affected_mob.adjust_slurring(6 SECONDS * REM * seconds_per_tick)
		if(6 to 9)
			need_mob_update = affected_mob.adjustStaminaLoss(40 * REM * seconds_per_tick, updating_stamina = FALSE)
		if(10 to INFINITY)
			if(affected_mob.stat != DEAD)
				affected_mob.fakedeath(type)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/ghoulpowder
	name = "Ghoul Powder-丧尸粉"
	description = "一种强烈的神经毒素，能减缓新陈代谢，使其达到类似于“死亡”的状态，同时使病人保持充分的生命力，如果使用时间过长，会导致毒素积聚。"
	reagent_state = SOLID
	color = "#664700" // rgb: 102, 71, 0
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0.8
	taste_description = "死亡"
	ph = 14.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	metabolized_traits = list(TRAIT_FAKEDEATH)

/datum/reagent/toxin/ghoulpowder/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustOxyLoss(1 * REM * seconds_per_tick, FALSE, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type))
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin-失智毒素"
	description = "强效致幻剂，这可不是闹着玩的，对一些精神病人来说，它抵消了他们的症状，把他们固定在现实中."
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0
	taste_description = "酸"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	ph = 11
	inverse_chem = /datum/reagent/impurity/rosenol
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/hallucinogens = 18)  //7.2 per 2 seconds
	metabolized_traits = list(TRAIT_RDS_SUPPRESSED)

/datum/reagent/toxin/mindbreaker/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	// mindbreaker toxin assuages hallucinations in those plagued with it, mentally
	if(affected_mob.has_trauma_type(/datum/brain_trauma/mild/hallucinations))
		affected_mob.remove_status_effect(/datum/status_effect/hallucination)

	// otherwise it creates hallucinations. truly a miracle medicine.
	else
		affected_mob.adjust_hallucinations(10 SECONDS * REM * seconds_per_tick)

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	description = "一种杀死植物的有毒混合物，不要吞食!"
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1
	taste_mult = 1
	penetrates_skin = NONE
	ph = 2.7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// Plant-B-Gone is just as bad
/datum/reagent/toxin/plantbgone/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume * 10))
	mytray.adjust_toxic(round(volume * 6))
	mytray.adjust_weedlevel(-rand(4,8))

/datum/reagent/toxin/plantbgone/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(istype(exposed_obj, /obj/structure/alien/weeds))
		var/obj/structure/alien/weeds/alien_weeds = exposed_obj
		alien_weeds.take_damage(rand(15, 35), BRUTE, 0) // Kills alien weeds pretty fast
	if(istype(exposed_obj, /obj/structure/alien/resin/flower_bud))
		var/obj/structure/alien/resin/flower_bud/flower = exposed_obj
		flower.take_damage(rand(30, 50), BRUTE, 0)
	else if(istype(exposed_obj, /obj/structure/glowshroom)) //even a small amount is enough to kill it
		qdel(exposed_obj)
	else if(istype(exposed_obj, /obj/structure/spacevine))
		var/obj/structure/spacevine/SV = exposed_obj
		SV.on_chem_effect(src)

/datum/reagent/toxin/plantbgone/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume)
	. = ..()
	var/damage = min(round(0.4 * reac_volume, 0.1), 10)
	if(exposed_mob.mob_biotypes & MOB_PLANT)
		// spray bottle emits 5u so it's dealing ~15 dmg per spray
		if(exposed_mob.adjustToxLoss(damage * 20, required_biotype = affected_biotype))
			return

	if(!(methods & VAPOR) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	if(!exposed_carbon.wear_mask)
		exposed_carbon.adjustToxLoss(damage, required_biotype = affected_biotype)

/datum/reagent/toxin/plantbgone/weedkiller
	name = "Weed Killer-除草剂"
	description = "一种有害的有毒混合物，用来杀死杂草，不要吞食!"
	color = "#4B004B" // rgb: 75, 0, 75
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//Weed Spray
/datum/reagent/toxin/plantbgone/weedkiller/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(round(volume * 0.5))
	mytray.adjust_weedlevel(-rand(1,2))

/datum/reagent/toxin/pestkiller
	name = "Pest Killer-杀虫剂"
	description = "一种有害的有毒混合物，用来杀死害虫，不要吞食!"
	color = "#4B004B" // rgb: 75, 0, 75
	toxpwr = 1
	ph = 3.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/pestkiller/on_new(data)
	. = ..()
	AddElement(/datum/element/bugkiller_reagent)

/datum/reagent/toxin/pestkiller/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustToxLoss(2 * toxpwr * REM * seconds_per_tick, updating_health = FALSE, required_biotype = MOB_BUG))
		return UPDATE_MOB_HEALTH

//Pest Spray
/datum/reagent/toxin/pestkiller/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(round(volume))
	mytray.adjust_pestlevel(-rand(1,2))

/datum/reagent/toxin/pestkiller/organic
	name = "Natural Pest Killer-天然杀虫剂"
	description = "一种用于杀死害虫的有机混合物，副作用较小，不要吞食!"
	color = "#4b2400" // rgb: 75, 0, 75
	toxpwr = 1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//Pest Spray
/datum/reagent/toxin/pestkiller/organic/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(round(volume * 0.1))
	mytray.adjust_pestlevel(-rand(1,2))

/datum/reagent/toxin/spore
	name = "Spore Toxin-芽孢毒素"
	description = "一种由斑点孢子产生的天然毒素，摄入后能抑制视力."
	color = "#9ACD32"
	toxpwr = 1
	ph = 11
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/spore/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.damageoverlaytemp = 60
	affected_mob.update_damage_hud()
	affected_mob.set_eye_blur_if_lower(6 SECONDS * REM * seconds_per_tick)

/datum/reagent/toxin/spore_burning
	name = "Burning Spore Toxin-燃烧孢子毒素"
	description = "一种由斑点孢子产生的天然毒素，能在受害者体内引起燃烧."
	color = "#9ACD32"
	toxpwr = 0.5
	taste_description = "燃烧"
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/spore_burning/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_fire_stacks(2 * REM * seconds_per_tick)
	affected_mob.ignite_mob()

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate-水合氯醛"
	description = "一种强效镇定剂，在使目标进入睡眠之前，会引起混乱和困倦."
	silent_toxin = TRUE
	reagent_state = SOLID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	ph = 11
	inverse_chem = /datum/reagent/impurity/chloralax
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/chloralhydrate/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	switch(current_cycle)
		if(2 to 11)
			affected_mob.adjust_confusion(2 SECONDS * REM * normalise_creation_purity() * seconds_per_tick)
			affected_mob.adjust_drowsiness(4 SECONDS * REM * normalise_creation_purity() * seconds_per_tick)
		if(11 to 51)
			affected_mob.Sleeping(40 * REM * normalise_creation_purity() * seconds_per_tick)
		if(52 to INFINITY)
			affected_mob.Sleeping(40 * REM * normalise_creation_purity() * seconds_per_tick)
			if(affected_mob.adjustToxLoss(1 * (current_cycle - 51) * REM * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
				return UPDATE_MOB_HEALTH

/datum/reagent/toxin/fakebeer //disguised as normal beer for use by emagged brobots
	name = "B33r"
	description = "一种伪装成啤酒的特制镇静剂，它能让目标瞬间入睡."
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "猫尿"
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/glass_style/drinking_glass/fakebeer
	required_drink_type = /datum/reagent/toxin/fakebeer

/datum/glass_style/drinking_glass/fakebeer/New()
	. = ..()
	// Copy styles from the beer drinking glass datum
	var/datum/glass_style/copy_from = /datum/glass_style/drinking_glass/beer
	name = initial(copy_from.name)
	desc = initial(copy_from.desc)
	icon = initial(copy_from.icon)
	icon_state = initial(copy_from.icon_state)

/datum/reagent/toxin/fakebeer/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	switch(current_cycle)
		if(2 to 51)
			affected_mob.Sleeping(40 * REM * seconds_per_tick)
		if(52 to INFINITY)
			affected_mob.Sleeping(40 * REM * seconds_per_tick)
			if(affected_mob.adjustToxLoss(1 * (current_cycle - 50) * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
				return UPDATE_MOB_HEALTH

/datum/reagent/toxin/coffeepowder
	name = "Coffee Grounds-碎咖啡豆"
	description = "磨碎的咖啡豆，用来煮咖啡."
	reagent_state = SOLID
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5
	ph = 4.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/toxin/teapowder
	name = "Ground Tea Leaves-碎茶叶"
	description = "磨碎的茶叶，用来煮茶."
	reagent_state = SOLID
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "绿茶"
	ph = 4.9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/toxin/mushroom_powder
	name = "Mushroom Powder-蘑菇粉"
	description = "细磨的多孔蘑菇，可以泡在水里煮蘑菇茶."
	reagent_state = SOLID
	color = "#67423A" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "蘑菇"
	ph = 8.0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutetoxin //the new zombie powder.
	name = "Mute Toxin-噤声毒素"
	description = "一种非致命的毒药，能抑制受害者的言语."
	silent_toxin = TRUE
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0
	taste_description = "沉默"
	ph = 12.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutetoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	// Gain approximately 12 seconds * creation purity seconds of silence every metabolism tick.
	affected_mob.set_silence_if_lower(6 SECONDS * REM * normalise_creation_purity() * seconds_per_tick)

/datum/reagent/toxin/staminatoxin
	name = "Tirizene-绝气毒素"
	description = "一种非致命的毒药，能使受害者极度疲劳和虚弱."
	silent_toxin = TRUE
	color = "#6E2828"
	data = 15
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/staminatoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustStaminaLoss(data * REM * seconds_per_tick, updating_stamina = FALSE))
		. = UPDATE_MOB_HEALTH
	data = max(data - 1, 3)

/datum/reagent/toxin/polonium
	name = "Polonium-放射毒素"
	description = "液态极具放射性的物质，误食会导致致命的辐射."
	reagent_state = LIQUID
	color = "#787878"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/polonium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if (!HAS_TRAIT(affected_mob, TRAIT_IRRADIATED) && SSradiation.can_irradiate_basic(affected_mob))
		affected_mob.AddComponent(/datum/component/irradiated)
	else
		if(affected_mob.adjustToxLoss(1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/toxin/histamine
	name = "Histamine-组胺"
	description = "组胺的作用随着剂量的增加而变得更加危险，它们的范围从轻微烦人到令人难以置信的致命."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#FA6464"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/histamine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(30, seconds_per_tick))
		switch(pick(1, 2, 3, 4))
			if(1)
				to_chat(affected_mob, span_danger("你几乎看不见!"))
				affected_mob.set_eye_blur_if_lower(6 SECONDS)
			if(2)
				affected_mob.emote("cough")
			if(3)
				affected_mob.sneeze()
			if(4)
				if(prob(75))
					to_chat(affected_mob, span_danger("你抓痒."))
					if(affected_mob.adjustBruteLoss(2* REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype))
						return UPDATE_MOB_HEALTH

/datum/reagent/toxin/histamine/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustOxyLoss(2 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	need_mob_update += affected_mob.adjustBruteLoss(2 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjustToxLoss(2 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/formaldehyde
	name = "Formaldehyde-甲醛"
	description = "甲醛本身是一种相当弱的毒素，它含有微量的组胺，在尸体上使用时，会防止器官腐烂."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#B4004B"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 1
	ph = 2.0
	inverse_chem = /datum/reagent/impurity/methanol
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/formaldehyde/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	var/obj/item/organ/internal/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_CORONER_METABOLISM)) //mmmm, the forbidden pickle juice
		if(affected_mob.adjustToxLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)) //it counteracts its own toxin damage.
			return UPDATE_MOB_HEALTH
		return
	else if(SPT_PROB(2.5, seconds_per_tick))
		holder.add_reagent(/datum/reagent/toxin/histamine, pick(5,15))
		holder.remove_reagent(/datum/reagent/toxin/formaldehyde, 1.2)
	return ..()

/datum/reagent/toxin/venom
	name = "Venom-毒液"
	description = "一种从剧毒动物群中提取的外来毒物，根据剂量不同，会造成大量毒素损伤和瘀伤。常衰变成组胺."
	reagent_state = LIQUID
	color = "#F0FFF0"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	///Mob Size of the current mob sprite.
	var/current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/toxin/venom/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	var/newsize = 1.1 * RESIZE_DEFAULT_SIZE
	affected_mob.update_transform(newsize/current_size)
	current_size = newsize
	toxpwr = 0.1 * volume

	if(affected_mob.adjustBruteLoss((0.3 * volume) * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype))
		. = UPDATE_MOB_HEALTH

	// chance to either decay into histamine or go the normal route of toxin metabolization
	if(SPT_PROB(8, seconds_per_tick))
		holder.add_reagent(/datum/reagent/toxin/histamine, pick(5, 10))
		holder.remove_reagent(/datum/reagent/toxin/venom, 1.1)
	else
		return ..() || .

/datum/reagent/toxin/venom/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.update_transform(RESIZE_DEFAULT_SIZE/current_size)
	current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/toxin/fentanyl
	name = "Fentanyl-芬太尼"
	description = "芬太尼会抑制大脑功能，并在最终击倒受害者之前造成毒素损害."
	reagent_state = LIQUID
	color = "#64916E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/opioids = 25)

/datum/reagent/toxin/fentanyl/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * REM * normalise_creation_purity() * seconds_per_tick, 150)
	if(affected_mob.toxloss <= 60)
		need_mob_update += affected_mob.adjustToxLoss(1 * REM * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	if(current_cycle > 4)
		affected_mob.add_mood_event("smacked out", /datum/mood_event/narcotic_heavy, name)
	if(current_cycle > 18)
		affected_mob.Sleeping(40 * REM * normalise_creation_purity() * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/cyanide
	name = "Cyanide-氰化物"
	description = "一种臭名昭著的毒药，以暗杀而闻名，造成少量毒素伤害，有很小几率造成氧气伤害或晕眩."
	reagent_state = LIQUID
	color = "#00B4FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1.25
	ph = 9.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/cyanide/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update = FALSE
	if(SPT_PROB(2.5, seconds_per_tick))
		affected_mob.losebreath += 1
		need_mob_update = TRUE
	if(SPT_PROB(4, seconds_per_tick))
		to_chat(affected_mob, span_danger("你感到非常虚弱!"))
		affected_mob.Stun(40)
		need_mob_update += affected_mob.adjustToxLoss(2*REM * normalise_creation_purity(), updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/bad_food
	name = "Bad Food-失败料理"
	description = "这是一些令人厌恶的烹饪的结果，食物糟糕到有毒."
	reagent_state = LIQUID
	color = "#d6d6d8"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0.5
	taste_description = "失败料理"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/itching_powder
	name = "Itching Powder-痒痒粉"
	description = "一种与皮肤接触引起瘙痒的粉末，会让受害者挠痒，并且很少有机会分解成组胺."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#C8C8C8"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 7
	penetrates_skin = TOUCH|VAPOR
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/itching_powder/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	var/scratched = FALSE
	var/scratch_damage = 0.2 * REM

	var/obj/item/bodypart/head = affected_mob.get_bodypart(BODY_ZONE_HEAD)
	if(!isnull(head) && SPT_PROB(8, seconds_per_tick))
		scratched = affected_mob.itch(damage = scratch_damage, target_part = head)

	var/obj/item/bodypart/leg = affected_mob.get_bodypart(pick(BODY_ZONE_L_LEG,BODY_ZONE_R_LEG))
	if(!isnull(leg) && SPT_PROB(8, seconds_per_tick))
		scratched = affected_mob.itch(damage = scratch_damage, target_part = leg, silent = scratched) || scratched

	var/obj/item/bodypart/arm = affected_mob.get_bodypart(pick(BODY_ZONE_L_ARM,BODY_ZONE_R_ARM))
	if(!isnull(arm) && SPT_PROB(8, seconds_per_tick))
		scratched = affected_mob.itch(damage = scratch_damage, target_part = arm, silent = scratched) || scratched

	if(SPT_PROB(1.5, seconds_per_tick))
		holder.add_reagent(/datum/reagent/toxin/histamine,rand(1,3))
		holder.remove_reagent(/datum/reagent/toxin/itching_powder, 1.2)
		return
	else
		return ..() || .

/datum/reagent/toxin/initropidril
	name = "Initropidril-猝死毒素"
	description = "一种具有阴险作用的强力毒药，它会导致昏迷、致命的呼吸衰竭和心脏骤停."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#7F10C0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 2.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/initropidril/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!SPT_PROB(13, seconds_per_tick))
		return
	var/picked_option = rand(1,3)
	var/need_mob_update
	switch(picked_option)
		if(1)
			affected_mob.Paralyze(60)
		if(2)
			affected_mob.losebreath += 10
			affected_mob.adjustOxyLoss(rand(5,25), updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
			need_mob_update = TRUE
		if(3)
			if(!affected_mob.undergoing_cardiac_arrest() && affected_mob.can_heartattack())
				affected_mob.set_heartattack(TRUE)
				if(affected_mob.stat == CONSCIOUS)
					affected_mob.visible_message(span_userdanger("[affected_mob]紧紧抓住[affected_mob.p_their()]的胸口，好像[affected_mob.p_their()]的心脏停止了跳动!"))
			else
				affected_mob.losebreath += 10
				need_mob_update = affected_mob.adjustOxyLoss(rand(5,25), updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/pancuronium
	name = "Pancuronium-肌肉松弛毒素"
	description = "一种无法检测的毒素能迅速使受害者丧失能力。也可能导致呼吸衰竭."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#195096"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_mult = 0 // undetectable, I guess?
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/pancuronium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 10)
		affected_mob.Stun(40 * REM * seconds_per_tick)
	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.losebreath += 4
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/sodium_thiopental
	name = "Sodium Thiopental-硫喷妥钠"
	description = "硫喷妥钠会使目标产生严重的虚弱和无意识."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = LIGHT_COLOR_BLUE
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	added_traits = list(TRAIT_ANTICONVULSANT)

/datum/reagent/toxin/sodium_thiopental/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 10)
		affected_mob.Sleeping(40 * REM * seconds_per_tick)
	if(affected_mob.adjustStaminaLoss(10 * REM * seconds_per_tick, updating_stamina = FALSE))
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/sulfonal
	name = "Sulfonal-索佛那"
	description = "一种潜行的毒药，造成轻微的毒素伤害，并最终使目标进入睡眠状态."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#7DC3A0"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.5
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/sulfonal/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 22)
		affected_mob.Sleeping(40 * REM * normalise_creation_purity() * seconds_per_tick)

/datum/reagent/toxin/amanitin
	name = "Amanitin-鹅膏蕈碱"
	description = "一种非常强大的延迟毒素，在完全代谢后，根据毒素在受害者血液中停留的时间长短，大量毒素损伤将被触发."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = COLOR_WHITE
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/delayed_toxin_damage = 0

/datum/reagent/toxin/amanitin/on_mob_life(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	delayed_toxin_damage += (seconds_per_tick * 3)

/datum/reagent/toxin/amanitin/on_mob_delete(mob/living/affected_mob)
	. = ..()
	affected_mob.log_message("has taken [delayed_toxin_damage] toxin damage from amanitin toxin", LOG_ATTACK)
	affected_mob.adjustToxLoss(delayed_toxin_damage, required_biotype = affected_biotype)

/datum/reagent/toxin/lipolicide
	name = "Lipolicide-断肠毒素"
	description = "一种强大的毒素，可以破坏脂肪细胞，在短时间内大量减轻体重，对那些体内没有营养的人来说是致命的."
	silent_toxin = TRUE
	taste_description = "樟脑球"
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#F0FFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 6
	inverse_chem = /datum/reagent/impurity/ipecacide
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/lipolicide/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.nutrition <= NUTRITION_LEVEL_STARVING)
		if(affected_mob.adjustToxLoss(1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
	affected_mob.adjust_nutrition(-3 * REM * normalise_creation_purity() * seconds_per_tick) // making the chef more valuable, one meme trap at a time
	affected_mob.overeatduration = 0

/datum/reagent/toxin/coniine
	name = "Coniine-毒芹碱"
	description = "毒芹碱代谢非常缓慢，会造成大量的毒素损害，并使呼吸停止."
	reagent_state = LIQUID
	color = "#7DC3A0"
	metabolization_rate = 0.06 * REAGENTS_METABOLISM
	toxpwr = 1.75
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/coniine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.losebreath < 5)
		affected_mob.losebreath = min(affected_mob.losebreath + 5 * REM * seconds_per_tick, 5)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/spewium
	name = "Spewium-呕血毒素"
	description = "强力催吐剂，引起无法控制的呕吐，高剂量可能导致器官呕吐."
	reagent_state = LIQUID
	color = "#2f6617" //A sickly green color
	metabolization_rate = REAGENTS_METABOLISM
	overdose_threshold = 29
	toxpwr = 0
	taste_description = "呕吐物"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/spewium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 11 && SPT_PROB(min(31, current_cycle), seconds_per_tick))
		affected_mob.vomit(10, prob(10), prob(50), rand(0,4), TRUE)
		var/constructed_flags = (MOB_VOMIT_MESSAGE | MOB_VOMIT_HARM)
		if(prob(10))
			constructed_flags |= MOB_VOMIT_BLOOD
		if(prob(50))
			constructed_flags |= MOB_VOMIT_STUN
		affected_mob.vomit(vomit_flags = constructed_flags, distance = rand(0,4))
		for(var/datum/reagent/toxin/R in affected_mob.reagents.reagent_list)
			if(R != src)
				affected_mob.reagents.remove_reagent(R.type, 1)

/datum/reagent/toxin/spewium/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 33 && SPT_PROB(7.5, seconds_per_tick))
		affected_mob.spew_organ()
		affected_mob.vomit(VOMIT_CATEGORY_BLOOD, lost_nutrition = 0, distance = 4)
		to_chat(affected_mob, span_userdanger("当你呕吐的时候，你感觉有东西隆起."))

/datum/reagent/toxin/curare
	name = "Curare-箭毒"
	description = "造成轻微的毒素伤害，随后是连锁昏迷和窒息伤害."
	reagent_state = LIQUID
	color = "#191919"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/curare/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 11)
		affected_mob.Paralyze(60 * REM * seconds_per_tick)
	if(affected_mob.adjustOxyLoss(0.5*REM*seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type))
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/heparin //Based on a real-life anticoagulant. I'm not a doctor, so this won't be realistic.
	name = "Heparin-肝素"
	description = "强力抗凝剂，受害者身上所有的开放性伤口都会裂开，血流得更快。它直接净化桑吉里特（一种凝血剂）."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#C8C8C8" //RGB: 200, 200, 200
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 11.6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	metabolized_traits = list(TRAIT_BLOODY_MESS)

/datum/reagent/toxin/heparin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(holder.has_reagent(/datum/reagent/medicine/coagulant)) //Directly purges coagulants from the system. Get rid of the heparin BEFORE attempting to use coagulants.
		holder.remove_reagent(/datum/reagent/medicine/coagulant, 2 * REM * seconds_per_tick)
	return ..()

/datum/reagent/toxin/rotatium //Rotatium. Fucks up your rotation and is hilarious
	name = "Rotatium-倒悬毒素"
	description = "一种不断旋转、色彩奇特的液体，使消费者的方向感和手眼协调变得疯狂."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#AC88CA" //RGB: 172, 136, 202
	metabolization_rate = 0.6 * REAGENTS_METABOLISM
	toxpwr = 0.5
	ph = 6.2
	taste_description = "天地倒悬"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/rotatium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!affected_mob.hud_used || (current_cycle < 20 || (current_cycle % 20) == 0))
		return
	var/atom/movable/plane_master_controller/pm_controller = affected_mob.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	var/rotation = min(round(current_cycle/20), 89) // By this point the player is probably puking and quitting anyway
	for(var/atom/movable/screen/plane_master/plane as anything in pm_controller.get_planes())
		animate(plane, transform = matrix(rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING, loop = -1)
		animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING)

/datum/reagent/toxin/rotatium/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	if(affected_mob?.hud_used)
		var/atom/movable/plane_master_controller/pm_controller = affected_mob.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		for(var/atom/movable/screen/plane_master/plane as anything in pm_controller.get_planes())
			animate(plane, transform = matrix(), time = 5, easing = QUAD_EASING)

/datum/reagent/toxin/anacea
	name = "Anacea-安娜赛亚"
	description = "一种能迅速清除药物而代谢缓慢的毒素."
	reagent_state = LIQUID
	color = "#3C5133"
	metabolization_rate = 0.08 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0.15
	ph = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/anacea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	var/remove_amt = 5
	if(holder.has_reagent(/datum/reagent/medicine/calomel) || holder.has_reagent(/datum/reagent/medicine/pen_acid))
		remove_amt = 0.5
	. = ..()
	for(var/datum/reagent/medicine/R in affected_mob.reagents.reagent_list)
		affected_mob.reagents.remove_reagent(R.type, remove_amt * REM * normalise_creation_purity() * seconds_per_tick)

//ACID

/datum/reagent/toxin/acid
	name = "Sulfuric Acid-硫酸"
	description = "一种分子式为H2SO4的强无机酸"
	color = "#00FF32"
	toxpwr = 1
	taste_description = "酸"
	self_consuming = TRUE
	ph = 2.75
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/acidpwr = 10 //the amount of protection removed from the armour

// ...Why? I mean, clearly someone had to have done this and thought, well,
// acid doesn't hurt plants, but what brought us here, to this point?
/datum/reagent/toxin/acid/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume))
	mytray.adjust_toxic(round(volume * 1.5))
	mytray.adjust_weedlevel(-rand(1,2))

/datum/reagent/toxin/acid/expose_mob(mob/living/carbon/exposed_carbon, methods=TOUCH, reac_volume)
	. = ..()
	if(!istype(exposed_carbon))
		return
	var/obj/item/organ/internal/liver/liver = exposed_carbon.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_HUMAN_AI_METABOLISM))
		return
	reac_volume = round(reac_volume,0.1)
	if(methods & INGEST)
		exposed_carbon.adjustBruteLoss(min(6*toxpwr, reac_volume * toxpwr), required_bodytype = affected_bodytype)
		return
	if(methods & INJECT)
		exposed_carbon.adjustBruteLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr), required_bodytype = affected_bodytype)
		return
	exposed_carbon.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(ismob(exposed_obj.loc)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	exposed_obj.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if (!istype(exposed_turf))
		return
	reac_volume = round(reac_volume,0.1)
	exposed_turf.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/fluacid
	name = "Fluorosulfuric Acid-氟硫酸"
	description = "氟硫酸是一种腐蚀性极强的化学物质."
	color = "#5050FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 2
	acidpwr = 42.0
	ph = 0.0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// SERIOUSLY
/datum/reagent/toxin/acid/fluacid/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume * 2))
	mytray.adjust_toxic(round(volume * 3))
	mytray.adjust_weedlevel(-rand(1,4))

/datum/reagent/toxin/acid/fluacid/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustFireLoss(((current_cycle-1)/15) * REM * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype))
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/acid/nitracid
	name = "Nitric Acid-硝酸"
	description = "硝酸是一种腐蚀性极强的化学物质，能与活的有机组织发生剧烈反应."
	color = "#5050FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 3
	acidpwr = 5.0
	ph = 1.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/acid/nitracid/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustFireLoss((volume/10) * REM * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)) //here you go nervar
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/delayed
	name = "Toxin Microcapsules-毒素微胶囊"
	description = "在短暂的不活动后会造成严重的毒素损害."
	reagent_state = LIQUID
	metabolization_rate = 0 //stays in the system until active.
	var/actual_metaboliztion_rate = REAGENTS_METABOLISM
	toxpwr = 0
	var/actual_toxpwr = 5
	var/delay = 31
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/delayed/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle <= delay)
		return
	if(holder)
		holder.remove_reagent(type, actual_metaboliztion_rate * affected_mob.metabolism_efficiency * seconds_per_tick)
	if(affected_mob.adjustToxLoss(actual_toxpwr * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		. = UPDATE_MOB_HEALTH
	if(SPT_PROB(5, seconds_per_tick))
		affected_mob.Paralyze(20)

/datum/reagent/toxin/mimesbane
	name = "Mime's Bane-默剧之祸"
	description = "一种非致命的神经毒素会干扰受害者的手势能力."
	silent_toxin = TRUE
	color = "#F0F8FF" // rgb: 240, 248, 255
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 1.7
	taste_description = "静止"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	metabolized_traits = list(TRAIT_EMOTEMUTE)

/datum/reagent/toxin/bonehurtingjuice //oof ouch
	name = "Bone Hurting Juice-伤骨果汁"
	description = "一种看起来很像水的奇怪物质，喝它对你来说是一种奇怪的诱惑，呕."
	silent_toxin = TRUE //no point spamming them even more.
	color = "#AAAAAA77" //RGBA: 170, 170, 170, 77
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 3.1
	taste_description = "骨折"
	overdose_threshold = 50
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/bonehurtingjuice/on_mob_add(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.say("哎哟，我的骨头", forced = /datum/reagent/toxin/bonehurtingjuice)

/datum/reagent/toxin/bonehurtingjuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustStaminaLoss(7.5 * REM * seconds_per_tick, updating_stamina = FALSE))
		. = UPDATE_MOB_HEALTH
	if(!SPT_PROB(10, seconds_per_tick))
		return
	switch(rand(1, 3))
		if(1)
			affected_mob.say(pick("哎呦.", "嗷嗷嗷.", "我的骨头.", "哎呦喂.", "哎呦我的骨头."), forced = /datum/reagent/toxin/bonehurtingjuice)
		if(2)
			affected_mob.manual_emote(pick("oofs silently.", "looks like [affected_mob.p_their()] bones hurt.", "grimaces, as though [affected_mob.p_their()] bones hurt."))
		if(3)
			to_chat(affected_mob, span_warning("你的骨头受伤了!"))

/datum/reagent/toxin/bonehurtingjuice/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(2, seconds_per_tick) && iscarbon(affected_mob)) //big oof
		var/selected_part = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //God help you if the same limb gets picked twice quickly.
		var/obj/item/bodypart/BP = affected_mob.get_bodypart(selected_part)
		if(BP)
			playsound(affected_mob, get_sfx(SFX_DESECRATION), 50, TRUE, -1)
			affected_mob.visible_message(span_warning("[affected_mob]的骨头太疼了!!"), span_danger("你的骨头太疼了!!"))
			affected_mob.say("啊!!", forced = /datum/reagent/toxin/bonehurtingjuice)
			if(BP.receive_damage(brute = 20 * REM * seconds_per_tick, burn = 0, blocked = 200, updating_health = FALSE, wound_bonus = rand(30, 130)))
				. = UPDATE_MOB_HEALTH
		else //SUCH A LUST FOR REVENGE!!!
			to_chat(affected_mob, span_warning("幻肢疼痛!"))
			affected_mob.say("为什么我还活着，为了受苦?", forced = /datum/reagent/toxin/bonehurtingjuice)

/datum/reagent/toxin/bungotoxin
	name = "Bungotoxin-Bungo毒素"
	description = "一种可怕的心脏毒素，保护着不起眼的Bungo果核."
	silent_toxin = TRUE
	color = "#EBFF8E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_description = "丹宁酸"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/bungotoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustOrganLoss(ORGAN_SLOT_HEART, 3 * REM * seconds_per_tick))
		. = UPDATE_MOB_HEALTH

	// If our mob's currently dizzy from anything else, we will also gain confusion
	var/mob_dizziness = affected_mob.get_timed_status_effect_duration(/datum/status_effect/confusion)
	if(mob_dizziness > 0)
		// Gain confusion equal to about half the duration of our current dizziness
		affected_mob.set_confusion(mob_dizziness / 2)

	if(current_cycle >= 13 && SPT_PROB(4, seconds_per_tick))
		var/tox_message = pick("你感到你的心脏在胸腔里痉挛.", "你感到头晕.","你觉得你需要喘口气.","你感到胸口一阵刺痛.")
		to_chat(affected_mob, span_notice("[tox_message]"))

/datum/reagent/toxin/leadacetate
	name = "Lead Acetate-醋酸铅"
	description = "几百年前，人们把它当作甜味剂，后来才发现它有毒."
	reagent_state = SOLID
	color = "#2b2b2b" // rgb: 127, 132, 0
	toxpwr = 0.5
	taste_mult = 1.3
	taste_description = "含糖的甜味"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/leadacetate/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_EARS, 1 * REM * seconds_per_tick)
	need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1 * REM * seconds_per_tick)
	if(need_mob_update)
		. = UPDATE_MOB_HEALTH
	if(SPT_PROB(0.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("啊，好像有什么东西? 你觉得自己听到了什么..."))
		affected_mob.adjust_confusion(5 SECONDS)

/datum/reagent/toxin/hunterspider
	name = "Spider Toxin-蜘蛛毒素"
	description = "蜘蛛分泌的一种有毒化学物质，用来削弱猎物."
	health_required = 40
	liver_damage_multiplier = 0

/datum/reagent/toxin/viperspider
	name = "Viper Spider Toxin-蜘蛛剧毒"
	toxpwr = 5
	description = "一种由罕见的毒蜘蛛产生的剧毒化学物质，把猎物带到死亡的边缘，并造成幻觉."
	health_required = 10
	liver_damage_multiplier = 0

/datum/reagent/toxin/viperspider/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_hallucinations(10 SECONDS * REM * seconds_per_tick)

/datum/reagent/toxin/tetrodotoxin
	name = "Tetrodotoxin-河豚毒素"
	description = "一种无色、无色、无味的神经毒素，通常由四齿目动物的肝脏携带."
	silent_toxin = TRUE
	reagent_state = SOLID
	color = COLOR_VERY_LIGHT_GRAY
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_mult = 0
	chemical_flags = REAGENT_NO_RANDOM_RECIPE
	var/list/traits_not_applied = list(
		TRAIT_PARALYSIS_L_ARM = BODY_ZONE_L_ARM,
		TRAIT_PARALYSIS_R_ARM = BODY_ZONE_R_ARM,
		TRAIT_PARALYSIS_L_LEG = BODY_ZONE_L_LEG,
		TRAIT_PARALYSIS_R_LEG = BODY_ZONE_R_LEG,
	)

/datum/reagent/toxin/tetrodotoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	//be ready for a cocktail of symptoms, including:
	//numbness, nausea, vomit, breath loss, weakness, paralysis and nerve damage/impairment and eventually a heart attack if enough time passes.
	var/need_mob_update
	switch(current_cycle)
		if(7 to 13)
			if(SPT_PROB(20, seconds_per_tick))
				affected_mob.set_jitter_if_lower(rand(2 SECONDS, 3 SECONDS) * REM * seconds_per_tick)
			if(SPT_PROB(5, seconds_per_tick))
				var/obj/item/organ/internal/tongue/tongue = affected_mob.get_organ_slot(ORGAN_SLOT_TONGUE)
				if(tongue)
					to_chat(affected_mob, span_warning("你[tongue.name]感到麻木..."))
				affected_mob.set_slurring_if_lower(5 SECONDS * REM * seconds_per_tick)
			affected_mob.adjust_disgust(3.5 * REM * seconds_per_tick)
		if(13 to 21)
			silent_toxin = FALSE
			toxpwr = 0.5
			need_mob_update = affected_mob.adjustStaminaLoss(2.5 * REM * seconds_per_tick, updating_stamina = FALSE)
			if(SPT_PROB(20, seconds_per_tick))
				affected_mob.losebreath += 1 * REM * seconds_per_tick
				need_mob_update = TRUE
			if(SPT_PROB(40, seconds_per_tick))
				affected_mob.set_jitter_if_lower(rand(2 SECONDS, 3 SECONDS) * REM * seconds_per_tick)
			affected_mob.adjust_disgust(3 * REM * seconds_per_tick)
			affected_mob.set_slurring_if_lower(1 SECONDS * REM * seconds_per_tick)
			affected_mob.adjustStaminaLoss(2 * REM * seconds_per_tick, updating_stamina = FALSE)
			if(SPT_PROB(4, seconds_per_tick))
				paralyze_limb(affected_mob)
				need_mob_update = TRUE
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.adjust_confusion(rand(6 SECONDS, 8 SECONDS))
		if(21 to 29)
			toxpwr = 1
			need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5)
			if(SPT_PROB(40, seconds_per_tick))
				affected_mob.losebreath += 2 * REM * seconds_per_tick
				need_mob_update = TRUE
			affected_mob.adjust_disgust(3 * REM * seconds_per_tick)
			affected_mob.set_slurring_if_lower(3 SECONDS * REM * seconds_per_tick)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_danger("你感到极度虚弱."))
			need_mob_update += affected_mob.adjustStaminaLoss(5 * REM * seconds_per_tick, updating_stamina = FALSE)
			if(SPT_PROB(8, seconds_per_tick))
				paralyze_limb(affected_mob)
				need_mob_update = TRUE
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.adjust_confusion(rand(6 SECONDS, 8 SECONDS))
		if(29 to INFINITY)
			toxpwr = 1.5
			need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1, BRAIN_DAMAGE_DEATH)
			affected_mob.set_silence_if_lower(3 SECONDS * REM * seconds_per_tick)
			need_mob_update += affected_mob.adjustStaminaLoss(5 * REM * seconds_per_tick, updating_stamina = FALSE)
			affected_mob.adjust_disgust(2 * REM * seconds_per_tick)
			if(SPT_PROB(15, seconds_per_tick))
				paralyze_limb(affected_mob)
				need_mob_update = TRUE
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.adjust_confusion(rand(6 SECONDS, 8 SECONDS))

	if(current_cycle > 38 && !length(traits_not_applied) && SPT_PROB(5, seconds_per_tick) && !affected_mob.undergoing_cardiac_arrest())
		affected_mob.set_heartattack(TRUE)
		to_chat(affected_mob, span_danger("你感到一种烧灼的疼痛蔓延到你的胸部，哦不..."))

	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/tetrodotoxin/proc/paralyze_limb(mob/living/affected_mob)
	if(!length(traits_not_applied))
		return
	var/added_trait = pick(traits_not_applied)
	ADD_TRAIT(affected_mob, added_trait, REF(src))
	traits_not_applied -= added_trait

/datum/reagent/toxin/tetrodotoxin/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	RegisterSignal(affected_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(block_breath))

/datum/reagent/toxin/tetrodotoxin/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	UnregisterSignal(affected_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(block_breath))
	// the initial() proc doesn't work for lists.
	var/list/initial_list = list(
		TRAIT_PARALYSIS_L_ARM = BODY_ZONE_L_ARM,
		TRAIT_PARALYSIS_R_ARM = BODY_ZONE_R_ARM,
		TRAIT_PARALYSIS_L_LEG = BODY_ZONE_L_LEG,
		TRAIT_PARALYSIS_R_LEG = BODY_ZONE_R_LEG,
	)
	affected_mob.remove_traits(initial_list, REF(src))
	traits_not_applied = initial_list

/datum/reagent/toxin/tetrodotoxin/proc/block_breath(mob/living/source)
	SIGNAL_HANDLER
	if(current_cycle > 28)
		return COMSIG_CARBON_BLOCK_BREATH
