//does brute damage through armor and bio resistance
/datum/blobstrain/reagent/reactive_spines
	name = "反应性尖刺"
	description = "造成高额的能穿透护甲与生物防护的穿甲创伤."
	effectdesc = "当受到烧伤或创伤时会对近战范围内的所有东西做出攻击反应."
	analyzerdescdamage = "造成无视护甲和生物防护的高额创伤."
	analyzerdesceffect = "当受到烧伤或创伤时会猛烈地攻击周围的一切."
	color = "#9ACD32"
	complementary_color = "#FFA500"
	blobbernaut_message = "刺向"
	message = "真菌体刺向了你"
	reagent = /datum/reagent/blob/reactive_spines
	COOLDOWN_DECLARE(retaliate_cooldown)

/datum/blobstrain/reagent/reactive_spines/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag)
	if(damage && ((damage_type == BRUTE) || (damage_type == BURN)) && B.get_integrity() - damage > 0 && COOLDOWN_FINISHED(src, retaliate_cooldown)) // Is there any damage, is it burn or brute, will we be alive, and has the cooldown finished?
		COOLDOWN_START(src, retaliate_cooldown, 2.5 SECONDS) // 2.5 seconds before auto-retaliate can whack everything within 1 tile again
		B.visible_message(span_boldwarning("真菌体进行了报复性打击!"))
		for(var/atom/thing in range(1, B))
			if(!thing.can_blob_attack())
				continue
			var/attacked_turf = get_turf(thing)
			if(isliving(thing) && !HAS_TRAIT(thing, TRAIT_BLOB_ALLY)) // Make sure to inject strain-reagents with automatic attacks when needed.
				B.blob_attack_animation(attacked_turf, overmind)
				attack_living(thing)

			else if(thing.blob_act(B)) // After checking for mobs, whack everything else with the standard attack
				B.blob_attack_animation(attacked_turf, overmind) // Only play the animation if the attack did something meaningful

	return ..()

/datum/reagent/blob/reactive_spines
	name = "反应性尖刺"
	taste_description = "岩石"
	color = "#9ACD32"

/datum/reagent/blob/reactive_spines/return_mob_expose_reac_volume(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	if(exposed_mob.stat == DEAD || HAS_TRAIT(exposed_mob, TRAIT_BLOB_ALLY))
		return 0 //the dead, and blob mobs, don't cause reactions
	return reac_volume

/datum/reagent/blob/reactive_spines/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	. = ..()
	reac_volume = return_mob_expose_reac_volume(exposed_mob, methods, reac_volume, show_message, touch_protection, overmind)
	exposed_mob.adjustBruteLoss(reac_volume)
