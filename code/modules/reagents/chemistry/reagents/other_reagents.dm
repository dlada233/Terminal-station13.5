/datum/reagent/blood
	data = list("viruses"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null,"quirks"=null, "monkey_origins" = FALSE) // SKYRAT EDIT - Rebalancing blood for Hemophages - ORIGINAL: data = list("viruses"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null,"quirks"=null)
	name = "Blood"
	color = "#C80000" // rgb: 200, 0, 0
	metabolization_rate = 12.5 * REAGENTS_METABOLISM //fast rate so it disappears fast.
	taste_description = "iron"
	taste_mult = 1.3
	penetrates_skin = NONE
	ph = 7.4
	default_container = /obj/item/reagent_containers/blood

/datum/glass_style/shot_glass/blood
	required_drink_type = /datum/reagent/blood
	icon_state = "shotglassred"

/datum/glass_style/drinking_glass/blood
	required_drink_type = /datum/reagent/blood
	name = "glass of tomato juice"
	desc = "Are you sure this is tomato juice?"
	icon_state = "glass_red"

	// FEED ME
/datum/reagent/blood/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_pestlevel(rand(2, 3))

/datum/reagent/blood/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(data && data["viruses"])
		for(var/thing in data["viruses"])
			var/datum/disease/strain = thing

			if((strain.spread_flags & DISEASE_SPREAD_SPECIAL) || (strain.spread_flags & DISEASE_SPREAD_NON_CONTAGIOUS))
				continue

			if(methods & INGEST)
				if(!strain.has_required_infectious_organ(exposed_mob, ORGAN_SLOT_STOMACH))
					continue

				exposed_mob.ForceContractDisease(strain)
			else if(methods & (INJECT|PATCH))
				if(!strain.has_required_infectious_organ(exposed_mob, ORGAN_SLOT_HEART))
					continue

				exposed_mob.ForceContractDisease(strain)
			else if((methods & VAPOR) && (strain.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS))
				if(!strain.has_required_infectious_organ(exposed_mob, ORGAN_SLOT_LUNGS))
					continue

				exposed_mob.ContactContractDisease(strain)
			else if((methods & TOUCH) && (strain.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS))
				exposed_mob.ContactContractDisease(strain)

	if(data && data["resistances"])
		if(methods & (INGEST|INJECT)) //have to inject or ingest it. no curefoam/cheap curesprays
			for(var/stuff in exposed_mob.diseases)
				var/datum/disease/infection = stuff
				if(infection.GetDiseaseID() in data["resistances"])
					if(!infection.bypasses_immunity)
						infection.cure(add_resistance = FALSE)

	if(iscarbon(exposed_mob))
		var/mob/living/carbon/exposed_carbon = exposed_mob
		if(exposed_carbon.get_blood_id() == type && ((methods & INJECT) || ((methods & INGEST) && HAS_TRAIT(exposed_carbon, TRAIT_DRINKS_BLOOD))))
			if(!data || !(data["blood_type"] in get_safe_blood(exposed_carbon.dna.blood_type)))
				exposed_carbon.reagents.add_reagent(/datum/reagent/toxin, reac_volume * 0.5)
			else
				/* SKYRAT EDIT - Rebalancing blood for Hemophages - ORIGINAL:
				exposed_carbon.blood_volume = min(exposed_carbon.blood_volume + round(reac_volume, 0.1), BLOOD_VOLUME_MAXIMUM)
				*/ // ORIGINAL END - SKYRAT EDIT:
				// We do a max() here so that being injected with monkey blood when you're past 560u doesn't reset you back to 560
				var/max_blood_volume = data["monkey_origins"] ? max(exposed_carbon.blood_volume, BLOOD_VOLUME_NORMAL) : BLOOD_VOLUME_MAXIMUM

				exposed_carbon.blood_volume = min(exposed_carbon.blood_volume + round(reac_volume, 0.1), max_blood_volume)
				// SKYRAT EDIT END

			exposed_carbon.reagents.remove_reagent(type, reac_volume) // Because we don't want blood to just lie around in the patient's blood, makes no sense.


/datum/reagent/blood/on_new(list/data)
	. = ..()
	if(istype(data))
		SetViruses(src, data)

/datum/reagent/blood/on_merge(list/mix_data)
	if(data && mix_data)
		if(data["blood_DNA"] != mix_data["blood_DNA"])
			data["cloneable"] = 0 //On mix, consider the genetic sampling unviable for pod cloning if the DNA sample doesn't match.
		if(data["viruses"] || mix_data["viruses"])

			var/list/mix1 = data["viruses"]
			var/list/mix2 = mix_data["viruses"]

			// Stop issues with the list changing during mixing.
			var/list/to_mix = list()

			for(var/datum/disease/advance/AD in mix1)
				to_mix += AD
			for(var/datum/disease/advance/AD in mix2)
				to_mix += AD

			var/datum/disease/advance/AD = Advance_Mix(to_mix)
			if(AD)
				var/list/preserve = list(AD)
				for(var/D in data["viruses"])
					if(!istype(D, /datum/disease/advance))
						preserve += D
				data["viruses"] = preserve
	return 1

/datum/reagent/blood/proc/get_diseases()
	. = list()
	if(data && data["viruses"])
		for(var/thing in data["viruses"])
			var/datum/disease/D = thing
			. += D

/datum/reagent/blood/expose_turf(turf/exposed_turf, reac_volume)//splash the blood all over the place
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume < 3)
		return

	var/obj/effect/decal/cleanable/blood/bloodsplatter = locate() in exposed_turf //find some blood here
	if(!bloodsplatter)
		bloodsplatter = new(exposed_turf, data["viruses"])
	else if(LAZYLEN(data["viruses"]))
		var/list/viri_to_add = list()
		for(var/datum/disease/virus in data["viruses"])
			if(virus.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS)
				viri_to_add += virus
		if(LAZYLEN(viri_to_add))
			bloodsplatter.AddComponent(/datum/component/infective, viri_to_add)
	if(data["blood_DNA"])
		bloodsplatter.add_blood_DNA(list(data["blood_DNA"] = data["blood_type"]))

/datum/reagent/consumable/liquidgibs
	name = "Liquid Gibs-流体残肢"
	color = "#CC4633"
	description = "你根本不想去想这里面有什么."
	taste_description = "gross iron"
	nutriment_factor = 2
	material = /datum/material/meat
	ph = 7.45
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/shot_glass/liquidgibs
	required_drink_type = /datum/reagent/consumable/liquidgibs
	icon_state = "shotglassred"

/datum/reagent/bone_dust
	name = "Bone Dust-骨粉"
	color = "#dbcdcb"
	description = "磨碎的骨头，恶心!"
	taste_description = "世上最恶心的粉末"

/datum/reagent/vaccine
	//data must contain virus type
	name = "Vaccine-疫苗"
	color = "#C81040" // rgb: 200, 16, 64
	taste_description = "黏糊糊"
	penetrates_skin = NONE

/datum/reagent/vaccine/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(!islist(data) || !(methods & (INGEST|INJECT)))
		return

	for(var/thing in exposed_mob.diseases)
		var/datum/disease/infection = thing
		if(infection.GetDiseaseID() in data)
			infection.cure(add_resistance = TRUE)
	LAZYOR(exposed_mob.disease_resistances, data)

/datum/reagent/vaccine/on_merge(list/data)
	if(istype(data))
		src.data |= data.Copy()

/datum/reagent/vaccine/fungal_tb
	name = "疫苗 (真菌结核病)"

/datum/reagent/vaccine/fungal_tb/New(data)
	. = ..()
	var/list/cached_data
	if(!data)
		cached_data = list()
	else
		cached_data = data
	cached_data |= "[/datum/disease/tuberculosis]"
	src.data = cached_data

/datum/reagent/water
	name = "Water-水"
	description = "由氢和氧组成的普遍存在的化学物质."
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "水"
	var/cooling_temperature = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_CLEANS
	default_container = /obj/item/reagent_containers/cup/glass/waterbottle
	evaporates = TRUE //SKYRAT EDIT ADDITION

/datum/glass_style/shot_glass/water
	required_drink_type = /datum/reagent/water
	icon_state = "shotglassclear"

/datum/glass_style/drinking_glass/water
	required_drink_type = /datum/reagent/water
	name = "一杯水"
	desc = "所有点心之父."
	icon_state = "glass_clear"

/datum/glass_style/shot_glass/water
	required_drink_type = /datum/reagent/water
	icon_state = "shotglassclear"

/datum/glass_style/drinking_glass/water
	required_drink_type = /datum/reagent/water
	name = "一杯水"
	desc = "所有点心之父."
	icon_state = "glass_clear"

/*
 * Water reaction to turf
 */

/datum/reagent/water/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return

	var/cool_temp = cooling_temperature
	if(reac_volume >= 5)
		exposed_turf.MakeSlippery(TURF_WET_WATER, 10 SECONDS, min(reac_volume*1.5 SECONDS, 60 SECONDS))

	for(var/mob/living/basic/slime/exposed_slime in exposed_turf)
		exposed_slime.apply_water()

	var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in exposed_turf)
	if(hotspot && !isspaceturf(exposed_turf))
		if(exposed_turf.air)
			var/datum/gas_mixture/air = exposed_turf.air
			air.temperature = max(min(air.temperature-(cool_temp*1000), air.temperature/cool_temp),TCMB)
			air.react(src)
			qdel(hotspot)

/*
 * Water reaction to an object
 */

/datum/reagent/water/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	exposed_obj.extinguish()
	exposed_obj.wash(CLEAN_TYPE_ACID)
	// Monkey cube
	if(istype(exposed_obj, /obj/item/food/monkeycube))
		var/obj/item/food/monkeycube/cube = exposed_obj
		cube.Expand()

	// Dehydrated carp
	else if(istype(exposed_obj, /obj/item/toy/plush/carpplushie/dehy_carp))
		var/obj/item/toy/plush/carpplushie/dehy_carp/dehy = exposed_obj
		dehy.Swell() // Makes a carp

	else if(istype(exposed_obj, /obj/item/stack/sheet/hairlesshide))
		var/obj/item/stack/sheet/hairlesshide/HH = exposed_obj
		new /obj/item/stack/sheet/wethide(get_turf(HH), HH.amount)
		qdel(HH)


/// How many wet stacks you get per units of water when it's applied by touch.
#define WATER_TO_WET_STACKS_FACTOR_TOUCH 0.5
/// How many wet stacks you get per unit of water when it's applied by vapor. Much less effective than by touch, of course.
#define WATER_TO_WET_STACKS_FACTOR_VAPOR 0.1


/**
 * Water reaction to a mob
 */
/datum/reagent/water/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume)//Splashing people with water can help put them out!
	. = ..()
	if(methods & TOUCH)
		exposed_mob.extinguish_mob() // extinguish removes all fire stacks
		exposed_mob.adjust_wet_stacks(reac_volume * WATER_TO_WET_STACKS_FACTOR_TOUCH) // Water makes you wet, at a 50% water-to-wet-stacks ratio. Which, in turn, gives you some mild protection from being set on fire!

	if(methods & VAPOR)
		exposed_mob.adjust_wet_stacks(reac_volume * WATER_TO_WET_STACKS_FACTOR_VAPOR) // Spraying someone with water with the hope to put them out is just simply too funny to me not to add it.

		if(!isfeline(exposed_mob)) // SKYRAT EDIT - Feline trait :) - ORIGINAL: if(!isfelinid(exposed_mob))
			return

		exposed_mob.incapacitate(1) // startles the felinid, canceling any do_after
		exposed_mob.add_mood_event("watersprayed", /datum/mood_event/watersprayed)


#undef WATER_TO_WET_STACKS_FACTOR_TOUCH
#undef WATER_TO_WET_STACKS_FACTOR_VAPOR


/datum/reagent/water/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.blood_volume)
		affected_mob.blood_volume += 0.1 * REM * seconds_per_tick // water is good for you!
	affected_mob.adjust_drunk_effect(-0.25 * REM * seconds_per_tick) // and even sobers you up slowly!!

// For weird backwards situations where water manages to get added to trays nutrients, as opposed to being snowflaked away like usual.
/datum/reagent/water/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_waterlevel(round(volume))
	//You don't belong in this world, monster!
	mytray.reagents.remove_reagent(type, volume)

/datum/reagent/water/salt
	name = "Saltwater-盐水"
	description = "水，不过是咸的，闻起来像...站点医务室?"
	color = "#aaaaaa9d" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "大海"
	cooling_temperature = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_CLEANS
	default_container = /obj/item/reagent_containers/cup/glass/waterbottle

/datum/glass_style/shot_glass/water/salt
	required_drink_type = /datum/reagent/water/salt
	icon_state = "shotglassclear"

/datum/glass_style/drinking_glass/water/salt
	required_drink_type = /datum/reagent/water/salt
	name = "一杯盐水"
	desc = "如果你喉咙痛，喝点盐水漱口，疼痛就会消失，可以作为一种非常临时的身体药物用于治疗伤口."
	icon_state = "glass_clear"

/datum/reagent/water/salt/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	. = ..()
	if(!iscarbon(exposed_mob))
		return
	var/mob/living/carbon/carbies = exposed_mob
	if(!(methods & (PATCH|TOUCH|VAPOR)))
		return
	for(var/datum/wound/iter_wound as anything in carbies.all_wounds)
		iter_wound.on_saltwater(reac_volume, carbies)

// Mixed salt with water! All the help of salt with none of the irritation. Plus increased volume.
/datum/wound/proc/on_saltwater(reac_volume, mob/living/carbon/carbies)
	return

/datum/wound/pierce/bleed/on_saltwater(reac_volume, mob/living/carbon/carbies)
	adjust_blood_flow(-0.06 * reac_volume, initial_flow * 0.6)
	to_chat(carbies, span_notice("盐水渗入了[lowertext(src)]，吸收了血液."))

/datum/wound/slash/flesh/on_saltwater(reac_volume, mob/living/carbon/carbies)
	adjust_blood_flow(-0.1 * reac_volume, initial_flow * 0.5)
	to_chat(carbies, span_notice("盐水渗入了[lowertext(src)], 吸收了血液."))

/datum/wound/burn/flesh/on_saltwater(reac_volume)
	// Similar but better stats from normal salt.
	sanitization += VALUE_PER(0.6, 30) * reac_volume
	infestation -= max(VALUE_PER(0.5, 30) * reac_volume, 0)
	infestation_rate += VALUE_PER(0.07, 30) * reac_volume
	to_chat(victim, span_notice("盐水渗入了[lowertext(src)], 吸收...各种各样的液体，之后感觉好多了."))
	return

/datum/reagent/water/holywater
	name = "Holy Water-圣水"
	description = "受到神灵庇佑的水."
	color = "#E0E8EF" // rgb: 224, 232, 239
	self_consuming = TRUE //divine intervention won't be limited by the lack of a liver
	ph = 7.5 //God is alkaline
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_CLEANS|REAGENT_UNAFFECTED_BY_METABOLISM // Operates at fixed metabolism for balancing memes.
	default_container = /obj/item/reagent_containers/cup/glass/bottle/holywater
	metabolized_traits = list(TRAIT_HOLY)

/datum/glass_style/drinking_glass/holywater
	required_drink_type = /datum/reagent/water/holywater
	name = "圣水瓶"
	desc = "一瓶圣水."
	icon_state = "glass_clear"

/datum/reagent/water/holywater/on_new(list/data)
	// Tracks the total amount of deciseconds that the reagent has been metab'd for, for the purpose of deconversion
	if(isnull(data))
		data = list("deciseconds_metabolized" = 0)
	else if(isnull(data["deciseconds_metabolized"]))
		data["deciseconds_metabolized"] = 0

	return ..()

// Holy water. Unlike water, which is nuked, stays in and heals the plant a little with the power of the spirits. Also ALSO increases instability.
/datum/reagent/water/holywater/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_waterlevel(round(volume))
	mytray.adjust_plant_health(round(volume * 0.1))
	mytray.myseed?.adjust_instability(round(volume * 0.15))

/datum/reagent/water/holywater/on_mob_add(mob/living/affected_mob, amount)
	. = ..()
	if(IS_CULTIST(affected_mob))
		to_chat(affected_mob, span_userdanger("一种邪恶的神圣开始在你的思想中蔓延它闪亮的卷须，清除了血中的某些影响!"))

/datum/reagent/water/holywater/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()

	data["deciseconds_metabolized"] += (seconds_per_tick * 1 SECONDS * REM)

	affected_mob.adjust_jitter_up_to(4 SECONDS * REM * seconds_per_tick, 20 SECONDS)

	if(IS_CULTIST(affected_mob))
		for(var/datum/action/innate/cult/blood_magic/BM in affected_mob.actions)
			var/removed_any = FALSE
			for(var/datum/action/innate/cult/blood_spell/BS in BM.spells)
				removed_any = TRUE
				qdel(BS)
			if(removed_any)
				to_chat(affected_mob, span_cult_large("当圣水冲刷你的身体时，你的血液崇拜动摇了!"))

	if(data["deciseconds_metabolized"] >= (25 SECONDS)) // 10 units
		affected_mob.adjust_stutter_up_to(4 SECONDS * REM * seconds_per_tick, 20 SECONDS)
		affected_mob.set_dizzy_if_lower(10 SECONDS)
		if(IS_CULTIST(affected_mob) && SPT_PROB(10, seconds_per_tick))
			affected_mob.say(pick("Av'te Nar'Sie","Pa'lid Mors","INO INO ORA ANA","SAT ANA!","Daim'niodeis Arc'iai Le'eones","R'ge Na'sie","Diabo us Vo'iscum","Eld' Mon Nobis"), forced = "holy water")
			if(prob(10))
				affected_mob.visible_message(span_danger("[affected_mob]开始癫痫发作!"), span_userdanger("你癫痫发作了!"))
				affected_mob.Unconscious(12 SECONDS)
				to_chat(affected_mob, span_cult_large("[pick("血是你们的纽带 - 没有它，你什么都不是", "别忘了你的位置", \
					"那么强大的力量，你还是失败了?", "如果你洗不清这罪孽，我就要洗净你贫乏的生命!")]."))

	if(data["deciseconds_metabolized"] >= (1 MINUTES)) // 24 units
		if(IS_CULTIST(affected_mob))
			affected_mob.mind.remove_antag_datum(/datum/antagonist/cult)
			affected_mob.Unconscious(10 SECONDS)
		affected_mob.remove_status_effect(/datum/status_effect/jitter)
		affected_mob.remove_status_effect(/datum/status_effect/speech/stutter)
		holder?.remove_reagent(type, volume) // maybe this is a little too perfect and a max() cap on the statuses would be better??

/datum/reagent/water/holywater/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume >= 10)
		for(var/obj/effect/rune/R in exposed_turf)
			qdel(R)
	exposed_turf.Bless()

/datum/reagent/water/hollowwater
	name = "Hollow Water-空心水"
	description = "一种无处不在的化学物质，由氢和氧组成，但它看起来有点中空."
	color = "#88878777"
	taste_description = "空白"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/hydrogen_peroxide
	name = "Hydrogen Peroxide-过氧化氢"
	description = "由氢、氧和氧组成的无所不在的化学物质。" //intended intended
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "沸水"
	var/cooling_temperature = 2
	ph = 6.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/shot_glass/hydrogen_peroxide
	required_drink_type = /datum/reagent/hydrogen_peroxide
	icon_state = "shotglassclear"

/datum/glass_style/drinking_glass/hydrogen_peroxide
	required_drink_type = /datum/reagent/hydrogen_peroxide
	name = "glass of oxygenated water-含氧水"
	desc = "所有点心之父，味道肯定很棒，对吧?"
	icon_state = "glass_clear"

/*
 * Water reaction to turf
 */

/datum/reagent/hydrogen_peroxide/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume >= 5)
		exposed_turf.MakeSlippery(TURF_WET_WATER, 10 SECONDS, min(reac_volume*1.5 SECONDS, 60 SECONDS))
/*
 * Water reaction to a mob
 */

/datum/reagent/hydrogen_peroxide/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with h2o2 can burn them !
	. = ..()
	if(methods & TOUCH)
		exposed_mob.adjustFireLoss(2)

/datum/reagent/fuel/unholywater //if you somehow managed to extract this from someone, dont splash it on yourself and have a smoke
	name = "Unholy Water-邪水"
	description = "一些不应该存在于这个世界上的东西."
	taste_description = "罪孽"
	self_consuming = TRUE //unholy intervention won't be limited by the lack of a liver
	metabolization_rate = 2.5 * REAGENTS_METABOLISM  //0.5u/second
	penetrates_skin = TOUCH|VAPOR
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/fuel/unholywater/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if(IS_CULTIST(affected_mob))
		ADD_TRAIT(affected_mob, TRAIT_COAGULATING, type)

/datum/reagent/fuel/unholywater/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()

	var/need_mob_update = FALSE
	if(IS_CULTIST(affected_mob))
		affected_mob.adjust_drowsiness(-10 SECONDS * REM * seconds_per_tick)
		affected_mob.AdjustAllImmobility(-40 * REM * seconds_per_tick)
		need_mob_update += affected_mob.adjustStaminaLoss(-10 * REM * seconds_per_tick, updating_stamina = FALSE)
		need_mob_update += affected_mob.adjustToxLoss(-2 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += affected_mob.adjustOxyLoss(-2 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += affected_mob.adjustBruteLoss(-2 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += affected_mob.adjustFireLoss(-2 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update = TRUE
		if(ishuman(affected_mob) && affected_mob.blood_volume < BLOOD_VOLUME_NORMAL)
			affected_mob.blood_volume += 3 * REM * seconds_per_tick

			var/datum/wound/bloodiest_wound

			for(var/datum/wound/iter_wound as anything in affected_mob.all_wounds)
				if(iter_wound.blood_flow && iter_wound.blood_flow > bloodiest_wound?.blood_flow)
					bloodiest_wound = iter_wound

			if(bloodiest_wound)
				bloodiest_wound.adjust_blood_flow(-2 * REM * seconds_per_tick)

	else  // Will deal about 90 damage when 50 units are thrown
		need_mob_update += affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * REM * seconds_per_tick, 150)
		need_mob_update += affected_mob.adjustToxLoss(1 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += affected_mob.adjustFireLoss(1 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += affected_mob.adjustOxyLoss(1 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += affected_mob.adjustBruteLoss(1 * REM * seconds_per_tick, updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/fuel/unholywater/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_COAGULATING, type) //We don't cult check here because potentially our imbiber may no longer be a cultist for whatever reason! It doesn't purge holy water, after all!

/datum/reagent/hellwater //if someone has this in their system they've really pissed off an eldrich god
	name = "Hell Water-炼狱之水"
	description = "YOUR FLESH! IT BURNS!"
	taste_description = "燃烧"
	ph = 0.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/hellwater/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.set_fire_stacks(min(affected_mob.fire_stacks + (1.5 * seconds_per_tick), 5))
	affected_mob.ignite_mob() //Only problem with igniting people is currently the commonly available fire suits make you immune to being on fire
	var/need_mob_update
	need_mob_update = affected_mob.adjustToxLoss(0.5*seconds_per_tick, updating_health = FALSE)
	need_mob_update += affected_mob.adjustFireLoss(0.5*seconds_per_tick, updating_health = FALSE) //Hence the other damages... ain't I a bastard?
	affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2.5*seconds_per_tick, 150)
	if(holder)
		holder.remove_reagent(type, 0.5 * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/omnizine/godblood
	name = "Godblood-神血"
	description = "缓慢治疗所有类型的伤害，有相当高的过量阈值，散发着神秘的力量."
	overdose_threshold = 150
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

///Used for clownery
/datum/reagent/lube
	name = "Space Lube-太空润滑剂"
	description = "润滑剂是在两个运动表面之间引入的物质，以减少它们之间的摩擦和磨损."
	color = "#009CA8" // rgb: 0, 156, 168
	taste_description = "樱桃" // by popular demand
	var/lube_kind = TURF_WET_LUBE ///What kind of slipperiness gets added to turfs
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/lube/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume >= 1)
		exposed_turf.MakeSlippery(lube_kind, 15 SECONDS, min(reac_volume * 2 SECONDS, 120))

///Stronger kind of lube. Applies TURF_WET_SUPERLUBE.
/datum/reagent/lube/superlube
	name = "Super Duper Lube-超级润滑剂"
	description = "\[数据删除\]在事件\[数据删除\]发生后已经被取缔了."
	lube_kind = TURF_WET_SUPERLUBE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/spraytan
	name = "Spray Tan-晒黑喷雾"
	description = "涂在皮肤上使皮肤变黑的物质."
	color = "#FFC080" // rgb: 255, 196, 128  Bright orange
	metabolization_rate = 10 * REAGENTS_METABOLISM // very fast, so it can be applied rapidly.  But this changes on an overdose
	overdose_threshold = 11 //Slightly more than one un-nozzled spraybottle.
	taste_description = "酸橙"
	ph = 5
	fallback_icon = 'icons/obj/drinks/drink_effects.dmi'
	fallback_icon_state = "spraytan_fallback"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/spraytan/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE)
	. = ..()
	if(ishuman(exposed_mob))
		if(methods & (PATCH|VAPOR))
			var/mob/living/carbon/human/exposed_human = exposed_mob
			if(HAS_TRAIT(exposed_human, TRAIT_USES_SKINTONES))
				switch(exposed_human.skin_tone)
					if("african1")
						exposed_human.skin_tone = "african2"
					if("indian")
						exposed_human.skin_tone = "mixed2"
					if("arab")
						exposed_human.skin_tone = "indian"
					if("asian2")
						exposed_human.skin_tone = "arab"
					if("asian1")
						exposed_human.skin_tone = "asian2"
					if("mediterranean")
						exposed_human.skin_tone = "mixed1"
					if("latino")
						exposed_human.skin_tone = "mediterranean"
					if("caucasian3")
						exposed_human.skin_tone = "mediterranean"
					if("caucasian2")
						exposed_human.skin_tone = pick("caucasian3", "latino")
					if("caucasian1")
						exposed_human.skin_tone = "caucasian2"
					if("albino")
						exposed_human.skin_tone = "caucasian1"
					if("mixed1")
						exposed_human.skin_tone = "mixed2"
					if("mixed2")
						exposed_human.skin_tone = "mixed3"
					if("mixed3")
						exposed_human.skin_tone = "african1"
					if("mixed4")
						exposed_human.skin_tone = "mixed3"
			//take current alien color and darken it slightly
			else if(HAS_TRAIT(exposed_human, TRAIT_MUTANT_COLORS) && !HAS_TRAIT(exposed_human, TRAIT_FIXED_MUTANT_COLORS))
				var/list/existing_color = rgb2num(exposed_human.dna.features["mcolor"])
				var/list/darkened_color = list()
				// Reduces each part of the color by 16
				for(var/channel in existing_color)
					darkened_color += max(channel - 17, 0)

				var/new_color = rgb(darkened_color[1], darkened_color[2], darkened_color[3])
				var/list/new_hsv = rgb2hsv(new_color)
				// Can't get too dark now
				if(new_hsv[3] >= 50)
					exposed_human.dna.features["mcolor"] = new_color
			exposed_human.update_body(is_creating = TRUE)

		if((methods & INGEST) && show_message)
			to_chat(exposed_mob, span_notice("尝起来很恐怖."))

/datum/reagent/spraytan/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	metabolization_rate = 1 * REAGENTS_METABOLISM

	if(ishuman(affected_mob))
		var/mob/living/carbon/human/affected_human = affected_mob
		var/obj/item/bodypart/head/head = affected_human.get_bodypart(BODY_ZONE_HEAD)
		if(head)
			head.head_flags |= HEAD_HAIR //No hair? No problem!
		if(!HAS_TRAIT(affected_human, TRAIT_SHAVED))
			affected_human.set_facial_hairstyle("Shaved", update = FALSE)
		affected_human.set_facial_haircolor(COLOR_BLACK, update = FALSE)
		if(!HAS_TRAIT(affected_human, TRAIT_BALD))
			affected_human.set_hairstyle("Spiky", update = FALSE)
		affected_human.set_haircolor(COLOR_BLACK, update = FALSE)
		if(HAS_TRAIT(affected_human, TRAIT_USES_SKINTONES))
			affected_human.skin_tone = "orange"
		else if(HAS_TRAIT(affected_human, TRAIT_MUTANT_COLORS) && !HAS_TRAIT(affected_human, TRAIT_FIXED_MUTANT_COLORS)) //Aliens with custom colors simply get turned orange
			affected_human.dna.features["mcolor"] = "#ff8800"
		affected_human.update_body(is_creating = TRUE)
		if(SPT_PROB(3.5, seconds_per_tick))
			if(affected_human.w_uniform)
				affected_mob.visible_message(pick("<b>[affected_mob]</b>的衣领毫无征兆的弹开了.</span>", "<b>[affected_mob]</b>扭曲了[affected_mob.p_their()]的臂膀."))
			else
				affected_mob.visible_message("<b>[affected_mob]</b>弯曲了[affected_mob.p_their()]的臂膀.")
	if(SPT_PROB(5, seconds_per_tick))
		affected_mob.say(pick("Shit was SO cash.", "你是世界上最坏的恶人.", "What sports do you play, other than 'jack off to naked drawn Japanese people?'", "Don???t be a stranger. Just hit me with your best shot.", "My name is John and I hate every single one of you."), forced = /datum/reagent/spraytan)

#define MUT_MSG_IMMEDIATE 1
#define MUT_MSG_EXTENDED 2
#define MUT_MSG_ABOUT2TURN 3

/// the current_cycle threshold / iterations needed before one can transform
#define CYCLES_TO_TURN 20
/// the cycle at which 'immediate' mutation text begins displaying
#define CYCLES_MSG_IMMEDIATE 6
/// the cycle at which 'extended' mutation text begins displaying
#define CYCLES_MSG_EXTENDED 16

/datum/reagent/mutationtoxin
	name = "Stable Mutation Toxin-稳定突变毒素"
	description = "人源化毒素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	metabolization_rate = 0.5 * REAGENTS_METABOLISM //metabolizes to prevent micro-dosage
	taste_description = "slime"
	var/race = /datum/species/human
	var/list/mutationtexts = list( "你感觉不太舒服." = MUT_MSG_IMMEDIATE,
									"你的皮肤感觉有点不正常." = MUT_MSG_IMMEDIATE,
									"你的四肢开始呈现出不同的形状." = MUT_MSG_EXTENDED,
									"你的部位开始变形." = MUT_MSG_EXTENDED,
									"你觉得自己好像随时都要发生改变了!" = MUT_MSG_ABOUT2TURN)

/datum/reagent/mutationtoxin/on_mob_life(mob/living/carbon/human/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!istype(affected_mob))
		return
	if(!(affected_mob.dna?.species) || !(affected_mob.mob_biotypes & affected_biotype))
		return

	if(SPT_PROB(5, seconds_per_tick))
		var/list/pick_ur_fav = list()
		var/filter = NONE
		if(current_cycle <= CYCLES_MSG_IMMEDIATE)
			filter = MUT_MSG_IMMEDIATE
		else if(current_cycle <= CYCLES_MSG_EXTENDED)
			filter = MUT_MSG_EXTENDED
		else
			filter = MUT_MSG_ABOUT2TURN

		for(var/i in mutationtexts)
			if(mutationtexts[i] == filter)
				pick_ur_fav += i
		to_chat(affected_mob, span_warning("[pick(pick_ur_fav)]"))

	if(current_cycle >= CYCLES_TO_TURN)
		var/datum/species/species_type = race
		//affected_mob.set_species(species_type) //ORIGINAL
		affected_mob.set_species(species_type, TRUE, FALSE, null, null, null, null, TRUE) //SKYRAT EDIT CHANGE - CUSTOMIZATION
		holder.del_reagent(type)
		to_chat(affected_mob, span_warning("我要变成一个[lowertext(initial(species_type.name))]!"))
		return

/datum/reagent/mutationtoxin/classic //The one from plasma on green slimes
	name = "Mutation Toxin-不稳定突变素"
	description = "腐化的毒素."
	color = "#13BC5E" // rgb: 19, 188, 94
	race = /datum/species/jelly/slime
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/mutationtoxin/felinid
	name = "Felinid Mutation Toxin-猫科突变素"
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/human/felinid
	taste_description = "任何好的东西"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/lizard
	name = "Lizard Mutation Toxin-蜥蜴突变素"
	description = "一个蜥蜴突变素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/lizard
	taste_description = "龙之呼吸，但没有那么酷"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/mutationtoxin/fly
	name = "Fly Mutation Toxin-飞行突变素"
	description = "驱虫毒素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/fly
	taste_description = "垃圾"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/moth
	name = "Moth Mutation Toxin-蛾类突变素"
	description = "发光的毒素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/moth
	taste_description = "布料"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/pod
	name = "Podperson Mutation Toxin-植物突变素"
	description = "一种植物性的突变毒素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/pod
	taste_description = "花"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/jelly
	name = "Imperfect Mutation Toxin-不完整突变素"
	description = "一种水母毒素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/jelly
	taste_description = "奶奶的果冻"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/mutationtoxin/jelly/on_mob_life(mob/living/carbon/human/affected_mob, seconds_per_tick, times_fired)
	if(isjellyperson(affected_mob))
		to_chat(affected_mob, span_warning("你的果冻会变形，把你变成另一个亚种!"))
		var/species_type = pick(subtypesof(/datum/species/jelly))
		//affected_mob.set_species(species_type) //ORIGINAL
		affected_mob.set_species(species_type, TRUE, FALSE, null, null, null, null, TRUE, TRUE) //SKYRAT EDIT CHANGE - CUSTOMIZATION
		holder.del_reagent(type)
		return UPDATE_MOB_HEALTH
	if(current_cycle >= CYCLES_TO_TURN) //overwrite since we want subtypes of jelly
		var/datum/species/species_type = pick(subtypesof(race))
		//affected_mob.set_species(species_type) //ORIGINAL
		affected_mob.set_species(species_type, TRUE, FALSE, null, null, null, null, TRUE, TRUE) //SKYRAT EDIT CHANGE - CUSTOMIZATION
		holder.del_reagent(type)
		to_chat(affected_mob, span_warning("你将变成一个[initial(species_type.name)]!"))
		return UPDATE_MOB_HEALTH
	return ..()

/datum/reagent/mutationtoxin/golem
	name = "Golem Mutation Toxin-傀儡突变素"
	description = "与格罗姆这种石傀儡生物有关."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/golem
	taste_description = "岩石"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/abductor
	name = "Abductor Mutation Toxin-外星突变素"
	description = "一种来自外星人的突变素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/abductor
	taste_description = "这个世界之外的东西...不,宇宙!"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/android
	name = "Android Mutation Toxin-机器人突变素"
	description = "机器人的东西."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/android
	taste_description = "电路和钢材"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

//BLACKLISTED RACES
/datum/reagent/mutationtoxin/skeleton
	name = "Skeleton Mutation Toxin-骷髅突变素"
	description = "吓人的毒素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/skeleton
	taste_description = "很多的钙"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/zombie
	name = "Zombie Mutation Toxin-僵尸突变素"
	description = "不死者的突变素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/zombie //Not the infectious kind. The days of xenobio zombie outbreaks are long past.
	taste_description = "脑子..."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/ash
	name = "Ash Mutation Toxin-灰烬突变素"
	description = "满是灰尘的突变素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/lizard/ashwalker
	taste_description = "原始生活"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

//DANGEROUS RACES
/datum/reagent/mutationtoxin/shadow
	name = "Shadow Mutation Toxin-暗影突变素"
	description = "黑色的毒素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/shadow
	taste_description = "黑夜"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/plasma
	name = "Plasma Mutation Toxin-等离子突变素"
	description = "基于等离子的毒素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/plasmaman
	taste_description = "等离子"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

#undef MUT_MSG_IMMEDIATE
#undef MUT_MSG_EXTENDED
#undef MUT_MSG_ABOUT2TURN

#undef CYCLES_TO_TURN
#undef CYCLES_MSG_IMMEDIATE
#undef CYCLES_MSG_EXTENDED

/datum/reagent/mulligan
	name = "Mulligan Toxin-穆里根毒素"
	description = "这种毒素会迅速改变类人生物的DNA。通常由辛迪加间谍和刺客在需要紧急更改身份时使用."
	color = "#5EFF3B" //RGB: 94, 255, 59
	metabolization_rate = INFINITY
	taste_description = "黏糊糊"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/mulligan/on_mob_life(mob/living/carbon/human/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if (!istype(affected_mob))
		return
	to_chat(affected_mob, span_warning("<b>当你的身体迅速变异时，你在痛苦中咬紧牙关!</b>"))
	affected_mob.visible_message("<b>[affected_mob]</b>突然改变!")
	randomize_human(affected_mob)

/datum/reagent/aslimetoxin
	name = "Advanced Mutation Toxin-先进穆里根毒素"
	description = "一种由史莱姆产生的高级变异毒素."
	color = "#13BC5E" // rgb: 19, 188, 94
	taste_description = "史莱姆"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/aslimetoxin/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(methods & ~TOUCH)
		exposed_mob.ForceContractDisease(new /datum/disease/transformation/slime(), FALSE, TRUE)

/datum/reagent/gluttonytoxin
	name = "Gluttony's Blessing-暴食赐福"
	description = "一种由可怕的东西产生的高级腐蚀毒素."
	color = "#5EFF3B" //RGB: 94, 255, 59
	taste_description = "衰变"
	penetrates_skin = NONE

/datum/reagent/gluttonytoxin/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(reac_volume >= 1)//This prevents microdosing from infecting masses of people
		exposed_mob.ForceContractDisease(new /datum/disease/transformation/morph(), FALSE, TRUE)

/datum/reagent/serotrotium
	name = "Serotrotium-植物血清"
	description = "一种促进人体内血清素神经递质集中产生的化合物."
	color = "#202040" // rgb: 20, 20, 40
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "苦"
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/serotrotium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(3.5, seconds_per_tick))
		affected_mob.emote(pick("twitch","drool","moan","gasp"))

/datum/reagent/oxygen
	name = "Oxygen-氧"
	description = "无色无味."
	reagent_state = GAS
	color = COLOR_GRAY
	taste_mult = 0 // oderless and tasteless
	ph = 9.2//It's acutally a huge range and very dependant on the chemistry but ph is basically a made up var in it's implementation anyways
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/oxygen/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(istype(exposed_turf))
		exposed_turf.atmos_spawn_air("[GAS_O2]=[reac_volume/20];[TURF_TEMPERATURE(holder ? holder.chem_temp : T20C)]")
	return

/datum/reagent/copper
	name = "Copper-铜"
	description = "高延展性的金属铜制的东西不是很耐用，但它是一种不错的电线材料."
	reagent_state = SOLID
	color = "#6E3B08" // rgb: 110, 59, 8
	taste_description = "金属"
	ph = 5.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/copper/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(!istype(exposed_obj, /obj/item/stack/sheet/iron))
		return

	var/obj/item/stack/sheet/iron/metal = exposed_obj
	reac_volume = min(reac_volume, metal.amount)
	new/obj/item/stack/sheet/bronze(get_turf(metal), reac_volume)
	metal.use(reac_volume)

/datum/reagent/nitrogen
	name = "Nitrogen-氮"
	description = "无色、无嗅、无味的气体，一种简单的窒息."
	reagent_state = GAS
	color = COLOR_GRAY
	taste_mult = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/nitrogen/expose_turf(turf/open/exposed_turf, reac_volume)
	if(istype(exposed_turf))
		exposed_turf.atmos_spawn_air("[GAS_N2]=[reac_volume/20];[TURF_TEMPERATURE(holder ? holder.chem_temp : T20C)]")
	return ..()

/datum/reagent/hydrogen
	name = "Hydrogen-氢"
	description = "一种无色、无味、非金属、高度可燃的双原子气体."
	reagent_state = GAS
	color = COLOR_GRAY
	taste_mult = 0
	ph = 0.1//Now I'm stuck in a trap of my own design. Maybe I should make -ve phes? (not 0 so I don't get div/0 errors)
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/potassium
	name = "Potassium-钾"
	description = "一种软的、低熔点的固体，易于用刀切割，与水剧烈反应."
	reagent_state = SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160
	taste_description = "甜"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/mercury
	name = "Mercury-汞"
	description = "一种奇怪的金属，在室温下呈液态，对大脑很不好."
	color = COLOR_WEBSAFE_DARK_GRAY // rgb: 72, 72, 72A
	taste_mult = 0 // apparently tasteless.
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/mercury/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_IMMOBILIZED) && isturf(affected_mob.loc) && !isgroundlessturf(affected_mob.loc))
		step(affected_mob, pick(GLOB.cardinals))
	if(SPT_PROB(3.5, seconds_per_tick))
		affected_mob.emote(pick("twitch","drool","moan"))
	if(affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5*seconds_per_tick))
		return UPDATE_MOB_HEALTH

/datum/reagent/sulfur
	name = "Sulfur-硫"
	description = "一种病态的黄色固体，以其难闻的气味而闻名，它实际上在生物化学中比看起来有用得多."
	reagent_state = SOLID
	color = "#BF8C00" // rgb: 191, 140, 0
	taste_description = "臭鸡蛋"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carbon
	name = "Carbon-碳"
	description = "一种易碎的黑色固体，虽然在物理层面上并不令人兴奋，但却构成了所有已知生命的基础，这是件大事."
	reagent_state = SOLID
	color = "#1C1300" // rgb: 30, 20, 0
	taste_description = "酸的粉笔"
	ph = 5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carbon/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(isspaceturf(exposed_turf))
		return

	exposed_turf.spawn_unique_cleanable(/obj/effect/decal/cleanable/dirt)

/datum/reagent/chlorine
	name = "Chlorine-氯"
	description = "一种淡黄色的气体，被称为氧化剂，虽然它在基本形态下形成了许多无害的分子，但它自己远非无害."
	reagent_state = GAS
	color = "#FFFB89" //pale yellow? let's make it light gray
	taste_description = "氯"
	ph = 7.4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


// You're an idiot for thinking that one of the most corrosive and deadly gasses would be beneficial
/datum/reagent/chlorine/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume))
	mytray.adjust_toxic(round(volume * 1.5))
	mytray.adjust_waterlevel(-round(volume * 0.5))
	mytray.adjust_weedlevel(-rand(1, 3))
	// White Phosphorous + water -> phosphoric acid. That's not a good thing really.


/datum/reagent/chlorine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.take_bodypart_damage(0.5*REM*seconds_per_tick, 0))
		return UPDATE_MOB_HEALTH

/datum/reagent/fluorine
	name = "Fluorine-氟"
	description = "一种滑稽的反应性化学元素，宇宙根本不希望这些物质以这种形式存在."
	reagent_state = GAS
	color = COLOR_GRAY
	taste_description = "酸"
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// You're an idiot for thinking that one of the most corrosive and deadly gasses would be beneficial
/datum/reagent/fluorine/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume * 2))
	mytray.adjust_toxic(round(volume * 2.5))
	mytray.adjust_waterlevel(-round(volume * 0.5))
	mytray.adjust_weedlevel(-rand(1, 4))

/datum/reagent/fluorine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustToxLoss(0.5*REM*seconds_per_tick, updating_health = FALSE))
		return UPDATE_MOB_HEALTH

/datum/reagent/sodium
	name = "Sodium-钠"
	description = "一种柔软的银色金属，很容易用刀切割，它不是盐，所以不要把它放在薯片上."
	reagent_state = SOLID
	color = COLOR_GRAY
	taste_description = "咸的金属"
	ph = 11.6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/phosphorus
	name = "Phosphorus-磷"
	description = "一种易于燃烧的红色粉末，虽然它有很多颜色，但总的主题总是一样的."
	reagent_state = SOLID
	color = "#832828" // rgb: 131, 40, 40
	taste_description = "醋"
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// Phosphoric salts are beneficial though. And even if the plant suffers, in the long run the tray gets some nutrients. The benefit isn't worth that much.
/datum/reagent/phosphorus/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume * 0.75))
	mytray.adjust_waterlevel(-round(volume * 0.5))
	mytray.adjust_weedlevel(-rand(1, 2))

/datum/reagent/lithium
	name = "Lithium-锂"
	description = "它是一种银色金属，因其极低的密度而闻名，用它让自己平静下来有点太有效了."
	reagent_state = SOLID
	color = COLOR_GRAY
	taste_description = "金属"
	ph = 11.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/lithium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!HAS_TRAIT(affected_mob, TRAIT_IMMOBILIZED) && isturf(affected_mob.loc) && !isgroundlessturf(affected_mob.loc))
		step(affected_mob, pick(GLOB.cardinals))
	if(SPT_PROB(2.5, seconds_per_tick))
		affected_mob.emote(pick("twitch","drool","moan"))

/datum/reagent/glycerol
	name = "Glycerol-甘油"
	description = "甘油是一种简单的多元醇化合物，甘油味甜，毒性低."
	color = "#D3B913"
	taste_description = "甜"
	ph = 9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/space_cleaner/sterilizine
	name = "Sterilizine-灭菌嗪"
	description = "为手术前的伤口消毒."
	color = "#D0EFEE" // space cleaner but lighter
	taste_description = "苦"
	ph = 10.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_AFFECTS_WOUNDS

/datum/reagent/space_cleaner/sterilizine/expose_mob(mob/living/carbon/exposed_carbon, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & (TOUCH|VAPOR|PATCH)))
		return

	for(var/datum/surgery/surgery as anything in exposed_carbon.surgeries)
		surgery.speed_modifier = max(0.2, surgery.speed_modifier)

/datum/reagent/space_cleaner/sterilizine/on_burn_wound_processing(datum/wound/burn/flesh/burn_wound)
	burn_wound.sanitization += 0.9

/datum/reagent/iron
	name = "Iron-铁"
	description = "铁铁铁."
	reagent_state = SOLID
	taste_description = "iron"
	material = /datum/material/iron
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	color = "#606060" //pure iron? let's make it violet of course
	ph = 6

/datum/reagent/iron/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.blood_volume < BLOOD_VOLUME_NORMAL)
		affected_mob.blood_volume += 0.25 * seconds_per_tick

/datum/reagent/gold
	name = "Gold-金"
	description = "黄金是一种致密、柔软、有光泽的金属，是已知的最具延展性和延展性的金属."
	reagent_state = SOLID
	color = "#F7C430" // rgb: 247, 196, 48
	taste_description = "昂贵的金属"
	material = /datum/material/gold
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/silver
	name = "Silver-银"
	description = "它是一种柔软、白色、有光泽的过渡金属，具有所有元素中最高的导电性和所有金属中最高的导热性."
	reagent_state = SOLID
	color = "#D0D0D0" // rgb: 208, 208, 208
	taste_description = "昂贵但合理的金属"
	material = /datum/material/silver
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/uranium
	name = "Uranium-铀"
	description = "锕系中的一种玉绿色金属化学元素，弱放射性."
	reagent_state = SOLID
	color = "#5E9964" //this used to be silver, but liquid uranium can still be green and it's more easily noticeable as uranium like this so why bother?
	taste_description = "反应堆核心"
	ph = 4
	material = /datum/material/uranium
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/effect/decal/cleanable/greenglow
	/// How much tox damage to deal per tick
	var/tox_damage = 0.5

/datum/reagent/uranium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustToxLoss(tox_damage * seconds_per_tick * REM, updating_health = FALSE))
		return UPDATE_MOB_HEALTH

/datum/reagent/uranium/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if((reac_volume < 3) || isspaceturf(exposed_turf))
		return

	var/obj/effect/decal/cleanable/greenglow/glow = exposed_turf.spawn_unique_cleanable(/obj/effect/decal/cleanable/greenglow)
	if(!QDELETED(glow))
		glow.reagents.add_reagent(type, reac_volume)

//Mutagenic chem side-effects.
/datum/reagent/uranium/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.mutation_roll(user)
	mytray.adjust_plant_health(-round(volume))
	mytray.adjust_toxic(round(volume / tox_damage)) // more damage = more

/datum/reagent/uranium/radium
	name = "Radium-镭"
	description = "镭是一种碱土金属，它具有极强的放射性."
	reagent_state = SOLID
	color = "#00CC00" // ditto
	taste_description = "蓝色和遗憾"
	tox_damage = 1
	material = null
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/bluespace
	name = "Bluespace Dust-蓝空尘"
	description = "一种由微小的蓝色空间晶体组成的尘埃，具有轻微的空间扭曲特性."
	reagent_state = SOLID
	color = "#0000CC"
	taste_description = "fizzling blue"
	material = /datum/material/bluespace
	ph = 12
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/bluespace/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		do_teleport(exposed_mob, get_turf(exposed_mob), (reac_volume / 5), asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE) //4 tiles per crystal

/datum/reagent/bluespace/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 10 && SPT_PROB(7.5, seconds_per_tick))
		to_chat(affected_mob, span_warning("你感觉不稳定..."))
		affected_mob.set_jitter_if_lower(2 SECONDS)
		current_cycle = 1
		addtimer(CALLBACK(affected_mob, TYPE_PROC_REF(/mob/living, bluespace_shuffle)), 3 SECONDS)

/mob/living/proc/bluespace_shuffle()
	do_teleport(src, get_turf(src), 5, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)

/datum/reagent/aluminium
	name = "Aluminium-铝"
	description = "化学元素中硼族的一种银白色的延展性成员."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	taste_description = "metal"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/silicon
	name = "Silicon-硅"
	description = "硅是一种四价类材料，它的反应性比它的化学类似物碳要低."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	taste_mult = 0
	material = /datum/material/glass
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/fuel
	name = "Welding Fuel-焊料"
	description = "焊工必备，易燃."
	color = "#660000" // rgb: 102, 0, 0
	taste_description = "总金属"
	penetrates_skin = NONE
	ph = 4
	burning_temperature = 1725 //more refined than oil
	burning_volume = 0.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/alcohol = 4)

/datum/glass_style/drinking_glass/fuel
	required_drink_type = /datum/reagent/fuel
	name = "glass of welder fuel-焊料"
	desc = "除非你是工业工具，否则喝下去可能不安全."
	icon_state = "dr_gibb_glass"

/datum/reagent/fuel/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with welding fuel to make them easy to ignite!
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.adjust_fire_stacks(reac_volume / 10)

/datum/reagent/fuel/on_mob_life(mob/living/carbon/victim, seconds_per_tick, times_fired)
	. = ..()
	var/obj/item/organ/internal/liver/liver = victim.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_HUMAN_AI_METABOLISM))
		return
	if(victim.adjustToxLoss(0.5 * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/fuel/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()

	if(!istype(exposed_turf) || isspaceturf(exposed_turf))
		return

	if((reac_volume < 5))
		return

	var/obj/effect/decal/cleanable/fuel_pool/pool = exposed_turf.spawn_unique_cleanable(/obj/effect/decal/cleanable/fuel_pool)
	if(pool)
		pool.burn_amount = max(min(round(reac_volume / 5), 10), 1)

/datum/reagent/space_cleaner
	name = "Space Cleaner-太空清洁剂"
	description = "用来清洁东西的化合物。现在加了50%的次氯酸钠!可以用来清洗伤口，但效果可能不是很好."
	color = "#A5F0EE" // rgb: 165, 240, 238
	taste_description = "酸"
	reagent_weight = 0.6 //so it sprays further
	penetrates_skin = VAPOR
	var/clean_types = CLEAN_WASH
	ph = 5.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_CLEANS|REAGENT_AFFECTS_WOUNDS

/datum/reagent/space_cleaner/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	exposed_obj?.wash(clean_types)

/datum/reagent/space_cleaner/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(reac_volume < 1)
		return

	exposed_turf.wash(clean_types)
	for(var/am in exposed_turf)
		var/atom/movable/movable_content = am
		if(ismopable(movable_content)) // Mopables will be cleaned anyways by the turf wash
			continue
		movable_content.wash(clean_types)

	for(var/mob/living/basic/slime/exposed_slime in exposed_turf)
		exposed_slime.adjustToxLoss(rand(5,10))

/datum/reagent/space_cleaner/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.wash(clean_types)

/datum/reagent/space_cleaner/on_burn_wound_processing(datum/wound/burn/flesh/burn_wound)
	burn_wound.sanitization += 0.3
	if(prob(5))
		to_chat(burn_wound.victim, span_notice("你的[burn_wound]感受到由[src]产生的刺痛! 但伤口看起来真的很干净."))
		burn_wound.victim.adjustToxLoss(0.5)
		burn_wound.limb.receive_damage(burn = 0.5, wound_bonus = CANT_WOUND)

/datum/reagent/space_cleaner/ez_clean
	name = "EZ Clean-EZ清洁剂"
	description = "华夫饼公司出售的一种强力酸性清洁剂，能清除有机物质的同时不影响其他物体."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "酸"
	penetrates_skin = VAPOR
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/space_cleaner/ez_clean/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjustBruteLoss(1.665*seconds_per_tick, updating_health = FALSE)
	need_mob_update += affected_mob.adjustFireLoss(1.665*seconds_per_tick, updating_health = FALSE)
	need_mob_update += affected_mob.adjustToxLoss(1.665*seconds_per_tick, updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/space_cleaner/ez_clean/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if((methods & (TOUCH|VAPOR)) && !issilicon(exposed_mob))
		exposed_mob.adjustBruteLoss(1.5)
		exposed_mob.adjustFireLoss(1.5)

/datum/reagent/cryptobiolin
	name = "Cryptobiolin-隐生物素"
	description = "隐生物素会引起混乱和头晕."
	color = "#ADB5DB" //i hate default violets and 'crypto' keeps making me think of cryo so it's light blue now
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "酸"
	ph = 11.9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/cryptobiolin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.set_dizzy_if_lower(2 SECONDS)

	// Cryptobiolin adjusts the mob's confusion down to 20 seconds if it's higher,
	// or up to 1 second if it's lower, but will do nothing if it's in between
	var/confusion_left = affected_mob.get_timed_status_effect_duration(/datum/status_effect/confusion)
	if(confusion_left < 1 SECONDS)
		affected_mob.set_confusion(1 SECONDS)

	else if(confusion_left > 20 SECONDS)
		affected_mob.set_confusion(20 SECONDS)

/datum/reagent/impedrezene
	name = "Impedrezene-因丙烯"
	description = "因丙烯是一种麻醉剂，通过减缓高级脑细胞的功能来阻碍人的能力."
	color = "#E07DDD" // pink = happy = dumb
	taste_description = "麻痹"
	ph = 9.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/opioids = 10)

/datum/reagent/impedrezene/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_jitter(-5 SECONDS * seconds_per_tick)
	if(SPT_PROB(55, seconds_per_tick))
		affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2)
		. = TRUE
	if(SPT_PROB(30, seconds_per_tick))
		affected_mob.adjust_drowsiness(6 SECONDS)
	if(SPT_PROB(5, seconds_per_tick))
		affected_mob.emote("drool")

/datum/reagent/cyborg_mutation_nanomachines
	name = "Nanomachines-纳米机械"
	description = "微型的构筑机器人，纳米机器，孩子!"
	color = "#535E66" // rgb: 83, 94, 102
	taste_description = "烂泥"
	penetrates_skin = NONE

/datum/reagent/cyborg_mutation_nanomachines/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	var/obj/item/organ/internal/liver/liver = exposed_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_HUMAN_AI_METABOLISM))
		return
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*(1 - touch_protection))))
		exposed_mob.ForceContractDisease(new /datum/disease/transformation/robot(), FALSE, TRUE)

/datum/reagent/xenomicrobes
	name = "Xenomicrobes-异形微生物"
	description = "具有完全陌生的细胞结构的微生物."
	color = "#535E66" // rgb: 83, 94, 102
	taste_description = "烂泥"
	penetrates_skin = NONE

/datum/reagent/xenomicrobes/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*(1 - touch_protection))))
		exposed_mob.ForceContractDisease(new /datum/disease/transformation/xeno(), FALSE, TRUE)

/datum/reagent/fungalspores
	name = "Tubercle Bacillus Cosmosis Microbes-结核杆菌宇宙微生物"
	description = "活跃的真菌孢子."
	color = "#92D17D" // rgb: 146, 209, 125
	taste_description = "黏糊糊"
	penetrates_skin = NONE
	ph = 11

/datum/reagent/fungalspores/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*(1 - touch_protection))))
		exposed_mob.ForceContractDisease(new /datum/disease/tuberculosis(), FALSE, TRUE)

/datum/reagent/snail
	name = "Agent-S"
	description = "使受试者感染胃病的病毒学制剂."
	color = COLOR_VERY_DARK_LIME_GREEN // rgb(0, 51, 0)
	taste_description = "粘性物"
	penetrates_skin = NONE
	ph = 11

/datum/reagent/snail/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*(1 - touch_protection))))
		exposed_mob.ForceContractDisease(new /datum/disease/gastrolosis(), FALSE, TRUE)

/datum/reagent/fluorosurfactant//foam precursor
	name = "Fluorosurfactant-含氟表面活性剂"
	description = "一种全氟磺酸，与水混合后形成泡沫."
	color = "#9E6B38" // rgb: 158, 107, 56
	taste_description = "金属"
	ph = 11
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/foaming_agent// Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming Agent-泡沫剂"
	description = "一种与轻金属和强酸混合后产生金属泡沫的物质."
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	taste_description = "金属"
	ph = 11.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/smart_foaming_agent //Smart foaming agent. Functions similarly to metal foam, but conforms to walls.
	name = "Smart Foaming Agent-智能泡沫剂"
	description = "一种与轻金属和强酸混合后产生符合区域边界的金属泡沫的药剂."
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	taste_description = "金属"
	ph = 11.8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/ammonia
	name = "Ammonia-氨"
	description = "一种腐蚀性物质，通常用于肥料或家用清洁剂中."
	reagent_state = GAS
	color = "#404030" // rgb: 64, 64, 48
	taste_description = "有腐蚀性的"
	ph = 11.6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/ammonia/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	// Ammonia is bad ass.
	mytray.adjust_plant_health(round(volume * 0.12))

	var/obj/item/seeds/myseed = mytray.myseed
	if(!isnull(myseed) && prob(10))
		myseed.adjust_yield(1)
		myseed.adjust_instability(1)

/datum/reagent/diethylamine
	name = "Diethylamine-二乙胺"
	description = "一种仲胺，有轻微腐蚀性."
	color = "#604030" // rgb: 96, 64, 48
	taste_description = "iron"
	ph = 12
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// This is more bad ass, and pests get hurt by the corrosive nature of it, not the plant. The new trade off is it culls stability.
/datum/reagent/diethylamine/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(round(volume))
	mytray.adjust_pestlevel(-rand(1,2))
	var/obj/item/seeds/myseed = mytray.myseed
	if(!isnull(myseed))
		myseed.adjust_yield(round(volume))
		myseed.adjust_instability(-round(volume))

/datum/reagent/carbondioxide
	name = "Carbon Dioxide-二氧化碳"
	reagent_state = GAS
	description = "通常由燃烧碳燃料产生的气体，你的肺部会不断产生这种物质."
	color = "#B0B0B0" // rgb : 192, 192, 192
	taste_description = "不可知"
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carbondioxide/expose_turf(turf/open/exposed_turf, reac_volume)
	if(istype(exposed_turf))
		exposed_turf.atmos_spawn_air("[GAS_CO2]=[reac_volume/20];[TURF_TEMPERATURE(holder ? holder.chem_temp : T20C)]")
	return ..()

/datum/reagent/nitrous_oxide
	name = "Nitrous Oxide-一氧化二氮"
	description = "一种强效氧化剂，用作火箭燃料和外科手术中的麻醉剂. \
		由于它是一种抗凝剂，最好与桑吉里特一起使用，以使血液继续凝固."
	reagent_state = LIQUID
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	color = COLOR_GRAY
	taste_description = "甜"
	ph = 5.8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/nitrous_oxide/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(istype(exposed_turf))
		exposed_turf.atmos_spawn_air("[GAS_N2O]=[reac_volume/20];[TURF_TEMPERATURE(holder ? holder.chem_temp : T20C)]")

/datum/reagent/nitrous_oxide/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(methods & VAPOR)
		// apply 2 seconds of drowsiness per unit applied, with a min duration of 4 seconds
		var/drowsiness_to_apply = max(round(reac_volume, 1) * 2 SECONDS, 4 SECONDS)
		exposed_mob.adjust_drowsiness(drowsiness_to_apply)

/datum/reagent/nitrous_oxide/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if(!HAS_TRAIT(affected_mob, TRAIT_COAGULATING)) //IF the mob does not have a coagulant in them, we add the blood mess trait to make the bleed quicker
		ADD_TRAIT(affected_mob, TRAIT_BLOODY_MESS, type)

/datum/reagent/nitrous_oxide/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_BLOODY_MESS, type)

/datum/reagent/nitrous_oxide/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_drowsiness(4 SECONDS * REM * seconds_per_tick)

	if(!HAS_TRAIT(affected_mob, TRAIT_BLOODY_MESS) && !HAS_TRAIT(affected_mob, TRAIT_COAGULATING)) //So long as they do not have a coagulant, if they did not have the bloody mess trait, they do now
		ADD_TRAIT(affected_mob, TRAIT_BLOODY_MESS, type)

	else if(HAS_TRAIT(affected_mob, TRAIT_COAGULATING)) //if we find they now have a coagulant, we remove the trait
		REMOVE_TRAIT(affected_mob, TRAIT_BLOODY_MESS, type)

	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.losebreath += 2
		affected_mob.adjust_confusion_up_to(2 SECONDS, 5 SECONDS)

/////////////////////////Colorful Powder////////////////////////////
//For colouring in /proc/mix_color_from_reagents

/datum/reagent/colorful_reagent/powder
	name = "Mundane Powder-染色粉" //the name's a bit similar to the name of colorful reagent, but hey, they're practically the same chem anyway
	var/colorname = "none"
	description = "用来给东西上色的粉末."
	reagent_state = SOLID
	color = COLOR_WHITE
	taste_description = "教室后面"

/datum/reagent/colorful_reagent/powder/New()
	if(colorname == "none")
		description = "一种看起来很普通的粉末，它看起来不会给任何东西上色..."
	else if(colorname == "invisible")
		description = "看不见的粉末，不幸的是，由于它是看不见的，它看起来不像会给任何东西上色..."
	else
		description = "[colorname]色粉, 用来给东西涂上[colorname]色."
	return ..()

/datum/reagent/colorful_reagent/powder/red
	name = "Red Powder-红染色粉"
	colorname = "红"
	color = COLOR_CRAYON_RED
	random_color_list = list("#FC7474")
	ph = 0.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/orange
	name = "Orange Powder-橙染色粉"
	colorname = "橙"
	color = COLOR_CRAYON_ORANGE
	random_color_list = list(COLOR_CRAYON_ORANGE)
	ph = 2

/datum/reagent/colorful_reagent/powder/yellow
	name = "Yellow Powder-黄染色粉"
	colorname = "黄"
	color = COLOR_CRAYON_YELLOW
	random_color_list = list(COLOR_CRAYON_YELLOW)
	ph = 5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/green
	name = "Green Powder-绿染色粉"
	colorname = "绿"
	color = COLOR_CRAYON_GREEN
	random_color_list = list(COLOR_CRAYON_GREEN)
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/blue
	name = "Blue Powder-蓝染色粉"
	colorname = "蓝"
	color = COLOR_CRAYON_BLUE
	random_color_list = list("#71CAE5")
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/purple
	name = "Purple Powder-紫染色粉"
	colorname = "紫"
	color = COLOR_CRAYON_PURPLE
	random_color_list = list("#BD8FC4")
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/invisible
	name = "Invisible Powder-不可见粉"
	colorname = "不可见"
	color = "#FFFFFF00" // white + no alpha
	random_color_list = list(COLOR_WHITE) //because using the powder color turns things invisible
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/black
	name = "Black Powder-黑染色粉"
	colorname = "黑"
	color = COLOR_CRAYON_BLACK
	random_color_list = list("#8D8D8D") //more grey than black, not enough to hide your true colors
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/white
	name = "White Powder-白染色粉"
	colorname = "白"
	color = COLOR_WHITE
	random_color_list = list(COLOR_WHITE) //doesn't actually change appearance at all
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/* used by crayons, can't color living things but still used for stuff like food recipes */

/datum/reagent/colorful_reagent/powder/red/crayon
	name = "Red Crayon Powder-红色蜡笔粉"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/orange/crayon
	name = "Orange Crayon Powder-橙色蜡笔粉"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/yellow/crayon
	name = "Yellow Crayon Powder-黄色蜡笔粉"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/green/crayon
	name = "Green Crayon Powder-绿色蜡笔粉"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/blue/crayon
	name = "Blue Crayon Powder-蓝色蜡笔粉"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/purple/crayon
	name = "Purple Crayon Powder-紫色蜡笔粉"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//datum/reagent/colorful_reagent/powder/invisible/crayon

/datum/reagent/colorful_reagent/powder/black/crayon
	name = "Black Crayon Powder-黑色蜡笔粉"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent/powder/white/crayon
	name = "White Crayon Powder-白色蜡笔粉"
	can_colour_mobs = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//////////////////////////////////Hydroponics stuff///////////////////////////////

/datum/reagent/plantnutriment
	name = "Generic Nutriment"
	description = "Some kind of nutriment. You can't really tell what it is. You should probably report it, along with how you obtained it."
	color = COLOR_BLACK // RBG: 0, 0, 0
	var/tox_prob = 0
	taste_description = "plant food"
	ph = 3

/datum/reagent/plantnutriment/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(tox_prob, seconds_per_tick))
		if(affected_mob.adjustToxLoss(1, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/plantnutriment/eznutriment
	name = "E-Z Nutrient-简单肥"
	description = "包含电解质，这是植物所渴望的."
	color = "#376400" // RBG: 50, 100, 0
	tox_prob = 5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plantnutriment/eznutriment/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	var/obj/item/seeds/myseed = mytray.myseed
	if(!isnull(myseed))
		myseed.adjust_instability(0.2)
		myseed.adjust_potency(round(volume * 0.3))
		myseed.adjust_yield(round(volume * 0.1))

/datum/reagent/plantnutriment/left4zednutriment
	name = "Left 4 Zed-突变肥"
	description = "不稳定的营养使植物比平常更容易变异."
	color = "#1A1E4D" // RBG: 26, 30, 77
	tox_prob = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plantnutriment/left4zednutriment/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)

	mytray.adjust_plant_health(round(volume * 0.1))
	mytray.myseed?.adjust_instability(round(volume * 0.2))

/datum/reagent/plantnutriment/robustharvestnutriment
	name = "Robust Harvest-丰收肥"
	description = "这是一种非常有效的营养物质，可以减缓植物的变异."
	color = "#9D9D00" // RBG: 157, 157, 0
	tox_prob = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plantnutriment/robustharvestnutriment/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	var/obj/item/seeds/myseed = mytray.myseed
	if(!isnull(myseed))
		myseed.adjust_instability(-0.25)
		myseed.adjust_potency(round(volume * 0.1))
		myseed.adjust_yield(round(volume * 0.2))

/datum/reagent/plantnutriment/endurogrow
	name = "Enduro Grow-长得好"
	description = "一种特殊的营养物，减少果实的数量和质量，但可以增强植物的耐受力."
	color = "#a06fa7" // RBG: 160, 111, 167
	tox_prob = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plantnutriment/endurogrow/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	var/obj/item/seeds/myseed = mytray.myseed
	if(!isnull(myseed))
		myseed.adjust_potency(-round(volume * 0.1))
		myseed.adjust_yield(-round(volume * 0.075))
		myseed.adjust_endurance(round(volume * 0.35))

/datum/reagent/plantnutriment/liquidearthquake
	name = "Liquid Earthquake-很会长"
	description = "一种特殊的营养物，可以提高植物的生产速度，同时也可以降低杂草的生长率."
	color = "#912e00" // RBG: 145, 46, 0
	tox_prob = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plantnutriment/liquidearthquake/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)

	var/obj/item/seeds/myseed = mytray.myseed
	if(!isnull(myseed))
		myseed.adjust_weed_rate(round(volume * 0.1))
		myseed.adjust_weed_chance(round(volume * 0.3))
		myseed.adjust_production(-round(volume * 0.075))

// GOON OTHERS



/datum/reagent/fuel/oil
	name = "Oil-油"
	description = "可以用来获得灰烬."
	reagent_state = LIQUID
	color = "#2D2D2D"
	taste_description = "油"
	burning_temperature = 1200//Oil is crude
	burning_volume = 0.05 //but has a lot of hydrocarbons
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = null
	default_container = /obj/effect/decal/cleanable/oil

/datum/reagent/stable_plasma
	name = "Stable Plasma-稳态等离子"
	description = "等离子体被锁定为液体形式，不能点燃或变成气体/固体."
	reagent_state = LIQUID
	color = "#2D2D2D"
	taste_description = "苦"
	taste_mult = 1.5
	ph = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/stable_plasma/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjustPlasma(10 * REM * seconds_per_tick)

/datum/reagent/iodine
	name = "Iodine-碘"
	description = "通常作为营养物添加到食盐中，它本身的味道就不那么令人愉快了."
	reagent_state = LIQUID
	color = "#BC8A00"
	taste_description = "金属"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet
	name = "Carpet-地毯"
	description = "对于那些需要更有创意的方式来铺红地毯的人."
	reagent_state = LIQUID
	color = "#771100"
	taste_description = "地毯" // Your tounge feels furry.
	var/carpet_type = /turf/open/floor/carpet
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/expose_turf(turf/exposed_turf, reac_volume)
	if(isopenturf(exposed_turf) && exposed_turf.turf_flags & IS_SOLID && !istype(exposed_turf, /turf/open/floor/carpet))
		exposed_turf.place_on_top(carpet_type, flags = CHANGETURF_INHERIT_AIR)
	..()

/datum/reagent/carpet/black
	name = "Black Carpet-黑色地毯"
	description = "地毯也是黑的." //yes, the typo is intentional
	color = "#1E1E1E"
	taste_description = "甘草"
	carpet_type = /turf/open/floor/carpet/black
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/blue
	name = "Blue Carpet-蓝色地毯"
	description = "对于那些真的需要冷静一下的人."
	color = "#0000DC"
	taste_description = "冰冷的地毯"
	carpet_type = /turf/open/floor/carpet/blue
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/cyan
	name = "Cyan Carpet-青色地毯"
	description = "对于那些想要回到用毒药做建筑材料的年代的人，闻起来像石棉."
	color = "#00B4FF"
	taste_description = "石棉"
	carpet_type = /turf/open/floor/carpet/cyan
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/green
	name = "Green Carpet-绿色地毯"
	description = "对于那些绿鸡蛋和火腿."
	color = COLOR_CRAYON_GREEN
	taste_description = "绿色" //the caps is intentional
	carpet_type = /turf/open/floor/carpet/green
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/orange
	name = "Orange Carpet-橙色地毯"
	description = "对于那些喜欢健康的地毯，以配合他们的健康饮食的人."
	color = "#E78108"
	taste_description = "橙汁"
	carpet_type = /turf/open/floor/carpet/orange
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/purple
	name = "Purple Carpet-紫色地毯"
	description = "对于那些需要浪费大量的再生胶只是为了看起来更漂亮的人."
	color = "#91D865"
	taste_description = "果冻"
	carpet_type = /turf/open/floor/carpet/purple
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/red
	name = "Red Carpet-红色地毯"
	description = "对于那些需要更红地毯的人."
	color = "#731008"
	taste_description = "血红"
	carpet_type = /turf/open/floor/carpet/red
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/royal
	name = "Royal Carpet?"
	description = "For those that break the game and need to make an issue report."

/datum/reagent/carpet/royal/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/obj/item/organ/internal/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver)
		// Heads of staff and the captain have a "royal metabolism"
		if(HAS_TRAIT(liver, TRAIT_ROYAL_METABOLISM))
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, "你觉得自己是皇族.")
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.say(pick("平民..","这地毯比你的合同还值钱!","我随时都可以解雇你..."), forced = "royal carpet")

		// The quartermaster, as a semi-head, has a "pretender royal" metabolism
		else if(HAS_TRAIT(liver, TRAIT_PRETENDER_ROYAL_METABOLISM))
			if(SPT_PROB(8, seconds_per_tick))
				to_chat(affected_mob, "你觉得自己像个骗子...")

/datum/reagent/carpet/royal/black
	name = "Royal Black Carpet-黑色皇家地毯"
	description = "对于那些觉得有必要炫耀自己浪费时间的人."
	color = COLOR_BLACK
	taste_description = "皇家"
	carpet_type = /turf/open/floor/carpet/royalblack
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/royal/blue
	name = "Royal Blue Carpet-蓝色皇家地毯"
	description = "对于那些觉得有必要炫耀自己浪费时间的技能的人."
	color = "#5A64C8"
	taste_description = "皇家蓝" //also intentional
	carpet_type = /turf/open/floor/carpet/royalblue
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/neon
	name = "Neon Carpet-霓虹地毯"
	description = "对于那些喜欢80年代的人."
	color = COLOR_ALMOST_BLACK
	taste_description = "霓虹灯"
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon

/datum/reagent/carpet/neon/simple_white
	name = "Simple White Neon Carpet-单调白色霓虹地毯"
	description = "适合那些喜欢荧光灯的人."
	color = LIGHT_COLOR_HALOGEN
	taste_description = "钠蒸汽"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/white

/datum/reagent/carpet/neon/simple_red
	name = "Simple Red Neon Carpet-单调红色霓虹地毯"
	description = "对于那些喜欢不确定性的人来说."
	color = COLOR_RED
	taste_description = "霓虹灯幻觉"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/red

/datum/reagent/carpet/neon/simple_orange
	name = "Simple Orange Neon Carpet-单调橙色霓虹地毯"
	description = "适合那些喜欢锋利边缘的人."
	color = COLOR_ORANGE
	taste_description = "刺眼的霓虹"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/orange

/datum/reagent/carpet/neon/simple_yellow
	name = "Simple Yellow Neon Carpet-单调黄色霓虹地毯"
	description = "对于那些需要稳定生活的人来说."
	color = COLOR_YELLOW
	taste_description = "稳定的霓虹灯"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/yellow

/datum/reagent/carpet/neon/simple_lime
	name = "Simple Lime Neon Carpet-单调黄绿色霓虹地毯"
	description = "给那些需要一点苦涩的人."
	color = COLOR_LIME
	taste_description = "霓虹灯柑橘"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/lime

/datum/reagent/carpet/neon/simple_green
	name = "Simple Green Neon Carpet-单调绿色霓虹地毯"
	description = "给那些需要改变生活的人."
	color = COLOR_GREEN
	taste_description = "镭"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/green

/datum/reagent/carpet/neon/simple_teal
	name = "Simple Teal Neon Carpet-单调蓝绿色霓虹地毯"
	description = "给那些需要抽烟的人."
	color = COLOR_TEAL
	taste_description = "霓虹灯烟草"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/teal

/datum/reagent/carpet/neon/simple_cyan
	name = "Simple Cyan Neon Carpet-单调青色霓虹地毯"
	description = "给那些需要喘口气的人."
	color = COLOR_DARK_CYAN
	taste_description = "霓虹空气"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/cyan

/datum/reagent/carpet/neon/simple_blue
	name = "Simple Blue Neon Carpet-单调蓝色霓虹地毯"
	description = "对于那些需要再次感受到快乐的人."
	color = COLOR_NAVY
	taste_description = "蓝色霓虹"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/blue

/datum/reagent/carpet/neon/simple_purple
	name = "Simple Purple Neon Carpet-单调紫色霓虹地毯"
	description = "对于那些需要一点点探索的人."
	color = COLOR_PURPLE
	taste_description = "霓虹地狱"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/purple

/datum/reagent/carpet/neon/simple_violet
	name = "Simple Violet Neon Carpet-单调深紫色霓虹地毯"
	description = "对于那些想要临时安排命运的人."
	color = COLOR_VIOLET
	taste_description = "霓虹地狱"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/violet

/datum/reagent/carpet/neon/simple_pink
	name = "Simple Pink Neon Carpet-单调粉色霓虹地毯"
	description = "对于那些只想停止思考的人."
	color = COLOR_PINK
	taste_description = "粉色霓虹"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/pink

/datum/reagent/carpet/neon/simple_black
	name = "Simple Black Neon Carpet-单调黑色霓虹地毯"
	description = "给那些需要喘口气的人."
	color = COLOR_BLACK
	taste_description = "霓虹灰烬"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/black

/datum/reagent/bromine
	name = "Bromine-溴"
	description = "一种高度活泼的棕色液体，对阻止自由基有用，但不适合人类食用."
	reagent_state = LIQUID
	color = "#D35415"
	taste_description = "化学物质"
	ph = 7.8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/pentaerythritol
	name = "Pentaerythritol-季戊四醇"
	description = "慢点，又不是打字比赛!"
	reagent_state = SOLID
	color = "#E66FFF"
	taste_description = "酸"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/acetaldehyde
	name = "Acetaldehyde-乙醛"
	description = "类似于塑料，尝起来像死人."
	reagent_state = SOLID
	color = "#EEEEEF"
	taste_description = "死人" //made from formaldehyde, ya get da joke ?
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/acetone_oxide
	name = "Acetone Oxide-丙酮氧化"
	description = "被奴役的氧气"
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "酸"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/acetone_oxide/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people kills people!
	. = ..()
	if(methods & TOUCH)
		exposed_mob.adjustFireLoss(2)
		exposed_mob.adjust_fire_stacks((reac_volume / 10))

/datum/reagent/phenol
	name = "Phenol-苯酚"
	description = "带有羟基的碳的芳香环，它是一些药物的有用前体，但本身没有治疗作用."
	reagent_state = LIQUID
	color = "#E7EA91"
	taste_description = "酸"
	ph = 5.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/ash
	name = "Ash-灰"
	description = "据说不死鸟从里升起，但你从来没见过."
	reagent_state = LIQUID
	color = "#515151"
	taste_description = "灰"
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/effect/decal/cleanable/ash

// Ash is also used IRL in gardening, as a fertilizer enhancer and weed killer
/datum/reagent/ash/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(round(volume))
	mytray.adjust_weedlevel(-1)

/datum/reagent/acetone
	name = "Acetone-丙酮"
	description = "一种光滑的、略微致癌的液体，在日常生活中有许多平凡的用途."
	reagent_state = LIQUID
	color = "#AF14B7"
	taste_description = "酸"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/colorful_reagent
	name = "Colorful Reagent-彩色试剂"
	description = "彻底取样彩虹."
	reagent_state = LIQUID
	var/list/random_color_list = list("#00aedb","#a200ff","#f47835","#d41243","#d11141","#00b159","#00aedb","#f37735","#ffc425","#008744","#0057e7","#d62d20","#ffa700")
	color = "#C8A5DC"
	taste_description = "彩虹"
	var/can_colour_mobs = TRUE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/datum/callback/color_callback

/datum/reagent/colorful_reagent/New()
	color_callback = CALLBACK(src, PROC_REF(UpdateColor))
	SSticker.OnRoundstart(color_callback)
	return ..()

/datum/reagent/colorful_reagent/Destroy()
	LAZYREMOVE(SSticker.round_end_events, color_callback) //Prevents harddels during roundstart
	color_callback = null //Fly free little callback
	return ..()

/datum/reagent/colorful_reagent/proc/UpdateColor()
	color_callback = null
	color = pick(random_color_list)

/datum/reagent/colorful_reagent/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(can_colour_mobs)
		affected_mob.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)

/// Colors anything it touches a random color.
/datum/reagent/colorful_reagent/expose_atom(atom/exposed_atom, reac_volume)
	. = ..()
	if(!isliving(exposed_atom) || can_colour_mobs)
		exposed_atom.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)

/datum/reagent/hair_dye
	name = "Quantum Hair Dye-量子染发剂"
	description = "会让你看起来像个疯狂的科学家吗."
	reagent_state = LIQUID
	var/list/potential_colors = list("#00aadd","#aa00ff","#ff7733","#dd1144","#dd1144","#00bb55","#00aadd","#ff7733","#ffcc22","#008844","#0055ee","#dd2222","#ffaa00") // fucking hair code
	color = "#C8A5DC"
	taste_description = "酸"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/hair_dye/New()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(UpdateColor)))
	return ..()

/datum/reagent/hair_dye/proc/UpdateColor()
	color = pick(potential_colors)

/datum/reagent/hair_dye/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=FALSE)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_mob))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	exposed_human.set_facial_haircolor(pick(potential_colors), update = FALSE)
	exposed_human.set_haircolor(pick(potential_colors), update = TRUE)
	exposed_human.update_body_parts()

/datum/reagent/barbers_aid
	name = "Barber's Aid-理发帮手"
	description = "解决全球脱发问题."
	reagent_state = LIQUID
	color = "#A86B45" //hair is brown
	taste_description = "酸"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/barbers_aid/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=FALSE)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_mob) || (HAS_TRAIT(exposed_mob, TRAIT_BALD) && HAS_TRAIT(exposed_mob, TRAIT_SHAVED)))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	if(!HAS_TRAIT(exposed_human, TRAIT_SHAVED))
		var/datum/sprite_accessory/facial_hair/picked_beard = pick(SSaccessories.facial_hairstyles_list)
		exposed_human.set_facial_hairstyle(picked_beard, update = FALSE)
	if(!HAS_TRAIT(exposed_human, TRAIT_BALD))
		var/datum/sprite_accessory/hair/picked_hair = pick(SSaccessories.hairstyles_list)
		exposed_human.set_hairstyle(picked_hair, update = TRUE)
	to_chat(exposed_human, span_notice("头发开始从你的[HAS_TRAIT(exposed_human, TRAIT_BALD) ? "面部" : "头顶"]发芽."))

/datum/reagent/concentrated_barbers_aid
	name = "Concentrated Barber's Aid-浓缩理发助手"
	description = "解决全球脱发问题的浓缩解决方案."
	reagent_state = LIQUID
	color = "#7A4E33" //hair is dark browmn
	taste_description = "酸"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/concentrated_barbers_aid/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=FALSE)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_mob) || (HAS_TRAIT(exposed_mob, TRAIT_BALD) && HAS_TRAIT(exposed_mob, TRAIT_SHAVED)))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	if(!HAS_TRAIT(exposed_human, TRAIT_SHAVED))
		exposed_human.set_facial_hairstyle("Beard (Very Long)", update = FALSE)
	if(!HAS_TRAIT(exposed_human, TRAIT_BALD))
		exposed_human.set_hairstyle("Very Long Hair", update = TRUE)
	to_chat(exposed_human, span_notice("你的[HAS_TRAIT(exposed_human, TRAIT_BALD) ? "面部" : ""]毛发开始以惊人的速度生长!"))

/datum/reagent/concentrated_barbers_aid/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 21 / creation_purity)
		if(!ishuman(affected_mob))
			return
		var/mob/living/carbon/human/human_mob = affected_mob
		if(creation_purity == 1 && human_mob.has_quirk(/datum/quirk/item_quirk/bald))
			human_mob.remove_quirk(/datum/quirk/item_quirk/bald)
		var/obj/item/bodypart/head/head = human_mob.get_bodypart(BODY_ZONE_HEAD)
		if(!head || (head.head_flags & HEAD_HAIR))
			return
		head.head_flags |= HEAD_HAIR
		var/message
		if(HAS_TRAIT(affected_mob, TRAIT_BALD))
			message = span_warning("你感到你的头皮发生了变异，但你仍然是无可救药的秃顶.")
		else
			message = span_notice("你的头皮会发生变异，长出一整头的头发.")
		to_chat(affected_mob, message)
		human_mob.update_body_parts()

/datum/reagent/baldium
	name = "Baldium-秃发素"
	description = "这是全世界脱发的主要原因."
	reagent_state = LIQUID
	color = "#ecb2cf"
	taste_description = "苦"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/baldium/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=FALSE)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_mob))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	to_chat(exposed_human, span_danger("你的头发一簇簇地掉下来了!"))
	exposed_human.set_facial_hairstyle("Shaved", update = FALSE)
	exposed_human.set_hairstyle("Bald", update = TRUE)

/datum/reagent/saltpetre
	name = "Saltpetre-硝酸钠"
	description = "不稳定的，有争议的，三件事."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	taste_description = "酷酷的盐"
	ph = 11.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// Saltpetre is used for gardening IRL, to simplify highly, it speeds up growth and strengthens plants
/datum/reagent/saltpetre/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(round(volume * 0.18))
	mytray.myseed?.adjust_production(-round(volume / 10)-prob(volume % 10))
	mytray.myseed?.adjust_potency(round(volume))

/datum/reagent/lye
	name = "Lye-碱液"
	description = "也被称为氢氧化钠."
	reagent_state = LIQUID
	color = "#FFFFD6" // very very light yellow
	taste_description = "酸"
	ph = 11.9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/drying_agent
	name = "Drying Agent-干燥剂"
	description = "一个干燥剂，可以用来干燥东西."
	reagent_state = LIQUID
	color = "#A70FFF"
	taste_description = "干燥"
	ph = 10.7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/drying_agent/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	// We want one spray of this stuff (5u) to take out a wet floor. Feels better that way
	exposed_turf.MakeDry(ALL, TRUE, reac_volume * 10 SECONDS)

/datum/reagent/drying_agent/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(exposed_obj.type != /obj/item/clothing/shoes/galoshes)
		return
	var/t_loc = get_turf(exposed_obj)
	qdel(exposed_obj)
	new /obj/item/clothing/shoes/galoshes/dry(t_loc)

// Virology virus food chems.

/datum/reagent/toxin/mutagen/mutagenvirusfood
	name = "Mutagenic Agar-诱变琼脂"
	color = "#A3C00F" // rgb: 163,192,15
	taste_description = "酸"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar
	name = "Sucrose Agar-蔗糖琼脂"
	color = "#41B0C0" // rgb: 65,176,192
	taste_description = "甜"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/synaptizine/synaptizinevirusfood
	name = "Virus Rations-病毒养料"
	color = "#D18AA5" // rgb: 209,138,165
	taste_description = "苦"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/plasma/plasmavirusfood
	name = "Virus Plasma-病毒等离子"
	color = "#A270A8" // rgb: 166,157,169
	taste_description = "苦"
	taste_mult = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/plasma/plasmavirusfood/weak
	name = "Weakened Virus Plasma-弱病毒等离子"
	color = "#A28CA5" // rgb: 206,195,198
	taste_description = "苦"
	taste_mult = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/uranium/uraniumvirusfood
	name = "Decaying Uranium Gel-衰变铀凝胶"
	color = "#67ADBA" // rgb: 103,173,186
	taste_description = "反应堆的内部"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/uranium/uraniumvirusfood/unstable
	name = "Unstable Uranium Gel-不稳定铀凝胶"
	color = "#2FF2CB" // rgb: 47,242,203
	taste_description = "反应堆的内部"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/uranium/uraniumvirusfood/stable
	name = "Stable Uranium Gel-稳定铀凝胶"
	color = "#04506C" // rgb: 4,80,108
	taste_description = "反应堆的内部"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// Bee chemicals

/datum/reagent/royal_bee_jelly
	name = "Royal Bee Jelly-蜂王浆"
	description = "如果把蜂王浆注射到一只太空蜂后体内，这只蜜蜂就会分裂成两只蜜蜂."
	color = "#00ff80"
	taste_description = "奇怪的蜂蜜"
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/royal_bee_jelly/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(1, seconds_per_tick))
		affected_mob.say(pick("Bzzz...","BZZ BZZ","Bzzzzzzzzzzz..."), forced = "royal bee jelly")

//Misc reagents

/datum/reagent/romerol
	name = "Romerol-罗梅罗"
	// the REAL zombie powder
	description = "Romerol-罗梅罗是一种高度机密的生物病毒，\
		它能在受试对象的灰质中蚀刻出休眠的肿瘤结节，\
		这些肿瘤结节将在宿主死亡时变得活跃，\
		进入活跃状态后，二级结构将被激活，该肿瘤将\
		控制宿主的肉体."
	color = "#123524" // RGB (18, 53, 36)
	metabolization_rate = INFINITY
	taste_description = "大脑"
	ph = 0.5

/datum/reagent/romerol/expose_mob(mob/living/carbon/human/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	// Silently add the zombie infection organ to be activated upon death
	if(!exposed_mob.get_organ_slot(ORGAN_SLOT_ZOMBIE))
		var/obj/item/organ/internal/zombie_infection/nodamage/ZI = new()
		ZI.Insert(exposed_mob)

/datum/reagent/magillitis
	name = "Magillitis-猿力宝"
	description = "使人科动物肌肉迅速生长的实验性血清，副作用可能包括多毛症、暴力爆发和对香蕉的无休止的喜爱."
	reagent_state = LIQUID
	color = "#00f041"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/magillitis/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if((ishuman(affected_mob)) && current_cycle > 10)
		var/mob/living/basic/gorilla/new_gorilla = affected_mob.gorillize()
		new_gorilla.AddComponent(/datum/component/regenerator, regeneration_delay = 12 SECONDS, brute_per_second = 1.5, outline_colour = COLOR_PALE_GREEN)

/datum/reagent/growthserum
	name = "Growth Serum-增生血清"
	description = "这是一种商业化学品，旨在帮助在床上的老年人."//not really it just makes you a giant
	color = "#ff0000"//strong red. rgb 255, 0, 0
	var/current_size = RESIZE_DEFAULT_SIZE
	taste_description = "苦" // apparently what viagra tastes like
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/growthserum/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/newsize = current_size
	switch(volume)
		if(0 to 19)
			newsize = 1.25*RESIZE_DEFAULT_SIZE
		if(20 to 49)
			newsize = 1.5*RESIZE_DEFAULT_SIZE
		if(50 to 99)
			newsize = 2*RESIZE_DEFAULT_SIZE
		if(100 to 199)
			newsize = 2.5*RESIZE_DEFAULT_SIZE
		if(200 to INFINITY)
			newsize = 3.5*RESIZE_DEFAULT_SIZE

	affected_mob.update_transform(newsize/current_size)
	current_size = newsize

/datum/reagent/growthserum/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.update_transform(RESIZE_DEFAULT_SIZE/current_size)
	current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/plastic_polymers
	name = "Plastic Polymers-塑料聚合物"
	description = "塑料的石油基成分."
	color = "#f7eded"
	taste_description = "塑料"
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/glitter
	name = "Generic Glitter"
	description = "if you can see this description, contact a coder."
	color = COLOR_WHITE //pure white
	taste_description = "plastic"
	reagent_state = SOLID
	var/glitter_type = /obj/effect/decal/cleanable/glitter
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/glitter/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	exposed_turf.spawn_unique_cleanable(glitter_type)

/datum/reagent/glitter/pink
	name = "Pink Glitter-粉红闪光"
	description = "到处都是粉红色的火花"
	color = "#ff8080" //A light pink color
	glitter_type = /obj/effect/decal/cleanable/glitter/pink
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/glitter/white
	name = "White Glitter-白色闪光"
	description = "到处都是白色的火花"
	glitter_type = /obj/effect/decal/cleanable/glitter/white
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/glitter/blue
	name = "Blue Glitter-蓝色闪光"
	description = "到处都是蓝色的火花"
	color = "#4040FF" //A blueish color
	glitter_type = /obj/effect/decal/cleanable/glitter/blue
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/glitter/confetti
	name = "Confetti-五彩纸屑"
	description = "难以清除的微小塑料碎片."
	color = "#7dd87b"
	glitter_type = /obj/effect/decal/cleanable/confetti
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/pax
	name = "Pax-和平素"
	description = "一种无色液体，能抑制其体内的暴力."
	color = "#AAAAAA55"
	taste_description = "water"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	ph = 15
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	metabolized_traits = list(TRAIT_PACIFISM)

/datum/reagent/bz_metabolites
	name = "BZ Metabolites-BZ代谢物"
	description = "一种无害的BZ气体代谢物."
	color = "#FAFF00"
	taste_description = "刺鼻的肉桂"
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	metabolized_traits = list(TRAIT_CHANGELING_HIVEMIND_MUTE)

/datum/reagent/bz_metabolites/on_mob_life(mob/living/carbon/target, seconds_per_tick, times_fired)
	. = ..()
	if(target.mind)
		var/datum/antagonist/changeling/changeling = IS_CHANGELING(target)
		if(changeling)
			changeling.adjust_chemicals(-4 * REM * seconds_per_tick) //SKYRAT EDIT - BZ-BUFF-VS-LING - ORIGINAL: changeling.adjust_chemicals(-2 * REM * seconds_per_tick)

/datum/reagent/pax/peaceborg
	name = "Synthpax-合成和平素"
	description = "一种无色液体，能抑制其体内的暴力，合成比普通和平素便宜，但药效消失得更快."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/peaceborg/confuse
	name = "Dizzying Solution-致晕剂"
	description = "使目标失去平衡，眩晕"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "头晕"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/peaceborg/confuse/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_confusion_up_to(3 SECONDS * REM * seconds_per_tick, 5 SECONDS)
	affected_mob.adjust_dizzy_up_to(6 SECONDS * REM * seconds_per_tick, 12 SECONDS)

	if(SPT_PROB(10, seconds_per_tick))
		to_chat(affected_mob, "你感到困惑和迷失方向.")

/datum/reagent/peaceborg/tire
	name = "Tiring Solution-致疲剂"
	description = "一种极弱的耐力毒素，能使目标精疲力竭。完全无害的."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "疲劳"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/peaceborg/tire/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/healthcomp = (100 - affected_mob.health) //DOES NOT ACCOUNT FOR ADMINBUS THINGS THAT MAKE YOU HAVE MORE THAN 200/210 HEALTH, OR SOMETHING OTHER THAN A HUMAN PROCESSING THIS.
	. = FALSE
	if(affected_mob.getStaminaLoss() < (45 - healthcomp)) //At 50 health you would have 200 - 150 health meaning 50 compensation. 60 - 50 = 10, so would only do 10-19 stamina.)
		if(affected_mob.adjustStaminaLoss(10 * REM * seconds_per_tick, updating_stamina = FALSE))
			. = UPDATE_MOB_HEALTH
	if(SPT_PROB(16, seconds_per_tick))
		to_chat(affected_mob, "你应该坐下来休息一下...")

/datum/reagent/gondola_mutation_toxin
	name = "Tranquility-宁剂"
	description = "一种来历不明的高度变异液体."
	color = "#9A6750" //RGB: 154, 103, 80
	taste_description = "内在平静"
	penetrates_skin = NONE
	var/datum/disease/transformation/gondola_disease = /datum/disease/transformation/gondola

/datum/reagent/gondola_mutation_toxin/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*(1 - touch_protection))))
		exposed_mob.ForceContractDisease(new gondola_disease, FALSE, TRUE)


/datum/reagent/spider_extract
	name = "Spider Extract-蜘蛛提取物"
	description = "一种来自澳大利亚科的高度专业化的提取物，用于制造母体蜘蛛."
	color = "#ED2939"
	taste_description = "上下颠倒"

/// Improvised reagent that induces vomiting. Created by dipping a dead mouse in welder fluid.
/datum/reagent/yuck
	name = "Organic Slurry-有机泥浆"
	description = "各种颜色液体的混合物诱发呕吐."
	color = "#545000"
	taste_description = "恶心"
	taste_mult = 4
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/yuck_cycle = 0 //! The `current_cycle` when puking starts.

/datum/glass_style/drinking_glass/yuck
	required_drink_type = /datum/reagent/yuck
	name = "恶心的东西"
	desc = "闻起来像一具尸体，看起来也好不到哪里去."

/datum/reagent/yuck/on_mob_add(mob/living/affected_mob)
	if(HAS_TRAIT(affected_mob, TRAIT_NOHUNGER)) //they can't puke
		holder.del_reagent(type)
	return ..()

#define YUCK_PUKE_CYCLES 3 // every X cycle is a puke
#define YUCK_PUKES_TO_STUN 3 // hit this amount of pukes in a row to start stunning
/datum/reagent/yuck/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!yuck_cycle)
		if(SPT_PROB(4, seconds_per_tick))
			var/dread = pick("你胃里有东西在动...", \
				"一声潮湿的咆哮从你的胃里回响...", \
				"有那么一刻，你觉得周围的环境在动，但那是你的胃...")
			to_chat(affected_mob, span_userdanger("[dread]"))
			yuck_cycle = current_cycle
	else
		var/yuck_cycles = current_cycle - yuck_cycle
		if(yuck_cycles % YUCK_PUKE_CYCLES == 0)
			if(yuck_cycles >= YUCK_PUKE_CYCLES * YUCK_PUKES_TO_STUN)
				if(holder)
					holder.remove_reagent(type, 5)
			var/passable_flags = (MOB_VOMIT_MESSAGE | MOB_VOMIT_HARM)
			if(yuck_cycles >= (YUCK_PUKE_CYCLES * YUCK_PUKES_TO_STUN))
				passable_flags |= MOB_VOMIT_STUN
			affected_mob.vomit(vomit_flags = passable_flags, lost_nutrition = rand(14, 26))

#undef YUCK_PUKE_CYCLES
#undef YUCK_PUKES_TO_STUN

/datum/reagent/yuck/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	yuck_cycle = 0 // reset vomiting

/datum/reagent/yuck/on_transfer(atom/A, methods=TOUCH, trans_volume)
	if((methods & INGEST) || !iscarbon(A))
		return ..()

	A.reagents.remove_reagent(type, trans_volume)
	A.reagents.add_reagent(/datum/reagent/fuel, trans_volume * 0.75)
	A.reagents.add_reagent(/datum/reagent/water, trans_volume * 0.25)

	return ..()

//monkey powder heehoo
/datum/reagent/monkey_powder
	name = "Monkey Powder-猴子粉"
	description = "只需加水!"
	color = "#9C5A19"
	taste_description = "香蕉"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/plasma_oxide
	name = "Hyper-Plasmium Oxide-超等离子体氧化物"
	description = "在地狱行星的核心深处产生的化合物，通常在深层间歇泉中发现."
	color = "#470750" // rgb: 255, 255, 255
	taste_description = "hell"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/exotic_stabilizer
	name = "Exotic Stabilizer-异星化合物"
	description = "由稳定剂和超等离子体氧化物混合而成的高级化合物."
	color = "#180000" // rgb: 255, 255, 255
	taste_description = "血液"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/wittel
	name = "Wittel-白石"
	description = "一种极其罕见的金属白色物质，只在地狱行星上发现."
	color = COLOR_WHITE // rgb: 255, 255, 255
	taste_mult = 0 // oderless and tasteless
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/metalgen
	name = "Metalgen-金属根"
	data = list("material"=null)
	description = "一种紫色的金属形态液体，据说能把它的金属性质施加到它接触到的任何东西上."
	color = "#b000aa"
	taste_mult = 0 // oderless and tasteless
	chemical_flags = REAGENT_NO_RANDOM_RECIPE
	/// The material flags used to apply the transmuted materials
	var/applied_material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR
	/// The amount of materials to apply to the transmuted objects if they don't contain materials
	var/default_material_amount = 100

/datum/reagent/metalgen/expose_obj(obj/exposed_obj, volume)
	. = ..()
	metal_morph(exposed_obj)

/datum/reagent/metalgen/expose_turf(turf/exposed_turf, volume)
	. = ..()
	metal_morph(exposed_turf)

///turn an object into a special material
/datum/reagent/metalgen/proc/metal_morph(atom/target)
	var/metal_ref = data["material"]
	if(!metal_ref)
		return

	if(is_type_in_typecache(target, GLOB.blacklisted_metalgen_types)) //some stuff can lead to exploits if transmuted
		return

	var/metal_amount = 0
	var/list/materials_to_transmute = target.get_material_composition()
	for(var/metal_key in materials_to_transmute) //list with what they're made of
		metal_amount += materials_to_transmute[metal_key]

	if(!metal_amount)
		metal_amount = default_material_amount //some stuff doesn't have materials at all. To still give them properties, we give them a material. Basically doesn't exist

	var/list/metal_dat = list((metal_ref) = metal_amount)
	target.material_flags = applied_material_flags
	target.set_custom_materials(metal_dat)

/datum/reagent/gravitum
	name = "Gravitum-零流体"
	description = "一种罕见的流体，能够暂时消除它接触到的所有物体的重量." //i dont even
	color = "#050096" // rgb: 5, 0, 150
	taste_mult = 0 // oderless and tasteless
	metabolization_rate = 0.1 * REAGENTS_METABOLISM //20 times as long, so it's actually viable to use
	var/time_multiplier = 1 MINUTES //1 minute per unit of gravitum on objects. Seems overpowered, but the whole thing is very niche
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	self_consuming = TRUE //this works on objects, so it should work on skeletons and robots too

/datum/reagent/gravitum/expose_obj(obj/exposed_obj, volume)
	. = ..()
	exposed_obj.AddElement(/datum/element/forced_gravity, 0)
	addtimer(CALLBACK(exposed_obj, PROC_REF(_RemoveElement), list(/datum/element/forced_gravity, 0)), volume * time_multiplier, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/reagent/gravitum/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.AddElement(/datum/element/forced_gravity, 0) //0 is the gravity, and in this case weightless

/datum/reagent/gravitum/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.RemoveElement(/datum/element/forced_gravity, 0)

/datum/reagent/cellulose
	name = "Cellulose Fibers-纤维素纤维"
	description = "这是一种结晶的葡萄糖聚合物，植物对它非常信任."
	reagent_state = SOLID
	color = "#E6E6DA"
	taste_mult = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// "Second wind" reagent generated when someone suffers a wound. Epinephrine, adrenaline, and stimulants are all already taken so here we are
/datum/reagent/determination
	name = "Determination-决心"
	description = "当你需要再努力一点的时候."
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM // 5u (WOUND_DETERMINATION_CRITICAL) will last for ~34 seconds
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	self_consuming = TRUE
	metabolized_traits = list(TRAIT_ANALGESIA)
	/// Whether we've had at least WOUND_DETERMINATION_SEVERE (2.5u) of determination at any given time. No damage slowdown immunity or indication we're having a second wind if it's just a single moderate wound
	var/significant = FALSE

/datum/reagent/determination/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	if(significant)
		var/stam_crash = 0
		for(var/thing in affected_mob.all_wounds)
			var/datum/wound/W = thing
			stam_crash += (W.severity + 1) * 3 // spike of 3 stam damage per wound severity (moderate = 6, severe = 9, critical = 12) when the determination wears off if it was a combat rush
		affected_mob.adjustStaminaLoss(stam_crash)
	affected_mob.remove_status_effect(/datum/status_effect/determined)

/datum/reagent/determination/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!significant && volume >= WOUND_DETERMINATION_SEVERE)
		significant = TRUE
		affected_mob.apply_status_effect(/datum/status_effect/determined) // in addition to the slight healing, limping cooldowns are divided by 4 during the combat high

	volume = min(volume, WOUND_DETERMINATION_MAX)

	for(var/thing in affected_mob.all_wounds)
		var/datum/wound/W = thing
		var/obj/item/bodypart/wounded_part = W.limb
		if(wounded_part)
			wounded_part.heal_damage(0.25 * REM * seconds_per_tick, 0.25 * REM * seconds_per_tick)
		if(affected_mob.adjustStaminaLoss(-1 * REM * seconds_per_tick, updating_stamina = FALSE)) // the more wounds, the more stamina regen
			return UPDATE_MOB_HEALTH

// unholy water, but for heretics.
// why couldn't they have both just used the same reagent?
// who knows.
// maybe nar'sie is considered to be too "mainstream" of a god to worship in the heretic community.
/datum/reagent/eldritch
	name = "Eldritch Essence-可畏的本质"
	description = "一种违反物理定律的奇怪液体. \
		它给那些能够超越脆弱现实的人重新注入能量，治愈他们， \
		但对思想封闭的人来说是非常有害的，它代谢得非常快."
	taste_description = "Ag'hsj'saje'sh"
	self_consuming = TRUE //eldritch intervention won't be limited by the lack of a liver
	color = "#1f8016"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM  //0.5u/second
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/eldritch/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update = FALSE
	if(IS_HERETIC_OR_MONSTER(drinker))
		drinker.adjust_drowsiness(-10 * REM * seconds_per_tick)
		drinker.AdjustAllImmobility(-40 * REM * seconds_per_tick)
		need_mob_update += drinker.adjustStaminaLoss(-10 * REM * seconds_per_tick, updating_stamina = FALSE)
		need_mob_update += drinker.adjustToxLoss(-2 * REM * seconds_per_tick, updating_health = FALSE, forced = TRUE)
		need_mob_update += drinker.adjustOxyLoss(-2 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += drinker.adjustBruteLoss(-2 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += drinker.adjustFireLoss(-2 * REM * seconds_per_tick, updating_health = FALSE)
		if(drinker.blood_volume < BLOOD_VOLUME_NORMAL)
			drinker.blood_volume += 3 * REM * seconds_per_tick
	else
		need_mob_update = drinker.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * REM * seconds_per_tick, 150)
		need_mob_update += drinker.adjustToxLoss(2 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += drinker.adjustFireLoss(2 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += drinker.adjustOxyLoss(2 * REM * seconds_per_tick, updating_health = FALSE)
		need_mob_update += drinker.adjustBruteLoss(2 * REM * seconds_per_tick, updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/universal_indicator
	name = "Universal Indicator-通用指示剂"
	description = "一种可以用来制作pH值小册子的溶液，或者喷在东西上，根据它们的pH值给它们上色."
	taste_description = "化学品"
	color = "#1f8016"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//Colours things by their pH
/datum/reagent/universal_indicator/expose_atom(atom/exposed_atom, reac_volume)
	. = ..()
	if(exposed_atom.reagents)
		var/color
		CONVERT_PH_TO_COLOR(exposed_atom.reagents.ph, color)
		exposed_atom.add_atom_colour(color, WASHABLE_COLOUR_PRIORITY)

// [Original ants concept by Keelin on Goon]
/datum/reagent/ants
	name = "Ants-蚂蚁"
	description = "太空蚂蚁是普通蚂蚁和白蚁的基因杂交品种，它们的叮咬在施密特疼痛量表上是3级."
	reagent_state = SOLID
	color = "#993333"
	taste_mult = 1.3
	taste_description = "小腿儿在喉咙里乱窜"
	metabolization_rate = 5 * REAGENTS_METABOLISM //1u per second
	ph = 4.6 // Ants contain Formic Acid
	/// Number of ticks the ants have been in the person's body
	var/ant_ticks = 0
	/// Amount of damage done per tick the ants have been in the person's system
	var/ant_damage = 0.025
	/// Tells the debuff how many ants we are being covered with.
	var/amount_left = 0
	/// Decal to spawn when spilled
	var/ants_decal = /obj/effect/decal/cleanable/ants
	/// Status effect applied by splashing ants
	var/status_effect = /datum/status_effect/ants
	/// List of possible common statements to scream when eating ants
	var/static/list/ant_screams = list(
		"它们在我的皮肤下面!!",
		"把它们从我身上弄出来!!",
		"我草皮肤在燃烧!!",
		"上帝啊它们在我身体里面!!",
		"滚啊啊啊!!",
	)

/datum/glass_style/drinking_glass/ants
	required_drink_type = /datum/reagent/ants
	name = "一杯蚂蚁"
	desc = "干杯...?"

/datum/reagent/ants/on_mob_life(mob/living/carbon/victim, seconds_per_tick)
	. = ..()
	victim.adjustBruteLoss(max(0.1, round((ant_ticks * ant_damage),0.1))) //Scales with time. Roughly 32 brute with 100u.
	ant_ticks++
	if(ant_ticks < 5) // Makes ant food a little more appetizing, since you won't be screaming as much.
		return
	if(SPT_PROB(5, seconds_per_tick))
		if(SPT_PROB(5, seconds_per_tick)) //Super rare statement
			victim.say("啊，啊！ 别，别是蚂蚁! 别是蚂蚁! 啊啊啊啊 它们在我的眼睛里! 我的眼睛! 啊啊啊啊!!", forced = type)
		else
			victim.say(pick(ant_screams), forced = type)
	if(SPT_PROB(15, seconds_per_tick))
		victim.emote("scream")
	if(SPT_PROB(2, seconds_per_tick)) // Stuns, but purges ants.
		victim.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = rand(5,10), purge_ratio = 1)

/datum/reagent/ants/on_mob_end_metabolize(mob/living/living_anthill)
	. = ..()
	ant_ticks = 0
	to_chat(living_anthill, "<span class='notice'>你觉得你的身体里没有蚂蚁了.</span>")

/datum/reagent/ants/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!iscarbon(exposed_mob) || (methods & (INGEST|INJECT)))
		return
	if(methods & (PATCH|TOUCH|VAPOR))
		amount_left = round(reac_volume,0.1)
		exposed_mob.apply_status_effect(status_effect, amount_left)

/datum/reagent/ants/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	var/turf/open/my_turf = exposed_obj.loc // No dumping ants on an object in a storage slot
	if(!istype(my_turf)) //Are we actually in an open turf?
		return
	var/static/list/accepted_types = typecacheof(list(/obj/machinery/atmospherics, /obj/structure/cable, /obj/structure/disposalpipe))
	if(!accepted_types[exposed_obj.type]) // Bypasses pipes, vents, and cables to let people create ant mounds on top easily.
		return
	expose_turf(my_turf, reac_volume)

/datum/reagent/ants/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf) || isspaceturf(exposed_turf)) // Is the turf valid
		return
	if((reac_volume <= 10)) // Makes sure people don't duplicate ants.
		return

	var/obj/effect/decal/cleanable/ants/pests = exposed_turf.spawn_unique_cleanable(ants_decal)
	if(!pests)
		return

	var/spilled_ants = (round(reac_volume,1) - 5) // To account for ant decals giving 3-5 ants on initialize.
	pests.reagents.add_reagent(type, spilled_ants)
	pests.update_ant_damage()

/datum/reagent/ants/fire
	name = "Fire ants"
	description = "A rare mutation of space ants, born from the heat of a plasma fire. Their bites land a 3.7 on the Schmidt Pain Scale."
	color = "#b51f1f"
	taste_description = "tiny flaming legs scuttling down the back of your throat"
	ant_damage = 0.05 // Roughly 64 brute with 100u
	ants_decal = /obj/effect/decal/cleanable/ants/fire
	status_effect = /datum/status_effect/ants/fire

/datum/glass_style/drinking_glass/fire_ants
	required_drink_type = /datum/reagent/ants/fire
	name = "glass of fire ants"
	desc = "This is a terrible idea."

//This is intended to a be a scarce reagent to gate certain drugs and toxins with. Do not put in a synthesizer. Renewable sources of this reagent should be inefficient.
/datum/reagent/lead
	name = "Lead-铅"
	description = "低熔点暗淡的金属元素."
	taste_description = "金属"
	reagent_state = SOLID
	color = "#80919d"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM

/datum/reagent/lead/on_mob_life(mob/living/carbon/victim)
	. = ..()
	if(victim.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5))
		return UPDATE_MOB_HEALTH

//The main feedstock for kronkaine production, also a shitty stamina healer.
/datum/reagent/kronkus_extract
	name = "Kronkus Extract-可卡提取物"
	description = "一种由发酵的kronkus藤浆制成的泡沫提取物。由于含有多种kronkamine而非常苦。"
	taste_description = "苦"
	color = "#228f63"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/stimulants = 5)

/datum/reagent/kronkus_extract/on_mob_life(mob/living/carbon/kronkus_enjoyer)
	. = ..()
	var/need_mob_update
	need_mob_update = kronkus_enjoyer.adjustOrganLoss(ORGAN_SLOT_HEART, 0.1)
	need_mob_update += kronkus_enjoyer.adjustStaminaLoss(-6, updating_stamina = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/brimdust
	name = "Brimdust-边缘尘埃"
	description = "虽然植物喜欢它，但不建议食用."
	reagent_state = SOLID
	color = "#522546"
	taste_description = "燃烧"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/brimdust/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.adjustFireLoss((ispodperson(affected_mob) ? -1 : 1 * seconds_per_tick), updating_health = FALSE))
		return UPDATE_MOB_HEALTH

/datum/reagent/brimdust/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_weedlevel(-1)
	mytray.adjust_pestlevel(-1)
	mytray.adjust_plant_health(round(volume))
	mytray.myseed?.adjust_potency(round(volume * 0.5))

// I made this food....with love.
// Reagent added to food by chef's with a chef's kiss. Makes people happy.
/datum/reagent/love
	name = "Love-爱"
	description = "这食物是...用爱."
	color = "#ff7edd"
	taste_description = "爱"
	taste_mult = 10
	overdose_threshold = 50 // too much love is a bad thing

/datum/reagent/love/expose_mob(mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection)
	. = ..()
	// A syringe is not grandma's cooking
	if(methods & ~INGEST)
		exposed_mob.reagents.del_reagent(type)

/datum/reagent/love/on_mob_metabolize(mob/living/metabolizer)
	. = ..()
	metabolizer.add_mood_event(name, /datum/mood_event/love_reagent)

/datum/reagent/love/on_mob_delete(mob/living/affected_mob)
	. = ..()
	// When we exit the system we'll leave the moodlet based on the amount we had
	var/duration_of_moodlet = current_cycle * 20 SECONDS
	affected_mob.clear_mood_event(name)
	affected_mob.add_mood_event(name, /datum/mood_event/love_reagent, duration_of_moodlet)

/datum/reagent/love/overdose_process(mob/living/metabolizer, seconds_per_tick, times_fired)
	. = ..()
	var/mob/living/carbon/carbon_metabolizer = metabolizer
	if(!istype(carbon_metabolizer) || !carbon_metabolizer.can_heartattack() || carbon_metabolizer.undergoing_cardiac_arrest())
		metabolizer.reagents.del_reagent(type)
		return

	if(SPT_PROB(10, seconds_per_tick))
		carbon_metabolizer.set_heartattack(TRUE)

/datum/reagent/hauntium
	name = "Hauntium-灵魂蚀液"
	color = "#3B3B3BA3"
	description = "一种通过净化灵魂而产生的诡异液体，如果它碰巧进入你的身体，它就会开始伤害你的灵魂." //soul as in mood and heart
	taste_description = "邪恶意志"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	material = /datum/material/hauntium
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/hauntium/expose_obj(obj/exposed_obj, volume) //gives 15 seconds of haunting effect for every unit of it that touches an object
	. = ..()
	if(HAS_TRAIT_FROM(exposed_obj, TRAIT_HAUNTED, HAUNTIUM_REAGENT_TRAIT))
		return
	exposed_obj.make_haunted(HAUNTIUM_REAGENT_TRAIT, "#f8f8ff")
	addtimer(CALLBACK(exposed_obj, TYPE_PROC_REF(/atom/movable/, remove_haunted), HAUNTIUM_REAGENT_TRAIT), volume * 20 SECONDS)

/datum/reagent/hauntium/on_mob_metabolize(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	to_chat(affected_mob, span_userdanger("你感到体内有邪恶的存在!"))
	if(affected_mob.mob_biotypes & MOB_UNDEAD || HAS_MIND_TRAIT(affected_mob, TRAIT_MORBID))
		affected_mob.add_mood_event("morbid_hauntium", /datum/mood_event/morbid_hauntium, name) //8 minutes of slight mood buff if undead or morbid
	else
		affected_mob.add_mood_event("hauntium_spirits", /datum/mood_event/hauntium_spirits, name) //8 minutes of mood debuff

/datum/reagent/hauntium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.mob_biotypes & MOB_UNDEAD || HAS_MIND_TRAIT(affected_mob, TRAIT_MORBID)) //if morbid or undead,acts like an addiction-less drug
		affected_mob.remove_status_effect(/datum/status_effect/jitter)
		affected_mob.AdjustStun(-50 * REM * seconds_per_tick)
		affected_mob.AdjustKnockdown(-50 * REM * seconds_per_tick)
		affected_mob.AdjustUnconscious(-50 * REM * seconds_per_tick)
		affected_mob.AdjustParalyzed(-50 * REM * seconds_per_tick)
		affected_mob.AdjustImmobilized(-50 * REM * seconds_per_tick)
	else
		if(affected_mob.adjustOrganLoss(ORGAN_SLOT_HEART, REM * seconds_per_tick)) //1 heart damage per tick
			. = UPDATE_MOB_HEALTH
		if(SPT_PROB(10, seconds_per_tick))
			affected_mob.emote(pick("twitch","choke","shiver","gag"))

// The same as gold just with a slower metabolism rate, to make using the Hand of Midas easier.
/datum/reagent/gold/cursed
	name = "Cursed Gold-诅咒黄金"
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
