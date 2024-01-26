/datum/computer_file/program/card_mod
	filename = "plexagonidwriter"
	filedesc = "Plexagon-迭角权限管理工具"
	downloader_category = PROGRAM_CATEGORY_EQUIPMENT
	program_open_overlay = "id"
	extended_desc = "该程序可用于管理员工ID卡的访问权限."
	download_access = list(ACCESS_COMMAND)
	size = 8
	tgui_id = "NtosCard"
	program_icon = "id-card"

	/// If TRUE, this program only modifies Centcom accesses.
	var/is_centcom = FALSE
	/// If TRUE, this program is authenticated with limited departmental access.
	var/minor = FALSE
	/// The name/assignment combo of the ID card used to authenticate.
	var/authenticated_card
	/// The name of the registered user, related to `authenticated_card`.
	var/authenticated_user
	/// The regions this program has access to based on the authenticated ID.
	var/list/region_access = list()
	/// The list of accesses this program is verified to change based on the authenticated ID. Used for state checking against player input.
	var/list/valid_access = list()
	/// List of job templates that can be applied to ID cards from this program.
	var/list/job_templates = list()
	/// Which departments this program has access to. See region defines.
	var/target_dept

/**
 * Authenticates the program based on the specific ID card.
 *
 * If the card has ACCESS_CHANGE_IDs, it authenticates with all options.
 * Otherwise, it authenticates depending on SSid_access.sub_department_managers_tgui
 * compared to the access on the supplied ID card.
 * Arguments:
 * * user - Program's user.
 * * auth_card - The ID card to attempt to authenticate under.
 */
/datum/computer_file/program/card_mod/proc/authenticate(mob/user, obj/item/card/id/auth_card)
	if(!auth_card)
		return

	region_access.Cut()
	valid_access.Cut()
	job_templates.Cut()

	// If the program isn't locked to a specific department or is_centcom and we have ACCESS_CHANGE_IDS in our auth card, we're not minor.
	if((!target_dept || is_centcom) && (ACCESS_CHANGE_IDS in auth_card.access))
		minor = FALSE
		authenticated_card = "[auth_card.name]"
		authenticated_user = auth_card.registered_name ? auth_card.registered_name : "Unknown"
		job_templates = is_centcom ? SSid_access.centcom_job_templates.Copy() : SSid_access.station_job_templates.Copy()
		valid_access = is_centcom ? SSid_access.get_region_access_list(list(REGION_CENTCOM)) : SSid_access.get_region_access_list(list(REGION_ALL_STATION))
		update_static_data(user)
		return TRUE

	// Otherwise, we're minor and now we have to build a list of restricted departments we can change access for.
	var/list/managers = SSid_access.sub_department_managers_tgui
	for(var/access_as_text in managers)
		var/list/info = managers[access_as_text]
		var/access = access_as_text
		if((access in auth_card.access) && ((target_dept in info["regions"]) || !target_dept))
			region_access |= info["regions"]
			job_templates |= info["templates"]

	if(length(region_access))
		minor = TRUE
		valid_access |= SSid_access.get_region_access_list(region_access)
		authenticated_card = "[auth_card.name] \[有限访问\]"
		update_static_data(user)
		return TRUE

	return FALSE

/datum/computer_file/program/card_mod/on_start(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	computer.crew_manifest_update = TRUE

/datum/computer_file/program/card_mod/kill_program(mob/user)
	computer.crew_manifest_update = FALSE
	var/obj/item/card/id/inserted_auth_card = computer.computer_id_slot
	if(inserted_auth_card)
		GLOB.manifest.modify(inserted_auth_card.registered_name, inserted_auth_card.assignment, inserted_auth_card.get_trim_assignment())

	return ..()

/datum/computer_file/program/card_mod/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = usr
	var/obj/item/card/id/inserted_auth_card = computer.computer_id_slot

	switch(action)
		// Log in.
		if("PRG_authenticate")
			if(!computer || !inserted_auth_card)
				playsound(computer, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
				return TRUE
			if(authenticate(user, inserted_auth_card))
				playsound(computer, 'sound/machines/terminal_on.ogg', 50, FALSE)
				return TRUE
		// Log out.
		if("PRG_logout")
			authenticated_card = null
			authenticated_user = null
			playsound(computer, 'sound/machines/terminal_off.ogg', 50, FALSE)
			return TRUE
		// Print a report.
		if("PRG_print")
			if(!computer)
				return TRUE
			if(!authenticated_card)
				return TRUE
			var/contents = {"<h4>权限报告</h4>
						<u>代写人:</u> [authenticated_user]<br>
						<u>For:</u> [inserted_auth_card.registered_name ? inserted_auth_card.registered_name : "未注册"]<br>
						<hr>
						<u>分配:</u> [inserted_auth_card.assignment]<br>
						<u>权限:</u><br>
						"}

			var/list/known_access_rights = SSid_access.get_region_access_list(list(REGION_ALL_STATION))
			for(var/A in inserted_auth_card.access)
				if(A in known_access_rights)
					contents += " [SSid_access.get_access_desc(A)]"

			if(!computer.print_text(contents, "access report - [inserted_auth_card.registered_name ? inserted_auth_card.registered_name : "未注册"]"))
				to_chat(usr, span_notice("打印机没纸了."))
				return TRUE
			else
				playsound(computer, 'sound/machines/terminal_on.ogg', 50, FALSE)
				computer.visible_message(span_notice("[computer]打印出了一张纸."))
			return TRUE
		if("PRG_eject_id")
			if(inserted_auth_card)
				return computer.RemoveID(usr)
			else
				var/obj/item/I = user.get_active_held_item()
				if(isidcard(I))
					return computer.InsertID(I, user)
			return TRUE
		// Used to fire someone. Wipes all access from their card and modifies their assignment.
		if("PRG_terminate")
			if(!computer || !authenticated_card)
				return TRUE
			if(minor)
				if(!(inserted_auth_card.trim?.type in job_templates))
					to_chat(usr, span_notice("Software error: 您没有降级该卡所需的权限."))
					return TRUE

			// Set the new assignment then remove the trim.
			inserted_auth_card.assignment = is_centcom ? "开除" : "降级"
			SSid_access.remove_trim_from_card(inserted_auth_card)

			playsound(computer, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
			return TRUE
		// Change ID card assigned name.
		if("PRG_edit")
			if(!computer || !authenticated_card || !inserted_auth_card)
				return TRUE

			var/old_name = inserted_auth_card.registered_name

			// Sanitize the name first. We're not using the full sanitize_name proc as ID cards can have a wider variety of things on them that
			// would not pass as a formal character name, but would still be valid on an ID card created by a player.
			var/new_name = sanitize(params["name"])

			if(!new_name)
				inserted_auth_card.registered_name = null
				playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
				inserted_auth_card.update_label()
				// We had a name before and now we have no name, so this will unassign the card and we update the icon.
				if(old_name)
					inserted_auth_card.update_icon()
				return TRUE

			// However, we are going to reject bad names overall including names with invalid characters in them, while allowing numbers.
			new_name = reject_bad_name(new_name, allow_numbers = TRUE)

			if(!new_name)
				to_chat(usr, span_notice("Software error: 该ID卡新名称被拒绝，因其含有禁用字符."))
				return TRUE

			inserted_auth_card.registered_name = new_name
			playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
			inserted_auth_card.update_label()
			// Card wasn't assigned before and now it is, so update the icon accordingly.
			if(!old_name)
				inserted_auth_card.update_icon()
			return TRUE
		// Change age
		if("PRG_age")
			if(!computer || !authenticated_card || !inserted_auth_card)
				return TRUE

			var/new_age = params["id_age"]
			if(!isnum(new_age))
				stack_trace("[key_name(usr)] ([usr])尝试将无效年龄\[[new_age]\]设置为[inserted_auth_card]")
				return TRUE

			inserted_auth_card.registered_age = new_age
			playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
			return TRUE
		// Change assignment
		if("PRG_assign")
			if(!computer || !authenticated_card || !inserted_auth_card)
				return TRUE
			var/new_asignment = trim(sanitize(params["分配"]), MAX_NAME_LEN)
			inserted_auth_card.assignment = new_asignment
			playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
			inserted_auth_card.update_label()
			return TRUE
		// Add/remove access.
		if("PRG_access")
			if(!computer || !authenticated_card || !inserted_auth_card)
				return TRUE
			playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
			var/access_type = params["access_target"]
			var/try_wildcard = params["access_wildcard"]
			if(!(access_type in valid_access))
				stack_trace("[key_name(usr)] ([usr])尝试将无效权限类型\[[access_type]\]设置为[inserted_auth_card]")
				return TRUE

			if(access_type in inserted_auth_card.access)
				inserted_auth_card.remove_access(list(access_type))
				LOG_ID_ACCESS_CHANGE(user, inserted_auth_card, "移除[SSid_access.get_access_desc(access_type)]")
				return TRUE

			if(!inserted_auth_card.add_access(list(access_type), try_wildcard))
				to_chat(usr, span_notice("ID error: ID卡拒绝了您尝试的访问修改."))
				LOG_ID_ACCESS_CHANGE(user, inserted_auth_card, "添加失败[SSid_access.get_access_desc(access_type)][try_wildcard ? "使用通配符 [try_wildcard]" : ""]")
				return TRUE

			if(access_type in ACCESS_ALERT_ADMINS)
				message_admins("[ADMIN_LOOKUPFLW(user)] just added [SSid_access.get_access_desc(access_type)] to an ID card [ADMIN_VV(inserted_auth_card)] [(inserted_auth_card.registered_name) ? "belonging to [inserted_auth_card.registered_name]." : "with no registered name."]")
			LOG_ID_ACCESS_CHANGE(user, inserted_auth_card, "added [SSid_access.get_access_desc(access_type)]")
			return TRUE
		// Apply template to ID card.
		if("PRG_template")
			if(!computer || !authenticated_card || !inserted_auth_card)
				return TRUE

			playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
			var/template_name = params["name"]

			if(!template_name)
				return TRUE

			for(var/trim_path in job_templates)
				var/datum/id_trim/trim = SSid_access.trim_singletons_by_path[trim_path]
				if(trim.assignment != template_name)
					continue

				SSid_access.add_trim_access_to_card(inserted_auth_card, trim_path)
				return TRUE

			stack_trace("[key_name(usr)] ([usr])尝试应用无效模板\[[template_name]\]为[inserted_auth_card]")

			return TRUE

/datum/computer_file/program/card_mod/ui_static_data(mob/user)
	var/list/data = list()
	data["station_name"] = station_name()
	data["centcom_access"] = is_centcom
	data["minor"] = target_dept || minor ? TRUE : FALSE

	var/list/regions = list()
	var/list/tgui_region_data = SSid_access.all_region_access_tgui
	if(is_centcom)
		regions += tgui_region_data[REGION_CENTCOM]
	else
		for(var/region in SSid_access.station_regions)
			if((minor || target_dept) && !(region in region_access))
				continue
			regions += tgui_region_data[region]

	data["regions"] = regions


	data["accessFlags"] = SSid_access.flags_by_access
	data["wildcardFlags"] = SSid_access.wildcard_flags_by_wildcard
	data["accessFlagNames"] = SSid_access.access_flag_string_by_flag
	data["showBasic"] = TRUE
	data["templates"] = job_templates

	return data

/datum/computer_file/program/card_mod/ui_data(mob/user)
	var/list/data = list()

	var/obj/item/card/id/inserted_id = computer.computer_id_slot
	data["authIDName"] = inserted_id ? inserted_id.name : "-----"
	data["authenticatedUser"] = authenticated_card

	data["has_id"] = !!inserted_id
	data["id_name"] = inserted_id ? inserted_id.name : "-----"
	if(inserted_id)
		data["id_rank"] = inserted_id.assignment ? inserted_id.assignment : "Unassigned"
		data["id_owner"] = inserted_id.registered_name ? inserted_id.registered_name : "-----"
		data["access_on_card"] = inserted_id.access
		data["wildcardSlots"] = inserted_id.wildcard_slots
		data["id_age"] = inserted_id.registered_age

		if(inserted_id.trim)
			var/datum/id_trim/card_trim = inserted_id.trim
			data["hasTrim"] = TRUE
			data["trimAssignment"] = card_trim.assignment ? card_trim.assignment : ""
			data["trimAccess"] = card_trim.access ? card_trim.access : list()
		else
			data["hasTrim"] = FALSE
			data["trimAssignment"] = ""
			data["trimAccess"] = list()

	return data
