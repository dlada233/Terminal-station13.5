/// 鲤鱼裂隙正在充能.
#define CHARGE_ONGOING 0
/// 鲤鱼裂隙正在充能，并发出最后警告.
#define CHARGE_FINALWARNING 1
/// 鲤鱼裂隙已充能完成.
#define CHARGE_COMPLETED 2

/datum/action/innate/summon_rift
	name = "召唤裂隙"
	desc = "召唤一个裂隙，释放一群太空鲤鱼. "
	background_icon_state = "bg_default"
	overlay_icon_state = "bg_default_border"
	button_icon = 'icons/mob/actions/actions_space_dragon.dmi'
	button_icon_state = "carp_rift"

/datum/action/innate/summon_rift/Activate()
	var/datum/antagonist/space_dragon/dragon = owner.mind?.has_antag_datum(/datum/antagonist/space_dragon)
	if(!dragon)
		return
	var/area/rift_location = get_area(owner)
	if(!(rift_location in dragon.chosen_rift_areas))
		owner.balloon_alert(owner, "不能在这里召唤裂隙！")
		return
	for(var/obj/structure/carp_rift/rift as anything in dragon.rift_list)
		var/area/used_location = get_area(rift)
		if(used_location == rift_location)
			owner.balloon_alert(owner, "已在此处召唤裂隙！")
			return
	var/turf/rift_spawn_turf = get_turf(dragon)
	if(isopenspaceturf(rift_spawn_turf))
		owner.balloon_alert(dragon, "需要稳定的地面！")
		return
	owner.balloon_alert(owner, "正在打开裂隙...")
	if(!do_after(owner, 10 SECONDS, target = owner))
		return
	if(locate(/obj/structure/carp_rift) in owner.loc)
		return
	var/obj/structure/carp_rift/new_rift = new(get_turf(owner))
	playsound(owner.loc, 'sound/vehicles/rocketlaunch.ogg', 100, TRUE)
	dragon.riftTimer = -1
	new_rift.dragon = dragon
	dragon.rift_list += new_rift
	to_chat(owner, span_boldwarning("裂隙已召唤. 务必阻止船员摧毁它！"))
	notify_ghosts(
		"太空龙已打开一个裂隙！",
		source = new_rift,
		header = "裂隙打开",
		notify_flags = NOTIFY_CATEGORY_NOFLASH,
	)
	ASSERT(dragon.rift_ability == src) // Badmin protection.
	QDEL_NULL(dragon.rift_ability) // 使用成功后删除此动作，我们稍后会重新获得一个新的.

/**
 * # 鲤鱼裂隙
 *
 * 太空龙召唤的用于将鲤鱼带到站点上的传送门.
 *
 * 太空龙召唤的用于将鲤鱼带到站点上的传送门. 他的主要目标是召唤3个裂隙并保护它们免受破坏.
 * 传送门可以召唤有限数量的有感知能力的太空鲤鱼. 传送门的颜色也会根据是否可召唤鲤鱼而改变.
 * 一旦充能完成，传送门变得无法摧毁，并会定期产生非有感知能力的鲤鱼. 如果太空龙死亡，传送门仍会被摧毁.
 */
/obj/structure/carp_rift
	name = "鲤鱼裂隙"
	desc = "太空鲤鱼用于长距离移动的裂隙. "
	armor_type = /datum/armor/structure_carp_rift
	max_integrity = 300
	icon = 'icons/obj/anomaly.dmi'
	icon_state = "carp_rift_carpspawn"
	light_color = LIGHT_COLOR_PURPLE
	light_range = 10
	anchored = TRUE
	density = TRUE
	plane = MASSIVE_OBJ_PLANE
	/// 裂隙充能时间.
	var/time_charged = 0
	/// 裂隙的最大充能量.
	var/max_charge = 300
	/// 可用的鲤鱼数量.
	var/carp_stored = 1
	/// A reference to the Space Dragon antag that created it.
	var/datum/antagonist/space_dragon/dragon
	/// 初始充能状态.
	var/charge_state = CHARGE_ONGOING
	/// 添加额外太空鲤鱼到裂隙的时间间隔.
	var/carp_interval = 45
	/// 上次向幽灵角色产生额外太空鲤鱼的时间.
	var/last_carp_inc = 0
	/// 使用此裂隙产生鲤鱼的 CKey 列表.
	var/list/ckey_list = list()
	/// 裂隙的重力场，使附近所有地块受到强制重力.
	var/datum/proximity_monitor/advanced/gravity/warns_on_entrance/gravity_aura


/datum/armor/structure_carp_rift
	energy = 100
	bomb = 50
	bio = 100
	fire = 100
	acid = 100

/obj/structure/carp_rift/hulk_damage()
	return 30

/obj/structure/carp_rift/Initialize(mapload)
	. = ..()

	AddComponent( \
		/datum/component/aura_healing, \
		range = 1, \
		simple_heal = 5, \
		limit_to_trait = TRAIT_HEALS_FROM_CARP_RIFTS, \
		healing_color = COLOR_BLUE, \
	)

	gravity_aura = new(
		/* host = */src,
		/* range = */15,
		/* ignore_if_not_on_turf = */TRUE,
		/* gravity = */1,
	)

	START_PROCESSING(SSobj, src)

/obj/structure/carp_rift/Destroy()
	QDEL_NULL(gravity_aura)
	return ..()

// 鲤鱼裂隙始终会受到严重的爆炸伤害. 这种做法不鼓励使用大型炸药
// 而更倾向于使用较弱的爆炸物来摧毁传送门
// 因为它们对传送门的影响相同.
/obj/structure/carp_rift/ex_act(severity, target)
	return ..(min(EXPLODE_HEAVY, severity))

/obj/structure/carp_rift/examine(mob/user)
	. = ..()
	if(time_charged < max_charge)
		. += span_notice("似乎达到了[(time_charged / max_charge) * 100]%充能. ")
	else
		. += span_warning("充能完成，它可以传送比正常情况下更多的鲤鱼. ")

	if(isobserver(user))
		. += span_notice("它有[carp_stored]条可供召唤的鲤鱼. ")

/obj/structure/carp_rift/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	playsound(src, 'sound/magic/lightningshock.ogg', 50, TRUE)

/obj/structure/carp_rift/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(charge_state != CHARGE_COMPLETED)
		if(dragon)
			to_chat(dragon.owner.current, span_boldwarning("一个裂隙已经被摧毁！你失败了，并且自己还变得虚弱."))
			dragon.destroy_rifts()
	dragon = null
	return ..()

/obj/structure/carp_rift/process(seconds_per_tick)
	// 如果充能完成，开始大量产生鲤鱼并移动.
	if(charge_state == CHARGE_COMPLETED)
		if(SPT_PROB(1.25, seconds_per_tick) && dragon)
			var/mob/living/newcarp = new dragon.ai_to_spawn(loc)
			newcarp.faction = dragon.owner.current.faction.Copy()
		if(SPT_PROB(1.5, seconds_per_tick))
			var/rand_dir = pick(GLOB.cardinals)
			SSmove_manager.move_to(src, get_step(src, rand_dir), 1)
		return

	// 增加时间追踪器并检查任何更新的状态.
	time_charged = min(time_charged + seconds_per_tick, max_charge)
	last_carp_inc += seconds_per_tick
	update_check()

/obj/structure/carp_rift/attack_ghost(mob/user)
	. = ..()
	if(.)
		return
	summon_carp(user)

/**
 * 根据裂隙的状态进行一系列检查.
 *
 * 根据裂隙当前的充能状态执行一系列检查，并相应地触发各种效果.
 * 如果当前充能是 carp_interval 的倍数，则增加一个额外的鲤鱼生成.
 * 如果我们充能到一半时，在 CENTCOM 的通知中向船员宣布我们的位置.
 * 如果我们充能完全，告诉船员我们已经充能完全，将我们的颜色改为黄色，变得无敌，并给 Space Dragon 提供制造另一个裂隙的能力，如果他还没有召唤总共 3 个裂隙.
 */
/obj/structure/carp_rift/proc/update_check()
	// 如果裂隙已完全充能，则此处不需要进行任何操作.
	if(charge_state == CHARGE_COMPLETED)
		return

	// 我们能增加鲤鱼生成池的大小吗？
	if(last_carp_inc >= carp_interval)
		carp_stored++
		icon_state = "carp_rift_carpspawn"
		if(light_color != LIGHT_COLOR_PURPLE)
			set_light_color(LIGHT_COLOR_PURPLE)
			update_light()
		notify_ghosts(
			"鲤鱼裂隙可以再生成一条鲤鱼！",
			source = src,
			header = "鲤鱼生成可用",
			notify_flags = NOTIFY_CATEGORY_NOFLASH,
		)
		last_carp_inc -= carp_interval

	// 裂隙现在是否已完全充能？
	if(time_charged >= max_charge)
		charge_state = CHARGE_COMPLETED
		var/area/A = get_area(src)
		priority_announce("[initial(A.name)]中的空间对象中已达到能量充能的峰值，请做好准备. ", "[command_name()] 野生动物监测", has_important_message = TRUE)
		atom_integrity = INFINITY
		icon_state = "carp_rift_charged"
		set_light_color(LIGHT_COLOR_DIM_YELLOW)
		update_light()
		set_armor(/datum/armor/immune)
		resistance_flags = INDESTRUCTIBLE
		dragon.rifts_charged += 1
		if(dragon.rifts_charged != 3 && !dragon.objective_complete)
			dragon.rift_ability = new()
			dragon.rift_ability.Grant(dragon.owner.current)
			dragon.riftTimer = 0
			dragon.rift_empower()
		// 提前返回，此后没有要做的事情.
		return

	// 在一半充能时，我们需要向站点发出最后警告吗？
	if(charge_state < CHARGE_FINALWARNING && time_charged >= (max_charge * 0.5))
		charge_state = CHARGE_FINALWARNING
		var/area/A = get_area(src)
		priority_announce("[initial(A.name)]中的一个裂隙引发了异常的大能量波动. 不惜一切代价摧毁它！", "[command_name()] 野生动物监测", ANNOUNCER_SPANOMALIES)

/**
 * 当选项可用时，用于创建由幽灵控制的鲤鱼。
 *
 * 如果我们有可用的鲤鱼生成，为幽灵创建一个可控制的鲤鱼。
 * 给他们一个提示，让他们控制一条鲤鱼，如果我们的情况仍然允许的话，当他们点击是时，将它们作为鲤鱼生成。
 * 还将它们添加到 Space Dragon 的反派数据中的鲤鱼列表中，这样它们将在回合结束时显示为帮助了他。
 * 参数：
 * * mob/user - 将控制鲤鱼的幽灵。
 */
/obj/structure/carp_rift/proc/summon_carp(mob/user)
	if(carp_stored <= 0)// 没有足够的鲤鱼点数
		return FALSE
	var/is_listed = FALSE
	if (user.ckey in ckey_list)
		if(carp_stored == 1)
			to_chat(user, span_warning("你已经用此裂隙变成一条鲤鱼了！召唤更多鲤鱼需要等待一段时间，或等待下一个裂隙！"))
			return FALSE
		is_listed = TRUE
	var/carp_ask = tgui_alert(user, "成为一条鲤鱼吗？", "鲤鱼裂隙", list("是", "否"))
	if(carp_ask != "是" || QDELETED(src) || QDELETED(user))
		return FALSE
	if(carp_stored <= 0)
		to_chat(user, span_warning("该裂隙已经召唤足够多的鲤鱼！"))
		return FALSE

	if(isnull(dragon))
		return
	var/mob/living/newcarp = new dragon.minion_to_spawn(loc)
	newcarp.faction = dragon.owner.current.faction
	newcarp.AddElement(/datum/element/nerfed_pulling, GLOB.typecache_general_bad_things_to_easily_move)
	newcarp.AddElement(/datum/element/prevent_attacking_of_types, GLOB.typecache_general_bad_hostile_attack_targets, "这尝起来很难吃！")
	dragon.wavespeak?.link_mob(newcarp)

	if(!is_listed)
		ckey_list += user.ckey
	newcarp.key = user.key
	newcarp.set_name()
	var/datum/antagonist/space_carp/carp_antag = new(src)
	newcarp.mind.add_antag_datum(carp_antag)
	dragon.carp += newcarp.mind
	to_chat(newcarp, span_boldwarning("你到达此地以协助太空龙保护裂隙，不要玩忽职守，以任何代价保护裂隙！"))
	carp_stored--
	if(carp_stored <= 0 && charge_state < CHARGE_COMPLETED)
		icon_state = "carp_rift"
		set_light_color(LIGHT_COLOR_BLUE)
		update_light()
	return TRUE

#undef CHARGE_ONGOING
#undef CHARGE_FINALWARNING
#undef CHARGE_COMPLETED
