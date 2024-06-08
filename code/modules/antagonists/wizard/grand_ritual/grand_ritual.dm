/**
 * 在巫师的大仪式期间向[已编辑]献祭奶酪的总目标。
 * 巫师获取奶酪的最简单方法是使用召唤奶酪法术，每次施法召唤9块奶酪。
 * 巫师需要完成7个仪式，因此我们在奶酪献祭上给他们一些余地。
 * 7 * 9 = 63，所以巫师如果每次在法阵上召唤奶酪，他们最多可以少召唤两次。
 */
#define CHEESE_SACRIFICE_GOAL 50
/**
 * 大仪式是巫师的替代胜利条件，
 * 也是一个制造有趣干扰和推动回合状态的工具。
 *
 * 巫师会被分配一个随机区域来进行仪式。
 * 这需要前往该区域，画一个3x3的法阵，并在上面施法一段时间。
 * 完成这些会立即触发一个随机事件，并可能在该区域产生额外的副作用。
 * 完成的仪式越多，生成的事件就越戏剧性。
 *
 * 在通过某些门槛后，大仪式的完成将开始生成活跃和耗尽的现实裂痕。
 * 超过某个门槛后，开始仪式会通知船员你的位置。
 *
 * 第七次仪式是特殊的，你可以选择一个非常戏剧性的“结局”效果。
 * 此后进一步的完成将返回到通常的行为。
 */
/datum/action/cooldown/grand_ritual
	name = "大仪式"
	desc = "大仪式为天地间汇聚的魔力指引方向，需要在特定位置画出法阵并启动.\
		而启动所需的时间只会一次比一次长."
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED | AB_CHECK_HANDS_BLOCKED
	background_icon_state = "bg_spell"
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "draw"
	cooldown_rounding = 0
	/// 要绘制下一个法阵的区域路径
	var/area/target_area
	/// 此用户完成大仪式的次数
	var/times_completed = 0
	/// 是否已画出结局法阵
	var/drew_finale = FALSE
	/// 在画法阵期间为真，防止动作刷屏
	var/drawing_rune = FALSE
	/// 之前绘制的法阵上献祭的奶酪数量
	var/total_cheese_sacrificed = 0
	/// 是否已献祭足够的奶酪
	var/total_cheese_goal_met = FALSE
	/// 在当前区域绘制的法阵的弱引用，如果有的话
	var/datum/weakref/rune

	/// 无法刻写法阵的地面黑名单。
	var/static/list/blacklisted_rune_turfs = typecacheof(list(
		/turf/closed/indestructible,
		/turf/open/chasm,
		/turf/open/indestructible,
		/turf/open/lava,
		/turf/open/openspace,
		/turf/open/space,
	))
	/**
	 * 可以放置法阵的区域
	 * 老实说，如果没有维修子类型，我可能只需要一个黑名单，c'est la vie
	 */
	var/static/list/area_whitelist = typecacheof(list(
		/area/station/cargo,
		/area/station/command,
		/area/station/commons,
		/area/station/construction,
		/area/station/engineering,
		/area/station/maintenance/disposal,
		/area/station/maintenance/radshelter,
		/area/station/maintenance/tram,
		/area/station/medical,
		/area/station/science,
		/area/station/security,
		/area/station/service,
	))
	/// 不能被要求绘制法阵的区域，通常因为它们太危险
	var/static/list/area_blacklist = typecacheof(list(
		/area/station/cargo/warehouse, // 这应该是可以的，除了有人给了这个区域一个位于太空的千克结构
		/area/station/engineering/supermatter,
		/area/station/engineering/transit_tube,
		/area/station/science/ordnance/bomb,
		/area/station/science/ordnance/burnchamber,
		/area/station/science/ordnance/freezerchamber,
		/area/station/science/server,
		/area/station/security/prison/safe,
	))

/datum/action/cooldown/grand_ritual/IsAvailable(feedback)
	. = ..()
	if (!.)
		return

	if(!isturf(owner.loc))
		if (feedback)
			owner.balloon_alert(owner, "无法触及地面！")
		return FALSE
	return TRUE

/datum/action/cooldown/grand_ritual/Activate(trigger_flags)
	. = ..()
	validate_area()
	if (istype(get_area(owner), target_area))
		start_drawing_rune()
	else
		pinpoint_area()

/datum/action/cooldown/grand_ritual/Grant(mob/grant_to)
	. = ..()
	if (!owner)
		return
	if (!target_area)
		set_new_area()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(update_status_on_signal))

/datum/action/cooldown/grand_ritual/Remove(mob/remove_from)
	. = ..()
	UnregisterSignal(remove_from, COMSIG_MOVABLE_MOVED)

/// 如果目标区域不存在或已被某种方式无效化，选择另一个区域
/datum/action/cooldown/grand_ritual/proc/validate_area()
	if (!target_area || !length(get_area_turfs(target_area)))
		set_new_area()
		return FALSE
	return TRUE

/// 找一个随机的车站区域来放置我们的法阵
/datum/action/cooldown/grand_ritual/proc/set_new_area()
	var/list/possible_areas = GLOB.the_station_areas.Copy()
	for (var/area/possible_area as anything in possible_areas)
		if (initial(possible_area.outdoors) \
			|| !is_type_in_typecache(possible_area, area_whitelist) \
			|| is_type_in_typecache(possible_area, area_blacklist))
			possible_areas -= possible_area

	target_area = pick(possible_areas)
	if (validate_area()) // 这有点冒险，但车站上的每个区域可能不会都被删除，对吧？
		to_chat(owner, span_alert("下一个魔力汇聚地在[initial(target_area.name)]"))

/// 检查你是否真的能在这里画法阵
/datum/action/cooldown/grand_ritual/proc/start_drawing_rune()
	var/atom/existing_rune = rune?.resolve()
	if (existing_rune)
		owner.balloon_alert(owner, "法阵已经存在！")
		return

	var/turf/target_turf = get_turf(owner)
	for (var/turf/nearby_turf as anything in RANGE_TURFS(1, target_turf))
		if (!is_type_in_typecache(nearby_turf, blacklisted_rune_turfs))
			continue
		owner.balloon_alert(owner, "无效的地面！")
		return

	if (locate(/obj/effect/grand_rune) in range(3, target_turf))
		owner.balloon_alert(owner, "太过靠近另一个法阵了！")
		return

	if (drawing_rune)
		owner.balloon_alert(owner, "正在画法阵！")
		return

	INVOKE_ASYNC(src, PROC_REF(draw_rune), target_turf)

/// 画出仪式法阵
/datum/action/cooldown/grand_ritual/proc/draw_rune(turf/target_turf)
	drawing_rune = TRUE
	var/next_rune_typepath = get_appropriate_rune_typepath()
	target_turf.balloon_alert(owner, "法阵凝聚中...")
	var/draw_effect_typepath = /obj/effect/temp_visual/wizard_rune/drawing
	if(next_rune_typepath == /obj/effect/grand_rune/finale/cheesy)
		draw_effect_typepath = /obj/effect/temp_visual/wizard_rune/drawing/cheese
	var/obj/effect/temp_visual/wizard_rune/drawing/draw_effect = new draw_effect_typepath(target_turf)
	if(!do_after(owner, 4 SECONDS, target_turf))
		target_turf.balloon_alert(owner, "被打断了！")
		drawing_rune = FALSE
		qdel(draw_effect)
		var/fail_effect_typepath = /obj/effect/temp_visual/wizard_rune/failed
		if(next_rune_typepath == /obj/effect/grand_rune/finale/cheesy)
			fail_effect_typepath = /obj/effect/temp_visual/wizard_rune/failed/cheese
		new fail_effect_typepath(target_turf)
		return

	var/evaporated_obstacles = FALSE
	for (var/atom/possible_obstacle in range(1, target_turf))
		if (!possible_obstacle.density)
			continue
		evaporated_obstacles = TRUE
		new /obj/effect/temp_visual/emp/pulse(possible_obstacle)

		if (iswallturf(possible_obstacle))
			var/turf/closed/wall/wall = possible_obstacle
			wall.dismantle_wall(devastated = TRUE)
			continue
		possible_obstacle.atom_destruction("magic")

	if (evaporated_obstacles)
		playsound(target_turf, 'sound/magic/blind.ogg', 100, TRUE)

	target_turf.balloon_alert(owner, "法阵已创建")
	var/obj/effect/grand_rune/new_rune = new next_rune_typepath(target_turf, times_completed)
	if(istype(new_rune, /obj/effect/grand_rune/finale))
		drew_finale = TRUE
	rune = WEAKREF(new_rune)
	RegisterSignal(new_rune, COMSIG_GRAND_RUNE_COMPLETE, PROC_REF(on_rune_complete))
	drawing_rune = FALSE
	StartCooldown(2 MINUTES) // 为了阻止拥有5级传送术的巫师

/// 第七个生成的法阵是特殊的
/datum/action/cooldown/grand_ritual/proc/get_appropriate_rune_typepath()
	if (times_completed < GRAND_RITUAL_FINALE_COUNT - 1)
		return /obj/effect/grand_rune
	if (drew_finale)
		return /obj/effect/grand_rune
	if (total_cheese_sacrificed >= CHEESE_SACRIFICE_GOAL)
		return /obj/effect/grand_rune/finale/cheesy
	return /obj/effect/grand_rune/finale

/// 当你完成一个绘制的法阵时被调用，准备好绘制另一个法阵。
/datum/action/cooldown/grand_ritual/proc/on_rune_complete(atom/source, cheese_sacrificed)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_GRAND_RUNE_COMPLETE)
	total_cheese_sacrificed += cheese_sacrificed
	if(total_cheese_sacrificed >= CHEESE_SACRIFICE_GOAL)
		if(!total_cheese_goal_met)
			total_cheese_goal_met = TRUE
			to_chat(owner, span_revenbignotice("YES! CHEESE! CHEESE FOR EVERYONE! SUCH A GRAND FEAST! YOU SHALL HAVE YOUR PRIZE, MY CHAMPION!!"))
		else
			to_chat(owner, span_revennotice("你听到一阵疯狂的笑声，随之而来的是一股浓烈的上等切达干酪的气味..."))
	else if (total_cheese_sacrificed)
		to_chat(owner, span_revendanger("你令我满意，凡人。继续献上奶酪吧，我的盛宴还需要<b>[CHEESE_SACRIFICE_GOAL - total_cheese_sacrificed]</b>才能完美..."))
	rune = null
	times_completed++
	set_new_area()
	switch (times_completed)
		if (GRAND_RITUAL_RUNES_WARNING_POTENCY)
			to_chat(owner, span_warning("越来越多的魔力汇聚而来，\
				继续进行仪式将会暴露你的位置给敌人."))
		if (GRAND_RITUAL_IMMINENT_FINALE_POTENCY)
			var/message = "魔力已聚有千钧！\
				下一个大仪式将允许你选择一个强大的效果，并带来属于你的胜利。"
			if(total_cheese_sacrificed >= CHEESE_SACRIFICE_GOAL)
				message = "混沌魔力翻涌不息！\
					下一个大仪式将召唤出一个强大的神器，并带来属于你的胜利。"
			to_chat(owner, span_warning(message))
		if (GRAND_RITUAL_FINALE_COUNT)
			SEND_SIGNAL(src, COMSIG_GRAND_RITUAL_FINAL_COMPLETE)

/// 定位仪式区域
/datum/action/cooldown/grand_ritual/proc/pinpoint_area()
	var/area/area_turf = pick(get_area_turfs(target_area)) // 大致正确即可
	var/area/our_turf = get_turf(owner)
	owner.balloon_alert(owner, get_pinpoint_text(area_turf, our_turf))

/**
 * 比较位置并输出信息。
 * 类似于异教徒目标定位。
 * 但简化了，因为我们不应该能够定位在熔岩地或传送门的地点。
 */
/datum/action/cooldown/grand_ritual/proc/get_pinpoint_text(area/area_turf, area/our_turf)
	var/area_z = area_turf?.z
	var/our_z = our_turf?.z
	var/balloon_message = "出错了！"

	// 我们或者位置在不该去的地方
	if (!our_z || !area_z)
		// “鬼知道在哪”
		balloon_message = "在另一个次元！"
	// 不在同一层级
	else if (our_z != area_z)
		// 在空间站上
		if (is_station_level(area_z))
			// 我们在多层空间站上
			if (is_station_level(our_z))
				if (our_z > area_z)
					balloon_message = "在你下方！"
				else
					balloon_message = "在你上方！"
			// 我们不在空间站上，但目标在
			else
				balloon_message = "在空间站上！"
	// 在同一层级！
	else
		var/dist = get_dist(our_turf, area_turf)
		var/dir = get_dir(our_turf, area_turf)
		switch(dist)
			if (0 to 15)
				balloon_message = "很近，[dir2text(dir)]！"
			if (16 to 31)
				balloon_message = "近，[dir2text(dir)]！"
			if (32 to 127)
				balloon_message = "远，[dir2text(dir)]！"
			else
				balloon_message = "非常远！"

	return balloon_message

/// Abstract holder for shared animation behaviour
/obj/effect/temp_visual/wizard_rune
	icon = 'icons/effects/96x96.dmi'
	icon_state = null
	pixel_x = -28
	pixel_y = -33
	anchored = TRUE
	layer = SIGIL_LAYER
	plane = GAME_PLANE
	duration = 0 SECONDS

/obj/effect/temp_visual/wizard_rune/Initialize(mapload)
	. = ..()
	var/image/silicon_image = image(icon = 'icons/effects/eldritch.dmi', icon_state = null, loc = src)
	silicon_image.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "wizard_rune", silicon_image)

/// Animates drawing a cool rune
/obj/effect/temp_visual/wizard_rune/drawing
	icon_state = "wizard_rune_draw"
	duration = 4 SECONDS

/// Displayed if you stop drawing it
/obj/effect/temp_visual/wizard_rune/failed
	icon_state = "wizard_rune_fail"
	duration = 0.5 SECONDS

/// Cheese drawing
/obj/effect/temp_visual/wizard_rune/drawing/cheese
	icon_state = "wizard_rune_cheese_draw"

/// Cheese fail
/obj/effect/temp_visual/wizard_rune/failed/cheese
	icon_state = "wizard_rune_cheese_fail"

#undef CHEESE_SACRIFICE_GOAL
