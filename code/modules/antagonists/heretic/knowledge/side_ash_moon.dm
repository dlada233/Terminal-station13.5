// Sidepaths for knowledge between Ash and Flesh.
/datum/heretic_knowledge/medallion
	name = "余烬双眼-Medallion"
	desc = "你可以将一双眼睛、一根蜡烛和一块玻璃碎片嬗变成邪术勋章. \
		佩戴邪术勋章可以给你热成像视觉，还能用做焦点."
	gain_text = "锐利的目标引导他们穿越尘世，黑暗与恐怖都无法阻拦."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/ash_passage,
		/datum/heretic_knowledge/spell/moon_smile,
	)
	required_atoms = list(
		/obj/item/organ/internal/eyes = 1,
		/obj/item/shard = 1,
		/obj/item/flashlight/flare/candle = 1,
	)
	result_atoms = list(/obj/item/clothing/neck/eldritch_amulet)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/curse/paralysis
	name = "麻痹诅咒-Paralysis"
	desc = "你可以将一把短柄斧和一双包含左右的腿嬗变出对船员释放的麻痹诅咒，\
		被诅咒的目标将无法行走. 你还可以提供受害者接触过的物品或者被受害者血液沾染的物品来强化诅咒."
	gain_text = "人类的肉体有多脆弱？只要让血流出来就能知道."
	next_knowledge = list(
		/datum/heretic_knowledge/mad_mask,
		/datum/heretic_knowledge/moon_amulet,
	)
	required_atoms = list(
		/obj/item/bodypart/leg/left = 1,
		/obj/item/bodypart/leg/right = 1,
		/obj/item/hatchet = 1,
	)
	duration = 3 MINUTES
	duration_modifier = 2
	curse_color = "#f19a9a"
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/curse/paralysis/curse(mob/living/carbon/human/chosen_mob, boosted = FALSE)
	if(chosen_mob.usable_legs <= 0) // What're you gonna do, curse someone who already can't walk?
		to_chat(chosen_mob, span_notice("You feel a slight pain for a moment, but it passes shortly. Odd."))
		return

	to_chat(chosen_mob, span_danger("You suddenly lose feeling in your leg[chosen_mob.usable_legs == 1 ? "":"s"]!"))
	chosen_mob.add_traits(list(TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG), type)
	return ..()

/datum/heretic_knowledge/curse/paralysis/uncurse(mob/living/carbon/human/chosen_mob, boosted = FALSE)
	if(QDELETED(chosen_mob))
		return

	chosen_mob.remove_traits(list(TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG), type)
	if(chosen_mob.usable_legs > 1)
		to_chat(chosen_mob, span_green("You regain feeling in your leg[chosen_mob.usable_legs == 1 ? "":"s"]!"))
	return ..()

/datum/heretic_knowledge/summon/ashy
	name = "灰烬仪式-Ashy man"
	desc = "你可以将一颗头颅、一堆灰尘和一本书嬗变成一名灰烬人. \
		灰烬人能短距离传送和范围内对敌人造成流血，还可以在自身周围创造持续一段时间的火焰环."
	gain_text = "我将饥渴的原理和毁灭的欲望结合在一起，元帅听见了，守夜人看到了."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/flame_birth,
		/datum/heretic_knowledge/spell/moon_ringleader,
	)
	required_atoms = list(
		/obj/effect/decal/cleanable/ash = 1,
		/obj/item/bodypart/head = 1,
		/obj/item/book = 1,
		)
	mob_to_summon = /mob/living/basic/heretic_summon/ash_spirit
	cost = 1
	route = PATH_SIDE
	poll_ignore_define = POLL_IGNORE_ASH_SPIRIT

/datum/heretic_knowledge/summon/ashy/cleanup_atoms(list/selected_atoms)
	var/obj/item/bodypart/head/ritual_head = locate() in selected_atoms
	if(!ritual_head)
		CRASH("[type] required a head bodypart, yet did not have one in selected_atoms when it reached cleanup_atoms.")

	// Spill out any brains or stuff before we delete it.
	ritual_head.drop_organs()
	return ..()
