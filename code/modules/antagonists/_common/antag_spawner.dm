/obj/item/antag_spawner
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY
	var/used = FALSE

/obj/item/antag_spawner/proc/spawn_antag(client/C, turf/T, kind = "", datum/mind/user)
	return

/obj/item/antag_spawner/proc/equip_antag(mob/target)
	return


///////////WIZARD

/obj/item/antag_spawner/contract
	name = "合同"
	desc = "一份由你的学徒签署的魔法合同，规定了作为学习魔法的代价，他们必须响应你的请求."
	icon = 'icons/obj/scrolls.dmi'
	icon_state ="scroll2"
	var/polling = FALSE

/obj/item/antag_spawner/contract/can_interact(mob/user)
	. = ..()
	if(!.)
		return FALSE
	if(polling)
		balloon_alert(user, "已经在呼叫学徒了!")
		return FALSE

/obj/item/antag_spawner/contract/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ApprenticeContract", name)
		ui.open()

/obj/item/antag_spawner/contract/ui_state(mob/user)
	if(used)
		return GLOB.never_state
	return GLOB.default_state

/obj/item/antag_spawner/contract/ui_assets(mob/user)
	. = ..()
	return list(
		get_asset_datum(/datum/asset/simple/contracts),
	)

/obj/item/antag_spawner/contract/ui_act(action, list/params)
	. = ..()
	if(used || polling || !ishuman(usr))
		return
	INVOKE_ASYNC(src, PROC_REF(poll_for_student), usr, params["school"])
	SStgui.close_uis(src)

/obj/item/antag_spawner/contract/proc/poll_for_student(mob/living/carbon/human/teacher, apprentice_school)
	balloon_alert(teacher, "联系学徒中...")
	polling = TRUE
	var/mob/chosen_one = SSpolling.poll_ghosts_for_target("你想要扮演[span_danger("[teacher]的")] [span_notice("[apprentice_school]学徒吗")]?", check_jobban = ROLE_WIZARD, role = ROLE_WIZARD, poll_time = 15 SECONDS, checked_target = src, alert_pic = /obj/item/clothing/head/wizard/red, jump_target = src, role_name_text = "wizard apprentice", chat_text_border_icon = /obj/item/clothing/head/wizard/red)
	polling = FALSE
	if(isnull(chosen_one))
		to_chat(teacher, span_warning("联系不到你的学徒!你可以使用合同击打魔法书来退还点数或者稍后重试."))
		return
	if(QDELETED(src) || used)
		return
	used = TRUE
	spawn_antag(chosen_one.client, get_turf(src), apprentice_school, teacher.mind)

/obj/item/antag_spawner/contract/spawn_antag(client/C, turf/T, kind, datum/mind/user)
	new /obj/effect/particle_effect/fluid/smoke(T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	C.prefs.safe_transfer_prefs_to(M, is_antag = TRUE)
	M.key = C.key
	var/datum/mind/app_mind = M.mind

	var/datum/antagonist/wizard/apprentice/app = new()
	app.master = user
	app.school = kind

	var/datum/antagonist/wizard/master_wizard = user.has_antag_datum(/datum/antagonist/wizard)
	if(master_wizard)
		if(!master_wizard.wiz_team)
			master_wizard.create_wiz_team()
		app.wiz_team = master_wizard.wiz_team
		master_wizard.wiz_team.add_member(app_mind)
	app_mind.add_antag_datum(app)
	app_mind.set_assigned_role(SSjob.GetJobType(/datum/job/wizard_apprentice))
	app_mind.special_role = ROLE_WIZARD_APPRENTICE
	SEND_SOUND(M, sound('sound/effects/magic.ogg'))

///////////BORGS AND OPERATIVES


/**
 * Device to request reinforcments from ghost pop
 */
/obj/item/antag_spawner/nuke_ops
	name = "辛迪加行动信标"
	desc = "MI13开发的增援呼叫装置. 不用考虑被呼叫者的安全 - 反正他们都来自Interdyne基因库的劣质克隆体."
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "nukietalkie"
	/// The name of the special role given to the recruit
	var/special_role_name = ROLE_NUCLEAR_OPERATIVE
	/// The applied outfit
	var/datum/outfit/syndicate/outfit = /datum/outfit/syndicate/reinforcement
	/// The antag datum applied
	var/antag_datum = /datum/antagonist/nukeop/reinforcement
	/// Style used by the droppod
	var/pod_style = STYLE_SYNDICATE
	/// Do we use a random subtype of the outfit?
	var/use_subtypes = TRUE
	/// Where do we land our pod?
	var/turf/spawn_location

/obj/item/antag_spawner/nuke_ops/proc/check_usability(mob/user)
	if(used)
		to_chat(user, span_warning("[src]电力不足!"))
		return FALSE
	if(!user.mind.has_antag_datum(/datum/antagonist/nukeop,TRUE))
		to_chat(user, span_danger("认证失败. 拒绝访问."))
		return FALSE
	return TRUE

/// Creates the drop pod the nukie will be dropped by
/obj/item/antag_spawner/nuke_ops/proc/setup_pod()
	var/obj/structure/closet/supplypod/pod = new(null, pod_style)
	pod.explosionSize = list(0,0,0,0)
	pod.bluespace = TRUE
	return pod

/obj/item/antag_spawner/nuke_ops/attack_self(mob/user)
	if(!(check_usability(user)))
		return

	to_chat(user, span_notice("你激活[src]并等待确认信息."))
	var/mob/chosen_one = SSpolling.poll_ghost_candidates("你想要扮演辛迪加[special_role_name]增援部队吗?", check_jobban = ROLE_OPERATIVE, role = ROLE_OPERATIVE, poll_time = 15 SECONDS, ignore_category = POLL_IGNORE_SYNDICATE, alert_pic = src, role_name_text = special_role_name, amount_to_pick = 1)
	if(chosen_one)
		if(QDELETED(src) || !check_usability(user))
			return
		used = TRUE
		spawn_antag(chosen_one.client, get_turf(src), "nukeop", user.mind)
		do_sparks(4, TRUE, src)
		qdel(src)
	else
		to_chat(user, span_warning("无法连通到辛迪加指挥部，请稍后再试或在上行链路上使用信标来退货."))

/obj/item/antag_spawner/nuke_ops/spawn_antag(client/our_client, turf/T, kind, datum/mind/user)
	var/mob/living/carbon/human/nukie = new()
	our_client.prefs.safe_transfer_prefs_to(nukie, is_antag = TRUE)
	nukie.ckey = our_client.key
	var/datum/mind/op_mind = nukie.mind
	if(length(GLOB.newplayer_start)) // needed as hud code doesn't render huds if the atom (in this case the nukie) is in nullspace, so just move the nukie somewhere safe
		nukie.forceMove(pick(GLOB.newplayer_start))
	else
		nukie.forceMove(locate(1,1,1))

	var/new_datum = new antag_datum()

	var/datum/antagonist/nukeop/creator_op = user.has_antag_datum(/datum/antagonist/nukeop, TRUE)
	op_mind.add_antag_datum(new_datum, creator_op ? creator_op.get_team() : null)
	op_mind.special_role = special_role_name

	if(outfit)
		var/datum/antagonist/nukeop/nukie_datum = op_mind.has_antag_datum(antag_datum)
		nukie_datum.nukeop_outfit = use_subtypes ? pick(subtypesof(outfit)) : outfit

	var/obj/structure/closet/supplypod/pod = setup_pod()
	nukie.forceMove(pod)
	new /obj/effect/pod_landingzone(spawn_location ? spawn_location : get_turf(src), pod)

/obj/item/antag_spawner/nuke_ops/overwatch
	name = "overwatch support beacon"
	desc = "Assigns an Overwatch Intelligence Agent to your operation. Stationed at their own remote outpost, they can view station cameras, alarms, and even move the Infiltrator shuttle! \
		Also, all members of your operation will receive body cameras that they can view your progress from."
	special_role_name = ROLE_OPERATIVE_OVERWATCH
	outfit = /datum/outfit/syndicate/support
	use_subtypes = FALSE
	antag_datum = /datum/antagonist/nukeop/support

/obj/item/antag_spawner/nuke_ops/overwatch/Initialize(mapload)
	. = ..()
	if(length(GLOB.nukeop_overwatch_start)) //Otherwise, it will default to the datum's spawn point anyways
		spawn_location = pick(GLOB.nukeop_overwatch_start)

//////CLOWN OP
/obj/item/antag_spawner/nuke_ops/clown
	name = "小丑行动队员信标"
	desc = "一次性的信标，用来快速地派遣增援小丑特工进入战场."
	special_role_name = ROLE_CLOWN_OPERATIVE
	outfit = /datum/outfit/syndicate/clownop/no_crystals
	antag_datum = /datum/antagonist/nukeop/clownop
	pod_style = STYLE_HONK
	use_subtypes = FALSE

//////SYNDICATE BORG
/obj/item/antag_spawner/nuke_ops/borg_tele
	name = "辛迪加赛博信标"
	desc = "一次性的信标，用来快速地派遣增援赛博进入战场."
	antag_datum = /datum/antagonist/nukeop/reinforcement/cyborg
	special_role_name = "Syndicate Cyborg"

/obj/item/antag_spawner/nuke_ops/borg_tele/assault
	name = "辛迪加突击赛博信标"
	special_role_name = ROLE_SYNDICATE_ASSAULTBORG

/obj/item/antag_spawner/nuke_ops/borg_tele/medical
	name = "辛迪加医疗赛博信标"
	special_role_name = ROLE_SYNDICATE_MEDBORG

/obj/item/antag_spawner/nuke_ops/borg_tele/saboteur
	name = "辛迪加武工赛博信标"
	special_role_name = ROLE_SYNDICATE_SABOBORG

/obj/item/antag_spawner/nuke_ops/borg_tele/spawn_antag(client/C, turf/T, kind, datum/mind/user)
	var/mob/living/silicon/robot/borg
	var/datum/antagonist/nukeop/creator_op = user.has_antag_datum(/datum/antagonist/nukeop,TRUE)
	if(!creator_op)
		return
	var/obj/structure/closet/supplypod/pod = setup_pod()
	switch(special_role_name)
		if(ROLE_SYNDICATE_MEDBORG)
			borg = new /mob/living/silicon/robot/model/syndicate/medical()
		if(ROLE_SYNDICATE_SABOBORG)
			borg = new /mob/living/silicon/robot/model/syndicate/saboteur()
		if(ROLE_SYNDICATE_ASSAULTBORG)
			borg = new /mob/living/silicon/robot/model/syndicate()
		else
			stack_trace("Unknown cyborg type '[special_role_name]' could not be found by [src]!")

	var/brainfirstname = pick(GLOB.first_names_male)
	if(prob(50))
		brainfirstname = pick(GLOB.first_names_female)
	var/brainopslastname = pick(GLOB.last_names)
	if(creator_op.nuke_team.syndicate_name)  //the brain inside the syndiborg has the same last name as the other ops.
		brainopslastname = creator_op.nuke_team.syndicate_name
	var/brainopsname = "[brainfirstname] [brainopslastname]"

	borg.mmi.name = "[initial(borg.mmi.name)]: [brainopsname]"
	borg.mmi.brain.name = "[brainopsname]的大脑"
	borg.mmi.brainmob.real_name = brainopsname
	borg.mmi.brainmob.name = brainopsname
	borg.real_name = borg.name

	borg.key = C.key

	borg.mind.add_antag_datum(antag_datum, creator_op ? creator_op.get_team() : null)
	borg.mind.special_role = special_role_name
	borg.forceMove(pod)
	new /obj/effect/pod_landingzone(get_turf(src), pod)

///////////SLAUGHTER DEMON

/obj/item/antag_spawner/slaughter_demon //Warning edgiest item in the game
	name = "魔血瓶"
	desc = "一瓶被魔法注入的血，从无数被谋杀的受害者身上提炼而成，一般用来在邪恶的仪式中吸引可怕的生物."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "vial"

	var/shatter_msg = span_notice("你打碎了瓶子，你现在没有回头路可走了!")
	var/veil_msg = span_warning("你感觉到一个黑暗的存在潜伏在帷幕后面...")
	var/mob/living/demon_type = /mob/living/basic/demon/slaughter

/obj/item/antag_spawner/slaughter_demon/attack_self(mob/user)
	if(!is_station_level(user.z))
		to_chat(user, span_warning("你也许应该等到空间站再说."))
		return
	if(used)
		return
	var/mob/chosen_one = SSpolling.poll_ghosts_for_target(check_jobban = ROLE_ALIEN, role = ROLE_ALIEN, poll_time = 5 SECONDS, checked_target = src, alert_pic = demon_type, jump_target = src, role_name_text = initial(demon_type.name))
	if(chosen_one)
		if(used || QDELETED(src))
			return
		used = TRUE
		user.log_message("召唤出了[initial(demon_type.name)] (played by [key_name(chosen_one)]) using a [name].", LOG_GAME) // has to be here before we create antag otherwise we can't get the ckey of the demon
		spawn_antag(chosen_one.client, get_turf(src), initial(demon_type.name), user.mind)
		to_chat(user, shatter_msg)
		to_chat(user, veil_msg)
		playsound(user.loc, 'sound/effects/glassbr1.ogg', 100, TRUE)
		qdel(src)
	else
		to_chat(user, span_warning("瓶子里的东西通常会不断地爆裂和沸腾，但现在却出奇地平静，也许你应该稍后再试."))

/obj/item/antag_spawner/slaughter_demon/spawn_antag(client/C, turf/T, kind = "", datum/mind/user)
	var/mob/living/basic/demon/spawned = new demon_type(T)
	new /obj/effect/dummy/phased_mob(T, spawned)

	spawned.key = C.key

/obj/item/antag_spawner/slaughter_demon/laughter
	name = "愉悦瓶"
	desc = "一瓶魔法注入的小丑之爱，从无数次拥抱攻击中提炼出来，用于在有趣的仪式中吸引可爱的生物。"
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "vial"
	color = "#FF69B4" // HOT PINK

	veil_msg = span_warning("你感觉到一个可爱的存在潜伏在面纱后面...")
	demon_type = /mob/living/basic/demon/slaughter/laughter

/**
 * A subtype meant for 'normal' antag spawner items so as to reduce the amount of required hardcoding.
 */

/obj/item/antag_spawner/loadout
	name = "通用信标"
	desc = "一次性信标，可以快速将错误代码发射到现场."
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "walkietalkie"
	/// The mob type to spawn.
	var/mob/living/spawn_type = /mob/living/carbon/human
	/// The species type to set a human spawn to.
	var/species_type = /datum/species/human
	/// The applied outfit. Won't work with nonhuman spawn types.
	var/datum/outfit/outfit
	/// The antag datum applied
	var/datum/antagonist/antag_datum
	/// Style used by the droppod
	var/pod_style = STYLE_SYNDICATE
	/// Do we use a random subtype of the outfit?
	var/use_subtypes = TRUE
	/// The antag role we check if the ghosts have enabled to get the poll.
	var/poll_role_check = ROLE_TRAITOR
	/// The mind's special role.
	var/role_to_play = ROLE_SYNDICATE_MONKEY
	/// What category to ignore the poll
	var/poll_ignore_category = POLL_IGNORE_SYNDICATE
	/// text given when device fails to secure candidates
	var/fail_text = "无法连通到辛迪加指挥部，请稍后再试或在上行链路上使用信标来退货."

/obj/item/antag_spawner/loadout/proc/check_usability(mob/user)
	if(used)
		to_chat(user, span_warning("[src]电力不足!"))
		return FALSE
	return TRUE

/// Creates the drop pod the spawned_mob will be dropped by
/obj/item/antag_spawner/loadout/proc/setup_pod()
	var/obj/structure/closet/supplypod/pod = new(null, pod_style)
	pod.explosionSize = list(0,0,0,0)
	pod.bluespace = TRUE
	return pod

/obj/item/antag_spawner/loadout/attack_self(mob/user)
	if(!(check_usability(user)))
		return

	to_chat(user, span_notice("You activate [src] and wait for confirmation."))
	var/mob/chosen_one = SSpolling.poll_ghost_candidates(
		check_jobban = poll_role_check,
		role = poll_role_check,
		poll_time = 10 SECONDS,
		ignore_category = poll_ignore_category,
		alert_pic = src,
		role_name_text = role_to_play,
		amount_to_pick = 1
	)
	if(isnull(chosen_one))
		to_chat(user, span_warning(fail_text))
		return
	if(QDELETED(src) || !check_usability(user))
		return
	used = TRUE
	spawn_antag(chosen_one.client, get_turf(src), user)
	do_sparks(4, TRUE, src)
	qdel(src)

// For subtypes to do special things to the summoned dude.
/obj/item/antag_spawner/loadout/proc/do_special_things(mob/living/carbon/human/spawned_mob, mob/user)
	return

/obj/item/antag_spawner/loadout/spawn_antag(client/our_client, turf/T, mob/user)
	var/mob/living/spawned_mob = new spawn_type()
	var/obj/structure/closet/supplypod/pod = setup_pod()
	our_client.prefs.safe_transfer_prefs_to(spawned_mob, is_antag = TRUE)
	spawned_mob.ckey = our_client.key
	var/datum/mind/op_mind = spawned_mob.mind
	if(length(GLOB.newplayer_start)) // needed as hud code doesn't render huds if the atom (in this case the spawned_mob) is in nullspace, so just move the spawned_mob somewhere safe
		spawned_mob.forceMove(pick(GLOB.newplayer_start))
	else
		spawned_mob.forceMove(locate(1,1,1))

	op_mind.add_antag_datum(antag_datum)

	if(ishuman(spawned_mob))
		var/mob/living/carbon/human/human_mob = spawned_mob
		human_mob.set_species(species_type)
		human_mob.equipOutfit(outfit)

	op_mind.special_role = role_to_play

	do_special_things(spawned_mob, user)

	spawned_mob.forceMove(pod)
	new /obj/effect/pod_landingzone(get_turf(src), pod)

/obj/item/antag_spawner/loadout/contractor
	name = "contractor support beacon"
	desc = "A beacon sold to the most prestigeous syndicate members, a single-use radio for calling immediate backup."
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "nukietalkie"
	outfit = /datum/outfit/contractor_partner
	use_subtypes = FALSE
	antag_datum = /datum/antagonist/traitor/contractor_support
	poll_ignore_category = ROLE_TRAITOR
	role_to_play = ROLE_CONTRACTOR_SUPPORT

/obj/item/antag_spawner/loadout/contractor/do_special_things(mob/living/carbon/human/contractor_support, mob/user)
	to_chat(contractor_support, "\n[span_alertwarning("[user.real_name] is your superior. Follow any, and all orders given by them. You're here to support their mission only.")]")
	to_chat(contractor_support, "[span_alertwarning("Should they perish, or be otherwise unavailable, you're to assist other active agents in this mission area to the best of your ability.")]")

/obj/item/antag_spawner/loadout/monkey_man
	name = "猴特工信标"
	desc = "叫ARC的后援来制造猴子骚乱."
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "walkietalkie"
	species_type = /datum/species/monkey
	outfit = /datum/outfit/syndicate_monkey
	antag_datum = /datum/antagonist/syndicate_monkey
	use_subtypes = FALSE
	poll_role_check = ROLE_TRAITOR
	role_to_play = ROLE_SYNDICATE_MONKEY
	poll_ignore_category = POLL_IGNORE_SYNDICATE
	fail_text = "无法连通到动物权利联盟的香蕉行动部，请稍后再试或在上行链路上使用信标来退货."

/obj/item/antag_spawner/loadout/monkey_man/do_special_things(mob/living/carbon/human/monkey_man, mob/user)

	monkey_man.fully_replace_character_name(monkey_man.real_name, pick(GLOB.syndicate_monkey_names))

	monkey_man.dna.add_mutation(/datum/mutation/human/clever)
	// Can't make them human or nonclever. At least not with the easy and boring way out.
	for(var/datum/mutation/human/mutation as anything in monkey_man.dna.mutations)
		mutation.mutadone_proof = TRUE
		mutation.instability = 0

	// Extra backup!
	ADD_TRAIT(monkey_man, TRAIT_NO_DNA_SCRAMBLE, SPECIES_TRAIT)
	// Anything else requires enough effort that they deserve it.

	monkey_man.mind.enslave_mind_to_creator(user)

	var/obj/item/implant/explosive/imp = new(src)
	imp.implant(monkey_man, user)

/datum/outfit/syndicate_monkey
	name = "辛迪加猴特工套装"

	head = /obj/item/clothing/head/fedora
	mask = /obj/item/clothing/mask/cigarette/syndicate
	uniform = /obj/item/clothing/under/syndicate
	l_pocket = /obj/item/reagent_containers/cup/soda_cans/monkey_energy
	r_pocket = /obj/item/storage/fancy/cigarettes/cigpack_syndicate
	internals_slot = NONE
	belt = /obj/item/lighter/skull
	r_hand = /obj/item/food/grown/banana

