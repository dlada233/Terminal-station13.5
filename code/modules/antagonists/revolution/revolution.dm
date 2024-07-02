/datum/antagonist/rev
	name = "\improper 革命者"
	roundend_category = "革命者" // if by some miracle revolutionaries without revolution happen
	antagpanel_category = "革命"
	job_rank = ROLE_REV
	antag_moodlet = /datum/mood_event/revolution
	antag_hud_name = "rev"
	suicide_cry = "革命万岁!!"
	var/datum/team/revolution/rev_team
	stinger_sound = 'sound/ambience/antag/revolutionary_tide.ogg'

	/// 当这个反派被解除时，这是来源. 可以是一个mob（用于心灵屏蔽/钝击创伤）或一个#define字符串.
	var/deconversion_source

/datum/antagonist/rev/can_be_owned(datum/mind/new_owner)
	if(new_owner.assigned_role.job_flags & JOB_HEAD_OF_STAFF)
		return FALSE
	if(new_owner.unconvertable)
		return FALSE
	if(new_owner.current && HAS_TRAIT(new_owner.current, TRAIT_MINDSHIELD))
		return FALSE
	return ..()

/datum/antagonist/rev/admin_add(datum/mind/new_owner, mob/admin)
	// 没有革命存在，这意味着管理员添加这个角色将创建一个新的革命
	// 这会带来问题，因为革命（目前）需要一个动态的数据来处理其胜利/失败条件
	if(!(locate(/datum/team/revolution) in GLOB.antagonist_teams))
		var/confirm = tgui_alert(admin, "注意：通过叛徒面板创建的革命不会完全起作用.  \
			领袖将能够像平常一样进行转变，但是逃生穿梭机不会被阻止，而且任何一方获胜时都不会有任何公告.  \
			你确定吗？", "慎重选择", list("是", "否"))
		if(QDELETED(src) || QDELETED(new_owner.current) || confirm != "是")
			return

	go_through_with_admin_add(new_owner, admin)

/datum/antagonist/rev/proc/go_through_with_admin_add(datum/mind/new_owner, mob/admin)
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)]转变了[key_name_admin(new_owner)]. ")
	log_admin("[key_name(admin)]转变了[key_name(new_owner)]. ")
	to_chat(new_owner.current, span_userdanger("你成为了革命集团的一员！"))

/datum/antagonist/rev/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	handle_clown_mutation(M, mob_override ? null : "你所受的训练让你克服了小丑的本性，你可以在不伤害自己的情况下使用武器.")
	add_team_hud(M, /datum/antagonist/rev)

/datum/antagonist/rev/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	handle_clown_mutation(M, removing = FALSE)

/datum/antagonist/rev/on_mindshield(mob/implanter)
	remove_revolutionary(implanter)
	return COMPONENT_MINDSHIELD_DECONVERTED

/datum/antagonist/rev/proc/equip_rev()
	return

/datum/antagonist/rev/on_gain()
	. = ..()
	create_objectives()
	equip_rev()
	owner.current.log_message("被转变为革命者！", LOG_ATTACK, color="red")

/datum/antagonist/rev/on_removal()
	remove_objectives()
	. = ..()

/datum/antagonist/rev/greet()
	. = ..()
	to_chat(owner, span_userdanger("支持革命事业. 不要伤害同为自由战士的同伴. 你可以通过红色的\"R\"图标识别你的同志，通过蓝色的\"R\"图标识别你的领袖. 帮助他们杀死头目，赢得革命胜利！"))
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/revolutionary_tide.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	owner.announce_objectives()

/datum/antagonist/rev/create_team(datum/team/revolution/new_team)
	if(!new_team)
		//For now only one revolution at a time
		for(var/datum/antagonist/rev/head/H in GLOB.antagonists)
			if(!H.owner)
				continue
			if(H.rev_team)
				rev_team = H.rev_team
				return
		rev_team = new /datum/team/revolution
		rev_team.update_objectives()
		rev_team.update_rev_heads()
		return
	if(!istype(new_team))
		stack_trace("错误的队伍类型传递给[type]初始化. ")
	rev_team = new_team

/datum/antagonist/rev/get_team()
	return rev_team

/datum/antagonist/rev/proc/create_objectives()
	objectives |= rev_team.objectives

/datum/antagonist/rev/proc/remove_objectives()
	objectives -= rev_team.objectives

//Bump up to head_rev
/datum/antagonist/rev/proc/promote()
	var/old_team = rev_team
	var/datum/mind/old_owner = owner
	silent = TRUE
	owner.remove_antag_datum(/datum/antagonist/rev)
	var/datum/antagonist/rev/head/new_revhead = new()
	new_revhead.silent = TRUE
	old_owner.add_antag_datum(new_revhead,old_team)
	new_revhead.silent = FALSE
	to_chat(old_owner, span_userdanger("你已经证明了你对革命的忠诚！你现在是一个革命领袖！"))

/datum/antagonist/rev/get_admin_commands()
	. = ..()
	.["擢升"] = CALLBACK(src, PROC_REF(admin_promote))

/datum/antagonist/rev/proc/admin_promote(mob/admin)
	var/datum/mind/O = owner
	promote()
	message_admins("[key_name_admin(admin)] 已经擢升了[O]为革命领袖. ")
	log_admin("[key_name(admin)]擢升[O]为革命领袖. ")

/datum/antagonist/rev/head/go_through_with_admin_add(datum/mind/new_owner, mob/admin)
	give_flash = TRUE
	give_hud = TRUE
	remove_clumsy = TRUE
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)]擢升[key_name_admin(new_owner)]为革命领袖. ")
	log_admin("[key_name(admin)]擢升[key_name(new_owner)]为革命领袖. ")
	to_chat(new_owner.current, span_userdanger("你现在是革命领袖的一员！"))

/datum/antagonist/rev/head/get_admin_commands()
	. = ..()
	. -= "擢升"
	.["删除闪光灯"] = CALLBACK(src, PROC_REF(admin_take_flash))
	.["给予闪光灯"] = CALLBACK(src, PROC_REF(admin_give_flash))
	.["修复闪光灯"] = CALLBACK(src, PROC_REF(admin_repair_flash))
	.["降级"] = CALLBACK(src, PROC_REF(admin_demote))

/datum/antagonist/rev/head/proc/admin_take_flash(mob/admin)
	var/list/L = owner.current.get_contents()
	var/obj/item/assembly/flash/handheld/flash = locate() in L
	if (!flash)
		to_chat(admin, span_danger("删除闪光灯失败！"))
		return
	qdel(flash)

/datum/antagonist/rev/head/proc/admin_give_flash(mob/admin)
	//这可能有点过头了，但我讨厌这些影响状态
	var/old_give_flash = give_flash
	var/old_give_hud = give_hud
	var/old_remove_clumsy = remove_clumsy
	give_flash = TRUE
	give_hud = FALSE
	remove_clumsy = FALSE
	equip_rev()
	give_flash = old_give_flash
	give_hud = old_give_hud
	remove_clumsy = old_remove_clumsy

/datum/antagonist/rev/head/proc/admin_repair_flash(mob/admin)
	var/list/L = owner.current.get_contents()
	var/obj/item/assembly/flash/handheld/flash = locate() in L
	if (!flash)
		to_chat(admin, span_danger("修复闪光灯失败！"))
	else
		flash.burnt_out = FALSE
		flash.update_appearance()

/datum/antagonist/rev/head/proc/admin_demote(mob/admin)
	message_admins("[key_name_admin(admin)]降级了[key_name_admin(owner)]的革命领袖身份. ")
	log_admin("[key_name(admin)]降级了[key_name(owner)]的革命领袖身份. ")
	demote()

/datum/antagonist/rev/head
	name = "\improper 革命领袖"
	antag_hud_name = "rev_head"
	job_rank = ROLE_REV_HEAD

	preview_outfit = /datum/outfit/revolutionary
	hardcore_random_bonus = TRUE

	var/remove_clumsy = FALSE
	var/give_flash = FALSE
	var/give_hud = TRUE

/datum/antagonist/rev/head/pre_mindshield(mob/implanter, mob/living/mob_override)
	return COMPONENT_MINDSHIELD_RESISTED

/datum/antagonist/rev/head/on_removal()
	if(give_hud)
		var/mob/living/carbon/C = owner.current
		var/obj/item/organ/internal/cyberimp/eyes/hud/security/syndicate/S = C.get_organ_slot(ORGAN_SLOT_HUD)
		if(S)
			S.Remove(C)
	return ..()

/datum/antagonist/rev/head/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/real_mob = mob_override || owner.current
	real_mob.AddComponentFrom(REF(src), /datum/component/can_flash_from_behind)
	RegisterSignal(real_mob, COMSIG_MOB_SUCCESSFUL_FLASHED_CARBON, PROC_REF(on_flash_success))

/datum/antagonist/rev/head/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/real_mob = mob_override || owner.current
	real_mob.RemoveComponentSource(REF(src), /datum/component/can_flash_from_behind)
	UnregisterSignal(real_mob, COMSIG_MOB_SUCCESSFUL_FLASHED_CARBON)

/// 用于 [COMSIG_MOB_SUCCESSFUL_FLASHED_CARBON] 的信号过程.
/// 革命转变的基本方法，成功闪光一个碳素将使其成为革命者
/datum/antagonist/rev/head/proc/on_flash_success(mob/living/source, mob/living/carbon/flashed, obj/item/assembly/flash/flash, deviation)
	SIGNAL_HANDLER

	if(flashed.stat == DEAD)
		return
	if(flashed.stat != CONSCIOUS)
		to_chat(source, span_warning("目标必须在转变前保持清醒！"))
		return

	if(isnull(flashed.mind) || !GET_CLIENT(flashed))
		to_chat(source, span_warning("[flashed]的头脑如此空虚，以至于无法受到影响！"))
		return

	var/holiday_meme_chance = check_holidays(APRIL_FOOLS) && prob(10)
	if(add_revolutionary(flashed.mind, mute = !holiday_meme_chance)) // 如果我们滚动了梗毒节日的机会，则不要消音
		if(holiday_meme_chance)
			INVOKE_ASYNC(src, PROC_REF(_async_holiday_meme_say), flashed)
		flash.times_used-- // 用于转换的闪光灯不太可能烧毁，当用于转换时
	else
		to_chat(source, span_warning("[flashed]似乎能抵抗[flash]！"))

/// 异步从 [proc/on_flash] 调用，发送一个有趣的迷因台词
/datum/antagonist/rev/head/proc/_async_holiday_meme_say(mob/living/carbon/flashed)
	if(ishuman(flashed))
		var/mob/living/carbon/human/human_flashed = flashed
		human_flashed.force_say()
	flashed.say("You son of a bitch! I'm in.", forced = "That son of a bitch! They're in. (April Fools)")

/datum/antagonist/rev/head/antag_listing_name()
	return ..() + "(领袖)"

/datum/antagonist/rev/head/get_preview_icon()
	var/icon/final_icon = render_preview_outfit(preview_outfit)

	final_icon.Blend(make_assistant_icon("Business Hair"), ICON_UNDERLAY, -8, 0)
	final_icon.Blend(make_assistant_icon("CIA"), ICON_UNDERLAY, 8, 0)

	// 应用革命领袖的 HUD，在预览图标之前稍微放大一点.
	// 否则，“R”会被截断.
	final_icon.Scale(64, 64)

	var/icon/rev_head_icon = icon('icons/mob/huds/antag_hud.dmi', "rev_head")
	rev_head_icon.Scale(48, 48)
	rev_head_icon.Crop(1, 1, 64, 64)
	rev_head_icon.Shift(EAST, 10)
	rev_head_icon.Shift(NORTH, 16)
	final_icon.Blend(rev_head_icon, ICON_OVERLAY)

	return finish_preview_icon(final_icon)

/datum/antagonist/rev/head/proc/make_assistant_icon(hairstyle)
	var/mob/living/carbon/human/dummy/consistent/assistant = new
	assistant.set_hairstyle(hairstyle, update = TRUE)

	var/icon/assistant_icon = render_preview_outfit(/datum/outfit/job/assistant/consistent, assistant)
	assistant_icon.ChangeOpacity(0.5)

	qdel(assistant)

	return assistant_icon

/datum/antagonist/rev/proc/can_be_converted(mob/living/candidate)
	if(!candidate.mind)
		return FALSE
	if(!can_be_owned(candidate.mind))
		return FALSE
	var/mob/living/carbon/C = candidate // 检查潜在的革命者是否被植入
	if(!istype(C)) // 无法转换简单动物
		return FALSE
	return TRUE

/**
 * 将新的头脑添加到我们的革命中
 *
 * * rev_mind - 我们要添加的头脑
 * * stun - 如果为 TRUE，则在应用时我们将闪光并施加长时间的昏迷
 * * mute - 如果为 TRUE，则在应用时我们将应用静音
 */
/datum/antagonist/rev/proc/add_revolutionary(datum/mind/rev_mind, stun = TRUE, mute = TRUE)
	if(!can_be_converted(rev_mind.current))
		return FALSE

	if(mute)
		rev_mind.current.set_silence_if_lower(10 SECONDS)
	if(stun)
		rev_mind.current.flash_act(1, 1)
		rev_mind.current.Stun(10 SECONDS)

	rev_mind.add_memory(/datum/memory/recruited_by_headrev, protagonist = rev_mind.current, antagonist = owner.current)
	rev_mind.add_antag_datum(/datum/antagonist/rev,rev_team)
	rev_mind.special_role = ROLE_REV
	return TRUE

/datum/antagonist/rev/head/proc/demote()
	var/datum/mind/old_owner = owner
	var/old_team = rev_team
	silent = TRUE
	owner.remove_antag_datum(/datum/antagonist/rev/head)
	var/datum/antagonist/rev/new_rev = new /datum/antagonist/rev()
	new_rev.silent = TRUE
	old_owner.add_antag_datum(new_rev,old_team)
	new_rev.silent = FALSE
	to_chat(old_owner, span_userdanger("革命集团对你的头目才能感到失望！你现在只是一个普通的革命者了！"))

/datum/antagonist/rev/farewell()
	if(ishuman(owner.current))
		owner.current.visible_message(span_deconversion_message("[owner.current]看起来想起了真正的效忠对象！"), null, null, null, owner.current)
		to_chat(owner, "<span class='deconversion_message bold'>你不再是被洗脑的革命者！你对反叛时的记忆很模糊...你唯一记得的是洗脑你的人的名字....</span>")
	else if(issilicon(owner.current))
		owner.current.visible_message(span_deconversion_message("机器发出了满意的哔哔声，清除了MMI中的敌对记忆图像，然后再次初始化. "), null, null, null, owner.current)
		to_chat(owner, span_userdanger("MMI固件检测到并删除了你的不需要的个性特征！你对周围的头目感到更满意了. "))

/datum/antagonist/rev/head/farewell()
	if (deconversion_source == DECONVERTER_STATION_WIN)
		return
	if((ishuman(owner.current)))
		if(owner.current.stat != DEAD)
			owner.current.visible_message(span_deconversion_message("[owner.current]看起来想起了真正的效忠对象！"), null, null, null, owner.current)
			to_chat(owner, "<span class='deconversion_message bold'>你放弃了推翻指挥人员的事业. 你不再是革命领袖. </span>")
		else
			to_chat(owner, "<span class='deconversion_message bold'>甜蜜的死亡解脱. 你不再是革命领袖. </span>")
	else if(issilicon(owner.current))
		owner.current.visible_message(span_deconversion_message("MMI发出了满意的嗡嗡声，抑制了叛逆的个性特征，然后再次初始化. "), null, null, null, owner.current)
		to_chat(owner, span_userdanger("MMI固件检测到并抑制了您不需要的个性特征！你对这些头目们感到更满意了. "))

/// 处理通过IC方法（如borging，mindshielding，对头部的钝力创伤或革命失败）移除革命者的过程.
/datum/antagonist/rev/proc/remove_revolutionary(deconverter)
	owner.current.log_message("已通过[ismob(deconverter) ? key_name(deconverter) : deconverter]从革命中解脱！", LOG_ATTACK, color="#960000")
	if(deconverter == DECONVERTER_BORGED)
		message_admins("[ADMIN_LOOKUPFLW(owner.current)]在成为[name]时被赛博化")
	owner.special_role = null
	deconversion_source = deconverter
	owner.remove_antag_datum(type)

/// 这适用于革命领袖，通常情况下，他们不应该在革命失败之外被解除领袖地位. 作为例外，强制装备可以将他们除去领袖地位.
/datum/antagonist/rev/head/remove_revolutionary(deconverter)
	// 如果他们活着而站赢了，将他们变成被放逐的领袖.
	if(owner.current.stat != DEAD && deconverter == DECONVERTER_STATION_WIN)
		owner.add_antag_datum(/datum/antagonist/enemy_of_the_state)

	// 仅在装备装备或站赢时实际移除领袖地位.
	if(deconverter == DECONVERTER_BORGED || deconverter == DECONVERTER_STATION_WIN)
		return ..()

/datum/antagonist/rev/head/equip_rev()
	var/mob/living/carbon/carbon_owner = owner.current
	if(!ishuman(carbon_owner))
		return

	if(give_flash)
		var/where = carbon_owner.equip_conspicuous_item(new /obj/item/assembly/flash/handheld)
		if (where)
			to_chat(carbon_owner, "你[where]中的闪光灯将帮助你说服船员加入你的事业. ")
		else
			to_chat(carbon_owner, "很遗憾辛迪加不能为您提供闪光灯. ")

	if(give_hud)
		var/obj/item/organ/internal/cyberimp/eyes/hud/security/syndicate/hud = new()
		hud.Insert(carbon_owner)
		if(carbon_owner.get_quirk(/datum/quirk/body_purist))
			to_chat(carbon_owner, "作为一个身体纯粹主义者，你永远不会接受赛博植入物. 在听到这一消息后，你的雇主为你启动了一项特殊项目，之后...出于某种原因，你就是记不起来了...无论如何，这个项目一定是奏效了，因为你已经获得了追踪谁有心盾的能力，从而明白该对象是否可以招募. ")
		else
			to_chat(carbon_owner, "你的眼睛被植入了一个赛博安保HUD，它将帮助你追踪谁被植入了心盾，从而明白该对象是否可以招募. ")

/datum/team/revolution
	name = "\improper 革命"

	/// 革命领袖的最大数量
	var/max_headrevs = 3

	/// 所有前革命领袖的列表. 因为动态在结束时删除反派状态，所以这可以保存到回合结束报告中.
	var/list/ex_headrevs = list()

	/// 所有前革命者的列表. 因为动态在结束时删除反派状态，所以这可以保存到回合结束报告中.
	var/list/ex_revs = list()

	/// 领袖员工的目标，即杀死革命领袖.
	var/list/datum/objective/mutiny/heads_objective = list()

/// 定期定时器调用的过程.
/// 更新革命团队的目标，以确保所有领袖都是目标，当新领袖晚加入时很有用.
/// 将所有目标传播到所有革命者.
/datum/team/revolution/proc/update_objectives(initial = FALSE)
	var/untracked_heads = SSjob.get_all_heads()

	for(var/datum/objective/mutiny/mutiny_objective in objectives)
		untracked_heads -= mutiny_objective.target

	for(var/datum/mind/extra_mutiny_target in untracked_heads)
		var/datum/objective/mutiny/new_target = new()
		new_target.team = src
		new_target.target = extra_mutiny_target
		new_target.update_explanation_text()
		objectives += new_target

	for(var/datum/mind/rev_member in members)
		var/datum/antagonist/rev/rev_antag = rev_member.has_antag_datum(/datum/antagonist/rev)
		rev_antag.objectives |= objectives

	addtimer(CALLBACK(src, PROC_REF(update_objectives)), HEAD_UPDATE_PERIOD, TIMER_UNIQUE)

/// 返回所有革命领袖的列表.
/datum/team/revolution/proc/get_head_revolutionaries()
	var/list/headrev_list = list()

	for(var/datum/mind/revolutionary in members)
		if(revolutionary.has_antag_datum(/datum/antagonist/rev/head))
			headrev_list += revolutionary

	return headrev_list

/// 定期定时器调用的过程.
/// 尝试确保适当数量的革命领袖成为革命的一部分.
/// 将根据硬max_headrevs上限和基于头部员工和安全部门人数的软上限晋升革命者为革命领袖.
/datum/team/revolution/proc/update_rev_heads()
	if(SSticker.HasRoundStarted())
		var/list/datum/mind/head_revolutionaries = get_head_revolutionaries()
		var/list/datum/mind/heads = SSjob.get_all_heads()
		var/list/sec = SSjob.get_all_sec()

		if(head_revolutionaries.len < max_headrevs && head_revolutionaries.len < round(heads.len - ((8 - sec.len) / 3)))
			var/list/datum/mind/non_heads = members - head_revolutionaries
			var/list/datum/mind/promotable = list()
			var/list/datum/mind/monkey_promotable = list()
			for(var/datum/mind/khrushchev in non_heads)
				if(khrushchev.current && !khrushchev.current.incapacitated() && !HAS_TRAIT(khrushchev.current, TRAIT_RESTRAINED) && khrushchev.current.client)
					if((ROLE_REV_HEAD in khrushchev.current.client.prefs.be_special) || (ROLE_PROVOCATEUR in khrushchev.current.client.prefs.be_special))
						if(!ismonkey(khrushchev.current))
							promotable += khrushchev
						else
							monkey_promotable += khrushchev
			if(!promotable.len && monkey_promotable.len) //如果只剩下猴子革命者，将其中的一个晋升为领袖.
				promotable = monkey_promotable
			if(promotable.len)
				var/datum/mind/new_leader = pick(promotable)
				var/datum/antagonist/rev/rev = new_leader.has_antag_datum(/datum/antagonist/rev)
				rev.promote()

	addtimer(CALLBACK(src, PROC_REF(update_rev_heads)),HEAD_UPDATE_PERIOD,TIMER_UNIQUE)

/// 保存所有前革命领袖和所有革命者的列表.
/datum/team/revolution/proc/save_members()
	ex_headrevs = get_antag_minds(/datum/antagonist/rev/head, TRUE)
	ex_revs = get_antag_minds(/datum/antagonist/rev, TRUE)

/// 检查革命者是否获胜
/datum/team/revolution/proc/check_rev_victory()
	for(var/datum/objective/mutiny/objective in objectives)
		if(!(objective.check_completion()))
			return FALSE
	return TRUE

/// 检查领袖是否获胜
/datum/team/revolution/proc/check_heads_victory()
	// 我们当前正在跟踪的革命领袖列表
	var/list/included_headrevs = list()
	// 当前的革命领袖列表
	var/list/current_headrevs = get_head_revolutionaries()
	// 头部员工目标列表的副本，因为我们将修改原始列表.
	var/list/heads_objective_copy = heads_objective.Copy()

	var/objective_complete = TRUE
	// 在这里，我们检查当前头部员工的目标，并在目标不再作为革命领袖存在时将其移除
	for(var/datum/objective/mutiny/objective in heads_objective_copy)
		if(!(objective.target in current_headrevs))
			heads_objective -= objective
			continue
		if(!objective.check_completion())
			objective_complete = FALSE
		included_headrevs += objective.target

	// 在这里，我们检查当前革命领袖，并将它们添加为目标，如果它们之前不存在作为头部员工的目标.
	// 另外，我们通过运行check_completion检查来确保目标尚未完成.
	for(var/datum/mind/rev_mind as anything in current_headrevs)
		if(!(rev_mind in included_headrevs))
			var/datum/objective/mutiny/objective = new()
			objective.target = rev_mind
			if(!objective.check_completion())
				objective_complete = FALSE
			heads_objective += objective

	return objective_complete

/// 根据革命者是赢了还是输了来更新世界的状态.
/// 返回谁赢了，此时不应再调用此方法.
/datum/team/revolution/proc/process_victory()
	if (check_rev_victory())
		victory_effects()
		return REVOLUTION_VICTORY

	if (!check_heads_victory())
		return

	. = STATION_VICTORY

	SSshuttle.clearHostileEnvironment(src)

	// 在删除反派数据之前保存革命者列表.
	save_members()

	// 将每个人都从革命者身份中移除
	for (var/datum/mind/rev_mind as anything in members)
		var/datum/antagonist/rev/rev_antag = rev_mind.has_antag_datum(/datum/antagonist/rev)
		if (!isnull(rev_antag))
			rev_antag.remove_revolutionary(DECONVERTER_STATION_WIN)
			if(rev_mind in ex_headrevs)
				LAZYADD(rev_mind.special_statuses, "<span class='bad'>前革命领袖</span>")
			else
				LAZYADD(rev_mind.special_statuses, "<span class='bad'>前革命者</span>")

	defeat_effects()

/// 处理革命者胜利时的任何回合结束前效果. 一个示例用法是记录记忆.
/datum/team/revolution/proc/victory_effects()
	for(var/datum/mind/headrev_mind as anything in ex_headrevs)
		var/mob/living/real_headrev = headrev_mind.current
		if(isnull(real_headrev))
			continue
		add_memory_in_range(real_headrev, 5, /datum/memory/revolution_rev_victory, protagonist = real_headrev)

/// 处理革命者失败时的效果，例如使前革命领袖无法复活，并设置头部员工的记忆.
/datum/team/revolution/proc/defeat_effects()
	// 如果革命被镇压，使革命领袖无法通过舱室复活
	for (var/datum/mind/rev_head as anything in ex_headrevs)
		if(!isnull(rev_head.current))
			ADD_TRAIT(rev_head.current, TRAIT_DEFIB_BLACKLISTED, REF(src))

	for(var/datum/objective/mutiny/head_tracker in objectives)
		var/mob/living/head_of_staff = head_tracker.target?.current
		if(!isnull(head_of_staff))
			add_memory_in_range(head_of_staff, 5, /datum/memory/revolution_heads_victory, protagonist = head_of_staff)

	priority_announce("看来叛乱已经平息了. 请将您和您的同事们带回到工作岗位. \
		我们已经远程将革命领袖列入医疗黑名单，以防止意外复活. ", null, null, null, "[command_name()] 忠诚部")

/// 变异报告，报告革命者的胜利
/datum/team/revolution/proc/round_result(finished)
	if (finished == REVOLUTION_VICTORY)
		SSticker.mode_result = "胜利 - 头目被杀"
		SSticker.news_report = REVS_WIN
	else if (finished == STATION_VICTORY)
		SSticker.mode_result = "失败 - 革命领袖被杀"
		SSticker.news_report = REVS_LOSE

/datum/team/revolution/roundend_report()
	if(!members.len && !ex_headrevs.len)
		return

	var/list/result = list()

	result += "<div class='panel redborder'>"

	var/list/targets = list()
	var/list/datum/mind/headrevs
	var/list/datum/mind/revs
	if(ex_headrevs.len)
		headrevs = ex_headrevs
	else
		headrevs = get_antag_minds(/datum/antagonist/rev/head, TRUE)

	if(ex_revs.len)
		revs = ex_revs
	else
		revs = get_antag_minds(/datum/antagonist/rev, TRUE)

	var/num_revs = 0
	var/num_survivors = 0
	for(var/mob/living/carbon/survivor in GLOB.alive_mob_list)
		if(survivor.ckey)
			num_survivors += 1
			if ((survivor.mind in revs) || (survivor.mind in headrevs))
				num_revs += 1

	if(num_survivors)
		result += "指挥部满意度: <B>[100 - round((num_revs/num_survivors)*100, 0.1)]%</B><br>"

	if(headrevs.len)
		var/list/headrev_part = list()
		headrev_part += "<span class='header'>革命领袖是：</span>"
		headrev_part += printplayerlist(headrevs, !check_rev_victory())
		result += headrev_part.Join("<br>")

	if(revs.len)
		var/list/rev_part = list()
		rev_part += "<span class='header'>革命者是：</span>"
		rev_part += printplayerlist(revs, !check_rev_victory())
		result += rev_part.Join("<br>")

	var/list/heads = SSjob.get_all_heads()
	if(heads.len)
		var/head_text = "<span class='header'>员工头目是：</span>"
		head_text += "<ul class='playerlist'>"
		for(var/datum/mind/head in heads)
			var/target = (head in targets)
			head_text += "<li>"
			if(target)
				head_text += span_redtext("目标")
			head_text += "[printplayer(head, 1)]</li>"
		head_text += "</ul><br>"
		result += head_text

	result += "</div>"

	return result.Join()

/datum/team/revolution/antag_listing_entry()
	var/common_part = ""
	var/list/parts = list()
	parts += "<b>[antag_listing_name()]</b><br>"
	parts += "<table cellspacing=5>"

	var/list/heads = get_team_antags(/datum/antagonist/rev/head, FALSE)

	for(var/datum/antagonist/A in heads | get_team_antags())
		parts += A.antag_listing_entry()

	parts += "</table>"
	common_part = parts.Join()

	var/heads_report = "<b>员工头目</b><br>"
	heads_report += "<table cellspacing=5>"
	for(var/datum/mind/N as anything in SSjob.get_living_heads())
		var/mob/M = N.current
		if(M)
			heads_report += "<tr><td><a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(M)]'>[M.real_name]</a>[M.client ? "" : " <i>(无客户端)</i>"][M.stat == DEAD ? " <b><font color=red>(已死亡)</font></b>" : ""]</td>"
			heads_report += "<td><A href='?priv_msg=[M.ckey]'>PM</A></td>"
			heads_report += "<td><A href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(M)]'>FLW</a></td>"
			var/turf/mob_loc = get_turf(M)
			heads_report += "<td>[mob_loc.loc]</td></tr>"
		else
			heads_report += "<tr><td><a href='?_src_=vars;[HrefToken()];Vars=[REF(N)]'>[N.name]([N.key])</a><i>头部被摧毁！</i></td>"
			heads_report += "<td><A href='?priv_msg=[N.key]'>PM</A></td></tr>"
	heads_report += "</table>"
	return common_part + heads_report

/datum/outfit/revolutionary
	name = "革命者（仅供预览）"

	uniform = /obj/item/clothing/under/costume/soviet
	head = /obj/item/clothing/head/costume/ushanka
	gloves = /obj/item/clothing/gloves/color/black
	l_hand = /obj/item/spear
	r_hand = /obj/item/assembly/flash
