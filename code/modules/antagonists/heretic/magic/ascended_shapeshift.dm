// Given to ascended knock heretics, is a form of shapeshift that can turn into all 4 common heretic summons, and is not limited to 1 selection.
/datum/action/cooldown/spell/shapeshift/eldritch/ascension
	name = "脱胎换骨"
	desc = "人类状态下使用能让你变身成为邪恶生物，在变身状态使用则变回人类. 在变身状态下死亡只会解除变身."
	cooldown_time = 20 SECONDS
	convert_damage = FALSE
	die_with_shapeshifted_form = FALSE
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "lock_ascension"
	possible_shapes = list(
		/mob/living/basic/heretic_summon/ash_spirit,
		/mob/living/basic/heretic_summon/raw_prophet/ascended,
		/mob/living/basic/heretic_summon/rust_walker,
		/mob/living/basic/heretic_summon/stalker,
	)

/datum/action/cooldown/spell/shapeshift/eldritch/ascension/do_shapeshift(mob/living/caster)
	. = ..()
	if(!.)
		return
	//buff our forms so this ascension ability isnt shit
	playsound(caster, 'sound/magic/demon_consume.ogg', 50, TRUE)
	var/mob/living/monster = .
	monster.AddComponent(/datum/component/seethrough_mob)
	monster.maxHealth *= 1.5
	monster.health = monster.maxHealth
	monster.melee_damage_lower = max((monster.melee_damage_lower * 2), 40)
	monster.melee_damage_upper = monster.melee_damage_upper / 2
	monster.transform *= 1.5
	monster.AddElement(/datum/element/wall_tearer)

/datum/action/cooldown/spell/shapeshift/eldritch/ascension/do_unshapeshift(mob/living/caster)
	. = ..()
	shapeshift_type = null //pick another loser
