//does low brute damage, oxygen damage, and stamina damage and wets tiles when damaged
/datum/blobstrain/reagent/pressurized_slime
	name = "受压黏液"
	description = "造成较低的创伤和窒息伤害，较高的耐力伤害，并使目标脚下的地块变得湿滑."
	effectdesc = "也会使被攻击的真菌体附近的地块变得很湿滑."
	analyzerdescdamage = "造成较低的创伤和窒息伤害，较高的耐力伤害，并使目标脚下的地块变得湿滑，同时也会扑灭上面的火焰；此外自身对创伤具有一定的抗性."
	analyzerdesceffect = "当被攻击或杀死时，会使附近的地块湿滑，同时扑灭上面的任何东西."
	color = "#AAAABB"
	complementary_color = "#BBBBAA"
	blobbernaut_message = "放出黏液对"
	message = "真菌体溅射液体到你的身上"
	message_living = "，你感到喘不过气来"
	reagent = /datum/reagent/blob/pressurized_slime

/datum/blobstrain/reagent/pressurized_slime/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag)
	if((damage_flag == MELEE || damage_flag == BULLET || damage_flag == LASER) || damage_type != BURN)
		extinguisharea(B, damage)
	if(damage_type == BRUTE)
		return damage * 0.5
	return ..()

/datum/blobstrain/reagent/pressurized_slime/death_reaction(obj/structure/blob/B, damage_flag)
	if(damage_flag == MELEE || damage_flag == BULLET || damage_flag == LASER)
		B.visible_message(span_boldwarning("真菌体破裂，液体喷溅到这个区域!"))
		extinguisharea(B, 50)

/datum/blobstrain/reagent/pressurized_slime/proc/extinguisharea(obj/structure/blob/B, probchance)
	for(var/turf/open/T in range(1, B))
		if(prob(probchance))
			T.MakeSlippery(TURF_WET_LUBE, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)
			for(var/obj/O in T)
				O.extinguish()
			for(var/mob/living/L in T)
				L.adjust_wet_stacks(2.5)
				L.extinguish_mob()

/datum/reagent/blob/pressurized_slime
	name = "受压黏液"
	taste_description = "一块海绵"
	color = "#AAAABB"

/datum/reagent/blob/pressurized_slime/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	. = ..()
	reac_volume = return_mob_expose_reac_volume(exposed_mob, methods, reac_volume, show_message, touch_protection, overmind)
	var/turf/open/location_turf = get_turf(exposed_mob)
	if(istype(location_turf) && prob(reac_volume))
		location_turf.MakeSlippery(TURF_WET_LUBE, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)
		exposed_mob.adjust_wet_stacks(reac_volume / 10)
	exposed_mob.apply_damage(0.4*reac_volume, BRUTE, wound_bonus=CANT_WOUND)
	if(exposed_mob)
		exposed_mob.adjustStaminaLoss(reac_volume, FALSE)
		exposed_mob.apply_damage(0.4 * reac_volume, OXY)
