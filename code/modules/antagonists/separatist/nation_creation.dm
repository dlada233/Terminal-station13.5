/**
 * ### create_separatist_nation()
 *
 * 辅助函数，通过使一个部门独立于站点来创建分裂者反派.
 *
 * * 参数:
 * * department: 要反抗的部门. 如果为空，将选择一个随机的非独立部门. 开始为类型，然后变成单例的引用.
 * * announcement: 是否告诉站点一个部门已经独立.
 * * dangerous: 这个国家是否会有攻击其他独立部门的目标，显然需要存在多个国家.
 * * message_admins: 这个函数是否会记录国家的创建情况. 无论如何，错误都会记录在运行时日志中.
 *
 * 返回空.
 */
/proc/create_separatist_nation(datum/job_department/department, announcement = FALSE, dangerous = FALSE, message_admins = TRUE)
	var/list/jobs_to_revolt = list()
	var/list/citizens = list()

	// 已经独立的部门，这些将被禁止随机选择
	var/list/independent_departments = list()
	// 所有独立国家团队的引用
	var/list/team_datums = list()
	for(var/datum/antagonist/separatist/separatist_datum in GLOB.antagonists)
		var/independent_department_type = separatist_datum.owner?.assigned_role.departments_list[1]
		independent_departments |= independent_department_type
		team_datums |= separatist_datum.nation

	if(!department)
		// 如果没有给出部门，随机选择一个部门
		department = pick(list(/datum/job_department/assistant, /datum/job_department/medical, /datum/job_department/engineering, /datum/job_department/science, /datum/job_department/cargo, /datum/job_department/service, /datum/job_department/security) - independent_departments)
		if(!department)
			if(message_admins)
				message_admins("部门叛乱无法创建国家，因为所有部门都是独立的！你已经创建了国家，你这个疯子！")
			CRASH("部门叛乱无法创建国家，因为所有部门都是独立的")
	department = SSjob.get_department_type(department)

	for(var/datum/job/job as anything in department.department_jobs)
		if(job.departments_list.len > 1 && job.departments_list[1] != department.type) // 他们的忠诚在其他部门
			continue
		jobs_to_revolt += job.title

	// 设置团队数据
	var/datum/team/nation/nation = new(null, jobs_to_revolt, department)
	nation.name = department.generate_nation_name()
	var/datum/team/department_target // 避免从空列表中选择引起运行时错误.
	if(team_datums.len)
		department_target = pick(team_datums)
	nation.generate_nation_objectives(dangerous, department_target)

	// 转换部门的当前成员
	for(var/mob/living/possible_separatist in GLOB.player_list)
		if(isnull(possible_separatist.mind))
			continue
		var/datum/mind/separatist_mind = possible_separatist.mind
		if(!(separatist_mind.assigned_role.title in jobs_to_revolt))
			continue
		citizens += possible_separatist
		separatist_mind.add_antag_datum(/datum/antagonist/separatist, nation, department)
		nation.add_member(separatist_mind)
		possible_separatist.log_message("被转变成了分离主义者，[nation.name]万岁！", LOG_ATTACK, color="red")

	// 如果我们没有转换任何人，我们就杀死团队数据，否则清理并正式化
	if(!citizens.len)
		qdel(nation)
		if(message_admins)
			message_admins("国家[nation.name]没有足够的潜在成员来创建. ")
		return
	var/jobs_english_list = english_list(jobs_to_revolt)
	if(message_admins)
		message_admins("国家[nation.name]已经成立. 受影响的职业有[jobs_english_list]. 任何属于这些职业的新船员都将加入分离主义者. ")
	if(announcement)
		var/announce_text = "[nation.name]的新独立国家已经从[department.department_name]部门的废墟中崛起！"
		if(istype(department, /datum/job_department/assistant)) // 这段文本不太对
			announce_text = "空间站的助手们已经崛起，形成了名为[nation.name]的新独立国家！"
		priority_announce(announce_text, "[GLOB.station_name]的分裂",  has_important_message = TRUE)
