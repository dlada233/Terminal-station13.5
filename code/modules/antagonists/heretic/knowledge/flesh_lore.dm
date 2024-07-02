/// The max amount of health a ghoul has.
#define GHOUL_MAX_HEALTH 25
/// The max amount of health a voiceless dead has.
#define MUTE_MAX_HEALTH 50

/**
 * # The path of Flesh.
 *
 * Goes as follows:
 *
 * Principle of Hunger
 * Grasp of Flesh
 * Imperfect Ritual
 * > Sidepaths:
 *   Void Cloak
 *
 * Mark of Flesh
 * Ritual of Knowledge
 * Flesh Surgery
 * Raw Ritual
 * > Sidepaths:
 *   Blood Siphon
 *   Opening Blast
 *
 * Bleeding Steel
 * Lonely Ritual
 * > Sidepaths:
 *   Cleave
 *   Aptera Vulnera
 *
 * Priest's Final Hymn
 */
/datum/heretic_knowledge/limited_amount/starting/base_flesh
	name = "饥渴原理-Base flesh"
	desc = "通往血肉之路. \
		你能将一摊血和一把刀具嬗变成一把血腥之刃. \
		同一时间只能创造二十把出来." //SKYRAT EDIT three to twenty
	gain_text = "我们中的数百人忍饥挨饿，但我没有... 我的贪婪让我脱颖而出."
	next_knowledge = list(/datum/heretic_knowledge/limited_amount/flesh_grasp)
	required_atoms = list(
		/obj/item/knife = 1,
		/obj/effect/decal/cleanable/blood = 1,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/flesh)
	limit = 3 // Bumped up so they can arm up their ghouls too.
	route = PATH_FLESH

/datum/heretic_knowledge/limited_amount/starting/base_flesh/on_research(mob/user, datum/antagonist/heretic/our_heretic)
	. = ..()
	var/datum/objective/heretic_summon/summon_objective = new()
	summon_objective.owner = our_heretic.owner
	our_heretic.objectives += summon_objective

	to_chat(user, span_hierophant("踏上了血肉之路，你拥有了另一个目标."))
	our_heretic.owner.announce_objectives()

/datum/heretic_knowledge/limited_amount/flesh_grasp
	name = "难耐之握"
	desc = "你的漫宿之握获得了从带有灵魂的尸体上创造食尸鬼的能力，食尸鬼只有25点生命值，在不信之人眼中看起来像干尸，但实际上它们非常擅长使用血腥之刃. 该方法一次只能创造出一只出来."
	gain_text = "我燃起的欲望驱使我不停地追求更丰盛丰满的目标."
	next_knowledge = list(/datum/heretic_knowledge/limited_amount/flesh_ghoul)
	limit = 1
	cost = 1
	route = PATH_FLESH

/datum/heretic_knowledge/limited_amount/flesh_grasp/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/limited_amount/flesh_grasp/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/limited_amount/flesh_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(target.stat != DEAD)
		return

	if(LAZYLEN(created_items) >= limit)
		target.balloon_alert(source, "到达食尸鬼上限!")
		return COMPONENT_BLOCK_HAND_USE

	if(HAS_TRAIT(target, TRAIT_HUSK))
		target.balloon_alert(source, "无皮之尸!")
		return COMPONENT_BLOCK_HAND_USE

	if(!IS_VALID_GHOUL_MOB(target))
		target.balloon_alert(source, "不可用尸体!")
		return COMPONENT_BLOCK_HAND_USE

	target.grab_ghost()

	// The grab failed, so they're mindless or playerless. We can't continue
	if(!target.mind || !target.client)
		target.balloon_alert(source, "没有灵魂!")
		return COMPONENT_BLOCK_HAND_USE

	make_ghoul(source, target)

/// Makes [victim] into a ghoul.
/datum/heretic_knowledge/limited_amount/flesh_grasp/proc/make_ghoul(mob/living/user, mob/living/carbon/human/victim)
	user.log_message("创造了食尸鬼，由[key_name(victim)]控制.", LOG_GAME)
	message_admins("[ADMIN_LOOKUPFLW(user)]创造了食尸鬼, [ADMIN_LOOKUPFLW(victim)].")

	victim.apply_status_effect(
		/datum/status_effect/ghoul,
		GHOUL_MAX_HEALTH,
		user.mind,
		CALLBACK(src, PROC_REF(apply_to_ghoul)),
		CALLBACK(src, PROC_REF(remove_from_ghoul)),
	)

/// Callback for the ghoul status effect - Tracking all of our ghouls
/datum/heretic_knowledge/limited_amount/flesh_grasp/proc/apply_to_ghoul(mob/living/ghoul)
	LAZYADD(created_items, WEAKREF(ghoul))

/// Callback for the ghoul status effect - Tracking all of our ghouls
/datum/heretic_knowledge/limited_amount/flesh_grasp/proc/remove_from_ghoul(mob/living/ghoul)
	LAZYREMOVE(created_items, WEAKREF(ghoul))

/datum/heretic_knowledge/limited_amount/flesh_ghoul
	name = "残缺秘仪-Flesh ghoul"
	desc = "允许你将一具尸体和罂粟嬗变为一只失声亡者. \
		失声亡者是一种沉默不语的食尸鬼，只有50点生命值，但擅长挥舞血腥之刃. \
		你同一时间只能创造两只出来."
	gain_text = "我找到了一些关于黑暗仪式的笔记，尽管还未完成...但我仍然抓紧进行."
	next_knowledge = list(
		/datum/heretic_knowledge/mark/flesh_mark,
		/datum/heretic_knowledge/void_cloak,
	)
	required_atoms = list(
		/mob/living/carbon/human = 1,
		/obj/item/food/grown/poppy = 1,
	)
	limit = 2
	cost = 1
	route = PATH_FLESH

/datum/heretic_knowledge/limited_amount/flesh_ghoul/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/body in atoms)
		if(body.stat != DEAD)
			continue
		if(!IS_VALID_GHOUL_MOB(body) || HAS_TRAIT(body, TRAIT_HUSK))
			to_chat(user, span_hierophant_warning("[body]的状态不能转变成食尸鬼."))
			continue

		// We'll select any valid bodies here. If they're clientless, we'll give them a new one.
		selected_atoms += body
		return TRUE

	loc.balloon_alert(user, "仪式失败，无效的尸体!")
	return FALSE

/datum/heretic_knowledge/limited_amount/flesh_ghoul/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/mob/living/carbon/human/soon_to_be_ghoul = locate() in selected_atoms
	if(QDELETED(soon_to_be_ghoul)) // No body? No ritual
		stack_trace("[type] reached on_finished_recipe without a human in selected_atoms to make a ghoul out of.")
		loc.balloon_alert(user, "仪式失败，无效的尸体!")
		return FALSE

	soon_to_be_ghoul.grab_ghost()

	if(!soon_to_be_ghoul.mind || !soon_to_be_ghoul.client)
		message_admins("[ADMIN_LOOKUPFLW(user)]正在创造没有玩家操纵的失声亡者.")
		var/mob/chosen_one = SSpolling.poll_ghosts_for_target("你愿意扮演[span_danger(soon_to_be_ghoul.real_name)], 一名[span_notice("失声亡者")]?", check_jobban = ROLE_HERETIC, role = ROLE_HERETIC, poll_time = 5 SECONDS, checked_target = soon_to_be_ghoul, alert_pic = mutable_appearance('icons/mob/human/human.dmi', "husk"), jump_target = soon_to_be_ghoul, role_name_text = "voiceless dead")
		if(isnull(chosen_one))
			loc.balloon_alert(user, "仪式失败，没有灵魂!")
			return FALSE
		message_admins("[key_name_admin(chosen_one)]已经控制了([key_name_admin(soon_to_be_ghoul)])来取代AFK玩家.")
		soon_to_be_ghoul.ghostize(FALSE)
		soon_to_be_ghoul.key = chosen_one.key

	selected_atoms -= soon_to_be_ghoul
	make_ghoul(user, soon_to_be_ghoul)
	return TRUE

/// Makes [victim] into a ghoul.
/datum/heretic_knowledge/limited_amount/flesh_ghoul/proc/make_ghoul(mob/living/user, mob/living/carbon/human/victim)
	user.log_message("创造了失声亡者，由[key_name(victim)]控制.", LOG_GAME)
	message_admins("[ADMIN_LOOKUPFLW(user)]创造了失声亡者， [ADMIN_LOOKUPFLW(victim)].")

	victim.apply_status_effect(
		/datum/status_effect/ghoul,
		MUTE_MAX_HEALTH,
		user.mind,
		CALLBACK(src, PROC_REF(apply_to_ghoul)),
		CALLBACK(src, PROC_REF(remove_from_ghoul)),
	)

/// Callback for the ghoul status effect - Tracks all of our ghouls and applies effects
/datum/heretic_knowledge/limited_amount/flesh_ghoul/proc/apply_to_ghoul(mob/living/ghoul)
	LAZYADD(created_items, WEAKREF(ghoul))
	ADD_TRAIT(ghoul, TRAIT_MUTE, MAGIC_TRAIT)

/// Callback for the ghoul status effect - Tracks all of our ghouls and applies effects
/datum/heretic_knowledge/limited_amount/flesh_ghoul/proc/remove_from_ghoul(mob/living/ghoul)
	LAZYREMOVE(created_items, WEAKREF(ghoul))
	REMOVE_TRAIT(ghoul, TRAIT_MUTE, MAGIC_TRAIT)

/datum/heretic_knowledge/mark/flesh_mark
	name = "肉中刺"
	desc = "你的漫宿之握现在对目标施加肉中刺，肉中刺可以被血腥之刃攻击触发，一旦触发，目标将开始严重出血."
	gain_text = "就在这时，我看到了他们，那些被标记的人. 他们逃开了. 他们尖叫，一直尖叫."
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/flesh)
	route = PATH_FLESH
	mark_type = /datum/status_effect/eldritch/flesh

/datum/heretic_knowledge/knowledge_ritual/flesh
	next_knowledge = list(/datum/heretic_knowledge/spell/flesh_surgery)
	route = PATH_FLESH

/datum/heretic_knowledge/spell/flesh_surgery
	name = "织肉"
	desc = "赐予你织肉咒语. 允许你不用手术也能摘取尸体的器官，对活着的目标也可以使用，不过需要花费长得多的时间.\
		织肉咒语还能用来治疗你的随从，或者恢复损坏器官到可工作状态."
	gain_text = "但他们无法逃开太远. 每迈出一步，尖叫声惧增，直到最后，我学会了平息他们."
	next_knowledge = list(/datum/heretic_knowledge/summon/raw_prophet)
	spell_to_add = /datum/action/cooldown/spell/touch/flesh_surgery
	cost = 1
	route = PATH_FLESH

/datum/heretic_knowledge/summon/raw_prophet
	name = "食生秘仪-Raw prophet"
	desc = "允许你将一双眼睛、一只左臂和一摊血嬗变成一名食生先知. \
		食生先知拥有大范围的视野和可以透视的X射线视觉，还拥有远距离跳跃和心灵沟通的能力. \
		唯一的缺点在于它们在战斗无力且脆弱."
	gain_text = "我无法独自继续. 我成功召唤了离奇的存在来帮我更多地看清事物. \
		尖叫声...曾经持续不断，现在却因它的注视而沉默下来. 没有什么遥不可及."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/flesh,
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/spell/blood_siphon,
		/datum/heretic_knowledge/spell/opening_blast,
	)
	required_atoms = list(
		/obj/item/organ/internal/eyes = 1,
		/obj/effect/decal/cleanable/blood = 1,
		/obj/item/bodypart/arm/left = 1,
	)
	mob_to_summon = /mob/living/basic/heretic_summon/raw_prophet
	cost = 1
	route = PATH_FLESH
	poll_ignore_define = POLL_IGNORE_RAW_PROPHET

/datum/heretic_knowledge/blade_upgrade/flesh
	name = "血染钢"
	desc = "你的血腥之刃现在可以让敌人大量出血."
	gain_text = "离奇的存在并不孤单. 它引我到了元帅那里. \
		我终于开始理解了. 随后，血雨从天空落下."
	next_knowledge = list(/datum/heretic_knowledge/summon/stalker)
	route = PATH_FLESH
	///What type of wound do we apply on hit
	var/wound_type = /datum/wound/slash/flesh/severe

/datum/heretic_knowledge/blade_upgrade/flesh/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(!iscarbon(target) || source == target)
		return

	var/mob/living/carbon/carbon_target = target
	var/obj/item/bodypart/bodypart = pick(carbon_target.bodyparts)
	var/datum/wound/crit_wound = new wound_type()
	crit_wound.apply_wound(bodypart, attack_direction = get_dir(source, target))

/datum/heretic_knowledge/summon/stalker
	name = "孤生秘仪-Stalker"
	desc = "你可以将一根任何物种的尾巴、一个胃、一条舌头、一支笔以及一张纸来嬗变出一只游荡者. \
		游荡者可以传送，释放电磁脉冲，变形成动物或者机器人，并且在战斗中表现不俗."
	gain_text = "我能够将贪婪和欲望结合在一起，召唤出我从未见的野兽. \
		一团不断变形、知晓我目标的邪恶肉块. 元帅同意了."
	next_knowledge = list(
		/datum/heretic_knowledge/ultimate/flesh_final,
		/datum/heretic_knowledge/spell/apetra_vulnera,
		/datum/heretic_knowledge/spell/cleave,
	)
	required_atoms = list(
		/obj/item/organ/external/tail = 1,
		/obj/item/organ/internal/stomach = 1,
		/obj/item/organ/internal/tongue = 1,
		/obj/item/pen = 1,
		/obj/item/paper = 1,
	)
	mob_to_summon = /mob/living/basic/heretic_summon/stalker
	cost = 1
	route = PATH_FLESH
	poll_ignore_define = POLL_IGNORE_STALKER

/datum/heretic_knowledge/ultimate/flesh_final
	name = "祭司的最终颂歌-Flesh final"
	desc = "血肉之路的飞升仪式. \
		带四具尸体到嬗变符文以完成仪式. \
		一旦完成，你将能摆脱人类姿态，变身成为夜之主，一种异常强大的生物 \
		仅仅是变身的场面就会给附近的不信之人带来巨大的恐惧和精神摧残. \
		在夜之主形态下，你可以通过吞食武器来治疗自身以及恢复身段. \
		此外，你能够召唤三倍数量的食尸鬼和失声亡者，并且能够无限地制造血腥之刃武装它们."
	gain_text = "在元帅的知识指引下，我的力量到达了巅峰. 王座唾手可得. \
		世界的人们，听我宣告时机的到来! 元帅领导者我的军队! 现实唯有屈服才能免于夜之王的解体!\
		见证我的飞升!!!"
	required_atoms = list(/mob/living/carbon/human = 4)
	route = PATH_FLESH

/datum/heretic_knowledge/ultimate/flesh_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce(
		text = "[generate_heretic_text()] 盘旋的螺旋. 现世的平展. 迎我双臂，暗夜之主， [user.real_name]飞升了! 唯有畏惧那永远扭曲的双手! [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = 'sound/ambience/antag/heretic/ascend_flesh.ogg',
		color_override = "pink",
	)

	var/datum/action/cooldown/spell/shapeshift/shed_human_form/worm_spell = new(user.mind)
	worm_spell.Grant(user)

	user.client?.give_award(/datum/award/achievement/misc/flesh_ascension, user)

	var/datum/antagonist/heretic/heretic_datum = IS_HERETIC(user)
	var/datum/heretic_knowledge/limited_amount/flesh_grasp/grasp_ghoul = heretic_datum.get_knowledge(/datum/heretic_knowledge/limited_amount/flesh_grasp)
	grasp_ghoul.limit *= 3
	var/datum/heretic_knowledge/limited_amount/flesh_ghoul/ritual_ghoul = heretic_datum.get_knowledge(/datum/heretic_knowledge/limited_amount/flesh_ghoul)
	ritual_ghoul.limit *= 3
	var/datum/heretic_knowledge/limited_amount/starting/base_flesh/blade_ritual = heretic_datum.get_knowledge(/datum/heretic_knowledge/limited_amount/starting/base_flesh)
	blade_ritual.limit = 999

#undef GHOUL_MAX_HEALTH
#undef MUTE_MAX_HEALTH
