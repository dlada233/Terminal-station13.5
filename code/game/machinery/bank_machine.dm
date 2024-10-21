/obj/machinery/computer/bank_machine
	name = "提款机"
	desc = "用于存取站点资金的机器."
	circuit = /obj/item/circuitboard/computer/bankmachine
	icon_screen = "vault"
	icon_keyboard = "security_key"
	req_access = list(ACCESS_VAULT)
	///Whether the machine is currently being siphoned
	var/siphoning = FALSE
	///While siphoning, how much money do we have? Will drop this once siphon is complete.
	var/syphoning_credits = 0
	///Whether siphoning is authorized or not (has access)
	var/unauthorized = FALSE
	///Amount of time before the next warning over the radio is announced.
	var/next_warning = 0
	///The amount of time we have between warnings
	var/minimum_time_between_warnings = 40 SECONDS

	///The machine's internal radio, used to broadcast alerts.
	var/obj/item/radio/radio
	///The channel we announce a siphon over.
	var/radio_channel = RADIO_CHANNEL_COMMON

	///What department to check to link our bank account to.
	var/account_department = ACCOUNT_CAR
	///Bank account we're connected to.
	var/datum/bank_account/synced_bank_account

/obj/machinery/computer/bank_machine/Initialize(mapload)
	. = ..()
	radio = new(src)
	radio.subspace_transmission = TRUE
	radio.canhear_range = 0
	radio.set_listening(FALSE)
	radio.recalculateChannels()
	synced_bank_account = SSeconomy.get_dep_account(account_department)

	if(!mapload)
		AddComponent(/datum/component/gps, "禁守现金信号")

/obj/machinery/computer/bank_machine/Destroy()
	QDEL_NULL(radio)
	synced_bank_account = null
	return ..()

/obj/machinery/computer/bank_machine/attackby(obj/item/weapon, mob/user, params)
	var/value = 0
	if(istype(weapon, /obj/item/stack/spacecash))
		var/obj/item/stack/spacecash/inserted_cash = weapon
		value = inserted_cash.value * inserted_cash.amount
	else if(istype(weapon, /obj/item/holochip))
		var/obj/item/holochip/inserted_holochip = weapon
		value = inserted_holochip.credits
	if(value)
		if(synced_bank_account)
			synced_bank_account.adjust_money(value)
			say("信用点已存入! [synced_bank_account.account_holder]先有[synced_bank_account.account_balance] cr.")
		qdel(weapon)
		return
	return ..()

/obj/machinery/computer/bank_machine/process(seconds_per_tick)
	. = ..()
	if(!siphoning || !synced_bank_account)
		return
	if (machine_stat & (BROKEN | NOPOWER))
		say("功率不足. 转移停止.")
		end_siphon()
		return
	var/siphon_am = 100 * seconds_per_tick
	if(!synced_bank_account.has_money(siphon_am))
		say("[synced_bank_account.account_holder]耗尽. 转移停止.")
		end_siphon()
		return

	playsound(src, 'sound/items/poster_being_created.ogg', 100, TRUE)
	syphoning_credits += siphon_am
	synced_bank_account.adjust_money(-siphon_am)
	if(next_warning < world.time && prob(15))
		var/area/A = get_area(loc)
		var/message = "[unauthorized ? "未经授权的" : ""]信用点取款在[initial(A.name)]进行中[unauthorized ? "!!" : "..."]"
		radio.talk_into(src, message, radio_channel)
		next_warning = world.time + minimum_time_between_warnings

/obj/machinery/computer/bank_machine/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BankMachine", name)
		ui.open()

/obj/machinery/computer/bank_machine/ui_data(mob/user)
	var/list/data = list()

	data["current_balance"] = synced_bank_account?.account_balance || 0
	data["siphoning"] = siphoning
	data["station_name"] = station_name()

	return data

/obj/machinery/computer/bank_machine/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("siphon")
			if(is_station_level(src.z) || is_centcom_level(src.z))
				say("站点信用点转移已经开始!")
				start_siphon(ui.user)
			else
				say("错误: 终端不在站点范围内，无法开始撤离.")
			. = TRUE
		if("halt")
			say("站点信用点取款已中止.")
			end_siphon()
			. = TRUE

/obj/machinery/computer/bank_machine/on_changed_z_level()
	. = ..()
	if(siphoning && !(is_station_level(src.z) || is_centcom_level(src.z)))
		say("错误: 终端不在站点范围内. 转移已停止.")
		end_siphon()

/obj/machinery/computer/bank_machine/proc/end_siphon()
	siphoning = FALSE
	unauthorized = FALSE
	if(syphoning_credits > 0)
		new /obj/item/holochip(drop_location(), syphoning_credits) //get the loot
	syphoning_credits = 0

/obj/machinery/computer/bank_machine/proc/start_siphon(mob/living/carbon/user)
	var/obj/item/card/id/card = user.get_idcard(hand_first = TRUE)
	if(!istype(card) || !check_access(card))
		unauthorized = TRUE
	else
		unauthorized = FALSE
	siphoning = TRUE
