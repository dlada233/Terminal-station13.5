/datum/antagonist/nukeop/leader
	name = "核武行动队长"
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
	addtimer(CALLBACK(src, PROC_REF(nuketeam_name_assign)), 0.1 SECONDS)

/datum/antagonist/nukeop/leader/proc/nuketeam_name_assign()
	if(!nuke_team)
		return
	nuke_team.rename_team(ask_name())

/datum/antagonist/nukeop/leader/proc/ask_name()
	var/randomname = pick(GLOB.last_names)
	var/newname = tgui_input_text(owner.current, "你是核特工[title]. 请为你的大家庭选择一个姓氏.", "改名", randomname, MAX_NAME_LEN)
	if (!newname)
		newname = randomname
	else
		newname = reject_bad_name(newname)
		if(!newname)
			newname = randomname

	return capitalize(newname)
