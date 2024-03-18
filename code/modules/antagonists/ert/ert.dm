//Both ERT and DS are handled by the same datums since they mostly differ in equipment in objective.
/datum/team/ert
	name = "应急响应部队"
	var/datum/objective/mission //main mission

/datum/antagonist/ert
	name = "应急响应军官"
	can_elimination_hijack = ELIMINATION_PREVENT
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	antag_moodlet = /datum/mood_event/focused
	antagpanel_category = ANTAG_GROUP_ERT
	suicide_cry = "为了纳米传讯!!"
	count_against_dynamic_roll_chance = FALSE
	// Not 'true' antags, this disables certain interactions that assume the owner is a baddie
	antag_flags = FLAG_FAKE_ANTAG
	var/datum/team/ert/ert_team
	var/leader = FALSE
	var/datum/outfit/outfit = /datum/outfit/centcom/ert/security
	var/datum/outfit/plasmaman_outfit = /datum/outfit/plasmaman/centcom_official
	var/role = "安保人员"
	var/list/name_source
	var/random_names = TRUE
	var/rip_and_tear = FALSE
	var/equip_ert = TRUE
	var/forge_objectives_for_ert = TRUE
	/// Typepath indicating the kind of job datum this ert member will have.
	var/ert_job_path = /datum/job/ert_generic


/datum/antagonist/ert/on_gain()
	if(random_names)
		update_name()
	if(forge_objectives_for_ert)
		forge_objectives()
	if(equip_ert)
		equipERT()
	owner?.current.faction |= FACTION_ERT //SKYRAT ADDITION
	. = ..()

/datum/antagonist/ert/get_team()
	return ert_team

/datum/antagonist/ert/New()
	. = ..()
	name_source = GLOB.last_names

/datum/antagonist/ert/proc/update_name()
	owner.current.fully_replace_character_name(owner.current.real_name,"[role] [pick(name_source)]")

/datum/antagonist/ert/official
	name = "中央指挥部官员"
	show_name_in_check_antagonists = TRUE
	var/datum/objective/mission
	role = "Inspector"
	random_names = FALSE
	outfit = /datum/outfit/centcom/centcom_official

/datum/antagonist/ert/official/greet()
	. = ..()
	if (ert_team)
		to_chat(owner, "<span class='warningplain'>中央指挥部向你指派了如下任务: [ert_team.mission.explanation_text]</span>")
	else
		to_chat(owner, "<span class='warningplain'>中央指挥部向你指派了如下任务: [mission.explanation_text]</span>")

/datum/antagonist/ert/official/forge_objectives()
	if (ert_team)
		return ..()
	if(mission)
		return
	var/datum/objective/missionobj = new ()
	missionobj.owner = owner
	missionobj.explanation_text = "对[station_name()]和其舰长进行例行绩效考核."
	missionobj.completed = TRUE
	mission = missionobj
	objectives |= mission

/datum/antagonist/ert/security // kinda handled by the base template but here for completion

/datum/antagonist/ert/security/red
	outfit = /datum/outfit/centcom/ert/security/alert

/datum/antagonist/ert/engineer
	role = "工程师"
	outfit = /datum/outfit/centcom/ert/engineer

/datum/antagonist/ert/engineer/red
	outfit = /datum/outfit/centcom/ert/engineer/alert

/datum/antagonist/ert/medic
	role = "医官"
	outfit = /datum/outfit/centcom/ert/medic

/datum/antagonist/ert/medic/red
	outfit = /datum/outfit/centcom/ert/medic/alert

/datum/antagonist/ert/commander
	role = "指挥官"
	outfit = /datum/outfit/centcom/ert/commander
	plasmaman_outfit = /datum/outfit/plasmaman/centcom_commander

/datum/antagonist/ert/commander/red
	outfit = /datum/outfit/centcom/ert/commander/alert

/datum/antagonist/ert/janitor
	role = "清洁工"
	outfit = /datum/outfit/centcom/ert/janitor

/datum/antagonist/ert/janitor/heavy
	role = "重装清洁工"
	outfit = /datum/outfit/centcom/ert/janitor/heavy

/datum/antagonist/ert/deathsquad
	name = "行刑队士兵"
	outfit = /datum/outfit/centcom/death_commando
	plasmaman_outfit = /datum/outfit/plasmaman/centcom_commander
	role = "士兵"
	rip_and_tear = TRUE

/datum/antagonist/ert/deathsquad/New()
	. = ..()
	name_source = GLOB.commando_names

/datum/antagonist/ert/deathsquad/leader
	name = "行刑队军官"
	outfit = /datum/outfit/centcom/death_commando
	role = "军官"

/datum/antagonist/ert/medic/inquisitor
	outfit = /datum/outfit/centcom/ert/medic/inquisitor

/datum/antagonist/ert/medic/inquisitor/on_gain()
	. = ..()
	owner.holy_role = HOLY_ROLE_PRIEST

/datum/antagonist/ert/security/inquisitor
	outfit = /datum/outfit/centcom/ert/security/inquisitor

/datum/antagonist/ert/security/inquisitor/on_gain()
	. = ..()
	owner.holy_role = HOLY_ROLE_PRIEST

/datum/antagonist/ert/chaplain
	role = "牧师"
	outfit = /datum/outfit/centcom/ert/chaplain

/datum/antagonist/ert/chaplain/inquisitor
	outfit = /datum/outfit/centcom/ert/chaplain/inquisitor

/datum/antagonist/ert/chaplain/on_gain()
	. = ..()
	owner.holy_role = HOLY_ROLE_PRIEST

/datum/antagonist/ert/commander/inquisitor
	outfit = /datum/outfit/centcom/ert/commander/inquisitor

/datum/antagonist/ert/commander/inquisitor/on_gain()
	. = ..()
	owner.holy_role = HOLY_ROLE_PRIEST

/datum/antagonist/ert/intern
	name = "中央指挥部实习生"
	outfit = /datum/outfit/centcom/centcom_intern
	plasmaman_outfit = /datum/outfit/plasmaman/centcom_intern
	random_names = FALSE
	role = "实习生"
	suicide_cry = "为了实习证明!!"

/datum/antagonist/ert/intern/leader
	name = "中央指挥部实习生头子"
	outfit = /datum/outfit/centcom/centcom_intern/leader
	random_names = FALSE
	role = "实习生头子"

/datum/antagonist/ert/intern/unarmed
	outfit = /datum/outfit/centcom/centcom_intern/unarmed

/datum/antagonist/ert/intern/leader/unarmed
	outfit = /datum/outfit/centcom/centcom_intern/leader/unarmed

/datum/antagonist/ert/clown
	role = "小丑"
	outfit = /datum/outfit/centcom/ert/clown
	plasmaman_outfit = /datum/outfit/plasmaman/party_comedian

/datum/antagonist/ert/clown/New()
	. = ..()
	name_source = GLOB.clown_names

/datum/antagonist/ert/janitor/party
	role = "派对清洁工"
	outfit = /datum/outfit/centcom/ert/janitor/party
	plasmaman_outfit = /datum/outfit/plasmaman/party_janitor

/datum/antagonist/ert/security/party
	role = "派对保镖"
	outfit = /datum/outfit/centcom/ert/security/party
	plasmaman_outfit = /datum/outfit/plasmaman/party_bouncer

/datum/antagonist/ert/engineer/party
	role = "派对布置人员"
	outfit = /datum/outfit/centcom/ert/engineer/party
	plasmaman_outfit = /datum/outfit/plasmaman/party_constructor

/datum/antagonist/ert/clown/party
	role = "派对喜剧演员"
	outfit = /datum/outfit/centcom/ert/clown/party

/datum/antagonist/ert/commander/party
	role = "派对策划师"
	outfit = /datum/outfit/centcom/ert/commander/party

/datum/antagonist/ert/create_team(datum/team/ert/new_team)
	if(istype(new_team))
		ert_team = new_team

/datum/antagonist/ert/bounty_armor
	role = "重甲赏金猎人"
	outfit = /datum/outfit/bountyarmor/ert

/datum/antagonist/ert/bounty_hook
	role = "钩枪赏金猎人"
	outfit = /datum/outfit/bountyhook/ert

/datum/antagonist/ert/bounty_synth
	role = "合成赏金猎人"
	outfit = /datum/outfit/bountysynth/ert

/datum/antagonist/ert/forge_objectives()
	if(ert_team)
		objectives |= ert_team.objectives

/datum/antagonist/ert/proc/equipERT()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	if(isplasmaman(H))
		H.equipOutfit(plasmaman_outfit)
		H.open_internals(H.get_item_for_held_index(2))
	H.equipOutfit(outfit)


/datum/antagonist/ert/greet()
	if(!ert_team)
		return

	to_chat(owner, "<span class='warningplain'><B><font size=3 color=red>你是[name].</font></B></span>")

	var/missiondesc = "纳米传讯安保部门派遣你的队伍前往[station_name()]执行任务，"
	if(leader) //If Squad Leader
		missiondesc += "你要带领你的队伍完成任务. 当队伍准备就绪就登上穿梭机"
	else
		missiondesc += "你要服从队长的指挥."
	if(!rip_and_tear)
		missiondesc += " 尽可能避免平民伤亡."

	missiondesc += "<span class='warningplain'><BR><B>你的任务</B> : [ert_team.mission.explanation_text]</span>"
	to_chat(owner,missiondesc)

/datum/antagonist/ert/marine
	name = "陆战队指挥"
	outfit = /datum/outfit/centcom/ert/marine
	role = "指挥官"

/datum/antagonist/ert/marine/security
	name = "陆战队员"
	outfit = /datum/outfit/centcom/ert/marine/security
	role = "士兵"

/datum/antagonist/ert/marine/engineer
	name = "陆战队工程师"
	outfit = /datum/outfit/centcom/ert/marine/engineer
	role = "工兵"

/datum/antagonist/ert/marine/medic
	name = "陆战队医疗兵"
	outfit = /datum/outfit/centcom/ert/marine/medic
	role = "医疗兵"

/datum/antagonist/ert/militia
	name = "边境义勇兵"
	outfit = /datum/outfit/centcom/militia
	role = "义勇兵"

/datum/antagonist/ert/militia/general
	name = "边境义勇兵将军"
	outfit = /datum/outfit/centcom/militia/general
	role = "将军"
