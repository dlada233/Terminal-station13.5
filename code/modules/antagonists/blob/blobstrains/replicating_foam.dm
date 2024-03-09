/datum/blobstrain/reagent/replicating_foam
	name = "复制泡沫"
	description = "将造成中等程度的创伤，在扩张时偶尔会再次扩张一次."
	shortdesc = "将造成中等程度的创伤."
	effectdesc = "当受到烧伤时也会扩张，但也会受到更多的创伤."
	color = "#7B5A57"
	complementary_color = "#57787B"
	analyzerdescdamage = "造成中等程度的创伤."
	analyzerdesceffect = "当受到烧伤时扩张，在扩张时偶尔会再次扩张一次，对创伤没有抗性."
	reagent = /datum/reagent/blob/replicating_foam


/datum/blobstrain/reagent/replicating_foam/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag)
	if(damage_type == BRUTE)
		damage = damage * 2
	else if(damage_type == BURN && damage > 0 && B.get_integrity() - damage > 0 && prob(60))
		var/obj/structure/blob/newB = B.expand(null, null, 0)
		if(newB)
			newB.update_integrity(B.get_integrity() - damage)
			newB.update_appearance()
	return ..()


/datum/blobstrain/reagent/replicating_foam/expand_reaction(obj/structure/blob/B, obj/structure/blob/newB, turf/T, mob/camera/blob/O)
	if(prob(30))
		newB.expand(null, null, 0) //do it again!

/datum/reagent/blob/replicating_foam
	name = "复制泡沫"
	taste_description = "复制"
	color = "#7B5A57"

/datum/reagent/blob/replicating_foam/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	. = ..()
	reac_volume = return_mob_expose_reac_volume(exposed_mob, methods, reac_volume, show_message, touch_protection, overmind)
	exposed_mob.apply_damage(0.7*reac_volume, BRUTE, wound_bonus=CANT_WOUND)
