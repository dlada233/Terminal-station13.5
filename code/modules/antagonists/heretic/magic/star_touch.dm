/datum/action/cooldown/spell/touch/star_touch
	name = "星之触"
	desc = "首先对目标施加星痕，若目标已有星痕则强制入眠四秒并消除星痕. \
		然后会在你与目标之间用宇宙射线相连，射线持续伤害目标一分钟，当目标逃出视线范围或距离太远时提前结束.\
		若对宇宙符文使用，则可以将其擦除；若对自身使用，则可以将自身传送至自己的观星者处."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "star_touch"

	sound = 'sound/items/welder.ogg'
	school = SCHOOL_FORBIDDEN
	cooldown_time = 15 SECONDS
	invocation = "ST'R 'N'RG'!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	antimagic_flags = MAGIC_RESISTANCE

	hand_path = /obj/item/melee/touch_attack/star_touch
	/// Stores the weakref for the Star Gazer after ascending
	var/datum/weakref/star_gazer
	/// If the heretic is ascended or not
	var/ascended = FALSE

/datum/action/cooldown/spell/touch/star_touch/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/touch/star_touch/on_antimagic_triggered(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	victim.visible_message(
		span_danger("咒语从你身上弹开了!"),
	)

/datum/action/cooldown/spell/touch/star_touch/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/victim, mob/living/carbon/caster)
	if(victim.has_status_effect(/datum/status_effect/star_mark))
		victim.apply_effect(4 SECONDS, effecttype = EFFECT_UNCONSCIOUS)
		victim.remove_status_effect(/datum/status_effect/star_mark)
	else
		victim.apply_status_effect(/datum/status_effect/star_mark, caster)
	for(var/turf/cast_turf as anything in get_turfs(victim))
		new /obj/effect/forcefield/cosmic_field(cast_turf)
	caster.apply_status_effect(/datum/status_effect/cosmic_beam, victim)
	return TRUE

/datum/action/cooldown/spell/touch/star_touch/proc/get_turfs(mob/living/victim)
	var/list/target_turfs = list(get_turf(owner))
	var/range = ascended ? 2 : 1
	var/list/directions = list(turn(owner.dir, 90), turn(owner.dir, 270))
	for (var/direction as anything in directions)
		for (var/i in 1 to range)
			target_turfs += get_ranged_target_turf(owner, direction, i)
	return target_turfs

/// To set the star gazer
/datum/action/cooldown/spell/touch/star_touch/proc/set_star_gazer(mob/living/basic/heretic_summon/star_gazer/star_gazer_mob)
	star_gazer = WEAKREF(star_gazer_mob)

/// To obtain the star gazer if there is one
/datum/action/cooldown/spell/touch/star_touch/proc/get_star_gazer()
	var/mob/living/basic/heretic_summon/star_gazer/star_gazer_resolved = star_gazer?.resolve()
	if(star_gazer_resolved)
		return star_gazer_resolved
	return FALSE

/obj/item/melee/touch_attack/star_touch
	name = "星之拂"
	desc = "不详的灵光扭曲了现实的流动. \
		让带有星痕的目标昏睡四秒，让不带星痕的目标带上星痕."
	icon_state = "star"
	inhand_icon_state = "star"

/obj/item/melee/touch_attack/star_touch/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/effect_remover, \
		success_feedback = "你移除 %THEEFFECT.", \
		tip_text = "清除符文", \
		on_clear_callback = CALLBACK(src, PROC_REF(after_clear_rune)), \
		effects_we_clear = list(/obj/effect/cosmic_rune), \
	)

/*
 * Callback for effect_remover component.
 */
/obj/item/melee/touch_attack/star_touch/proc/after_clear_rune(obj/effect/target, mob/living/user)
	new /obj/effect/temp_visual/cosmic_rune_fade(get_turf(target))
	var/datum/action/cooldown/spell/touch/star_touch/star_touch_spell = spell_which_made_us?.resolve()
	star_touch_spell?.spell_feedback(user)
	remove_hand_with_no_refund(user)

/obj/item/melee/touch_attack/star_touch/ignition_effect(atom/to_light, mob/user)
	. = span_notice("[user]将手指搭在了[to_light]上，用指尖的奇异能量将其点燃了. 酷毙了!")
	remove_hand_with_no_refund(user)

/obj/item/melee/touch_attack/star_touch/attack_self(mob/living/user)
	var/datum/action/cooldown/spell/touch/star_touch/star_touch_spell = spell_which_made_us?.resolve()
	var/mob/living/basic/heretic_summon/star_gazer/star_gazer_mob = star_touch_spell?.get_star_gazer()
	if(!star_gazer_mob)
		balloon_alert(user, "没有连结的观星者!")
		return ..()
	new /obj/effect/temp_visual/cosmic_explosion(get_turf(user))
	do_teleport(
		user,
		get_turf(star_gazer_mob),
		no_effects = TRUE,
		channel = TELEPORT_CHANNEL_MAGIC,
		asoundin = 'sound/magic/cosmic_energy.ogg',
		asoundout = 'sound/magic/cosmic_energy.ogg',
	)
	remove_hand_with_no_refund(user)

/obj/effect/ebeam/cosmic
	name = "宇宙射线"

/datum/status_effect/cosmic_beam
	id = "cosmic_beam"
	tick_interval = 0.2 SECONDS
	duration = 1 MINUTES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	/// Stores the current beam target
	var/mob/living/current_target
	/// Checks the time of the last check
	var/last_check = 0
	/// The delay of when the beam gets checked
	var/check_delay = 10 //Check los as often as possible, max resolution is SSobj tick though
	/// The maximum range of the beam
	var/max_range = 8
	/// Wether the beam is active or not
	var/active = FALSE
	/// The storage for the beam
	var/datum/beam/current_beam = null

/datum/status_effect/cosmic_beam/on_creation(mob/living/new_owner, mob/living/current_target)
	src.current_target = current_target
	start_beam(current_target, new_owner)
	return ..()

/datum/status_effect/cosmic_beam/be_replaced()
	if(active)
		QDEL_NULL(current_beam)
		active = FALSE
	return ..()

/datum/status_effect/cosmic_beam/tick(seconds_between_ticks)
	if(!current_target)
		lose_target()
		return

	if(world.time <= last_check+check_delay)
		return

	last_check = world.time

	if(!los_check(owner, current_target))
		QDEL_NULL(current_beam)//this will give the target lost message
		return

	if(current_target)
		on_beam_tick(current_target)

/**
 * Proc that always is called when we want to end the beam and makes sure things are cleaned up, see beam_died()
 */
/datum/status_effect/cosmic_beam/proc/lose_target()
	if(active)
		QDEL_NULL(current_beam)
		active = FALSE
	if(current_target)
		on_beam_release(current_target)
	current_target = null

/**
 * Proc that is only called when the beam fails due to something, so not when manually ended.
 * manual disconnection = lose_target, so it can silently end
 * automatic disconnection = beam_died, so we can give a warning message first
 */
/datum/status_effect/cosmic_beam/proc/beam_died()
	SIGNAL_HANDLER
	to_chat(owner, span_warning("射线失去了控制!"))
	lose_target()
	duration = 0

/// Used for starting the beam when a target has been acquired
/datum/status_effect/cosmic_beam/proc/start_beam(atom/target, mob/living/user)

	if(current_target)
		lose_target()
	if(!isliving(target))
		return

	current_target = target
	active = TRUE
	current_beam = user.Beam(current_target, icon_state="cosmic_beam", time = 1 MINUTES, maxdistance = max_range, beam_type = /obj/effect/ebeam/cosmic)
	RegisterSignal(current_beam, COMSIG_QDELETING, PROC_REF(beam_died))

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)
	if(current_target)
		on_beam_hit(current_target)

/// Checks if the beam is going through an invalid turf
/datum/status_effect/cosmic_beam/proc/los_check(atom/movable/user, mob/target)
	var/turf/user_turf = user.loc
	if(!istype(user_turf))
		return FALSE
	var/obj/dummy = new(user_turf)
	dummy.pass_flags |= PASSTABLE|PASSGLASS|PASSGRILLE //Grille/Glass so it can be used through common windows
	var/turf/previous_step = user_turf
	var/first_step = TRUE
	for(var/turf/next_step as anything in (get_line(user_turf, target) - user_turf))
		if(first_step)
			for(var/obj/blocker in user_turf)
				if(!blocker.density || !(blocker.flags_1 & ON_BORDER_1))
					continue
				if(blocker.CanPass(dummy, get_dir(user_turf, next_step)))
					continue
				return FALSE // Could not leave the first turf.
			first_step = FALSE
		if(next_step.density)
			qdel(dummy)
			return FALSE
		for(var/atom/movable/movable as anything in next_step)
			if(!movable.CanPass(dummy, get_dir(next_step, previous_step)))
				qdel(dummy)
				return FALSE
		previous_step = next_step
	qdel(dummy)
	return TRUE

/// What to add when the beam connects to a target
/datum/status_effect/cosmic_beam/proc/on_beam_hit(mob/living/target)
	if(!istype(target, /mob/living/basic/heretic_summon/star_gazer))
		target.AddElement(/datum/element/effect_trail, /obj/effect/forcefield/cosmic_field/fast)

/// What to process when the beam is connected to a target
/datum/status_effect/cosmic_beam/proc/on_beam_tick(mob/living/target)
	if(target.adjustFireLoss(3, updating_health = FALSE))
		target.updatehealth()

/// What to remove when the beam disconnects from a target
/datum/status_effect/cosmic_beam/proc/on_beam_release(mob/living/target)
	if(!istype(target, /mob/living/basic/heretic_summon/star_gazer))
		target.RemoveElement(/datum/element/effect_trail, /obj/effect/forcefield/cosmic_field/fast)
