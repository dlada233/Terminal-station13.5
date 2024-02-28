/datum/quirk/freerunning
	name = "Freerunning-跑酷"
	desc = "你擅于闪转腾挪! 你能更快地爬上桌子，且不会因短距离的坠落而受伤。."
	icon = FA_ICON_RUNNING
	value = 8
	mob_trait = TRAIT_FREERUNNING
	gain_text = span_notice("你感觉身轻如燕!")
	lose_text = span_danger("你感觉步履笨拙.")
	medical_record_text = "Patient scored highly on cardio tests."
	mail_goodies = list(/obj/item/melee/skateboard, /obj/item/clothing/shoes/wheelys/rollerskates)
