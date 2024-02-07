/datum/quirk/alcohol_tolerance
	name = "Alcohol Tolerance-酒精耐受"
	desc = "你喝酒醉得更慢，并且酒精带来的坏处也更少."
	icon = FA_ICON_BEER
	value = 4
	mob_trait = TRAIT_ALCOHOL_TOLERANCE
	gain_text = span_notice("你感觉自己能喝下一整桶酒!")
	lose_text = span_danger("不知为何，你不再感到对酒精有抵抗力.")
	medical_record_text = "患者表现出对酒精高度耐受."
	mail_goodies = list(/obj/item/skillchip/wine_taster)
