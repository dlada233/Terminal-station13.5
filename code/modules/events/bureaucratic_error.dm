/datum/round_event_control/bureaucratic_error
	name = "Bureaucratic Error-行政失误"
	typepath = /datum/round_event/bureaucratic_error
	max_occurrences = 1
	weight = 5
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "随机增设或削减职位数量，同时更改溢出角色"

/datum/round_event/bureaucratic_error
	announce_when = 1

/datum/round_event/bureaucratic_error/announce(fake)
	priority_announce("最近人力资源部的一个行政错误可能导致一些部门人员冗余或短缺.", "行政事故警报")

/datum/round_event/bureaucratic_error/start()
	var/list/jobs = SSjob.get_valid_overflow_jobs()
	/* SKYRAT EDIT REMOVAL START
	if(prob(33)) // Only allows latejoining as a single role.
		var/datum/job/overflow = pick_n_take(jobs)
		overflow.spawn_positions = -1
		overflow.total_positions = -1 // Ensures infinite slots as this role. Assistant will still be open for those that cant play it.
		for(var/job in jobs)
			var/datum/job/current = job
			current.total_positions = 0
		return
	*/ // SKYRAT EDIT REMOVAL - no more locking off jobs
	// Adds/removes a random amount of job slots from all jobs.
	for(var/datum/job/current as anything in jobs)
		current.total_positions = max(current.total_positions + rand(-2,4), 1) // SKYRAT EDIT CHANGE - No more locking off jobs - ORIGINAL: current.total_positions = max(current.total_positions + rand(-2,4), 0)
