/*
 * Tier two entries are unlocked after infusing someone/being infused and achieving a bonus, and are for dna mutants that are:
 * - harder to aquire (gondolas) but not *necessarily* requiring job help
 * - have a bonus for getting past a threshold
 *
 * todos for the future:
 * - tier threes, requires xenobio cooperation, unlocked after getting a tier two entity bonus
 * - when completing a tier, add the bonus to an xp system for unlocking new tiers. so instead of getting/giving a tier 1 bonus and unlocking tier 2, tier 1 would add "1" to a total. when you have a total of say, 3, you get the next tier
*/
/datum/infuser_entry/gondola
	name = "贡多拉"
	infuse_mob_name = "贡多拉"
	desc = "贡多拉，一种只是观察外界而不采取行动的稀有生物，有一系列有趣的特性可以利用. 比如:禅、平和、幸福...对肆虐的等离子火不屑一顾..."
	threshold_desc = "你能无视大多数环境条件!"
	qualities = list(
		"你的拥抱能安抚人们",
		"进入禅宗信仰的极乐状态",
		"太过虚弱以至于拿不起比钢笔更大的东西",
		"不再关心温度...压力...大气...或任何东西...",
	)
	input_obj_or_mob = list(
		/obj/item/food/meat/slab/gondola,
	)
	output_organs = list(
		/obj/item/organ/internal/heart/gondola,
		/obj/item/organ/internal/tongue/gondola,
		/obj/item/organ/internal/liver/gondola,
	)
	infusion_desc = "善于观察的"
	tier = DNA_MUTANT_TIER_TWO
	status_effect_type = /datum/status_effect/organ_set_bonus/gondola
