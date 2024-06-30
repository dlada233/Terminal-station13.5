
//space pirates from the pirate event.

/obj/effect/mob_spawn/ghost_role/human/pirate
	name = "太空海盗休眠仓"
	desc = "有淡淡的朗姆酒味的休眠仓."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "太空海盗"
	outfit = /datum/outfit/pirate/space
	anchored = TRUE
	density = FALSE
	show_flavor = FALSE //Flavour only exists for spawners menu
	you_are_text = "你是一名太空海盗."
	flavour_text = "空间站拒绝交出保护费，保护你的海盗船，抽取站点的信用点以及突袭它以掠夺更多的战利品."
	spawner_job_path = /datum/job/space_pirate
	///Rank of the pirate on the ship, it's used in generating pirate names!
	var/rank = "逃兵"
	///Path of the structure we spawn after creating a pirate.
	var/fluff_spawn = /obj/structure/showcase/machinery/oldpod/used

	//obviously, these pirate name vars are only used if you don't override `generate_pirate_name()`
	///json key to pirate names, the first part ("Comet" in "Cometfish")
	var/name_beginnings = "generic_beginnings"
	///json key to pirate names, the last part ("fish" in "Cometfish")
	var/name_endings = "generic_endings"

/obj/effect/mob_spawn/ghost_role/human/pirate/special(mob/living/spawned_mob, mob/mob_possessor)
	. = ..()
	spawned_mob.fully_replace_character_name(spawned_mob.real_name, generate_pirate_name(spawned_mob.gender))
	spawned_mob.mind.add_antag_datum(/datum/antagonist/pirate)

/obj/effect/mob_spawn/ghost_role/human/pirate/proc/generate_pirate_name(spawn_gender)
	var/beggings = strings(PIRATE_NAMES_FILE, name_beginnings)
	var/endings = strings(PIRATE_NAMES_FILE, name_endings)
	return "[rank ? rank + " " : ""][pick(beggings)][pick(endings)]"

/obj/effect/mob_spawn/ghost_role/human/pirate/create(mob/mob_possessor, newname)
	if(fluff_spawn)
		new fluff_spawn(drop_location())
	return ..()

/obj/effect/mob_spawn/ghost_role/human/pirate/captain
	rank = "叛军领袖"
	outfit = /datum/outfit/pirate/space/captain

/obj/effect/mob_spawn/ghost_role/human/pirate/gunner
	rank = "恶棍"

/obj/effect/mob_spawn/ghost_role/human/pirate/skeleton
	name = "海盗遗骸"
	desc = "一些死气沉沉的骨头，他们好像知道自己随时都可以复活!"
	density = FALSE
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	prompt_name = "骷髅海盗"
	mob_species = /datum/species/skeleton
	outfit = /datum/outfit/pirate
	rank = "大副"
	fluff_spawn = null

/obj/effect/mob_spawn/ghost_role/human/pirate/skeleton/captain
	rank = "船长"
	outfit = /datum/outfit/pirate/captain/skeleton

/obj/effect/mob_spawn/ghost_role/human/pirate/skeleton/gunner
	rank = "炮手"

/obj/effect/mob_spawn/ghost_role/human/pirate/silverscale
	name = "高雅休眠仓"
	desc = "舒适，但你感觉自己好像不应该在这里..."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "银鳞成员"
	mob_species = /datum/species/lizard/silverscale
	outfit = /datum/outfit/pirate/silverscale
	rank = "名门"

/obj/effect/mob_spawn/ghost_role/human/pirate/silverscale/generate_pirate_name(spawn_gender)
	var/first_name
	switch(spawn_gender)
		if(MALE)
			first_name = pick(GLOB.lizard_names_male)
		if(FEMALE)
			first_name = pick(GLOB.lizard_names_female)
		else
			first_name = pick(GLOB.lizard_names_male + GLOB.lizard_names_female)

	return "[rank] [first_name]-银鳞"

/obj/effect/mob_spawn/ghost_role/human/pirate/silverscale/captain
	rank = "老辈"
	outfit = /datum/outfit/pirate/silverscale/captain

/obj/effect/mob_spawn/ghost_role/human/pirate/silverscale/gunner
	rank = "顶流"

/obj/effect/mob_spawn/ghost_role/human/pirate/interdyne
	name = "\improper Interdyne休眠仓"
	desc = "非常干净的低温休眠仓，你可以在侧面看到自己的倒影."
	density = FALSE
	you_are_text = "你曾经是一名Interdyne药剂师，现在变成了太空海盗."
	flavour_text = "空间站拒绝资助你们的研究，所以你要'说服'他们为你们的慈善事业捐款."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "前Interdyne员工"
	outfit = /datum/outfit/pirate/interdyne
	rank = "药剂师"

/obj/effect/mob_spawn/ghost_role/human/pirate/interdyne/generate_pirate_name(spawn_gender)
	var/first_name
	switch(spawn_gender)
		if(MALE)
			first_name = pick(GLOB.first_names_male)
		if(FEMALE)
			first_name = pick(GLOB.first_names_female)
		else
			first_name = pick(GLOB.first_names)

	return "[rank] [first_name]"

/obj/effect/mob_spawn/ghost_role/human/pirate/interdyne/senior
	rank = "药剂师主管"
	outfit = /datum/outfit/pirate/interdyne/captain

/obj/effect/mob_spawn/ghost_role/human/pirate/interdyne/junior
	rank = "药剂师"

/obj/effect/mob_spawn/ghost_role/human/pirate/grey
	name = "\improper 助手休眠仓"
	desc = "非常脏的低温休眠仓，你甚至不确定它功能正不正常."
	density = FALSE
	you_are_text = "你曾经是纳米传讯下的助手，直到一场暴乱的发生，现在你在太空漫游，洗劫你遇到的任何船只!"
	flavour_text = "没有什么是工具箱砸不出来的，这次是钱，抢劫一切!"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "野助手"
	outfit = /datum/outfit/pirate/grey
	rank = "Tider"

/obj/effect/mob_spawn/ghost_role/human/pirate/grey/shitter
	rank = "Tidemaster"

/obj/effect/mob_spawn/ghost_role/human/pirate/irs
	name = "\improper 太空国税局休眠仓"
	desc = "非常干净的低温休眠仓，你可以在侧面看到自己的倒影."
	density = FALSE
	you_are_text = "你是太空国税局的探员."
	flavour_text = "在这浩瀚无穷的宇宙，唯有税务永恒；不管你是要扮演一名专业的海盗，还是隶属于政府的公务员，你都得不择手段地榨干空间站的收入！无论通过和平亦或其他的方式..."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "太空国税局探员"
	outfit = /datum/outfit/pirate/irs
	fluff_spawn = null // dirs are fucked and I don't have the energy to deal with it
	rank = "Agent"

/obj/effect/mob_spawn/ghost_role/human/pirate/irs/generate_pirate_name(spawn_gender)
	var/first_name
	switch(spawn_gender)
		if(MALE)
			first_name = pick(GLOB.first_names_male)
		if(FEMALE)
			first_name = pick(GLOB.first_names_female)
		else
			first_name = pick(GLOB.first_names)

	return "[rank] [first_name]"


/obj/effect/mob_spawn/ghost_role/human/pirate/irs/auditor
	rank = "总审计负责人"
	outfit = /datum/outfit/pirate/irs/auditor

/obj/effect/mob_spawn/ghost_role/human/pirate/lustrous
	name = "耀光晶体"
	desc = "容纳了变异光灵的水晶，散发出不详的光芒."
	density = FALSE
	you_are_text = "曾经的你是一个拥有自尊的光灵，现在的你只剩下对珍贵的蓝空水晶的渴望."
	flavour_text = "空间拒绝交出那五维空间的甜蜜之物，你只好亲自去取了."
	icon = 'icons/mob/effects/ethereal_crystal.dmi'
	icon_state = "ethereal_crystal"
	fluff_spawn = null
	prompt_name = "晶洞居民"
	mob_species = /datum/species/ethereal/lustrous
	outfit = /datum/outfit/pirate/lustrous
	rank = "闪烁者"

/obj/effect/mob_spawn/ghost_role/human/pirate/lustrous/captain
	rank = "璀璨者"
	outfit = /datum/outfit/pirate/lustrous/captain

/obj/effect/mob_spawn/ghost_role/human/pirate/lustrous/gunner
	rank = "辉光者"

/obj/effect/mob_spawn/ghost_role/human/pirate/medieval
	name = "\improper 简易睡仓"
	desc = "被戳了洞的收尸袋，目前用于当睡袋，好像还有人在里面睡觉."
	density = FALSE
	you_are_text = "你以前只是个无名小卒，直到有人给了你一把剑以及上升的机会. 如果你再付出一些努力，或许可以创造你的辉煌."
	flavour_text = "在参与暴力血腥运动的时候顺带袭击一些白痴？多划算啊，聚在一起，洗劫一切!"
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "bodybag"
	fluff_spawn = null
	prompt_name = "中世纪战团战士"
	outfit = /datum/outfit/pirate/medieval
	rank = "Footsoldier"

/obj/effect/mob_spawn/ghost_role/human/pirate/medieval/special(mob/living/carbon/spawned_mob)
	. = ..()
	if(rank == "Footsoldier")
		ADD_TRAIT(spawned_mob, TRAIT_NOGUNS, INNATE_TRAIT)
		spawned_mob.AddComponent(/datum/component/unbreakable)
		var/datum/action/cooldown/mob_cooldown/dash/dodge = new(spawned_mob)
		dodge.Grant(spawned_mob)

/obj/effect/mob_spawn/ghost_role/human/pirate/medieval/warlord
	rank = "军阀"
	outfit = /datum/outfit/pirate/medieval/warlord

/obj/effect/mob_spawn/ghost_role/human/pirate/medieval/warlord/special(mob/living/carbon/spawned_mob)
	. = ..()
	spawned_mob.dna.add_mutation(/datum/mutation/human/hulk/superhuman)
	spawned_mob.dna.add_mutation(/datum/mutation/human/gigantism)
