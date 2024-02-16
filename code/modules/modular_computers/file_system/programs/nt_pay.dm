/datum/computer_file/program/nt_pay
	filename = "纳米支付"
	filedesc = "纳米支付"
	downloader_category = PROGRAM_CATEGORY_DEVICE
	program_open_overlay = "generic"
	extended_desc = "一个在线支付工具，以便当地管理者帮助转移资金或跟踪你的开支和利润."
	size = 2
	tgui_id = "NtosPay"
	program_icon = "money-bill-wave"
	can_run_on_flags = PROGRAM_ALL
	///Reference to the currently logged in user.
	var/datum/bank_account/current_user
	///Pay token, by which we can send credits
	var/token
	///Amount of credits, which we sends
	var/money_to_send = 0
	///Pay token what we want to find
	var/wanted_token

/datum/computer_file/program/nt_pay/ui_act(action, list/params, datum/tgui/ui)
	switch(action)
		if("Transaction")
			if(IS_DEPARTMENTAL_ACCOUNT(current_user))
				return to_chat(usr, span_notice("该卡不支持提现."))

			token = params["令牌"]
			money_to_send = params["数额"]
			var/datum/bank_account/recipient
			if(!token)
				return to_chat(usr, span_notice("请输入收款人的支付令牌."))
			if(!money_to_send)
				return to_chat(usr, span_notice("请输入转账金额."))
			if(token == current_user.pay_token)
				return to_chat(usr, span_notice("无法给自己转账."))

			for(var/account as anything in SSeconomy.bank_accounts_by_id)
				var/datum/bank_account/acc = SSeconomy.bank_accounts_by_id[account]
				if(acc.pay_token == token)
					recipient = acc
					break

			if(!recipient)
				return to_chat(usr, span_notice("应用未找到转账对象，请确认输入的支付令牌是否正确."))
			if(!current_user.has_money(money_to_send) || money_to_send < 1)
				return current_user.bank_card_talk("余额不足.")

			recipient.bank_card_talk("您收到了 [money_to_send] 点信用点，原因:转账自[current_user.account_holder]")
			recipient.transfer_money(current_user, money_to_send)
			current_user.bank_card_talk("您将 [money_to_send] 信用点转至 [recipient.account_holder].当前您的余额为 [current_user.account_balance] 信用点.")

		if("GetPayToken")
			wanted_token = null
			for(var/account in SSeconomy.bank_accounts_by_id)
				var/datum/bank_account/acc = SSeconomy.bank_accounts_by_id[account]
				if(acc.account_holder == params["wanted_name"])
					wanted_token = "令牌: [acc.pay_token]"
					break
			if(!wanted_token)
				return wanted_token = "账户 \"[params["wanted_name"]]\" 不存在."



/datum/computer_file/program/nt_pay/ui_data(mob/user)
	var/list/data = list()

	current_user = computer.computer_id_slot?.registered_account || null
	if(!current_user)
		data["name"] = null
	else
		data["name"] = current_user.account_holder
		data["owner_token"] = current_user.pay_token
		data["money"] = current_user.account_balance
		data["wanted_token"] = wanted_token
		data["transaction_list"] = current_user.transaction_history

	return data
