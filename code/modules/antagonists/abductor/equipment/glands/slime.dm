/obj/item/organ/internal/heart/gland/slime
	abductor_hint = "胃部活性促成器. 被劫持者将偶尔吐出史莱姆，并且史莱姆不会攻击被劫持者."
	cooldown_low = 600
	cooldown_high = 1200
	uses = -1
	icon_state = "slime"
	mind_control_uses = 1
	mind_control_duration = 2400

/obj/item/organ/internal/heart/gland/slime/on_mob_insert(mob/living/carbon/gland_owner)
	. = ..()
	gland_owner.faction |= FACTION_SLIME
	gland_owner.grant_language(/datum/language/slime, source = LANGUAGE_GLAND)

/obj/item/organ/internal/heart/gland/slime/on_mob_remove(mob/living/carbon/gland_owner)
	. = ..()
	gland_owner.faction -= FACTION_SLIME
	gland_owner.remove_language(/datum/language/slime, source = LANGUAGE_GLAND)

/obj/item/organ/internal/heart/gland/slime/activate()
	to_chat(owner, span_warning("你感到反胃!"))
	owner.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 20)

	var/mob/living/simple_animal/slime/Slime = new(get_turf(owner), /datum/slime_type/grey)
	Slime.set_friends(list(owner))
	Slime.set_leader(owner)
