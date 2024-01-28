///////////////////////////////////////////////////////////////////
					//Food Reagents
//////////////////////////////////////////////////////////////////


// Part of the food code. Also is where all the food
// condiments, additives, and such go.


/datum/reagent/consumable
	name = "Consumable"
	taste_description = "generic food"
	taste_mult = 4
	inverse_chem_val = 0.1
	inverse_chem = null
	creation_purity = 0.5 // 50% pure by default. Below - synthetic food. Above - natural food.
	/// How much nutrition this reagent supplies
	var/nutriment_factor = 1
	/// affects mood, typically higher for mixed drinks with more complex recipes'
	var/quality = 0

/datum/reagent/consumable/New()
	. = ..()
	// All food reagents function at a fixed rate
	chemical_flags |= REAGENT_UNAFFECTED_BY_METABOLISM

/datum/reagent/consumable/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!ishuman(affected_mob) || HAS_TRAIT(affected_mob, TRAIT_NOHUNGER))
		return

	var/mob/living/carbon/human/affected_human = affected_mob
	affected_human.adjust_nutrition(get_nutriment_factor(affected_mob) * REM * seconds_per_tick)

/datum/reagent/consumable/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & INGEST) || !quality || HAS_TRAIT(exposed_mob, TRAIT_AGEUSIA))
		return
	switch(quality)
		if (DRINK_REVOLTING)
			exposed_mob.add_mood_event("quality_drink", /datum/mood_event/quality_revolting)
		if (DRINK_NICE)
			exposed_mob.add_mood_event("quality_drink", /datum/mood_event/quality_nice)
		if (DRINK_GOOD)
			exposed_mob.add_mood_event("quality_drink", /datum/mood_event/quality_good)
		if (DRINK_VERYGOOD)
			exposed_mob.add_mood_event("quality_drink", /datum/mood_event/quality_verygood)
		if (DRINK_FANTASTIC)
			exposed_mob.add_mood_event("quality_drink", /datum/mood_event/quality_fantastic)
			exposed_mob.add_mob_memory(/datum/memory/good_drink, drink = src)
		if (FOOD_AMAZING)
			exposed_mob.add_mood_event("quality_food", /datum/mood_event/amazingtaste)
			// The food this was in was really tasty, not the reagent itself
			var/obj/item/the_real_food = holder.my_atom
			if(isitem(the_real_food) && !is_reagent_container(the_real_food))
				exposed_mob.add_mob_memory(/datum/memory/good_food, food = the_real_food)
		// SKYRAT ADDITION BEGIN - Racial Drinks
		if (RACE_DRINK)
			exposed_mob.add_mood_event("quality_drink", /datum/mood_event/race_drink)
		// SKYRAT ADDITION END

/// Gets just how much nutrition this reagent is worth for the passed mob
/datum/reagent/consumable/proc/get_nutriment_factor(mob/living/carbon/eater)
	return nutriment_factor * REAGENTS_METABOLISM * purity * 2

/datum/reagent/consumable/nutriment
	name = "Nutriment-营养"
	description = "含有人体所需的所有维生素、矿物质和碳水化合物."
	reagent_state = SOLID
	nutriment_factor = 15
	color = "#664330" // rgb: 102, 67, 48
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	var/brute_heal = 1
	var/burn_heal = 0

/datum/reagent/consumable/nutriment/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(round(volume * 0.2))

/datum/reagent/consumable/nutriment/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(30, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(brute = brute_heal * REM * seconds_per_tick, burn = burn_heal * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/nutriment/on_new(list/supplied_data)
	. = ..()
	if(!data)
		return
	// taste data can sometimes be ("salt" = 3, "chips" = 1)
	// and we want it to be in the form ("salt" = 0.75, "chips" = 0.25)
	// which is called "normalizing"
	if(!supplied_data)
		supplied_data = data

	// if data isn't an associative list, this has some WEIRD side effects
	// TODO probably check for assoc list?

	data = counterlist_normalise(supplied_data)

/datum/reagent/consumable/nutriment/on_merge(list/newdata, newvolume)
	. = ..()
	if(!islist(newdata) || !newdata.len)
		return

	// data for nutriment is one or more (flavour -> ratio)
	// where all the ratio values adds up to 1

	var/list/taste_amounts = list()
	if(data)
		taste_amounts = data.Copy()

	counterlist_scale(taste_amounts, volume)

	var/list/other_taste_amounts = newdata.Copy()
	counterlist_scale(other_taste_amounts, newvolume)

	counterlist_combine(taste_amounts, other_taste_amounts)

	counterlist_normalise(taste_amounts)

	data = taste_amounts

/datum/reagent/consumable/nutriment/get_taste_description(mob/living/taster)
	return data

/datum/reagent/consumable/nutriment/vitamin
	name = "Vitamin-维生素"
	description = "所有最好的维生素，矿物质和碳水化合物身体需要的纯粹形式."
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	brute_heal = 1
	burn_heal = 1

/datum/reagent/consumable/nutriment/vitamin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.satiety < MAX_SATIETY)
		affected_mob.satiety += 30 * REM * seconds_per_tick

/// The basic resource of vat growing.
/datum/reagent/consumable/nutriment/protein
	name = "Protein-蛋白质"
	description = "由氨基酸组成的天然聚酰胺，是大多数已知生命形式的基本组成部分."
	brute_heal = 0.8 //Rewards the player for eating a balanced diet.
	nutriment_factor = 9 //45% as calorie dense as oil.
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/nutriment/fat
	name = "Fat-脂肪"
	description = "甘油三酯存在于植物油和动物脂肪组织中."
	color = "#f0eed7"
	taste_description = "油脂"
	brute_heal = 0
	burn_heal = 1
	nutriment_factor = 18 // Twice as nutritious compared to protein and carbohydrates
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/fry_temperature = 450 //Around ~350 F (117 C) which deep fryers operate around in the real world

/datum/reagent/consumable/nutriment/fat/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(!holder || (holder.chem_temp <= fry_temperature))
		return
	if(!isitem(exposed_obj) || HAS_TRAIT(exposed_obj, TRAIT_FOOD_FRIED))
		return
	if(is_type_in_typecache(exposed_obj, GLOB.oilfry_blacklisted_items) || (exposed_obj.resistance_flags & INDESTRUCTIBLE))
		exposed_obj.visible_message(span_notice("热油对[exposed_obj]不起作用!"))
		return
	if(exposed_obj.atom_storage)
		exposed_obj.visible_message(span_notice("[exposed_obj]一接触热油就四处飞溅，没法好好煮!"))
		return

	exposed_obj.visible_message(span_warning("[exposed_obj]迅速炸酥!"))
	exposed_obj.AddElement(/datum/element/fried_item, volume)
	exposed_obj.reagents.add_reagent(src.type, reac_volume)

/datum/reagent/consumable/nutriment/fat/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!(methods & (VAPOR|TOUCH)) || isnull(holder) || (holder.chem_temp < fry_temperature)) //Directly coats the mob, and doesn't go into their bloodstream
		return

	var/burn_damage = ((holder.chem_temp / fry_temperature) * 0.33) //Damage taken per unit
	if(methods & TOUCH)
		burn_damage *= max(1 - touch_protection, 0)
	var/FryLoss = round(min(38, burn_damage * reac_volume))
	if(!HAS_TRAIT(exposed_mob, TRAIT_OIL_FRIED))
		exposed_mob.visible_message(span_warning("沸腾的油滋滋地覆盖着[exposed_mob]!"), \
		span_userdanger("你浑身都是滚烫的油!"))
		if(FryLoss)
			exposed_mob.emote("scream")
		playsound(exposed_mob, 'sound/machines/fryer/deep_fryer_emerge.ogg', 25, TRUE)
		ADD_TRAIT(exposed_mob, TRAIT_OIL_FRIED, "cooking_oil_react")
		addtimer(CALLBACK(exposed_mob, TYPE_PROC_REF(/mob/living, unfry_mob)), 3)
	if(FryLoss)
		exposed_mob.adjustFireLoss(FryLoss)

/datum/reagent/consumable/nutriment/fat/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	exposed_turf.MakeSlippery(TURF_WET_LUBE, min_wet_time = 10 SECONDS, wet_time_to_add = reac_volume*2 SECONDS)
	var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in exposed_turf)
	if(hotspot)
		var/datum/gas_mixture/lowertemp = exposed_turf.remove_air(exposed_turf.air.total_moles())
		lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
		lowertemp.react(src)
		exposed_turf.assume_air(lowertemp)
		qdel(hotspot)

/datum/reagent/consumable/nutriment/fat/oil
	name = "Vegetable Oil-菜油"
	description = "从植物中提取的各种食用油，用于食品制备和油炸."
	color = "#EADD6B" //RGB: 234, 221, 107 (based off of canola oil)
	taste_mult = 0.8
	taste_description = "油"
	nutriment_factor = 7 //Not very healthy on its own
	metabolization_rate = 10 * REAGENTS_METABOLISM
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/vegetable_oil

/datum/reagent/consumable/nutriment/fat/oil/olive
	name = "Olive Oil-橄榄油"
	description = "这是一种高品质的油，适合于油是关键风味的菜肴."
	taste_description = "橄榄油"
	color = "#DBCF5C"
	nutriment_factor = 10
	default_container = /obj/item/reagent_containers/condiment/olive_oil

/datum/reagent/consumable/nutriment/fat/oil/corn
	name = "Corn Oil-玉米油"
	description = "从不同种类的玉米中提取的油."
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "黏糊糊"
	nutriment_factor = 5 //it's a very cheap oil

/datum/reagent/consumable/nutriment/organ_tissue
	name = "Organ Tissue-器官组织"
	description = "构成大部分器官的天然组织，提供许多维生素和矿物质."
	taste_description = "浓郁的泥土香味"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/nutriment/cloth_fibers
	name = "Cloth Fibers-布纤维"
	description = "它实际上不是一种营养物质，但它确实能让蛾人活一段时间..."
	nutriment_factor = 30
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	brute_heal = 0
	burn_heal = 0
	///Amount of satiety that will be drained when the cloth_fibers is fully metabolized
	var/delayed_satiety_drain = 2 * CLOTHING_NUTRITION_GAIN

/datum/reagent/consumable/nutriment/cloth_fibers/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.satiety < MAX_SATIETY)
		affected_mob.adjust_nutrition(CLOTHING_NUTRITION_GAIN)
		delayed_satiety_drain += CLOTHING_NUTRITION_GAIN

/datum/reagent/consumable/nutriment/cloth_fibers/on_mob_delete(mob/living/carbon/affected_mob)
	. = ..()
	if(!iscarbon(affected_mob))
		return

	var/mob/living/carbon/carbon_mob = affected_mob
	carbon_mob.adjust_nutrition(-delayed_satiety_drain)

/datum/reagent/consumable/nutriment/mineral
	name = "Mineral Slurry-矿物浆"
	description = "矿物质被捣碎成糊状，只有当你也是由岩石构成时才有营养."
	color = COLOR_WEBSAFE_DARK_GRAY
	chemical_flags = NONE
	brute_heal = 0
	burn_heal = 0

/datum/reagent/consumable/nutriment/mineral/get_nutriment_factor(mob/living/carbon/eater)
	if(HAS_TRAIT(eater, TRAIT_ROCK_EATER))
		return ..()

	// You cannot eat rocks, it gives no nutrition
	return 0

/datum/reagent/consumable/sugar
	name = "Sugar-糖"
	description = "通常被称为食糖的有机化合物，有时也被称为蔗糖，这种白色无味的结晶粉末有一种令人愉悦的甜味."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_mult = 1.5 // stop sugar drowning out other flavours
	nutriment_factor = 2
	metabolization_rate = 5 * REAGENTS_METABOLISM
	creation_purity = 1 // impure base reagents are a big no-no
	overdose_threshold = 120 // Hyperglycaemic shock
	taste_description = "甜"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/sugar

// Plants should not have sugar, they can't use it and it prevents them getting water/ nutients, it is good for mold though...
/datum/reagent/consumable/sugar/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_weedlevel(rand(1, 2))
	mytray.adjust_pestlevel(rand(1, 2))

/datum/reagent/consumable/sugar/overdose_start(mob/living/affected_mob)
	. = ..()
	to_chat(affected_mob, span_userdanger("你会陷入高血糖休克!别再吃了!"))
	affected_mob.AdjustSleeping(20 SECONDS)

/datum/reagent/consumable/sugar/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_drowsiness_up_to((5 SECONDS * REM * seconds_per_tick), 60 SECONDS)

/datum/reagent/consumable/virus_food
	name = "Virus Food-病毒食品"
	description = "牛奶和水的混合物，病毒可以利用这种混合物进行繁殖."
	nutriment_factor = 2
	color = "#899613" // rgb: 137, 150, 19
	taste_description = "掺水牛奶"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// Compost for EVERYTHING
/datum/reagent/consumable/virus_food/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume * 0.5))

/datum/reagent/consumable/soysauce
	name = "Soysauce-酱油"
	description = "一种用大豆制成的咸调味汁."
	nutriment_factor = 2
	color = "#792300" // rgb: 121, 35, 0
	taste_description = "鲜味"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/soysauce

/datum/reagent/consumable/ketchup
	name = "Ketchup-番茄酱"
	description = "番茄酱，番茄酱，随便什么，这是番茄酱."
	nutriment_factor = 5
	color = "#731008" // rgb: 115, 16, 8
	taste_description = "番茄酱"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/ketchup

/datum/reagent/consumable/capsaicin
	name = "Capsaicin Oil-辣椒油"
	description = "这就是辣椒辣的原因."
	color = "#B31008" // rgb: 179, 16, 8
	taste_description = "辣椒"
	taste_mult = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/capsaicin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/heating = 0
	switch(current_cycle)
		if(1 to 15)
			heating = 5
			if(holder.has_reagent(/datum/reagent/cryostylane))
				holder.remove_reagent(/datum/reagent/cryostylane, 5 * REM * seconds_per_tick)
		if(15 to 25)
			heating = 10
		if(25 to 35)
			heating = 15
		if(35 to INFINITY)
			heating = 20
	affected_mob.adjust_bodytemperature(heating * TEMPERATURE_DAMAGE_COEFFICIENT * REM * seconds_per_tick)

/datum/reagent/consumable/frostoil
	name = "Frost Oil-霜油"
	description = "一种特殊的油，能明显地使身体降温，从特殊辣椒和史莱姆中提取."
	color = "#8BA6E9" // rgb: 139, 166, 233
	taste_description = "薄荷"
	ph = 13 //HMM! I wonder
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	///40 joules per unit.
	specific_heat = 40
	default_container = /obj/item/reagent_containers/cup/bottle/frostoil

/datum/reagent/consumable/frostoil/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/cooling = 0
	switch(current_cycle)
		if(1 to 15)
			cooling = -10
			if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
				holder.remove_reagent(/datum/reagent/consumable/capsaicin, 5 * REM * seconds_per_tick)
		if(15 to 25)
			cooling = -20
		if(25 to 35)
			cooling = -30
			if(prob(1))
				affected_mob.emote("shiver")
		if(35 to INFINITY)
			cooling = -40
			if(prob(5))
				affected_mob.emote("shiver")
	affected_mob.adjust_bodytemperature(cooling * TEMPERATURE_DAMAGE_COEFFICIENT * REM * seconds_per_tick, 50)

/datum/reagent/consumable/frostoil/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(reac_volume < 1)
		return
	if(isopenturf(exposed_turf))
		var/turf/open/exposed_open_turf = exposed_turf
		exposed_open_turf.MakeSlippery(wet_setting=TURF_WET_ICE, min_wet_time=100, wet_time_to_add=reac_volume SECONDS) // Is less effective in high pressure/high heat capacity environments. More effective in low pressure.
		var/temperature = exposed_open_turf.air.temperature
		var/heat_capacity = exposed_open_turf.air.heat_capacity()
		exposed_open_turf.air.temperature = max(exposed_open_turf.air.temperature - ((temperature - TCMB) * (heat_capacity * reac_volume * specific_heat) / (heat_capacity + reac_volume * specific_heat)) / heat_capacity, TCMB) // Exchanges environment temperature with reagent. Reagent is at 2.7K with a heat capacity of 40J per unit.
	if(reac_volume < 5)
		return
	for(var/mob/living/simple_animal/slime/exposed_slime in exposed_turf)
		exposed_slime.adjustToxLoss(rand(15,30))

/datum/reagent/consumable/condensedcapsaicin
	name = "Condensed Capsaicin-浓缩辣椒素"
	description = "一种用于自卫和警察工作的化学药剂."
	color = "#B31008" // rgb: 179, 16, 8
	taste_description = "灼烧的痛苦"
	penetrates_skin = NONE
	ph = 7.4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/bottle/capsaicin

/datum/reagent/consumable/condensedcapsaicin/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	if(!ishuman(exposed_mob))
		return

	var/mob/living/carbon/victim = exposed_mob
	if(methods & (TOUCH|VAPOR))
		//check for protection
		//actually handle the pepperspray effects
		if (!victim.is_pepper_proof()) // you need both eye and mouth protection
			if(prob(5))
				victim.emote("scream")
			victim.emote("cry")
			victim.set_eye_blur_if_lower(10 SECONDS)
			victim.adjust_temp_blindness(6 SECONDS)
			victim.set_confusion_if_lower(5 SECONDS)
			victim.Knockdown(3 SECONDS)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/reagent/pepperspray)
			addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/reagent/pepperspray), 10 SECONDS)
		victim.update_damage_hud()
	if(methods & INGEST)
		if(!holder.has_reagent(/datum/reagent/consumable/milk))
			if(prob(15))
				to_chat(exposed_mob, span_danger("[pick("你的头仿佛遭受了重击.", "你的嘴像着了火一样.", "你觉得头晕.")]"))
			if(prob(10))
				victim.set_eye_blur_if_lower(2 SECONDS)
			if(prob(10))
				victim.set_dizzy_if_lower(2 SECONDS)
			if(prob(5))
				victim.vomit(VOMIT_CATEGORY_DEFAULT)
	return ..()

/datum/reagent/consumable/condensedcapsaicin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!holder.has_reagent(/datum/reagent/consumable/milk))
		if(SPT_PROB(5, seconds_per_tick))
			affected_mob.visible_message(span_warning("[affected_mob] [pick("dry heaves!","coughs!","splutters!")]"))

/datum/reagent/consumable/salt
	name = "Table Salt-调味盐"
	description = "一种由氯化钠制成的盐，通常用于给食物调味."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	taste_description = "盐"
	penetrates_skin = NONE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/saltshaker

/datum/reagent/consumable/salt/expose_turf(turf/exposed_turf, reac_volume) //Creates an umbra-blocking salt pile
	. = ..()
	if(!istype(exposed_turf) || (reac_volume < 1))
		return
	exposed_turf.spawn_unique_cleanable(/obj/effect/decal/cleanable/food/salt)

/datum/reagent/consumable/salt/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	. = ..()
	if(!iscarbon(exposed_mob))
		return
	var/mob/living/carbon/carbies = exposed_mob
	if(!(methods & (PATCH|TOUCH|VAPOR)))
		return
	for(var/datum/wound/iter_wound as anything in carbies.all_wounds)
		iter_wound.on_salt(reac_volume, carbies)

// Salt can help with wounds by soaking up fluid, but undiluted salt will also cause irritation from the loose crystals, and it might soak up the body's water as well!
// A saltwater mixture would be best, but we're making improvised chems here, not real ones.
/datum/wound/proc/on_salt(reac_volume, mob/living/carbon/carbies)
	return

/datum/wound/pierce/bleed/on_salt(reac_volume, mob/living/carbon/carbies)
	adjust_blood_flow(-0.06 * reac_volume, initial_flow * 0.6) // 20u of a salt shacker * 0.1 = -1.6~ blood flow, but is always clamped to, at best, third blood loss from that wound.
	// Crystal irritation worsening recovery.
	gauzed_clot_rate *= 0.65
	to_chat(carbies, span_notice("盐粒渗入了[lowertext(src)], 疼痛地刺激皮肤，但吸收了大部分血液."))

/datum/wound/slash/flesh/on_salt(reac_volume, mob/living/carbon/carbies)
	adjust_blood_flow(-0.1 * reac_volume, initial_flow * 0.5) // 20u of a salt shacker * 0.1 = -2~ blood flow, but is always clamped to, at best, halve blood loss from that wound.
	// Crystal irritation worsening recovery.
	clot_rate *= 0.75
	to_chat(carbies, span_notice("盐粒渗入了[lowertext(src)], 疼痛地刺激皮肤，但吸收了大部分血液."))

/datum/wound/burn/flesh/on_salt(reac_volume)
	// Slightly sanitizes and disinfects, but also increases infestation rate (some bacteria are aided by salt), and decreases flesh healing (can damage the skin from moisture absorption)
	sanitization += VALUE_PER(0.4, 30) * reac_volume
	infestation -= max(VALUE_PER(0.3, 30) * reac_volume, 0)
	infestation_rate += VALUE_PER(0.12, 30) * reac_volume
	flesh_healing -= max(VALUE_PER(5, 30) * reac_volume, 0)
	to_chat(victim, span_notice("盐粒渗入了[lowertext(src)],疼痛刺激皮肤!过了一会儿，感觉稍微好了一点."))

/datum/reagent/consumable/blackpepper
	name = "Black Pepper-黑胡椒"
	description = "胡椒粉是由胡椒磨成的粉末. *AAAACHOOO*"
	reagent_state = SOLID
	// no color (ie, black)
	taste_description = "胡椒"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/peppermill

/datum/reagent/consumable/coco
	name = "Coco Powder-可可粉"
	description = "可可豆制成的油腻而苦的糊状物."
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "苦"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/garlic //NOTE: having garlic in your blood stops vampires from biting you.
	name = "Garlic Juice-蒜泥"
	description = "碎大蒜，厨师们喜欢它，但它会让你闻起来很糟糕."
	color = "#FEFEFE"
	taste_description = "garlic"
	metabolization_rate = 0.15 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/garlic/on_mob_add(mob/living/affected_mob, amount)
	. = ..()
	ADD_TRAIT(affected_mob, TRAIT_GARLIC_BREATH, type)

/datum/reagent/consumable/garlic/on_mob_delete(mob/living/affected_mob)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_GARLIC_BREATH, type)

/datum/reagent/consumable/garlic/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(isvampire(affected_mob)) //incapacitating but not lethal. Unfortunately, vampires cannot vomit.
		if(SPT_PROB(min((current_cycle-1)/2, 12.5), seconds_per_tick))
			to_chat(affected_mob, span_danger("你的鼻子闻不出大蒜外的味道!你几乎不能思考..."))
			affected_mob.Paralyze(10)
			affected_mob.set_jitter_if_lower(20 SECONDS)
	else
		var/obj/item/organ/internal/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
		if(liver && HAS_TRAIT(liver, TRAIT_CULINARY_METABOLISM))
			if(SPT_PROB(10, seconds_per_tick)) //stays in the system much longer than sprinkles/banana juice, so heals slower to partially compensate
				if(affected_mob.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
					return UPDATE_MOB_HEALTH

/datum/reagent/consumable/tearjuice
	name = "Tear Juice-催泪素"
	description = "从某些洋葱中提取的致盲物质."
	color = "#c0c9a0"
	taste_description = "苦"
	ph = 5

/datum/reagent/consumable/tearjuice/expose_mob(mob/living/exposed_mob, methods = INGEST, reac_volume)
	. = ..()
	if(!ishuman(exposed_mob))
		return

	var/mob/living/carbon/victim = exposed_mob
	if(methods & (TOUCH | VAPOR))
		var/tear_proof = victim.is_eyes_covered()
		if (!tear_proof)
			to_chat(exposed_mob, span_warning("你的眼睛刺痛!"))
			victim.emote("cry")
			victim.adjust_eye_blur(6 SECONDS)

/datum/reagent/consumable/sprinkles
	name = "Sprinkles-糖屑"
	description = "多色的小糖屑，常见于甜甜圈上，深受警察喜爱."
	color = "#FF00FF" // rgb: 255, 0, 255
	taste_description = "童趣"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/sprinkles/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/obj/item/organ/internal/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		if(affected_mob.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/enzyme
	name = "Universal Enzyme-通用酶"
	description = "一种用于制备某些化学品和食品的通用酶."
	color = "#365E30" // rgb: 54, 94, 48
	taste_description = "甜"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/enzyme

/datum/reagent/consumable/dry_ramen
	name = "Dry Ramen-干拉面"
	description = "太空时代的食物，含有干面、蔬菜和与水接触会沸腾的化学物质."
	reagent_state = SOLID
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "便宜的干面条"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/dry_ramen

/datum/reagent/consumable/hot_ramen
	name = "Hot Ramen-热拉面"
	description = "面条是煮过的，味道是人造的，就像回到学校一样."
	nutriment_factor = 5
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "便宜的热面条"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/dry_ramen

/datum/reagent/consumable/nutraslop
	name = "Nutraslop-自由糊"
	description = "前几天监狱里剩下的食物混合在一起."
	nutriment_factor = 5
	color = "#3E4A00" // rgb: 62, 74, 0
	taste_description = "你的牢笼"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/hot_ramen/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(10 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * seconds_per_tick, 0, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/hell_ramen
	name = "Hell Ramen-地狱拉面"
	description = "面条是煮过的，味道是人造的，就像回到学校一样."
	nutriment_factor = 5
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "在燃烧的便宜面条"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/hell_ramen/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_bodytemperature(10 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * seconds_per_tick)

/datum/reagent/consumable/flour
	name = "Flour-面粉"
	description = "这就是你用来装鬼的东西."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 0, 0, 0
	taste_description = "小麦粉"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_AFFECTS_WOUNDS
	default_container = /obj/item/reagent_containers/condiment/flour

/datum/reagent/consumable/flour/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	. = ..()
	if(!iscarbon(exposed_mob))
		return
	var/mob/living/carbon/carbies = exposed_mob
	if(!(methods & (PATCH|TOUCH|VAPOR)))
		return
	for(var/datum/wound/iter_wound as anything in carbies.all_wounds)
		iter_wound.on_flour(reac_volume, carbies)

/datum/wound/proc/on_flour(reac_volume, mob/living/carbon/carbies)
	return

/datum/wound/pierce/bleed/on_flour(reac_volume, mob/living/carbon/carbies)
	adjust_blood_flow(-0.015 * reac_volume) // 30u of a flour sack * 0.015 = -0.45~ blood flow, prettay good
	to_chat(carbies, span_notice("面粉渗进了[lowertext(src)], 痛苦地擦干伤口，吸收一些血液."))
	// When some nerd adds infection for wounds, make this increase the infection

/datum/wound/slash/flesh/on_flour(reac_volume, mob/living/carbon/carbies)
	adjust_blood_flow(-0.04 * reac_volume) // 30u of a flour sack * 0.04 = -1.25~ blood flow, pretty good!
	to_chat(carbies, span_notice("面粉渗进了[lowertext(src)], 痛苦地擦干伤口，吸收一些血液."))
	// When some nerd adds infection for wounds, make this increase the infection

// Don't pour flour onto burn wounds, it increases infection risk! Very unwise. Backed up by REAL info from REAL professionals.
// https://www.reuters.com/article/uk-factcheck-flour-burn-idUSKCN26F2N3
/datum/wound/burn/flesh/on_flour(reac_volume)
	to_chat(victim, span_notice("面粉渗进了[lowertext(src)], 让你痛不欲生!那可能不是个好主意..."))
	sanitization -= min(0, 1)
	infestation += 0.2
	return

/datum/reagent/consumable/flour/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(isspaceturf(exposed_turf))
		return

	var/obj/effect/decal/cleanable/food/flour/flour_decal = exposed_turf.spawn_unique_cleanable(/obj/effect/decal/cleanable/food/flour)
	if(flour_decal)
		flour_decal.reagents.add_reagent(/datum/reagent/consumable/flour, reac_volume)

/datum/reagent/consumable/cherryjelly
	name = "Cherry Jelly-樱桃果酱"
	description = "绝对是好东西，只能涂抹在食物上，具有极好的横向对称性."
	nutriment_factor = 10
	color = "#801E28" // rgb: 128, 30, 40
	taste_description = "樱桃"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/cherryjelly

/datum/reagent/consumable/bluecherryjelly
	name = "Blue Cherry Jelly-蓝樱桃果酱"
	description = "蓝色的更美味的樱桃果冻."
	color = "#00F0FF"
	taste_description = "蓝樱桃"

/datum/reagent/consumable/rice
	name = "Rice-米"
	description = "小米粒们"
	reagent_state = SOLID
	nutriment_factor = 3
	color = "#FFFFFF" // rgb: 0, 0, 0
	taste_description = "米"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/rice

/datum/reagent/consumable/rice_flour
	name = "Rice Flour-米粉"
	description = "面粉混着米粉？"
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 0, 0, 0
	taste_description = "小麦混米粉"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/vanilla
	name = "Vanilla Powder-香草粉"
	description = "香草豆荚制成的油腻而苦的糊状物."
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#FFFACD"
	taste_description = "香草"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/eggyolk
	name = "Egg Yolk-蛋黄"
	description = "它富含蛋白质."
	nutriment_factor = 8
	color = "#FFB500"
	taste_description = "鸡蛋黄"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/eggwhite
	name = "Egg White-蛋白"
	description = "它含有更多的蛋白质."
	nutriment_factor = 4
	color = "#fffdf7"
	taste_description = "蛋白"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/corn_starch
	name = "Corn Starch-玉米淀粉"
	description = "狡猾的解决方案."
	color = "#DBCE95"
	taste_description = "黏糊糊"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_AFFECTS_WOUNDS

// Starch has similar absorbing properties to flour (Stronger here because it's rarer)
/datum/reagent/consumable/corn_starch/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	. = ..()
	if(!iscarbon(exposed_mob))
		return
	var/mob/living/carbon/carbies = exposed_mob
	if(!(methods & (PATCH|TOUCH|VAPOR)))
		return
	for(var/datum/wound/iter_wound as anything in carbies.all_wounds)
		iter_wound.on_starch(reac_volume, carbies)

/datum/wound/proc/on_starch(reac_volume, mob/living/carbon/carbies)
	return

/datum/wound/pierce/bleed/on_starch(reac_volume, mob/living/carbon/carbies)
	adjust_blood_flow(-0.03 * reac_volume)
	to_chat(carbies, span_notice("粘稠的淀粉渗入了[lowertext(src)], 痛苦地擦干伤口，吸了一点血."))
	// When some nerd adds infection for wounds, make this increase the infection
	return

/datum/wound/slash/flesh/on_starch(reac_volume, mob/living/carbon/carbies)
	adjust_blood_flow(-0.06 * reac_volume)
	to_chat(carbies, span_notice("粘稠的淀粉渗入了[lowertext(src)], 痛苦地擦干伤口，吸了一点血."))
	// When some nerd adds infection for wounds, make this increase the infection
	return

/datum/wound/burn/flesh/on_starch(reac_volume, mob/living/carbon/carbies)
	to_chat(carbies, span_notice("粘稠的淀粉渗入了[lowertext(src)], 让你痛不欲生!那可能不是个好主意..."))
	sanitization -= min(0, 0.5)
	infestation += 0.1
	return

/datum/reagent/consumable/corn_syrup
	name = "Corn Syrup-玉米糖浆"
	description = "腐烂成糖."
	color = "#DBCE95"
	metabolization_rate = 3 * REAGENTS_METABOLISM
	taste_description = "很甜的黏糊糊"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/corn_syrup/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	holder.add_reagent(/datum/reagent/consumable/sugar, 3 * REM * seconds_per_tick)

/datum/reagent/consumable/honey
	name = "Honey-蜂蜜"
	description = "甜的甜的蜂蜜会腐烂成糖，具有抗菌和自然愈合的特性."
	color = "#d3a308"
	nutriment_factor = 15
	metabolization_rate = 1 * REAGENTS_METABOLISM
	taste_description = "甜蜜"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/honey

// On the other hand, honey has been known to carry pollen with it rarely. Can be used to take in a lot of plant qualities all at once, or harm the plant.
/datum/reagent/consumable/honey/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	if(!isnull(mytray.myseed) && prob(20))
		mytray.pollinate(range = 1)
		return

	mytray.adjust_weedlevel(rand(1, 2))
	mytray.adjust_pestlevel(rand(1, 2))

/datum/reagent/consumable/honey/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	holder.add_reagent(/datum/reagent/consumable/sugar, 3 * REM * seconds_per_tick)
	var/need_mob_update
	if(SPT_PROB(33, seconds_per_tick))
		need_mob_update = affected_mob.adjustBruteLoss(-1, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += affected_mob.adjustFireLoss(-1, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += affected_mob.adjustOxyLoss(-1, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += affected_mob.adjustToxLoss(-1, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/honey/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!iscarbon(exposed_mob) || !(methods & (TOUCH|VAPOR|PATCH)))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	for(var/datum/surgery/surgery as anything in exposed_carbon.surgeries)
		surgery.speed_modifier = max(0.6, surgery.speed_modifier)

/datum/reagent/consumable/mayonnaise
	name = "Mayonnaise-蛋黄酱"
	description = "蛋黄混合成的白色和油性混合物."
	color = "#DFDFDF"
	taste_description = "mayonnaise"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/mayonnaise

/datum/reagent/consumable/mold // yeah, ok, togopal, I guess you could call that a condiment
	name = "Mold-霉菌"
	description = "这种东西能使任何食物发霉，或者你的胃."
	color ="#708a88"
	taste_description = "令人作呕的真菌"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/eggrot
	name = "Rotten Eggyolk-臭鸡蛋"
	description = "闻起来太难闻了."
	color ="#708a88"
	taste_description = "臭鸡蛋"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/nutriment/stabilized
	name = "Stabilized Nutriment-人工蛋白"
	description = "一种生物工程蛋白质营养结构，设计在高饱和度下分解，通俗地说，它不会让你发胖."
	reagent_state = SOLID
	nutriment_factor = 15
	color = "#664330" // rgb: 102, 67, 48
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/nutriment/stabilized/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.nutrition > NUTRITION_LEVEL_FULL - 25)
		affected_mob.adjust_nutrition(-3 * REM * get_nutriment_factor(affected_mob) * seconds_per_tick)

////Lavaland Flora Reagents////


/datum/reagent/consumable/entpoly
	name = "Entropic Polypnium-蘑菇灵液"
	description = "从某种蘑菇中提取的液体会让人难受."
	color = "#1d043d"
	taste_description = "苦蘑菇"
	ph = 12
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/entpoly/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	if(current_cycle > 10)
		affected_mob.Unconscious(40 * REM * seconds_per_tick, FALSE)
	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.losebreath += 4
		affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM, 150, affected_biotype)
		affected_mob.adjustToxLoss(3*REM, updating_health = FALSE, required_biotype = affected_biotype)
		affected_mob.adjustStaminaLoss(10*REM, updating_stamina = FALSE, required_biotype = affected_biotype)
		affected_mob.set_eye_blur_if_lower(10 SECONDS)
		need_mob_update = TRUE
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/tinlux
	name = "Tinea Luxor-卢克索光癣"
	description = "一种能使发光真菌在皮肤上生长的刺激性物质. "
	color = "#b5a213"
	taste_description = "刺痛蘑菇"
	ph = 11.2
	self_consuming = TRUE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_DEAD_PROCESS

/datum/reagent/consumable/tinlux/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!exposed_mob.reagents) // they won't process the reagent, but still benefit from its effects for a duration.
		var/amount = round(reac_volume * clamp(1 - touch_protection, 0, 1))
		var/duration = (amount / metabolization_rate) * SSmobs.wait
		if(duration > 1 SECONDS)
			exposed_mob.adjust_timed_status_effect(duration, /datum/status_effect/tinlux_light)

/datum/reagent/consumable/tinlux/on_mob_add(mob/living/living_mob)
	. = ..()
	living_mob.apply_status_effect(/datum/status_effect/tinlux_light) //infinite duration

/datum/reagent/consumable/tinlux/on_mob_delete(mob/living/living_mob)
	. = ..()
	living_mob.remove_status_effect(/datum/status_effect/tinlux_light)

/datum/reagent/consumable/vitfro
	name = "Vitrium Froth-维生泡沫"
	description = "一种能愈合皮肤伤口的泡沫膏."
	color = "#d3a308"
	nutriment_factor = 3
	taste_description = "新鲜的蘑菇"
	ph = 10.4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/vitfro/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	if(SPT_PROB(55, seconds_per_tick))
		need_mob_update = affected_mob.adjustBruteLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += affected_mob.adjustFireLoss(-1 * REM * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/liquidelectricity
	name = "Liquid Electricity-液体电"
	description = "Ethereals的血，还有让他们活下去的元素，对他们来说很好，对其他人来说很可怕."
	nutriment_factor = 5
	color = "#97ee63"
	taste_description = "纯净电"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/liquidelectricity/enriched
	name = "浓缩液体电"

/datum/reagent/consumable/liquidelectricity/enriched/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume) //can't be on life because of the way blood works.
	. = ..()
	if(!(methods & (INGEST|INJECT|PATCH)) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/obj/item/organ/internal/stomach/ethereal/stomach = exposed_carbon.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		stomach.adjust_charge(reac_volume * 30)

/datum/reagent/consumable/liquidelectricity/enriched/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(isethereal(affected_mob))
		affected_mob.blood_volume += 1 * seconds_per_tick
	else if(SPT_PROB(10, seconds_per_tick)) //lmao at the newbs who eat energy bars
		affected_mob.electrocute_act(rand(5,10), "液体电在其身体里", 1, SHOCK_NOGLOVES) //the shock is coming from inside the house
		playsound(affected_mob, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/datum/reagent/consumable/astrotame
	name = "Astrotame-甜味剂"
	description = "太空时代的人造甜味剂."
	nutriment_factor = 0
	metabolization_rate = 2 * REAGENTS_METABOLISM
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_mult = 8
	taste_description = "甜味"
	overdose_threshold = 17
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/astrotame/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.disgust < 80)
		affected_mob.adjust_disgust(10 * REM * seconds_per_tick)

/datum/reagent/consumable/secretsauce
	name = "Secret Sauce-秘制酱"
	description = "是什么呢?"
	nutriment_factor = 2
	color = "#792300"
	taste_description = "难以形容的味道"
	quality = FOOD_AMAZING
	taste_mult = 100
	ph = 6.1

/datum/reagent/consumable/nutriment/peptides
	name = "Peptides-修复肽"
	color = "#BBD4D9"
	taste_description = "薄荷结霜"
	description = "这些修复肽不仅加速伤口愈合，而且营养丰富!"
	nutriment_factor = 10 // 33% less than nutriment to reduce weight gain
	brute_heal = 3
	burn_heal = 1
	inverse_chem = /datum/reagent/peptides_failed//should be impossible, but it's so it appears in the chemical lookup gui
	inverse_chem_val = 0.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/caramel
	name = "Caramel-焦糖"
	description = "谁能想到加热过的糖会如此美味呢?"
	nutriment_factor = 10
	color = "#D98736"
	taste_mult = 2
	taste_description = "焦糖"
	reagent_state = SOLID
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/char
	name = "Char-烧烤渣"
	description = "烧烤后的精华，过量服用后有奇怪的效果."
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#C8C8C8"
	taste_mult = 6
	taste_description = "焦糊"
	overdose_threshold = 15
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/char/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(13, seconds_per_tick))
		affected_mob.say(pick_list_replacements(BOOMER_FILE, "boomer"), forced = /datum/reagent/consumable/char)

/datum/reagent/consumable/bbqsauce
	name = "BBQ Sauce-烧烤酱"
	description = "甜的，烟熏的，咸味的，什么都有，非常适合烧烤."
	nutriment_factor = 5
	color = "#78280A" // rgb: 120 40, 10
	taste_mult = 2.5 //sugar's 1.5, capsacin's 1.5, so a good middle ground.
	taste_description = "烧烤酱"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/bbqsauce

/datum/reagent/consumable/chocolatepudding
	name = "Chocolate Pudding-巧克力布丁"
	description = "巧克力爱好者的好甜点."
	color = "#800000"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4
	taste_description = "甜巧克力"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/glass_style/drinking_glass/chocolatepudding
	required_drink_type = /datum/reagent/consumable/chocolatepudding
	name = "chocolate pudding-巧克力布丁"
	desc = "人间美味."
	icon = 'icons/obj/drinks/shakes.dmi'
	icon_state = "chocolatepudding"

/datum/reagent/consumable/vanillapudding
	name = "Vanilla Pudding-香草布丁"
	description = "香草爱好者的好甜点."
	color = "#FAFAD2"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4
	taste_description = "甜甜的香草"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/vanillapudding
	required_drink_type = /datum/reagent/consumable/vanillapudding
	name = "vanilla pudding-香草布丁"
	desc = "人间美味."
	icon = 'icons/obj/drinks/shakes.dmi'
	icon_state = "vanillapudding"

/datum/reagent/consumable/laughsyrup
	name = "Laughin' Syrup-笑糖浆"
	description = "笑豆榨汁的产物，嘶嘶作响，而且似乎根据它的用途而改变味道!"
	color = "#803280"
	nutriment_factor = 5
	taste_mult = 2
	taste_description = "碳酸甜蜜"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/gravy
	name = "Gravy-肉汁"
	description = "面粉、水和煮熟的肉的汁液的混合物."
	taste_description = "肉汁"
	color = "#623301"
	taste_mult = 1.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/pancakebatter
	name = "Pancake Batter-薄饼面糊"
	description = "一种乳白色的面糊，在煎锅上放5个单位的这个，就能做成一个美味的煎饼."
	taste_description = "乳白色的面糊"
	color = "#fccc98"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/korta_flour
	name = "Korta Flour-科塔尔面粉"
	description = "一种用科塔尔坚果壳制成的粗磨粉."
	taste_description = "朴实粗糙"
	color = "#EEC39A"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/korta_milk
	name = "Korta Milk-科塔尔奶"
	description = "一种乳白色的液体，由碾碎坚果的中心制成."
	taste_description = "甜牛奶"
	color = "#FFFFFF"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/korta_nectar
	name = "Korta Nectar-科塔尔蜜"
	description = "一种甜的、含糖的糖浆，由碾碎的甜科尔塔坚果制成."
	color = "#d3a308"
	nutriment_factor = 5
	metabolization_rate = 1 * REAGENTS_METABOLISM
	taste_description = "peppery sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/whipped_cream
	name = "Whipped Cream-鲜奶油"
	description = "通过快速搅拌将空气混入其中的浓厚奶油."
	color = "#efeff0"
	nutriment_factor = 4
	taste_description = "鲜奶油"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/peanut_butter
	name = "Peanut Butter-花生酱"
	description = "一种由花生研磨而成的浓郁的酱."
	taste_description = "peanuts"
	reagent_state = SOLID
	color = "#D9A066"
	nutriment_factor = 15
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/peanut_butter

/datum/reagent/consumable/peanut_butter/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired) //ET loves peanut butter
	. = ..()
	if(isabductor(affected_mob))
		affected_mob.add_mood_event("ET_pieces", /datum/mood_event/et_pieces, name)
		affected_mob.set_drugginess(30 SECONDS * REM * seconds_per_tick)

/datum/reagent/consumable/vinegar
	name = "Vinegar-醋"
	description = "用于腌制，或放在薯片上."
	taste_description = "acid"
	color = "#661F1E"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/vinegar

/datum/reagent/consumable/cornmeal
	name = "Cornmeal-玉米粉"
	description = "磨碎的玉米粉，用来做玉米相关的东西."
	taste_description = "生玉米粉"
	color = "#ebca85"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/cornmeal

/datum/reagent/consumable/yoghurt
	name = "Yoghurt-酸奶"
	description = "乳状天然酸奶，在食品和饮料中都有应用."
	taste_description = "yoghurt"
	color = "#efeff0"
	nutriment_factor = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/yoghurt

/datum/reagent/consumable/cornmeal_batter
	name = "Cornmeal Batter-玉米糊"
	description = "一种鸡蛋味、乳白色、玉米粉的混合物，生吃不太好."
	taste_description = "生玉米糊"
	color = "#ebca85"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/olivepaste
	name = "Olive Paste-橄榄酱"
	description = "一堆细碎的橄榄."
	taste_description = "mushy olives"
	color = "#adcf77"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/creamer
	name = "Coffee Creamer-咖啡奶油"
	description = "廉价咖啡的奶粉，多么令人愉快."
	taste_description = "milk"
	color = "#efeff0"
	nutriment_factor = 1.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/creamer

/datum/reagent/consumable/mintextract
	name = "Mint Extract-薄荷提取物"
	description = "对付不受欢迎的顾客很有用。"
	color = "#CF3600" // rgb: 207, 54, 0
	taste_description = "薄荷"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/mintextract/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(HAS_TRAIT(affected_mob, TRAIT_FAT))
		affected_mob.investigate_log("has been gibbed by consuming [src] while fat.", INVESTIGATE_DEATHS)
		affected_mob.inflate_gib()

/datum/reagent/consumable/worcestershire
	name = "Worcestershire Sauce-伍斯特郡酱油"
	description = "也叫伍斯特沙司."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#572b26"
	taste_description = "甜味的鱼"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/worcestershire

/datum/reagent/consumable/red_bay
	name = "Red Bay Seasoning-红湾香料"
	description = "这是一种香草和香料的秘密混合物，至少对火星人来说是这样."
	color = "#8E4C00"
	taste_description = "香料"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/red_bay

/datum/reagent/consumable/curry_powder
	name = "Curry Powder-咖喱粉"
	description = "人类最常见的香料之一，通常用来做咖喱."
	color = "#F6C800"
	taste_description = "干咖喱"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/curry_powder

/datum/reagent/consumable/dashi_concentrate
	name = "Dashi Concentrate-鱼汤宝"
	description = "一种浓缩的鱼汤，以1:8的比例加水炖出美味的鱼汤."
	color = "#372926"
	taste_description = "极鲜"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/dashi_concentrate

/datum/reagent/consumable/martian_batter
	name = "Martian Batter-火星面糊"
	description = "一种用鱼粉和面粉制成的厚面糊，用于制作日式烧和章鱼烧等菜肴."
	color = "#D49D26"
	taste_description = "鲜味面糊"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/grounding_solution
	name = "Grounding Solution-绝缘剂"
	description = "这是一种食品安全的离子溶液，旨在中和神秘的“液态电”，在接触时形成无害的盐."
	color = "#efeff0"
	taste_description = "金属盐"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
