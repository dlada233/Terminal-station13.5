/// Name of the blanks file
#define BLANKS_FILE_NAME "config/blanks.json"

/// For use with the `color_mode` var. Photos will be printed in greyscale while the var has this value.
#define PHOTO_GREYSCALE "Greyscale"
/// For use with the `color_mode` var. Photos will be printed in full color while the var has this value.
#define PHOTO_COLOR "Color"

/// How much toner is used for making a copy of a paper.
#define PAPER_TONER_USE 0.125
/// How much toner is used for making a copy of a photo.
#define PHOTO_TONER_USE 0.625
/// How much toner is used for making a copy of a document.
#define DOCUMENT_TONER_USE (PAPER_TONER_USE * DOCUMENT_PAPER_USE)
/// How much toner is used for making a copy of an ass.
#define ASS_TONER_USE PHOTO_TONER_USE
/// How much toner is used for making a copy of paperwork.
#define PAPERWORK_TONER_USE (PAPER_TONER_USE * PAPERWORK_PAPER_USE)

/// At which toner charge amount we start losing color. Toner cartridges are scams.
#define TONER_CHARGE_LOW_AMOUNT 2

// please use integers here
/// How much paper is used for making a copy of paper. What, are you seriously surprised by this?
#define PAPER_PAPER_USE 1
/// How much paper is used for making a copy of a photo.
#define PHOTO_PAPER_USE 1
/// How much paper is used for making a copy of a document.
#define DOCUMENT_PAPER_USE 20
/// How much paper is used for making a copy of a photo.
#define ASS_PAPER_USE PHOTO_PAPER_USE
/// How much paper is used for making a copy of paperwork.
#define PAPERWORK_PAPER_USE 10

/// Maximum capacity of a photocopier
#define MAX_PAPER_CAPACITY 60
/// The maximum amount of copies you can make with one press of the copy button.
#define MAX_COPIES_AT_ONCE 10

/// Photocopier copy fee.
#define PHOTOCOPIER_FEE 5

/// Paper blanks (form templates, basically). Loaded from `config/blanks.json`.
/// If invalid or not found, set to null.
GLOBAL_LIST_INIT(paper_blanks, init_paper_blanks())

/proc/init_paper_blanks()
	if(!fexists(BLANKS_FILE_NAME))
		return null
	var/list/blanks_json = json_decode(file2text(BLANKS_FILE_NAME))
	if(!length(blanks_json))
		return null

	var/list/parsed_blanks = list()
	for(var/paper_blank in blanks_json)
		parsed_blanks += list("[paper_blank["code"]]" = paper_blank)

	return parsed_blanks

/obj/machinery/photocopier
	name = "复印机"
	desc = "用来复制重要文件和解剖学研究资料."
	icon = 'icons/obj/service/library.dmi'
	icon_state = "photocopier"
	density = TRUE
	power_channel = AREA_USAGE_EQUIP
	max_integrity = 300
	integrity_failure = 0.33
	interaction_flags_mouse_drop = NEED_DEXTERITY | ALLOW_RESTING

	/// A reference to a mob on top of the photocopier trying to copy their ass. Null if there is no mob.
	var/mob/living/ass
	/// A reference to the toner cartridge that's inserted into the copier. Null if there is no cartridge.
	var/obj/item/toner/toner_cartridge
	/// How many copies will be printed with one click of the "copy" button.
	var/num_copies = 1
	/// Used with photos. Determines if the copied photo will be in greyscale or color.
	var/color_mode = PHOTO_COLOR
	/// Indicates whether the printer is currently busy copying or not.
	var/busy = FALSE
	/// Variable needed to determine the selected category of forms on Photocopier.js
	var/category
	/// Variable that holds a reference to any object supported for photocopying inside the photocopier
	var/obj/object_copy
	/// Variable for the UI telling us how many copies are in the queue.
	var/copies_left = 0
	/// The amount of paper this photocoper starts with.
	var/starting_paper = 30
	/// A stack for all the empty paper we have newly inserted (LIFO)
	var/list/paper_stack = list()


/obj/machinery/photocopier/Initialize(mapload)
	. = ..()
	toner_cartridge = new(src)
	setup_components()
	AddElement(/datum/element/elevation, pixel_shift = 8) //enough to look like your bums are on the machine.

/// Simply adds the necessary components for this to function.
/obj/machinery/photocopier/proc/setup_components()
	AddComponent(/datum/component/payment, PHOTOCOPIER_FEE, SSeconomy.get_dep_account(ACCOUNT_CIV), PAYMENT_CLINICAL)

/obj/machinery/photocopier/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == object_copy)
		object_copy = null
	if(gone == toner_cartridge)
		toner_cartridge = null
	if(gone in paper_stack)
		paper_stack -= gone

/obj/machinery/photocopier/Destroy()
	// object_copy can be a traitor objective, don't qdel
	if(object_copy)
		object_copy.forceMove(drop_location())

	QDEL_NULL(toner_cartridge)
	QDEL_LIST(paper_stack)

	ass = null //the mob isn't actually contained and just referenced, no need to delete it.
	return ..()

/obj/machinery/photocopier/examine(mob/user)
	. = ..()
	if(object_copy)
		. += span_notice("扫描托盘里已经放了东西.")
	. += span_notice("你可以把任何类型的空白纸放进去，以便在上面打印表格或复印内容")

/obj/machinery/photocopier/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Photocopier")
		ui.open()

/obj/machinery/photocopier/ui_static_data(mob/user)
	var/list/static_data = list()

	var/list/blank_infos = list()
	var/list/category_names = list()
	if(GLOB.paper_blanks)
		for(var/blank_id in GLOB.paper_blanks)
			var/list/paper_blank = GLOB.paper_blanks[blank_id]
			blank_infos += list(list(
				name = paper_blank["name"],
				category = paper_blank["category"],
				code = blank_id,
			))
			category_names |= paper_blank["category"]

	static_data["blanks"] = blank_infos
	static_data["categories"] = category_names

	return static_data

/obj/machinery/photocopier/ui_data(mob/user)
	var/list/data = list()
	data["has_item"] = !copier_empty()
	data["num_copies"] = num_copies

	data["category"] = category
	data["copies_left"] = copies_left

	if(istype(object_copy, /obj/item/photo))
		data["is_photo"] = TRUE
		data["color_mode"] = color_mode

	if(HAS_AI_ACCESS(user))
		data["isAI"] = TRUE
		data["can_AI_print"] = toner_cartridge && (toner_cartridge.charges >= PHOTO_TONER_USE) && (get_paper_count() >= PHOTO_PAPER_USE)
	else
		data["isAI"] = FALSE

	if(toner_cartridge)
		data["has_toner"] = TRUE
		data["current_toner"] = toner_cartridge.charges
		data["max_toner"] = toner_cartridge.max_charges
	else
		data["has_toner"] = FALSE

	data["paper_count"] = get_paper_count()

	return data

/obj/machinery/photocopier/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(machine_stat & (BROKEN|NOPOWER))
		return

	switch(action)
		// Copying paper, photos, documents and asses.
		if("make_copy")
			if(check_busy(usr))
				return FALSE
			// ASS COPY. By Miauw
			if(ass)
				if(ishuman(ass) && (ass.get_item_by_slot(ITEM_SLOT_ICLOTHING) || ass.get_item_by_slot(ITEM_SLOT_OCLOTHING)))
					if(ass == usr)
						to_chat(usr, span_notice("你穿着衣服复印自己的屁股，感觉有点傻."))
					else
						to_chat(usr, span_notice("你让[ass]穿着衣服复印屁股，感觉有点傻."))
					return FALSE
				do_copies(CALLBACK(src, PROC_REF(make_ass_copy)), usr, ASS_PAPER_USE, ASS_TONER_USE, num_copies)
				return TRUE
			else
				// Basic paper
				if(istype(object_copy, /obj/item/paper))
					do_copies(CALLBACK(src, PROC_REF(make_paper_copy), object_copy), usr, PAPER_PAPER_USE, PAPER_TONER_USE, num_copies)
					return TRUE
				// Copying photo.
				if(istype(object_copy, /obj/item/photo))
					var/obj/item/photo/photo_copy = object_copy
					do_copies(CALLBACK(src, PROC_REF(make_photo_copy), photo_copy.picture, color_mode), usr, PHOTO_PAPER_USE, PHOTO_TONER_USE, num_copies)
					return TRUE
				// Copying Documents.
				if(istype(object_copy, /obj/item/documents))
					do_copies(CALLBACK(src, PROC_REF(make_document_copy), object_copy), usr, DOCUMENT_PAPER_USE, DOCUMENT_TONER_USE, num_copies)
					return TRUE
				// Copying paperwork
				if(istype(object_copy, /obj/item/paperwork))
					do_copies(CALLBACK(src, PROC_REF(make_paperwork_copy), object_copy), usr, PAPERWORK_PAPER_USE, PAPERWORK_TONER_USE, num_copies)
					return TRUE

		// Remove the paper/photo/document from the photocopier.
		if("remove")
			if(object_copy)
				remove_photocopy(object_copy, usr)
				object_copy = null
			else if(check_ass())
				to_chat(ass, span_notice("你感到屁股下传来轻微的压力."))
			return TRUE

		// AI printing photos from their saved images.
		if("ai_photo")
			if(check_busy(usr))
				return FALSE
			var/mob/living/silicon/ai/tempAI = usr
			if(!length(tempAI.aicamera.stored))
				balloon_alert(usr, "无图像保存!")
				return FALSE
			var/datum/picture/selection = tempAI.aicamera.selectpicture(usr)
			do_copies(CALLBACK(src, PROC_REF(make_photo_copy), selection, PHOTO_COLOR), usr, PHOTO_PAPER_USE, PHOTO_TONER_USE, 1)
			return TRUE

		// Switch between greyscale and color photos
		if("color_mode")
			if(params["mode"] in list(PHOTO_GREYSCALE, PHOTO_COLOR))
				color_mode = params["mode"]
			return TRUE

		// Remove the toner cartridge from the copier.
		if("remove_toner")
			if(check_busy(usr))
				return FALSE
			var/success = usr.put_in_hands(toner_cartridge)
			if(!success)
				toner_cartridge.forceMove(drop_location())

			toner_cartridge = null
			return TRUE

		// Set the number of copies to be printed with 1 click of the "copy" button.
		if("set_copies")
			num_copies = clamp(text2num(params["num_copies"]), 1, MAX_COPIES_AT_ONCE)
			return TRUE
		// Changes the forms displayed on Photocopier.js when you switch categories
		if("choose_category")
			category = params["category"]
			return TRUE
		// Called when you press print blank
		if("print_blank")
			if(check_busy(usr))
				return FALSE
			if(!(params["code"] in GLOB.paper_blanks))
				return FALSE
			var/list/blank = GLOB.paper_blanks[params["code"]]
			do_copies(CALLBACK(src, PROC_REF(make_blank_print), blank), usr, PAPER_PAPER_USE, PAPER_TONER_USE, 1)
			return TRUE

/// Returns the color used for the printing operation. If the color is below TONER_LOW_PERCENTAGE, it returns a gray color.
/obj/machinery/photocopier/proc/get_toner_color()
	return toner_cartridge.charges > TONER_CHARGE_LOW_AMOUNT ? COLOR_FULL_TONER_BLACK : COLOR_GRAY


/// Will invoke `do_copy_loop` asynchronously. Passes the supplied arguments on to it.
/obj/machinery/photocopier/proc/do_copies(datum/callback/copy_cb, mob/user, paper_use, toner_use, copies_amount)
	if(machine_stat & (BROKEN|NOPOWER))
		return

	busy = TRUE
	update_use_power(ACTIVE_POWER_USE)
	// fucking god proc
	INVOKE_ASYNC(src, PROC_REF(do_copy_loop), copy_cb, user, paper_use, toner_use, copies_amount)

/**
 * Will invoke the passed in `copy_cb` callback in 4 second intervals, and charge the user 5 credits for each copy made.
 *
 * Arguments:
 * * copy_cb - a callback for which proc to call. Should only be one of the `make_x_copy()` procs, such as `make_paper_copy()`.
 * * user - the mob who clicked copy.
 * * paper_use - the amount of paper used in this operation
 * * toner_use - the amount of toner used in this operation
 * * copies_amount - the amount of copies we should make
 */
/obj/machinery/photocopier/proc/do_copy_loop(datum/callback/copy_cb, mob/user, paper_use, toner_use, copies_amount)
	var/error_message = null
	if(!toner_cartridge)
		copies_amount = 0
		error_message = span_warning("一条故障信息出现在[src]的屏幕上: \"找不到墨盒，中止.\"")
	else if(toner_cartridge.charges < toner_use * copies_amount)
		copies_amount = FLOOR(toner_cartridge.charges / toner_use, 1)
		error_message = span_warning("一条故障信息出现在[src]的屏幕上: \"没有足够的墨粉来执行[copies_amount >= 1 ? "全部" : ""]操作.\"")
	if(get_paper_count() < paper_use * copies_amount)
		copies_amount = FLOOR(get_paper_count() / paper_use, 1)
		error_message = span_warning("一条故障信息出现在[src]的屏幕上: \"没有足够的纸张来执行[copies_amount >= 1 ? "全部 " : ""]操作.\"")

	copies_left = copies_amount

	if(copies_amount <= 0)
		to_chat(user, error_message)
		reset_busy()
		return

	if(attempt_charge(src, user, (copies_amount - 1) * PHOTOCOPIER_FEE) & COMPONENT_OBJ_CANCEL_CHARGE)
		reset_busy()
		return

	if(error_message)
		to_chat(user, error_message)

	// if you managed to cancel the copy operation, tough luck. you aren't getting your money back.
	for(var/i in 1 to copies_amount)
		if(machine_stat & (BROKEN|NOPOWER))
			break

		if(!toner_cartridge)
			break

		// arguments to copy_cb have been set at callback instantiation
		var/atom/movable/copied_obj = copy_cb.Invoke()
		if(isnull(copied_obj)) // something went wrong, so other copies will go wrong too
			break

		playsound(src, 'sound/machines/printer.ogg', 50, vary = FALSE)
		sleep(4 SECONDS)

		// reveal our copied item
		copied_obj.forceMove(drop_location())
		give_pixel_offset(copied_obj)
		copies_left--

	copies_left = 0
	reset_busy()

/// Sets busy to `FALSE`.
/obj/machinery/photocopier/proc/reset_busy()
	update_use_power(IDLE_POWER_USE)
	busy = FALSE

/// Determines if the printer is currently busy, informs the user if it is.
/obj/machinery/photocopier/proc/check_busy(mob/user)
	if(busy)
		balloon_alert(user, "printer is busy!")
		return TRUE
	return FALSE

/**
 * Gives items a random x and y pixel offset, between -10 and 10 for each.
 *
 * This is done that when someone prints multiple papers, we dont have them all appear to be stacked in the same exact location.
 *
 * Arguments:
 * * copied_item - The paper, document, or photo that was just spawned on top of the printer.
 */
/obj/machinery/photocopier/proc/give_pixel_offset(obj/item/copied_item)
	copied_item.pixel_x = copied_item.base_pixel_x + rand(-10, 10)
	copied_item.pixel_y = copied_item.base_pixel_y + rand(-10, 10)

/// Gets the total amount of paper this printer has stored.
/obj/machinery/photocopier/proc/get_paper_count()
	return length(paper_stack) + starting_paper

/**
 * Returns an empty paper, used for blanks and paper copies.
 * Prioritizes `paper_stack`, creates new paper in case `paper_stack` is empty.
 */
/obj/machinery/photocopier/proc/get_empty_paper()
	var/obj/item/paper/new_paper = pop(paper_stack)
	if(new_paper == null && starting_paper > 0)
		new_paper = new /obj/item/paper
		starting_paper--
	return new_paper

/**
 * Removes an amount of paper from the printer's storage.
 * This lets us pretend we actually consumed paper when we were actually printing something that wasn't paper.
 */
/obj/machinery/photocopier/proc/delete_paper(number)
	if(number > get_paper_count())
		CRASH("Trying to delete more paper than is stored in the photocopier")
	for(var/i in 1 to number)
		var/to_delete = pop(paper_stack)
		if(to_delete)
			qdel(to_delete)
		else
			starting_paper--

/**
 * Handles the copying of paper. Transfers all the text, stamps and so on from the old paper, to the copy.
 *
 * Checks first if `paper_copy` exists. Since this proc is called from a timer, it's possible that it was removed.
 */
/obj/machinery/photocopier/proc/make_paper_copy(obj/item/paper/paper_copy)
	if(isnull(paper_copy))
		return null

	var/obj/item/paper/empty_paper = get_empty_paper()
	toner_cartridge.charges -= PAPER_TONER_USE

	var/copy_colour = get_toner_color()

	var/obj/item/paper/copied_paper = paper_copy.copy(empty_paper, src, FALSE, copy_colour)
	copied_paper.name = paper_copy.name
	return copied_paper

/**
 * Handles the copying of photos, which can be printed in either color or greyscale.
 *
 * Checks first if `picture` exists. Since this proc is called from a timer, it's possible that it was removed.
 */
/obj/machinery/photocopier/proc/make_photo_copy(datum/picture/photo, photo_color)
	if(isnull(photo))
		return null
	var/obj/item/photo/copied_pic = new(src, photo.Copy(photo_color == PHOTO_GREYSCALE ? TRUE : FALSE))
	delete_paper(PHOTO_PAPER_USE)
	toner_cartridge.charges -= PHOTO_TONER_USE
	return copied_pic

/**
 * Handles the copying of documents.
 *
 * Checks first if `document_copy` exists. Since this proc is called from a timer, it's possible that it was removed.
 */
/obj/machinery/photocopier/proc/make_document_copy(obj/item/documents/document_copy)
	if(isnull(document_copy))
		return null
	var/obj/item/documents/photocopy/copied_doc = new(src, document_copy)
	delete_paper(DOCUMENT_PAPER_USE)
	toner_cartridge.charges -= DOCUMENT_TONER_USE
	return copied_doc

/**
 * Handles the copying of documents.
 *
 * Checks first if `paperwork_copy` exists. Since this proc is called from a timer, it's possible that it was removed.
 * Copies the stamp from a given piece of paperwork if it is already stamped, allowing for you to sell photocopied paperwork at the risk of losing budget money.
 */
/obj/machinery/photocopier/proc/make_paperwork_copy(obj/item/paperwork/paperwork_copy)
	if(isnull(paperwork_copy))
		return null
	var/obj/item/paperwork/photocopy/copied_paperwork = new(src, paperwork_copy)
	copied_paperwork.copy_stamp_info(paperwork_copy)
	if(paperwork_copy.stamped)
		copied_paperwork.stamp_icon = "paper_stamp-pc" //Override with the photocopy overlay sprite
		copied_paperwork.add_stamp()
	delete_paper(PAPERWORK_PAPER_USE)
	toner_cartridge.charges -= PAPERWORK_TONER_USE
	return copied_paperwork

/// Handles the copying of blanks. No mutating state, so this should not fail.
/obj/machinery/photocopier/proc/make_blank_print(list/blank)
	var/copy_colour = get_toner_color()
	var/obj/item/paper/printblank = get_empty_paper()

	var/printname = blank["name"]
	var/list/printinfo
	for(var/infoline in blank["info"])
		printinfo += infoline

	printblank.name = "paper - '[printname]'"
	printblank.add_raw_text(printinfo, color = copy_colour)
	printblank.update_appearance()

	toner_cartridge.charges -= PAPER_TONER_USE
	return printblank

/**
 * Handles the copying of an ass photo.
 *
 * Calls `check_ass()` first to make sure that `ass` exists, among other conditions. Since this proc is called from a timer, it's possible that it was removed.
 * Additionally checks that the mob has their clothes off.
 */
/obj/machinery/photocopier/proc/make_ass_copy()
	if(!check_ass())
		return null
	var/icon/temp_img = ass.get_butt_sprite()
	if(isnull(temp_img))
		return null
	var/obj/item/photo/copied_ass = new /obj/item/photo(src)
	var/datum/picture/toEmbed = new(name = "[ass]的屁股", desc = "你看见[ass]的屁股在照片上.", image = temp_img)
	toEmbed.psize_x = 128
	toEmbed.psize_y = 128
	copied_ass.set_picture(toEmbed, TRUE, TRUE)
	delete_paper(ASS_PAPER_USE)
	toner_cartridge.charges -= ASS_TONER_USE
	return copied_ass

/**
 * Called when someone hits the "remove item" button on the copier UI.
 *
 * If the user is a silicon, it drops the object at the location of the copier. If the user is not a silicon, it tries to put the object in their hands first.
 * Sets `busy` to `FALSE` because if the inserted item is removed, the copier should halt copying.
 *
 * Arguments:
 * * object - the item we're trying to remove.
 * * user - the user removing the item.
 */
/obj/machinery/photocopier/proc/remove_photocopy(obj/item/object, mob/user)
	if(issilicon(user))
		object.forceMove(drop_location())
		return

	object.forceMove(user.loc)
	user.put_in_hands(object)

	to_chat(user, span_notice("你从[src]中取出[object]. [busy ? "[src]停下了." : ""]"))

/obj/machinery/photocopier/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/photocopier/attackby(obj/item/object, mob/user, params)
	if(istype(object, /obj/item/paper) || istype(object, /obj/item/photo) || istype(object, /obj/item/documents))
		if(istype(object, /obj/item/paper))
			var/obj/item/paper/paper = object
			if(paper.is_empty())
				insert_empty_paper(paper, user)
				return
		insert_copy_object(object, user)

	else if(istype(object, /obj/item/toner))
		if(toner_cartridge)
			balloon_alert(user, "里面已有墨盒!")
			return
		object.forceMove(src)
		toner_cartridge = object
		balloon_alert(user, "墨盒已放入")

	else if(istype(object, /obj/item/blueprints))
		to_chat(user, span_warning("[object]太大了，无法放入复印机，你需要找其他东西来记录这份文件."))

	else if(istype(object, /obj/item/paperwork))
		if(istype(object, /obj/item/paperwork/photocopy)) //No infinite paper chain. You need the original paperwork to make more copies.
			to_chat(user, span_warning("[object]太乱了，无法复印出清晰的内容!"))
		else
			insert_copy_object(object, user)

/// Proc that handles insertion of empty paper, useful for copying later.
/obj/machinery/photocopier/proc/insert_empty_paper(obj/item/paper/paper, mob/user)
	if(istype(paper, /obj/item/paper/paperslip))
		return
	if(get_paper_count() >= MAX_PAPER_CAPACITY)
		balloon_alert(user, "装载不下更多纸张了!")
		return
	if(!user.temporarilyRemoveItemFromInventory(paper))
		return
	paper_stack += paper
	paper.forceMove(src)
	balloon_alert(user, "纸张插入")

/obj/machinery/photocopier/proc/insert_copy_object(obj/item/object, mob/user)
	if(!copier_empty())
		balloon_alert(user, "扫描锁盘已被占用!")
		return
	if(!user.temporarilyRemoveItemFromInventory(object))
		return
	object_copy = object
	object.forceMove(src)
	balloon_alert(user, "复印物品插入")
	flick("photocopier1", src)

/obj/machinery/photocopier/atom_break(damage_flag)
	. = ..()
	if(. && toner_cartridge.charges)
		new /obj/effect/decal/cleanable/oil(get_turf(src))
		toner_cartridge.charges = 0

/obj/machinery/photocopier/mouse_drop_receive(mob/target, mob/user, params)
	if(!istype(target) || target.anchored || target.buckled || target == ass || copier_blocked())
		return
	add_fingerprint(user)
	if(target == user)
		user.visible_message(span_notice("[user]开始爬上复印机!"), span_notice("你开始爬上复印机..."))
	else
		user.visible_message(span_warning("[user]开始把[target]放到复印机上!"), span_notice("你开始把[target]放到复印机上!..."))

	if(do_after(user, 2 SECONDS, target = src))
		if(!target || QDELETED(target) || QDELETED(src) || !Adjacent(target)) //check if the photocopier/target still exists.
			return

		if(target == user)
			user.visible_message(span_notice("[user]爬上了复印机!"), span_notice("你爬上了复印机."))
		else
			user.visible_message(span_warning("[user]把[target]放到了复印机上!"), span_notice("你把[target]放到了复印机上."))

		target.forceMove(drop_location())
		ass = target

		if(!isnull(object_copy))
			object_copy.forceMove(drop_location())
			visible_message(span_warning("[object_copy]被[ass]挡住了!"))
			object_copy = null

/**
 * Checks the living mob `ass` exists and its location is the same as the photocopier.
 *
 * Returns FALSE if `ass` doesn't exist or is not at the copier's location. Returns TRUE otherwise.
 */
/obj/machinery/photocopier/proc/check_ass() //I'm not sure wether I made this proc because it's good form or because of the name.
	if(!isliving(ass))
		return FALSE
	if(ass.loc != loc)
		ass = null
		return FALSE
	return TRUE

/**
 * Checks if the copier is deleted, or has something dense at its location. Called in `mouse_drop_receive()`
 */
/obj/machinery/photocopier/proc/copier_blocked()
	if(QDELETED(src))
		return
	if(loc.density)
		return TRUE
	for(var/atom/movable/AM in loc)
		if(AM == src)
			continue
		if(AM.density)
			return TRUE
	return FALSE

/**
 * Checks if there is an item inserted into the copier or a mob sitting on top of it.
 *
 * Return `FALSE` is the copier has something inside of it. Returns `TRUE` if it doesn't.
 */
/obj/machinery/photocopier/proc/copier_empty()
	if(object_copy || check_ass())
		return FALSE
	else
		return TRUE

/// Subtype of photocopier that is free to use.
/obj/machinery/photocopier/gratis
	desc = "它处理的是同样重要的文件，但使用却是免费的！这是最好的一种免费服务."

/obj/machinery/photocopier/gratis/setup_components()
	// it's free! no charge! very cool and gratis-pilled.
	AddComponent(/datum/component/payment, 0, SSeconomy.get_dep_account(ACCOUNT_CIV), PAYMENT_CLINICAL)

/*
 * Toner cartridge
 */
/obj/item/toner
	name = "墨盒"
	desc = "一个小巧轻便的Nanotrasen ValueBrand碳粉盒，适用于复印机和自动绘图仪."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "tonercartridge"
	grind_results = list(/datum/reagent/iodine = 40, /datum/reagent/iron = 10)
	var/charges = 5
	var/max_charges = 5

/obj/item/toner/examine(mob/user)
	. = ..()
	. += span_notice("墨位计上写着[round(charges / max_charges * 100)]%")

/obj/item/toner/large
	name = "大墨盒"
	desc = "一大盒Nanotrasen ValueBrand碳粉盒，适用于复印机和自动绘图仪."
	grind_results = list(/datum/reagent/iodine = 90, /datum/reagent/iron = 10)
	charges = 25
	max_charges = 25

/obj/item/toner/extreme
	name = "超大墨盒"
	desc = "为什么会有人需要这么多的墨粉?"
	charges = 200
	max_charges = 200

#undef PHOTOCOPIER_FEE
#undef BLANKS_FILE_NAME
#undef PAPER_PAPER_USE
#undef PHOTO_PAPER_USE
#undef DOCUMENT_PAPER_USE
#undef ASS_PAPER_USE
#undef PAPERWORK_PAPER_USE
#undef MAX_PAPER_CAPACITY
#undef TONER_CHARGE_LOW_AMOUNT
#undef PHOTO_GREYSCALE
#undef PHOTO_COLOR
#undef PAPER_TONER_USE
#undef PHOTO_TONER_USE
#undef DOCUMENT_TONER_USE
#undef ASS_TONER_USE
#undef MAX_COPIES_AT_ONCE
#undef PAPERWORK_TONER_USE
