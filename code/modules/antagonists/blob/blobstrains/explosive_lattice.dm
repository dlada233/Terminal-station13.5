//does aoe brute damage when hitting targets, is immune to explosions
/datum/blobstrain/reagent/explosive_lattice
	name = "爆炸网格"
	description = "攻击时引发小范围爆炸，对附近的所有人造成中等程度的创伤烧伤混合伤害，并且真菌体在死亡时将会爆炸."
	effectdesc = "自身可以抵抗爆炸伤害，但将受到来自火和能量武器的更多伤害."
	analyzerdescdamage = "在目标周围引发小范围的爆炸，造成中等程度的创伤和烧伤，并且真菌体在死亡时将会爆炸."
	analyzerdesceffect = "自身对爆炸伤害具有强抗性，但将受到来自火和能量武器的更多伤害."
	color = "#8B2500"
	complementary_color = "#00668B"
	blobbernaut_message = "引发爆炸对"
	message = "真菌体在你周围引发爆炸"
	reagent = /datum/reagent/blob/explosive_lattice

/datum/blobstrain/reagent/explosive_lattice/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag)
	if(damage_flag == BOMB)
		return 0
	else if(damage_flag != MELEE && damage_flag != BULLET && damage_flag != LASER)
		return damage * 1.5
	return ..()

/datum/blobstrain/reagent/explosive_lattice/on_sporedeath(mob/living/spore)
	var/obj/effect/temp_visual/explosion/fast/effect = new /obj/effect/temp_visual/explosion/fast(get_turf(spore))
	effect.alpha = 150
	for(var/mob/living/actor in orange(get_turf(spore), 1))
		if(ROLE_BLOB in actor.faction) // No friendly fire
			continue
		actor.take_overall_damage(10, 10)

/datum/reagent/blob/explosive_lattice
	name = "爆炸网格"
	taste_description = "炸弹"
	color = "#8B2500"

/datum/reagent/blob/explosive_lattice/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	. = ..()
	var/brute_loss = 0
	var/burn_loss = 0
	var/bomb_armor = 0
	reac_volume = return_mob_expose_reac_volume(exposed_mob, methods, reac_volume, show_message, touch_protection, overmind)

	if(reac_volume >= 10) // If it's not coming from a sporecloud, AOE 'explosion' damage
		var/epicenter_turf = get_turf(exposed_mob)
		var/obj/effect/temp_visual/explosion/fast/ex_effect = new /obj/effect/temp_visual/explosion/fast(get_turf(exposed_mob))
		ex_effect.alpha = 150

		// Total damage to epicenter mob of 0.7*reac_volume, like a mid-tier strain
		brute_loss = reac_volume*0.35

		bomb_armor = exposed_mob.getarmor(null, BOMB)
		if(bomb_armor) // Same calculation and proc that ex_act uses on mobs
			brute_loss = brute_loss*(2 - round(bomb_armor*0.01, 0.05))

		burn_loss = brute_loss

		exposed_mob.take_overall_damage(brute_loss, burn_loss)

		for(var/mob/living/nearby_mob in orange(epicenter_turf, 1))
			if(ROLE_BLOB in nearby_mob.faction) // No friendly fire.
				continue
			if(nearby_mob == exposed_mob) // We've already hit the epicenter mob
				continue
			// AoE damage of 0.5*reac_volume to everyone in a 1 tile range
			brute_loss = reac_volume*0.25
			burn_loss = brute_loss

			bomb_armor = nearby_mob.getarmor(null, BOMB)
			if(bomb_armor) // Same calculation and prod that ex_act uses on mobs
				brute_loss = brute_loss*(2 - round(bomb_armor*0.01, 0.05))
				burn_loss = brute_loss

			nearby_mob.take_overall_damage(brute_loss, burn_loss)

	else
		exposed_mob.apply_damage(0.6*reac_volume, BRUTE, wound_bonus=CANT_WOUND)
