/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "lockbox+l"
	inhand_icon_state = "lockbox"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	req_access = list(ACCESS_ARMORY)
	var/broken = FALSE
	var/open = FALSE
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"

/obj/item/storage/lockbox/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_total_storage = 14
	atom_storage.max_slots = 4
	atom_storage.locked = TRUE

	register_context()

/obj/item/storage/lockbox/storage_insert_on_interacted_with(datum/storage, obj/item/inserted, mob/living/user)
	var/locked = atom_storage.locked
	if(inserted.GetID())
		if(broken)
			balloon_alert(user, "broken!")
			return FALSE
		if(allowed(user))
			if(atom_storage.locked)
				atom_storage.locked = STORAGE_NOT_LOCKED
			else
				atom_storage.locked = STORAGE_FULLY_LOCKED
			locked = atom_storage.locked
			if(locked)
				icon_state = icon_locked
				atom_storage.close_all()
			else
				icon_state = icon_closed

			balloon_alert(user, locked ? "已上锁" : "已解锁")
			return FALSE

		balloon_alert(user, "权限不足!")
		return FALSE

	if(locked)
		balloon_alert(user, "已上锁!")
		return FALSE

	return TRUE

/obj/item/storage/lockbox/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(!broken)
		broken = TRUE
		atom_storage.locked = STORAGE_NOT_LOCKED
		icon_state = src.icon_broken
		balloon_alert(user, "锁已损坏")
		if (emag_card && user)
			user.visible_message(span_warning("[user]在[src]上刷[emag_card]，破坏了锁!"))
		return TRUE
	return FALSE

/obj/item/storage/lockbox/examine(mob/user)
	. = ..()
	if(broken)
		. += span_notice("它似乎坏了.")

/obj/item/storage/lockbox/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	open = TRUE
	update_appearance()

/obj/item/storage/lockbox/Exited(atom/movable/gone, direction)
	. = ..()
	open = TRUE
	update_appearance()

/obj/item/storage/lockbox/loyalty
	name = "心盾植入物锁箱"
	req_access = list(ACCESS_SECURITY)

/obj/item/storage/lockbox/loyalty/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/implantcase/mindshield(src)
	new /obj/item/implanter/mindshield(src)

/obj/item/storage/lockbox/clusterbang
	name = "爆弹锁箱"
	desc = "你对打开这个有不好的预感."
	req_access = list(ACCESS_SECURITY)

/obj/item/storage/lockbox/clusterbang/PopulateContents()
	new /obj/item/grenade/clusterbuster(src)

/obj/item/storage/lockbox/medal
	name = "奖章盒"
	desc = "一个上锁的盒子，用来存放荣誉勋章."
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "medalbox+l"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	req_access = list(ACCESS_CAPTAIN)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"

/obj/item/storage/lockbox/medal/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.max_slots = 10
	atom_storage.max_total_storage = 20
	atom_storage.set_holdable(/obj/item/clothing/accessory/medal)

/obj/item/storage/lockbox/medal/examine(mob/user)
	. = ..()
	if(!atom_storage.locked)
		. += span_notice("Alt加左键[open ? "关闭":"打开"]它.")

/obj/item/storage/lockbox/medal/click_alt(mob/user)
	if(!atom_storage.locked)
		open = (open ? FALSE : TRUE)
		update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/storage/lockbox/medal/PopulateContents()
	new /obj/item/clothing/accessory/medal/gold/captain(src)
	new /obj/item/clothing/accessory/medal/silver/valor(src)
	new /obj/item/clothing/accessory/medal/silver/valor(src)
	new /obj/item/clothing/accessory/medal/silver/security(src)
	new /obj/item/clothing/accessory/medal/bronze_heart(src)
	new /obj/item/clothing/accessory/medal/plasma/nobel_science(src)
	new /obj/item/clothing/accessory/medal/plasma/nobel_science(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/conduct(src)

/obj/item/storage/lockbox/medal/update_icon_state()
	if(atom_storage?.locked)
		icon_state = "medalbox+l"
		return ..()

	icon_state = "medalbox"
	if(open)
		icon_state += "open"
	if(broken)
		icon_state += "+b"
	return ..()

/obj/item/storage/lockbox/medal/update_overlays()
	. = ..()
	if(!contents || !open)
		return
	if(atom_storage?.locked)
		return
	for(var/i in 1 to contents.len)
		var/obj/item/clothing/accessory/medal/M = contents[i]
		var/mutable_appearance/medalicon = mutable_appearance(initial(icon), M.medaltype)
		if(i > 1 && i <= 5)
			medalicon.pixel_x += ((i-1)*3)
		else if(i > 5)
			medalicon.pixel_y -= 7
			medalicon.pixel_x -= 2
			medalicon.pixel_x += ((i-6)*3)
		. += medalicon

/obj/item/storage/lockbox/medal/hop
	name = "人事主任奖章盒"
	desc = "一个上锁的盒子，用来存放奖状，颁发给管理优秀的人."
	req_access = list(ACCESS_HOP)

/obj/item/storage/lockbox/medal/hop/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/silver/bureaucracy(src)
	new /obj/item/clothing/accessory/medal/gold/ordom(src)

/obj/item/storage/lockbox/medal/sec
	name = "安保奖章盒"
	desc = "一个上锁的盒子，用来存放给安保部门成员的奖章."
	req_access = list(ACCESS_HOS)

/obj/item/storage/lockbox/medal/med
	name = "医疗奖章盒"
	desc = "一个上锁的盒子，用来存放给医疗部门成员的奖章."
	req_access = list(ACCESS_CMO)

/obj/item/storage/lockbox/medal/med/PopulateContents()
	new /obj/item/clothing/accessory/medal/med_medal(src)
	new /obj/item/clothing/accessory/medal/med_medal2(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/silver/emergency_services/medical(src)

/obj/item/storage/lockbox/medal/sec/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/silver/security(src)

/obj/item/storage/lockbox/medal/cargo
	name = "货仓奖品盒"
	desc = "一个上锁的箱子，用来存放发给货运部员工的奖品."
	req_access = list(ACCESS_QM)

/obj/item/storage/lockbox/medal/cargo/PopulateContents()
		new /obj/item/clothing/accessory/medal/ribbon/cargo(src)

/obj/item/storage/lockbox/medal/service
	name = "服务奖品盒"
	desc = "一个上锁的箱子，用来存放发给货运部员工的奖品."
	req_access = list(ACCESS_HOP)

/obj/item/storage/lockbox/medal/service/PopulateContents()
		new /obj/item/clothing/accessory/medal/silver/excellence(src)

/obj/item/storage/lockbox/medal/sci
	name = "科研奖章盒"
	desc = "一个上锁的盒子，用来存放颁发给科研部门成员的奖章."
	req_access = list(ACCESS_RD)

/obj/item/storage/lockbox/medal/sci/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/plasma/nobel_science(src)

/obj/item/storage/lockbox/medal/engineering
	name = "工程奖章盒"
	desc = "一个上锁的盒子，用来存放给工程部成员的奖励."
	req_access = list(ACCESS_CE)

/obj/item/storage/lockbox/medal/engineering/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/silver/emergency_services/engineering(src)
	new /obj/item/clothing/accessory/medal/silver/elder_atmosian(src)

/obj/item/storage/lockbox/order
	name = "购物小锁箱"
	desc = "一个箱子，用来保证小货物不被没有下单的人抢走，对，货仓技工，就是你."
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "secure"
	icon_closed = "secure"
	icon_locked = "secure_locked"
	icon_broken = "secure+b"
	inhand_icon_state = "sec-case"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	var/datum/bank_account/buyer_account
	var/privacy_lock = TRUE

/obj/item/storage/lockbox/order/Initialize(mapload, datum/bank_account/_buyer_account)
	. = ..()
	buyer_account = _buyer_account
	ADD_TRAIT(src, TRAIT_NO_MISSING_ITEM_ERROR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NO_MANIFEST_CONTENTS_ERROR, TRAIT_GENERIC)
	//SKYRAT EDIT START
	if(istype(buyer_account, /datum/bank_account/department))
		department_purchase = TRUE
		department_account = buyer_account
	//SKYRAT EDIT END

/obj/item/storage/lockbox/order/storage_insert_on_interacted_with(datum/storage, obj/item/inserted, mob/living/user)
	var/obj/item/card/id/id_card = inserted.GetID()
	if(!id_card)
		return ..()

	if(id_card.registered_account != buyer_account)
		balloon_alert(user, "错误的银行账户!")
		return FALSE

	if(privacy_lock)
		atom_storage.locked = STORAGE_NOT_LOCKED
		icon_state = icon_locked
	else
		atom_storage.locked = STORAGE_FULLY_LOCKED
		icon_state = icon_closed
	privacy_lock = atom_storage.locked
	user.visible_message(
		span_notice("[user] [privacy_lock ? "锁上" : "解锁"][src]的私人锁."),
		span_notice("你[privacy_lock ? "锁上" : "解锁"][src]的私人锁.")
	)
	return FALSE

///screentips for lockboxes
/obj/item/storage/lockbox/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(!held_item)
		return NONE
	if(src.broken)
		return NONE
	if(!held_item.GetID())
		return NONE
	context[SCREENTIP_CONTEXT_LMB] = atom_storage.locked ? "用ID卡解锁" : "用ID卡上锁"
	return CONTEXTUAL_SCREENTIP_SET
