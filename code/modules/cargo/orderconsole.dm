/obj/machinery/computer/cargo
	name = "供应控制台"
	desc = "用来订购物资，批准请购，控制穿梭机."
	icon_screen = "supply"
	circuit = /obj/item/circuitboard/computer/cargo
	light_color = COLOR_BRIGHT_ORANGE

	///Can the supply console send the shuttle back and forth? Used in the UI backend.
	var/can_send = TRUE
	///Can this console only send requests?
	var/requestonly = FALSE
	///Can you approve requests placed for cargo? Works differently between the app and the computer.
	var/can_approve_requests = TRUE
	var/contraband = FALSE
	var/self_paid = FALSE
	var/safety_warning = "出于安全与道德因素，货运穿梭机上禁止运送活体生物、人体遗骸、机密核武器、邮件、未送达的部门订购箱、辛迪加炸弹、追踪信标、不稳定物质、传真机以及任何包含人工智能的机器."
	var/blockade_warning = "检测到蓝空不稳定.穿梭机无法航行."
	/// radio used by the console to send messages on supply channel
	var/obj/item/radio/headset/radio
	/// var that tracks message cooldown
	var/message_cooldown
	var/list/loaded_coupons
	/// var that makes express console use rockets
	var/is_express = FALSE
	///The name of the shuttle template being used as the cargo shuttle. 'cargo' is default and contains critical code. Don't change this unless you know what you're doing.
	var/cargo_shuttle = "cargo"
	///The docking port called when returning to the station.
	var/docking_home = "cargo_home"
	///The docking port called when leaving the station.
	var/docking_away = "cargo_away"
	///If this console can loan the cargo shuttle. Set to false to disable.
	var/stationcargo = TRUE
	///The account this console processes and displays. Independent from the account the shuttle processes.
	var/cargo_account = ACCOUNT_CAR
	///Interface name for the ui_interact call for different subtypes.
	var/interface_type = "Cargo"

/obj/machinery/computer/cargo/request
	name = "供应请购控制台"
	desc = "用来向货舱请购物资."
	icon_screen = "request"
	circuit = /obj/item/circuitboard/computer/cargo/request
	can_send = FALSE
	can_approve_requests = FALSE
	requestonly = TRUE

/obj/machinery/computer/cargo/Initialize(mapload)
	. = ..()
	radio = new /obj/item/radio/headset/headset_cargo(src)

/obj/machinery/computer/cargo/Destroy()
	QDEL_NULL(radio)
	return ..()

/obj/machinery/computer/cargo/attacked_by(obj/item/I, mob/living/user)
	if(istype(I,/obj/item/trade_chip))
		var/obj/item/trade_chip/contract = I
		contract.try_to_unlock_contract(user)
		return TRUE
	else
		return ..()

/obj/machinery/computer/cargo/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	if(user)
		if (emag_card)
			user.visible_message(span_warning("[user]在[src]上刷了[emag_card]!"))
		to_chat(user, span_notice("你调整了[src]的路由和接收频谱,解锁了特供物资和违禁品."))

	obj_flags |= EMAGGED
	contraband = TRUE

	// This also permanently sets this on the circuit board
	var/obj/item/circuitboard/computer/cargo/board = circuit
	board.contraband = TRUE
	board.obj_flags |= EMAGGED
	update_static_data(user)
	return TRUE

/obj/machinery/computer/cargo/on_construction(mob/user)
	. = ..()
	circuit.configure_machine(src)

/obj/machinery/computer/cargo/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface_type, name)
		ui.open()

/obj/machinery/computer/cargo/ui_data()
	var/list/data = list()
	data["department"] = "Cargo" // Hardcoded here, for customization in budgetordering.dm AKA NT IRN
	data["location"] = SSshuttle.supply.getStatusText()
	var/datum/bank_account/D = SSeconomy.get_dep_account(cargo_account)
	if(D)
		data["points"] = D.account_balance
	data["grocery"] = SSshuttle.chef_groceries.len
	data["away"] = SSshuttle.supply.getDockedId() == docking_away
	data["self_paid"] = self_paid
	data["docked"] = SSshuttle.supply.mode == SHUTTLE_IDLE
	data["loan"] = !!SSshuttle.shuttle_loan
	data["loan_dispatched"] = SSshuttle.shuttle_loan && SSshuttle.shuttle_loan.dispatched
	data["can_send"] = can_send
	data["can_approve_requests"] = can_approve_requests
	var/message = "记得盖上邮票并寄回货单."
	if(SSshuttle.centcom_message)
		message = SSshuttle.centcom_message
	if(SSshuttle.supply_blocked)
		message = blockade_warning
	data["message"] = message

	var/list/amount_by_name = list()
	var/cart_list = list()
	for(var/datum/supply_order/order in SSshuttle.shopping_list)
		if(cart_list[order.pack.name])
			amount_by_name[order.pack.name] += 1
			cart_list[order.pack.name][1]["amount"]++
			cart_list[order.pack.name][1]["cost"] += order.get_final_cost()
			if(order.department_destination)
				cart_list[order.pack.name][1]["dep_order"]++
			if(!isnull(order.paying_account))
				cart_list[order.pack.name][1]["paid"]++
			continue

		amount_by_name[order.pack.name] += 1
		cart_list[order.pack.name] = list(list(
			"cost_type" = order.cost_type,
			"object" = order.pack.name,
			"cost" = order.get_final_cost(),
			"id" = order.id,
			"amount" = 1,
			"orderer" = order.orderer,
			"paid" = !isnull(order.paying_account) ? 1 : 0, //number of orders purchased privatly
			"dep_order" = order.department_destination ? 1 : 0, //number of orders purchased by a department
			"can_be_cancelled" = order.can_be_cancelled,
		))
	data["cart"] = list()
	for(var/item_id in cart_list)
		data["cart"] += cart_list[item_id]


	data["requests"] = list()
	for(var/datum/supply_order/order in SSshuttle.request_list)
		var/datum/supply_pack/pack = order.pack
		amount_by_name[pack.name] += 1
		data["requests"] += list(list(
			"object" = pack.name,
			"cost" = pack.get_cost(),
			"orderer" = order.orderer,
			"reason" = order.reason,
			"id" = order.id,
		))
	data["amount_by_name"] = amount_by_name

	return data

/obj/machinery/computer/cargo/ui_static_data(mob/user)
	var/list/data = list()
	data["max_order"] = CARGO_MAX_ORDER
	data["supplies"] = list()
	for(var/pack in SSshuttle.supply_packs)
		var/datum/supply_pack/P = SSshuttle.supply_packs[pack]
		if(!data["supplies"][P.group])
			data["supplies"][P.group] = list(
				"name" = P.group,
				"packs" = list()
			)
		if((P.hidden && !(obj_flags & EMAGGED)) || (P.contraband && !contraband) || (P.special && !P.special_enabled) || P.drop_pod_only)
			continue
		data["supplies"][P.group]["packs"] += list(list(
			"name" = P.name,
			"cost" = P.get_cost(),
			"id" = pack,
			"desc" = P.desc || P.name, // If there is a description, use it. Otherwise use the pack's name.
			"goody" = P.goody,
			"access" = P.access,
		))
	return data

/**
 * adds an supply pack to the checkout cart
 * * user - the mobe doing this order
 * * id - the type of pack to order
 * * amount - the amount to order. You may not order more then 10 things at once
 */
/obj/machinery/computer/cargo/proc/add_item(mob/user, id, amount = 1)
	if(is_express)
		return
	id = text2path(id) || id
	var/datum/supply_pack/pack = SSshuttle.supply_packs[id]
	if(!istype(pack))
		CRASH("Unknown supply pack id given by order console ui. ID: [id]")
	if(amount > CARGO_MAX_ORDER || amount < 1) // Holy shit fuck off
		CRASH("Invalid amount passed into add_item")
	if((pack.hidden && !(obj_flags & EMAGGED)) || (pack.contraband && !contraband) || pack.drop_pod_only || (pack.special && !pack.special_enabled))
		return

	var/name = "*None Provided*"
	var/rank = "*None Provided*"
	var/ckey = user.ckey
	if(ishuman(user))
		var/mob/living/carbon/human/human = user
		name = human.get_authentification_name()
		rank = human.get_assignment(hand_first = TRUE)
	else if(HAS_SILICON_ACCESS(user))
		name = user.real_name
		rank = "Silicon"

	var/datum/bank_account/account
	if(self_paid && isliving(user))
		var/mob/living/living_user = user
		var/obj/item/card/id/id_card = living_user.get_idcard(TRUE)
		if(!istype(id_card))
			say("未检测到ID卡.")
			return
		if(IS_DEPARTMENTAL_CARD(id_card))
			say("[id_card]不能用于购物.")
			return
		account = id_card.registered_account
		if(!istype(account))
			say("无效银行账户.")
			return
		var/list/access = id_card.GetAccess()
		if(pack.access_view && !(pack.access_view in access))
			say("[id_card]缺少订购所需权限.")
			return

	// The list we are operating on right now
	var/list/working_list = SSshuttle.shopping_list
	var/reason = ""
	if(requestonly && !self_paid)
		working_list = SSshuttle.request_list
		reason = tgui_input_text(user, "理由", name)
		if(isnull(reason))
			return

	if(pack.goody && !self_paid)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		say("错误: 小商品仅限私人账户订购.")
		return

	var/similar_count = SSshuttle.supply.get_order_count(pack)
	if(similar_count == OVER_ORDER_LIMIT)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		say("错误: 单次订购数量不得超过[CARGO_MAX_ORDER]")
		return

	amount = clamp(amount, 1, CARGO_MAX_ORDER - similar_count)
	for(var/count in 1 to amount)
		var/obj/item/coupon/applied_coupon
		for(var/obj/item/coupon/coupon_check in loaded_coupons)
			if(pack.type == coupon_check.discounted_pack)
				say("检测到优惠券，已为您的订单优惠[round(coupon_check.discount_pct_off * 100)]% !")
				coupon_check.moveToNullspace()
				applied_coupon = coupon_check
				break

		var/datum/supply_order/order = new(
			pack = pack ,
			orderer = name,
			orderer_rank = rank,
			orderer_ckey = ckey,
			reason = reason,
			paying_account = account,
			coupon = applied_coupon,
			charge_on_purchase = TRUE, // SKYRAT EDIT ADDITION
		)
		working_list += order

	if(self_paid)
		say("订单已处理。费用将从[account.account_holder]的银行账户中扣除.")
	if(requestonly && message_cooldown < world.time)
		var/message = amount == 1 ? "有新的订单请购." : "有[amount]件新的订单请购."
		radio.talk_into(src, message, RADIO_CHANNEL_SUPPLY)
		message_cooldown = world.time + 30 SECONDS
	. = TRUE

/**
 * removes an item from the checkout cart
 * * id - the id of the cart item to remove
 */
/obj/machinery/computer/cargo/proc/remove_item(id)
	for(var/datum/supply_order/order in SSshuttle.shopping_list)
		if(order.id != id)
			continue
		if(order.department_destination)
			say("只有订购该物品的部门才能取消订单.")
			return FALSE
		if(order.applied_coupon)
			say("优惠券已退回.")
			order.applied_coupon.forceMove(get_turf(src))
		SSshuttle.shopping_list -= order
		qdel(order)
		return TRUE
	return FALSE
/**
 * maps the ordename displayed on the ui to its supply pack id
 * * order_name - the name of the order
 */
/obj/machinery/computer/cargo/proc/name_to_id(order_name)
	for(var/pack in SSshuttle.supply_packs)
		var/datum/supply_pack/supply = SSshuttle.supply_packs[pack]
		if(order_name == supply.name)
			return pack
	return null

/obj/machinery/computer/cargo/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("send")
			if(!SSshuttle.supply.canMove())
				say(safety_warning)
				return
			if(SSshuttle.supply_blocked)
				say(blockade_warning)
				return

			if(SSshuttle.supply.getDockedId() == docking_home)
				SSshuttle.moveShuttle(cargo_shuttle, docking_away, TRUE)
				say("货运穿梭机即将出发.")
				ui.user.investigate_log("货运穿梭机已派遣.", INVESTIGATE_CARGO)
			else
				//create the paper from the SSshuttle.shopping_list
				if(length(SSshuttle.shopping_list))
					var/obj/item/paper/requisition_paper = new(get_turf(src))
					requisition_paper.name = "申请表 - [station_time_timestamp()]"
					var/requisition_text = "<h2>[station_name()]货运申请</h2>"
					requisition_text += "<hr/>"
					requisition_text += "订购时间: [station_time_timestamp()]<br/><br/>"
					for(var/datum/supply_order/order as anything in SSshuttle.shopping_list)
						requisition_text += "<b>[order.pack.name]</b></br>"
						requisition_text += "- 订单 ID: [order.id]</br>"
						var/restrictions = SSid_access.get_access_desc(order.pack.access)
						if(restrictions)
							requisition_text += "- 访问限制: [restrictions]</br>"
						requisition_text += "- 订购人: [order.orderer] ([order.orderer_rank])</br>"
						var/paying_account = order.paying_account
						if(paying_account)
							requisition_text += "- 私人订购付款: [order.paying_account.account_holder]<br/>"
						var/reason = order.reason
						if(reason)
							requisition_text += "- 订购理由: [reason]</br>"
						requisition_text += "</br></br>"
					requisition_paper.add_raw_text(requisition_text)
					requisition_paper.color = "#9ef5ff"
					requisition_paper.update_appearance()

				ui.user.investigate_log("呼叫货运穿梭机.", INVESTIGATE_CARGO)
				say("已呼叫货运穿梭机,将在[SSshuttle.supply.timeLeft(600)]分钟内抵达.")
				SSshuttle.moveShuttle(cargo_shuttle, docking_home, TRUE)

			. = TRUE
		if("loan")
			if(!SSshuttle.shuttle_loan)
				return
			if(SSshuttle.supply_blocked)
				say(blockade_warning)
				return
			else if(SSshuttle.supply.mode != SHUTTLE_IDLE)
				return
			else if(SSshuttle.supply.getDockedId() != docking_away)
				return
			else if(stationcargo != TRUE)
				return
			else
				SSshuttle.shuttle_loan.loan_shuttle()
				say("货运穿梭机已借给中央指挥部使用.")
				ui.user.investigate_log("已接受穿梭机租借项目.", INVESTIGATE_CARGO)
				ui.user.log_message("已接受穿梭机租借项目.", LOG_GAME)
				. = TRUE
		if("add")
			return add_item(ui.user, params["id"])
		if("add_by_name")
			var/supply_pack_id = name_to_id(params["order_name"])
			if(!supply_pack_id)
				return
			return add_item(ui.user, supply_pack_id)
		if("remove")
			var/order_name = params["order_name"]
			//try removing atleast one item with the specified name. An order may not be removed if it was from the department
			for(var/datum/supply_order/order in SSshuttle.shopping_list)
				if(order.pack.name != order_name)
					continue
				if(remove_item(order.id))
					return TRUE

			return TRUE
		if("modify")
			var/order_name = params["order_name"]

			//clear out all orders with the above mentioned order_name name to make space for the new amount
			for(var/datum/supply_order/order in SSshuttle.shopping_list) //find corresponding order id for the order name
				if(order.pack.name == order_name)
					remove_item(order.id)

			//now add the new amount stuff
			var/amount = text2num(params["amount"])
			if(amount == 0)
				return TRUE
			if(amount > CARGO_MAX_ORDER)
				return
			var/supply_pack_id = name_to_id(order_name) //map order name to supply pack id for adding
			if(!supply_pack_id)
				return
			return add_item(ui.user, supply_pack_id, amount)
		if("clear")
			//create copy of list else we will get runtimes when iterating & removing items on the same list SSshuttle.shopping_list
			var/list/shopping_cart = SSshuttle.shopping_list.Copy()
			for(var/datum/supply_order/cancelled_order in shopping_cart)
				if(cancelled_order.department_destination || !cancelled_order.can_be_cancelled)
					continue //don't cancel other department's orders or orders that can't be cancelled
				remove_item(cancelled_order.id) //remove & properly refund any coupons attached with this order
		if("approve")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SSshuttle.request_list)
				if(SO.id == id)
					SSshuttle.request_list -= SO
					SSshuttle.shopping_list += SO
					. = TRUE
					break
		if("deny")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SSshuttle.request_list)
				if(SO.id == id)
					SSshuttle.request_list -= SO
					. = TRUE
					break
		if("denyall")
			SSshuttle.request_list.Cut()
			. = TRUE
		if("toggleprivate")
			self_paid = !self_paid
			. = TRUE
	if(.)
		post_signal(cargo_shuttle)

/obj/machinery/computer/cargo/proc/post_signal(command)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(FREQ_STATUS_DISPLAYS)

	if(!frequency)
		return

	var/datum/signal/status_signal = new(list("command" = command))
	frequency.post_signal(src, status_signal)
