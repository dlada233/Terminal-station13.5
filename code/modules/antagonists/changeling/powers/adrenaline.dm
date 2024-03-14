/datum/action/changeling/adrenaline
	name = "肾上腺素囊"
	desc = "在我们体内进化出额外的肾上腺素囊，花费30点化学物质."
	helptext = "立即从眩晕中完全恢复，并在短时间内对眩晕产生抗性. 在无意识状态下依然可以使用该能力，但持续使用会毒害身体."
	button_icon_state = "adrenaline"
	chemical_cost = 30
	dna_cost = 2
	req_human = TRUE
	req_stat = UNCONSCIOUS

//Recover from stuns.
/datum/action/changeling/adrenaline/sting_action(mob/living/user)
	..()
	to_chat(user, span_notice("能量从我们体内涌现."))
	user.SetKnockdown(0)
	user.setStaminaLoss(0) //SKYRAT EDIT ADDITION
	user.set_resting(FALSE)
	user.reagents.add_reagent(/datum/reagent/medicine/changelingadrenaline, 4) //20 seconds
	user.reagents.add_reagent(/datum/reagent/medicine/changelinghaste, 3) //6 seconds, for a really quick burst of speed
	return TRUE
