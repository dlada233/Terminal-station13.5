/datum/quirk/empath
	name = "Empath-同感者"
	desc = "也许是第六感，或是对肢体语言细致入微的解读，你只需要快速地瞥一眼某人，就能洞悉其内心感受."
	icon = FA_ICON_SMILE_BEAM
	value = 6 // SKYRAT EDIT CHANGE - Quirk Rebalance - Original: value = 8
	mob_trait = TRAIT_EMPATH
	gain_text = span_notice("你感觉和周围的人心意相通.")
	lose_text = span_danger("你感觉和其他人疏远隔绝.")
	medical_record_text = "患者对社交暗示具有高度的敏感及洞察力，甚至可能存在超感知能力.仍需进一步测试来验证."
	mail_goodies = list(/obj/item/toy/foamfinger)
