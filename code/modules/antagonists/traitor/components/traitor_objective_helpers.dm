/// 帮助组件，用于在对象上注册信号
/// 使用这个组件并不是必须的，而且对条件的控制很少
/datum/component/traitor_objective_register
	dupe_mode = COMPONENT_DUPE_ALLOWED

	/// 要应用成功/失败信号的目标
	var/datum/target
	/// 用于自动完成目标的信号
	var/succeed_signals
	/// 用于自动失败目标的信号
	var/fail_signals
	/// 失败是否有惩罚
	var/penalty = 0

/datum/component/traitor_objective_register/Initialize(datum/target, succeed_signals, fail_signals, penalty)
	. = ..()
	if(!istype(parent, /datum/traitor_objective))
		return COMPONENT_INCOMPATIBLE
	src.target = target
	src.succeed_signals = succeed_signals
	src.fail_signals = fail_signals
	src.penalty = penalty

/datum/component/traitor_objective_register/RegisterWithParent()
	if(succeed_signals)
		RegisterSignals(target, succeed_signals, PROC_REF(on_success))
	if(fail_signals)
		RegisterSignals(target, fail_signals, PROC_REF(on_fail))
	RegisterSignals(parent, list(COMSIG_TRAITOR_OBJECTIVE_COMPLETED, COMSIG_TRAITOR_OBJECTIVE_FAILED), PROC_REF(delete_self))

/datum/component/traitor_objective_register/UnregisterFromParent()
	if(target)
		if(succeed_signals)
			UnregisterSignal(target, succeed_signals)
		if(fail_signals)
			UnregisterSignal(target, fail_signals)
	UnregisterSignal(parent, list(
		COMSIG_TRAITOR_OBJECTIVE_COMPLETED,
		COMSIG_TRAITOR_OBJECTIVE_FAILED
	))

/datum/component/traitor_objective_register/proc/on_fail(datum/traitor_objective/source)
	SIGNAL_HANDLER
	var/datum/traitor_objective/objective = parent
	objective.fail_objective(penalty)

/datum/component/traitor_objective_register/proc/on_success()
	SIGNAL_HANDLER
	var/datum/traitor_objective/objective = parent
	objective.succeed_objective()

/datum/component/traitor_objective_register/proc/delete_self()
	SIGNAL_HANDLER
	qdel(src)
