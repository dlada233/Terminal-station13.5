/**
 * # The path of Moon.
 *
 * Goes as follows:
 *
 * Moonlight Troupe
 * Grasp of Lunacy
 * Smile of the moon
 * > Sidepaths:
 *   Mind Gate
 *   Ashen Eyes
 *
 * Mark of Moon
 * Ritual of Knowledge
 * Lunar Parade
 * Moonlight Amulet
 * > Sidepaths:
 *   Curse of Paralasys
 *   Unfathomable Curio
 * 	 Unsealed Arts
 *
 * Moonlight blade
 * Ringleaders Rise
 * > Sidepaths:
 *   Ashen Ritual
 *
 * Last Act
 */
/datum/heretic_knowledge/limited_amount/starting/base_moon
	name = "月光剧团-Base moon"
	desc = "通往月之路. \
		你能将2份铁和1把刀嬗变成月之刃. \
		同一时间只能创造2把出来."
	gain_text = "月光下笑声回荡."
	next_knowledge = list(/datum/heretic_knowledge/moon_grasp)
	required_atoms = list(
		/obj/item/knife = 1,
		/obj/item/stack/sheet/iron = 2,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/moon)
	route = PATH_MOON

/datum/heretic_knowledge/base_moon/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	add_traits(user ,TRAIT_EMPATH, REF(src))

/datum/heretic_knowledge/moon_grasp
	name = "月圆之握"
	desc = "你的漫宿之握让目标产生幻觉，会把每个人都看成月亮， \
		并在短时间内隐藏你的身份."
	gain_text = "月上的剧团展示了真理，我欣然接受."
	next_knowledge = list(/datum/heretic_knowledge/spell/moon_smile)
	cost = 1
	route = PATH_MOON

/datum/heretic_knowledge/moon_grasp/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/moon_grasp/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/moon_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER
	source.apply_status_effect(/datum/status_effect/moon_grasp_hide)

	if(!iscarbon(target))
		return
	var/mob/living/carbon/carbon_target = target
	to_chat(carbon_target, span_danger("你听到遥远上空传来笑声."))
	carbon_target.cause_hallucination(/datum/hallucination/delusion/preset/moon, "delusion/preset/moon hallucination caused by mansus grasp")
	carbon_target.mob_mood.set_sanity(carbon_target.mob_mood.sanity-30)

/datum/heretic_knowledge/spell/moon_smile
	name = "月的微笑"
	desc = "赐予你名为月的微笑的远程法术，使目标沉默、失明、失聪并被击倒，\
		持续时间取决于目标的理智."
	gain_text = "月亮向我们所有人微笑，那些看到它真实一面的人将承载它的喜悦."
	next_knowledge = list(
		/datum/heretic_knowledge/mark/moon_mark,
		/datum/heretic_knowledge/medallion,
		/datum/heretic_knowledge/spell/mind_gate,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/moon_smile
	cost = 1
	route = PATH_MOON

/datum/heretic_knowledge/mark/moon_mark
	name = "月印"
	desc = "你漫宿之握现在对目标施加月印，安抚目标直到被攻击. \
		月刃的攻击可以触发月印，让带有印记的目标陷入困惑."
	gain_text = "月上的剧团跳着永不停歇的舞蹈，\
		在舞蹈中能瞥见月亮对我的微笑， \
		然而每当夜幕降临，那笑容变得迟钝，月球被迫凝视着地球."
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/moon)
	route = PATH_MOON
	mark_type = /datum/status_effect/eldritch/moon

/datum/heretic_knowledge/knowledge_ritual/moon
	next_knowledge = list(/datum/heretic_knowledge/spell/moon_parade)
	route = PATH_MOON

/datum/heretic_knowledge/spell/moon_parade
	name = "月面游行"
	desc = "赐予你名为月面游行的冲锋法术，在短时间的冲锋中被击中的人将会得到狂欢节效果，\
		他们将被迫加入游行并产生幻觉."
	gain_text = "音乐就像灵魂的倒影，驱使着人们飞蛾般扑火."
	next_knowledge = list(/datum/heretic_knowledge/moon_amulet)
	spell_to_add = /datum/action/cooldown/spell/pointed/projectile/moon_parade
	cost = 1
	route = PATH_MOON


/datum/heretic_knowledge/moon_amulet
	name = "月光护符-Moon amulet"
	desc = "你可以将2份玻璃、1颗心脏和1条领带嬗变成月光护符. \
			该护符用在理智较低的人身上时会让他们疯狂地攻击所有人，\
			而理智较高的则会降低他们的心情."
	gain_text = "他站在游行队伍的最前面，月亮凝聚成一团，是灵魂的倒影."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/moon,
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/unfathomable_curio,
		/datum/heretic_knowledge/curse/paralysis,
		/datum/heretic_knowledge/painting,
	)
	required_atoms = list(
		/obj/item/organ/internal/heart = 1,
		/obj/item/stack/sheet/glass = 2,
		/obj/item/clothing/neck/tie = 1,
	)
	result_atoms = list(/obj/item/clothing/neck/heretic_focus/moon_amulet)
	cost = 1
	route = PATH_MOON

/datum/heretic_knowledge/blade_upgrade/moon
	name = "月光之刃"
	desc = "你的月之刃现在能造成脑损伤，造成随机幻觉，并造成理智伤害."
	gain_text = "他的机智幽默犀利如刀，总能戳穿谎言为我们带来欢乐."
	next_knowledge = list(/datum/heretic_knowledge/spell/moon_ringleader)
	route = PATH_MOON

/datum/heretic_knowledge/blade_upgrade/moon/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(source == target)
		return

	target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10, 100)
	target.cause_hallucination( \
			get_random_valid_hallucination_subtype(/datum/hallucination/body), \
			"升级了月之刃", \
		)
	target.emote(pick("giggle", "laugh"))
	target.mob_mood.set_sanity(target.mob_mood.sanity - 10)

/datum/heretic_knowledge/spell/moon_ringleader
	name = "剧团长登台"
	desc = "赐予你名为剧团长登台的AoE法术，对范围内所有人造成脑损伤、幻觉，\
			范围内目标理智越低，效果越好. \
			如果目标理智低到可以致使精神错乱，还能让他们的理智再减半."
	gain_text = "我抓住他的手站了起来，看到真相的人们也站了起来. \
		剧团长向上指了指，真理之光进一步撒下."
	next_knowledge = list(
		/datum/heretic_knowledge/ultimate/moon_final,
		/datum/heretic_knowledge/summon/ashy,
	)
	spell_to_add = /datum/action/cooldown/spell/aoe/moon_ringleader
	cost = 1
	route = PATH_MOON

/datum/heretic_knowledge/ultimate/moon_final
	name = "最后一幕-Moon final"
	desc = "月之路的飞升仪式. \
		携带3具脑损伤超过50的尸体到嬗变符文前以完成仪式. \
		一旦完成仪式，你将化身疯狂的预兆者，自带减少理智，增加混乱的光环，\
		如果范围内目标理智足够低，还会造成脑损伤和失明. \
		五分之一的船员会变成追随你的信徒，他们都将获得月光护符."
	gain_text = "我们俯冲向人群，他的灵魂四散开来去那剧团长游行之地找寻更伟大的冒险，\
		我将接过旗杆与口号，永不停歇地继续下去，直到太阳的死亡见证我的飞升，\
		月亮微笑一次又一次，永永远远不会停歇!"
	route = PATH_MOON

/datum/heretic_knowledge/ultimate/moon_final/is_valid_sacrifice(mob/living/sacrifice)

	var/brain_damage = sacrifice.get_organ_loss(ORGAN_SLOT_BRAIN)
	// Checks if our target has enough brain damage
	if(brain_damage < 50)
		return FALSE

	return ..()

/datum/heretic_knowledge/ultimate/moon_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	var/datum/antagonist/heretic/heretic_datum = IS_HERETIC(user)
	priority_announce(
		text = "[generate_heretic_text()]开怀大笑吧，因为剧团长[user.real_name]已经飞升了! \
				真相终将吞噬一切谎言! [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = 'sound/ambience/antag/heretic/ascend_moon.ogg',
		color_override = "pink",
	)

	user.client?.give_award(/datum/award/achievement/misc/moon_ascension, user)
	ADD_TRAIT(user, TRAIT_MADNESS_IMMUNE, REF(src))
	heretic_datum.add_team_hud(user, /datum/antagonist/lunatic)

	RegisterSignal(user, COMSIG_LIVING_LIFE, PROC_REF(on_life))

	// Roughly 1/5th of the station will rise up as lunatics to the heretic
	for (var/mob/living/carbon/human/crewmate as anything in GLOB.human_list)
		// How many lunatics we have
		var/amount_of_lunatics = 0
		// Where the crewmate is, used to check their z-level
		var/turf/crewmate_turf = get_turf(crewmate)
		var/crewmate_z = crewmate_turf?.z
		if(isnull(crewmate.mind))
			continue
		if(crewmate.stat != CONSCIOUS)
			continue
		if(!is_station_level(crewmate_z))
			continue
		// Heretics, lunatics and monsters shouldn't become lunatics because they either have a master or have a mansus grasp
		if(IS_HERETIC_OR_MONSTER(crewmate))
			to_chat(crewmate, span_boldwarning("[user]的飞升影响了那些意志薄弱的人，他们的心会被撕裂." ))
			continue
		// Mindshielded and anti-magic folks are immune against this effect because this is a magical mind effect
		if(HAS_TRAIT(crewmate, TRAIT_MINDSHIELD) || crewmate.can_block_magic(MAGIC_RESISTANCE))
			to_chat(crewmate, span_boldwarning("你感觉被某物保护了." ))
			continue
		if(amount_of_lunatics > length(GLOB.human_list) * 0.2)
			to_chat(crewmate, span_boldwarning("你感到不安，仿佛有什么东西盯着你看了一会儿." ))
			continue
		var/datum/antagonist/lunatic/lunatic = crewmate.mind.add_antag_datum(/datum/antagonist/lunatic)
		lunatic.set_master(user.mind, user)
		var/obj/item/clothing/neck/heretic_focus/moon_amulet/amulet = new(crewmate_turf)
		var/static/list/slots = list(
			"neck" = ITEM_SLOT_NECK,
			"hands" = ITEM_SLOT_HANDS,
			"backpack" = ITEM_SLOT_BACKPACK,
			"right pocket" = ITEM_SLOT_RPOCKET,
			"left pocket" = ITEM_SLOT_RPOCKET,
		)
		crewmate.equip_in_one_of_slots(amulet, slots, qdel_on_fail = FALSE)
		crewmate.emote("laugh")
		amount_of_lunatics += 1

/datum/heretic_knowledge/ultimate/moon_final/proc/on_life(mob/living/source, seconds_per_tick, times_fired)
	var/obj/effect/moon_effect = /obj/effect/temp_visual/moon_ringleader
	SIGNAL_HANDLER

	visible_hallucination_pulse(
		center = get_turf(source),
		radius = 7,
		hallucination_duration = 60 SECONDS
	)

	for(var/mob/living/carbon/carbon_view in view(5, source))
		var/carbon_sanity = carbon_view.mob_mood.sanity
		if(carbon_view.stat != CONSCIOUS)
			continue
		if(IS_HERETIC_OR_MONSTER(carbon_view))
			continue
		new moon_effect(get_turf(carbon_view))
		carbon_view.adjust_confusion(2 SECONDS)
		carbon_view.mob_mood.set_sanity(carbon_sanity - 5)
		if(carbon_sanity < 30)
			if(SPT_PROB(20, seconds_per_tick))
				to_chat(carbon_view, span_warning("你感到你的思绪开始被撕裂!"))
			carbon_view.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
		if(carbon_sanity < 10)
			if(SPT_PROB(20, seconds_per_tick))
				to_chat(carbon_view, span_warning("它在你心中回响!"))
			visible_hallucination_pulse(
				center = get_turf(carbon_view),
				radius = 7,
				hallucination_duration = 50 SECONDS
			)
			carbon_view.adjust_temp_blindness(5 SECONDS)
