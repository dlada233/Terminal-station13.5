/datum/action/changeling/resonant_shriek
	name = "惊声尖啸"
	desc = "我们的肺与声带一齐运动，发出能使心智弱小的单位耳聋并困惑的噪音. 使用该能力将花费20点化学物质."
	helptext = "发出一种高频率的声音，对人类造成困惑和耳聋，甚至能熄灭附近的灯光照明并使赛博传感器过载."
	button_icon_state = "resonant_shriek"
	chemical_cost = 20
	dna_cost = 1
	req_human = TRUE

//A flashy ability, good for crowd control and sowing chaos.
/datum/action/changeling/resonant_shriek/sting_action(mob/user)
	..()
	if(user.movement_type & VENTCRAWLING)
		user.balloon_alert(user, "没法在管道里尖啸!")
		return FALSE
	for(var/mob/living/M in get_hearers_in_view(4, user))
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(!C.mind || !C.mind.has_antag_datum(/datum/antagonist/changeling))
				var/obj/item/organ/internal/ears/ears = C.get_organ_slot(ORGAN_SLOT_EARS)
				if(ears)
					ears.adjustEarDamage(0, 30)
				C.adjust_confusion(25 SECONDS)
				C.set_jitter_if_lower(100 SECONDS)
			else
				SEND_SOUND(C, sound('sound/effects/screech.ogg'))

		if(issilicon(M))
			SEND_SOUND(M, sound('sound/weapons/flash.ogg'))
			M.Paralyze(rand(100,200))

	for(var/obj/machinery/light/L in range(4, user))
		L.on = TRUE
		L.break_light_tube()
		stoplag()
	return TRUE

/datum/action/changeling/dissonant_shriek
	name = "惊声尖啸"
	desc = "我们调整声带，发出能使附近电子设备超载的高频率声音. 使用该能力将花费20点化学物质."
	button_icon_state = "dissonant_shriek"
	chemical_cost = 20
	dna_cost = 1

/datum/action/changeling/dissonant_shriek/sting_action(mob/user)
	..()
	if(user.movement_type & VENTCRAWLING)
		user.balloon_alert(user, "不能在管道里尖啸!")
		return FALSE
	empulse(get_turf(user), 2, 5, 1)
	for(var/obj/machinery/light/L in range(5, usr))
		L.on = TRUE
		L.break_light_tube()
		stoplag()

	return TRUE
