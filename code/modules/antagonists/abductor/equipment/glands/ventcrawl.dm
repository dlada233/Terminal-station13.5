/obj/item/organ/internal/heart/gland/ventcrawling
	abductor_hint = "软骨增殖器. 被劫持者可以毫无困难地爬过通风管道."
	cooldown_low = 1800
	cooldown_high = 2400
	uses = 1
	icon_state = "vent"
	mind_control_uses = 4
	mind_control_duration = 1800

/obj/item/organ/internal/heart/gland/ventcrawling/activate()
	to_chat(owner, span_notice("你感到身体变柔软了."))
	ADD_TRAIT(owner, TRAIT_VENTCRAWLER_ALWAYS, type)
