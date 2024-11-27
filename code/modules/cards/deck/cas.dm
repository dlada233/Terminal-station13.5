// CARDS AGAINST SPESS
// This is a parody of Cards Against Humanity (https://en.wikipedia.org/wiki/Cards_Against_Humanity)
// which is licensed under CC BY-NC-SA 2.0, the full text of which can be found at the following URL:
// https://creativecommons.org/licenses/by-nc-sa/2.0/legalcode
// Original code by Zuhayr, Polaris Station, ported with modifications
/obj/item/toy/cards/deck/cas
	name = "希望毁灭卡牌(白)"
	desc = "一副希望毁灭卡牌，历经数个世纪依然广受欢迎，警告：可能包含打破次元壁的内容，这是白牌组."
	cardgame_desc = "Cards Against Spess game"
	icon_state = "deck_white_full"
	deckstyle = "white"
	has_unique_card_icons = FALSE
	is_standard_deck = FALSE
	decksize = 150
	can_play_52_card_pickup = FALSE

/obj/item/toy/cards/deck/cas/black
	name = "希望毁灭卡牌(黑)"
	desc = "一副希望毁灭卡牌，历经数个世纪依然广受欢迎，警告：可能包含打破次元壁的内容，这是黑牌组."
	icon_state = "deck_black_full"
	deckstyle = "black"
	decksize = 50

GLOBAL_LIST_INIT(card_decks, list(
	black = world.file2list("strings/cas_black.txt"),
	white = world.file2list("strings/cas_white.txt")
))

/obj/item/toy/cards/deck/cas/Initialize(mapload)
	. = ..()
	var/list/cards_against_space = GLOB.card_decks[deckstyle]
	var/list/possible_cards = cards_against_space.Copy()

	for(var/i in 1 to decksize)
		initial_cards += pick_n_take(possible_cards)
