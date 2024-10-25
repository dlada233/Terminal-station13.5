/*
 * Tier one entries are unlocked at the start, and are for dna mutants that are:
 * - easy to aquire (rats)
 * - have a bonus for getting past a threshold
 * - might serve a job purpose for others (goliath) and thus should be gainable early enough
*/
/datum/infuser_entry/goliath
	name = "歌利亚"
	infuse_mob_name = "歌利亚"
	desc = "担心“屠龙勇者终成龙”的人显然还没见识到歌利亚矿工究竟有多强!"
	threshold_desc = "你可以在岩浆上行走!"
	qualities = list(
		"你可以适应空间站以及拉瓦兰的空气，但要小心纯氧环境",
		"对灰尘暴免疫",
		"眼睛在黑暗中也能看清",
		"卷须手可以轻易挖开火山岩，也能用来消灭敌对动物，但再也无法戴手套了...",
	)
	input_obj_or_mob = list(
		/mob/living/basic/mining/goliath,
	)
	output_organs = list(
		/obj/item/organ/internal/brain/goliath,
		/obj/item/organ/internal/eyes/night_vision/goliath,
		/obj/item/organ/internal/heart/goliath,
		/obj/item/organ/internal/lungs/lavaland/goliath,
	)
	infusion_desc = "装甲卷须状"
	tier = DNA_MUTANT_TIER_ONE
	status_effect_type = /datum/status_effect/organ_set_bonus/goliath

/datum/infuser_entry/carp
	name = "鲤鱼"
	infuse_mob_name = "太空鲤科动物"
	desc = "鲤鱼变种人已经为长期的深空探索做好了充分的准备，事实上，他们不想做好准备也不行!"
	threshold_desc = "你学会像条鱼一样在太空中推进自己!"
	qualities = list(
		"巨大嘴巴，巨大牙齿",
		"在太空中游泳，没问题",
		"在回到站点时面对各种问题",
		"总是想出去旅行",
	)
	input_obj_or_mob = list(
		/mob/living/basic/carp,
	)
	output_organs = list(
		/obj/item/organ/internal/brain/carp,
		/obj/item/organ/internal/heart/carp,
		/obj/item/organ/internal/lungs/carp,
		/obj/item/organ/internal/tongue/carp,
	)
	infusion_desc = "游牧的"
	tier = DNA_MUTANT_TIER_ONE
	status_effect_type = /datum/status_effect/organ_set_bonus/carp

/datum/infuser_entry/rat
	name = "老鼠"
	infuse_mob_name = "啮齿动物"
	desc = "脆弱、矮小、对世界充满了厌倦. 让自己充满老鼠DNA是很容易的事情，但也许不是最好的选择?"
	threshold_desc = "你能在通风管道中爬行."
	qualities = list(
		"俗气台词",
		"什么都吃",
		"不停地想吃所有东西",
		"脆弱但敏捷",
	)
	input_obj_or_mob = list(
		/obj/item/food/deadmouse,
	)
	output_organs = list(
		/obj/item/organ/internal/eyes/night_vision/rat,
		/obj/item/organ/internal/heart/rat,
		/obj/item/organ/internal/stomach/rat,
		/obj/item/organ/internal/tongue/rat,
	)
	infusion_desc = "易受惊的"
	tier = DNA_MUTANT_TIER_ONE
	status_effect_type = /datum/status_effect/organ_set_bonus/rat

/datum/infuser_entry/roach
	name = "蟑螂"
	infuse_mob_name = "蟑螂"
	desc = "你似乎是古代文学的粉丝才会拥有这方面的兴趣，当然这里将蟑螂DNA合并到你的基因组不会导致你下不了床. \
		蟑螂对很多事物拥有难以置信的抵抗力，我们可以利用这一点弥补人类的脆弱，谁不想在核爆中幸存下来呢! \
		注意:不明显的话，被压扁的蟑螂对机器不起作用，试着用植物学的杀虫剂喷洒它们!"
	threshold_desc = "你不会再被爆炸碎尸，并获得对病毒和辐射的不可思议的抗性."
	qualities = list(
		"抵御来自背后的攻击",
		"更加健康的身体器官",
		"更快地克服恶心",
		"能够在核灾难中存活下来",
		"跌到时更难爬起来",
		"必须不惜一切代价避免毒素",
		"总是想找点零食吃",
	)
	input_obj_or_mob = list(
		/mob/living/basic/cockroach,
	)
	output_organs = list(
		/obj/item/organ/internal/heart/roach,
		/obj/item/organ/internal/stomach/roach,
		/obj/item/organ/internal/liver/roach,
		/obj/item/organ/internal/appendix/roach,
	)
	infusion_desc = "卡夫卡式" // Gregor Samsa !!
	tier = DNA_MUTANT_TIER_ONE
	status_effect_type = /datum/status_effect/organ_set_bonus/roach
