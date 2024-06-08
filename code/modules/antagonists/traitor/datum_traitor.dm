// 定义所有属于辛迪加的雇主
#define FLAVOR_FACTION_SYNDICATE "辛迪加"
// 定义所有属于纳米传讯的雇主
#define FLAVOR_FACTION_NANOTRASEN "纳米传讯"

/datum/antagonist/traitor
    name = "\improper 叛徒"
    roundend_category = "叛徒"
    antagpanel_category = "叛徒"
    job_rank = ROLE_TRAITOR
    antag_moodlet = /datum/mood_event/focused
    antag_hud_name = "traitor"
    hijack_speed = 0.5 // 默认情况下，每个劫持阶段需要 10 秒
    ui_name = "AntagInfoTraitor"
    suicide_cry = "辛迪加万岁!!"
    preview_outfit = /datum/outfit/traitor
    can_assign_self_objectives = TRUE
    default_custom_objective = "洗劫纳米传讯的高价值资产. "
    hardcore_random_bonus = TRUE

    // 此叛徒应拥有的上行链路标志
    var/uplink_flag_given = UPLINK_TRAITORS

    var/give_objectives = TRUE
    // 是否给叛徒提供次要目标，这些目标不是必需的，但可以完成以获得进展和 TC 提升
    var/give_secondary_objectives = TRUE
    var/should_give_codewords = TRUE
    // 给这个叛徒一个上行链路吗？
    var/give_uplink = TRUE
    // 允许叛徒获得替换上行链路的代码
    var/replacement_uplink_code = ""
    // 叛徒必须在其上讲话才能获得替换上行链路的无线电频率
    var/replacement_uplink_frequency = ""
    // 如果为 TRUE，此叛徒将始终将劫持作为其最终目标
    var/is_hijacker = FALSE

    // 此叛徒具有的对抗风味的名称
    var/employer

    // 在给出雇主后设置的字符串关联列表
    var/list/traitor_flavor

    // 此叛徒被给予的上行链路的引用（如果有）
    var/datum/weakref/uplink_ref

    // 此叛徒所属的上行链路处理程序
    var/datum/uplink_handler/uplink_handler

    var/uplink_sale_count = 3

    // 叛徒必须完成的最终目标，无论是逃跑、劫持还是仅仅是殉道
    var/datum/objective/ending_objective

/datum/antagonist/traitor/infiltrator
    // 用于表示中途加入的叛徒，因此无法访问次要目标
    // 进展元素最好留给回合开始的对抗者
    // 上行链路项目仍将有时间锁定
    name = "\improper 潜伏人员"
    give_secondary_objectives = FALSE
    uplink_flag_given = UPLINK_TRAITORS | UPLINK_INFILTRATORS

/datum/antagonist/traitor/infiltrator/sleeper_agent
    name = "\improper 辛迪加潜伏特工"

/datum/antagonist/traitor/New(give_objectives = TRUE)
	. = ..()
	src.give_objectives = give_objectives

/datum/antagonist/traitor/on_gain()
    owner.special_role = job_rank

    if(give_uplink)
        owner.give_uplink(silent = TRUE, antag_datum = src)
    generate_replacement_codes()

    var/datum/component/uplink/uplink = owner.find_syndicate_uplink()
    uplink_ref = WEAKREF(uplink)
    if(uplink)
        if(uplink_handler)
            uplink.uplink_handler = uplink_handler
        else
            uplink_handler = uplink.uplink_handler
        uplink_handler.uplink_flag = uplink_flag_given
        uplink_handler.primary_objectives = objectives
        uplink_handler.has_progression = TRUE
        SStraitor.register_uplink_handler(uplink_handler)

        if(give_secondary_objectives)
            uplink_handler.has_objectives = TRUE
            uplink_handler.generate_objectives()

        uplink_handler.can_replace_objectives = CALLBACK(src, PROC_REF(can_change_objectives))
        uplink_handler.replace_objectives = CALLBACK(src, PROC_REF(submit_player_objective))

        if(uplink_handler.progression_points < SStraitor.current_global_progression)
            uplink_handler.progression_points = SStraitor.current_global_progression * SStraitor.newjoin_progression_coeff

        var/list/uplink_items = list()
        for(var/datum/uplink_item/item as anything in SStraitor.uplink_items)
            if(item.item &&!item.cant_discount && (item.purchasable_from & uplink_handler.uplink_flag) && item.cost > 1)
                if(!length(item.restricted_roles) &&!length(item.restricted_species))
                    uplink_items += item
                    continue
                if((uplink_handler.assigned_role in item.restricted_roles) || (uplink_handler.assigned_species in item.restricted_species))
                    uplink_items += item
                    continue
        uplink_handler.extra_purchasable += create_uplink_sales(uplink_sale_count, /datum/uplink_category/discounts, 1, uplink_items)

    if(give_objectives)
        forge_traitor_objectives()
        forge_ending_objective()

    pick_employer()

    owner.teach_crafting_recipe(/datum/crafting_recipe/syndicate_uplink_beacon)

    owner.current.playsound_local(get_turf(owner.current),'sound/ambience/antag/tatoralert.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

    return..()

/datum/antagonist/traitor/on_removal()
    if(!isnull(uplink_handler))
        uplink_handler.has_objectives = FALSE
        uplink_handler.can_replace_objectives = null
        uplink_handler.replace_objectives = null
    return..()

/datum/antagonist/traitor/proc/traitor_objective_to_html(datum/traitor_objective/to_display)
    var/string = "[to_display.name]"
    if(to_display.objective_state == OBJECTIVE_STATE_ACTIVE || to_display.objective_state == OBJECTIVE_STATE_INACTIVE)
        string += " <a href='?src=[REF(owner)];edit_obj_tc=[REF(to_display)]'>[to_display.telecrystal_reward] TC</a>"
        string += " <a href='?src=[REF(owner)];edit_obj_pr=[REF(to_display)]'>[to_display.progression_reward] PR</a>"
    else
        string += ", [to_display.telecrystal_reward] TC"
        string += ", [to_display.progression_reward] PR"
    if(to_display.objective_state == OBJECTIVE_STATE_ACTIVE &&!istype(to_display, /datum/traitor_objective/ultimate))
        string += " <a href='?src=[REF(owner)];fail_objective=[REF(to_display)]'>使目标失败</a>"
        string += " <a href='?src=[REF(owner)];succeed_objective=[REF(to_display)]'>使目标成功</a>"
    if(to_display.objective_state == OBJECTIVE_STATE_INACTIVE)
        string += " <a href='?src=[REF(owner)];fail_objective=[REF(to_display)]'>丢掉该目标</a>"

    if(to_display.skipped)
        string += " - <b>跳过</b>"
    else if(to_display.objective_state == OBJECTIVE_STATE_FAILED)
        string += " - <b><font color='red'>失败</font></b>"
    else if(to_display.objective_state == OBJECTIVE_STATE_INVALID)
        string += " - <b>无效</b>"
    else if(to_display.objective_state == OBJECTIVE_STATE_COMPLETED)
        string += " - <b><font color='green'>成功</font></b>"

    return string

/datum/antagonist/traitor/antag_panel_objectives()
	var/result = ..()
	if(!uplink_handler)
		return result
	result += "<i><b>叛徒具体目标</b></i><br>"
	result += "<i><b>最终目标</b></i>:<br>"
	for(var/datum/traitor_objective/objective as anything in uplink_handler.completed_objectives)
		result += "[traitor_objective_to_html(objective)]<br>"
	if(!length(uplink_handler.completed_objectives))
		result += "EMPTY<br>"
	result += "<i><b>持续目标</b></i>:<br>"
	for(var/datum/traitor_objective/objective as anything in uplink_handler.active_objectives)
		result += "[traitor_objective_to_html(objective)]<br>"
	if(!length(uplink_handler.active_objectives))
		result += "EMPTY<br>"
	result += "<i><b>潜在目标</b></i>:<br>"
	for(var/datum/traitor_objective/objective as anything in uplink_handler.potential_objectives)
		result += "[traitor_objective_to_html(objective)]<br>"
	if(!length(uplink_handler.potential_objectives))
		result += "EMPTY<br>"
	result += "<a href='?src=[REF(owner)];common=give_objective'>强制添加目标</a><br>"
	return result

// 如果允许我们为自己分配新目标，则返回 true
/datum/antagonist/traitor/proc/can_change_objectives()
    return can_assign_self_objectives

// 生成叛徒替换上行链路代码和无线电频率的过程
/datum/antagonist/traitor/proc/generate_replacement_codes()
    replacement_uplink_code = "[pick(GLOB.phonetic_alphabet)] [rand(10,99)]"
    replacement_uplink_frequency = sanitize_frequency(rand(MIN_UNUSED_FREQ, MAX_FREQ), free = FALSE, syndie = FALSE)

/datum/antagonist/traitor/on_removal()
    owner.special_role = null
    owner.forget_crafting_recipe(/datum/crafting_recipe/syndicate_uplink_beacon)
    return..()

/datum/antagonist/traitor/proc/pick_employer()
    var/faction = prob(75)? FLAVOR_FACTION_SYNDICATE : FLAVOR_FACTION_NANOTRASEN
    var/list/possible_employers = list()

    possible_employers.Add(GLOB.syndicate_employers, GLOB.nanotrasen_employers)

    if(istype(ending_objective, /datum/objective/hijack))
        possible_employers -= GLOB.normal_employers
    else // 逃跑或殉道
        possible_employers -= GLOB.hijack_employers

    switch(faction)
        if(FLAVOR_FACTION_SYNDICATE)
            possible_employers -= GLOB.nanotrasen_employers
        if(FLAVOR_FACTION_NANOTRASEN)
            possible_employers -= GLOB.syndicate_employers
    employer = pick(possible_employers)
    traitor_flavor = strings(TRAITOR_FLAVOR_FILE, employer)

// 生成一套完整的叛徒目标，直到叛徒目标限制，包括非通用目标，如殉道者和劫持
/datum/antagonist/traitor/proc/forge_traitor_objectives()
    objectives.Cut()
    var/objective_count = 0

    if((GLOB.joined_player_list.len >= HIJACK_MIN_PLAYERS) && prob(HIJACK_PROB))
        is_hijacker = TRUE
        objective_count++

    var/objective_limit = CONFIG_GET(number/traitor_objectives_amount)

    // for(in...to) 循环迭代包含，因此要达到 objective_limit，我们需要循环到 objective_limit - 1
    // 这不会给他们比预期少 1 个目标
    for(var/i in objective_count to objective_limit - 1)
        objectives += forge_single_generic_objective()

/**
 * ## forge_ending_objective
 *
 * 伪造最终目标并将其添加到此数据的目标列表中
 */
/datum/antagonist/traitor/proc/forge_ending_objective()
    if(is_hijacker)
        ending_objective = new /datum/objective/hijack
        ending_objective.owner = owner
        return

    var/martyr_compatibility = TRUE

    for(var/datum/objective/traitor_objective in objectives)
        if(!traitor_objective.martyr_compatible)
            martyr_compatibility = FALSE
            break

    if(martyr_compatibility && prob(MARTYR_PROB))
        ending_objective = new /datum/objective/martyr
        ending_objective.owner = owner
        objectives += ending_objective
        return

    ending_objective = new /datum/objective/escape
    ending_objective.owner = owner
    objectives += ending_objective

/datum/antagonist/traitor/proc/forge_single_generic_objective()
    if(prob(KILL_PROB))
        var/list/active_ais = active_ais()
        if(active_ais.len && prob(DESTROY_AI_PROB(GLOB.joined_player_list.len)))
            var/datum/objective/destroy/destroy_objective = new()
            destroy_objective.owner = owner
            destroy_objective.find_target()
            return destroy_objective

        if(prob(MAROON_PROB))
            var/datum/objective/maroon/maroon_objective = new()
            maroon_objective.owner = owner
            maroon_objective.find_target()
            return maroon_objective

        var/datum/objective/assassinate/kill_objective = new()
        kill_objective.owner = owner
        kill_objective.find_target()
        return kill_objective

    var/datum/objective/steal/steal_objective = new()
    steal_objective.owner = owner
    steal_objective.find_target()
    return steal_objective

/datum/antagonist/traitor/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/datum_owner = mob_override || owner.current

	handle_clown_mutation(datum_owner, mob_override ? null : "你所受的训练让你克服了小丑本能，你可以在不伤害自己的情况下使用武器了.")
	if(should_give_codewords)
		datum_owner.AddComponent(/datum/component/codeword_hearing, GLOB.syndicate_code_phrase_regex, "blue", src)
		datum_owner.AddComponent(/datum/component/codeword_hearing, GLOB.syndicate_code_response_regex, "red", src)

/datum/antagonist/traitor/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/datum_owner = mob_override || owner.current
	handle_clown_mutation(datum_owner, removing = FALSE)

	for(var/datum/component/codeword_hearing/component as anything in datum_owner.GetComponents(/datum/component/codeword_hearing))
		component.delete_if_from_source(src)

/datum/antagonist/traitor/ui_static_data(mob/user)
	var/datum/component/uplink/uplink = uplink_ref?.resolve()
	var/list/data = list()
	data["has_codewords"] = should_give_codewords
	if(should_give_codewords)
		data["phrases"] = jointext(GLOB.syndicate_code_phrase, ", ")
		data["responses"] = jointext(GLOB.syndicate_code_response, ", ")
	data["theme"] = traitor_flavor["ui_theme"]
	data["code"] = uplink?.unlock_code
	data["failsafe_code"] = uplink?.failsafe_code
	data["replacement_code"] = replacement_uplink_code
	data["replacement_frequency"] = format_frequency(replacement_uplink_frequency)
	data["intro"] = traitor_flavor["introduction"]
	data["allies"] = traitor_flavor["allies"]
	data["goal"] = traitor_flavor["goal"]
	data["has_uplink"] = uplink ? TRUE : FALSE
	if(uplink)
		data["uplink_intro"] = traitor_flavor["uplink"]
		data["uplink_unlock_info"] = uplink.unlock_text
	data["objectives"] = get_objectives()
	return data

/datum/antagonist/traitor/roundend_report()
	var/list/result = list()

	var/traitor_won = TRUE

	result += printplayer(owner)

	var/used_telecrystals = 0
	var/uplink_owned = FALSE
	var/purchases = ""

	LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
	// Uplinks add an entry to uplink_purchase_logs_by_key on init.
	var/datum/uplink_purchase_log/purchase_log = GLOB.uplink_purchase_logs_by_key[owner.key]
	if(purchase_log)
		used_telecrystals = purchase_log.total_spent
		uplink_owned = TRUE
		purchases += purchase_log.generate_render(FALSE)

	var/objectives_text = ""
	if(objectives.len) //If the traitor had no objectives, don't need to process this.
		var/count = 1
		for(var/datum/objective/objective in objectives)
			if(!objective.check_completion())
				traitor_won = FALSE
			objectives_text += "<br><B>目标 #[count]</B>: [objective.explanation_text] [objective.get_roundend_success_suffix()]"
			count++
		if(uplink_handler.final_objective)
			objectives_text += "<br>[span_greentext("[traitor_won ? "此外" : "然而"], 最终目标 \"[uplink_handler.final_objective]\" 成功了!")]"
			traitor_won = TRUE

	result += "<br>[owner.name] <B>[traitor_flavor["roundend_report"]]</B>"

	if(uplink_owned)
		var/uplink_text = "(使用了 [used_telecrystals] TC) [purchases]"
		if((used_telecrystals == 0) && traitor_won)
			var/static/icon/badass = icon('icons/ui_icons/antags/badass.dmi', "badass")
			uplink_text += "<BIG>[icon2html(badass, world)]</BIG>"
		result += uplink_text

	result += objectives_text

	if(uplink_handler)
		if (uplink_handler.contractor_hub)
			result += contractor_round_end()
		result += "<br>叛徒总共拥有[DISPLAY_PROGRESSION(uplink_handler.progression_points)]点名誉和[uplink_handler.telecrystals]未使用的TC."

	var/special_role_text = lowertext(name)

	if(traitor_won)
		result += span_greentext("[special_role_text]成功了!")
	else
		result += span_redtext("[special_role_text]失败了!")
		SEND_SOUND(owner.current, 'sound/ambience/ambifailure.ogg')

	return result.Join("<br>")

///Tells how many contracts have been completed.
/datum/antagonist/traitor/proc/contractor_round_end()
	var/completed_contracts = uplink_handler.contractor_hub.contracts_completed
	var/tc_total = uplink_handler.contractor_hub.contract_TC_payed_out + uplink_handler.contractor_hub.contract_TC_to_redeem

	var/datum/antagonist/traitor/contractor_support/contractor_support_unit = uplink_handler.contractor_hub.contractor_teammate

	if(completed_contracts <= 0)
		return
	var/plural_check = "契约工作"
	if (completed_contracts > 1)
		plural_check = "契约工作"
	var/sent_data = "完成了[span_greentext("[completed_contracts]")]份[plural_check]，赚得[span_greentext("[tc_total] TC")]!<br>"
	if(contractor_support_unit)
		sent_data += "<b>[contractor_support_unit.owner.key]</b>扮演了<b>[contractor_support_unit.owner.current.name]</b>, 契约支援单位.<br>"
	return sent_data

/datum/antagonist/traitor/roundend_report_footer()
	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	var/message = "<br><b>呼叫暗号:</b> <span class='bluetext'>[phrases]</span><br>\
					<b>应答暗号:</b> [span_redtext("[responses]")]<br>"

	return message

/datum/outfit/traitor
	name = "叛徒 (仅供预览)"

	uniform = /obj/item/clothing/under/color/grey
	suit = /obj/item/clothing/suit/hooded/ablative
	head = /obj/item/clothing/head/hooded/ablative
	gloves = /obj/item/clothing/gloves/color/yellow
	mask = /obj/item/clothing/mask/gas
	l_hand = /obj/item/melee/energy/sword
	r_hand = /obj/item/gun/energy/recharge/ebow
	shoes = /obj/item/clothing/shoes/magboots/advance

/datum/outfit/traitor/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/melee/energy/sword/sword = locate() in H.held_items
	if(sword.flags_1 & INITIALIZED_1)
		sword.attack_self()
	else //Atoms aren't initialized during the screenshots unit test, so we can't call attack_self for it as the sword doesn't have the transforming weapon component to handle the icon changes. The below part is ONLY for the antag screenshots unit test.
		sword.icon_state = "e_sword_on_red"
		sword.inhand_icon_state = "e_sword_on_red"
		sword.worn_icon_state = "e_sword_on_red"

		H.update_held_items()

#undef FLAVOR_FACTION_SYNDICATE
#undef FLAVOR_FACTION_NANOTRASEN
