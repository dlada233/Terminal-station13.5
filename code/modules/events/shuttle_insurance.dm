

/datum/round_event_control/shuttle_insurance
	name = "Shuttle Insurance"
	typepath = /datum/round_event/shuttle_insurance
	max_occurrences = 1
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "A sketchy but legit insurance offer."

/datum/round_event_control/shuttle_insurance/can_spawn_event(players, allow_magic = FALSE)
	. = ..()
	if(!.)
		return .

	if(!SSeconomy.get_dep_account(ACCOUNT_CAR))
		return FALSE //They can't pay?
	if(SSshuttle.shuttle_purchased == SHUTTLEPURCHASE_FORCED)
		return FALSE //don't do it if there's nothing to insure
	if(istype(SSshuttle.emergency, /obj/docking_port/mobile/emergency/shuttle_build))
		return FALSE //this shuttle prevents the catastrophe event from happening making this event effectively useless
	if(EMERGENCY_AT_LEAST_DOCKED)
		return FALSE //catastrophes won't trigger so no point
	return TRUE

/datum/round_event/shuttle_insurance
	var/ship_name = "\"In the Unlikely Event\""
	var/datum/comm_message/insurance_message
	var/insurance_evaluation = 0

/datum/round_event/shuttle_insurance/announce(fake)
	priority_announce("进入子空间通信，在所有通信控制台打开可靠频道.", "消息传入中", SSstation.announcer.get_rand_report_sound())

/datum/round_event/shuttle_insurance/setup()
	ship_name = pick(strings(PIRATE_NAMES_FILE, "rogue_names"))
	for(var/shuttle_id in SSmapping.shuttle_templates)
		var/datum/map_template/shuttle/template = SSmapping.shuttle_templates[shuttle_id]
		if(template.name == SSshuttle.emergency.name) //found you slackin
			insurance_evaluation = template.credit_cost/2
			break
	if(!insurance_evaluation)
		insurance_evaluation = 5000 //gee i dunno

/datum/round_event/shuttle_insurance/start()
	insurance_message = new("撤离船保险", "嘿，伙计, 这里是 [ship_name]，不得不注意到你有一个狂野疯狂且没有保险的撤离船！ 好TM疯狂，如果它出了事怎么办，嗯?! 我们对你们在这个领域的保险费率做了一个快速评估，我们现在为你们的撤离船提供 [insurance_evaluation] 来防止你遇到意外束手无策.", list("购买保险.","拒绝购买."))
	insurance_message.answer_callback = CALLBACK(src, PROC_REF(answered))
	SScommunications.send_message(insurance_message, unique = TRUE)

/datum/round_event/shuttle_insurance/proc/answered()
	if(EMERGENCY_AT_LEAST_DOCKED)
		priority_announce("你们决定地太晚啦，我的朋友，我们的员工已经下班了.",sender_override = ship_name, color_override = "red")
		return
	if(insurance_message && insurance_message.answered == 1)
		var/datum/bank_account/station_balance = SSeconomy.get_dep_account(ACCOUNT_CAR)
		if(!station_balance?.adjust_money(-insurance_evaluation))
			priority_announce("你没有为保险支付足够的钱，而这在太空商法中被认为是诈骗，我们现在没收你已经给的钱, 诈骗犯！", sender_override = ship_name, color_override = "red")
			return
		priority_announce("感谢你方购买撤离船保险！", sender_override = ship_name, color_override = "red")
		SSshuttle.shuttle_insurance = TRUE
