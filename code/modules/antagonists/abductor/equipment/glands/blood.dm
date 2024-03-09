/obj/item/organ/internal/heart/gland/blood
	abductor_hint = "伪核血液不稳定器. 周期性的将被劫持者的血型转变成一种随机试剂."
	cooldown_low = 1200
	cooldown_high = 1800
	uses = -1
	icon_state = "egg"
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	mind_control_uses = 3
	mind_control_duration = 1500

/obj/item/organ/internal/heart/gland/blood/activate()
	if(!ishuman(owner) || !owner.dna.species)
		return
	var/mob/living/carbon/human/H = owner
	var/datum/species/species = H.dna.species
	to_chat(H, span_warning("你感到你的血液在一瞬间变热了."))
	species.exotic_blood = get_random_reagent_id()
