/obj/item/organ/internal/heart/gland/spiderman
	abductor_hint = "蜘蛛巢聚促成器. 被劫持者偶尔会释放蜘蛛信息素并会产下蜘蛛幼虫."
	cooldown_low = 450
	cooldown_high = 900
	uses = -1
	icon_state = "spider"
	mind_control_uses = 2
	mind_control_duration = 2400

/obj/item/organ/internal/heart/gland/spiderman/activate()
	to_chat(owner, span_warning("你感到你的皮肤上有东西在爬."))
	owner.faction |= FACTION_SPIDER
	var/mob/living/basic/spider/growing/spiderling/spider = new(owner.drop_location())
	spider.directive = "保护[owner.real_name]体内的巢穴."
