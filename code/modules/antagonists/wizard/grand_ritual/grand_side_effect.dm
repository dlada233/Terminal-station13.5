/**
 * 描述在完成宏伟仪式时可以在局部区域内发生的事情。
 */
/datum/grand_side_effect
	/// 如果为真，则此效果是行为的持有者，不应被选择。
	var/abstract = TRUE

/**
 * 如果可以触发此效果，则返回 true。
 * * ritual_location - 仪式符文的中心地皮。
 */
/datum/grand_side_effect/proc/can_trigger(turf/ritual_location)
	return !abstract

/**
 * 在仪式区域触发某种效果。
 * 参数
 * * potency - 之前施法次数。
 * * ritual_location - 仪式符文的中心地皮。
 * * invoker - 施法者。
 */
/datum/grand_side_effect/proc/trigger(potency, turf/ritual_location, mob/invoker)
	return // 在重写中做些酷炫的事

/**
 * 只在其位置施放一个法术的副作用
 */
/datum/grand_side_effect/spell
	/// 要施放的法术路径
	var/spell_path
	/// 结束法术前的持续时间
	var/duration = 0
	/// 播放的音效
	var/sound

/// 在区域内施放维度不稳定
/datum/grand_side_effect/scramble_turfs
	abstract = FALSE

/datum/grand_side_effect/scramble_turfs/trigger(potency, turf/ritual_location, mob/invoker)
	playsound(ritual_location, 'sound/magic/timeparadox2.ogg', 60, TRUE)
	var/datum/action/cooldown/spell/spell = new /datum/action/cooldown/spell/spacetime_dist()
	spell.cast(ritual_location)

	var/duration = LERP((10 SECONDS), (15 SECONDS), potency/GRAND_RITUAL_FINALE_COUNT)
	QDEL_IN(spell, duration)

/// 将周围区域变成其他东西
/datum/grand_side_effect/transmogrify_area
	abstract = FALSE

/datum/grand_side_effect/transmogrify_area/trigger(potency, turf/ritual_location, mob/invoker)
	var/new_theme_path = pick(subtypesof(/datum/dimension_theme))
	var/datum/dimension_theme/theme = new new_theme_path()
	var/range = round(LERP(2, 4, potency/GRAND_RITUAL_FINALE_COUNT))

	var/list/turfs_to_transform = list()

	for (var/turf/turf in orange(range, ritual_location))
		if (!theme.can_convert(turf))
			continue
		turfs_to_transform += turf

	if (theme.can_convert(ritual_location))
		theme.apply_theme(ritual_location)

	for (var/iterator in 1 to range)
		var/list/range_turfs = list()
		for (var/turf/turf as anything in turfs_to_transform)
			var/dist_between = get_dist(ritual_location, turf)
			if (dist_between != iterator)
				continue
			range_turfs += turf
		addtimer(CALLBACK(src, PROC_REF(staggered_transform), theme, range_turfs), (0.5 SECONDS) * iterator)

/datum/grand_side_effect/transmogrify_area/proc/staggered_transform(datum/dimension_theme/theme, list/transform_turfs)
	for (var/turf/target_turf as anything in transform_turfs)
		theme.apply_theme(target_turf)

/// 最小创建异常数量
#define MIN_ANOMALIES_CREATED 1
/// 最大创建异常数量
#define MAX_ANOMALIES_CREATED 4

/// 在区域内生成一些不太危险的异常
/datum/grand_side_effect/create_anomalies
	abstract = FALSE
	/// 我们允许创建的异常类型列表，每种类型的最大创建数量
	var/static/list/permitted_anomalies = list(
		/obj/effect/anomaly/bioscrambler = 1,
		/obj/effect/anomaly/hallucination = 2,
		/obj/effect/anomaly/grav = 2,
		/obj/effect/anomaly/flux/minor = 3,
	)

/datum/grand_side_effect/create_anomalies/trigger(potency, turf/ritual_location, mob/invoker)
	var/to_create = rand(MIN_ANOMALIES_CREATED, MAX_ANOMALIES_CREATED)
	var/potency_add = LERP(-1, 1, potency/GRAND_RITUAL_FINALE_COUNT)
	to_create = clamp(round(to_create + potency_add), MIN_ANOMALIES_CREATED, MAX_ANOMALIES_CREATED)

	var/list/can_create = permitted_anomalies.Copy()
	var/list/anomaly_positions = list()
	for (var/turf/potential_turf in orange(4, ritual_location))
		if (potential_turf.is_blocked_turf(exclude_mobs = TRUE))
			continue
		anomaly_positions += potential_turf

	while(to_create > 0)
		var/create_path = pick(can_create)
		if (can_create[create_path] == 0)
			continue
		can_create[create_path] = can_create[create_path] - 1
		new create_path(pick(anomaly_positions), new_lifespan = rand(150, 300), drops_core = FALSE)
		to_create--

#undef MIN_ANOMALIES_CREATED
#undef MAX_ANOMALIES_CREATED

/// 使附近的机器产生EMP脉冲
/datum/grand_side_effect/emp
	abstract = FALSE

/datum/grand_side_effect/emp/trigger(potency, turf/ritual_location, mob/invoker)
	var/heavy = LERP(0, 3, potency/GRAND_RITUAL_FINALE_COUNT)
	var/light = LERP(3, 6, potency/GRAND_RITUAL_FINALE_COUNT)
	empulse(ritual_location, heavy, light)

/// 随机交换附近生物的位置并使其混乱
/datum/grand_side_effect/translocate
	abstract = FALSE

/// 如果没有人可交换则不运行
/datum/grand_side_effect/translocate/can_trigger(turf/ritual_location)
	. = ..()
	if (!.)
		return

	var/list/mobs = list()
	for (var/mob/living/victim in range(5, ritual_location))
		mobs += victim
	if (length(mobs) < 2)
		return FALSE
	return TRUE

/datum/grand_side_effect/translocate/trigger(potency, turf/ritual_location, mob/invoker)
	var/list/mobs = list()
	var/list/mob_locations = list()

	for (var/mob/living/victim in range(5, ritual_location))
		mob_locations += victim.loc
		mobs += victim

	if (!length(mobs))
		return

	shuffle_inplace(mob_locations)
	shuffle_inplace(mobs)

	for (var/mob/living/victim as anything in mobs)
		if (!length(mob_locations))
			break //locs aren't always unique, so this may come into play
		var/obj/effect/particle_effect/fluid/smoke/poof = new(get_turf(victim))
		poof.lifetime = 2 SECONDS
		var/atom/new_loc = pop(mob_locations)
		do_teleport(victim, new_loc, channel = TELEPORT_CHANNEL_MAGIC)

/// 在区域内生成润滑剂
/datum/grand_side_effect/slippery
	abstract = FALSE

/datum/grand_side_effect/slippery/trigger(potency, turf/ritual_location, mob/invoker)
	var/range = LERP(2, 4, potency/GRAND_RITUAL_FINALE_COUNT)
	var/datum/reagents/lube = new(1000)
	lube.add_reagent(/datum/reagent/lube, 100)
	lube.my_atom = ritual_location
	lube.create_foam(/datum/effect_system/fluid_spread/foam, DIAMOND_AREA(range))
	qdel(lube)

/// 抓住一个人并将其拉到此位置，延迟后
/datum/grand_side_effect/summon_crewmate
	abstract = FALSE
	/// 将要抓住并拉到我们位置的人的弱引用
	var/datum/weakref/victim

/// 如果没有人可召唤则不运行
/datum/grand_side_effect/summon_crewmate/can_trigger(turf/ritual_location)
	. = ..()
	if (!.)
		return
	var/area/our_area = get_area(ritual_location)
	for (var/mob/living/carbon/human/crewmate as anything in GLOB.human_list)
		if (is_valid_crewmate(crewmate, our_area))
			return TRUE
	return FALSE

/datum/grand_side_effect/summon_crewmate/proc/is_valid_crewmate(mob/living/carbon/human/crewmate, area/our_area)
	if (!crewmate.mind || IS_HUMAN_INVADER(crewmate))
		return FALSE
	return get_area(crewmate) != our_area

#define CREWMATE_SUMMON_TELEPORT_DELAY 9 SECONDS

/datum/grand_side_effect/summon_crewmate/trigger(potency, turf/ritual_location, mob/invoker)
	playsound(ritual_location, 'sound/magic/lightning_chargeup.ogg', 65, TRUE)
	var/list/potential_victims = list()
	var/area/our_area = get_area(ritual_location)
	for (var/mob/living/carbon/human/crewmate as anything in GLOB.human_list)
		if (!is_valid_crewmate(crewmate, our_area))
			continue
		potential_victims += crewmate

	var/list/nearby_turfs = list()
	for (var/turf/potential_turf in range(1, ritual_location))
		if (potential_turf.is_blocked_turf(exclude_mobs = TRUE))
			continue
		nearby_turfs += potential_turf

	var/turf/landing_pos = pick(nearby_turfs)
	new /obj/effect/temp_visual/teleport_abductor(landing_pos)

	var/mob/living/carbon/human/victim = pick(potential_victims)
	playsound(get_turf(victim),'sound/magic/repulse.ogg', 60, TRUE)
	victim.Immobilize(CREWMATE_SUMMON_TELEPORT_DELAY)
	victim.AddElement(/datum/element/forced_gravity, 0)
	victim.add_filter("teleport_glow", 2, list("type" = "outline", "color" = "#de3aff48", "size" = 2))
	victim.visible_message(span_warning("[victim]突然漂浮起来!"), span_warning("你被一股升力揪到空中!"))
	addtimer(CALLBACK(src, PROC_REF(summon_crewmate), victim, landing_pos), CREWMATE_SUMMON_TELEPORT_DELAY)

#undef CREWMATE_SUMMON_TELEPORT_DELAY

/datum/grand_side_effect/summon_crewmate/proc/summon_crewmate(mob/victim, turf/destination)
	var/turf/was_position = victim.loc
	victim.RemoveElement(/datum/element/forced_gravity, 0)
	victim.remove_filter("teleport_glow")

	if (do_teleport(victim, destination, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_MAGIC))
		var/obj/effect/particle_effect/fluid/smoke/poof = new(was_position)
		poof.lifetime = 2 SECONDS
		was_position.visible_message(span_warning("[victim]消失在一团烟雾中!"))
	else
		victim.visible_message(span_notice("[victim]回到了地面."))

/// Create colourful smoke
/datum/grand_side_effect/smoke
	abstract = FALSE

/datum/grand_side_effect/smoke/trigger(potency, turf/ritual_location, mob/invoker)
	playsound(src, 'sound/magic/smoke.ogg', 50, TRUE)
	var/range = LERP(2, 4, potency/GRAND_RITUAL_FINALE_COUNT)
	var/datum/effect_system/fluid_spread/smoke/colourful/smoke = new
	smoke.set_up(range, holder = ritual_location, location = ritual_location)
	smoke.start()

/// Spawns randomly coloured smoke
/datum/effect_system/fluid_spread/smoke/colourful
	effect_type = /obj/effect/particle_effect/fluid/smoke/colourful

/// Randomly coloured smoke
/obj/effect/particle_effect/fluid/smoke/colourful
	/// Colours that the smoke can be
	var/static/list/colours = list(
		"#ff0033",
		"#3366ff",
		"#10802d",
		"#ee55ba",
		"#e9ea53",
		"#3f484e",
		"#d6e1f0",
		"#6b30bc",
		"#72491e",
		"#39e2dd",
		"#50f038",
	)

/obj/effect/particle_effect/fluid/smoke/colourful/Initialize(mapload, datum/fluid_group/group, ...)
	. = ..()
	color = pick(colours)

/// Make a bloody mess
/datum/grand_side_effect/gore
	abstract = FALSE

/datum/grand_side_effect/gore/trigger(potency, turf/ritual_location, mob/invoker)
	var/list/nearby_turfs = list()
	for (var/turf/potential_turf in range(2, ritual_location))
		if (potential_turf.is_blocked_turf(exclude_mobs = TRUE))
			continue
		nearby_turfs += potential_turf

	for (var/iterator in 1 to 4)
		new /obj/effect/gibspawner/generic(pick(nearby_turfs))

/// Rain food in the area
/datum/grand_side_effect/create_food
	abstract = FALSE

/datum/grand_side_effect/create_food/trigger(potency, turf/ritual_location, mob/invoker)
	var/duration = LERP((10 SECONDS), (30 SECONDS), potency/GRAND_RITUAL_FINALE_COUNT)
	new /obj/effect/abstract/local_food_rain(ritual_location, duration)

/// Makes food land near it until it expires
/obj/effect/abstract/local_food_rain
	var/max_foods_per_second = 1
	var/range = 3

/obj/effect/abstract/local_food_rain/Initialize(mapload, duration, max_foods_per_second = 3, range = 3)
	. = ..()
	src.max_foods_per_second = max_foods_per_second
	src.range = range
	addtimer(CALLBACK(src, PROC_REF(end_rain)), duration)
	create_food(2 SECONDS)
	START_PROCESSING(SSprocessing, src)

/obj/effect/abstract/local_food_rain/Destroy(force)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/abstract/local_food_rain/process(seconds_per_tick)
	create_food(seconds_per_tick)

/obj/effect/abstract/local_food_rain/proc/create_food(seconds_per_tick)
	var/to_create = rand(0, max_foods_per_second * seconds_per_tick)
	if (to_create == 0)
		return

	var/list/valid_turfs = list()
	for (var/turf/turf in range(range, src))
		if(turf.is_blocked_turf(exclude_mobs = TRUE))
			continue
		valid_turfs += turf

	while(to_create > 0 && length(valid_turfs) > 0)
		to_create--
		addtimer(CALLBACK(src, PROC_REF(drop_food), pick_n_take(valid_turfs)), rand(0, (1 SECONDS) * seconds_per_tick))

/obj/effect/abstract/local_food_rain/proc/drop_food(turf/landing_zone)
	podspawn(list(
			"target" = landing_zone,
			"style" = STYLE_SEETHROUGH,
			"spawn" = get_random_food(),
			"delays" = list(POD_TRANSIT = 0, POD_FALLING = (3 SECONDS), POD_OPENING = 0, POD_LEAVING = 0),
			"effectStealth" = TRUE,
			"effectQuiet" = TRUE,
		)
	)

/obj/effect/abstract/local_food_rain/proc/end_rain()
	qdel(src)

/// Spawn some mobs after a delay
/datum/grand_side_effect/spawn_delayed_mobs
	abstract = FALSE
	/// Typepaths of mobs to create
	var/static/list/permitted_mobs = list(
		/mob/living/basic/carp,
		/mob/living/basic/killer_tomato,
		/mob/living/basic/skeleton,
		/mob/living/basic/wumborian_fugu,
		/mob/living/simple_animal/hostile/illusion,
		/mob/living/simple_animal/hostile/ooze,
	)

/datum/grand_side_effect/spawn_delayed_mobs/trigger(potency, turf/ritual_location, mob/invoker)
	var/count = LERP(1, 4, potency/GRAND_RITUAL_FINALE_COUNT)
	var/list/valid_turfs = list()
	for (var/turf/turf in range(3, ritual_location))
		if(turf.is_blocked_turf(exclude_mobs = TRUE))
			continue
		valid_turfs += turf

	var/mob_type = pick(permitted_mobs)
	while(count > 0 && length(valid_turfs) > 0)
		count--
		var/turf/spawn_loc = pick_n_take(valid_turfs)
		addtimer(CALLBACK(src, PROC_REF(create_portal), mob_type, spawn_loc), rand(0, 1 SECONDS))

/datum/grand_side_effect/spawn_delayed_mobs/proc/create_portal(mob_type, turf/spawn_loc)
	var/spawn_delay = rand(10 SECONDS, 15 SECONDS)
	new /obj/effect/temp_visual/delayed_mob_portal(spawn_loc, spawn_delay)
	addtimer(CALLBACK(src, PROC_REF(create_mob), mob_type, spawn_loc), spawn_delay)

/datum/grand_side_effect/spawn_delayed_mobs/proc/create_mob(mob_path, loc)
	if (!loc)
		return
	if (!mob_path)
		return
	playsound(get_turf(src),'sound/magic/teleport_app.ogg', 60, TRUE)
	do_sparks(5, FALSE, loc)
	new mob_path(loc)

/// Spawns a mob when it expires
/obj/effect/temp_visual/delayed_mob_portal
	icon_state = "rift"

/obj/effect/temp_visual/delayed_mob_portal/Initialize(mapload, duration = 15 SECONDS)
	src.duration = duration
	animate(src, transform = matrix()*0, time = 0)
	animate(transform = matrix(), time = 2)
	add_filter("portal_ripple", 2, list("type" = "ripple", "flags" = WAVE_BOUNDED, "radius" = 0, "size" = 2))
	var/filter = get_filter("portal_ripple")
	animate(filter, radius = 0, time = 0.2 SECONDS, size = 2, easing = JUMP_EASING, loop = -1, flags = ANIMATION_PARALLEL)
	animate(radius = 32, time = 1.5 SECONDS, size = 0)
	return ..()

/// Provides musical accompaniment
/datum/grand_side_effect/orchestra
	abstract = FALSE

/datum/grand_side_effect/orchestra/trigger(potency, turf/ritual_location, mob/invoker)
	var/count = LERP(1, 4, potency/GRAND_RITUAL_FINALE_COUNT)
	var/list/valid_turfs = list()
	for (var/turf/turf in range(2, ritual_location))
		if(turf.is_blocked_turf(exclude_mobs = TRUE))
			continue
		valid_turfs += turf

	while(count > 0 && length(valid_turfs) > 0)
		count--
		var/mob/living/carbon/human/species/monkey/monke = new(pick_n_take(valid_turfs))
		monke.equip_to_slot_or_del(new /obj/item/clothing/under/suit/waiter(monke), ITEM_SLOT_ICLOTHING)
		var/instrument_path = pick(subtypesof(/obj/item/instrument))
		var/obj/item/instrument/instrument = new instrument_path()
		monke.put_in_hands(instrument)
