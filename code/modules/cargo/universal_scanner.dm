#define PAPER_PER_SHEET 10

/obj/item/universal_scanner
	name = "通用扫码枪"
	desc = "用于根据纳米传讯导出数据库检查对象、分配价格标签或为自定义自动售货机准备商品的设备."
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "export scanner"
	worn_icon_state = "electronic"
	inhand_icon_state = "export_scanner"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	/// Which mode is the scanner currently on?
	var/scanning_mode = SCAN_EXPORTS
	/// A list of all available export scanner modes.
	var/list/scale_mode = list()
	/// The paper currently stored by the export scanner.
	var/paper_count = 10
	/// The maximum paper to be stored by the export scanner.
	var/max_paper_count = 20

	/// The price of the item used by price tagger mode.
	var/new_custom_price = 1

	/// The account which is receiving the split profits in sales tagger mode.
	var/datum/bank_account/payments_acc = null
	/// The person who tagged this will receive the sale value multiplied by this number in sales tagger mode.
	var/cut_multiplier = 0.5
	/// Maximum value for cut_multiplier in sales tagger mode.
	var/cut_max = 0.5
	/// Minimum value for cut_multiplier in sales tagger mode.
	var/cut_min = 0.01

/obj/item/universal_scanner/Initialize(mapload)
	. = ..()
	scale_mode = sort_list(list(
		"export scanner" = image(icon = src.icon, icon_state = "export scanner"),
		"price tagger" = image(icon = src.icon, icon_state = "price tagger"),
		"sales tagger" = image(icon = src.icon, icon_state = "sales tagger"),
))
	register_context()

/obj/item/universal_scanner/attack_self(mob/user, modifiers)
	. = ..()
	var/choice = show_radial_menu(user, src, scale_mode, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
	if(!choice)
		return FALSE
	if(icon_state == "[choice]")
		return FALSE
	switch(choice)
		if("export scanner")
			scanning_mode = SCAN_EXPORTS
		if("price tagger")
			scanning_mode = SCAN_PRICE_TAG
		if("sales tagger")
			scanning_mode = SCAN_SALES_TAG
	icon_state = "[choice]"
	playsound(src, 'sound/machines/click.ogg', 40, TRUE)

/obj/item/universal_scanner/afterattack(obj/object, mob/user, proximity)
	. = ..()
	if(!istype(object) || !proximity)
		return
	. |= AFTERATTACK_PROCESSED_ITEM
	if(scanning_mode == SCAN_EXPORTS)
		export_scan(object, user)
		return .
	if(scanning_mode == SCAN_PRICE_TAG)
		price_tag(target = object, user = user)
	return .

/obj/item/universal_scanner/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(scanning_mode == SCAN_SALES_TAG && isidcard(attacking_item))
		var/obj/item/card/id/potential_acc = attacking_item
		if(potential_acc.registered_account)
			if(payments_acc == potential_acc.registered_account)
				to_chat(user, span_notice("ID卡已登记."))
				return
			else
				payments_acc = potential_acc.registered_account
				playsound(src, 'sound/machines/ping.ogg', 40, TRUE)
				to_chat(user, span_notice("[src]登记了ID卡，标记包装物品以创建条形码."))
		else if(!potential_acc.registered_account)
			to_chat(user, span_warning("这张ID卡没有账户."))
			return
	if(istype(attacking_item, /obj/item/paper))
		if (!(paper_count >= max_paper_count))
			paper_count += PAPER_PER_SHEET
			qdel(attacking_item)
			if (paper_count >= max_paper_count)
				paper_count = max_paper_count
				to_chat(user, span_notice("[src]的纸库已满."))
				return
			to_chat(user, span_notice("你重新填充了[src]的纸库, 当前剩下[paper_count]张."))
		else
			to_chat(user, span_notice("[src]的纸张库已满."))

/obj/item/universal_scanner/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(scanning_mode == SCAN_SALES_TAG)
		if(paper_count <= 0)
			to_chat(user, span_warning("没有纸了!."))
			return
		if(!payments_acc)
			to_chat(user, span_warning("你需要先用ID卡刷一下[src]."))
			return
		paper_count--
		playsound(src, 'sound/machines/click.ogg', 40, TRUE)
		to_chat(user, span_notice("你打印了一个新的条形码."))
		var/obj/item/barcode/new_barcode = new /obj/item/barcode(src)
		new_barcode.payments_acc = payments_acc		// The sticker gets the scanner's registered account.
		new_barcode.cut_multiplier = cut_multiplier		// Also the registered percent cut.
		user.put_in_hands(new_barcode)
	if(scanning_mode == SCAN_PRICE_TAG)
		if(loc != user)
			to_chat(user, span_warning("您必须保持[src]才能继续!"))
			return
		var/chosen_price = tgui_input_number(user, "标定价格", "价格", new_custom_price)
		if(!chosen_price || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH) || loc != user)
			return
		new_custom_price = chosen_price
		to_chat(user, span_notice("[src]现在会给货物一个[new_custom_price]cr的价格标签."))

/obj/item/universal_scanner/CtrlClick(mob/user)
	. = ..()
	if(scanning_mode == SCAN_SALES_TAG)
		payments_acc = null
		to_chat(user, span_notice("你清除了注册账户."))

/obj/item/universal_scanner/click_alt(mob/user)
	if(!scanning_mode == SCAN_SALES_TAG)
		return CLICK_ACTION_BLOCKING
	var/potential_cut = input("在注册的卡上支付多少钱？","利润率 ([round(cut_min*100)]% - [round(cut_max*100)]%)") as num|null
	if(!potential_cut)
		cut_multiplier = initial(cut_multiplier)
	cut_multiplier = clamp(round(potential_cut/100, cut_min), cut_min, cut_max)
	to_chat(user, span_notice("[round(cut_multiplier*100)]% 如果销售带有条形码的货物，将获得利润."))
	return CLICK_ACTION_SUCCESS

/obj/item/universal_scanner/examine(mob/user)
	. = ..()
	. += span_notice("它有[paper_count]/[max_paper_count]张可用的条形码，可补充纸张.")

	if(scanning_mode == SCAN_SALES_TAG)
		. += span_notice("销售利润分成当先设置为[round(cut_multiplier*100)]%. <b>Alt加左键</b>来更改.")
		if(payments_acc)
			. += span_notice("<b>Ctrl加左键</b>来清除注册账户.")

	if(scanning_mode == SCAN_PRICE_TAG)
		. += span_notice("当前自定义价格被设置为[new_custom_price]cr. <b>右键</b>来更改.")

/obj/item/universal_scanner/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	switch(scanning_mode)
		if(SCAN_SALES_TAG)
			context[SCREENTIP_CONTEXT_LMB] = "标签包装"
			context[SCREENTIP_CONTEXT_ALT_LMB] = "更改价格"
			context[SCREENTIP_CONTEXT_CTRL_LMB] = "清空目标账户"
			context[SCREENTIP_CONTEXT_ALT_LMB] = "更改支付 %"
		if(SCAN_PRICE_TAG)
			context[SCREENTIP_CONTEXT_LMB] = "价格物品"
			context[SCREENTIP_CONTEXT_RMB] = "标定价格"
		if(SCAN_EXPORTS)
			context[SCREENTIP_CONTEXT_LMB] = "扫描出口价值"
	return CONTEXTUAL_SCREENTIP_SET
/**
 * Scans an object, target, and provides it's export value based on selling to the cargo shuttle, to mob/user.
 */
/obj/item/universal_scanner/proc/export_scan(obj/target, mob/user)
	var/datum/export_report/report = export_item_and_contents(target, dry_run = TRUE)
	var/price = 0
	for(var/exported_datum in report.total_amount)
		price += report.total_value[exported_datum]

	var/message = "已扫描[target]"
	var/warning = FALSE
	if(length(target.contents))
		message = "已扫描[target]及其内容."
		if(price)
			message += ", 总价值: <b>[price]</b>cr"
		else
			message += ", 无出口价值"
			warning = TRUE
		if(!report.all_contents_scannable)
			message += " (检测到波动价格，最终实际值可能有所出入)"
		message += "."
	else
		if(!report.all_contents_scannable)
			message += ", 无法确定价值."
			warning = TRUE
		else if(price)
			message += ", 价值: <b>[price]</b>cr."
		else
			message += ", 无出口价值."
			warning = TRUE
	if(warning)
		to_chat(user, span_warning(message))
	else
		to_chat(user, span_notice(message))

	if(price)
		playsound(src, 'sound/machines/terminal_select.ogg', 50, vary = TRUE)

	if(istype(target, /obj/item/delivery))
		var/obj/item/delivery/parcel = target
		if(!parcel.sticker)
			return
		var/obj/item/barcode/our_code = parcel.sticker
		to_chat(user, span_notice("检测到出口条形码! 该货物出口时，将支付到[our_code.payments_acc.account_holder], \
			以[our_code.cut_multiplier * 100]%比例(已反映在上述记录值中)."))

	if(istype(target, /obj/item/barcode))
		var/obj/item/barcode/our_code = target
		to_chat(user, span_notice("检测到出口条形码! 该货物出口时，将支付到[our_code.payments_acc.account_holder], \
			以[our_code.cut_multiplier * 100]%比例."))

	if(ishuman(user))
		var/mob/living/carbon/human/scan_human = user
		if(istype(target, /obj/item/bounty_cube))
			var/obj/item/bounty_cube/cube = target
			var/datum/bank_account/scanner_account = scan_human.get_bank_account()

			if(!istype(get_area(cube), /area/shuttle/supply))
				to_chat(user, span_warning("未检测到货船位置，处理提示未登记."))

			else if(cube.bounty_handler_account)
				to_chat(user, span_warning("用于处理小费的银行账户已注册"))

			else if(scanner_account)
				cube.AddComponent(/datum/component/pricetag, scanner_account, cube.handler_tip, FALSE)

				cube.bounty_handler_account = scanner_account
				cube.bounty_handler_account.bank_card_talk("Bank account for [price ? "<b>[price * cube.handler_tip]</b> credit " : ""]handling tip successfully registered.")

				if(cube.bounty_holder_account != cube.bounty_handler_account) //No need to send a tracking update to the person scanning it
					cube.bounty_holder_account.bank_card_talk("<b>[cube]</b> was scanned in \the <b>[get_area(cube)]</b> by <b>[scan_human] ([scan_human.job])</b>.")

			else
				to_chat(user, span_warning("未检测到银行账户，请注册小费账户."))

/**
 * Scans an object, target, and sets it's custom_price variable to new_custom_price, presenting it to the user.
 */
/obj/item/universal_scanner/proc/price_tag(obj/target, mob/user)
	if(isitem(target))
		var/obj/item/selected_target = target
		selected_target.custom_price = new_custom_price
		to_chat(user, span_notice("You set the price of [selected_target] to [new_custom_price] cr."))

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 */
/obj/item/universal_scanner/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/barcode
	name = "条形码"
	desc = "一个小标签，与船员的银行账户关联.用于附在包装项目上，将包装项目的一部分利润分给该账户."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "barcode"
	w_class = WEIGHT_CLASS_TINY
	//All values inherited from the sales tagger it came from.
	///The bank account assigned to pay out to from the sales tagger.
	var/datum/bank_account/payments_acc = null
	///The percentage of profit to give to the payments_acc, from 0 to 1.
	var/cut_multiplier = 0.5

#undef PAPER_PER_SHEET
