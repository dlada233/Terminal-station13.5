/obj/projectile/energy/flora
	damage = 0
	damage_type = TOX
	armor_flag = ENERGY

/obj/projectile/energy/flora/on_hit(atom/target, blocked, pierce_hit)
	if(!isliving(target))
		return ..()

	var/mob/living/hit_plant = target
	if(!(hit_plant.mob_biotypes & MOB_PLANT))
		hit_plant.show_message(span_notice("辐射束会在你体内无害地消散."))
		return BULLET_ACT_BLOCK

	. = ..()
	if(. == BULLET_ACT_HIT && blocked < 100)
		on_hit_plant_effect(target)

	return .

/// Called when we hit a mob with plant biotype
/obj/projectile/energy/flora/proc/on_hit_plant_effect(mob/living/hit_plant)
	return

/obj/projectile/energy/flora/mut
	name = "阿尔法植物细胞"
	icon_state = "energy"

/obj/projectile/energy/flora/mut/on_hit_plant_effect(mob/living/hit_plant)
	if(prob(85))
		hit_plant.adjustFireLoss(rand(5, 15))
		hit_plant.show_message(span_userdanger("辐射束将灼烧你!"))
		return

	hit_plant.adjustToxLoss(rand(3, 6))
	hit_plant.Paralyze(10 SECONDS)
	hit_plant.visible_message(
		span_warning("[hit_plant.p_their()]液泡沸腾时，[hit_plant]痛苦地扭动."),
		span_userdanger("当你的液泡沸腾时，你痛苦地扭动!"),
		span_hear("你听到树叶的嘎吱声."),
	)
	if(iscarbon(hit_plant) && hit_plant.has_dna())
		var/mob/living/carbon/carbon_plant = hit_plant
		if(prob(80))
			carbon_plant.easy_random_mutate(NEGATIVE + MINOR_NEGATIVE)
		else
			carbon_plant.easy_random_mutate(POSITIVE)
		carbon_plant.random_mutate_unique_identity()
		carbon_plant.random_mutate_unique_features()
		carbon_plant.domutcheck()

/obj/projectile/energy/flora/yield
	name = "贝塔植物细胞"
	icon_state = "energy2"

/obj/projectile/energy/flora/yield/on_hit_plant_effect(mob/living/hit_plant)
	hit_plant.set_nutrition(min(hit_plant.nutrition + 30, NUTRITION_LEVEL_FULL))

/obj/projectile/energy/flora/evolution
	name = "伽马植物细胞"
	icon_state = "energy3"

/obj/projectile/energy/flora/evolution/on_hit_plant_effect(mob/living/hit_plant)
	hit_plant.show_message(span_notice("辐射束会让你迷失方向!"))
	hit_plant.set_dizzy_if_lower(30 SECONDS)
	hit_plant.emote("flip")
	hit_plant.emote("spin")
