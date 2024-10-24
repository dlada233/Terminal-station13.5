// Shoots out in a wave-like, what rust heretics themselves get
/datum/action/cooldown/spell/cone/staggered/entropic_plume
	name = "熵雾"
	desc = "喷出一股令人混乱的烟雾，使敌人互相攻击，造成致盲（效果随距离增加）和中毒（效果随距离减少）. 同时也会锈蚀喷射范围内的物体."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "entropic_plume"
	sound = 'sound/magic/forcewall.ogg'

	school = SCHOOL_FORBIDDEN
	cooldown_time = 30 SECONDS

	invocation = "'NTR'P'C PL'M'"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	cone_levels = 5
	respect_density = TRUE

/datum/action/cooldown/spell/cone/staggered/entropic_plume/cast(atom/cast_on)
	. = ..()
	new /obj/effect/temp_visual/dir_setting/entropic(get_step(cast_on, cast_on.dir), cast_on.dir)

/datum/action/cooldown/spell/cone/staggered/entropic_plume/do_turf_cone_effect(turf/target_turf, mob/living/caster, level)
	caster.do_rust_heretic_act(target_turf)

/datum/action/cooldown/spell/cone/staggered/entropic_plume/do_mob_cone_effect(mob/living/victim, atom/caster, level)
	if(victim.can_block_magic(antimagic_flags) || IS_HERETIC_OR_MONSTER(victim) || victim == caster)
		return
	victim.apply_status_effect(/datum/status_effect/amok)
	victim.apply_status_effect(/datum/status_effect/cloudstruck, level * 1 SECONDS)
	victim.adjust_disgust(100)

/datum/action/cooldown/spell/cone/staggered/entropic_plume/calculate_cone_shape(current_level)
	// At the first level (that isn't level 1) we will be small
	if(current_level == 2)
		return 3
	// At the max level, we turn small again
	if(current_level == cone_levels)
		return 3
	// Otherwise, all levels in between will be wider
	return 5

/obj/effect/temp_visual/dir_setting/entropic
	icon = 'icons/effects/160x160.dmi'
	icon_state = "entropic_plume"
	duration = 3 SECONDS

/obj/effect/temp_visual/dir_setting/entropic/setDir(dir)
	. = ..()
	switch(dir)
		if(NORTH)
			pixel_x = -64
		if(SOUTH)
			pixel_x = -64
			pixel_y = -128
		if(EAST)
			pixel_y = -64
		if(WEST)
			pixel_y = -64
			pixel_x = -128

// Shoots a straight line of rusty stuff ahead of the caster, what rust monsters get
/datum/action/cooldown/spell/basic_projectile/rust_wave
	name = "神之致"
	desc = "将能量传输至手中，释放出锈蚀之潮."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "rust_wave"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 35 SECONDS

	invocation = "SPR'D TH' WO'D"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	projectile_type = /obj/projectile/magic/aoe/rust_wave

/obj/projectile/magic/aoe/rust_wave
	name = "神之致"
	icon_state = "eldritch_projectile"
	alpha = 180
	damage = 30
	damage_type = TOX
	hitsound = 'sound/weapons/punch3.ogg'
	trigger_range = 0
	ignored_factions = list(FACTION_HERETIC)
	range = 15
	speed = 1

/obj/projectile/magic/aoe/rust_wave/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	playsound(src, 'sound/items/welder.ogg', 75, TRUE)
	var/list/turflist = list()
	var/turf/T1
	turflist += get_turf(src)
	T1 = get_step(src,turn(movement_dir,90))
	turflist += T1
	turflist += get_step(T1,turn(movement_dir,90))
	T1 = get_step(src,turn(movement_dir,-90))
	turflist += T1
	turflist += get_step(T1,turn(movement_dir,-90))
	for(var/turf/T as anything in turflist)
		if(!T || prob(25))
			continue
		T.rust_heretic_act()

/datum/action/cooldown/spell/basic_projectile/rust_wave/short
	name = "次级神之致"
	projectile_type = /obj/projectile/magic/aoe/rust_wave/short

/obj/projectile/magic/aoe/rust_wave/short
	range = 7
	speed = 2
