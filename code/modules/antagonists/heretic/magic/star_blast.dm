/datum/action/cooldown/spell/pointed/projectile/star_blast
	name = "聚变星体"
	desc = "向目标发射带有宇宙能量的圆盘."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "star_blast"

	sound = 'sound/magic/cosmic_energy.ogg'
	school = SCHOOL_FORBIDDEN
	cooldown_time = 20 SECONDS

	invocation = "R'T'T' ST'R!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE

	active_msg = "你准备好发射聚变星体了!"
	deactive_msg = "你暂时停止在手中搓宇宙能量..."
	cast_range = 12
	projectile_type = /obj/projectile/magic/star_ball

/obj/projectile/magic/star_ball
	name = "star ball"
	icon_state = "star_ball"
	damage = 20
	damage_type = BURN
	speed = 1
	range = 100
	knockdown = 4 SECONDS
	pixel_speed_multiplier = 0.2
	/// Effect for when the ball hits something
	var/obj/effect/explosion_effect = /obj/effect/temp_visual/cosmic_explosion
	/// The range at which people will get marked with a star mark.
	var/star_mark_range = 3

/obj/projectile/magic/star_ball/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/effect_trail, /obj/effect/forcefield/cosmic_field/fast)

/obj/projectile/magic/star_ball/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	var/mob/living/cast_on = firer
	for(var/mob/living/nearby_mob in range(star_mark_range, target))
		if(cast_on == nearby_mob || cast_on.buckled == nearby_mob)
			continue
		nearby_mob.apply_status_effect(/datum/status_effect/star_mark, cast_on)

/obj/projectile/magic/star_ball/Destroy()
	playsound(get_turf(src), 'sound/magic/cosmic_energy.ogg', 50, FALSE)
	for(var/turf/cast_turf as anything in get_turfs())
		new /obj/effect/forcefield/cosmic_field(cast_turf)
	return ..()

/obj/projectile/magic/star_ball/proc/get_turfs()
	return list(get_turf(src), pick(get_step(src, NORTH), get_step(src, SOUTH)), pick(get_step(src, EAST), get_step(src, WEST)))
