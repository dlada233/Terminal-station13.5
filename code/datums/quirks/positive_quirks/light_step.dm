/datum/quirk/light_step
	name = "Light Step-步履轻盈"
	desc = "你行路步履轻盈；脚步声和踩过尖锐物品的动静更小，光脚时也不会那么疼.你的手和衣物也不会因走过血迹而变脏."
	icon = FA_ICON_SHOE_PRINTS
	value = 4
	mob_trait = TRAIT_LIGHT_STEP
	gain_text = span_notice("你的步伐变得轻盈.")
	lose_text = span_danger("你开始像个野蛮人一样粗犷迈步.")
	medical_record_text = "患者灵巧的步伐使其拥有高强的潜行能力."
	mail_goodies = list(/obj/item/clothing/shoes/sandal)
