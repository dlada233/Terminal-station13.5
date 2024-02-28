/datum/quirk/throwingarm
	name = "Throwing Arm-投掷能“手"
	desc = "你的胳膊强壮有力，投掷物品总比其他人要远，并且从不失手."
	icon = FA_ICON_BASEBALL
	value = 7
	mob_trait = TRAIT_THROWINGARM
	gain_text = span_notice("你的手臂精力充沛!")
	lose_text = span_danger("你的手臂微微作痛.")
	medical_record_text = "患者在投球方面表现精通."
	mail_goodies = list(/obj/item/toy/beach_ball/baseball, /obj/item/toy/basketball, /obj/item/toy/dodgeball)
