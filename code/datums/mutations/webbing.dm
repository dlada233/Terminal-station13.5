//spider webs
/datum/mutation/human/webbing
	name = "吐丝"
	desc = "允许使用者吐丝，并通过吐出的丝网进行移动."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>你的皮肤感觉有点像蜘蛛网.</span>"
	instability = POSITIVE_INSTABILITY_MODERATE // useful until you're lynched
	power_path = /datum/action/cooldown/mob_cooldown/lay_web/genetic
	energy_coeff = 1

/datum/mutation/human/webbing/modify()
	. = ..()
	var/datum/action/cooldown/mob_cooldown/lay_web/genetic/to_modify = .

	if(!istype(to_modify)) // null or invalid
		return

	if(GET_MUTATION_ENERGY(src) == 1) // Energetic chromosome outputs a value less than 1 when present, 1 by default
		to_modify.webbing_time = initial(to_modify.webbing_time)
		return
	to_modify.webbing_time = 2 SECONDS // Spin webs faster but not more often

/datum/mutation/human/webbing/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_WEB_WEAVER, GENETIC_MUTATION)

/datum/mutation/human/webbing/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_WEB_WEAVER, GENETIC_MUTATION)
