/**
 * # The path of Ash.
 *
 * Goes as follows:
 *
 * Nightwatcher's Secret
 * Grasp of Ash
 * Ashen Passage
 * > Sidepaths:
 *   Scorching Shark
 *   Ashen Eyes
 *
 * Mark of Ash
 * Ritual of Knowledge
 * Fire Blast
 * Mask of Madness
 * > Sidepaths:
 *   Space Phase
 *   Curse of Paralysis
 *
 * Fiery Blade
 * Nightwatcher's Rebirth
 * > Sidepaths:
 *   Ashen Ritual
 *   Eldritch Coin
 *
 * Ashlord's Rite
 */
/datum/heretic_knowledge/limited_amount/starting/base_ash
	name = "守夜人的秘密-Base ash"
	desc = "通往灰烬之路. \
		你将能把火柴和刀具嬗变为灰烬之刃. \
		同一时间只能创造五把出来." //SKYRAT EDIT two to five
	gain_text = "城市守卫知道它的守望，如果你在晚上问他们，他们可能会告诉你灰烬灯笼的事"
	next_knowledge = list(/datum/heretic_knowledge/ashen_grasp)
	required_atoms = list(
		/obj/item/knife = 1,
		/obj/item/match = 1,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/ash)
	route = PATH_ASH

/datum/heretic_knowledge/ashen_grasp
	name = "掸灰之握"
	desc = "你的漫宿之握将灼烧受害者眼睛，造成伤害和失明."
	gain_text = "守夜人是第一个，他的背叛引发了这一切. 他的灯笼已经化为灰烬，随着表一并消失."
	next_knowledge = list(/datum/heretic_knowledge/spell/ash_passage)
	cost = 1
	route = PATH_ASH

/datum/heretic_knowledge/ashen_grasp/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/ashen_grasp/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/ashen_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(target.is_blind())
		return

	if(!target.get_organ_slot(ORGAN_SLOT_EYES))
		return

	to_chat(target, span_danger("骤亮的绿色光芒可怕地灼伤了你的眼睛!"))
	target.adjustOrganLoss(ORGAN_SLOT_EYES, 15)
	target.set_eye_blur_if_lower(20 SECONDS)

/datum/heretic_knowledge/spell/ash_passage
	name = "隐尘漫行"
	desc = "赐予你隐尘漫行，一次消无声息的短距移动."
	gain_text = "他知道如何穿行于位面间."
	next_knowledge = list(
		/datum/heretic_knowledge/mark/ash_mark,
		/datum/heretic_knowledge/summon/fire_shark,
		/datum/heretic_knowledge/medallion,
	)
	spell_to_add = /datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash
	cost = 1
	route = PATH_ASH

/datum/heretic_knowledge/mark/ash_mark
	name = "余烬祷记"
	desc = "你的漫宿之握将施加余烬祷记. 拥有余烬祷记的目标在被灰烬之刃攻击时会收到额外的耐力和烧伤，并且余烬祷记还将转移到附近的不信之人身上. 伤害会随着转移次数而衰减."
	gain_text = "他是一个非常特别的人，总是在夜深人静的时候警觉地守望着. \
		但尽管责任在身，他也常会高举燃烧的灯笼，出神地穿过旧宅间. \
		他在黑暗中闪耀着明亮光芒，直到那熊熊火焰开始消逝."
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/ash)
	route = PATH_ASH
	mark_type = /datum/status_effect/eldritch/ash

/datum/heretic_knowledge/mark/ash_mark/trigger_mark(mob/living/source, mob/living/target)
	. = ..()
	if(!.)
		return

	// Also refunds 75% of charge!
	var/datum/action/cooldown/spell/touch/mansus_grasp/grasp = locate() in source.actions
	if(grasp)
		grasp.next_use_time = min(round(grasp.next_use_time - grasp.cooldown_time * 0.75, 0), 0)
		grasp.build_all_button_icons()

/datum/heretic_knowledge/knowledge_ritual/ash
	next_knowledge = list(/datum/heretic_knowledge/spell/fire_blast)
	route = PATH_ASH

/datum/heretic_knowledge/spell/fire_blast
	name = "热炎迸发"
	desc = "赐予你热炎迸发，一种咒语. 经过充能后向附近的敌人发射一束能量，使其烧伤并着火. 如果他们不自行扑灭，能量还将弹射到附近目标身上"
	gain_text = "火之将熄，没有余温使其复燃，没有光芒化为救赎."
	next_knowledge = list(/datum/heretic_knowledge/mad_mask)
	spell_to_add = /datum/action/cooldown/spell/charged/beam/fire_blast
	cost = 1
	route = PATH_ASH


/datum/heretic_knowledge/mad_mask
	name = "蒙尘面罩-Mad mask"
	desc = "这狂人的假面可由任意面具、四根蜡烛、一根电棍以及一块肝脏创造出来. \
		假面将恐惧灌输给任何看到它的不信之人，造成耐力损伤、幻觉和精神错乱. \
		也可以将假面强行戴在不信之人脸上，他们无法脱下这幅假面..."
	gain_text = "守夜人消失了，守卫们深信不疑. 然而前者在世间行走着，不被众生所察觉着."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/ash,
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/spell/space_phase,
		/datum/heretic_knowledge/curse/paralysis,
	)
	required_atoms = list(
		/obj/item/organ/internal/liver = 1,
		/obj/item/melee/baton/security = 1,  // Technically means a cattleprod is valid
		/obj/item/clothing/mask = 1,
		/obj/item/flashlight/flare/candle = 4,
	)
	result_atoms = list(/obj/item/clothing/mask/madness_mask)
	cost = 1
	route = PATH_ASH

/datum/heretic_knowledge/blade_upgrade/ash
	name = "劫火法刃"
	desc = "你的刃将能够猛烈点燃敌人."
	gain_text = "他回来时，手中有剑，挥舞时天空飘来灰烬. \
		他的城市，他的人民，他守望着他们全部烧成灰烬."
	next_knowledge = list(/datum/heretic_knowledge/spell/flame_birth)
	route = PATH_ASH

/datum/heretic_knowledge/blade_upgrade/ash/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(source == target)
		return

	target.adjust_fire_stacks(1)
	target.ignite_mob()

/datum/heretic_knowledge/spell/flame_birth
	name = "守夜人的重生"
	desc = "赐予你守夜人的重生，为自身灭火并疗伤，同时伤害周围着火的不信之人的咒语. \
		每有一名受此影响的不信之人都会治疗你，陷入濒死的不信之人将立刻死亡. "
	gain_text = "火焰最终吞噬了一切，然而焦黑的残躯里仍有生命留存. \
		守夜人是一个特别的人，总是在守望着."
	next_knowledge = list(
		/datum/heretic_knowledge/ultimate/ash_final,
		/datum/heretic_knowledge/summon/ashy,
		/datum/heretic_knowledge/eldritch_coin,
	)
	spell_to_add = /datum/action/cooldown/spell/aoe/fiery_rebirth
	cost = 1
	route = PATH_ASH

/datum/heretic_knowledge/ultimate/ash_final
	name = "灰烬之主的仪式-Ash final"
	desc = "灰烬之路的飞升仪式. \
		将三具燃烧或烧干的尸体带到嬗变符文前以完成仪式. \
		一旦完成，你将化身火焰使者，同时获得流火和火焰之誓两个技能. \
		流火会在你周围产生一个巨大的，不断增长的火环；\
		火焰之誓会让你在行走时被动地生成一个火环. \
		此外，你对火焰、太空或类似的环境危害免疫."
	gain_text = "守卫死了，守夜人也陨落火场. 然而他的火焰却永不熄灭，因为人类已经获此馈赠! \
		我化身烈火，继续使他的目光洒满人间, \
		见证我的飞升!灰烬的灯笼再次复燃!"
	route = PATH_ASH
	/// A static list of all traits we apply on ascension.
	var/static/list/traits_to_apply = list(
		TRAIT_BOMBIMMUNE,
		TRAIT_NOBREATH,
		TRAIT_NOFIRE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
	)

/datum/heretic_knowledge/ultimate/ash_final/is_valid_sacrifice(mob/living/carbon/human/sacrifice)
	. = ..()
	if(!.)
		return

	if(sacrifice.on_fire)
		return TRUE
	if(HAS_TRAIT_FROM(sacrifice, TRAIT_HUSK, BURN))
		return TRUE
	return FALSE

/datum/heretic_knowledge/ultimate/ash_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce(
		text = "[generate_heretic_text()]敬畏火焰，以敬灰烬之主，[user.real_name]飞升了! 火焰将焚烧万物! [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = 'sound/ambience/antag/heretic/ascend_ash.ogg',
		color_override = "pink",
	)

	var/datum/action/cooldown/spell/fire_sworn/circle_spell = new(user.mind)
	circle_spell.Grant(user)

	var/datum/action/cooldown/spell/fire_cascade/big/screen_wide_fire_spell = new(user.mind)
	screen_wide_fire_spell.Grant(user)

	var/datum/action/cooldown/spell/charged/beam/fire_blast/existing_beam_spell = locate() in user.actions
	if(existing_beam_spell)
		existing_beam_spell.max_beam_bounces *= 2 // Double beams
		existing_beam_spell.beam_duration *= 0.66 // Faster beams
		existing_beam_spell.cooldown_time *= 0.66 // Lower cooldown

	var/datum/action/cooldown/spell/aoe/fiery_rebirth/fiery_rebirth = locate() in user.actions
	fiery_rebirth?.cooldown_time *= 0.16

	user.client?.give_award(/datum/award/achievement/misc/ash_ascension, user)
	if(length(traits_to_apply))
		user.add_traits(traits_to_apply, MAGIC_TRAIT)
