#define MAX_NOTICES 8

/obj/structure/noticeboard
	name = "公告板"
	desc = "用来钉重要通知的板，它是用最好的西班牙软木制成的."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "noticeboard"
	density = FALSE
	anchored = TRUE
	max_integrity = 150
	/// Current number of a pinned notices
	var/notices = 0

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/noticeboard, 32)

/obj/structure/noticeboard/Initialize(mapload)
	. = ..()

	if(!mapload)
		return

	for(var/obj/item/I in loc)
		if(notices >= MAX_NOTICES)
			break
		if(istype(I, /obj/item/paper))
			I.forceMove(src)
			notices++
	update_appearance(UPDATE_ICON)
	find_and_hang_on_wall()

//attaching papers!!
/obj/structure/noticeboard/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo))
		if(!allowed(user))
			to_chat(user, span_warning("You are not authorized to add notices!"))
			return
		if(notices < MAX_NOTICES)
			if(!user.transferItemToLoc(O, src))
				return
			notices++
			update_appearance(UPDATE_ICON)
			to_chat(user, span_notice("You pin the [O] to the noticeboard."))
		else
			to_chat(user, span_warning("The notice board is full!"))
	else
		return ..()

/obj/structure/noticeboard/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/noticeboard/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NoticeBoard", name)
		ui.open()

/obj/structure/noticeboard/ui_data(mob/user)
	var/list/data = list()
	data["allowed"] = allowed(user)
	data["items"] = list()
	for(var/obj/item/content in contents)
		var/list/content_data = list(
			name = content.name,
			ref = REF(content)
		)
		data["items"] += list(content_data)
	return data

/obj/structure/noticeboard/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/obj/item/item = locate(params["ref"]) in contents
	if(!istype(item) || item.loc != src)
		return

	var/mob/user = usr

	switch(action)
		if("examine")
			if(istype(item, /obj/item/paper))
				item.ui_interact(user)
			else
				user.examinate(item)
			return TRUE
		if("remove")
			if(!allowed(user))
				return
			remove_item(item, user)
			return TRUE

/obj/structure/noticeboard/update_overlays()
	. = ..()
	if(notices)
		. += "notices_[notices]"

/**
 * Removes an item from the notice board
 *
 * Arguments:
 * * item - The item that is to be removed
 * * user - The mob that is trying to get the item removed, if there is one
 */
/obj/structure/noticeboard/proc/remove_item(obj/item/item, mob/user)
	item.forceMove(drop_location())
	if(user)
		user.put_in_hands(item)
		balloon_alert(user, "removed from board")
	notices--
	update_appearance(UPDATE_ICON)

/obj/structure/noticeboard/atom_deconstruct(disassembled = TRUE)
	if(!disassembled)
		new /obj/item/stack/sheet/mineral/wood(loc)
	else
		new /obj/item/wallframe/noticeboard(loc)
	for(var/obj/item/content in contents)
		remove_item(content)

/obj/item/wallframe/noticeboard
	name = "公告板"
	desc = "现在它更像是一个剪贴板，贴在墙上使用的."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "noticeboard"
	custom_materials = list(
		/datum/material/wood = SHEET_MATERIAL_AMOUNT,
	)
	resistance_flags = FLAMMABLE
	result_path = /obj/structure/noticeboard
	pixel_shift = 32

// Notice boards for the heads of staff (plus the qm)

/obj/structure/noticeboard/captain
	name = "舰长公告栏"
	desc = "这里有来自舰长的重要通知."
	req_access = list(ACCESS_CAPTAIN)

/obj/structure/noticeboard/hop
	name = "人事部长公告栏"
	desc = "这里有来自人事部长的重要通知."
	req_access = list(ACCESS_HOP)

/obj/structure/noticeboard/ce
	name = "工程部长公告栏"
	desc = "这里有来自工程部长的重要通知."
	req_access = list(ACCESS_CE)

/obj/structure/noticeboard/hos
	name = "安保部长公告栏"
	desc = "这里有来自安保部长的重要通知."
	req_access = list(ACCESS_HOS)

/obj/structure/noticeboard/cmo
	name = "首席医疗官公告栏"
	desc = "这里有来自首席医疗官的重要通知."
	req_access = list(ACCESS_CMO)

/obj/structure/noticeboard/rd
	name = "研究主管公告栏"
	desc = "这里有来自研究主管的重要通知."
	req_access = list(ACCESS_RD)

/obj/structure/noticeboard/qm
	name = "军需官公告栏"
	desc = "这里有来自军需官的重要通知."
	req_access = list(ACCESS_QM)

/obj/structure/noticeboard/staff
	name = "员工公告栏"
	desc = "这里有来自部长的重要通知."
	req_access = list(ACCESS_COMMAND)

#undef MAX_NOTICES
