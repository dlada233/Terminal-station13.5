// Eldritch armor. Looks cool, hood lets you cast heretic spells.
/obj/item/clothing/head/hooded/cult_hoodie/eldritch
	name = "不详兜帽"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "eldritch"
	desc = "破旧、满是灰尘的兜帽，怪异的多眼排列在里面."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flash_protect = FLASH_PROTECTION_WELDER

/obj/item/clothing/head/hooded/cult_hoodie/eldritch/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/heretic_focus)

/obj/item/clothing/suit/hooded/cultrobes/eldritch
	name = "不详护甲"
	desc = "一身破旧、满是灰尘的长袍，怪异的多眼排列在里面."
	icon_state = "eldritch_armor"
	inhand_icon_state = null
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	allowed = list(/obj/item/melee/sickly_blade)
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/eldritch
	// Slightly better than normal cult robes
	armor_type = /datum/armor/cultrobes_eldritch

/datum/armor/cultrobes_eldritch
	melee = 50
	bullet = 50
	laser = 50
	energy = 50
	bomb = 35
	bio = 20
	fire = 20
	acid = 20
	wound = 20

/obj/item/clothing/suit/hooded/cultrobes/eldritch/examine(mob/user)
	. = ..()
	if(!IS_HERETIC(user))
		return
	if(hood_up)
		return

	// Our hood gains the heretic_focus element.
	. += span_notice("戴上兜帽时获得焦点.")

// Void cloak. Turns invisible with the hood up, lets you hide stuff.
/obj/item/clothing/head/hooded/cult_hoodie/void
	name = "虚空兜帽"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	desc = "黑如柏油，任何光都不被反射. 符文排列在外，每次闪烁你都会对失去对所见事物的理解."
	icon_state = "void_cloak"
	flags_inv = NONE
	flags_cover = NONE
	item_flags = EXAMINE_SKIP
	armor_type = /datum/armor/cult_hoodie_void

/datum/armor/cult_hoodie_void
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 15
	wound = 10

/obj/item/clothing/head/hooded/cult_hoodie/void/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_STRIP, REF(src))

/obj/item/clothing/suit/hooded/cultrobes/void
	name = "虚空斗篷"
	desc = "黑如柏油，任何光都不被反射. 符文排列在外，每次闪烁你都会对失去对所见事物的理解."
	icon_state = "void_cloak"
	inhand_icon_state = null
	allowed = list(/obj/item/melee/sickly_blade)
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/void
	flags_inv = NONE
	body_parts_covered = CHEST|GROIN|ARMS
	// slightly worse than normal cult robes
	armor_type = /datum/armor/cultrobes_void
	alternative_mode = TRUE

/datum/armor/cultrobes_void
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 15
	wound = 10

/obj/item/clothing/suit/hooded/cultrobes/void/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/void_cloak)
	make_visible()

/obj/item/clothing/suit/hooded/cultrobes/void/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_OCLOTHING)
		RegisterSignal(user, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(hide_item))
		RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(show_item))

/obj/item/clothing/suit/hooded/cultrobes/void/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, list(COMSIG_MOB_UNEQUIPPED_ITEM, COMSIG_MOB_EQUIPPED_ITEM))

/obj/item/clothing/suit/hooded/cultrobes/void/proc/hide_item(datum/source, obj/item/item, slot)
	SIGNAL_HANDLER
	if(slot & ITEM_SLOT_SUITSTORE)
		ADD_TRAIT(item, TRAIT_NO_STRIP, REF(src)) // i'd use examine hide but its a flag and yeah

/obj/item/clothing/suit/hooded/cultrobes/void/proc/show_item(datum/source, obj/item/item, slot)
	SIGNAL_HANDLER
	REMOVE_TRAIT(item, TRAIT_NO_STRIP, REF(src))

/obj/item/clothing/suit/hooded/cultrobes/void/examine(mob/user)
	. = ..()
	if(!IS_HERETIC(user))
		return
	if(!hood_up)
		return

	// Let examiners know this works as a focus only if the hood is down
	. += span_notice("在兜帽放下时，你将获得焦点.")

/obj/item/clothing/suit/hooded/cultrobes/void/on_hood_down(obj/item/clothing/head/hooded/hood)
	make_visible()
	return ..()

/obj/item/clothing/suit/hooded/cultrobes/void/can_create_hood()
	if(!isliving(loc))
		CRASH("[src] attempted to make a hood on a non-living thing: [loc]")
	var/mob/living/wearer = loc
	if(IS_HERETIC_OR_MONSTER(wearer))
		return TRUE

	loc.balloon_alert(loc, "没法把兜帽戴上!")
	return FALSE

/obj/item/clothing/suit/hooded/cultrobes/void/on_hood_created(obj/item/clothing/head/hooded/hood)
	. = ..()
	make_invisible()

/// Makes our cloak "invisible". Not the wearer, the cloak itself.
/obj/item/clothing/suit/hooded/cultrobes/void/proc/make_invisible()
	item_flags |= EXAMINE_SKIP
	ADD_TRAIT(src, TRAIT_NO_STRIP, REF(src))
	RemoveElement(/datum/element/heretic_focus)

	if(isliving(loc))
		loc.balloon_alert(loc, "斗篷隐形")
		loc.visible_message(span_notice("光游移在[loc]周身，使得斗篷变得不可见!"))

/// Makes our cloak "visible" again.
/obj/item/clothing/suit/hooded/cultrobes/void/proc/make_visible()
	item_flags &= ~EXAMINE_SKIP
	REMOVE_TRAIT(src, TRAIT_NO_STRIP, REF(src))
	AddElement(/datum/element/heretic_focus)

	if(isliving(loc))
		loc.balloon_alert(loc, "斗篷显形")
		loc.visible_message(span_notice("周围[loc]的光线万花筒般崩溃，穿着斗篷的人突然出现!"))
