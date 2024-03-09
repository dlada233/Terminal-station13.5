// Category 2 medicines are medicines that have an ill effect regardless of volume/OD to dissuade doping. Mostly used as emergency chemicals OR to convert damage (and heal a bit in the process). The type is used to prompt borgs that the medicine is harmful.
/datum/reagent/medicine/c2
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	inverse_chem = null //Some of these use inverse chems - we're just defining them all to null here to avoid repetition, eventually this will be moved up to parent
	creation_purity = REAGENT_STANDARD_PURITY//All sources by default are 0.75 - reactions are primed to resolve to roughly the same with no intervention for these.
	purity = REAGENT_STANDARD_PURITY
	inverse_chem_val = 0
	inverse_chem = null
	chemical_flags = REAGENT_SPLITRETAINVOL

/******BRUTE******/
/*Suffix: -bital*/

/datum/reagent/medicine/c2/helbital //kinda a C2 only if you're not in hardcrit.
	name = "Helbital-海尔"
	description = "这种药以北欧女神海尔的名字命名，能治愈病人越接近死亡的创伤，病人会发现只要自己不是在窒息到濒临死亡，这种药物就会治疗他们."
	color = "#9400D3"
	taste_description = "冰冷"
	ph = 8
	overdose_threshold = 35
	reagent_state = SOLID
	inverse_chem_val = 0.3
	inverse_chem = /datum/reagent/inverse/helgrasp
	var/helbent = FALSE
	var/reaping = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/c2/helbital/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/death_is_coming = (affected_mob.getToxLoss() + affected_mob.getOxyLoss() + affected_mob.getFireLoss() + affected_mob.getBruteLoss())*normalise_creation_purity()
	var/thou_shall_heal = 0
	var/good_kind_of_healing = FALSE
	var/need_mob_update = FALSE
	switch(affected_mob.stat)
		if(CONSCIOUS) //bad
			thou_shall_heal = death_is_coming/50
			need_mob_update += affected_mob.adjustOxyLoss(2 * REM * seconds_per_tick, TRUE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		if(SOFT_CRIT) //meh convert
			thou_shall_heal = round(death_is_coming/47,0.1)
			need_mob_update += affected_mob.adjustOxyLoss(1 * REM * seconds_per_tick, TRUE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		else //no convert
			thou_shall_heal = round(death_is_coming/45, 0.1)
			good_kind_of_healing = TRUE
	need_mob_update += affected_mob.adjustBruteLoss(-thou_shall_heal * REM * seconds_per_tick, FALSE, required_bodytype = affected_bodytype)
	if(need_mob_update)
		. = UPDATE_MOB_HEALTH

	if(good_kind_of_healing && !reaping && SPT_PROB(0.00005, seconds_per_tick)) //janken with the grim reaper!
		notify_ghosts(
			"[affected_mob]进入了一场决定生死的石头剪刀布游戏!",
			source = affected_mob,
			header = "Who Will Win?",
		)
		reaping = TRUE
		if(affected_mob.apply_status_effect(/datum/status_effect/necropolis_curse, CURSE_BLINDING))
			helbent = TRUE
		to_chat(affected_mob, span_hierophant("邪恶的灵魂出现在你面前，在一个“友好”的石头、剪刀、布游戏中决定你的生命，你的决定?"))
		var/timeisticking = world.time
		var/RPSchoice = tgui_alert(affected_mob, "你有60秒的时间选择!", "石头剪刀布", list("石头" , "布" , "剪刀"), 60)
		if(QDELETED(affected_mob) || (timeisticking+(1.1 MINUTES) < world.time))
			reaping = FALSE
			return //good job, you ruined it
		if(!RPSchoice)
			to_chat(affected_mob, span_hierophant("你决定不碰运气，但灵魂依然存在...希望它们能很快消失."))
			reaping = FALSE
			return
		switch(rand(1,3))
			if(1) //You Tied!
				to_chat(affected_mob, span_hierophant("邪恶的灵魂消失了...暂时."))
				reaping = FALSE
			if(2) //You lost!
				to_chat(affected_mob, span_hierophant("你输了，邪恶的灵魂围绕着你的身体诡异地傻笑着."))
				affected_mob.investigate_log("has lost rock paper scissors with the grim reaper and been dusted.", INVESTIGATE_DEATHS)
				affected_mob.dust()
				return
			if(3) //VICTORY ROYALE
				to_chat(affected_mob, span_hierophant("你赢了，邪恶的灵魂和你的伤口将会消失."))
				affected_mob.client.give_award(/datum/award/achievement/jobs/helbitaljanken, affected_mob)
				affected_mob.revive(HEAL_ALL)
				holder.del_reagent(type)
				return

/datum/reagent/medicine/c2/helbital/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!helbent)
		affected_mob.apply_necropolis_curse(CURSE_WASTING | CURSE_BLINDING)
		helbent = TRUE

/datum/reagent/medicine/c2/helbital/on_mob_delete(mob/living/affected_mob)
	. = ..()
	if(helbent)
		affected_mob.remove_status_effect(/datum/status_effect/necropolis_curse)

/datum/reagent/medicine/c2/libital //messes with your liber
	name = "Libital-利比特"
	description = "创伤特效药，造成轻微的肝损伤."
	color = "#ECEC8D" // rgb: 236 236 141
	ph = 8.2
	taste_description = "苦中带点酒精味"
	reagent_state = SOLID
	inverse_chem_val = 0.3
	inverse_chem = /datum/reagent/inverse/libitoil
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/c2/libital/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_LIVER, 0.3 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	need_mob_update += affected_mob.adjustBruteLoss(-3 * REM * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/probital
	name = "Probital-帕比特"
	description = "这种口服药物最初是健身房补充剂，它可以快速修复受损的肌肉组织，但会导致乳酸积聚，使患者感到疲劳，过量服用会导致极度困倦，若有营养物质的流入则进一步促进肌肉的修复."
	reagent_state = SOLID
	color = "#FFFF6B"
	ph = 5.5
	overdose_threshold = 20
	inverse_chem_val = 0.5//Though it's tough to get
	inverse_chem = /datum/reagent/medicine/metafactor //Seems thematically intact
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/c2/probital/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustBruteLoss(-2.25 * REM * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	var/ooo_youaregettingsleepy = 3.5
	switch(round(affected_mob.getStaminaLoss()))
		if(10 to 40)
			ooo_youaregettingsleepy = 3
		if(41 to 60)
			ooo_youaregettingsleepy = 2.5
		if(61 to 200) //you really can only go to 120
			ooo_youaregettingsleepy = 2
	need_mob_update += affected_mob.adjustStaminaLoss(ooo_youaregettingsleepy * REM * seconds_per_tick, updating_stamina = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/probital/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustStaminaLoss(3 * REM * seconds_per_tick, updating_stamina = FALSE)
	if(affected_mob.getStaminaLoss() >= 80)
		affected_mob.adjust_drowsiness(2 SECONDS * REM * seconds_per_tick)
	if(affected_mob.getStaminaLoss() >= 100)
		to_chat(affected_mob,span_warning("你觉得比平时更累了，也许你应该闭眼休息一下..."))
		need_mob_update += affected_mob.adjustStaminaLoss(-100, updating_stamina = FALSE) // Don't add the biotype parameter here as it results in infinite sleep and chat spam.
		affected_mob.Sleeping(10 SECONDS)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/probital/on_transfer(atom/A, methods=INGEST, trans_volume)
	if(!(methods & INGEST) || (!iscarbon(A) && !istype(A, /obj/item/organ/internal/stomach)) )
		return

	A.reagents.remove_reagent(/datum/reagent/medicine/c2/probital, trans_volume * 0.05)
	A.reagents.add_reagent(/datum/reagent/medicine/metafactor, trans_volume * 0.25)

	..()

/******BURN******/
/*Suffix: -uri*/
/datum/reagent/medicine/c2/lenturi
	name = "Lenturi-伦图里"
	description = "用于治疗烧伤，会对胃造成伤害."
	reagent_state = LIQUID
	color = "#6171FF"
	ph = 4.7
	var/resetting_probability = 0 //What are these for?? Can I remove them?
	var/spammer = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	inverse_chem_val = 0.4
	inverse_chem = /datum/reagent/inverse/lentslurri


/datum/reagent/medicine/c2/lenturi/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustFireLoss(-3 * REM * normalise_creation_purity() * seconds_per_tick, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_STOMACH, 0.4 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/aiuri
	name = "Aiuri-艾尤里"
	description = "用于治疗烧伤，会对眼造成伤害."
	reagent_state = LIQUID
	color = "#8C93FF"
	ph = 4
	var/resetting_probability = 0 //same with this? Old legacy vars that should be removed?
	var/message_cd = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	inverse_chem_val = 0.35
	inverse_chem = /datum/reagent/inverse/aiuri

/datum/reagent/medicine/c2/aiuri/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustFireLoss(-2 * REM * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_EYES, 0.25 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/hercuri
	name = "Hercuri-赫库里"
	description = "不要与汞元素混淆，这种药物在恢复烧伤方面表现出色，长时间使用会导致体温过低."
	reagent_state = LIQUID
	color = "#F7FFA5"
	overdose_threshold = 25
	reagent_weight = 0.6
	ph = 8.9
	inverse_chem = /datum/reagent/inverse/hercuri
	inverse_chem_val = 0.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	process_flags = REAGENT_ORGANIC | REAGENT_SYNTHETIC // SKYRAT EDIT ADDITION - Lets hercuri process in synths

/datum/reagent/medicine/c2/hercuri/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	// SKYRAT EDIT CHANGE BEGIN -- Adds check for owner_flags; indented the getFireLoss check and everything under it, so synths can get cooled down
	var/owner_flags = affected_mob.dna.species.reagent_flags
	if (owner_flags & PROCESS_ORGANIC)
		if(affected_mob.getFireLoss() > 50)
			need_mob_update = affected_mob.adjustFireLoss(-2 * REM * seconds_per_tick * normalise_creation_purity(), updating_health = FALSE, required_bodytype = affected_bodytype)
		else
			need_mob_update = affected_mob.adjustFireLoss(-1.25 * REM * seconds_per_tick * normalise_creation_purity(), updating_health = FALSE, required_bodytype = affected_bodytype)
	// SKYRAT EDIT CHANGE END
	affected_mob.adjust_bodytemperature(rand(-25,-5) * TEMPERATURE_DAMAGE_COEFFICIENT * REM * seconds_per_tick, 50)
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/humi = affected_mob
		humi.adjust_coretemperature(rand(-25,-5) * TEMPERATURE_DAMAGE_COEFFICIENT * REM * seconds_per_tick, 50)
	affected_mob.reagents?.chem_temp += (-10 * REM * seconds_per_tick)
	affected_mob.adjust_fire_stacks(-1 * REM * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/hercuri/expose_mob(mob/living/carbon/exposed_mob, methods=VAPOR, reac_volume)
	. = ..()
	if(!(methods & VAPOR))
		return

	exposed_mob.adjust_bodytemperature(-reac_volume * TEMPERATURE_DAMAGE_COEFFICIENT, 50)
	exposed_mob.adjust_fire_stacks(reac_volume / -2)
	if(reac_volume >= metabolization_rate)
		exposed_mob.extinguish_mob()

/datum/reagent/medicine/c2/hercuri/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * seconds_per_tick, 50) //chilly chilly
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/humi = affected_mob
		humi.adjust_coretemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * seconds_per_tick, 50)


/******OXY******/
/*Suffix: -mol*/
#define CONVERMOL_RATIO 5 //# Oxygen damage to result in 1 tox

/datum/reagent/medicine/c2/convermol
	name = "Convermol-肯尔莫"
	description = "治愈窒息症状，同时产生较少的有毒副产物，两者都与药物暴露和当前缺氧程度有关，过量服用会导致有毒副产物."
	reagent_state = LIQUID
	color = "#FF6464"
	overdose_threshold = 35 // at least 2 full syringes +some, this stuff is nasty if left in for long
	ph = 5.6
	inverse_chem_val = 0.5
	inverse_chem = /datum/reagent/inverse/healing/convermol
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/c2/convermol/on_mob_life(mob/living/carbon/human/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/oxycalc = 2.5 * REM * (current_cycle-1)
	if(!overdosed)
		oxycalc = min(oxycalc, affected_mob.getOxyLoss() + 0.5) //if NOT overdosing, we lower our toxdamage to only the damage we actually healed with a minimum of 0.1*current_cycle. IE if we only heal 10 oxygen damage but we COULD have healed 20, we will only take toxdamage for the 10. We would take the toxdamage for the extra 10 if we were overdosing.
	var/need_mob_update
	need_mob_update = affected_mob.adjustOxyLoss(-oxycalc * seconds_per_tick * normalise_creation_purity(), FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	need_mob_update += affected_mob.adjustToxLoss(oxycalc * seconds_per_tick / CONVERMOL_RATIO, updating_health = FALSE, required_biotype = affected_biotype)
	if(SPT_PROB((current_cycle-1) / 2, seconds_per_tick) && affected_mob.losebreath)
		affected_mob.losebreath--
		need_mob_update = TRUE
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/convermol/overdose_process(mob/living/carbon/human/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	metabolization_rate += 2.5 * REAGENTS_METABOLISM

#undef CONVERMOL_RATIO

/datum/reagent/medicine/c2/tirimol
	name = "Tirimol-提里莫尔"
	description = "一种会导致疲劳的供氧药物，长期接触会导致患者在药物代谢后入睡."
	color = "#FF6464"
	ph = 5.6
	inverse_chem = /datum/reagent/inverse/healing/tirimol
	inverse_chem_val = 0.4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	/// A cooldown for spacing bursts of stamina damage
	COOLDOWN_DECLARE(drowsycd)

/datum/reagent/medicine/c2/tirimol/on_mob_life(mob/living/carbon/human/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustOxyLoss(-3 * REM * seconds_per_tick * normalise_creation_purity(), updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	need_mob_update += affected_mob.adjustStaminaLoss(2 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
	if(drowsycd && COOLDOWN_FINISHED(src, drowsycd))
		affected_mob.adjust_drowsiness(20 SECONDS)
		COOLDOWN_START(src, drowsycd, 45 SECONDS)
	else if(!drowsycd)
		COOLDOWN_START(src, drowsycd, 15 SECONDS)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/tirimol/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	if(current_cycle > 21)
		affected_mob.Sleeping(10 SECONDS)

/******TOXIN******/
/*Suffix: -iver*/

/datum/reagent/medicine/c2/seiver //a bit of a gray joke
	name = "Seiver-塞维尔"
	description = "一种根据温度改变功能的药物，更高的温度会治愈更多的毒性，而更低的温度会只在病人收到辐射的情况下治愈更多的毒性，会损害心脏." //CHEM HOLDER TEMPS, NOT AIR TEMPS
	inverse_chem_val = 0.3
	ph = 3.7
	inverse_chem = /datum/reagent/inverse/technetium
	inverse_chem_val = 0.45
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	/// Temperatures below this number give radiation healing.
	var/rads_heal_threshold = 100

/datum/reagent/medicine/c2/seiver/on_mob_metabolize(mob/living/carbon/human/affected_mob)
	. = ..()
	rads_heal_threshold = rand(rads_heal_threshold - 50, rads_heal_threshold + 50) // Basically this means 50K and below will always give the radiation heal, and upto 150K could. Calculated once.

/datum/reagent/medicine/c2/seiver/on_mob_life(mob/living/carbon/human/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/chemtemp = min(holder.chem_temp, 1000)
	chemtemp = chemtemp ? chemtemp : T0C //why do you have null sweaty
	var/healypoints = 0 //5 healypoints = 1 heart damage; 5 rads = 1 tox damage healed for the purpose of healypoints

	//you're hot
	var/toxcalc = min(round(5 + ((chemtemp-1000)/175), 0.1), 5) * REM * seconds_per_tick * normalise_creation_purity() //max 2.5 tox healing per second
	var/need_mob_update
	if(toxcalc > 0)
		need_mob_update = affected_mob.adjustToxLoss(-toxcalc, updating_health = FALSE, required_biotype = affected_biotype)
		healypoints += toxcalc

	//and you're cold
	var/radcalc = round((T0C-chemtemp) / 6, 0.1) * REM * seconds_per_tick //max ~45 rad loss unless you've hit below 0K. if so, wow.
	if(radcalc > 0 && HAS_TRAIT(affected_mob, TRAIT_IRRADIATED))
		radcalc *= normalise_creation_purity()
		// extra rad healing if you are SUPER cold
		if(chemtemp < rads_heal_threshold*0.1)
			need_mob_update += affected_mob.adjustToxLoss(-radcalc * 0.9, updating_health = FALSE, required_biotype = affected_biotype)
		else if(chemtemp < rads_heal_threshold)
			need_mob_update += affected_mob.adjustToxLoss(-radcalc * 0.75, updating_health = FALSE, required_biotype = affected_biotype)
		healypoints += (radcalc / 5)

	//you're yes and... oh no!
	healypoints = round(healypoints, 0.1)
	affected_mob.adjustOrganLoss(ORGAN_SLOT_HEART, healypoints / 5, required_organ_flag = affected_organ_flags)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/multiver //enhanced with MULTIple medicines
	name = "Multiver-木太尔"
	description = "一种化学净化剂，越有特殊的药物存在，净化效果越好，轻微治愈毒性，会引起肺损伤(可通过特殊药物减轻)。"
	inverse_chem = /datum/reagent/inverse/healing/monover
	inverse_chem_val = 0.35
	ph = 9.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/c2/multiver/on_mob_life(mob/living/carbon/human/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/medibonus = 0 //it will always have itself which makes it REALLY start @ 1
	for(var/r in affected_mob.reagents.reagent_list)
		var/datum/reagent/the_reagent = r
		if(istype(the_reagent, /datum/reagent/medicine))
			medibonus += 1
	if(creation_purity >= 1) //Perfectly pure multivers gives a bonus of 2!
		medibonus += 1
	var/need_mob_update
	need_mob_update = affected_mob.adjustToxLoss(-0.5 * min(medibonus, 3 * normalise_creation_purity()) * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype) //not great at healing but if you have nothing else it will work
	need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.5 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags) //kills at 40u
	for(var/r2 in affected_mob.reagents.reagent_list)
		var/datum/reagent/the_reagent2 = r2
		if(the_reagent2 == src)
			continue
		var/amount2purge = 3
		if(medibonus >= 3 && istype(the_reagent2, /datum/reagent/medicine)) //3 unique meds (2+multiver) | (1 + pure multiver) will make it not purge medicines
			continue
		affected_mob.reagents.remove_reagent(the_reagent2.type, amount2purge * REM * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

// Antitoxin binds plants pretty well. So the tox goes significantly down
/datum/reagent/medicine/c2/multiver/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(-(round(volume * 2)*normalise_creation_purity())) //0-2.66, 2 by default (0.75 purity).

#define issyrinormusc(A) (istype(A,/datum/reagent/medicine/c2/syriniver) || istype(A,/datum/reagent/medicine/c2/musiver)) //musc is metab of syrin so let's make sure we're not purging either

/datum/reagent/medicine/c2/syriniver //Inject >> SYRINge
	name = "Syriniver-希里尔"
	description = "强效抗毒药物，用于静脉注射，具有狭窄的治疗指数."
	reagent_state = LIQUID
	color = "#8CDF24" // heavy saturation to make the color blend better
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	overdose_threshold = 6
	ph = 8.6
	var/conversion_amount
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/c2/syriniver/on_transfer(atom/A, methods=INJECT, trans_volume)
	if(!(methods & INJECT) || !iscarbon(A))
		return
	var/mob/living/carbon/C = A
	if(trans_volume >= 0.6) //prevents cheesing with ultralow doses.
		C.adjustToxLoss((-1.5 * min(2, trans_volume) * REM) * normalise_creation_purity(), required_biotype = affected_biotype) //This is to promote iv pole use for that chemotherapy feel.
	var/obj/item/organ/internal/liver/L = C.organs_slot[ORGAN_SLOT_LIVER]
	if(!L || L.organ_flags & ORGAN_FAILING)
		return
	conversion_amount = (trans_volume * (min(100 -C.get_organ_loss(ORGAN_SLOT_LIVER), 80) / 100)*normalise_creation_purity()) //the more damaged the liver the worse we metabolize.
	C.reagents.remove_reagent(/datum/reagent/medicine/c2/syriniver, conversion_amount)
	C.reagents.add_reagent(/datum/reagent/medicine/c2/musiver, conversion_amount)
	..()

/datum/reagent/medicine/c2/syriniver/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_LIVER, 0.8 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	need_mob_update += affected_mob.adjustToxLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	for(var/datum/reagent/R in affected_mob.reagents.reagent_list)
		if(issyrinormusc(R))
			continue
		affected_mob.reagents.remove_reagent(R.type, 0.4 * REM * seconds_per_tick)

	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/syriniver/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustOrganLoss(ORGAN_SLOT_LIVER, 1.5 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		. = UPDATE_MOB_HEALTH
	affected_mob.adjust_disgust(3 * REM * seconds_per_tick)
	affected_mob.reagents.add_reagent(/datum/reagent/medicine/c2/musiver, 0.225 * REM * seconds_per_tick)

/datum/reagent/medicine/c2/musiver //MUScles
	name = "Musiver-木瑟尔"
	description = "希里尔的活性代谢物，过量服用会导致肌肉无力."
	reagent_state = LIQUID
	color = "#DFD54E"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 25
	ph = 9.1
	var/datum/brain_trauma/mild/muscle_weakness/trauma
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/c2/musiver/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_LIVER, 0.1 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	need_mob_update += affected_mob.adjustToxLoss(-1 * REM * seconds_per_tick * normalise_creation_purity(), updating_health = FALSE, required_biotype = affected_biotype)
	for(var/datum/reagent/R in affected_mob.reagents.reagent_list)
		if(issyrinormusc(R))
			continue
		affected_mob.reagents.remove_reagent(R.type, 0.2 * REM * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/musiver/overdose_start(mob/living/carbon/affected_mob)
	. = ..()
	trauma = new()
	affected_mob.gain_trauma(trauma, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/medicine/c2/musiver/on_mob_delete(mob/living/affected_mob)
	. = ..()
	if(trauma)
		QDEL_NULL(trauma)

/datum/reagent/medicine/c2/musiver/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustOrganLoss(ORGAN_SLOT_LIVER, 1.5 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		. = UPDATE_MOB_HEALTH
	affected_mob.adjust_disgust(3 * REM * seconds_per_tick)

#undef issyrinormusc
/******COMBOS******/
/*Suffix: Combo of healing, prob gonna get wack REAL fast*/
/datum/reagent/medicine/c2/synthflesh
	name = "Synthflesh-合成肉"
	description = "以毒素为代价治疗创伤和烧伤(66%的伤害治疗)，100u以上可以恢复被烧伤剥皮的尸体，外敷用."
	reagent_state = LIQUID
	color = "#FFEBEB"
	ph = 7.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/c2/synthflesh/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE)
	. = ..()
	if(!iscarbon(exposed_mob))
		return
	var/mob/living/carbon/carbies = exposed_mob
	if(carbies.stat == DEAD)
		show_message = 0
	if(!(methods & (PATCH|TOUCH|VAPOR)))
		return
	var/current_bruteloss = carbies.getBruteLoss() // because this will be changed after calling adjustBruteLoss()
	var/current_fireloss = carbies.getFireLoss() // because this will be changed after calling adjustFireLoss()
	var/harmies = clamp(carbies.adjustBruteLoss(-1.25 * reac_volume, updating_health = FALSE, required_bodytype = affected_bodytype), 0, current_bruteloss)
	var/burnies = clamp(carbies.adjustFireLoss(-1.25 * reac_volume, updating_health = FALSE, required_bodytype = affected_bodytype), 0, current_fireloss)
	for(var/i in carbies.all_wounds)
		var/datum/wound/iter_wound = i
		iter_wound.on_synthflesh(reac_volume)
	var/need_mob_update = harmies + burnies
	need_mob_update = carbies.adjustToxLoss((harmies + burnies)*(0.5 + (0.25*(1-creation_purity))), updating_health = FALSE, required_biotype = affected_biotype) || need_mob_update //0.5 - 0.75

	if(need_mob_update)
		carbies.updatehealth()
	if(show_message)
		to_chat(carbies, span_danger("你感觉你的烧伤和瘀伤愈合了!痛得要命!"))

	carbies.add_mood_event("painful_medicine", /datum/mood_event/painful_medicine)
	if(HAS_TRAIT_FROM(exposed_mob, TRAIT_HUSK, BURN) && carbies.getFireLoss() < UNHUSK_DAMAGE_THRESHOLD && (carbies.reagents.get_reagent_amount(/datum/reagent/medicine/c2/synthflesh) + reac_volume >= SYNTHFLESH_UNHUSK_AMOUNT))
		carbies.cure_husk(BURN)
		carbies.visible_message("<span class='nicegreen'>一种胶状液体涂在了[carbies]的烧伤处. [carbies]看起来愈合了不少!") //we're avoiding using the phrases "burnt flesh" and "burnt skin" here because carbies could be a skeleton or a golem or something
	// SKYRAT EDIT ADDITION BEGIN - non-modular changeling balancing
	if(HAS_TRAIT_FROM(exposed_mob, TRAIT_HUSK, CHANGELING_DRAIN) && (carbies.reagents.get_reagent_amount(/datum/reagent/medicine/c2/synthflesh) + reac_volume >= SYNTHFLESH_LING_UNHUSK_AMOUNT))//Costs a little more than a normal husk
		carbies.cure_husk(CHANGELING_DRAIN)
		carbies.visible_message("<span class='nicegreen'>一种胶状液体涂在了[carbies]的组织处. [carbies]看起来愈合了不少!")
	// SKYRAT EDIT ADDITION END

/******ORGAN HEALING******/
/*Suffix: -rite*/
/*
*How this medicine works:
*Penthrite if you are not in crit only stabilizes your heart.
*As soon as you pass crit threshold it's special effects kick in. Penthrite forces your heart to beat preventing you from entering
*soft and hard crit, but there is a catch. During this you will be healed and you will sustain
*heart damage that will not imapct you as long as penthrite is in your system.
*If you reach the threshold of -60 HP penthrite stops working and you get a heart attack, penthrite is flushed from your system in that very moment,
*causing you to loose your soft crit, hard crit and heart stabilization effects.
*Overdosing on penthrite also causes a heart failure.
*/
/datum/reagent/medicine/c2/penthrite
	name = "Penthrite-喷砂膏"
	description = "一种昂贵的药物，即使没有心脏，也能帮助血液在全身循环，防止心脏衰竭，与肾上腺素或阿托品混合会引起爆炸."
	color = "#F5F5F5"
	overdose_threshold = 50
	ph = 12.7
	inverse_chem = /datum/reagent/inverse/penthrite
	inverse_chem_val = 0.25
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	/// List of traits to add/remove from our subject when we are in their system
	var/static/list/subject_traits = list(
		TRAIT_STABLEHEART,
		TRAIT_NOHARDCRIT,
		TRAIT_NOSOFTCRIT,
		TRAIT_NOCRITDAMAGE,
	)

/atom/movable/screen/alert/penthrite
	name = "Strong Heartbeat-强心剂"
	desc = "心跳得很有力!"
	icon_state = "penthrite"

/datum/reagent/medicine/c2/penthrite/on_mob_metabolize(mob/living/user)
	. = ..()
	user.throw_alert("penthrite", /atom/movable/screen/alert/penthrite)
	user.add_traits(subject_traits, type)

/datum/reagent/medicine/c2/penthrite/on_mob_life(mob/living/carbon/human/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustStaminaLoss(-12.5 * REM * seconds_per_tick, updating_stamina = FALSE) //SKYRAT EDIT ADDITION - COMBAT - makes your heart beat faster, fills you with energy. For miners
	need_mob_update = affected_mob.adjustOrganLoss(ORGAN_SLOT_STOMACH, 0.25 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(affected_mob.health <= HEALTH_THRESHOLD_CRIT && affected_mob.health > (affected_mob.crit_threshold + HEALTH_THRESHOLD_FULLCRIT * (2 * normalise_creation_purity()))) //we cannot save someone below our lowered crit threshold.

		need_mob_update += affected_mob.adjustToxLoss(-2 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += affected_mob.adjustBruteLoss(-2 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += affected_mob.adjustFireLoss(-2 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += affected_mob.adjustOxyLoss(-6 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)

		affected_mob.losebreath = 0

		need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_HEART, max(volume/10, 1) * REM * seconds_per_tick, required_organ_flag = affected_organ_flags) // your heart is barely keeping up!

		affected_mob.set_jitter_if_lower(rand(0 SECONDS, 4 SECONDS) * REM * seconds_per_tick)
		affected_mob.set_dizzy_if_lower(rand(0 SECONDS, 4 SECONDS) * REM * seconds_per_tick)

		if(SPT_PROB(18, seconds_per_tick))
			to_chat(affected_mob,span_danger("你试图放弃，但你的心还在跳!"))

	if(affected_mob.health <= (affected_mob.crit_threshold + HEALTH_THRESHOLD_FULLCRIT*(2*normalise_creation_purity()))) //certain death below this threshold
		REMOVE_TRAIT(affected_mob, TRAIT_STABLEHEART, type) //we have to remove the stable heart trait before we give them a heart attack
		to_chat(affected_mob,span_danger("你觉得胸腔里有东西破裂了!"))
		affected_mob.emote("scream")
		affected_mob.set_heartattack(TRUE)
		volume = 0
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/penthrite/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.clear_alert("penthrite")
	affected_mob.remove_traits(subject_traits, type)

/datum/reagent/medicine/c2/penthrite/overdose_process(mob/living/carbon/human/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_STABLEHEART, type)
	var/need_mob_update
	need_mob_update = affected_mob.adjustStaminaLoss(10 * REM * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_HEART, 10 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags)
	need_mob_update += affected_mob.set_heartattack(TRUE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH


/******NICHE******/
//todo