//Strained Muscles: Temporary speed boost at the cost of rapid damage
//Limited because of space suits and such; ideally, used for a quick getaway

/datum/action/changeling/strained_muscles
	name = "肌肉紧绷"
	desc = "通过进化出减少肌肉酸积聚的能力，我们能更快地移动."
	helptext = "这种紧绷使我们很快就会感到疲倦，并且拥有如太空服为标准的重量限制. 此外无法在退形的情况下使用该能力."
	button_icon_state = "strained_muscles"
	chemical_cost = 0
	dna_cost = 1
	req_human = TRUE
	var/stacks = 0 //Increments every 5 seconds; damage increases over time
	active = FALSE //Whether or not you are a hedgehog
	disabled_by_fire = FALSE

/datum/action/changeling/strained_muscles/sting_action(mob/living/carbon/user)
	..()
	active = !active
	if(active)
		to_chat(user, span_notice("我们的肌肉紧绷并增强了."))
	else
		user.remove_movespeed_modifier(/datum/movespeed_modifier/strained_muscles)
		to_chat(user, span_notice("我们的肌肉松弛了下来."))
		if(stacks >= 10)
			to_chat(user, span_danger("我们精疲力尽."))
			user.Paralyze(60)
			user.emote("gasp")

	INVOKE_ASYNC(src, PROC_REF(muscle_loop), user)

	return TRUE

/datum/action/changeling/strained_muscles/Remove(mob/user)
	user.remove_movespeed_modifier(/datum/movespeed_modifier/strained_muscles)
	return ..()

/datum/action/changeling/strained_muscles/proc/muscle_loop(mob/living/carbon/user)
	while(active)
		if(QDELETED(src) || QDELETED(user))
			return

		user.add_movespeed_modifier(/datum/movespeed_modifier/strained_muscles)
		if(user.stat != CONSCIOUS || user.staminaloss >= 90)
			active = !active
			to_chat(user, span_notice("没有能量来加强我们松弛的肌肉."))
			user.Paralyze(40)
			user.remove_movespeed_modifier(/datum/movespeed_modifier/strained_muscles)
			break

		stacks++

		user.adjustStaminaLoss(stacks * 1.3) //At first the changeling may regenerate stamina fast enough to nullify fatigue, but it will stack

		if(stacks == 11) //Warning message that the stacks are getting too high
			to_chat(user, span_warning("我们的腿真的疼起来了..."))

		sleep(4 SECONDS)

	while(!active && stacks) //Damage stacks decrease fairly rapidly while not in sanic mode
		if(QDELETED(src) || QDELETED(user))
			return

		stacks--
		sleep(2 SECONDS)
