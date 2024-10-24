// Realignment. It's like Fleshmend but solely for stamina damage and stuns. Sec meta
/datum/action/cooldown/spell/realignment
	name = "重铸"
	desc = "重铸自身，迅速恢复耐力，并从昏迷或击倒中恢复. \
		重铸期间内你无法发动攻击. 该咒语可以短时间连续使用，但每次使用都会增加冷却时间."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/hud/implants.dmi'
	button_icon_state = "adrenal"
	// sound = 'sound/magic/whistlereset.ogg'

	school = SCHOOL_FORBIDDEN
	cooldown_time = 6 SECONDS
	cooldown_reduction_per_rank = -6 SECONDS // we're not a wizard spell but we use the levelling mechanic
	spell_max_level = 10 // we can get up to / over a minute duration cd time

	invocation = "R'S'T."
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE

/datum/action/cooldown/spell/realignment/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/realignment/cast(mob/living/cast_on)
	. = ..()
	cast_on.apply_status_effect(/datum/status_effect/realignment)
	to_chat(cast_on, span_notice("我们开始重铸自身."))

/datum/action/cooldown/spell/realignment/after_cast(atom/cast_on)
	. = ..()
	// With every cast, our spell level increases for a short time, which goes back down after a period
	// and with every spell level, the cooldown duration of the spell goes up
	if(level_spell())
		var/reduction_timer = max(cooldown_time * spell_max_level * 0.5, 1.5 MINUTES)
		addtimer(CALLBACK(src, PROC_REF(delevel_spell)), reduction_timer)

/datum/action/cooldown/spell/realignment/get_spell_title()
	switch(spell_level)
		if(1, 2)
			return "急促" // Hasty Realignment
		if(3, 4)
			return "" // Realignment
		if(5, 6, 7)
			return "缓慢" // Slowed Realignment
		if(8, 9, 10)
			return "费力" // Laborious Realignment (don't reach here)

	return ""

/datum/status_effect/realignment
	id = "realigment"
	status_type = STATUS_EFFECT_REFRESH
	duration = 8 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/realignment
	tick_interval = 0.2 SECONDS
	show_duration = TRUE

/datum/status_effect/realignment/get_examine_text()
	return span_notice("[owner.p_Theyre()]发出柔和的白光.")

/datum/status_effect/realignment/on_apply()
	ADD_TRAIT(owner, TRAIT_PACIFISM, id)
	owner.add_filter(id, 2, list("type" = "outline", "color" = "#d6e3e7", "size" = 2))
	var/filter = owner.get_filter(id)
	animate(filter, alpha = 127, time = 1 SECONDS, loop = -1)
	animate(alpha = 63, time = 2 SECONDS)
	return TRUE

/datum/status_effect/realignment/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, id)
	owner.remove_filter(id)

/datum/status_effect/realignment/tick(seconds_between_ticks)
	owner.adjustStaminaLoss(-5)
	owner.AdjustAllImmobility(-0.5 SECONDS)

/atom/movable/screen/alert/status_effect/realignment
	name = "重铸"
	desc = "你重铸自身，期间迅速恢复体力且无法攻击."
	icon_state = "realignment"
