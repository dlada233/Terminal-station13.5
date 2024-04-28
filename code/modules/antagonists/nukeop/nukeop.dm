/datum/antagonist/nukeop
	name = ROLE_NUCLEAR_OPERATIVE
	roundend_category = "辛迪加行动人员" //just in case
	antagpanel_category = ANTAG_GROUP_SYNDICATE
	job_rank = ROLE_OPERATIVE
	antag_hud_name = "synd"
	antag_moodlet = /datum/mood_event/focused
	show_to_ghosts = TRUE
	hijack_speed = 2 //If you can't take out the station, take the shuttle instead.
	suicide_cry = "辛迪加万岁!!"
	/// Which nukie team are we on?
	var/datum/team/nuclear/nuke_team
	/// If not assigned a team by default ops will try to join existing ones, set this to TRUE to always create new team.
	var/always_new_team = FALSE
	/// Should the user be moved to default spawnpoint after being granted this datum.
	var/send_to_spawnpoint = TRUE
	/// The DEFAULT outfit we will give to players granted this datum
	var/nukeop_outfit = /datum/outfit/syndicate

	preview_outfit = /datum/outfit/nuclear_operative_elite

	/// In the preview icon, the nukies who are behind the leader
	var/preview_outfit_behind = /datum/outfit/nuclear_operative
	/// In the preview icon, a nuclear fission explosive device, only appearing if there's an icon state for it.
	var/nuke_icon_state = "nuclearbomb_base"

	/// The amount of discounts that the team get
	var/discount_team_amount = 5
	/// The amount of limited discounts that the team get
	var/discount_limited_amount = 10

/datum/antagonist/nukeop/New()
	if(send_to_spawnpoint) // lets get the loading started now, but don't block waiting for it
		INVOKE_ASYNC(SSmapping, TYPE_PROC_REF(/datum/controller/subsystem/mapping, lazy_load_template), LAZY_TEMPLATE_KEY_NUKIEBASE)
	return ..()

/datum/antagonist/nukeop/proc/equip_op()
	if(!ishuman(owner.current))
		return

	var/mob/living/carbon/human/operative = owner.current
	ADD_TRAIT(operative, TRAIT_NOFEAR_HOLDUPS, INNATE_TRAIT)

	if(!nukeop_outfit) // this variable is null in instances where an antagonist datum is granted via enslaving the mind (/datum/mind/proc/enslave_mind_to_creator), like in golems.
		return

	// If our nuke_ops_species pref is set to TRUE, (or we have no client) make us a human
	if(isnull(operative.client) || operative.client.prefs.read_preference(/datum/preference/toggle/nuke_ops_species))
		operative.set_species(/datum/species/human)

	operative.equip_species_outfit(nukeop_outfit)

	return TRUE

/datum/antagonist/nukeop/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ops.ogg',100,0, use_reverb = FALSE)
	to_chat(owner, span_big("你是一名[nuke_team ? nuke_team.syndicate_name : "辛迪加"]特工!"))
	owner.announce_objectives()

/datum/antagonist/nukeop/on_gain()
	give_alias()
	forge_objectives()
	. = ..()
	equip_op()
	if(send_to_spawnpoint)
		move_to_spawnpoint()
		// grant extra TC for the people who start in the nukie base ie. not the lone op
		var/extra_tc = CEILING(GLOB.joined_player_list.len/5, 5)
		var/datum/component/uplink/uplink = owner.find_syndicate_uplink()
		if (uplink)
			uplink.add_telecrystals(extra_tc)

	var/datum/component/uplink/uplink = owner.find_syndicate_uplink()
	if(uplink)
		var/datum/team/nuclear/nuke_team = get_team()
		if(!nuke_team.team_discounts)
			var/list/uplink_items = list()
			for(var/datum/uplink_item/item as anything in SStraitor.uplink_items)
				if(item.item && !item.cant_discount && (item.purchasable_from & uplink.uplink_handler.uplink_flag) && item.cost > 1)
					uplink_items += item
			nuke_team.team_discounts = list()
			nuke_team.team_discounts += create_uplink_sales(discount_team_amount, /datum/uplink_category/discount_team_gear, -1, uplink_items)
			nuke_team.team_discounts += create_uplink_sales(discount_limited_amount, /datum/uplink_category/limited_discount_team_gear, 1, uplink_items)
		uplink.uplink_handler.extra_purchasable += nuke_team.team_discounts

	memorize_code()

/datum/antagonist/nukeop/get_team()
	return nuke_team

/datum/antagonist/nukeop/apply_innate_effects(mob/living/mob_override)
	add_team_hud(mob_override || owner.current, /datum/antagonist/nukeop)

/datum/antagonist/nukeop/proc/assign_nuke()
	if(nuke_team && !nuke_team.tracked_nuke)
		nuke_team.memorized_code = random_nukecode()
		var/obj/machinery/nuclearbomb/syndicate/nuke = locate() in SSmachines.get_machines_by_type(/obj/machinery/nuclearbomb/syndicate)
		if(nuke)
			nuke_team.tracked_nuke = nuke
			if(nuke.r_code == NUKE_CODE_UNSET)
				nuke.r_code = nuke_team.memorized_code
			else //Already set by admins/something else?
				nuke_team.memorized_code = nuke.r_code
			for(var/obj/machinery/nuclearbomb/beer/beernuke as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/nuclearbomb/beer))
				beernuke.r_code = nuke_team.memorized_code
		else
			stack_trace("Syndicate nuke not found during nuke team creation.")
			nuke_team.memorized_code = null

/datum/antagonist/nukeop/proc/give_alias()
	if(nuke_team?.syndicate_name)
		var/mob/living/carbon/human/human_to_rename = owner.current
		if(istype(human_to_rename)) // Reinforcements get a real name
			var/first_name = owner.current.client?.prefs?.read_preference(/datum/preference/name/operative_alias) || pick(GLOB.operative_aliases)
			var/chosen_name = "[first_name] [nuke_team.syndicate_name]"
			human_to_rename.fully_replace_character_name(human_to_rename.real_name, chosen_name)
		else
			var/number = 1
			number = nuke_team.members.Find(owner)
			owner.current.real_name = "[nuke_team.syndicate_name] 特工 #[number]"

/datum/antagonist/nukeop/proc/memorize_code()
	if(nuke_team && nuke_team.tracked_nuke && nuke_team.memorized_code)
		antag_memory += "<B>[nuke_team.tracked_nuke] 代码</B>: [nuke_team.memorized_code]<br>"
		owner.add_memory(/datum/memory/key/nuke_code, nuclear_code = nuke_team.memorized_code)
		to_chat(owner, "核武授权代码: <B>[nuke_team.memorized_code]</B>")
	else
		to_chat(owner, "不幸的是，集团无法向您提供核武授权代码.")

/datum/antagonist/nukeop/forge_objectives()
	if(nuke_team)
		objectives |= nuke_team.objectives

/// Actually moves our nukie to where they should be
/datum/antagonist/nukeop/proc/move_to_spawnpoint()
	// Ensure that the nukiebase is loaded, and wait for it if required
	SSmapping.lazy_load_template(LAZY_TEMPLATE_KEY_NUKIEBASE)
	var/turf/destination = get_spawnpoint()
	owner.current.forceMove(destination)
	if(!owner.current.onSyndieBase())
		message_admins("[ADMIN_LOOKUPFLW(owner.current)]是核队特工，但move_to_spawnpoint没有被放在辛迪加基地内，请提供帮助.")
		stack_trace("Nuke op move_to_spawnpoint resulted in a location not on the syndicate base. (Was moved to: [destination])")

/// Gets the position we spawn at
/datum/antagonist/nukeop/proc/get_spawnpoint()
	var/team_number = 1
	if(nuke_team)
		team_number = nuke_team.members.Find(owner)

	return GLOB.nukeop_start[((team_number - 1) % GLOB.nukeop_start.len) + 1]

/datum/antagonist/nukeop/leader/get_spawnpoint()
	return pick(GLOB.nukeop_leader_start)

/datum/antagonist/nukeop/create_team(datum/team/nuclear/new_team)
	if(!new_team)
		if(!always_new_team)
			for(var/datum/antagonist/nukeop/N in GLOB.antagonists)
				if(!N.owner)
					stack_trace("Antagonist datum without owner in GLOB.antagonists: [N]")
					continue
				if(N.nuke_team)
					nuke_team = N.nuke_team
					return
		nuke_team = new /datum/team/nuclear
		nuke_team.update_objectives()
		assign_nuke() //This is bit ugly
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	nuke_team = new_team

/datum/antagonist/nukeop/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.set_assigned_role(SSjob.GetJobType(/datum/job/nuclear_operative))
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)]使[key_name_admin(new_owner)]成为核队特工.")
	log_admin("[key_name(admin)]使[key_name(new_owner)]成为核队特工.")

/datum/antagonist/nukeop/get_admin_commands()
	. = ..()
	.["送至基地"] = CALLBACK(src, PROC_REF(admin_send_to_base))
	.["授予代码"] = CALLBACK(src, PROC_REF(admin_tell_code))

/datum/antagonist/nukeop/proc/admin_send_to_base(mob/admin)
	owner.current.forceMove(pick(GLOB.nukeop_start))

/datum/antagonist/nukeop/proc/admin_tell_code(mob/admin)
	var/code
	for (var/obj/machinery/nuclearbomb/bombue as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/nuclearbomb))
		if (length(bombue.r_code) <= 5 && bombue.r_code != initial(bombue.r_code))
			code = bombue.r_code
			break
	if (code)
		antag_memory += "<B>辛迪加核弹密码</B>: [code]<br>"
		to_chat(owner.current, "核武授权代码: <B>[code]</B>")
	else
		to_chat(admin, span_danger("无可用核武!"))

/datum/antagonist/nukeop/get_preview_icon()
	if (!preview_outfit)
		return null

	var/icon/final_icon = render_preview_outfit(preview_outfit)

	if (!isnull(preview_outfit_behind))
		var/icon/teammate = render_preview_outfit(preview_outfit_behind)
		teammate.Blend(rgb(128, 128, 128, 128), ICON_MULTIPLY)

		final_icon.Blend(teammate, ICON_UNDERLAY, -world.icon_size / 4, 0)
		final_icon.Blend(teammate, ICON_UNDERLAY, world.icon_size / 4, 0)

	if (!isnull(nuke_icon_state))
		var/icon/nuke = icon('icons/obj/machines/nuke.dmi', nuke_icon_state)
		nuke.Shift(SOUTH, 6)
		final_icon.Blend(nuke, ICON_OVERLAY)

	return finish_preview_icon(final_icon)

/datum/outfit/nuclear_operative
	name = "核特工 (仅浏览)"

	back = /obj/item/mod/control/pre_equipped/empty/syndicate
	uniform = /obj/item/clothing/under/syndicate

/datum/outfit/nuclear_operative/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/mod/module/armor_booster/booster = locate() in H.back
	booster.active = TRUE
	H.update_worn_back()

/datum/outfit/nuclear_operative_elite
	name = "核特工 (精英，仅浏览)"

	back = /obj/item/mod/control/pre_equipped/empty/elite
	uniform = /obj/item/clothing/under/syndicate
	l_hand = /obj/item/modular_computer/pda/nukeops
	r_hand = /obj/item/shield/energy

/datum/outfit/nuclear_operative_elite/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/mod/module/armor_booster/booster = locate() in H.back
	booster.active = TRUE
	H.update_worn_back()
	var/obj/item/shield/energy/shield = locate() in H.held_items
	shield.icon_state = "[shield.base_icon_state]1"
	H.update_held_items()

/datum/antagonist/nukeop/leader
	name = "核特工队长"
	nukeop_outfit = /datum/outfit/syndicate/leader
	always_new_team = TRUE
	/// Randomly chosen honorific, for distinction
	var/title
	/// The nuclear challenge remote we will spawn this player with.
	var/challengeitem = /obj/item/nuclear_challenge

/datum/antagonist/nukeop/leader/memorize_code()
	..()
	if(nuke_team?.memorized_code)
		var/obj/item/paper/nuke_code_paper = new
		nuke_code_paper.add_raw_text("核武授权代码: <b>[nuke_team.memorized_code]</b>")
		nuke_code_paper.name = "核弹密码"
		var/mob/living/carbon/human/H = owner.current
		if(!istype(H))
			nuke_code_paper.forceMove(get_turf(H))
		else
			H.put_in_hands(nuke_code_paper, TRUE)
			H.update_icons()

/datum/antagonist/nukeop/leader/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ops.ogg',100,0, use_reverb = FALSE)
	to_chat(owner, "<span class='warningplain'><B>你是这次任务的辛迪加[title]. 你负责指挥团队，只有你的ID卡可以打开发射舱门.</B></span>")
	to_chat(owner, "<span class='warningplain'><B>如果你觉得自己无法胜任，那么请将ID卡和无线电交予另一名特工.</B></span>")
	if(!CONFIG_GET(flag/disable_warops))
		to_chat(owner, "<span class='warningplain'><B>你的手中有一件特殊物品，能让你们进行更难的挑战，在启动请仔细检查并询问同僚意见.</B></span>")
	owner.announce_objectives()

/datum/antagonist/nukeop/leader/on_gain()
	. = ..()
	if(!CONFIG_GET(flag/disable_warops))
		var/mob/living/carbon/human/leader = owner.current
		var/obj/item/war_declaration = new challengeitem(leader.drop_location())
		leader.put_in_hands(war_declaration)
		nuke_team.war_button_ref = WEAKREF(war_declaration)
	addtimer(CALLBACK(src, PROC_REF(nuketeam_name_assign)), 1)

/datum/antagonist/nukeop/leader/proc/nuketeam_name_assign()
	if(!nuke_team)
		return
	nuke_team.rename_team(ask_name())

/datum/team/nuclear/proc/rename_team(new_name)
	syndicate_name = new_name
	name = "[syndicate_name]队伍"
	for(var/I in members)
		var/datum/mind/synd_mind = I
		var/mob/living/carbon/human/human_to_rename = synd_mind.current
		if(!istype(human_to_rename))
			continue
		var/first_name = human_to_rename.client?.prefs?.read_preference(/datum/preference/name/operative_alias) || pick(GLOB.operative_aliases)
		var/chosen_name = "[first_name] [syndicate_name]"
		human_to_rename.fully_replace_character_name(human_to_rename.real_name, chosen_name)

/datum/antagonist/nukeop/leader/proc/ask_name()
	var/randomname = pick(GLOB.last_names)
	var/newname = tgui_input_text(owner.current, "你是核特工[title]. 请为你的家族选择一个姓氏.", "改名", randomname, MAX_NAME_LEN)
	if (!newname)
		newname = randomname
	else
		newname = reject_bad_name(newname)
		if(!newname)
			newname = randomname

	return capitalize(newname)

/datum/antagonist/nukeop/lone
	name = "独狼核特工"
	always_new_team = TRUE
	send_to_spawnpoint = FALSE //Handled by event
	nukeop_outfit = /datum/outfit/syndicate/full
	preview_outfit = /datum/outfit/nuclear_operative
	preview_outfit_behind = null
	nuke_icon_state = null

/datum/antagonist/nukeop/lone/assign_nuke()
	if(nuke_team && !nuke_team.tracked_nuke)
		nuke_team.memorized_code = random_nukecode()
		var/obj/machinery/nuclearbomb/selfdestruct/nuke = locate() in SSmachines.get_machines_by_type(/obj/machinery/nuclearbomb/selfdestruct)
		if(nuke)
			nuke_team.tracked_nuke = nuke
			if(nuke.r_code == NUKE_CODE_UNSET)
				nuke.r_code = nuke_team.memorized_code
			else //Already set by admins/something else?
				nuke_team.memorized_code = nuke.r_code
		else
			stack_trace("Station self-destruct not found during lone op team creation.")
			nuke_team.memorized_code = null

/datum/antagonist/nukeop/reinforcement
	show_in_antagpanel = FALSE
	send_to_spawnpoint = FALSE
	nukeop_outfit = /datum/outfit/syndicate/reinforcement

/datum/team/nuclear
	var/syndicate_name
	var/obj/machinery/nuclearbomb/tracked_nuke
	var/core_objective = /datum/objective/nuclear
	var/memorized_code
	var/list/team_discounts
	var/datum/weakref/war_button_ref

/datum/team/nuclear/New()
	..()
	syndicate_name = syndicate_name()

/datum/team/nuclear/proc/update_objectives()
	if(core_objective)
		var/datum/objective/O = new core_objective
		O.team = src
		objectives += O

/datum/team/nuclear/proc/is_disk_rescued()
	for(var/obj/item/disk/nuclear/nuke_disk in SSpoints_of_interest.real_nuclear_disks)
		//If emergency shuttle is in transit disk is only safe on it
		if(SSshuttle.emergency.mode == SHUTTLE_ESCAPE)
			if(!SSshuttle.emergency.is_in_shuttle_bounds(nuke_disk))
				return FALSE
		//If shuttle escaped check if it's on centcom side
		else if(SSshuttle.emergency.mode == SHUTTLE_ENDGAME)
			if(!nuke_disk.onCentCom())
				return FALSE
		else //Otherwise disk is safe when on station
			var/turf/disk_turf = get_turf(nuke_disk)
			if(!disk_turf || !is_station_level(disk_turf.z))
				return FALSE
	return TRUE

/datum/team/nuclear/proc/are_all_operatives_dead()
	for(var/datum/mind/operative_mind as anything in members)
		if(ishuman(operative_mind.current) && (operative_mind.current.stat != DEAD))
			return FALSE
	return TRUE

/datum/team/nuclear/proc/get_result()
	var/shuttle_evacuated = EMERGENCY_ESCAPED_OR_ENDGAMED
	var/shuttle_landed_base = SSshuttle.emergency.is_hijacked()
	var/disk_rescued = is_disk_rescued()
	var/syndies_didnt_escape = !is_infiltrator_docked_at_syndiebase()
	var/team_is_dead = are_all_operatives_dead()
	var/station_was_nuked = GLOB.station_was_nuked
	var/station_nuke_source = GLOB.station_nuke_source

	// The nuke detonated on the syndicate base
	if(station_nuke_source == DETONATION_HIT_SYNDIE_BASE)
		return NUKE_RESULT_FLUKE

	// The station was nuked
	if(station_was_nuked)
		// The station was nuked and the infiltrator failed to escape
		if(syndies_didnt_escape)
			return NUKE_RESULT_NOSURVIVORS
		// The station was nuked and the infiltrator escaped, and the nuke ops won
		else
			return NUKE_RESULT_NUKE_WIN

	// The station was not nuked, but something was
	else if(station_nuke_source && !disk_rescued)
		// The station was not nuked, but something was, and the syndicates didn't escape it
		if(syndies_didnt_escape)
			return NUKE_RESULT_WRONG_STATION_DEAD
		// The station was not nuked, but something was, and the syndicates returned to their base
		else
			return NUKE_RESULT_WRONG_STATION

	// Nuke didn't blow, but nukies somehow hijacked the emergency shuttle to land at the base anyways.
	else if(shuttle_landed_base)
		if(disk_rescued)
			return NUKE_RESULT_HIJACK_DISK
		else
			return NUKE_RESULT_HIJACK_NO_DISK

	// No nuke went off, the station rescued the disk
	else if(disk_rescued)
		// No nuke went off, the shuttle left, and the team is dead
		if(shuttle_evacuated && team_is_dead)
			return NUKE_RESULT_CREW_WIN_SYNDIES_DEAD
		// No nuke went off, but the nuke ops survived
		else
			return NUKE_RESULT_CREW_WIN

	// No nuke went off, but the disk was left behind
	else
		// No nuke went off, the disk was left, but all the ops are dead
		if(team_is_dead)
			return NUKE_RESULT_DISK_LOST
		// No nuke went off, the disk was left, there are living ops, but the shuttle left successfully
		else if(shuttle_evacuated)
			return NUKE_RESULT_DISK_STOLEN

	CRASH("[type] - got an undefined / unexpected result.")

/datum/team/nuclear/roundend_report()
	var/list/parts = list()
	parts += "<span class='header'>[syndicate_name]特工:</span>"

	switch(get_result())
		if(NUKE_RESULT_FLUKE)
			parts += "<span class='redtext big'>辛迪加耻辱大败</span>"
			parts += "<B>[station_name()]的船员把炸弹扔回给了[syndicate_name]特工! 辛迪加基地被摧毁了!</B> 下次看好核弹吧!"
		if(NUKE_RESULT_NUKE_WIN)
			parts += "<span class='greentext big'>辛迪加大胜利!</span>"
			parts += "<B>[syndicate_name]特工摧毁了[station_name()]!</B>"
		if(NUKE_RESULT_NOSURVIVORS)
			parts += "<span class='neutraltext big'>同归于尽!</span>"
			parts += "<B>[syndicate_name]特工摧毁了[station_name()]，但未能及时撤离.</B> 下次看好磁盘吧!"
		if(NUKE_RESULT_WRONG_STATION)
			parts += "<span class='redtext big'>船员大胜利!</span>"
			parts += "<B>[syndicate_name]特工搞到了核磁盘但却没炸到[station_name()].</B> 下次注意吧!"
		if(NUKE_RESULT_WRONG_STATION_DEAD)
			parts += "<span class='redtext big'>[syndicate_name]特工得到的达尔文奖!</span>"
			parts += "<B>[syndicate_name]特工炸飞了自己却没炸到[station_name()].</B> 下次注意吧!"
		if(NUKE_RESULT_HIJACK_DISK)
			parts += "<span class='greentext big'>辛迪加小胜利!</span>"
			parts += "<B>[syndicate_name]特工未能摧毁[station_name()]，但他们设法获取了核磁盘并劫持了撤离船，使其降落在辛迪加基地. 干得好?</B>"
		if(NUKE_RESULT_HIJACK_NO_DISK)
			parts += "<span class='greentext big'>辛迪加迷你胜利!</span>"
			parts += "<B>[syndicate_name]特工未能摧毁[station_name()]或获取核磁盘，但他们劫持了撤离船，使其降落在辛迪加基地. 干得好?</B>"
		if(NUKE_RESULT_CREW_WIN_SYNDIES_DEAD)
			parts += "<span class='redtext big'>船员大胜利!</span>"
			parts += "<B>研究人员保住了核磁盘并杀死了[syndicate_name]特工</B>"
		if(NUKE_RESULT_CREW_WIN)
			parts += "<span class='redtext big'>船员大胜利!</span>"
			parts += "<B>研究人员保住了核磁盘并拦住了[syndicate_name]特工!</B>"
		if(NUKE_RESULT_DISK_LOST)
			parts += "<span class='neutraltext big'>平局!</span>"
			parts += "<B>研究人员未能保住磁盘但杀死了大多数的[syndicate_name]特工!</B>"
		if(NUKE_RESULT_DISK_STOLEN)
			parts += "<span class='greentext big'>辛迪加小胜!</span>"
			parts += "<B>[syndicate_name]在活着完成了袭击，但未能摧毁[station_name()].</B> 下次看好磁盘吧!"
		else
			parts += "<span class='neutraltext big'>平局</span>"
			parts += "<B>任务中止!</B>"

	var/text = "<br><span class='header'>辛迪加特工名单:</span>"
	var/purchases = ""
	var/TC_uses = 0
	LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
	for(var/I in members)
		var/datum/mind/syndicate = I
		var/datum/uplink_purchase_log/H = GLOB.uplink_purchase_logs_by_key[syndicate.key]
		if(H)
			TC_uses += H.total_spent
			purchases += H.generate_render(show_key = FALSE)
	text += printplayerlist(members)
	text += "<br>"
	text += "(辛迪加消费了[TC_uses]TC) [purchases]"
	if(TC_uses == 0 && GLOB.station_was_nuked && !are_all_operatives_dead())
		text += "<BIG>[icon2html('icons/ui_icons/antags/badass.dmi', world, "badass")]</BIG>"

	parts += text

	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"

/datum/team/nuclear/antag_listing_name()
	if(syndicate_name)
		return "[syndicate_name]辛迪加"
	else
		return "辛迪加"

/datum/team/nuclear/antag_listing_entry()
	var/disk_report = "<b>核磁盘(s)</b><br>"
	disk_report += "<table cellspacing=5>"
	for(var/obj/item/disk/nuclear/N in SSpoints_of_interest.real_nuclear_disks)
		disk_report += "<tr><td>[N.name], "
		var/atom/disk_loc = N.loc
		while(!isturf(disk_loc))
			if(ismob(disk_loc))
				var/mob/M = disk_loc
				disk_report += "由<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(M)]'>[M.real_name]</a>携带 "
			if(isobj(disk_loc))
				var/obj/O = disk_loc
				disk_report += "位于[O.name] "
			disk_loc = disk_loc.loc
		disk_report += "位于[disk_loc.loc] ([disk_loc.x], [disk_loc.y], [disk_loc.z])</td><td><a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(N)]'>FLW</a></td></tr>"
	disk_report += "</table>"

	var/post_report

	var/war_declared = FALSE
	for(var/obj/item/circuitboard/computer/syndicate_shuttle/board as anything in GLOB.syndicate_shuttle_boards)
		if(board.challenge)
			war_declared = TRUE

	var/force_war_button = ""

	if(war_declared)
		post_report += "<b>已宣战.</b>"
		force_war_button = "\[武力战争\]"
	else
		post_report += "<b>未宣战.</b>"
		var/obj/item/nuclear_challenge/war_button = war_button_ref?.resolve()
		if(war_button)
			force_war_button = "<a href='?_src_=holder;[HrefToken()];force_war=[REF(war_button)]'>\[武力战争\]</a>"
		else
			force_war_button = "\[无法宣战，挑战按钮不见踪影!\]"

	post_report += "\n[force_war_button]"
	post_report += "\n<a href='?_src_=holder;[HrefToken()];give_reinforcement=[REF(src)]'>\[输送增援部队\]</a>"

	var/final_report = ..()
	final_report += disk_report
	final_report += post_report
	return final_report

#define SPAWN_AT_BASE "核基地"
#define SPAWN_AT_INFILTRATOR "渗透者号"

/datum/team/nuclear/proc/admin_spawn_reinforcement(mob/admin)
	if(!check_rights_for(admin.client, R_ADMIN))
		return

	var/infil_or_nukebase = tgui_alert(
		admin,
		"将他们送到核基地还是渗透者号里?",
		"增援位置?",
		list(SPAWN_AT_BASE, SPAWN_AT_INFILTRATOR, "取消"),
	)

	if(!infil_or_nukebase || infil_or_nukebase == "取消")
		return

	var/tc_to_spawn = tgui_input_number(admin, "初始携带多少TC?", "TC", 0, 100)

	var/list/nuke_candidates = SSpolling.poll_ghost_candidates(
		"你想扮演辛迪加紧急增援部队吗?",
		check_jobban = ROLE_OPERATIVE,
		role = ROLE_OPERATIVE,
		poll_time = 30 SECONDS,
		ignore_category = POLL_IGNORE_SYNDICATE,
		pic_source = /obj/structure/sign/poster/contraband/gorlex_recruitment,
		role_name_text = "辛迪加增援部队",
	)

	nuke_candidates -= admin // may be easy to fat-finger say yes. so just don't

	if(!length(nuke_candidates))
		tgui_alert(admin, "找不到人选.", "人员短缺", list("OK"))
		return


	var/turf/spawn_loc
	if(infil_or_nukebase == SPAWN_AT_INFILTRATOR)
		var/area/spawn_in
		// Prioritize EVA then hallway, if neither can be found default to the first area we can find
		for(var/area_type in list(/area/shuttle/syndicate/eva, /area/shuttle/syndicate/hallway, /area/shuttle/syndicate))
			spawn_in = locate(area_type) in GLOB.areas // I'd love to use areas_by_type but the Infiltrator is a unique area
			if(spawn_in)
				break

		var/list/turf/options = list()
		for(var/turf/open/open_turf in spawn_in?.get_contained_turfs())
			if(open_turf.is_blocked_turf())
				continue
			options += open_turf

		if(length(options))
			spawn_loc = pick(options)
		else
			infil_or_nukebase = SPAWN_AT_BASE

	if(infil_or_nukebase == SPAWN_AT_BASE)
		spawn_loc = pick(GLOB.nukeop_start)

	var/mob/dead/observer/picked = pick(nuke_candidates)
	var/mob/living/carbon/human/nukie = new(spawn_loc)
	picked.client.prefs.safe_transfer_prefs_to(nukie, is_antag = TRUE)
	nukie.key = picked.key

	var/datum/antagonist/nukeop/antag_datum = new()
	antag_datum.send_to_spawnpoint = FALSE
	antag_datum.nukeop_outfit = /datum/outfit/syndicate/reinforcement

	nukie.mind.add_antag_datum(antag_datum, src)

	var/datum/component/uplink/uplink = nukie.mind.find_syndicate_uplink()
	uplink?.set_telecrystals(tc_to_spawn)

	// add some pizzazz
	do_sparks(4, FALSE, spawn_loc)
	new /obj/effect/temp_visual/teleport_abductor/syndi_teleporter(spawn_loc)
	playsound(spawn_loc, SFX_SPARKS, 50, TRUE)
	playsound(spawn_loc, 'sound/effects/phasein.ogg', 50, TRUE)

	tgui_alert(admin, "增援部队携带着[tc_to_spawn]到达了[infil_or_nukebase]处.", "增援到达", list("祝好运"))

#undef SPAWN_AT_BASE
#undef SPAWN_AT_INFILTRATOR

/// Returns whether or not syndicate operatives escaped.
/proc/is_infiltrator_docked_at_syndiebase()
	var/obj/docking_port/mobile/infiltrator/infiltrator_port = SSshuttle.getShuttle("syndicate")

	var/datum/lazy_template/nukie_base/nukie_template = GLOB.lazy_templates[LAZY_TEMPLATE_KEY_NUKIEBASE]
	if(!nukie_template)
		return FALSE // if its not even loaded, cant be docked

	for(var/datum/turf_reservation/loaded_area as anything in nukie_template.reservations)
		var/infiltrator_turf = get_turf(infiltrator_port)
		if(infiltrator_turf in loaded_area.reserved_turfs)
			return TRUE
	return FALSE
