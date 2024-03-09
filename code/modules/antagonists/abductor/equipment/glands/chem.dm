/obj/item/organ/internal/heart/gland/chem
	abductor_hint = "内生药囊. 被劫持者不断在其血液中产生随机的化学物质，还能快速恢复毒素损伤."
	cooldown_low = 50
	cooldown_high = 50
	uses = -1
	icon_state = "viral"
	mind_control_uses = 3
	mind_control_duration = 1200
	var/list/possible_reagents = list()

/obj/item/organ/internal/heart/gland/chem/Initialize(mapload)
	. = ..()
	for(var/R in subtypesof(/datum/reagent/drug) + subtypesof(/datum/reagent/medicine) + typesof(/datum/reagent/toxin))
		possible_reagents += R

/obj/item/organ/internal/heart/gland/chem/activate()
	var/chem_to_add = pick(possible_reagents)
	owner.reagents.add_reagent(chem_to_add, 2)
	owner.adjustToxLoss(-5, forced = TRUE)
	..()
