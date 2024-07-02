/datum/round_event_control/shuttle_catastrophe
	name = "Shuttle Catastrophe-撤离船事故"
	typepath = /datum/round_event/shuttle_catastrophe
	weight = 10
	max_occurrences = 1
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "把应急撤离船换成随机的某个船."
	admin_setup = list(/datum/event_admin_setup/warn_admin/shuttle_catastrophe, /datum/event_admin_setup/listed_options/shuttle_catastrophe)

/datum/round_event_control/shuttle_catastrophe/can_spawn_event(players, allow_magic = FALSE)
	. = ..()
	if(!.)
		return .

	if(SSshuttle.shuttle_purchased == SHUTTLEPURCHASE_FORCED)
		return FALSE //don't do it if its already been done
	if(istype(SSshuttle.emergency, /obj/docking_port/mobile/emergency/shuttle_build))
		return FALSE //don't undo manual player engineering, it also would unload people and ghost them, there's just a lot of problems
	if(EMERGENCY_AT_LEAST_DOCKED)
		return FALSE //don't remove all players when its already on station or going to centcom
	return TRUE

/datum/round_event/shuttle_catastrophe
	var/datum/map_template/shuttle/new_shuttle

/datum/round_event/shuttle_catastrophe/announce(fake)
	var/cause = pick("被 [syndicate_name()] 特工攻击了", "神秘地被传送了", "后勤人员叛逃了",
		"引擎被偷了", "\[数据删除\]", "融化在了落日中", "从一头非常聪明的牛那里学到了一些东西，然后自己离开了",
		"上面有克隆设备", "地勤人员指挥失误，导致飞船撞进了机库")
	var/message = "您的撤离船 [cause]. "

	if(SSshuttle.shuttle_insurance)
		message += "幸运的是，您的飞船保险已经涵盖了修理费！"
		if(SSeconomy.get_dep_account(ACCOUNT_CAR))
			message += " 您因充满智慧的投资而得到了 [command_name()] 的一个奖励."
	else
		message += "在进一步通知前，您的替代撤离船将会是 [new_shuttle.name]."
	priority_announce(message, "[command_name()] 航天工程部")

/datum/round_event/shuttle_catastrophe/setup()
	if(SSshuttle.shuttle_insurance || !isnull(new_shuttle)) //If an admin has overridden it don't re-roll it
		return
	var/list/valid_shuttle_templates = list()
	for(var/shuttle_id in SSmapping.shuttle_templates)
		var/datum/map_template/shuttle/template = SSmapping.shuttle_templates[shuttle_id]
		if(!isnull(template.who_can_purchase) && template.credit_cost < INFINITY) //if we could get it from the communications console, it's cool for us to get it here
			valid_shuttle_templates += template
	new_shuttle = pick(valid_shuttle_templates)

/datum/round_event/shuttle_catastrophe/start()
	if(SSshuttle.shuttle_insurance)
		var/datum/bank_account/station_balance = SSeconomy.get_dep_account(ACCOUNT_CAR)
		station_balance?.adjust_money(8000)
		return
	SSshuttle.shuttle_purchased = SHUTTLEPURCHASE_FORCED
	SSshuttle.unload_preview()
	SSshuttle.existing_shuttle = SSshuttle.emergency
	SSshuttle.action_load(new_shuttle, replace = TRUE)
	log_shuttle("Shuttle Catastrophe set a new shuttle, [new_shuttle.name].")

/datum/event_admin_setup/warn_admin/shuttle_catastrophe
	warning_text = "这将卸载当前停靠的应急撤离船以及其中的任何东西，确定要进行吗？"
	snitch_text = "在撤离船已经对接的情况下触发了撤离船事故."

/datum/event_admin_setup/warn_admin/shuttle_catastrophe/should_warn()
	return EMERGENCY_AT_LEAST_DOCKED || istype(SSshuttle.emergency, /obj/docking_port/mobile/emergency/shuttle_build)

/datum/event_admin_setup/listed_options/shuttle_catastrophe
	input_text = "选择指定的船?"
	normal_run_option = "随机船"

/datum/event_admin_setup/listed_options/shuttle_catastrophe/get_list()
	var/list/valid_shuttle_templates = list()
	for(var/shuttle_id in SSmapping.shuttle_templates)
		var/datum/map_template/shuttle/template = SSmapping.shuttle_templates[shuttle_id]
		if(!isnull(template.who_can_purchase) && template.credit_cost < INFINITY) //Even admins cannot force the cargo shuttle to act as an escape shuttle
			valid_shuttle_templates += template
	return valid_shuttle_templates

/datum/event_admin_setup/listed_options/shuttle_catastrophe/apply_to_event(datum/round_event/shuttle_catastrophe/event)
	event.new_shuttle = chosen
