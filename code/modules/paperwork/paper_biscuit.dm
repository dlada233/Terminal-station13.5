/obj/item/folder/biscuit
	name = "封套卡"
	desc = "封套卡. 背面写有大字:<b>切勿吞食</b>."
	icon_state = "paperbiscuit"
	bg_color = "#ffffff"
	w_class = WEIGHT_CLASS_TINY
	max_integrity = 130
	drop_sound = 'sound/items/handling/disk_drop.ogg'
	pickup_sound = 'sound/items/handling/disk_pickup.ogg'
	contents_hidden = TRUE
	/// Is biscuit cracked open or not?
	var/cracked = FALSE
	/// The paper slip inside, if there is one
	var/obj/item/paper/paperslip/contained_slip

/obj/item/folder/biscuit/Initialize(mapload)
	. = ..()
	if(ispath(contained_slip, /obj/item/paper/paperslip))
		contained_slip = new contained_slip(src)

/obj/item/folder/biscuit/Destroy()
	if(isdatum(contained_slip))
		QDEL_NULL(contained_slip)
	return ..()

/obj/item/folder/biscuit/Exited(atom/movable/gone, direction)
	. = ..()
	if(contained_slip == gone)
		contained_slip = null

/obj/item/folder/biscuit/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(isnull(contained_slip) && istype(arrived, /obj/item/paper/paperslip))
		contained_slip = arrived

/obj/item/folder/biscuit/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] tries to eat [src]! [user.p_theyre()] trying to commit suicide!"))
	playsound(get_turf(user), 'sound/effects/wounds/crackandbleed.ogg', 40, TRUE) //Don't eat plastic cards kids, they get really sharp if you chew on them.
	return BRUTELOSS

/obj/item/folder/biscuit/update_overlays()
	. = ..()
	if(contents.len) //This is to prevent the unsealed biscuit from having the folder_paper overlay when it gets sealed
		. -= "folder_paper"
		if(cracked) //Shows overlay only when it has contents and is cracked open
			. += "paperbiscuit_paper"

///Checks if the biscuit has been already cracked.
/obj/item/folder/biscuit/proc/crack_check(mob/user)
	if (cracked)
		return TRUE
	balloon_alert(user, "unopened!")
	return FALSE

/obj/item/folder/biscuit/examine()
	. = ..()
	if(cracked)
		. += span_notice("It's been cracked open.")
	else
		. += span_notice("You'll need to crack it open to access its contents.")
		if(contained_slip)
			. += "This one contains [contained_slip.name]."

//The next few checks are done to prevent you from reaching the contents or putting anything inside when it's not cracked open
/obj/item/folder/biscuit/remove_item(obj/item/item, mob/user)
	if (!crack_check(user))
		return

	return ..()

/obj/item/folder/biscuit/attack_hand(mob/user, list/modifiers)
	if (LAZYACCESS(modifiers, RIGHT_CLICK) && !crack_check(user))
		return

	return ..()

/obj/item/folder/biscuit/attackby(obj/item/weapon, mob/user, params)
	if (is_type_in_typecache(weapon, folder_insertables) && !crack_check(user))
		return

	return ..()

/obj/item/folder/biscuit/attack_self(mob/user)
	add_fingerprint(user)
	if (!cracked)
		if (tgui_alert(user, "你想打开它吗?", "饼干卡", list("Yes", "No")) != "Yes")
			return
		cracked = TRUE
		contents_hidden = FALSE
		playsound(get_turf(user), 'sound/effects/wounds/crack1.ogg', 60)
		icon_state = "[icon_state]_cracked"
		update_appearance()

	ui_interact(user)

//Corporate "confidential" biscuit cards
/obj/item/folder/biscuit/confidential
	name = "机密封套卡"
	desc = "封套卡片，印着的纳米文字让它看起来有点像巧克力，背面写有大字:<b>切勿吞食</b>."
	icon_state = "paperbiscuit_secret"
	bg_color = "#355e9f"

/obj/item/folder/biscuit/confidential/spare_id_safe_code
	name = "备用ID安全码封套卡"
	contained_slip = /obj/item/paper/paperslip/corporate/fluff/spare_id_safe_code

/obj/item/folder/biscuit/confidential/emergency_spare_id_safe_code
	name = "备用应急ID安全吗封套卡"
	contained_slip = /obj/item/paper/paperslip/corporate/fluff/emergency_spare_id_safe_code

//Biscuits which start open. Used for crafting, printing, and such
/obj/item/folder/biscuit/unsealed
	name = "封套卡"
	desc = "封套卡. 背面写有大字:<b>切勿吞食</b>."
	icon_state = "paperbiscuit_cracked"
	contents_hidden = FALSE
	cracked = TRUE
	///Was the biscuit already sealed by players? Prevents re-sealing after use
	var/has_been_sealed = FALSE
	///What is the sprite for when it's sealed? It starts unsealed, so needs a sprite for when it's sealed.
	var/sealed_icon = "paperbiscuit"

/obj/item/folder/biscuit/unsealed/examine()
	. = ..()
	if(!has_been_sealed)
		. += span_notice("这个可以被<b>亲手</b>密封，密封后除非拆开封套卡否则无法查看里面内容，并且拆开后无法复原.")

//Asks if you want to seal the biscuit, after you do that it behaves like a normal paper biscuit.
/obj/item/folder/biscuit/unsealed/attack_self(mob/user)
	add_fingerprint(user)
	if(!cracked)
		return ..()
	if(tgui_alert(user, "你确定要封上吗，该操作只能做一次.", "封套卡封装", list("Yes", "No")) != "Yes")
		return
	cracked = FALSE
	has_been_sealed = TRUE
	contents_hidden = TRUE
	playsound(get_turf(user), 'sound/items/duct_tape_snap.ogg', 60)
	icon_state = "[sealed_icon]"
	update_appearance()

/obj/item/folder/biscuit/unsealed/confidential
	name = "机密封套卡"
	desc = "封套卡片，印着的纳米文字让它看起来有点像巧克力，背面写有大字:<b>切勿吞食</b>."
	icon_state = "paperbiscuit_secret_cracked"
	bg_color = "#355e9f"
	sealed_icon = "paperbiscuit_secret"
