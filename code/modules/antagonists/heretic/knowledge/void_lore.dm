/**
 * # The path of VOID.
 *
 * Goes as follows:
 *
 * Glimmer of Winter
 * Grasp of Void
 * Aristocrat's Way
 * > Sidepaths:
 *   Void Cloak
 *   Shattered Ritual
 *
 * Mark of Void
 * Ritual of Knowledge
 * Cone of Cold
 * Void Phase
 * > Sidepaths:
 *   Carving Knife
 *   Blood Siphon
 *
 * Seeking blade
 * Void Pull
 * > Sidepaths:
 *   Cleave
 *   Maid in the Mirror
 *
 * Waltz at the End of Time
 */
/datum/heretic_knowledge/limited_amount/starting/base_void
	name = "冬日的微光-Base void"
	desc = "通往虚无之路. \
		允许你在零度以下的环境将刀具嬗变为虚无之刃. \
		同一时间只能创造五把出来." //SKYRAT EDIT two to five
	gain_text = "我感到空气中有一丝微光，周围的空气变得很冷；我察觉到空虚的存在，有什么在注视着我."
	next_knowledge = list(/datum/heretic_knowledge/void_grasp)
	required_atoms = list(/obj/item/knife = 1)
	result_atoms = list(/obj/item/melee/sickly_blade/void)
	route = PATH_VOID

/datum/heretic_knowledge/limited_amount/starting/base_void/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	if(!isopenturf(loc))
		loc.balloon_alert(user, "仪式失败，无效地点!")
		return FALSE

	var/turf/open/our_turf = loc
	if(our_turf.GetTemperature() > T0C)
		loc.balloon_alert(user, "仪式失败，不够冷!")
		return FALSE

	return ..()

/datum/heretic_knowledge/void_grasp
	name = "寒空之握"
	desc = "你的漫宿之握能使目标短暂陷入沉默和受寒."
	gain_text = "我看见了那个向我投来冰冷视线的存在. 它们无比安静. 这还不能解释一切."
	next_knowledge = list(/datum/heretic_knowledge/cold_snap)
	cost = 1
	route = PATH_VOID

/datum/heretic_knowledge/void_grasp/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/void_grasp/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/void_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(!iscarbon(target))
		return

	var/mob/living/carbon/carbon_target = target
	carbon_target.adjust_silence(10 SECONDS)
	carbon_target.apply_status_effect(/datum/status_effect/void_chill)

/datum/heretic_knowledge/cold_snap
	name = "贵族风流"
	desc = "赐予你免疫寒冷，并不再需要呼吸，但仍然会因气压异常而受伤."
	gain_text = "缕缕寒气将我带往了奇怪的水晶宫殿，朦胧苍白的贵族形象出现在我面前."
	next_knowledge = list(
		/datum/heretic_knowledge/mark/void_mark,
		/datum/heretic_knowledge/void_cloak,
		/datum/heretic_knowledge/limited_amount/risen_corpse,
	)
	cost = 1
	route = PATH_VOID

/datum/heretic_knowledge/cold_snap/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	user.add_traits(list(TRAIT_NOBREATH, TRAIT_RESISTCOLD), type)

/datum/heretic_knowledge/cold_snap/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	user.remove_traits(list(TRAIT_RESISTCOLD, TRAIT_NOBREATH), type)

/datum/heretic_knowledge/mark/void_mark
	name = "虚无印"
	desc = "你的漫宿之握现在对目标施加虚无印，虚无印可以由虚无之刃触发. \
		一旦被触发，目标将被沉默更久并会迅速降低他们体内和周围空气的温度."
	gain_text = "风？微光？这股存在让我不知所措，我的感官也背叛了我，我的思维成了自己的敌人."
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/void)
	route = PATH_VOID
	mark_type = /datum/status_effect/eldritch/void

/datum/heretic_knowledge/knowledge_ritual/void
	next_knowledge = list(/datum/heretic_knowledge/spell/void_cone)
	route = PATH_VOID

/datum/heretic_knowledge/spell/void_cone
	name = "空无气震"
	desc = "赐予你空无气震，这个咒语让你能对面前的扇形区域发出冻结波，冻结地面和被命中者."
	gain_text = "每打开一扇门都让我痛苦万分，门后的东西让我害怕，有什么正在等着我. 步履渐弱. 那是...雪吗？"
	next_knowledge = list(/datum/heretic_knowledge/spell/void_phase)
	spell_to_add = /datum/action/cooldown/spell/cone/staggered/cone_of_cold/void
	cost = 1
	route = PATH_VOID

/datum/heretic_knowledge/spell/void_phase
	name = "冥冥迷踪"
	desc = "赐予你冥冥迷踪，一种远距离指向传送术. \
		使用时还会对出发点和目的地周围的不信之人造成伤害."
	gain_text = "实体自称贵族，它们毫不费力地在凌风中穿行，如同无物，留下一阵刺骨的寒风. 它们消失了，而我被留在暴风雪中."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/void,
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/spell/blood_siphon,
		/datum/heretic_knowledge/rune_carver,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/void_phase
	cost = 1
	route = PATH_VOID

/datum/heretic_knowledge/blade_upgrade/void
	name = "追暮之刃"
	desc = "你现在可以用虚无之刃攻击远处带有虚无霜痕的目标，将直接传送到他们身边."
	gain_text = "转瞬的追忆，飘忽的步履. 我用冻结的鲜血在雪地上标记下我的路. 被掩埋，被遗忘."
	next_knowledge = list(/datum/heretic_knowledge/spell/void_pull)
	route = PATH_VOID

/datum/heretic_knowledge/blade_upgrade/void/do_ranged_effects(mob/living/user, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(!target.has_status_effect(/datum/status_effect/eldritch))
		return

	var/dir = angle2dir(dir2angle(get_dir(user, target)) + 180)
	user.forceMove(get_step(target, dir))

	INVOKE_ASYNC(src, PROC_REF(follow_up_attack), user, target, blade)

/datum/heretic_knowledge/blade_upgrade/void/proc/follow_up_attack(mob/living/user, mob/living/target, obj/item/melee/sickly_blade/blade)
	blade.melee_attack_chain(user, target)

/datum/heretic_knowledge/spell/void_pull
	name = "虚空牵引"
	desc = "赐予你虚空牵引，这个咒语可以将你附近所有的不信之人拉向你并让他们陷入短暂昏迷."
	gain_text = "逝者如潮，无可避免. 从开端到终末，贵族又一次向我显露真身. 它们说我迟到了，以万不能抗的力量拉扯我."
	next_knowledge = list(
		/datum/heretic_knowledge/ultimate/void_final,
		/datum/heretic_knowledge/spell/cleave,
		/datum/heretic_knowledge/summon/maid_in_mirror,
	)
	spell_to_add = /datum/action/cooldown/spell/aoe/void_pull
	cost = 1
	route = PATH_VOID

/datum/heretic_knowledge/ultimate/void_final
	name = "终末华尔兹-Void final"
	desc = "虚无之路的飞升仪式. \
		在零下的温度里带三具尸体到嬗变符文以完成仪式. \
		一旦仪式完成，将在空间站上刮起猛烈的虚无暴雪，冻结和伤害不信之人. \
		附近的人将更快地被冻结和沉默. \
		另外，你将获得对太空环境的完全免疫."
	gain_text = "世界坠入黑暗. 我站在空无的虚面上，目睹潇潇冰片的飘落. \
		贵族站在我的面前向我招手. 当世界在我们眼前毁灭时，是时候为垂死的现实献上一曲华尔兹了. \
		尘归尘，土归土. 见证我的飞升!"
	route = PATH_VOID
	///soundloop for the void theme
	var/datum/looping_sound/void_loop/sound_loop
	///Reference to the ongoing voidstrom that surrounds the heretic
	var/datum/weather/void_storm/storm

/datum/heretic_knowledge/ultimate/void_final/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	if(!isopenturf(loc))
		loc.balloon_alert(user, "仪式失败，无效地点!")
		return FALSE

	var/turf/open/our_turf = loc
	if(our_turf.GetTemperature() > T0C)
		loc.balloon_alert(user, "仪式失败，不够寒冷!")
		return FALSE

	return ..()

/datum/heretic_knowledge/ultimate/void_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce(
		text = "[generate_heretic_text()] 虚无贵族[user.real_name]迈着终末华尔兹到来! [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = 'sound/ambience/antag/heretic/ascend_void.ogg',
		color_override = "pink",
	)
	user.client?.give_award(/datum/award/achievement/misc/void_ascension, user)
	ADD_TRAIT(user, TRAIT_RESISTLOWPRESSURE, MAGIC_TRAIT)

	// Let's get this show on the road!
	sound_loop = new(user, TRUE, TRUE)
	RegisterSignal(user, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/heretic_knowledge/ultimate/void_final/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	on_death() // Losing is pretty much dying. I think
	RegisterSignals(user, list(COMSIG_LIVING_LIFE, COMSIG_LIVING_DEATH))

/**
 * Signal proc for [COMSIG_LIVING_LIFE].
 *
 * Any non-heretics nearby the heretic ([source])
 * are constantly silenced and battered by the storm.
 *
 * Also starts storms in any area that doesn't have one.
 */
/datum/heretic_knowledge/ultimate/void_final/proc/on_life(mob/living/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	for(var/mob/living/carbon/close_carbon in view(5, source))
		if(IS_HERETIC_OR_MONSTER(close_carbon))
			continue
		close_carbon.adjust_silence_up_to(2 SECONDS, 20 SECONDS)

	// Telegraph the storm in every area on the station.
	var/list/station_levels = SSmapping.levels_by_trait(ZTRAIT_STATION)
	if(!storm)
		storm = new /datum/weather/void_storm(station_levels)
		storm.telegraph()

	// When the heretic enters a new area, intensify the storm in the new area,
	// and lessen the intensity in the former area.
	var/area/source_area = get_area(source)
	if(!storm.impacted_areas[source_area])
		storm.former_impacted_areas |= storm.impacted_areas
		storm.impacted_areas = list(source_area)
		storm.update_areas()

/**
 * Signal proc for [COMSIG_LIVING_DEATH].
 *
 * Stop the storm when the heretic passes away.
 */
/datum/heretic_knowledge/ultimate/void_final/proc/on_death(datum/source)
	SIGNAL_HANDLER

	if(sound_loop)
		sound_loop.stop()
	if(storm)
		storm.end()
		QDEL_NULL(storm)
