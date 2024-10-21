#define NARSIE_CHANCE_TO_PICK_NEW_TARGET 5
#define NARSIE_CONSUME_RANGE 12
#define NARSIE_GRAV_PULL 10
#define NARSIE_MESMERIZE_CHANCE 25
#define NARSIE_MESMERIZE_EFFECT 60
#define NARSIE_SINGULARITY_SIZE 12

#define ADMIN_WARNING_MESSAGE "Invoking this will begin the Nar'Sie roundender. Assume that this WILL end the round in a few minutes. Are you sure?"

/// Nar'Sie, the God of the blood cultists
/obj/narsie
	name = "Nar'Sie"
	desc = "当你试图理解所看到的东西时，你的大脑开始陷入疯狂."
	icon = 'icons/obj/antags/cult/narsie.dmi'
	icon_state = "narsie"
	anchored = TRUE
	appearance_flags = LONG_GLIDE
	density = FALSE
	gender = FEMALE
	plane = MASSIVE_OBJ_PLANE
	light_color = COLOR_RED
	light_power = 0.7
	light_range = 15
	light_range = 6
	move_resist = INFINITY
	obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION
	pixel_x = -236
	pixel_y = -256
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1

	/// The singularity component to move around Nar'Sie.
	/// A weak ref in case an admin removes the component to preserve the functionality.
	var/datum/weakref/singularity

	var/list/souls_needed = list()
	var/soul_goal = 0
	var/souls = 0
	var/resolved = FALSE

/obj/narsie/Initialize(mapload)
	. = ..()

	narsie_spawn_animation()

/obj/narsie/Destroy()
	if (GLOB.cult_narsie == src)
		fall_of_the_harbinger()
		GLOB.cult_narsie = null

	return ..()

/// This proc sets up all of Nar'Sie's abilities, stats, and begins her round-ending capabilities. She does not do anything unless this proc is invoked.
/// This is only meant to be invoked after this instance is initialized in specific pro-sumer procs, as it WILL derail the entire round.
/obj/narsie/proc/start_ending_the_round()
	GLOB.cult_narsie = src
	SSpoints_of_interest.make_point_of_interest(src)

	singularity = WEAKREF(AddComponent(
		/datum/component/singularity, \
		bsa_targetable = FALSE, \
		consume_callback = CALLBACK(src, PROC_REF(consume)), \
		consume_range = NARSIE_CONSUME_RANGE, \
		disregard_failed_movements = TRUE, \
		grav_pull = NARSIE_GRAV_PULL, \
		roaming = FALSE, /* This is set once the animation finishes */ \
		singularity_size = NARSIE_SINGULARITY_SIZE, \
	))

	send_to_playing_players(span_narsie("NAR'SIE归位"))
	sound_to_playing_players('sound/creatures/narsie_rises.ogg')

	var/area/area = get_area(src)
	if(area)
		var/mutable_appearance/alert_overlay = mutable_appearance('icons/effects/cult.dmi', "ghostalertsie")
		notify_ghosts(
			"Nar'Sie自[area]崛起. 找到次元几何之血尊来获得新的躯体.",
			source = src,
			header = "Nar'Sie归位!",
			click_interact = TRUE,
			alert_overlay = alert_overlay,
		)

	var/list/all_cults = list()

	for (var/datum/antagonist/cult/cultist in GLOB.antagonists)
		if (!cultist.owner)
			continue
		all_cults |= cultist.cult_team

	for (var/_cult_team in all_cults)
		var/datum/team/cult/cult_team = _cult_team
		cult_team.set_blood_target(src, duration = INFINITY)
		var/datum/objective/eldergod/summon_objective = locate() in cult_team.objectives
		if(summon_objective)
			summon_objective.summoned = TRUE

	for (var/datum/mind/cult_mind as anything in get_antag_minds(/datum/antagonist/cult))
		if (isliving(cult_mind.current))
			var/mob/living/L = cult_mind.current
			L.narsie_act()

	for (var/mob/living/carbon/player in GLOB.player_list)
		if (player.stat != DEAD && is_station_level(player.loc?.z) && !IS_CULTIST(player))
			souls_needed[player] = TRUE

	soul_goal = round(1 + LAZYLEN(souls_needed) * 0.75)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(begin_the_end))

/// Cleans up all of Nar'Sie's abilities, stats, and ends her round-ending capabilities. This should only be called if `start_ending_the_round()` successfully started.
/obj/narsie/proc/fall_of_the_harbinger()
	var/list/all_cults = list()

	for (var/datum/antagonist/cult/cultist in GLOB.antagonists)
		if (!cultist.owner)
			continue
		all_cults |= cultist.cult_team

	for(var/_cult_team in all_cults)
		var/datum/team/cult/cult_team = _cult_team
		var/datum/objective/eldergod/summon_objective = locate() in cult_team.objectives
		if (summon_objective)
			summon_objective.summoned = FALSE
			summon_objective.killed = TRUE

	send_to_playing_players(span_narsie(span_bold(pick("Nooooo...", "Not die. How-", "Die. Mort-", "Sas tyen re-"))))
	sound_to_playing_players('sound/magic/demon_dies.ogg', 50)

/obj/narsie/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION(VV_HK_BEGIN_NARSIE_ROUNDEND, "开始Nar'Sie之终局")

/obj/narsie/vv_do_topic(list/href_list)
	. = ..()

	if(!.)
		return

	if(isnull(usr) || !href_list[VV_HK_BEGIN_NARSIE_ROUNDEND] || !check_rights(R_FUN, show_msg = TRUE))
		return

	if(tgui_alert(usr, ADMIN_WARNING_MESSAGE, "开始Nar'Sie之终局", list("我确定", "取消")) != "我确定")
		return

	log_admin("[key_name(usr)] has triggered the Nar'Sie roundender.")
	start_ending_the_round()

/obj/narsie/attack_ghost(mob/user)
	make_new_construct(/mob/living/basic/construct/harvester, user, cultoverride = TRUE, loc_override = loc)

/obj/narsie/process()
	var/datum/component/singularity/singularity_component = singularity.resolve()

	if (!isnull(singularity_component) && (!singularity_component?.target || prob(NARSIE_CHANCE_TO_PICK_NEW_TARGET)))
		pickcultist()

	if (prob(NARSIE_MESMERIZE_CHANCE))
		mesmerize()

/obj/narsie/Bump(atom/target)
	var/turf/target_turf = get_turf(target)
	if (target_turf == loc)
		target_turf = get_step(target, target.dir) //please don't slam into a window like a bird, Nar'Sie
	forceMove(target_turf)

/// Stun people around Nar'Sie that aren't cultists
/obj/narsie/proc/mesmerize()
	for (var/mob/living/carbon/victim in viewers(NARSIE_CONSUME_RANGE, src))
		if (victim.stat == CONSCIOUS)
			if (!IS_CULTIST(victim))
				to_chat(victim, span_cult("当你凝视着[src]时，你感到有意识的思想瞬间崩溃了..."))
				victim.apply_effect(NARSIE_MESMERIZE_EFFECT, EFFECT_STUN)

/// Narsie rewards her cultists with being devoured first, then picks a ghost to follow.
/obj/narsie/proc/pickcultist()
	var/list/cultists = list()
	var/list/noncultists = list()

	for (var/mob/living/carbon/food in GLOB.alive_mob_list) //we don't care about constructs or cult-Ians or whatever. cult-monkeys are fair game i guess
		var/turf/pos = get_turf(food)
		if (!pos || (pos.z != z))
			continue

		if (IS_CULTIST(food))
			cultists += food
		else
			noncultists += food

		if (cultists.len) //cultists get higher priority
			acquire(pick(cultists))
			return

		if (noncultists.len)
			acquire(pick(noncultists))
			return

	//no living humans, follow a ghost instead.
	for (var/mob/dead/observer/ghost in GLOB.player_list)
		var/turf/pos = get_turf(ghost)
		if (!pos || (pos.z != z))
			continue
		cultists += ghost
	if (cultists.len)
		acquire(pick(cultists))
		return

/// Nar'Sie gets a taste of something, and will start to gravitate towards it
/obj/narsie/proc/acquire(atom/food)
	var/datum/component/singularity/singularity_component = singularity.resolve()

	if (isnull(singularity_component))
		return

	var/old_target = singularity_component.target
	if (food == old_target)
		return

	to_chat(old_target, span_cult("NAR'SIE对你失去了兴趣."))
	singularity_component.target = food
	if(ishuman(food))
		to_chat(food, span_cult("NAR'SIE渴望你的灵魂."))
	else
		to_chat(food, span_cult("NAR'SIE选中你作为她的下一餐."))

/// Called to make Nar'Sie convert objects to cult stuff, or to eat
/obj/narsie/proc/consume(atom/target)
	if (isturf(target))
		target.narsie_act()

/obj/narsie/proc/narsie_spawn_animation()
	setDir(SOUTH)
	flick("narsie_spawn_anim", src)
	addtimer(CALLBACK(src, PROC_REF(narsie_spawn_animation_end)), 3.5 SECONDS)

/obj/narsie/proc/narsie_spawn_animation_end()
	var/datum/component/singularity/singularity_component = singularity?.resolve()
	singularity_component?.roaming = TRUE

/**
 * Begins the process of ending the round via cult narsie win
 * Consists of later called procs (in order of called):
 *  * [/proc/narsie_end_begin_check()]
 *  * [/proc/narsie_end_second_check()]
 *  * [/proc/narsie_start_destroy_station()]
 *  * [/proc/narsie_apocalypse()]
 *  * [/proc/narsie_last_second_win()]
 *  * [/proc/cult_ending_helper()]
 */
/proc/begin_the_end()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(narsie_end_begin_check)), 5 SECONDS)

///First crew last second win check and flufftext for [/proc/begin_the_end()]
/proc/narsie_end_begin_check()
	if(QDELETED(GLOB.cult_narsie)) // uno
		priority_announce("状况报告? 我们发现了异常, 但它立刻就消失了.","[command_name()]高维事务", 'sound/misc/notice1.ogg')
		GLOB.cult_narsie = null
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper), CULT_FAILURE_NARSIE_KILLED), 2 SECONDS)
		return
	priority_announce(
		text = "在您的区域检测到一次突发的次元事件. 该事件已被标定为‘灭绝级’事件. 现将所有资产用于模拟解决方案. 解决方案 ETA: 60 秒.",
		title = "[command_name()]高维事务",
		sound = 'sound/misc/airraid.ogg',
	)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(narsie_end_second_check)), 50 SECONDS)

///Second crew last second win check and flufftext for [/proc/begin_the_end()]
/proc/narsie_end_second_check()
	if(QDELETED(GLOB.cult_narsie)) // dos
		priority_announce("模拟终止, 传感器报告偶发事件正在正常化. 干得好, 船员.","[command_name()]高维事务", 'sound/misc/notice1.ogg')
		GLOB.cult_narsie = null
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper), CULT_FAILURE_NARSIE_KILLED), 2 SECONDS)
		return
	priority_announce("对非因果纬度事件的模拟完成. 现在部署解决方案. 部署解决方案 ETA: 一分钟. ","[command_name()]高维事务")
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(narsie_start_destroy_station)), 5 SECONDS)

///security level and shuttle lockdowns for [/proc/begin_the_end()]
/proc/narsie_start_destroy_station()
	SSsecurity_level.set_level(SEC_LEVEL_GAMMA) //SKYRAT EDIT CHANGE - ALERTS - ORIGINAL "delta"
	SSshuttle.registerHostileEnvironment(GLOB.cult_narsie)
	SSshuttle.lockdown = TRUE
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(narsie_apocalypse)), 1 MINUTES)

///Third crew last second win check and flufftext for [/proc/begin_the_end()]
/proc/narsie_apocalypse()
	if(QDELETED(GLOB.cult_narsie)) // tres
		priority_announce("检测到正常化! 中止部署解决方案!","[command_name()]高维事务", 'sound/misc/notice1.ogg')
		SSshuttle.clearHostileEnvironment(GLOB.cult_narsie)
		GLOB.cult_narsie = null
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(narsie_last_second_win)), 2 SECONDS)
		return
	if(GLOB.cult_narsie.resolved == FALSE)
		GLOB.cult_narsie.resolved = TRUE
		sound_to_playing_players('sound/machines/alarm.ogg')
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper)), 12 SECONDS)

///Called only if the crew managed to destroy narsie at the very last second for [/proc/begin_the_end()]
/proc/narsie_last_second_win()
	SSsecurity_level.set_level(SEC_LEVEL_RED)
	SSshuttle.lockdown = FALSE
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(cult_ending_helper), CULT_FAILURE_NARSIE_KILLED)

///Helper to set the round to end asap. Current usage Cult round end code
/proc/ending_helper()
	SSticker.force_ending = FORCE_END_ROUND

/**
 * Selects cinematic to play as part of the cult end depending on the outcome then ends the round afterward
 * called either when narsie eats everyone, or when [/proc/begin_the_end()] reaches it's conclusion
 */
/proc/cult_ending_helper(ending_type = CULT_VICTORY_NUKE)
	switch(ending_type)
		// Narsie was killed
		if(CULT_FAILURE_NARSIE_KILLED)
			play_cinematic(/datum/cinematic/cult_fail, world, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ending_helper)))

		// The cult "converted" (harvested) most of the station
		if(CULT_VICTORY_MASS_CONVERSION)
			play_cinematic(/datum/cinematic/cult_arm, world, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ending_helper)))

		// The cult won, but centcom deployed a nuke. Default
		if(CULT_VICTORY_NUKE)
			play_cinematic(/datum/cinematic/nuke/cult, world, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ending_helper)))

#undef NARSIE_CHANCE_TO_PICK_NEW_TARGET
#undef NARSIE_CONSUME_RANGE
#undef NARSIE_GRAV_PULL
#undef NARSIE_MESMERIZE_CHANCE
#undef NARSIE_MESMERIZE_EFFECT
#undef NARSIE_SINGULARITY_SIZE

#undef ADMIN_WARNING_MESSAGE
