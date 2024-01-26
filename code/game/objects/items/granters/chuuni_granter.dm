/// Turns the user into a chuunibyou.
/obj/item/book/granter/chuunibyou
	starting_title = "《关于我在图书馆发现一本教我成为中二病的书，但却意外使我学会魔法那件事》"
	starting_author = "佚名"
	name = "《关于我在图书馆发现一本教我成为中二病的书，但却意外使我学会魔法那件事》"
	desc = "说实话，我宁愿拿着辛迪加左轮被抓..."
	icon_state ="chuuni_manga"
	remarks = list(
		"这种事怎么会有人相信呢？",
		"...我真是在浪费时间呀",
		"根据需要使用禁忌魔法实际上是一种技能...",
		"我应该带上一个独眼的医用眼罩...",
		"根据这幅漫画，我的力量将在禁忌魔法后提升5000%...",
		"这个\"黑魔王\"是谁? 为什么他支配所有魔力?",
	)

/obj/item/book/granter/chuunibyou/can_learn(mob/living/user)
	if (!isliving(user))
		return
	if (user.GetComponent(/datum/component/chuunibyou))
		to_chat(user, span_warning("你成为了一名中二病!"))
		return
	return TRUE

/obj/item/book/granter/chuunibyou/recoil(mob/living/user)
	to_chat(user, span_warning("你读不下去了...脚趾扣地板要扣破了..."))

/obj/item/book/granter/chuunibyou/on_reading_finished(mob/living/user)
	..()
	to_chat(user, span_notice("你学会了如何更像中二病一样施法!"))
	user.AddComponent(/datum/component/chuunibyou/no_healing)
