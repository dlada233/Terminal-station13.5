/obj/item/book/granter/martial/carp
	martial = /datum/martial_art/the_sleeping_carp
	name = "神秘卷轴"
	martial_name = "sleeping carp-睡鲤拳"
	desc = "满是奇怪标记的卷轴，似乎是某种武术的秘籍."
	greet = "<span class='sciradio'>你学会了古老的Sleep Carp-睡鲤拳！你在近身战斗中将更加迅猛，并且在战斗模式下向你飞来的投射物也会被你偏转. \
		你的肉体变得金刚不坏，在长久的战斗中能坚持更久. \
		然而，你也必须摒弃了任何远程武器.你可以在sleep Carp中的Recall Teaching了解更多武学奥义.</span>"
	icon = 'icons/obj/scrolls.dmi'
	icon_state = "sleepingcarp"
	worn_icon_state = "scroll"
	remarks = list(
		"等等，高蛋白饮食真的是变强的唯一途径吗...?",
		"侵掠如火，不动如山...",
		"静心...制敌只需分秒...",
		"不知可否使力量穿透护甲呢...",
		"好像没法和其他武术结合使用...",
		"人鲤合一...",
		"Glub...",
	)

/obj/item/book/granter/martial/carp/on_reading_finished(mob/living/carbon/user)
	. = ..()
	update_appearance()

/obj/item/book/granter/martial/carp/update_appearance(updates)
	. = ..()
	if(uses <= 0)
		name = "空卷轴"
		desc = "完全是空白的."
		icon_state = "blankscroll"
	else
		name = initial(name)
		desc = initial(desc)
		icon_state = initial(icon_state)
