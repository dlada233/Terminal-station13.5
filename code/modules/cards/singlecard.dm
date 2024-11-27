/obj/item/toy/singlecard
	name = "卡牌"
	desc = "一张可以玩卡牌游戏的扑克牌."
	icon = 'icons/obj/toys/playing_cards.dmi'
	icon_state = "sc_Ace of Spades_nanotrasen"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = "card"
	pixel_x = -5
	resistance_flags = FLAMMABLE
	max_integrity = 50
	force = 0
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	attack_verb_continuous = list("攻击")
	attack_verb_simple = list("攻击")
	interaction_flags_click = NEED_DEXTERITY|FORBID_TELEKINESIS_REACH|ALLOW_RESTING
	/// Artistic style of the deck
	var/deckstyle = "nanotrasen"
	/// If the cards in the deck have different icon states (blank and CAS decks do not)
	var/has_unique_card_icons = TRUE
	/// The name of the card
	var/cardname = "Ace of Spades"
	/// Is the card flipped facedown (FALSE) or flipped faceup (TRUE)
	var/flipped = CARD_FACEDOWN
	/// The card is blank and can be written on with a pen.
	var/blank = FALSE
	/// The color used to mark a card for cheating (by pens or crayons)
	var/marked_color

/obj/item/toy/singlecard/Initialize(mapload, cardname, obj/item/toy/cards/deck/parent_deck)
	. = ..()
	src.cardname = cardname || src.cardname
	if(istype(parent_deck))
		deckstyle = parent_deck.deckstyle
		has_unique_card_icons = parent_deck.has_unique_card_icons
		icon_state = "singlecard_down_[parent_deck.deckstyle]"
		hitsound = parent_deck.hitsound
		force = parent_deck.force
		throwforce = parent_deck.throwforce
		throw_speed = parent_deck.throw_speed
		throw_range = parent_deck.throw_range
		attack_verb_continuous = parent_deck.attack_verb_continuous
		attack_verb_simple = parent_deck.attack_verb_simple

		if(parent_deck.holodeck)
			flags_1 |= HOLOGRAM_1
			parent_deck.holodeck.spawned += src
	if(mapload)
		//maploaded card needs to be faceup anyways, and doing this will give it its name and appearance properly
		Flip(CARD_FACEUP)

	register_context()


/obj/item/toy/singlecard/examine(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		return

	if(user.is_holding(src))
		user.visible_message(span_notice("[user]检查了牌."), span_notice("牌是: [cardname]."))
		if(blank)
			. += span_notice("这张牌是空白的，可以用笔在上面自定义书写.")
	else if(HAS_TRAIT(user, TRAIT_XRAY_VISION))
		. += span_notice("你用X光透视扫描上面的卡牌，上面写着: [cardname].")
	else
		. += span_warning("你需要把卡牌拿到手里来见检查!")

	var/marked_color = getMarkedColor(user)
	if(marked_color)
		. += span_notice("这张牌的边角有一个[marked_color]标记!")

/obj/item/toy/singlecard/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item) || src == held_item)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "逆时针旋转" // add a ALT_RMB screentip to rotate clockwise
		context[SCREENTIP_CONTEXT_RMB] = "翻牌"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/toy/cards/deck))
		var/obj/item/toy/cards/deck/dealer_deck = held_item
		if(HAS_TRAIT(dealer_deck, TRAIT_WIELDED))
			context[SCREENTIP_CONTEXT_LMB] = "发牌"
			context[SCREENTIP_CONTEXT_RMB] = "正面朝上发牌"
			return CONTEXTUAL_SCREENTIP_SET
		context[SCREENTIP_CONTEXT_LMB] = "回收牌"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/toy/singlecard))
		context[SCREENTIP_CONTEXT_LMB] = "组成手牌"
		context[SCREENTIP_CONTEXT_RMB] = "正面朝上组成手牌"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/toy/cards/cardhand))
		context[SCREENTIP_CONTEXT_LMB] = "组成手牌"
		return CONTEXTUAL_SCREENTIP_SET

	if(IS_WRITING_UTENSIL(held_item))
		context[SCREENTIP_CONTEXT_LMB] = blank ? "在牌上书写" : "标记卡牌"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/toy/singlecard/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]尝试用[src]割腕! 看起来牌运不济!"))
	playsound(src, 'sound/weapons/bladeslice.ogg', 50, TRUE)
	return BRUTELOSS

/**
 * Flips the card over
 *
 * * Arguments:
 * * is_face_up (optional) - Sets flipped state to CARD_FACEDOWN or CARD_FACEUP if given (otherwise just invert the flipped state)
 */
/obj/item/toy/singlecard/proc/Flip(is_face_up)
	if(!isnull(is_face_up))
		flipped = is_face_up
	else
		flipped = !flipped

	name = flipped ? cardname : "card"
	update_appearance()

/**
 * Returns a color if a card is marked and the user can see it
 *
 * * Arguments:
 * * user - We need to check if the user see the marked card
 */
/obj/item/toy/singlecard/proc/getMarkedColor(mob/living/carbon/user)
	if(!istype(user))
		return
	var/is_marked_with_visible_color = (marked_color && marked_color != "invisible")
	if(is_marked_with_visible_color || (marked_color == "invisible" && HAS_TRAIT(user, TRAIT_REAGENT_SCANNER)))
		return marked_color

/obj/item/toy/singlecard/update_icon_state()
	if(!flipped)
		icon_state = "singlecard_down_[deckstyle]"
	else if(has_unique_card_icons) // each card in a deck has a different icon
		icon_state = "sc_[cardname]_[deckstyle]"
	else // all cards are the same icon state (blank or scribble)
		icon_state = blank ? "sc_blank_[deckstyle]" : "sc_scribble_[deckstyle]"
	return ..()

/obj/item/toy/singlecard/update_name()
	name = flipped ? cardname : "卡牌"
	return ..()

/obj/item/toy/singlecard/attackby(obj/item/item, mob/living/user, params, flip_card=FALSE)
	var/obj/item/toy/singlecard/card

	if(istype(item, /obj/item/toy/cards/deck))
		var/obj/item/toy/cards/deck/dealer_deck = item
		if(!HAS_TRAIT(dealer_deck, TRAIT_WIELDED)) // recycle card into deck (if unwielded)
			dealer_deck.insert(src)
			user.balloon_alert_to_viewers("放牌进牌堆")
			return
		card = dealer_deck.draw(user)

	if(istype(item, /obj/item/toy/singlecard))
		card = item

	if(card) // card + card = combine into cardhand
		if(flip_card)
			card.Flip()

		if(istype(item, /obj/item/toy/cards/deck))
			// only decks cause a balloon alert
			user.balloon_alert_to_viewers("发一张牌")

		var/obj/item/toy/cards/cardhand/new_cardhand = new (drop_location())
		new_cardhand.insert(src)
		new_cardhand.insert(card)
		new_cardhand.pixel_x = pixel_x
		new_cardhand.pixel_y = pixel_y

		if(!isturf(loc)) // make a cardhand in our active hand
			user.temporarilyRemoveItemFromInventory(src, TRUE)
			new_cardhand.pickup(user)
			user.put_in_active_hand(new_cardhand)
		return

	if(istype(item, /obj/item/toy/cards/cardhand)) // insert into cardhand
		var/obj/item/toy/cards/cardhand/target_cardhand = item
		target_cardhand.insert(src)
		return

	var/can_item_write
	var/marked_cheating_color

	if(istype(item, /obj/item/pen))
		var/obj/item/pen/pen = item
		can_item_write = TRUE
		marked_cheating_color = (pen.colour == "white" && "invisible") || pen.colour

	if(istype(item, /obj/item/toy/crayon))
		var/obj/item/toy/crayon/crayon = item
		can_item_write = TRUE
		marked_cheating_color = (crayon.crayon_color == "mime" && "invisible") || crayon.crayon_color

	if(can_item_write && !blank) // You cheated not only the game, but yourself
		marked_color = marked_cheating_color
		to_chat(user, span_notice("你用[item]在[src]的边角上做了[marked_color]标记. 作弊以取得胜利!"))
		return

	if(can_item_write)
		if(!user.is_literate())
			to_chat(user, span_notice("你在[src]上乱涂乱画!"))
			return

		var/cardtext = stripped_input(user, "你想在卡牌上写什么?", "卡牌写作", "", 50)
		if(!cardtext || !user.can_perform_action(src))
			return

		cardname = cardtext
		blank = FALSE
		update_appearance()
		return
	return ..()

/obj/item/toy/singlecard/attackby_secondary(obj/item/item, mob/living/user, modifiers)
	attackby(item, user, modifiers, flip_card=TRUE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/toy/singlecard/attack_hand_secondary(mob/living/carbon/human/user, modifiers)
	attack_self(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/toy/singlecard/attack_self_secondary(mob/living/carbon/human/user, modifiers)
	attack_self(user)

/obj/item/toy/singlecard/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
		return

	Flip()
	if(isturf(src.loc)) // only display tihs message when flipping in a visible spot like on a table
		user.balloon_alert_to_viewers("翻一张牌")

/obj/item/toy/singlecard/click_alt(mob/living/carbon/human/user)
	transform = turn(transform, 90)
		// use the simple_rotation component to make this turn with Alt+RMB & Alt+LMB at some point in the future - TimT
	return CLICK_ACTION_SUCCESS
