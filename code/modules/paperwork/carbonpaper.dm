/obj/item/paper/carbon
	name = "复写纸"
	icon_state = "paper_stack"
	inhand_icon_state = "paper"
	show_written_words = FALSE
	var/copied = FALSE

/obj/item/paper/carbon/update_icon_state()
	if(copied)
		icon_state = "paper"
	else
		icon_state = "paper_stack"
	if(get_total_length())
		icon_state = "[icon_state]_words"
	return ..()

/obj/item/paper/carbon/examine()
	. = ..()
	if(copied)
		return
	. += span_notice("右键撕下复写件(必须用双手).")

/obj/item/paper/carbon/click_alt(mob/living/user)
	if(!copied)
		to_chat(user, span_notice("先撕下复写件."))
		return CLICK_ACTION_BLOCKING
	return CLICK_ACTION_SUCCESS

/obj/item/paper/carbon/proc/removecopy(mob/living/user)
	if(copied)
		to_chat(user, span_notice("已经没有更多的复写纸了!"))
		return

	var/obj/item/paper/carbon/copy = copy(/obj/item/paper/carbon_copy, loc.drop_location(), FALSE)
	copy.name = "复件 - [name]"
	to_chat(user, span_notice("你撕下复写件!"))
	copied = TRUE
	update_icon_state()
	user.put_in_hands(copy)

/obj/item/paper/carbon/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(loc == user && user.is_holding(src))
		removecopy(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/paper/carbon_copy
	icon_state = "cpaper"
