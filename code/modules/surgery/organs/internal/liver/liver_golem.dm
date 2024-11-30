/**
 * Golem liver
 * Basically only exists to remove the nutriment factor from consumables,
 * so golems can only consume minerals even when injecting reagents.
 *
 * Actually consuming golem food is handled by /obj/item/organ/internal/stomach/golem!
 **/
/obj/item/organ/internal/liver/golem
	name = "多孔岩石"
	desc = "能吸收化学物质的海绵状岩石."
	icon_state = "liver-p"
	organ_flags = ORGAN_MINERAL
	color = COLOR_GOLEM_GRAY

/obj/item/organ/internal/liver/golem/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick, times_fired)
	. = ..()
	// parent returned COMSIG_MOB_STOP_REAGENT_CHECK or we are failing
	if((. & COMSIG_MOB_STOP_REAGENT_CHECK) || (organ_flags & ORGAN_FAILING))
		return
	// golems can only eat minerals
	if(istype(chem, /datum/reagent/consumable) && !istype(chem, /datum/reagent/consumable/nutriment/mineral))
		var/datum/reagent/consumable/yummy_chem = chem
		yummy_chem.nutriment_factor = 0
		return // Do normal metabolism
