// The spooky "void" / "abyssal" / "madness" mask for heretics.
/obj/item/clothing/mask/madness_mask
	name = "深渊面罩"
	desc = "一副由实在的痛苦创造出来的面罩，当你凝视它的双眼时，它也凝视着你."
	icon_state = "mad_mask"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	flags_cover = MASKCOVERSEYES
	resistance_flags = FLAMMABLE
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	///Who is wearing this
	var/mob/living/carbon/human/local_user

/obj/item/clothing/mask/madness_mask/Destroy()
	local_user = null
	return ..()

/obj/item/clothing/mask/madness_mask/examine(mob/user)
	. = ..()
	if(IS_HERETIC_OR_MONSTER(user))
		. += span_notice("佩戴时消耗附近非异教徒的理智和耐力.")
		. += span_notice("如果强行给非异教徒带上，则他们无法主动取下来.")
	else
		. += span_danger("面具的双眼让你恐惧...最好还是避开视线.")

/obj/item/clothing/mask/madness_mask/equipped(mob/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_MASK))
		return
	if(!ishuman(user) || !user.mind)
		return

	local_user = user
	START_PROCESSING(SSobj, src)

	if(IS_HERETIC_OR_MONSTER(user))
		return

	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	to_chat(user, span_userdanger("[src]紧紧地卡在你的脸上，你感到灵魂正在流失!"))

/obj/item/clothing/mask/madness_mask/dropped(mob/M)
	local_user = null
	STOP_PROCESSING(SSobj, src)
	REMOVE_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	return ..()

/obj/item/clothing/mask/madness_mask/process(seconds_per_tick)
	if(!local_user)
		return PROCESS_KILL

	if(IS_HERETIC_OR_MONSTER(local_user) && HAS_TRAIT(src, TRAIT_NODROP))
		REMOVE_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

	for(var/mob/living/carbon/human/human_in_range in view(local_user))
		if(IS_HERETIC_OR_MONSTER(human_in_range) || human_in_range.is_blind())
			continue

		human_in_range.mob_mood.direct_sanity_drain(rand(-2, -20) * seconds_per_tick)

		if(SPT_PROB(60, seconds_per_tick))
			human_in_range.adjust_hallucinations_up_to(10 SECONDS, 240 SECONDS)

		if(SPT_PROB(40, seconds_per_tick))
			human_in_range.set_jitter_if_lower(10 SECONDS)

		if(human_in_range.getStaminaLoss() <= 85 && SPT_PROB(30, seconds_per_tick))
			human_in_range.emote(pick("giggle", "laugh"))
			human_in_range.adjustStaminaLoss(10)

		if(SPT_PROB(25, seconds_per_tick))
			human_in_range.set_dizzy_if_lower(10 SECONDS)
