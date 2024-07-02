//These mutations change your overall "form" somehow, like size

//Epilepsy gives a very small chance to have a seizure every life tick, knocking you unconscious.
/datum/mutation/human/epilepsy
	name = "癫痫"
	desc = "一种偶尔引起癫痫发作的遗传缺陷."
	instability = NEGATIVE_STABILITY_MODERATE
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>你感觉头疼.</span>"
	synchronizer_coeff = 1
	power_coeff = 1

/datum/mutation/human/epilepsy/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(0.5 * GET_MUTATION_SYNCHRONIZER(src), seconds_per_tick))
		trigger_seizure()

/datum/mutation/human/epilepsy/proc/trigger_seizure()
	if(owner.stat != CONSCIOUS)
		return
	owner.visible_message(span_danger("[owner]开始癫痫发作!"), span_userdanger("你癫痫发作了!"))
	owner.Unconscious(200 * GET_MUTATION_POWER(src))
	owner.set_jitter(2000 SECONDS * GET_MUTATION_POWER(src)) //yes this number looks crazy but the jitter animations are amplified based on the duration.
	owner.add_mood_event("epilepsy", /datum/mood_event/epilepsy)
	addtimer(CALLBACK(src, PROC_REF(jitter_less)), 9 SECONDS)

/datum/mutation/human/epilepsy/proc/jitter_less()
	if(QDELETED(owner))
		return

	owner.set_jitter(20 SECONDS)

/datum/mutation/human/epilepsy/on_acquiring(mob/living/carbon/human/acquirer)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_FLASHED, PROC_REF(get_flashed_nerd))

/datum/mutation/human/epilepsy/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_FLASHED)

/datum/mutation/human/epilepsy/proc/get_flashed_nerd()
	SIGNAL_HANDLER

	if(!prob(30))
		return
	trigger_seizure()


//Unstable DNA induces random mutations!
/datum/mutation/human/bad_dna
	name = "不稳定DNA"
	desc = "一种奇怪的变异，会导致携带者产生随机变异."
	instability = NEGATIVE_STABILITY_MAJOR
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>你有种古怪的感觉.</span>"
	locked = TRUE

/datum/mutation/human/bad_dna/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	to_chat(owner, text_gain_indication)
	var/mob/new_mob
	if(prob(95))
		switch(rand(1,3))
			if(1)
				new_mob = owner.easy_random_mutate(NEGATIVE + MINOR_NEGATIVE)
			if(2)
				new_mob = owner.random_mutate_unique_identity()
			if(3)
				new_mob = owner.random_mutate_unique_features()
	else
		new_mob = owner.easy_random_mutate(POSITIVE)
	if(new_mob && ismob(new_mob))
		owner = new_mob
	. = owner
	on_losing(owner)


//Cough gives you a chronic cough that causes you to drop items.
/datum/mutation/human/cough
	name = "咳嗽"
	desc = "慢性咳嗽."
	instability = NEGATIVE_STABILITY_MODERATE
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='danger'>你开始咳嗽起来.</span>"
	synchronizer_coeff = 1
	power_coeff = 1

/datum/mutation/human/cough/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(2.5 * GET_MUTATION_SYNCHRONIZER(src), seconds_per_tick) && owner.stat == CONSCIOUS)
		owner.drop_all_held_items()
		owner.emote("cough")
		if(GET_MUTATION_POWER(src) > 1)
			var/cough_range = GET_MUTATION_POWER(src) * 4
			var/turf/target = get_ranged_target_turf(owner, REVERSE_DIR(owner.dir), cough_range)
			owner.throw_at(target, cough_range, GET_MUTATION_POWER(src))

/datum/mutation/human/paranoia
	name = "躁狂症"
	desc = "对象容易受到惊吓，并可能产生幻觉."
	instability = NEGATIVE_STABILITY_MODERATE
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>你感觉尖叫声回荡在你的脑海中...</span>"
	text_lose_indication = "<span class='notice'>萦绕在脑海中的尖叫声逐渐消逝.</span>"

/datum/mutation/human/paranoia/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(2.5, seconds_per_tick) && owner.stat == CONSCIOUS)
		owner.emote("scream")
		if(prob(25))
			owner.adjust_hallucinations(40 SECONDS)

//Dwarfism shrinks your body and lets you pass tables.
/datum/mutation/human/dwarfism
	name = "侏儒"
	desc = "一种被认为导致了侏儒症的突变."
	quality = POSITIVE
	difficulty = 16
	instability = POSITIVE_INSTABILITY_MINOR
	conflicts = list(/datum/mutation/human/gigantism, /datum/mutation/human/acromegaly)
	locked = TRUE // Default intert species for now, so locked from regular pool.

/datum/mutation/human/dwarfism/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	// SKYRAT EDIT BEGIN
	if(owner.dna.features["body_size"] < 1 || isteshari(owner))
		to_chat(owner, "你感觉身体缩小了，但你的器官没有跟着一起！糟了!")
		owner.adjustBruteLoss(25)
		return
	// SKYRAT EDIT END
	ADD_TRAIT(owner, TRAIT_DWARF, GENETIC_MUTATION)
	owner.visible_message(span_danger("[owner]突然缩小了!"), span_notice("周围的一切似乎变大了."))

/datum/mutation/human/dwarfism/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	// SKYRAT EDIT BEGIN
	if(owner.dna.features["body_size"] < 1 || isteshari(owner))
		to_chat(owner, "随着器官挤压的感觉消失，你感到无比轻松..")
		REMOVE_TRAIT(owner, TRAIT_DWARF, GENETIC_MUTATION)
		return
	// SKYRAT EDIT END
	REMOVE_TRAIT(owner, TRAIT_DWARF, GENETIC_MUTATION)
	owner.visible_message(span_danger("[owner]突然变大了!"), span_notice("周围的一切似乎变小了"))

/datum/mutation/human/acromegaly
	name = "Acromegaly"
	desc = "A mutation believed to be the cause of acromegaly, or 'being unusually tall'."
	quality = MINOR_NEGATIVE
	difficulty = 16
	instability = NEGATIVE_STABILITY_MODERATE
	synchronizer_coeff = 1
	conflicts = list(/datum/mutation/human/dwarfism)

/datum/mutation/human/acromegaly/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_TOO_TALL, GENETIC_MUTATION)
	owner.visible_message(span_danger("[owner] suddenly grows tall!"), span_notice("You feel a small strange urge to fight small men with slingshots. Or maybe play some basketball."))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(head_bonk))
	owner.regenerate_icons()

/datum/mutation/human/acromegaly/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_TOO_TALL, GENETIC_MUTATION)
	owner.visible_message(span_danger("[owner] suddenly shrinks!"), span_notice("You return to your usual height."))
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(head_bonk))
	owner.regenerate_icons()

// This is specifically happening because they're not used to their new height and are stumbling around into machinery made for normal humans
/datum/mutation/human/acromegaly/proc/head_bonk(mob/living/parent)
	SIGNAL_HANDLER
	var/turf/airlock_turf = get_turf(parent)
	var/atom/movable/whacked_by = locate(/obj/machinery/door/airlock) in airlock_turf || locate(/obj/machinery/door/firedoor) in airlock_turf || locate(/obj/structure/mineral_door) in airlock_turf
	if(!whacked_by || prob(100 - (8 *  GET_MUTATION_SYNCHRONIZER(src))))
		return
	to_chat(parent, span_danger("You hit your head on \the [whacked_by]'s header!"))
	var/dmg = HAS_TRAIT(parent, TRAIT_HEAD_INJURY_BLOCKED) ? rand(1,4) : rand(2,9)
	parent.apply_damage(dmg, BRUTE, BODY_ZONE_HEAD)
	parent.do_attack_animation(whacked_by, ATTACK_EFFECT_PUNCH)
	playsound(whacked_by, 'sound/effects/bang.ogg', 10, TRUE)
	parent.adjust_staggered_up_to(STAGGERED_SLOWDOWN_LENGTH, 10 SECONDS)

/datum/mutation/human/gigantism
	name = "Gigantism" //negative version of dwarfism
	desc = "The cells within the subject spread out to cover more area, making the subject appear larger."
	quality = MINOR_NEGATIVE
	difficulty = 12
	conflicts = list(/datum/mutation/human/dwarfism)

/datum/mutation/human/gigantism/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	// SKYRAT EDIT BEGIN
	if(owner.dna.features["body_size"] > 1)
		to_chat(owner, "You feel your body expanding even further, but it feels like your bones are expanding too much!")
		owner.adjustBruteLoss(25) // take some DAMAGE
		return
	// SKYRAT EDIT END
	ADD_TRAIT(owner, TRAIT_GIANT, GENETIC_MUTATION)
	owner.update_transform(1.25)
	owner.visible_message(span_danger("[owner] suddenly grows!"), span_notice("Everything around you seems to shrink.."))

/datum/mutation/human/gigantism/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	// SKYRAT EDIT BEGIN
	if(owner.dna.features["body_size"] > 1)
		to_chat(owner, "You feel relief as your bones cease their growth spurt.")
		REMOVE_TRAIT(owner, TRAIT_GIANT, GENETIC_MUTATION)
		return
	// SKYRAT EDIT END

//Clumsiness has a very large amount of small drawbacks depending on item.
/datum/mutation/human/clumsy
	name = "笨拙"
	desc = "一种抑制了某些大脑功能的基因组，使携带者显得十分笨拙. Honk!"
	instability = NEGATIVE_STABILITY_MAJOR
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='danger'>你感觉头晕目眩.</span>"

/datum/mutation/human/clumsy/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_CLUMSY, GENETIC_MUTATION)

/datum/mutation/human/clumsy/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_CLUMSY, GENETIC_MUTATION)


//Tourettes causes you to randomly stand in place and shout.
/datum/mutation/human/tourettes
	name = "秽语综合征"
	desc = "一种慢性抽搐，会迫使携带者尖叫骂出难听的话." //definitely needs rewriting
	quality = NEGATIVE
	instability = 0
	text_gain_indication = "<span class='danger'>你抽搐了一下.</span>"
	synchronizer_coeff = 1

/datum/mutation/human/tourettes/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(5 * GET_MUTATION_SYNCHRONIZER(src), seconds_per_tick) && owner.stat == CONSCIOUS && !owner.IsStun())
		switch(rand(1, 3))
			if(1)
				owner.emote("twitch")
			if(2 to 3)
				owner.say("[prob(50) ? ";" : ""][pick("该死", "烦死了", "操", "逼养的", "杂种", "操你妈", "蠢货")]", forced=name)
		var/x_offset_old = owner.pixel_x
		var/y_offset_old = owner.pixel_y
		var/x_offset = owner.pixel_x + rand(-2,2)
		var/y_offset = owner.pixel_y + rand(-1,1)
		animate(owner, pixel_x = x_offset, pixel_y = y_offset, time = 1)
		animate(owner, pixel_x = x_offset_old, pixel_y = y_offset_old, time = 1)


//Deafness makes you deaf.
/datum/mutation/human/deaf
	name = "失聪"
	desc = "拥有该基因组的人完全失聪."
	instability = NEGATIVE_STABILITY_MAJOR
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>你似乎听不见声音了.</span>"

/datum/mutation/human/deaf/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_DEAF, GENETIC_MUTATION)

/datum/mutation/human/deaf/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_DEAF, GENETIC_MUTATION)


//Monified turns you into a monkey.
/datum/mutation/human/race
	name = "猴化"
	desc = "一个奇怪的基因组，据信是区分猴子与人类差异的关键."
	text_gain_indication = "你怪异地觉得像猴子一样."
	text_lose_indication = "你感觉又恢复了原先的自我."
	quality = NEGATIVE
	instability = NEGATIVE_STABILITY_MAJOR // mmmonky
	remove_on_aheal = FALSE
	locked = TRUE //Species specific, keep out of actual gene pool
	mutadone_proof = TRUE
	var/datum/species/original_species = /datum/species/human
	var/original_name

/datum/mutation/human/race/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	if(!ismonkey(owner))
		original_species = owner.dna.species.type
		original_name = owner.real_name
		owner.fully_replace_character_name(null, "猴子 ([rand(1,999)])")
	. = owner.monkeyize()

/datum/mutation/human/race/on_losing(mob/living/carbon/human/owner)
	if(!QDELETED(owner) && owner.stat != DEAD && (owner.dna.mutations.Remove(src)) && ismonkey(owner))
		owner.fully_replace_character_name(null, original_name)
		. = owner.humanize(original_species)

/datum/mutation/human/glow
	name = "荧光"
	desc = "你永久性的散发随机颜色和强度的荧光."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>你的皮肤开始散发出柔和的光线.</span>"
	instability = POSITIVE_INSTABILITY_MINI
	power_coeff = 1
	conflicts = list(/datum/mutation/human/glow/anti)
	var/glow_power = 2
	var/glow_range = 2.5
	var/glow_color
	var/obj/effect/dummy/lighting_obj/moblight/glow

/datum/mutation/human/glow/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	glow_color = get_glow_color()
	glow = owner.mob_light()
	modify()

// Override modify here without a parent call, because we don't actually give an action.
/datum/mutation/human/glow/modify()
	if(!glow)
		return

	glow.set_light_range_power_color(glow_range * GET_MUTATION_POWER(src), glow_power, glow_color)

/datum/mutation/human/glow/on_losing(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	QDEL_NULL(glow)

/// Returns a color for the glow effect
/datum/mutation/human/glow/proc/get_glow_color()
	return pick(COLOR_RED, COLOR_BLUE, COLOR_YELLOW, COLOR_GREEN, COLOR_PURPLE, COLOR_ORANGE)

/datum/mutation/human/glow/anti
	name = "反荧光"
	desc = "你的皮肤似乎会吸引和吸收附近的光线，在你周围制造“黑暗”."
	text_gain_indication = "<span class='notice'>你身边的光线似乎消失了.</span>"
	conflicts = list(/datum/mutation/human/glow)
	instability = POSITIVE_INSTABILITY_MINOR
	locked = TRUE
	glow_power = -1.5

/datum/mutation/human/glow/anti/get_glow_color()
	return COLOR_BLACK

/datum/mutation/human/strong
	name = "强壮"
	desc = "携带者的肌肉轻微扩张了."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>你感觉变得强壮.</span>"
	instability = POSITIVE_INSTABILITY_MINI
	difficulty = 16

/datum/mutation/human/strong/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	ADD_TRAIT(owner, TRAIT_STRENGTH, GENETIC_MUTATION)

/datum/mutation/human/strong/on_losing(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	REMOVE_TRAIT(owner, TRAIT_STRENGTH, GENETIC_MUTATION)


/datum/mutation/human/stimmed
	name = "自我刺激"
	desc = "携带者的化学平衡更稳定."
	quality = POSITIVE
	instability = POSITIVE_INSTABILITY_MINI
	text_gain_indication = "<span class='notice'>你感觉精力充沛.</span>"
	difficulty = 16

/datum/mutation/human/stimmed/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	ADD_TRAIT(owner, TRAIT_STIMMED, GENETIC_MUTATION)

/datum/mutation/human/stimmed/on_losing(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	REMOVE_TRAIT(owner, TRAIT_STIMMED, GENETIC_MUTATION)

/datum/mutation/human/insulated
	name = "绝缘"
	desc = "受影响者不再导电."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>你的指尖变得麻木.</span>"
	text_lose_indication = "<span class='notice'>你的指尖恢复了知觉.</span>"
	difficulty = 16
	instability = POSITIVE_INSTABILITY_MODERATE

/datum/mutation/human/insulated/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_SHOCKIMMUNE, GENETIC_MUTATION)

/datum/mutation/human/insulated/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_SHOCKIMMUNE, GENETIC_MUTATION)

/datum/mutation/human/fire
	name = "可燃汗液"
	desc = "携带者的皮肤会随机燃烧，但对火焰具有更强的抗性."
	quality = NEGATIVE
	text_gain_indication = "<span class='warning'>你感觉一股热感袭来.</span>"
	text_lose_indication = "<span class='notice'>你感觉凉快多了.</span>"
	difficulty = 14
	synchronizer_coeff = 1
	power_coeff = 1

/datum/mutation/human/fire/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB((0.05+(100-dna.stability)/19.5) * GET_MUTATION_SYNCHRONIZER(src), seconds_per_tick))
		owner.adjust_fire_stacks(2 * GET_MUTATION_POWER(src))
		owner.ignite_mob()

/datum/mutation/human/fire/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.physiology.burn_mod *= 0.5

/datum/mutation/human/fire/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.physiology.burn_mod *= 2

/datum/mutation/human/badblink
	name = "空间不稳定性"
	desc = "受突变者与现实空间的联系非常微弱，有时可能会被放逐. 通常会引起极度的恶心."
	quality = NEGATIVE
	text_gain_indication = "<span class='warning'>你周围的空间开始不自然扭曲.</span>"
	text_lose_indication = "<span class='notice'>你周围的空间变回正常.</span>"
	difficulty = 18//high so it's hard to unlock and abuse
	instability = NEGATIVE_STABILITY_MODERATE
	synchronizer_coeff = 1
	energy_coeff = 1
	power_coeff = 1
	var/warpchance = 0

/datum/mutation/human/badblink/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(warpchance, seconds_per_tick))
		var/warpmessage = pick(
		span_warning("随着背部一阵令人作呕的720°扭曲, [owner]消失于空气之中."),
		span_warning("[owner]做了一个奇怪的后空翻，进入了另一个维度. 看起来很疼"),
		span_warning("[owner]向左跳一步，向右走一步，扭曲了现实."),
		span_warning("[owner]的躯干开始向内折叠直至从现实中消失,将[owner]带走了."),
		span_warning("一瞬间，你看到了[owner]. 下一秒， [owner]消失了."))
		owner.visible_message(warpmessage, span_userdanger("你感到一阵恶心，仿佛穿越了现实！!"))
		var/warpdistance = rand(10, 15) * GET_MUTATION_POWER(src)
		do_teleport(owner, get_turf(owner), warpdistance, channel = TELEPORT_CHANNEL_FREE)
		owner.adjust_disgust(GET_MUTATION_SYNCHRONIZER(src) * (warpchance * warpdistance))
		warpchance = 0
		owner.visible_message(span_danger("[owner]凭空出现了!"))
	else
		warpchance += 0.0625 * seconds_per_tick / GET_MUTATION_ENERGY(src)

/datum/mutation/human/acidflesh
	name = "酸性血肉"
	desc = "实验对象的皮肤下有酸性物质积聚，这通常是致命的."
	instability = NEGATIVE_STABILITY_MAJOR
	quality = NEGATIVE
	text_gain_indication = "<span class='userdanger'> 一股可怕的灼烧感笼罩着你，你的血肉变成了酸!</span>"
	text_lose_indication = "<span class='notice'>一阵轻松感涌来，你的皮肤恢复了正常.</span>"
	difficulty = 18//high so it's hard to unlock and use on others
	/// The cooldown for the warning message
	COOLDOWN_DECLARE(msgcooldown)

/datum/mutation/human/acidflesh/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(13, seconds_per_tick))
		if(COOLDOWN_FINISHED(src, msgcooldown))
			to_chat(owner, span_danger("你的酸性血肉不断冒泡..."))
			COOLDOWN_START(src, msgcooldown, 20 SECONDS)
		if(prob(15))
			owner.acid_act(rand(30, 50), 10)
			owner.visible_message(span_warning("[owner]的皮肤起泡并破裂开来."), span_userdanger("你的皮肤正起泡和破裂! 它在燃烧!"))
			playsound(owner,'sound/weapons/sear.ogg', 50, TRUE)

/datum/mutation/human/spastic
	name = "痉挛"
	desc = "受试者的肌肉痉挛."
	instability = NEGATIVE_STABILITY_MODERATE
	quality = NEGATIVE
	text_gain_indication = "<span class='你感到一阵抽搐.</span>"
	text_lose_indication = "<span class='notice'>抽搐的感觉逐渐消退.</span>"
	difficulty = 16

/datum/mutation/human/spastic/on_acquiring()
	if(..())
		return
	owner.apply_status_effect(/datum/status_effect/spasms)

/datum/mutation/human/spastic/on_losing()
	if(..())
		return
	owner.remove_status_effect(/datum/status_effect/spasms)

/datum/mutation/human/extrastun
	name = "双左脚"
	desc = "一种基因突变，使你的右脚变成另一只左脚. 症状包括走路时会绊倒自己，和地板热吻."
	instability = NEGATIVE_STABILITY_MODERATE
	quality = NEGATIVE
	text_gain_indication = "<span class='warning'>Your right foot feels... left.</span>"
	text_lose_indication = "<span class='notice'>Your right foot feels alright.</span>"
	difficulty = 16

/datum/mutation/human/extrastun/on_acquiring()
	. = ..()
	if(.)
		return
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))

/datum/mutation/human/extrastun/on_losing()
	. = ..()
	if(.)
		return
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

///Triggers on moved(). Randomly makes the owner trip
/datum/mutation/human/extrastun/proc/on_move()
	SIGNAL_HANDLER

	if(prob(99.5)) //The brawl mutation
		return
	if(owner.buckled || owner.body_position == LYING_DOWN || HAS_TRAIT(owner, TRAIT_IMMOBILIZED) || owner.throwing || owner.movement_type & (VENTCRAWLING | FLYING | FLOATING))
		return //remove the 'edge' cases
	to_chat(owner, span_danger("You trip over your own feet."))
	owner.Knockdown(30)

/datum/mutation/human/martyrdom
	name = "内爆殉道"
	desc = "一种基因突变，使身体在接近死亡时自我毁灭. 不会造成伤害，但会极度迷失方向."
	instability = NEGATIVE_STABILITY_MAJOR // free stability >:)
	locked = TRUE
	quality = POSITIVE //not that cloning will be an option a lot but generally lets keep this around i guess?
	text_gain_indication = "<span class='warning'>你感到一阵剧烈的烧灼感.</span>"
	text_lose_indication = "<span class='notice'>你的内脏感觉很舒服.</span>"

/datum/mutation/human/martyrdom/on_acquiring()
	. = ..()
	if(.)
		return TRUE
	RegisterSignal(owner, COMSIG_MOB_STATCHANGE, PROC_REF(bloody_shower))

/datum/mutation/human/martyrdom/on_losing()
	. = ..()
	if(.)
		return TRUE
	UnregisterSignal(owner, COMSIG_MOB_STATCHANGE)

/datum/mutation/human/martyrdom/proc/bloody_shower(datum/source, new_stat)
	SIGNAL_HANDLER

	if(new_stat != HARD_CRIT)
		return
	var/list/organs = owner.get_organs_for_zone(BODY_ZONE_HEAD, TRUE)

	for(var/obj/item/organ/I in organs)
		qdel(I)

	explosion(owner, light_impact_range = 2, adminlog = TRUE, explosion_cause = src)
	for(var/mob/living/carbon/human/splashed in view(2, owner))
		var/obj/item/organ/internal/eyes/eyes = splashed.get_organ_slot(ORGAN_SLOT_EYES)
		if(eyes)
			to_chat(splashed, span_userdanger("你被一阵血雨弄瞎了!"))
			eyes.apply_organ_damage(5)
		else
			to_chat(splashed, span_userdanger("你被一股... 血浪击倒?!"))
		splashed.Stun(2 SECONDS)
		splashed.set_eye_blur_if_lower(40 SECONDS)
		splashed.adjust_confusion(3 SECONDS)
	for(var/mob/living/silicon/borgo in view(2, owner))
		to_chat(borgo, span_userdanger("一阵血雨遮蔽了你的传感器!"))
		borgo.Paralyze(6 SECONDS)
	owner.investigate_log("被内爆殉道炸成了碎片.", INVESTIGATE_DEATHS)
	owner.gib(DROP_ALL_REMAINS)

/datum/mutation/human/headless
	name = "H.A.R.S 头部过敏性排斥综合征."
	desc = "一种基因突变，使身体排斥头部，导致大脑退缩至胸腔内. 警告：移除此突变非常危险，虽然它会再生非重要头部器官"
	instability = NEGATIVE_STABILITY_MAJOR
	difficulty = 12 //pretty good for traitors
	quality = NEGATIVE //holy shit no eyes or tongue or ears
	text_gain_indication = "<span class='warning'>感觉有些不对劲.</span>"

/datum/mutation/human/headless/on_acquiring()
	. = ..()
	if(.)//cant add
		return TRUE

	var/obj/item/organ/internal/brain/brain = owner.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.Remove(owner, special = TRUE)
		brain.zone = BODY_ZONE_CHEST
		brain.Insert(owner, special = TRUE)

	var/obj/item/bodypart/head/head = owner.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		owner.visible_message(span_warning("[owner]的头颅发出令人作呕的嘎吱声，爆裂开来!"), ignored_mobs = list(owner))
		new /obj/effect/gibspawner/generic(get_turf(owner), owner)
		head.drop_organs()
		head.dismember(dam_type = BRUTE, silent = TRUE)
		qdel(head)
	RegisterSignal(owner, COMSIG_ATTEMPT_CARBON_ATTACH_LIMB, PROC_REF(abort_attachment))

/datum/mutation/human/headless/on_losing()
	. = ..()
	if(.)
		return TRUE

	UnregisterSignal(owner, COMSIG_ATTEMPT_CARBON_ATTACH_LIMB)
	var/successful = owner.regenerate_limb(BODY_ZONE_HEAD)
	if(!successful)
		stack_trace("HARS mutation head regeneration failed! (usually caused by headless syndrome having a head)")
		return TRUE
	var/obj/item/organ/internal/brain/brain = owner.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.Remove(owner, special = TRUE)
		brain.zone = initial(brain.zone)
		brain.Insert(owner, special = TRUE)

	owner.dna.species.regenerate_organs(owner, replace_current = FALSE, excluded_zones = list(BODY_ZONE_CHEST)) //replace_current needs to be FALSE to prevent weird adding and removing mutation healing
	owner.apply_damage(damage = 50, damagetype = BRUTE, def_zone = BODY_ZONE_HEAD) //and this to DISCOURAGE organ farming, or at least not make it free.
	owner.visible_message(span_warning("[owner]的头颅伴随着令人作呕的嘎吱声重新长了出来!"), span_warning("你的头伴随着令人作呕的咔哒声重新长了出来，好痛."))
	new /obj/effect/gibspawner/generic(get_turf(owner), owner)

/datum/mutation/human/headless/proc/abort_attachment(datum/source, obj/item/bodypart/new_limb, special) //you aren't getting your head back
	SIGNAL_HANDLER

	if(istype(new_limb, /obj/item/bodypart/head))
		return COMPONENT_NO_ATTACH
