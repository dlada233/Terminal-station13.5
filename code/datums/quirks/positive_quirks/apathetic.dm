/datum/quirk/apathetic
	name = "Apathetic-性情淡漠"
	desc = "你不像其他人那样在乎这么多事.在这种地方这样也挺好."
	icon = FA_ICON_MEH
	value = 4
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "患者漫不经心地完成了淡漠评估量表测试."
	mail_goodies = list(/obj/item/hourglass)

/datum/quirk/apathetic/add(client/client_source)
	quirk_holder.mob_mood?.mood_modifier -= 0.2

/datum/quirk/apathetic/remove()
	quirk_holder.mob_mood?.mood_modifier += 0.2
