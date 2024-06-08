/// Datum which manages references to things we are instructed to destroy
GLOBAL_DATUM_INIT(objective_machine_handler, /datum/objective_target_machine_handler, new())

/// Marks a machine as a possible traitor sabotage target
/proc/add_sabotage_machine(source, typepath)
	LAZYADD(GLOB.objective_machine_handler.machine_instances_by_path[typepath], source)
	return typepath

/// Traitor objective to destroy a machine the crew cares about
/datum/traitor_objective_category/sabotage_machinery
	name = "破坏工作场所"
	objectives = list(
		/datum/traitor_objective/sabotage_machinery/trap = 1,
		/datum/traitor_objective/sabotage_machinery/destroy = 1,
	)

/datum/traitor_objective/sabotage_machinery
	name = "破坏 %MACHINE%"
	description = "Abstract objective holder which shouldn't appear in your uplink."
	abstract_type = /datum/traitor_objective/sabotage_machinery

	/// The maximum amount of this type of objective a traitor can have, set to 0 for no limit.
	var/maximum_allowed = 0
	/// The possible target machinery and the jobs tied to each one.
	var/list/applicable_jobs = list()
	/// The chosen job. Used to check for duplicates
	var/chosen_job

/datum/traitor_objective/sabotage_machinery/can_generate_objective(datum/mind/generating_for, list/possible_duplicates)
	if(!maximum_allowed)
		return TRUE
	if(length(possible_duplicates) >= maximum_allowed)
		return FALSE
	return TRUE

/datum/traitor_objective/sabotage_machinery/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	var/list/possible_jobs = applicable_jobs.Copy()
	for(var/datum/traitor_objective/sabotage_machinery/objective as anything in possible_duplicates)
		possible_jobs -= objective.chosen_job
	for(var/available_job in possible_jobs)
		var/job_machine_path = possible_jobs[available_job]
		if (!length(GLOB.objective_machine_handler.machine_instances_by_path[job_machine_path]))
			possible_jobs -= available_job
	if(!length(possible_jobs))
		return FALSE

	chosen_job = pick(possible_jobs)
	var/list/obj/machinery/possible_machines = GLOB.objective_machine_handler.machine_instances_by_path[possible_jobs[chosen_job]]
	for(var/obj/machinery/machine as anything in possible_machines)
		prepare_machine(machine)

	replace_in_name("%JOB%", lowertext(chosen_job))
	replace_in_name("%MACHINE%", possible_machines[1].name)
	return TRUE

/// Marks a given machine as our target
/datum/traitor_objective/sabotage_machinery/proc/prepare_machine(obj/machinery/machine)
	AddComponent(/datum/component/traitor_objective_register, machine, succeed_signals = list(COMSIG_QDELETING))

// Destroy machines which are in annoying locations, are annoying when destroyed, and aren't directly interacted with
/datum/traitor_objective/sabotage_machinery/destroy
	name = "摧毁 %MACHINE%"
	description = "摧毁 %MACHINE% 以造成混乱，扰乱 %JOB% 部门的活动."

	progression_reward = list(5 MINUTES, 10 MINUTES)
	telecrystal_reward = list(3, 4)

	progression_minimum = 15 MINUTES
	progression_maximum = 30 MINUTES

	applicable_jobs = list(
		JOB_STATION_ENGINEER = /obj/machinery/telecomms/hub,
		JOB_SCIENTIST = /obj/machinery/rnd/server,
	)

// Rig machines which are in public locations to explode when interacted with
/datum/traitor_objective/sabotage_machinery/trap
	name = "破坏 %MACHINE%"
	description = "摧毁 %MACHINE% 以造成混乱，扰乱 %JOB% 部门的活动. 如果你有办法让其他船员使用提供给你的诡雷摧毁机器，你将额外获得 %PROGRESSION% 点声望和 %TC% 点TC."

	progression_reward = list(2 MINUTES, 4 MINUTES)
	telecrystal_reward = 0 // Only from completing the bonus objective

	progression_minimum = 0 MINUTES
	progression_maximum = 10 MINUTES

	maximum_allowed = 2
	applicable_jobs = list(
		JOB_CHIEF_ENGINEER = /obj/machinery/rnd/production/protolathe/department/engineering,
		JOB_CHIEF_MEDICAL_OFFICER = /obj/machinery/rnd/production/techfab/department/medical,
		JOB_HEAD_OF_PERSONNEL = /obj/machinery/rnd/production/techfab/department/service,
		JOB_QUARTERMASTER = /obj/machinery/rnd/production/techfab/department/cargo,
		JOB_RESEARCH_DIRECTOR = /obj/machinery/rnd/production/protolathe/department/science,
		JOB_SHAFT_MINER = /obj/machinery/mineral/ore_redemption,
	)

	/// Bonus reward to grant if you booby trap successfully
	var/bonus_tc = 2
	/// Bonus progression to grant if you booby trap successfully
	var/bonus_progression = 5 MINUTES
	/// Have we given out a traitor trap item?
	var/traitor_trapper_given = FALSE

/datum/traitor_objective/sabotage_machinery/trap/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	. = ..()
	if (!.)
		return FALSE

	replace_in_name("%TC%", bonus_tc)
	replace_in_name("%PROGRESSION%", DISPLAY_PROGRESSION(bonus_progression))
	return TRUE

/datum/traitor_objective/sabotage_machinery/trap/prepare_machine(obj/machinery/machine)
	RegisterSignal(machine, COMSIG_TRAITOR_MACHINE_TRAP_TRIGGERED, PROC_REF(sabotage_success))
	return ..()

/// Called when you successfully proc the booby trap, gives a bonus reward
/datum/traitor_objective/sabotage_machinery/trap/proc/sabotage_success(obj/machinery/machine)
	progression_reward += bonus_progression
	telecrystal_reward += bonus_tc
	succeed_objective()

/datum/traitor_objective/sabotage_machinery/trap/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!traitor_trapper_given)
		buttons += add_ui_button("", "按下该按钮爆炸陷阱就会出现在你的手中，你可以把它藏进机器里.", "wifi", "summon_gear")
	return buttons

/datum/traitor_objective/sabotage_machinery/trap/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if("summon_gear")
			if(traitor_trapper_given)
				return
			traitor_trapper_given = TRUE
			var/obj/item/traitor_machine_trapper/tool = new(user.drop_location())
			user.put_in_hands(tool)
			tool.balloon_alert(user, "诡雷出现在你的手中.")
			tool.target_machine_path = applicable_jobs[chosen_job]

/// 一个用在机器上的物品，导致下次有人使用机器时爆炸
/obj/item/traitor_machine_trapper
	name = "可疑装置"
	desc = "它看起来很危险. "
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "boobytrap"

	/// 轻微的爆炸范围，用于伤害使用机器的人
	var/explosion_range = 3
	/// 可以放置这个装置的目标机器类型
	var/obj/machinery/target_machine_path
	/// 部署炸弹所需的时间
	var/deploy_time = 10 SECONDS

/obj/item/traitor_machine_trapper/examine(mob/user)
	. = ..()
	if(!IS_TRAITOR(user))
		return
	if(target_machine_path)
		. += span_notice("这个装置必须通过<b>单击 [initial(target_machine_path.name)]</b> 来放置. 可以用螺丝刀移除. ")
	. += span_notice("记住，你可能会在装置上留下指纹. 处理它时请戴上<b>手套</b>以确保安全！")

/obj/item/traitor_machine_trapper/pre_attack(atom/target, mob/living/user, params)
	. = ..()
	if (. || !istype(target, target_machine_path))
		return
	balloon_alert(user, "正在放置装置...")
	if(!do_after(user, delay = deploy_time, target = src, interaction_key = DOAFTER_SOURCE_PLANTING_DEVICE))
		return TRUE
	target.AddComponent(\
		/datum/component/interaction_booby_trap,\
		additional_triggers = list(COMSIG_ORM_COLLECTED_ORE),\
		on_triggered_callback = CALLBACK(src, PROC_REF(on_triggered)),\
		on_defused_callback = CALLBACK(src, PROC_REF(on_defused)),\
	)
	RegisterSignal(target, COMSIG_QDELETING, GLOBAL_PROC_REF(qdel), src)
	moveToNullspace()
	return TRUE

/// 当安装的陷阱被触发时调用，标记成功
/obj/item/traitor_machine_trapper/proc/on_triggered(atom/machine)
	SEND_SIGNAL(machine, COMSIG_TRAITOR_MACHINE_TRAP_TRIGGERED)
	qdel(src)

/// 当安装的陷阱被解除时调用，从虚空中取回此物品
/obj/item/traitor_machine_trapper/proc/on_defused(atom/machine, mob/defuser, obj/item/tool)
	UnregisterSignal(machine, COMSIG_QDELETING)
	playsound(machine, 'sound/effects/structure_stress/pop3.ogg', 100, vary = TRUE)
	forceMove(get_turf(machine))
	visible_message(span_warning("一个 [src] 从 [machine] 掉了出来！"))

/// 管理我们被指示摧毁的事物的引用的数据
/datum/objective_target_machine_handler
	/// 根据类型路径组织的现有机器实例
	var/list/machine_instances_by_path = list()

/datum/objective_target_machine_handler/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_NEW_MACHINE, PROC_REF(on_machine_created))
	RegisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE, PROC_REF(finalise_valid_targets))

/// 如果需要，将新创建的机器添加到我们的机器列表中
/datum/objective_target_machine_handler/proc/on_machine_created(datum/source, obj/machinery/new_machine)
	SIGNAL_HANDLER
	new_machine.add_as_sabotage_target()

/// 确认添加到列表中的所有内容都是有效目标，然后阻止添加新目标
/datum/objective_target_machine_handler/proc/finalise_valid_targets()
	SIGNAL_HANDLER
	for (var/machine_type in machine_instances_by_path)
		for (var/obj/machinery/machine as anything in machine_instances_by_path[machine_type])
			var/turf/place = get_turf(machine)
			if(!place || !is_station_level(place.z))
				machine_instances_by_path[machine_type] -= machine
				continue
			RegisterSignal(machine, COMSIG_QDELETING, PROC_REF(machine_destroyed))
	UnregisterSignal(SSdcs, COMSIG_GLOB_NEW_MACHINE)

/datum/objective_target_machine_handler/proc/machine_destroyed(atom/machine)
	SIGNAL_HANDLER
	// 由于某些地图帮助子类型，无法直接进行类型路径关联
	for (var/machine_type in machine_instances_by_path)
		machine_instances_by_path[machine_type] -= machine

// 将有效的机器标记为目标，如果添加了新的潜在目标，请在此处添加新的条目

/obj/machinery/telecomms/hub/add_as_sabotage_target()
	return add_sabotage_machine(src, /obj/machinery/telecomms/hub) // 不总是我们的特定类型，因为地图帮助子类型

/obj/machinery/rnd/server/add_as_sabotage_target()
	return add_sabotage_machine(src, type)

/obj/machinery/rnd/production/protolathe/department/add_as_sabotage_target()
	return add_sabotage_machine(src, type)

/obj/machinery/rnd/production/techfab/department/add_as_sabotage_target()
	return add_sabotage_machine(src, type)

/obj/machinery/mineral/ore_redemption/add_as_sabotage_target()
	return add_sabotage_machine(src, type)
