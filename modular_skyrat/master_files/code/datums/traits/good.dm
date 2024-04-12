// SKYRAT GOOD TRAITS

/datum/quirk/hard_soles
	name = "Hardened Soles-硬脚板"
	desc = "你习惯了赤脚走路，而且不会受到负面影响."
	value = 2
	mob_trait = TRAIT_HARD_SOLES
	gain_text = span_notice("你感觉脚下的地面不那么粗糙了.")
	lose_text = span_danger("你开始感觉到地面凸起和沟壑.")
	medical_record_text = "患者的足部能更好地抵抗地面摩擦."
	icon = FA_ICON_SHAPES

/datum/quirk/linguist
	name = "Linguist-语言学家"
	desc = "你是个精通多种语言的学者，拥有一个额外的语言点数."
	value = 4
	mob_trait = TRAIT_LINGUIST
	gain_text = span_notice("你的大脑似乎更适合处理不同的对话模式.")
	lose_text = span_danger("你对龙族俚语精妙之处的熟谙逐渐消失.")
	medical_record_text = "患者的大脑在学习语言方面展现出高度的可塑性."
	icon = FA_ICON_BOOK_ATLAS

/datum/quirk/sharpclaws
	name = "Sharp Claws-锐利尖爪"
	desc = "不管是捕猎者与生俱来的生物学特征，还是你执意拒绝在上柔术课前修剪指甲，你的徒手攻击更加锋利，能够使敌人流血."
	value = 2
	gain_text = span_notice("你的手掌被锋利的指甲刮得隐隐作痛.")
	lose_text = span_danger("你的指甲变钝了，你心里有点茫然若失；抓痒痒的时候祝你好运.")
	medical_record_text = "患者抓破了检查台的垫子；建议患者修剪爪子."
	icon = FA_ICON_HAND

/datum/quirk/sharpclaws/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(!istype(human_holder))
		return FALSE

	var/obj/item/bodypart/arm/left/left_arm = human_holder.get_bodypart(BODY_ZONE_L_ARM)
	if(left_arm)
		left_arm.unarmed_attack_verb = "slash"
		left_arm.unarmed_attack_effect = ATTACK_EFFECT_CLAW
		left_arm.unarmed_attack_sound = 'sound/weapons/slash.ogg'
		left_arm.unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'
		left_arm.unarmed_sharpness = SHARP_EDGED

	var/obj/item/bodypart/arm/right/right_arm = human_holder.get_bodypart(BODY_ZONE_R_ARM)
	if(right_arm)
		right_arm.unarmed_attack_verb = "slash"
		right_arm.unarmed_attack_effect = ATTACK_EFFECT_CLAW
		right_arm.unarmed_attack_sound = 'sound/weapons/slash.ogg'
		right_arm.unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'
		right_arm.unarmed_sharpness = SHARP_EDGED

/datum/quirk/sharpclaws/remove(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/bodypart/arm/left/left_arm = human_holder.get_bodypart(BODY_ZONE_L_ARM)
	if(left_arm)
		left_arm.unarmed_attack_verb = initial(left_arm.unarmed_attack_verb)
		left_arm.unarmed_attack_effect = initial(left_arm.unarmed_attack_effect)
		left_arm.unarmed_attack_sound = initial(left_arm.unarmed_attack_sound)
		left_arm.unarmed_miss_sound = initial(left_arm.unarmed_miss_sound)
		left_arm.unarmed_sharpness = initial(left_arm.unarmed_sharpness)

	var/obj/item/bodypart/arm/right/right_arm = human_holder.get_bodypart(BODY_ZONE_R_ARM)
	if(right_arm)
		right_arm.unarmed_attack_verb = initial(right_arm.unarmed_attack_verb)
		right_arm.unarmed_attack_effect = initial(right_arm.unarmed_attack_effect)
		right_arm.unarmed_attack_sound = initial(right_arm.unarmed_attack_sound)
		right_arm.unarmed_miss_sound = initial(right_arm.unarmed_miss_sound)
		right_arm.unarmed_sharpness = initial(right_arm.unarmed_sharpness)

/datum/quirk/water_breathing
	name = "Water breathing-水下呼吸"
	desc = "你能在水底下呼吸!"
	value = 2
	mob_trait = TRAIT_WATER_BREATHING
	gain_text = span_notice("你开始能敏锐地感知到肺部和空气中的湿气，挺舒服的.")
	lose_text = span_danger("你突然感到肺部的水分<i>非常膈应</i>，你简直快要窒息了!")
	medical_record_text = "患者拥有适应水下呼吸的生物学特征."
	icon = FA_ICON_FISH

// AdditionalEmotes *turf quirks
/datum/quirk/water_aspect
	name = "Water aspect (Emotes)"
	desc = "(Aquatic innate) Underwater societies are home to you, space ain't much different. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_WATER_ASPECT
	gain_text = span_notice("You feel like you can control water.")
	lose_text = span_danger("Somehow, you've lost your ability to control water!")
	medical_record_text = "Patient holds a collection of nanobots designed to synthesize H2O."
	icon = FA_ICON_WATER

/datum/quirk/webbing_aspect
	name = "Webbing aspect (Emotes)"
	desc = "(Insect innate) Insect folk capable of weaving aren't unfamiliar with receiving envy from those lacking a natural 3D printer. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_WEBBING_ASPECT
	gain_text = span_notice("You could easily spin a web.")
	lose_text = span_danger("Somehow, you've lost your ability to weave.")
	medical_record_text = "Patient has the ability to weave webs with naturally synthesized silk."
	icon = FA_ICON_STICKY_NOTE

/datum/quirk/floral_aspect
	name = "Floral aspect (Emotes)"
	desc = "(Podperson innate) Kudzu research isn't pointless, rapid photosynthesis technology is here! (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_FLORAL_ASPECT
	gain_text = span_notice("You feel like you can grow vines.")
	lose_text = span_danger("Somehow, you've lost your ability to rapidly photosynthesize.")
	medical_record_text = "Patient can rapidly photosynthesize to grow vines."
	icon = FA_ICON_PLANT_WILT

/datum/quirk/ash_aspect
	name = "Ash aspect (Emotes)"
	desc = "(Lizard innate) The ability to forge ash and flame, a mighty power - yet mostly used for theatrics. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_ASH_ASPECT
	gain_text = span_notice("There is a forge smouldering inside of you.")
	lose_text = span_danger("Somehow, you've lost your ability to breathe fire.")
	medical_record_text = "Patients possess a fire breathing gland commonly found in lizard folk."
	icon = FA_ICON_FIRE

/datum/quirk/sparkle_aspect
	name = "Sparkle aspect (Emotes)"
	desc = "(Moth innate) Sparkle like the dust off of a moth's wing, or like a cheap red-light hook-up. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_SPARKLE_ASPECT
	gain_text = span_notice("You're covered in sparkling dust!")
	lose_text = span_danger("Somehow, you've completely cleaned yourself of glitter..")
	medical_record_text = "Patient seems to be looking fabulous."
	icon = FA_ICON_HAND_SPARKLES
