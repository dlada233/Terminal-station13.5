/datum/traitor_objective_category/hack_comm_console
	name = "骇入通讯终端"
	objectives = list(
		/datum/traitor_objective/hack_comm_console = 1,
	)

/datum/traitor_objective/hack_comm_console
	name = "骇入通讯终端并引发未知威胁"
	description = "右键通讯终端开始骇入，一旦开始，AI会知道你在骇入通讯终端，所以准备好逃跑或做好伪装. 如果另有叛徒先完成了同样的目标，你的这个目标会失败."

	progression_minimum = 60 MINUTES
	progression_reward = list(30 MINUTES, 40 MINUTES)
	telecrystal_reward = list(7, 12)

	var/progression_objectives_minimum = 20 MINUTES

/datum/traitor_objective/hack_comm_console/can_generate_objective(datum/mind/generating_for, list/possible_duplicates)
	if(length(possible_duplicates) > 0)
		return FALSE
	if(SStraitor.get_taken_count(/datum/traitor_objective/hack_comm_console) > 0)
		return FALSE
	if(handler.get_completion_progression(/datum/traitor_objective) < progression_objectives_minimum)
		return FALSE
	return TRUE

/datum/traitor_objective/hack_comm_console/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	AddComponent(/datum/component/traitor_objective_mind_tracker, generating_for, \
		signals = list(COMSIG_LIVING_UNARMED_ATTACK = PROC_REF(on_unarmed_attack)))
	RegisterSignal(SSdcs, COMSIG_GLOB_TRAITOR_OBJECTIVE_COMPLETED, PROC_REF(on_global_obj_completed))
	return TRUE

/datum/traitor_objective/hack_comm_console/ungenerate_objective()
	UnregisterSignal(SSdcs, COMSIG_GLOB_TRAITOR_OBJECTIVE_COMPLETED)

/datum/traitor_objective/hack_comm_console/proc/on_global_obj_completed(datum/source, datum/traitor_objective/objective)
	SIGNAL_HANDLER
	if(istype(objective, /datum/traitor_objective/hack_comm_console))
		fail_objective()

/datum/traitor_objective/hack_comm_console/proc/on_unarmed_attack(mob/user, obj/machinery/computer/communications/target, proximity_flag, modifiers)
	SIGNAL_HANDLER
	if(!proximity_flag)
		return
	if(!modifiers[RIGHT_CLICK])
		return
	if(!istype(target))
		return
	INVOKE_ASYNC(src, PROC_REF(begin_hack), user, target)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/traitor_objective/hack_comm_console/proc/begin_hack(mob/user, obj/machinery/computer/communications/target)
	if(!target.try_hack_console(user))
		return

	succeed_objective()
