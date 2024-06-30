/datum/antagonist/nukeop/support
	name = ROLE_OPERATIVE_OVERWATCH
	show_to_ghosts = TRUE
	send_to_spawnpoint = TRUE
	nukeop_outfit = /datum/outfit/syndicate/support

/datum/antagonist/nukeop/support/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/machines/printer.ogg', 100, 0, use_reverb = FALSE)
	to_chat(owner, span_big("你是[name]! 你被临时指派为一个核武行动小组提供摄像头以及通讯监听支援!"))
	to_chat(owner, span_red("使用你的工具来设置你喜欢的装备，但不要试图离开你的哨站."))
	owner.announce_objectives()

/datum/antagonist/nukeop/support/on_gain()
	..()
	for(var/datum/mind/teammate_mind in nuke_team.members)
		var/mob/living/our_teammate = teammate_mind.current
		our_teammate.AddComponent( \
			/datum/component/simple_bodycam, \
			camera_name = "行动队员随身摄像头", \
			c_tag = "[our_teammate.real_name]", \
			network = OPERATIVE_CAMERA_NET, \
			emp_proof = FALSE, \
		)
		our_teammate.playsound_local(get_turf(owner.current), 'sound/weapons/egloves.ogg', 100, 0)
		to_chat(our_teammate, span_notice("一名辛迪加情报监听特工被分配到你的队伍内. 笑一笑，你已经在其照管范围内了!"))

	RegisterSignal(nuke_team, COMSIG_NUKE_TEAM_ADDITION, PROC_REF(late_bodycam))

	owner.current.grant_language(/datum/language/codespeak)

/datum/antagonist/nukeop/support/get_spawnpoint()
	return pick(GLOB.nukeop_overwatch_start)

/datum/antagonist/nukeop/support/forge_objectives()
	var/datum/objective/overwatch/objective = new
	objective.owner = owner
	objectives += objective

/datum/antagonist/nukeop/support/proc/late_bodycam(datum/source, mob/living/new_teammate)
	SIGNAL_HANDLER
	new_teammate.AddComponent( \
		/datum/component/simple_bodycam, \
		camera_name = "行动队员随身摄像头", \
		c_tag = "[new_teammate.real_name]", \
		network = OPERATIVE_CAMERA_NET, \
		emp_proof = FALSE, \
	)
	to_chat(new_teammate, span_notice("你已经装备了一个随身摄像头，你的情报监听特工可以看到你的视角，来场精彩的表演吧!"))

/datum/objective/overwatch
	explanation_text = "为你的行动小组提供情报支持!"

/datum/objective/overwatch/check_completion()
	return GLOB.station_was_nuked
