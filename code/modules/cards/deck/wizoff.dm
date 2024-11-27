//It's Wiz-Off, the wizard themed card game! It's modular too, in case you might want to make it Syndie, Sec and Clown themed or something stupid like that.
/obj/item/toy/cards/deck/wizoff
	name = "巫师牌"
	desc = "一副巫师牌，为宇宙的命运展开一场神秘的较量：抽5张！出5张！五局三胜！随牌附有一张规则卡！"
	cardgame_desc = "巫师牌"
	icon_state = "deck_wizoff_full"
	deckstyle = "wizoff"
	is_standard_deck = FALSE

/obj/item/toy/cards/deck/wizoff/Initialize(mapload)
	. = ..()
	var/card_list = strings("wizoff.json", "wizard")
	initial_cards += new /datum/deck_card/of_type(/obj/item/toy/singlecard/wizoff_ruleset) // ruleset should be the top card
	for(var/card in card_list)
		initial_cards += card

/obj/item/toy/singlecard/wizoff_ruleset
	desc = "卡牌游戏巫师牌的规则卡."
	cardname = "巫师牌规则卡"
	deckstyle = "black"
	has_unique_card_icons = FALSE
	icon_state = "singlecard_down_black"

/obj/item/toy/singlecard/wizoff_ruleset/examine(mob/living/carbon/human/user)
	. = ..()
	. += span_notice("记住巫师牌规则！")
	. += span_info("每位玩家抽取5张牌。")
	. += span_info("游戏共有五轮，每轮中，玩家选择一张牌来出，根据以下规则决定胜负：")
	. += span_info("防御牌克制攻击牌！")
	. += span_info("攻击牌克制功能牌！")
	. += span_info("功能牌克制防御牌！")
	. += span_info("如果两位玩家出的是同类型的咒语牌，则数字较大的那张获胜！")
	. += span_info("在五轮中获胜轮次最多的玩家赢得游戏！")
	. += span_notice("现在，准备为宇宙的命运而战吧：巫师牌！")
