/datum/computer_file/program/bounty_board
	filename = "赏金板"
	filedesc = "赏金悬赏请求网络"
	downloader_category = PROGRAM_CATEGORY_SUPPLY
	program_open_overlay = "bountyboard"
	extended_desc = "一个用于跨空间站发布悬赏的多平台网络中心，并可以在线支付."
	program_flags = PROGRAM_ON_NTNET_STORE | PROGRAM_REQUIRES_NTNET
	size = 10
	tgui_id = "NtosBountyBoard"
	///Reference to the currently logged in user.
	var/datum/bank_account/current_user
	///The station request datum being affected by UI actions.
	var/datum/station_request/active_request
	///Value of the currently bounty input
	var/bounty_value = 1
	///Text of the currently written bounty
	var/bounty_text = ""
	///Has the app been added to the network yet?
	var/networked = FALSE

/datum/computer_file/program/bounty_board/ui_data(mob/user)
	var/list/data = list()
	var/list/formatted_requests = list()
	var/list/formatted_applicants = list()
	if(current_user)
		data["user"] = list()
		data["user"]["name"] = current_user.account_holder
		if(current_user.account_job)
			data["user"]["job"] = current_user.account_job.title
			data["user"]["department"] = current_user.account_job.paycheck_department
		else
			data["user"]["job"] = "No Job"
			data["user"]["department"] = DEPARTMENT_UNASSIGNED
	else
		data["user"] = list()
		data["user"]["name"] = user.name
		data["user"]["job"] = "N/A"
		data["user"]["department"] = "N/A"
	if(!networked)
		GLOB.allbountyboards += computer
		networked = TRUE
	if(computer.computer_id_slot)
		current_user = computer.computer_id_slot?.registered_account
	for(var/i in GLOB.request_list)
		if(!i)
			continue
		var/datum/station_request/request = i
		formatted_requests += list(list("owner" = request.owner, "value" = request.value, "description" = request.description, "acc_number" = request.req_number))
		if(request.applicants)
			for(var/datum/bank_account/j in request.applicants)
				formatted_applicants += list(list("name" = j.account_holder, "request_id" = request.owner_account.account_id, "requestee_id" = j.account_id))
	if(current_user)
		data["accountName"] = current_user.account_holder
	data["requests"] = formatted_requests
	data["applicants"] = formatted_applicants
	data["bountyValue"] = bounty_value
	data["bountyText"] = bounty_text
	return data

/datum/computer_file/program/bounty_board/ui_act(action, list/params)
	var/current_ref_num = params["request"]
	var/current_app_num = params["applicant"]
	var/datum/bank_account/request_target
	if(current_ref_num)
		for(var/datum/station_request/i in GLOB.request_list)
			if("[i.req_number]" == "[current_ref_num]")
				active_request = i
				break
	if(active_request)
		for(var/datum/bank_account/j in active_request.applicants)
			if("[j.account_id]" == "[current_app_num]")
				request_target = j
				break
	switch(action)
		if("createBounty")
			if(!current_user || !bounty_text)
				playsound(src, 'sound/machines/buzz-sigh.ogg', 20, TRUE)
				return TRUE
			for(var/datum/station_request/i in GLOB.request_list)
				if("[i.req_number]" == "[current_user.account_id]")
					computer.say("账号已有激活委托.")
					return TRUE
			var/datum/station_request/curr_request = new /datum/station_request(current_user.account_holder, bounty_value,bounty_text,current_user.account_id, current_user)
			GLOB.request_list += list(curr_request)
			for(var/obj/i in GLOB.allbountyboards)
				i.say("新委托发出!")
				playsound(i.loc, 'sound/effects/cashregister.ogg', 30, TRUE)
			return TRUE
		if("apply")
			if(!current_user)
				computer.say("请先刷有效ID证件.")
				return TRUE
			if(current_user.account_holder == active_request.owner)
				playsound(computer, 'sound/machines/buzz-sigh.ogg', 20, TRUE)
				return TRUE
			active_request.applicants += list(current_user)
		if("payApplicant")
			if(!current_user)
				return
			if(!current_user.has_money(active_request.value) || (current_user.account_holder != active_request.owner))
				playsound(computer, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
				return
			request_target.transfer_money(current_user, active_request.value, "赏金: 委托完成")
			computer.say("已支付[active_request.value]信用点.")
			GLOB.request_list.Remove(active_request)
			return TRUE
		if("clear")
			if(current_user)
				current_user = null
				computer.say("账户重置.")
				return TRUE
		if("deleteRequest")
			if(!current_user)
				playsound(computer, 'sound/machines/buzz-sigh.ogg', 20, TRUE)
				return TRUE
			if(active_request.owner != current_user.account_holder)
				playsound(computer, 'sound/machines/buzz-sigh.ogg', 20, TRUE)
				return TRUE
			computer.say("取消当前委托.")
			GLOB.request_list.Remove(active_request)
			return TRUE
		if("bountyVal")
			bounty_value = text2num(params["bountyval"])
			if(!bounty_value)
				bounty_value = 1
			return TRUE
		if("bountyText")
			bounty_text = (params["bountytext"])
	return TRUE
