/**
 * # The path of Cosmos.
 *
 * Goes as follows:
 *
 * Eternal Gate
 * Grasp of Cosmos
 * Cosmic Runes
 * > Sidepaths:
 *   Priest's Ritual
 *   Scorching Shark
 *
 * Mark of Cosmos
 * Ritual of Knowledge
 * Star Touch
 * Star Blast
 * > Sidepaths:
 *   Curse of Corrosion
 *   Space Phase
 *
 * Cosmic Blade
 * Cosmic Expansion
 * > Sidepaths:
 *   Eldritch Coin
 *   Rusted Ritual
 *
 * Creators's Gift
 */
/datum/heretic_knowledge/limited_amount/starting/base_cosmic
	name = "永恒门扉"
	desc = "通往宇宙之路. \
		你可以将一块等离子和一把刀具嬗变成宇宙之刃. \
		同一时间只能创造两把出来."
	gain_text = "星云在天空中出现，地狱般地诞生场景向我扑来，这是一个伟大超然的开端."
	next_knowledge = list(/datum/heretic_knowledge/cosmic_grasp)
	required_atoms = list(
		/obj/item/knife = 1,
		/obj/item/stack/sheet/mineral/plasma = 1,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/cosmic)
	route = PATH_COSMIC

/datum/heretic_knowledge/cosmic_grasp
	name = "星空之握"
	desc = "你的漫宿之握将给目标施加星痕(宇宙圆环)并在你脚下创造一个宇宙领域."
	gain_text = "一些恒星熄灭，一些恒星膨胀. 通过新的手段我可以将星云的力量引入自身."
	next_knowledge = list(/datum/heretic_knowledge/spell/cosmic_runes)
	cost = 1
	route = PATH_COSMIC

/datum/heretic_knowledge/cosmic_grasp/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/cosmic_grasp/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/// Aplies the effect of the mansus grasp when it hits a target.
/datum/heretic_knowledge/cosmic_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	to_chat(target, span_danger("宇宙圆环出现在你的头顶上!"))
	target.apply_status_effect(/datum/status_effect/star_mark, source)
	new /obj/effect/forcefield/cosmic_field(get_turf(source))

/datum/heretic_knowledge/spell/cosmic_runes
	name = "宇宙符文"
	desc = "赐予你宇宙符文，这个咒语可以创造两个连接的传送符文，需要站在上面激活来传送. 被施加星痕生物无法激活该符文，但可以借由其他人的激活来传送."
	gain_text = "遥远的星星爬进我的梦里，毫无理由地咆哮与尖叫. 我发出话语却只有回声传来."
	next_knowledge = list(
		/datum/heretic_knowledge/mark/cosmic_mark,
		/datum/heretic_knowledge/essence,
		/datum/heretic_knowledge/summon/fire_shark,
	)
	spell_to_add = /datum/action/cooldown/spell/cosmic_rune
	cost = 1
	route = PATH_COSMIC

/datum/heretic_knowledge/mark/cosmic_mark
	name = "门阈印记"
	desc = "你的漫宿之握现在将施加门阈印记. 门阈印记在受到宇宙之刃攻击时触发. \
		一旦被触发，受害者将会回到最初被打上印记的地方并瘫痪两秒."
	gain_text = "野兽向我低语它们境况的片絮，我可以帮助它们，我必须帮助它们."
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/cosmic)
	route = PATH_COSMIC
	mark_type = /datum/status_effect/eldritch/cosmic

/datum/heretic_knowledge/knowledge_ritual/cosmic
	next_knowledge = list(/datum/heretic_knowledge/spell/star_touch)
	route = PATH_COSMIC

/datum/heretic_knowledge/spell/star_touch
	name = "星之触"
	desc = "赐予你星之触，一种咒语. 会在你的目标上施加星痕，并在你的脚下和旁边的地块上创造宇宙领域. \
		若目标已经带有星痕则会被强制入眠四秒. 当目标被击中时还会产生连线，对目标造成烧伤和细胞伤，除非被阻挡或找到新目标，连线将持续存在一分钟，"
	gain_text = "在一身冷汗中惊醒，我感到一只手掌按上了我的头皮，一个印记在我身上燃烧. 血管里发出奇异紫光，野兽知道我会比它们所期望的还要好."
	next_knowledge = list(/datum/heretic_knowledge/spell/star_blast)
	spell_to_add = /datum/action/cooldown/spell/touch/star_touch
	cost = 1
	route = PATH_COSMIC

/datum/heretic_knowledge/spell/star_blast
	name = "聚变星体"
	desc = "发射一种移动非常缓慢的投射物，在撞击时产生宇宙领域，任何被该投射物击中的人都会被击倒并受到烧伤，并给周围三格内的人施加星痕."
	gain_text = "野兽现在与我如影随形，每次献祭时都会送上肯定的话语."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/cosmic,
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/curse/corrosion,
		/datum/heretic_knowledge/spell/space_phase,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/projectile/star_blast
	cost = 1
	route = PATH_COSMIC

/datum/heretic_knowledge/blade_upgrade/cosmic
	name = "寰宇之刃"
	desc = "你的剑刃现在通过宇宙辐射直接对目标体内器官造成伤害. \
		你的每一次攻击都将标记敌人，最多能标记两人，重复攻击会使标记失效，2秒内不攻击其他敌人也会使标记失效. \
		当标记存在时，你攻击无标记的敌人将触发标记，对被标记者造成伤害. 当这种触发连续超过4次，那么你将获得宇宙轨迹，标记时间延长至10秒." // 标记，经测试疑似没有高连击奖励
	gain_text = "野兽将我的刀刃握在手中，我跪下时感到一阵剧痛. 刀刃上闪着解离的力量. 我匍匐在地，在野兽的脚边哭泣."
	next_knowledge = list(/datum/heretic_knowledge/spell/cosmic_expansion)
	route = PATH_COSMIC
	/// Storage for the second target.
	var/datum/weakref/second_target
	/// Storage for the third target.
	var/datum/weakref/third_target
	/// When this timer completes we reset our combo.
	var/combo_timer
	/// The active duration of the combo.
	var/combo_duration = 3 SECONDS
	/// The duration of a combo when it starts.
	var/combo_duration_amount = 3 SECONDS
	/// The maximum duration of the combo.
	var/max_combo_duration = 10 SECONDS
	/// The amount the combo duration increases.
	var/increase_amount = 0.5 SECONDS
	/// The hits we have on a mob with a mind.
	var/combo_counter = 0

/datum/heretic_knowledge/blade_upgrade/cosmic/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	var/static/list/valid_organ_slots = list(
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_STOMACH,
		ORGAN_SLOT_EYES,
		ORGAN_SLOT_EARS,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_BRAIN
	)
	if(source == target)
		return
	if(combo_timer)
		deltimer(combo_timer)
	combo_timer = addtimer(CALLBACK(src, PROC_REF(reset_combo), source), combo_duration, TIMER_STOPPABLE)
	var/mob/living/second_target_resolved = second_target?.resolve()
	var/mob/living/third_target_resolved = third_target?.resolve()
	var/need_mob_update = FALSE
	need_mob_update += target.adjustFireLoss(5, updating_health = FALSE)
	need_mob_update += target.adjustOrganLoss(pick(valid_organ_slots), 8)
	if(need_mob_update)
		target.updatehealth()
	if(target == second_target_resolved || target == third_target_resolved)
		reset_combo(source)
		return
	if(target.mind && target.stat != DEAD)
		combo_counter += 1
	if(second_target_resolved)
		new /obj/effect/temp_visual/cosmic_explosion(get_turf(second_target_resolved))
		playsound(get_turf(second_target_resolved), 'sound/magic/cosmic_energy.ogg', 25, FALSE)
		need_mob_update = FALSE
		need_mob_update += second_target_resolved.adjustFireLoss(14, updating_health = FALSE)
		need_mob_update += second_target_resolved.adjustOrganLoss(pick(valid_organ_slots), 12)
		if(need_mob_update)
			second_target_resolved.updatehealth()
		if(third_target_resolved)
			new /obj/effect/temp_visual/cosmic_domain(get_turf(third_target_resolved))
			playsound(get_turf(third_target_resolved), 'sound/magic/cosmic_energy.ogg', 50, FALSE)
			need_mob_update = FALSE
			need_mob_update += third_target_resolved.adjustFireLoss(28, updating_health = FALSE)
			need_mob_update += third_target_resolved.adjustOrganLoss(pick(valid_organ_slots), 14)
			if(need_mob_update)
				third_target_resolved.updatehealth()
			if(combo_counter > 3)
				target.apply_status_effect(/datum/status_effect/star_mark, source)
				if(target.mind && target.stat != DEAD)
					increase_combo_duration()
					if(combo_counter == 4)
						source.AddElement(/datum/element/effect_trail, /obj/effect/forcefield/cosmic_field/fast)
		third_target = second_target
	second_target = WEAKREF(target)

/// Resets the combo.
/datum/heretic_knowledge/blade_upgrade/cosmic/proc/reset_combo(mob/living/source)
	second_target = null
	third_target = null
	if(combo_counter > 3)
		source.RemoveElement(/datum/element/effect_trail, /obj/effect/forcefield/cosmic_field/fast)
	combo_duration = combo_duration_amount
	combo_counter = 0
	new /obj/effect/temp_visual/cosmic_cloud(get_turf(source))
	if(combo_timer)
		deltimer(combo_timer)

/// Increases the combo duration.
/datum/heretic_knowledge/blade_upgrade/cosmic/proc/increase_combo_duration()
	if(combo_duration < max_combo_duration)
		combo_duration += increase_amount

/datum/heretic_knowledge/spell/cosmic_expansion
	name = "宇宙膨胀"
	desc = "赐予你宇宙膨胀，一种能在你周围创造3x3的宇宙领域，使附近生物获得星痕的咒语."
	gain_text =  "地面会在我脚下震动. 野兽寄居在我的体内，它们的声音令人陶醉."
	next_knowledge = list(
		/datum/heretic_knowledge/ultimate/cosmic_final,
		/datum/heretic_knowledge/eldritch_coin,
		/datum/heretic_knowledge/summon/rusty,
	)
	spell_to_add = /datum/action/cooldown/spell/conjure/cosmic_expansion
	cost = 1
	route = PATH_COSMIC

/datum/heretic_knowledge/ultimate/cosmic_final
	name = "造物主的馈赠"
	desc = "宇宙之路的飞升仪式. \
		带三具体内含有蓝空尘的尸体到嬗变符文以完成仪式. \
		一旦完成，你将成为观星者的主人. \
		你能通过Alt加左键来对观星者下达命令. \
		你也可以用话语给他下达命令. \
		观星者十分强力，甚至能破坏加固墙. \
		它还附带一个能治疗你和伤害敌人的光环. \
		此外天星照拂在手中激活时，能将你传送到观星者处."
	gain_text = "野兽伸出手，我就握住它. 在故事的尽头，它们曾经高耸的身躯也看起来如此渺小脆弱.\
		我们紧握不放，彼此互相保护. 我闭上双眼，只将头靠在它们身上. 我很安全. 见证我的飞升!"
	route = PATH_COSMIC
	/// A static list of command we can use with our mob.
	var/static/list/star_gazer_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/follow,
		/datum/pet_command/point_targeting/attack/star_gazer
	)

/datum/heretic_knowledge/ultimate/cosmic_final/is_valid_sacrifice(mob/living/carbon/human/sacrifice)
	. = ..()
	if(!.)
		return FALSE

	return sacrifice.has_reagent(/datum/reagent/bluespace)

/datum/heretic_knowledge/ultimate/cosmic_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce(
		text = "[generate_heretic_text()] 观星者降临空间站， [user.real_name]飞升了! 站点终将回归群星怀抱! [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = ANNOUNCER_SPANOMALIES,
		color_override = "pink",
	)
	var/mob/living/basic/heretic_summon/star_gazer/star_gazer_mob = new /mob/living/basic/heretic_summon/star_gazer(loc)
	star_gazer_mob.maxHealth = INFINITY
	star_gazer_mob.health = INFINITY
	user.AddComponent(/datum/component/death_linked, star_gazer_mob)
	star_gazer_mob.AddComponent(/datum/component/obeys_commands, star_gazer_commands)
	star_gazer_mob.AddComponent(/datum/component/damage_aura, range = 7, burn_damage = 0.5, simple_damage = 0.5, immune_factions = list(FACTION_HERETIC), current_owner = user)
	star_gazer_mob.befriend(user)
	var/datum/action/cooldown/open_mob_commands/commands_action = new /datum/action/cooldown/open_mob_commands()
	commands_action.Grant(user, star_gazer_mob)
	var/datum/action/cooldown/spell/touch/star_touch/star_touch_spell = locate() in user.actions
	if(star_touch_spell)
		star_touch_spell.set_star_gazer(star_gazer_mob)
		star_touch_spell.ascended = TRUE

	var/datum/antagonist/heretic/heretic_datum = user.mind.has_antag_datum(/datum/antagonist/heretic)
	var/datum/heretic_knowledge/blade_upgrade/cosmic/blade_upgrade = heretic_datum.get_knowledge(/datum/heretic_knowledge/blade_upgrade/cosmic)
	blade_upgrade.combo_duration = 10 SECONDS
	blade_upgrade.combo_duration_amount = 10 SECONDS
	blade_upgrade.max_combo_duration = 30 SECONDS
	blade_upgrade.increase_amount = 2 SECONDS

	var/datum/action/cooldown/spell/conjure/cosmic_expansion/cosmic_expansion_spell = locate() in user.actions
	cosmic_expansion_spell?.ascended = TRUE

	user.client?.give_award(/datum/award/achievement/misc/cosmic_ascension, user)
