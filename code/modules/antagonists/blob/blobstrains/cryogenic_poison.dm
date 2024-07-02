//does brute, burn, and toxin damage, and cools targets down
/datum/blobstrain/reagent/cryogenic_poison
	name = "低温毒素"
	description = "会给目标注射一种冰冻毒素，起初只造成很小的冲击，但随着时间的推移将产生高额伤害."
	analyzerdescdamage = "给目标注射一种冰冻毒素，逐渐凝固目标的体内器官."
	color = "#8BA6E9"
	complementary_color = "#7D6EB4"
	blobbernaut_message = "注射"
	message = "真菌体刺痛了你"
	message_living = "，你感觉自己体内在凝固成一团."
	reagent = /datum/reagent/blob/cryogenic_poison

/datum/reagent/blob/cryogenic_poison
	name = "低温毒素"
	description = "会给目标注射一种冰冻毒素，并在一段时间内产生高额伤害."
	color = "#8BA6E9"
	taste_description = "脑冻"

/datum/reagent/blob/cryogenic_poison/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	. = ..()
	reac_volume = return_mob_expose_reac_volume(exposed_mob, methods, reac_volume, show_message, touch_protection, overmind)
	if(exposed_mob.reagents)
		exposed_mob.reagents.add_reagent(/datum/reagent/consumable/frostoil, 0.3*reac_volume)
		exposed_mob.reagents.add_reagent(/datum/reagent/consumable/ice, 0.3*reac_volume)
		exposed_mob.reagents.add_reagent(/datum/reagent/blob/cryogenic_poison, 0.3*reac_volume)
	exposed_mob.apply_damage(0.2*reac_volume, BRUTE, wound_bonus=CANT_WOUND)

/datum/reagent/blob/cryogenic_poison/on_mob_life(mob/living/carbon/exposed_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	need_mob_update = exposed_mob.adjustBruteLoss(0.5 * REM * seconds_per_tick, updating_health = FALSE)
	need_mob_update += exposed_mob.adjustFireLoss(0.5 * REM * seconds_per_tick, updating_health = FALSE)
	need_mob_update += exposed_mob.adjustToxLoss(0.5 * REM * seconds_per_tick, updating_health = FALSE)
	if(need_mob_update)
		. = UPDATE_MOB_HEALTH
