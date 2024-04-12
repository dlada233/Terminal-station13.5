/datum/quirk/voracious
	name = "Voracious-贪食"
	desc = "你对食物的欲望无与伦比.你比常人吃得更快，还能大吃垃圾食品！肥胖对你来说刚刚好."
	icon = FA_ICON_DRUMSTICK_BITE
	value = 4
	mob_trait = TRAIT_VORACIOUS
	gain_text = span_notice("你感觉很饿.")
	lose_text = span_danger("你不再感到那么饥饿.")
	medical_record_text = "患者对于饮食有着高于平均水平的兴趣和享受."
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/dinner)
