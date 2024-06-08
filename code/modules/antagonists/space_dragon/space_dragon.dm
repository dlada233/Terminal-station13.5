/datum/antagonist/space_dragon
	name = "\improper 太空龙"
	roundend_category = "太空龙"
	antagpanel_category = ANTAG_GROUP_LEVIATHANS
	job_rank = ROLE_SPACE_DRAGON
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	/// 由此反派太空龙创建的所有太空鲤鱼
	var/list/datum/mind/carp = list()
	/// 召唤裂隙的内在能力
	var/datum/action/innate/summon_rift/rift_ability
	/// 自上次裂隙激活以来的当前时间. 如果设置为-1，则不递增.
	var/riftTimer = 0
	/// 在太空龙消失之前允许的最长时间，单位为秒.
	var/maxRiftTimer = 300
	/// 太空龙创建的所有裂隙的列表. 用于在太空龙获胜时将它们全部设置为无限的鲤鱼生成，以及在太空龙死亡时将它们移除.
	var/list/obj/structure/carp_rift/rift_list = list()
	/// 成功充能的裂隙数量
	var/rifts_charged = 0
	/// 太空龙是否完成了其目标，从而触发了结束序列.
	var/objective_complete = FALSE
	/// 通过此龙的裂隙召唤的幽灵的生物
	var/minion_to_spawn = /mob/living/basic/carp/advanced
	/// 通过此龙的裂隙召唤的AI生物
	var/ai_to_spawn = /mob/living/basic/carp
	/// Wavespeak心灵链接器，允许太空龙与鲤鱼进行心灵交流
	var/datum/component/mind_linker/wavespeak
	/// 可以放置裂隙的区域列表
	var/list/chosen_rift_areas = list()

/datum/antagonist/space_dragon/greet()
	. = ..()
	to_chat(owner, "<b>我们已经跨越了无尽的时空，我们不记得来自何处，也不知道将去往何处，因为咫尺天涯不过一瞬. \n\
					这片空旷的虚空中，我们曾屹立于食物链之巅，而极少有挑战者上前. \n\
					然而时过境迁，入侵者如今分散在我们的领地中，想用费解的魔法对抗利齿，筑起闪烁星光的巢穴. \n\
					但可知，星云变换也不过朝生暮死!</b>")
	to_chat(owner, span_boldwarning("你有五分钟的时间找到一个安全的位置放置第一个裂隙. 超时将被送回原来的地方. "))
	owner.announce_objectives()
	owner.current.playsound_local(get_turf(owner.current), 'sound/magic/demon_attack1.ogg', 80)

/datum/antagonist/space_dragon/forge_objectives()
	var/static/list/area/allowed_areas
	if(!allowed_areas)
		// 对太空龙构成挑战且对船员具有挑衅性的区域.
		allowed_areas = typecacheof(list(
			/area/station/command,
			/area/station/engineering,
			/area/station/science,
			/area/station/security,
		))

	var/list/possible_areas = typecache_filter_list(get_sorted_areas(), allowed_areas)
	for(var/area/possible_area as anything in possible_areas)
		if(initial(possible_area.outdoors) || !(possible_area.area_flags & VALID_TERRITORY))
			possible_areas -= possible_area

	for(var/i in 1 to 5)
		chosen_rift_areas += pick_n_take(possible_areas)

	var/datum/objective/summon_carp/summon = new
	objectives += summon
	summon.owner = owner
	summon.update_explanation_text()

/datum/antagonist/space_dragon/on_gain()
	forge_objectives()
	rift_ability = new()
	owner.special_role = ROLE_SPACE_DRAGON
	owner.set_assigned_role(SSjob.GetJobType(/datum/job/space_dragon))
	return ..()

/datum/antagonist/space_dragon/on_removal()
	owner.special_role = null
	owner.set_assigned_role(SSjob.GetJobType(/datum/job/unassigned))
	return ..()

/datum/antagonist/space_dragon/apply_innate_effects(mob/living/mob_override)
	var/mob/living/antag = mob_override || owner.current
	RegisterSignal(antag, COMSIG_LIVING_LIFE, PROC_REF(rift_checks))
	RegisterSignal(antag, COMSIG_LIVING_DEATH, PROC_REF(destroy_rifts))
	antag.faction |= FACTION_CARP
	// 如果有的话，赋予能力
	rift_ability?.Grant(antag)
	wavespeak = antag.AddComponent( \
		/datum/component/mind_linker, \
		network_name = "交流波", \
		chat_color = "#635BAF", \
		signals_which_destroy_us = list(COMSIG_LIVING_DEATH), \
		speech_action_icon = 'icons/mob/actions/actions_space_dragon.dmi', \
		speech_action_icon_state = "wavespeak", \
	)
	RegisterSignal(wavespeak, COMSIG_QDELETING, PROC_REF(clear_wavespeak))

/datum/antagonist/space_dragon/remove_innate_effects(mob/living/mob_override)
	var/mob/living/antag = mob_override || owner.current
	UnregisterSignal(antag, COMSIG_LIVING_LIFE)
	UnregisterSignal(antag, COMSIG_LIVING_DEATH)
	antag.faction -= FACTION_CARP
	rift_ability?.Remove(antag)
	QDEL_NULL(wavespeak)

/datum/antagonist/space_dragon/Destroy()
	rift_list = null
	carp = null
	QDEL_NULL(rift_ability)
	QDEL_NULL(wavespeak)
	chosen_rift_areas.Cut()
	return ..()

/datum/antagonist/space_dragon/get_preview_icon()
	var/icon/icon = icon('icons/mob/nonhuman-player/spacedragon.dmi', "spacedragon")

	icon.Blend(COLOR_STRONG_VIOLET, ICON_MULTIPLY)
	icon.Blend(icon('icons/mob/nonhuman-player/spacedragon.dmi', "overlay_base"), ICON_OVERLAY)

	icon.Crop(10, 9, 54, 53)
	icon.Scale(ANTAGONIST_PREVIEW_ICON_SIZE, ANTAGONIST_PREVIEW_ICON_SIZE)

	return icon

/datum/antagonist/space_dragon/proc/clear_wavespeak()
	SIGNAL_HANDLER
	wavespeak = null

/**
 * 检查太空龙裂隙的当前状态是否需要进行任何操作.
 *
 * 一个简单的更新检查，根据太空龙裂隙的当前状态判断是否需要进行任何操作.
 */
/datum/antagonist/space_dragon/proc/rift_checks()
	if((rifts_charged == 3 || (SSshuttle.emergency.mode == SHUTTLE_DOCKED && rifts_charged > 0)) && !objective_complete)
		victory()
		return
	if(riftTimer == -1)
		return
	riftTimer = min(riftTimer + 1, maxRiftTimer + 1)
	if(riftTimer == (maxRiftTimer - 60))
		to_chat(owner.current, span_boldwarning("你还有一分钟召唤裂隙的时间！抓紧时间！"))
		return
	if(riftTimer >= maxRiftTimer)
		to_chat(owner.current, span_boldwarning("你未能及时召唤裂隙！你被送回了原来的地方！"))
		destroy_rifts()
		SEND_SOUND(owner.current, sound('sound/magic/demon_dies.ogg'))
		owner.current.death(/* gibbed = */ TRUE)
		QDEL_NULL(owner.current)

/**
 * 销毁太空龙当前的所有裂隙.
 *
 * QDeletes所有当前的裂隙，之前移除它们与其他对象的引用.
 * 目前，它们唯一的引用是创建它们的太空龙，因此我们在删除它们之前清除了该引用.
 * 当太空龙死亡或其裂隙之一被销毁时当前使用.
 */
/datum/antagonist/space_dragon/proc/destroy_rifts()
	if(objective_complete)
		return
	rifts_charged = 0
	ADD_TRAIT(owner.current, TRAIT_RIFT_FAILURE, REF(src))
	owner.current.add_movespeed_modifier(/datum/movespeed_modifier/dragon_depression)
	riftTimer = -1
	SEND_SOUND(owner.current, sound('sound/vehicles/rocketlaunch.ogg'))
	for(var/obj/structure/carp_rift/rift as anything in rift_list)
		rift.dragon = null
		rift_list -= rift
		if(!QDELETED(rift))
			QDEL_NULL(rift)

/**
 * 设置太空龙完成目标的胜利条件.
 *
 * 当太空龙完成他的目标时触发.
 * 呼叫系数为3的穿梭，使其无法召回.
 * 设置他的所有裂隙以允许无限产生有感知的鲤鱼.
 * 同时播放适当的声音和CENTCOM消息.
 */
/datum/antagonist/space_dragon/proc/victory()
	objective_complete = TRUE
	permanant_empower()
	var/datum/objective/summon_carp/main_objective = locate() in objectives
	main_objective?.completed = TRUE
	priority_announce("在[station_name()]上检测到了大量生命体以极高的速度接近. \
		剩余船员被建议尽快撤离. ", "[command_name()] 野生动物监测", has_important_message = TRUE)
	sound_to_playing_players('sound/creatures/space_dragon_roar.ogg', volume = 75)
	for(var/obj/structure/carp_rift/rift as anything in rift_list)
		rift.carp_stored = 999999
		rift.time_charged = rift.max_charge

/**
 * 永久给予太空龙裂隙速度提升，并完全治愈用户.
 *
 * 永久给予太空龙从充能裂隙中获得的愤怒速度提升.
 * 仅在太空龙完成他们的目标的情况下发生.
 * 同时对其进行完全治愈.
 */
/datum/antagonist/space_dragon/proc/permanant_empower()
	owner.current.fully_heal()
	owner.current.add_filter("anger_glow", 3, list("type" = "outline", "color" = "#ff330030", "size" = 5))
	owner.current.add_movespeed_modifier(/datum/movespeed_modifier/dragon_rage)

/**
 * 在增强裂隙后处理太空龙的临时增强.
 *
 * 在成功充能裂隙后，给予太空龙力量，并在30秒内降低太空龙的力量.
 * 在增强状态下，太空龙恢复所有健康，并在30秒内变得临时更快，同时呈现红色.
 */
/datum/antagonist/space_dragon/proc/rift_empower()
	owner.current.fully_heal()
	owner.current.add_filter("anger_glow", 3, list("type" = "outline", "color" = "#ff330030", "size" = 5))
	owner.current.add_movespeed_modifier(/datum/movespeed_modifier/dragon_rage)
	addtimer(CALLBACK(src, PROC_REF(rift_depower)), 30 SECONDS)

/**
 * 移除太空龙的裂隙速度提升.
 *
 * 移除太空龙从充能裂隙中获得的速度提升. 此方法仅在
 * rift_empower中调用，该方法使用定时器在30秒后调用此方法.
 * 同时从太空龙身上移除与速度提升相对应的红色发光.
 */
/datum/antagonist/space_dragon/proc/rift_depower()
	owner.current.remove_filter("anger_glow")
	owner.current.remove_movespeed_modifier(/datum/movespeed_modifier/dragon_rage)

/datum/objective/summon_carp
	explanation_text = "召唤3个裂隙以让鲤鱼潮淹没空间站."

/datum/objective/summon_carp/update_explanation_text()
	var/datum/antagonist/space_dragon/dragon_owner = owner.has_antag_datum(/datum/antagonist/space_dragon)
	if(isnull(dragon_owner))
		return

	var/list/converted_names = list()
	for(var/area/possible_area as anything in dragon_owner.chosen_rift_areas)
		converted_names += possible_area.get_original_area_name()

	explanation_text = initial(explanation_text)
	explanation_text += " 你可用的裂隙位置有：[english_list(converted_names)]"

/datum/antagonist/space_dragon/roundend_report()
	var/list/parts = list()
	var/datum/objective/summon_carp/S = locate() in objectives
	if(S.check_completion())
		parts += "<span class='redtext big'>[name]成功了！太空鲤鱼占领了空间站空间！</span>"
	parts += printplayer(owner)
	var/objectives_complete = TRUE
	if(objectives.len)
		parts += printobjectives(objectives)
		for(var/datum/objective/objective in objectives)
			if(!objective.check_completion())
				objectives_complete = FALSE
				break
	if(objectives_complete)
		parts += "<span class='greentext big'>[name]成功了！</span>"
	else
		parts += "<span class='redtext big'>[name]失败了！</span>"

	if(length(carp))
		parts += "<br><span class='header'>[name]受到以下帮助：</span>"
		parts += "<ul class='playerlist'>"
		var/list/players_to_carp_taken = list()
		for(var/datum/mind/carpy as anything in carp)
			players_to_carp_taken[carpy.key] += 1
		var/list = ""
		for(var/carp_user in players_to_carp_taken)
			list += "<li><b>[carp_user]</b>总共玩了<b>[players_to_carp_taken[carp_user]]</b>只太空鲤鱼. </li>"
		parts += list
		parts += "</ul>"

	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"
