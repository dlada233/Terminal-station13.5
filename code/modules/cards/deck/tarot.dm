#define TAROT_GHOST_TIMER (666 SECONDS) // this translates into 11 mins and 6 seconds

//These cards certainly won't tell the future, but you can play some nice games with them.
/obj/item/toy/cards/deck/tarot
	name = "塔罗牌"
	desc = "一副完整的78张塔罗牌游戏牌组，包含4组各14张的小阿尔卡那牌，以及一组完整的大阿尔卡那牌."
	cardgame_desc = "tarot card reading"
	icon_state = "deck_tarot_full"
	deckstyle = "tarot"
	is_standard_deck = FALSE

/obj/item/toy/cards/deck/tarot/Initialize(mapload)
	. = ..()
	for(var/suit in list("Hearts", "Pikes", "Clovers", "Tiles"))
		for(var/i in 1 to 10)
			initial_cards += "[i] of [suit]"
		for(var/person in list("Valet", "Chevalier", "Dame", "Roi"))
			initial_cards += "[person] of [suit]"
	for(var/trump in list("The Magician", "The High Priestess", "The Empress", "The Emperor", "The Hierophant", "The Lover", "The Chariot", "Justice", "The Hermit", "The Wheel of Fortune", "Strength", "The Hanged Man", "Death", "Temperance", "The Devil", "The Tower", "The Star", "The Moon", "The Sun", "Judgement", "The World", "The Fool"))
		initial_cards += trump

/obj/item/toy/cards/deck/tarot/draw(mob/user)
	. = ..()
	if(prob(50))
		var/obj/item/toy/singlecard/card = .
		if(!card)
			return FALSE

		var/matrix/M = matrix()
		M.Turn(180)
		card.transform = M

/obj/item/toy/cards/deck/tarot/haunted
	name = "灵异塔罗牌"
	desc = "一副诡异的塔罗牌，你可以感受到其中与超自然存在的某种联系..."
	/// ghost notification cooldown
	COOLDOWN_DECLARE(ghost_alert_cooldown)

/obj/item/toy/cards/deck/tarot/haunted/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/two_handed, \
		attacksound = 'sound/items/cardflip.ogg', \
		wield_callback = CALLBACK(src, PROC_REF(on_wield)), \
		unwield_callback = CALLBACK(src, PROC_REF(on_unwield)), \
	)

/obj/item/toy/cards/deck/tarot/haunted/proc/on_wield(obj/item/source, mob/living/carbon/user)
	ADD_TRAIT(user, TRAIT_SIXTHSENSE, MAGIC_TRAIT)
	to_chat(user, span_notice("冥界的面纱被揭开. 你能感受到到死去的灵魂在呼唤..."))

	if(!COOLDOWN_FINISHED(src, ghost_alert_cooldown))
		return

	COOLDOWN_START(src, ghost_alert_cooldown, TAROT_GHOST_TIMER)
	notify_ghosts(
		"有人开始在[get_area(src)]玩[src.name]!",
		source = src,
		header = "灵异塔罗牌",
		ghost_sound = 'sound/effects/ghost2.ogg',
		notify_volume = 75,
	)

/obj/item/toy/cards/deck/tarot/haunted/proc/on_unwield(obj/item/source, mob/living/carbon/user)
	REMOVE_TRAIT(user, TRAIT_SIXTHSENSE, MAGIC_TRAIT)
	to_chat(user, span_notice("冥界的面纱合上了，你感受到感官恢复了正常."))

#undef TAROT_GHOST_TIMER
