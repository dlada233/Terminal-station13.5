/*
 * Tier zero entries are unlocked at the start, and are for dna mutants that are:
 * - a roundstart race (felinid)
 * - something of equal power to a roundstart race (flyperson)
 * - mutants without a bonus, just bringing cosmetics (fox ears)
 * basically just meme, cosmetic, and base species entries
*/
/datum/infuser_entry/fly
	name = "被排斥"
	infuse_mob_name = "排斥生物"
	desc = "不论处于何种原因，当身体排斥DNA时，DNA酸化，最终变成某种苍蝇一样的紊乱DNA."
	threshold_desc = "紊乱DNA接管，你成为了一个成熟的苍蝇."
	qualities = list(
		"讲话声嗡嗡恼人",
		"喝酒呕吐",
		"器官无法识别",
		"这是个糟糕的注意",
	)
	output_organs = list(
		/obj/item/organ/internal/appendix/fly,
		/obj/item/organ/internal/eyes/fly,
		/obj/item/organ/internal/heart/fly,
		/obj/item/organ/internal/lungs/fly,
		/obj/item/organ/internal/stomach/fly,
		/obj/item/organ/internal/tongue/fly,
	)
	infusion_desc = "苍蝇一样的"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/vulpini
	name = "狐狸"
	infuse_mob_name = "vulpini"
	desc = "由于2555年 \"狐狸耳\" 热潮，狐狸现在非常罕见. 我的意思是, 我们很久以前就破坏了狐狸的自然栖息地, 其他动物也是如此."
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"你不是吧",
		"所有的基因学家因此受辱",
		"我希望这值得",
	)
	input_obj_or_mob = list(
		/mob/living/basic/pet/fox,
	)
	output_organs = list(
		/obj/item/organ/internal/ears/fox,
	)
	infusion_desc = "不可原谅的"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/mothroach
	name = "蛾螂"
	infuse_mob_name = "蛾螂"
	desc = "所以他们首先将蛾和蟑螂基因混合，然后我们又将其与人类DNA混合?"
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"眼睛对强光很弱",
		"你说话的时候会发抖",
		"翅膀承载不了你的体重",
		"我希望这值得",
	)
	input_obj_or_mob = list(
		/mob/living/basic/mothroach,
	)
	output_organs = list(
		/obj/item/organ/external/antennae,
		/obj/item/organ/external/wings/moth,
		/obj/item/organ/internal/eyes/moth,
		/obj/item/organ/internal/tongue/moth,
	)
	infusion_desc = "蓬松的"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/felinid
	name = "猫"
	infuse_mob_name = "猫科动物"
	desc = "大家冷静一点! 我不是在暗指任何事情. 我们真的对这世界上有猫人这种事情感到惊讶吗?"
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"哦，让我猜猜，你是那些日本旅游机器人的忠实粉丝",
	)
	input_obj_or_mob = list(
		/mob/living/basic/pet/cat,
	)
	output_organs = list(
		/obj/item/organ/internal/ears/cat,
		/obj/item/organ/external/tail/cat,
	)
	infusion_desc = "被驯养的"
	tier = DNA_MUTANT_TIER_ZERO
