// Sidepaths for knowledge between Rust and Cosmos.

/datum/heretic_knowledge/essence
	name = "祭司的秘仪"
	desc = "让你将水罐和一片玻璃嬗变成一瓶邪术精华，邪术精华液可以用来治疗自己，也可以用来毒死不信之人."
	gain_text = "这是一份旧药谱. 猫头鹰悄悄对我说. 祭司创造的液体，不存在与过去与未来."
	next_knowledge = list(
		/datum/heretic_knowledge/rust_regen,
		/datum/heretic_knowledge/spell/cosmic_runes,
		)
	required_atoms = list(
		/obj/structure/reagent_dispensers/watertank = 1,
		/obj/item/shard = 1,
	)
	result_atoms = list(/obj/item/reagent_containers/cup/beaker/eldritch)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/entropy_pulse
	name = "脉冲熵"
	desc = "你可以将20块铁和2个垃圾物品进行嬗变，让符文周围充满铁锈."
	gain_text = "现实开始向我低语，以赋予它熵增的终结."
	required_atoms = list(
		/obj/item/stack/sheet/iron = 20,
		/obj/item/trash = 2
	)
	cost = 0
	route = PATH_SIDE
	var/rusting_range = 4

/datum/heretic_knowledge/entropy_pulse/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	for(var/turf/nearby_turf in view(rusting_range, loc))
		if(get_dist(nearby_turf, loc) <= 1) //tiles on rune should always be rusted
			nearby_turf.rust_heretic_act()
		//we exclude closed turf to avoid exposing cultist bases
		if(prob(20) || isclosedturf(nearby_turf))
			continue
		nearby_turf.rust_heretic_act()
	return TRUE

/datum/heretic_knowledge/curse/corrosion
	name = "疫病诅咒"
	desc = "你可以将剪线钳，一堆呕吐物和一颗心脏嬗变，来对船员施加疫病诅咒. 当被诅咒时，受害者将反复呕吐，器官持续受到伤害. 你还可以提供受害者接触过的物品或受害者的血覆盖的物品来增强诅咒."
	gain_text = "血肉之躯终为土灰，生老病死人之所命. 展示光阴数载后的必然命运吧."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/area_conversion,
		/datum/heretic_knowledge/spell/star_blast,
	)
	required_atoms = list(
		/obj/item/wirecutters = 1,
		/obj/effect/decal/cleanable/vomit = 1,
		/obj/item/organ/internal/heart = 1,
	)
	duration = 0.5 MINUTES
	duration_modifier = 4
	curse_color = "#c1ffc9"
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/curse/corrosion/curse(mob/living/carbon/human/chosen_mob, boosted = FALSE)
	to_chat(chosen_mob, span_danger("你感觉很不舒服..."))
	chosen_mob.apply_status_effect(/datum/status_effect/corrosion_curse)
	return ..()

/datum/heretic_knowledge/curse/corrosion/uncurse(mob/living/carbon/human/chosen_mob, boosted = FALSE)
	if(QDELETED(chosen_mob))
		return

	chosen_mob.remove_status_effect(/datum/status_effect/corrosion_curse)
	to_chat(chosen_mob, span_green("你感觉好多了."))
	return ..()

/datum/heretic_knowledge/summon/rusty
	name = "生锈秘仪"
	desc = "你可以将一摊呕吐物，一本书和一颗头嬗变成铁锈漫步者. 铁锈漫步者擅长传播铁锈，战斗力也不俗."
	gain_text = "我把创造的理论和腐败的渴望结合在一起，元帅听闻了我的名字，锈山回响不息."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/entropic_plume,
		/datum/heretic_knowledge/spell/cosmic_expansion,
	)
	required_atoms = list(
		/obj/effect/decal/cleanable/vomit = 1,
		/obj/item/book = 1,
		/obj/item/bodypart/head = 1,
	)
	mob_to_summon = /mob/living/basic/heretic_summon/rust_walker
	cost = 1
	route = PATH_SIDE
	poll_ignore_define = POLL_IGNORE_RUST_SPIRIT

/datum/heretic_knowledge/summon/rusty/cleanup_atoms(list/selected_atoms)
	var/obj/item/bodypart/head/ritual_head = locate() in selected_atoms
	if(!ritual_head)
		CRASH("[type] required a head bodypart, yet did not have one in selected_atoms when it reached cleanup_atoms.")

	// Spill out any brains or stuff before we delete it.
	ritual_head.drop_organs()
	return ..()
