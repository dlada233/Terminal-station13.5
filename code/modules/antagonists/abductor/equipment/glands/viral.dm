/obj/item/organ/internal/heart/gland/viral
	abductor_hint = "疫病培育炉. 劫持者成为一种随机的先进疾病的携带者，并且他们自身不会受该疾病影响."
	cooldown_low = 1800
	cooldown_high = 2400
	uses = 1
	icon_state = "viral"
	mind_control_uses = 1
	mind_control_duration = 1800

/obj/item/organ/internal/heart/gland/viral/activate()
	to_chat(owner, span_warning("你感到恶心."))
	var/datum/disease/advance/A = random_virus(pick(2,6),6)
	A.carrier = TRUE
	owner.ForceContractDisease(A, FALSE, TRUE)

/obj/item/organ/internal/heart/gland/viral/proc/random_virus(max_symptoms, max_level)
	if(max_symptoms > VIRUS_SYMPTOM_LIMIT)
		max_symptoms = VIRUS_SYMPTOM_LIMIT
	var/datum/disease/advance/A = new /datum/disease/advance()
	var/list/datum/symptom/possible_symptoms = list()
	for(var/symptom in subtypesof(/datum/symptom))
		var/datum/symptom/S = symptom
		if(initial(S.level) > max_level)
			continue
		if(initial(S.level) <= 0) //unobtainable symptoms
			continue
		possible_symptoms += S
	for(var/i in 1 to max_symptoms)
		var/datum/symptom/chosen_symptom = pick_n_take(possible_symptoms)
		if(chosen_symptom)
			var/datum/symptom/S = new chosen_symptom
			A.symptoms += S
	A.Refresh() //just in case someone already made and named the same disease
	return A
