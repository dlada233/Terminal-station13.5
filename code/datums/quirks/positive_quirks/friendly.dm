/datum/quirk/friendly
	name = "Friendly-友善"
	desc = "你能给别人一个超棒的抱抱，尤其是你心情很好的时候."
	icon = FA_ICON_HANDS_HELPING
	value = 2
	mob_trait = TRAIT_FRIENDLY
	gain_text = span_notice("你想要抱一抱其他人.")
	lose_text = span_danger("你不再感到要非抱别人不可的了.")
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "患者表现出对身体接触毫无顾忌，且手臂发达。请求另一位医生接手此案."
	mail_goodies = list(/obj/item/storage/box/hug)
