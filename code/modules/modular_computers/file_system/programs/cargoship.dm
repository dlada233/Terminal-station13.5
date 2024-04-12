/datum/computer_file/program/shipping
	filename = "shipping"
	filedesc = "宏舟出口器"
	downloader_category = PROGRAM_CATEGORY_SUPPLY
	program_open_overlay = "shipping"
	extended_desc = "一个集成印花/扫描一体的应用程序，使设备能够打印便于扫描和运输的条形码."
	size = 6
	tgui_id = "NtosShipping"
	program_icon = "tags"
	///Account used for creating barcodes.
	var/datum/bank_account/payments_acc
	///The person who tagged this will receive the sale value multiplied by this number.
	var/cut_multiplier = 0.5
	///Maximum value for cut_multiplier.
	var/cut_max = 0.5
	///Minimum value for cut_multiplier.
	var/cut_min = 0.01

/datum/computer_file/program/shipping/ui_data(mob/user)
	var/list/data = list()

	data["has_id_slot"] = !!computer.computer_id_slot
	data["paperamt"] = "[computer.stored_paper] / [computer.max_paper]"
	data["card_owner"] = computer.computer_id_slot || "未插卡."
	data["current_user"] = payments_acc ? payments_acc.account_holder : null
	data["barcode_split"] = cut_multiplier * 100
	return data

/datum/computer_file/program/shipping/ui_act(action, list/params)
	if(!computer.computer_id_slot) //We need an ID to successfully run
		return FALSE

	switch(action)
		if("ejectid")
			computer.RemoveID(usr)
		if("selectid")
			if(!computer.computer_id_slot.registered_account)
				playsound(get_turf(computer.ui_host()), 'sound/machines/buzz-sigh.ogg', 50, TRUE, -1)
				return TRUE
			payments_acc = computer.computer_id_slot.registered_account
			playsound(get_turf(computer.ui_host()), 'sound/machines/ping.ogg', 50, TRUE, -1)
		if("resetid")
			payments_acc = null
		if("setsplit")
			var/potential_cut = input("您想在登记卡上支付多少钱?","利润率([round(cut_min*100)]% - [round(cut_max*100)]%)") as num|null
			cut_multiplier = potential_cut ? clamp(round(potential_cut/100, cut_min), cut_min, cut_max) : initial(cut_multiplier)
		if("print")
			if(computer.stored_paper <= 0)
				to_chat(usr, span_notice("打印机没纸了."))
				return TRUE
			if(!payments_acc)
				to_chat(usr, span_notice("Software error: 请先设置当前用户."))
				return TRUE
			var/obj/item/barcode/barcode = new /obj/item/barcode(get_turf(computer.ui_host()))
			barcode.payments_acc = payments_acc
			barcode.cut_multiplier = cut_multiplier
			computer.stored_paper--
			to_chat(usr, span_notice("计算机打印出了条形码."))
