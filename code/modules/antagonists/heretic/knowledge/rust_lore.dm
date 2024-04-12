/**
 * # The path of Rust.
 *
 * Goes as follows:
 *
 * Blacksmith's Tale
 * Grasp of Rust
 * Leeching Walk
 * > Sidepaths:
 *   Priest's Ritual
 *   Armorer's Ritual
 *
 * Mark of Rust
 * Ritual of Knowledge
 * Rust Construction
 * > Sidepaths:
 *   Lionhunter Rifle
 *
 * Aggressive Spread
 * > Sidepaths:
 *   Curse of Corrosion
 *   Mawed Crucible
 *
 * Toxic Blade
 * Entropic Plume
 * > Sidepaths:
 *   Rusted Ritual
 *   Rust Charge
 *
 * Rustbringer's Oath
 */
/datum/heretic_knowledge/limited_amount/starting/base_rust
	name = "铁匠的故事"
	desc = "通往铁锈之路. \
		你可以将任何垃圾物品和一把刀嬗变成铁锈之刃. 同一时间只能创造两把."
	gain_text = "\"让我给你讲个故事\"，铁匠凝视着自己生锈的刀刃说道."
	next_knowledge = list(/datum/heretic_knowledge/rust_fist)
	required_atoms = list(
		/obj/item/knife = 1,
		/obj/item/trash = 1,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/rust)
	route = PATH_RUST

/datum/heretic_knowledge/rust_fist
	name = "锈蚀之握"
	desc = "你的漫宿之握将对无生命的物体造成500点伤害，并锈蚀它接触到的表面. \
		若已被锈蚀则会被破坏. 只能通过右键来锈蚀表面或结构."
	gain_text = "在漫宿的顶，铁锈就像石头上的苔藓一样生长."
	next_knowledge = list(/datum/heretic_knowledge/rust_regen)
	cost = 1
	route = PATH_RUST

/datum/heretic_knowledge/rust_fist/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK_SECONDARY, PROC_REF(on_secondary_mansus_grasp))

/datum/heretic_knowledge/rust_fist/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, list(COMSIG_HERETIC_MANSUS_GRASP_ATTACK, COMSIG_HERETIC_MANSUS_GRASP_ATTACK_SECONDARY))

/datum/heretic_knowledge/rust_fist/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(!issilicon(target) && !(target.mob_biotypes & MOB_ROBOTIC))
		return

	target.rust_heretic_act()

/datum/heretic_knowledge/rust_fist/proc/on_secondary_mansus_grasp(mob/living/source, atom/target)
	SIGNAL_HANDLER

	// Rusting an airlock causes it to lose power, mostly to prevent the airlock from shocking you.
	// This is a bit of a hack, but fixing this would require the enture wire cut/pulse system to be reworked.
	if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/airlock = target
		airlock.loseMainPower()

	target.rust_heretic_act()
	return COMPONENT_USE_HAND

/datum/heretic_knowledge/rust_regen
	name = "锈中行"
	desc = "当你站在铁锈上时，给予你缓慢治疗和电棍抗性."
	gain_text = "速度无与伦比，力量超越常人，铁匠笑了."
	next_knowledge = list(
		/datum/heretic_knowledge/mark/rust_mark,
		/datum/heretic_knowledge/armor,
		/datum/heretic_knowledge/essence,
		/datum/heretic_knowledge/entropy_pulse,
	)
	cost = 1
	route = PATH_RUST

/datum/heretic_knowledge/rust_regen/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	RegisterSignal(user, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/heretic_knowledge/rust_regen/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, list(COMSIG_MOVABLE_MOVED, COMSIG_LIVING_LIFE))

/*
 * Signal proc for [COMSIG_MOVABLE_MOVED].
 *
 * Checks if we should have baton resistance on the new turf.
 */
/datum/heretic_knowledge/rust_regen/proc/on_move(mob/source, atom/old_loc, dir, forced, list/old_locs)
	SIGNAL_HANDLER

	var/turf/mover_turf = get_turf(source)
	if(HAS_TRAIT(mover_turf, TRAIT_RUSTY))
		ADD_TRAIT(source, TRAIT_BATON_RESISTANCE, type)
		return

	REMOVE_TRAIT(source, TRAIT_BATON_RESISTANCE, type)

/**
 * Signal proc for [COMSIG_LIVING_LIFE].
 *
 * Gradually heals the heretic ([source]) on rust,
 * including baton knockdown and stamina damage.
 */
/datum/heretic_knowledge/rust_regen/proc/on_life(mob/living/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	var/turf/our_turf = get_turf(source)
	if(!HAS_TRAIT(our_turf, TRAIT_RUSTY))
		return

	// Heals all damage + Stamina
	var/need_mob_update = FALSE
	need_mob_update += source.adjustBruteLoss(-2, updating_health = FALSE)
	need_mob_update += source.adjustFireLoss(-2, updating_health = FALSE)
	need_mob_update += source.adjustToxLoss(-2, updating_health = FALSE, forced = TRUE) // Slimes are people too
	need_mob_update += source.adjustOxyLoss(-0.5, updating_health = FALSE)
	need_mob_update += source.adjustStaminaLoss(-2, updating_stamina = FALSE)
	if(need_mob_update)
		source.updatehealth()
	// Reduces duration of stuns/etc
	source.AdjustAllImmobility(-0.5 SECONDS)
	// Heals blood loss
	if(source.blood_volume < BLOOD_VOLUME_NORMAL)
		source.blood_volume += 2.5 * seconds_per_tick

/datum/heretic_knowledge/mark/rust_mark
	name = "锈斑"
	desc = "你的漫宿之握可以施加锈斑. 锈斑可以由你的铁锈之刃触发. \
		一旦被触发，目标的器官和装备有75%的几率受到损伤并可能被摧毁."
	gain_text = "铁匠望向远处. 看向很久以前就失落的地方. \"锈山会解燃眉之急...以一定代价.\""
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/rust)
	route = PATH_RUST
	mark_type = /datum/status_effect/eldritch/rust

/datum/heretic_knowledge/knowledge_ritual/rust
	next_knowledge = list(/datum/heretic_knowledge/spell/rust_construction)
	route = PATH_RUST

/datum/heretic_knowledge/spell/rust_construction
	name = "赭色宫"
	desc = "赐予你赭色宫咒语，能让你从生锈的地板上升起一堵墙，墙壁升起的同时会顶飞上面的任何人并造成伤害."
	gain_text = "异域、不详的宫殿浮影在脑海中跃动闪烁，从头到尾都被厚厚的铁锈覆盖，\
		看起来不是人力所能筑成，或许也根本不存在这样的建筑."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/area_conversion,
		/datum/heretic_knowledge/rifle,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/rust_construction
	cost = 1
	route = PATH_RUST

/datum/heretic_knowledge/spell/area_conversion
	name = "冶锈法"
	desc = "赐予你冶锈法咒语，可以将铁锈扩散到附近的表面. \
		已经生锈的表面将被破坏."
	gain_text = "聪明人都知道不要去锈山...但铁匠的故事总是鼓舞人心."
	next_knowledge = list(
		/datum/heretic_knowledge/blade_upgrade/rust,
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/curse/corrosion,
		/datum/heretic_knowledge/crucible,
	)
	spell_to_add = /datum/action/cooldown/spell/aoe/rust_conversion
	cost = 1
	route = PATH_RUST

/datum/heretic_knowledge/blade_upgrade/rust
	name = "锈风毒刃"
	desc = "你的铁锈之刃现在将使敌人中毒."
	gain_text = "铁匠把它的剑递给你. \"如果你愿意，这把刀刃将引导你穿过血肉.\" \
		沉重的铁锈使它下沉. 你深深地凝视它. 此时锈山传来呼唤."
	next_knowledge = list(/datum/heretic_knowledge/spell/entropic_plume)
	route = PATH_RUST

/datum/heretic_knowledge/blade_upgrade/rust/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	// No user == target check here, cause it's technically good for the heretic?
	target.reagents?.add_reagent(/datum/reagent/eldritch, 5)

/datum/heretic_knowledge/spell/entropic_plume
	name = "熵雾"
	desc = "赐予你熵雾，一种释放恼人锈潮的法术. \
		让被命中的不信之人失明、中毒以及陷入不分敌我的狂乱之中，\
		还能锈蚀被击中的物品."
	gain_text = "腐蚀之潮势不可挡，铁锈生花赏心悦目. \
		铁匠不在了，而你握住了他的剑. 希望的斗士们，铁锈之主已然临近!"
	next_knowledge = list(
		/datum/heretic_knowledge/ultimate/rust_final,
		/datum/heretic_knowledge/summon/rusty,
		/datum/heretic_knowledge/spell/rust_charge,
	)
	spell_to_add = /datum/action/cooldown/spell/cone/staggered/entropic_plume
	cost = 1
	route = PATH_RUST

/datum/heretic_knowledge/ultimate/rust_final
	name = "铁锈之主的誓约"
	desc = "铁锈之路的飞升仪式. \
		将三具尸体带到画在站点舰桥上的嬗变符文以完成仪式. \
		一旦完成，锈蚀将以仪式场地为中心无休无止地传播开来，直到无物可锈. \
		而你在生锈表面上将获得非常强的治愈力，伤害愈合速度是原来的三倍，同时你也能免疫许多效果和危险."
	gain_text = "铁锈冠军. 钢铁的腐蚀者. 畏惧黑暗吧，因为铁锈之主的到来! \
		铁匠锻造不停! 锈山，呼唤我的名字! 见证我的飞升!"
	route = PATH_RUST
	/// If TRUE, then immunities are currently active.
	var/immunities_active = FALSE
	/// A typepath to an area that we must finish the ritual in.
	var/area/ritual_location = /area/station/command/bridge
	/// A static list of traits we give to the heretic when on rust.
	var/static/list/conditional_immunities = list(
		TRAIT_BOMBIMMUNE,
		TRAIT_NO_SLIP_ALL,
		TRAIT_NOBREATH,
		TRAIT_PIERCEIMMUNE,
		TRAIT_PUSHIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_SHOCKIMMUNE,
		TRAIT_SLEEPIMMUNE,
		TRAIT_STUNIMMUNE,
	)

/datum/heretic_knowledge/ultimate/rust_final/on_research(mob/user, datum/antagonist/heretic/our_heretic)
	. = ..()
	// This map doesn't have a Bridge, for some reason??
	// Let them complete the ritual anywhere
	if(!GLOB.areas_by_type[ritual_location])
		ritual_location = null

/datum/heretic_knowledge/ultimate/rust_final/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	if(ritual_location)
		var/area/our_area = get_area(loc)
		if(!istype(our_area, ritual_location))
			loc.balloon_alert(user, "仪式失败，必须在[initial(ritual_location.name)]!") // "must be in bridge"
			return FALSE

	return ..()

/datum/heretic_knowledge/ultimate/rust_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce(
		text = "[generate_heretic_text()] 畏惧腐朽吧，因为铁锈之主的垂怜，[user.real_name]已经飞升! 没人可以逃离锈蚀! [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = ANNOUNCER_SPANOMALIES,
		color_override = "pink",
	)
	new /datum/rust_spread(loc)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	RegisterSignal(user, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	user.client?.give_award(/datum/award/achievement/misc/rust_ascension, user)

/**
 * Signal proc for [COMSIG_MOVABLE_MOVED].
 *
 * Gives our heretic ([source]) buffs if they stand on rust.
 */
/datum/heretic_knowledge/ultimate/rust_final/proc/on_move(mob/source, atom/old_loc, dir, forced, list/old_locs)
	SIGNAL_HANDLER

	// If we're on a rusty turf, and haven't given out our traits, buff our guy
	var/turf/our_turf = get_turf(source)
	if(HAS_TRAIT(our_turf, TRAIT_RUSTY))
		if(!immunities_active)
			source.add_traits(conditional_immunities, type)
			immunities_active = TRUE

	// If we're not on a rust turf, and we have given out our traits, nerf our guy
	else
		if(immunities_active)
			source.remove_traits(conditional_immunities, type)
			immunities_active = FALSE

/**
 * Signal proc for [COMSIG_LIVING_LIFE].
 *
 * Gradually heals the heretic ([source]) on rust.
 */
/datum/heretic_knowledge/ultimate/rust_final/proc/on_life(mob/living/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	var/turf/our_turf = get_turf(source)
	if(!HAS_TRAIT(our_turf, TRAIT_RUSTY))
		return

	var/need_mob_update = FALSE
	need_mob_update += source.adjustBruteLoss(-4, updating_health = FALSE)
	need_mob_update += source.adjustFireLoss(-4, updating_health = FALSE)
	need_mob_update += source.adjustToxLoss(-4, updating_health = FALSE, forced = TRUE)
	need_mob_update += source.adjustOxyLoss(-4, updating_health = FALSE)
	need_mob_update += source.adjustStaminaLoss(-20, updating_stamina = FALSE)
	if(need_mob_update)
		source.updatehealth()

/**
 * #Rust spread datum
 *
 * Simple datum that automatically spreads rust around it.
 *
 * Simple implementation of automatically growing entity.
 */
/datum/rust_spread
	/// The rate of spread every tick.
	var/spread_per_sec = 6
	/// The very center of the spread.
	var/turf/centre
	/// List of turfs at the edge of our rust (but not yet rusted).
	var/list/edge_turfs = list()
	/// List of all turfs we've afflicted.
	var/list/rusted_turfs = list()
	/// Static blacklist of turfs we can't spread to.
	var/static/list/blacklisted_turfs = typecacheof(list(
		/turf/open/indestructible,
		/turf/closed/indestructible,
		/turf/open/space,
		/turf/open/lava,
		/turf/open/chasm
	))

/datum/rust_spread/New(loc)
	centre = get_turf(loc)
	centre.rust_heretic_act()
	rusted_turfs += centre
	START_PROCESSING(SSprocessing, src)

/datum/rust_spread/Destroy(force)
	centre = null
	edge_turfs.Cut()
	rusted_turfs.Cut()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/rust_spread/process(seconds_per_tick)
	var/spread_amount = round(spread_per_sec * seconds_per_tick)

	if(length(edge_turfs) < spread_amount)
		compile_turfs()

	for(var/i in 0 to spread_amount)
		if(!length(edge_turfs))
			break
		var/turf/afflicted_turf = pick_n_take(edge_turfs)
		afflicted_turf.rust_heretic_act()
		rusted_turfs |= afflicted_turf

/**
 * Compile turfs
 *
 * Recreates the edge_turfs list.
 * Updates the rusted_turfs list, in case any turfs within were un-rusted.
 */
/datum/rust_spread/proc/compile_turfs()
	edge_turfs.Cut()

	var/max_dist = 1
	for(var/turf/found_turf as anything in rusted_turfs)
		if(!HAS_TRAIT(found_turf, TRAIT_RUSTY))
			rusted_turfs -= found_turf
		max_dist = max(max_dist, get_dist(found_turf, centre) + 1)

	for(var/turf/nearby_turf as anything in spiral_range_turfs(max_dist, centre, FALSE))
		if(nearby_turf in rusted_turfs || is_type_in_typecache(nearby_turf, blacklisted_turfs))
			continue

		for(var/turf/line_turf as anything in get_line(nearby_turf, centre))
			if(get_dist(nearby_turf, line_turf) <= 1)
				edge_turfs |= nearby_turf
		CHECK_TICK
