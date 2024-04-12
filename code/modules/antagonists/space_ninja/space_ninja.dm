/datum/antagonist/ninja
	name = "\improper 太空忍者"
	antagpanel_category = ANTAG_GROUP_NINJAS
	job_rank = ROLE_NINJA
	antag_hud_name = "space_ninja"
	hijack_speed = 1
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	antag_moodlet = /datum/mood_event/focused
	suicide_cry = "蜘蛛众万岁!!"
	preview_outfit = /datum/outfit/ninja_preview
	can_assign_self_objectives = TRUE
	ui_name = "AntagInfoNinja"
	default_custom_objective = "在不被发现的情况下摧毁空间站基础设施."
	///Whether or not this ninja will obtain objectives
	var/give_objectives = TRUE

/**
 * Proc that equips the space ninja outfit on a given individual.  By default this is the owner of the antagonist datum.
 *
 * Proc that equips the space ninja outfit on a given individual.  By default this is the owner of the antagonist datum.
 * Arguments:
 * * ninja - The human to receive the gear
 * * Returns a proc call on the given human which will equip them with all the gear.
 */
/datum/antagonist/ninja/proc/equip_space_ninja(mob/living/carbon/human/ninja = owner.current)
	return ninja.equipOutfit(/datum/outfit/ninja)

/**
 * Proc that adds the proper memories to the antag datum
 *
 * Proc that adds the ninja starting memories to the owner of the antagonist datum.
 */
/datum/antagonist/ninja/proc/addMemories()
	antag_memory += "我是显赫的蜘蛛众门下的精锐佣兵. 一名<font color='red'><B>太空忍者</B></font>!<br>"
	antag_memory += "善战者，攻其所不守，守其所不攻.<br>" // 孙子兵法 虚实篇....

/datum/objective/cyborg_hijack
	explanation_text = "用你的手套骇入至少一个赛博来帮你破坏空间站."

/datum/objective/door_jack
	///How many doors that need to be opened using the gloves to pass the objective
	var/doors_required = 0

/datum/objective/plant_explosive
	var/area/detonation_location

/datum/objective/security_scramble
	explanation_text = "用你的手套骇入安保终端，使每个人至少被通缉一次，请注意AI能收到骇入警报!"

/datum/objective/terror_message
	explanation_text = "用你的手套骇入通讯终端，将给空间站带来新的外部威胁，请注意AI能收到骇入警报!"

/datum/objective/research_secrets
	explanation_text = "用你的手套骇入研发服务器，破坏研究成果，请注意AI能收到骇入警报!"

/**
 * Proc that adds all the ninja's objectives to the antag datum.
 *
 * Proc that adds all the ninja's objectives to the antag datum.  Called when the datum is gained.
 */
/datum/antagonist/ninja/proc/addObjectives()
	//Cyborg Hijack: Flag set to complete in the DrainAct in ninjaDrainAct.dm
	var/datum/objective/hijack = new /datum/objective/cyborg_hijack()
	objectives += hijack

	// Break into science and mess up their research. Only add this objective if the similar steal objective is possible.
	var/datum/objective/research_secrets/sabotage_research = new /datum/objective/research_secrets()
	objectives += sabotage_research

	//Door jacks, flag will be set to complete on when the last door is hijacked
	var/datum/objective/door_jack/doorobjective = new /datum/objective/door_jack()
	doorobjective.doors_required = rand(15,40)
	doorobjective.explanation_text = "用你的手套骇入[doorobjective.doors_required]扇空间站上的气闸门."
	objectives += doorobjective
	//SKYRAT EDIT START
	if(length(get_crewmember_minds()) >= BOMB_POP_REQUIREMENT)
		//Explosive plant, the bomb will register its completion on priming
		var/datum/objective/plant_explosive/bombobjective = new /datum/objective/plant_explosive()
		for(var/sanity in 1 to 100) // 100 checks at most.
			var/area/selected_area = pick(GLOB.areas)
			if(!is_station_level(selected_area.z) || !(selected_area.area_flags & VALID_TERRITORY))
				continue
			bombobjective.detonation_location = selected_area
			break
		if(bombobjective.detonation_location)
			bombobjective.explanation_text = "在[bombobjective.detonation_location]中安置并启动爆弹. 请注意爆弹在其他地方不可用!"
			objectives += bombobjective
	//SKYRAT EDIT END

	//Security Scramble, set to complete upon using your gloves on a security console
	var/datum/objective/securityobjective = new /datum/objective/security_scramble()
	objectives += securityobjective
	/* SKYRAT EDIT REMOVAL
	//Message of Terror, set to complete upon using your gloves a communication console
	var/datum/objective/communicationobjective = new /datum/objective/terror_message()
	objectives += communicationobjective
	*/
	//Survival until end
	var/datum/objective/survival = new /datum/objective/survive()
	survival.owner = owner
	objectives += survival

/datum/antagonist/ninja/greet()
	. = ..()
	SEND_SOUND(owner.current, sound('sound/effects/ninja_greeting.ogg'))
	to_chat(owner.current, span_danger("我是显赫的蜘蛛众的精英佣兵!"))
	to_chat(owner.current, span_warning("我将攻其所不守，守其所不攻."))
	to_chat(owner.current, span_notice("空间站位于你的[dir2text(get_dir(owner.current, locate(world.maxx/2, world.maxy/2, owner.current.z)))]. 投掷忍者手里剑将帮助你到达那里."))
	owner.announce_objectives()

/datum/antagonist/ninja/on_gain()
	if(give_objectives)
		addObjectives()
	addMemories()
	equip_space_ninja(owner.current)
	owner.current.add_quirk(/datum/quirk/freerunning)
	owner.current.add_quirk(/datum/quirk/light_step)
	owner.current.mind.set_assigned_role(SSjob.GetJobType(/datum/job/space_ninja))
	owner.current.mind.special_role = ROLE_NINJA
	return ..()

/datum/antagonist/ninja/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.set_assigned_role(SSjob.GetJobType(/datum/job/space_ninja))
	new_owner.special_role = ROLE_NINJA
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)]让[key_name_admin(new_owner)]成为一名忍者.")
	log_admin("[key_name(admin)]让[key_name(new_owner)]成为一名忍者.")
