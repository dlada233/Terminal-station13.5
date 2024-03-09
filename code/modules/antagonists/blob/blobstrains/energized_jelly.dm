//does tons of oxygen damage and a little stamina, immune to tesla bolts, weak to EMP
/datum/blobstrain/reagent/energized_jelly
	name = "高能胶质"
	description = "造成高额耐力和中等程度窒息伤害，并导致目标无法呼吸."
	effectdesc = "对于电流有良好的传导能力，但也会受到EMP的伤害."
	analyzerdescdamage = "造成高额耐力和中等程度窒息伤害，并阻碍目标的呼吸."
	analyzerdesceffect = "优异的导电性使其免疫电击，但缺乏对EMP的抗性."
	color = "#EFD65A"
	complementary_color = "#00E5B1"
	reagent = /datum/reagent/blob/energized_jelly

/datum/blobstrain/reagent/energized_jelly/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag)
	if((damage_flag == MELEE || damage_flag == BULLET || damage_flag == LASER) && B.get_integrity() - damage <= 0 && prob(10))
		do_sparks(rand(2, 4), FALSE, B)
	return ..()

/datum/blobstrain/reagent/energized_jelly/tesla_reaction(obj/structure/blob/B, power)
	return FALSE

/datum/blobstrain/reagent/energized_jelly/emp_reaction(obj/structure/blob/B, severity)
	var/damage = rand(30, 50) - severity * rand(10, 15)
	B.take_damage(damage, BURN, ENERGY)

/datum/reagent/blob/energized_jelly
	name = "高能真菌胶质"
	taste_description = "明胶"
	color = "#EFD65A"

/datum/reagent/blob/energized_jelly/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	. = ..()
	reac_volume = return_mob_expose_reac_volume(exposed_mob, methods, reac_volume, show_message, touch_protection, overmind)
	exposed_mob.losebreath += round(0.2*reac_volume)
	exposed_mob.adjustStaminaLoss(reac_volume * 1.2)
	if(exposed_mob)
		exposed_mob.apply_damage(0.6*reac_volume, OXY)
