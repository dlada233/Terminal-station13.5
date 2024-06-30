#define ORE_BAG_BALOON_COOLDOWN (2 SECONDS)

/*
 * These absorb the functionality of the plant bag, ore satchel, etc.
 * They use the use_to_pickup, quick_gather, and quick_empty functions
 * that were already defined in weapon/storage, but which had been
 * re-implemented in other classes.
 *
 * Contains:
 * Trash Bag
 * Mining Satchel
 * Plant Bag
 * Sheet Snatcher
 * Book Bag
 *      Biowaste Bag
 *
 * -Sayu
 */

//  Generic non-item
/obj/item/storage/bag
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/bag/Initialize(mapload)
	. = ..()
	atom_storage.allow_quick_gather = TRUE
	atom_storage.allow_quick_empty = TRUE
	atom_storage.numerical_stacking = TRUE

// -----------------------------
//          Trash bag
// -----------------------------
/obj/item/storage/bag/trash
	name = "垃圾袋"
	desc = "这是一种重型黑色聚合物，该扔垃圾了!"
	icon = 'icons/obj/service/janitor.dmi'
	icon_state = "trashbag"
	inhand_icon_state = "trashbag"
	worn_icon_state = "trashbag"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	storage_type = /datum/storage/trash
	///If true, can be inserted into the janitor cart
	var/insertable = TRUE

/obj/item/storage/bag/trash/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.max_total_storage = 30
	atom_storage.max_slots = 30
	atom_storage.set_holdable(cant_hold_list = /obj/item/disk/nuclear)
	atom_storage.supports_smart_equip = FALSE
	RegisterSignal(atom_storage, COMSIG_STORAGE_DUMP_POST_TRANSFER, PROC_REF(post_insertion))

/// If you dump a trash bag into something, anything that doesn't get inserted will spill out onto your feet
/obj/item/storage/bag/trash/proc/post_insertion(datum/storage/source, atom/dest_object, mob/user)
	SIGNAL_HANDLER
	// If there's no item in there, don't do anything
	if(!(locate(/obj/item) in src))
		return

	// Otherwise, we're gonna dump into the dest object
	var/turf/dump_onto = get_turf(dest_object)
	user.visible_message(
		span_notice("[user]将[src]的内容物全都倒进了[dump_onto]中"),
		span_notice("[src]的剩余垃圾落在了[dump_onto]中"),
	)
	source.remove_all(dump_onto)

/obj/item/storage/bag/trash/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]把[src]套到头上然后开始啃里面的东西! 恶心!"))
	playsound(loc, 'sound/items/eatfood.ogg', 50, TRUE, -1)
	return TOXLOSS

/obj/item/storage/bag/trash/update_icon_state()
	switch(contents.len)
		if(20 to INFINITY)
			icon_state = "[initial(icon_state)]3"
		if(11 to 20)
			icon_state = "[initial(icon_state)]2"
		if(1 to 11)
			icon_state = "[initial(icon_state)]1"
		else
			icon_state = "[initial(icon_state)]"
	return ..()

/obj/item/storage/bag/trash/cyborg/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CYBORG_ITEM_TRAIT)

/obj/item/storage/bag/trash/filled

/obj/item/storage/bag/trash/filled/PopulateContents()
	. = ..()
	for(var/i in 1 to rand(1, 7))
		new /obj/effect/spawner/random/trash/garbage(src)
	update_icon_state()

/obj/item/storage/bag/trash/bluespace
	name = "蓝空垃圾袋"
	desc = "最新、最便捷的储存工具，一个能装下大量垃圾的垃圾袋."
	icon_state = "bluetrashbag"
	inhand_icon_state = "bluetrashbag"
	item_flags = NO_MAT_REDEMPTION

/obj/item/storage/bag/trash/bluespace/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 60
	atom_storage.max_slots = 60

/obj/item/storage/bag/trash/bluespace/cyborg
	insertable = FALSE

// -----------------------------
//        Mining Satchel
// -----------------------------

/obj/item/storage/bag/ore
	name = "矿石袋"
	desc = "这个小东西专门用于储存矿石."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	worn_icon_state = "satchel"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_NORMAL
	///If this is TRUE, the holder won't receive any messages when they fail to pick up ore through crossing it
	var/spam_protection = FALSE
	var/mob/listeningTo
	///Cooldown on balloon alerts when picking ore
	COOLDOWN_DECLARE(ore_bag_balloon_cooldown)

/obj/item/storage/bag/ore/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_HUGE
	atom_storage.max_total_storage = 50
	atom_storage.numerical_stacking = TRUE
	atom_storage.allow_quick_empty = TRUE
	atom_storage.allow_quick_gather = TRUE
	atom_storage.set_holdable(/obj/item/stack/ore)
	atom_storage.silent_for_user = TRUE

/obj/item/storage/bag/ore/equipped(mob/user)
	. = ..()
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(pickup_ores))
	listeningTo = user

/obj/item/storage/bag/ore/dropped()
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		listeningTo = null

/obj/item/storage/bag/ore/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/boulder))
		to_chat(user, span_warning("You can't fit \the [attacking_item] into \the [src]. Perhaps you should break it down first, or find an ore box."))
		return TRUE
	return ..()

/obj/item/storage/bag/ore/proc/pickup_ores(mob/living/user)
	SIGNAL_HANDLER

	var/show_message = FALSE
	var/obj/structure/ore_box/box
	var/turf/tile = get_turf(user)

	if(!isturf(tile))
		return

	if(istype(user.pulling, /obj/structure/ore_box))
		box = user.pulling

	if(atom_storage)
		for(var/thing in tile)
			if(!is_type_in_typecache(thing, atom_storage.can_hold))
				continue
			if(box)
				user.transferItemToLoc(thing, box)
				show_message = TRUE
			else if(atom_storage.attempt_insert(thing, user))
				show_message = TRUE
			else
				if(!spam_protection)
					balloon_alert(user, "包满了!")
					spam_protection = TRUE
					continue
	if(show_message)
		playsound(user, SFX_RUSTLE, 50, TRUE)
		if(!COOLDOWN_FINISHED(src, ore_bag_balloon_cooldown))
			return

		COOLDOWN_START(src, ore_bag_balloon_cooldown, ORE_BAG_BALOON_COOLDOWN)
		if (box)
			balloon_alert(user, "把矿石送进盒子里")
			user.visible_message(
				span_notice("[user]卸下矿石到[box]."),
				ignored_mobs = user
			)
		else
			balloon_alert(user, "把矿石送进包里")
			user.visible_message(
				span_notice("[user]铲起了脚下的矿石."),
				ignored_mobs = user
			)

	spam_protection = FALSE

/obj/item/storage/bag/ore/cyborg
	name = "赛博矿石袋"

/obj/item/storage/bag/ore/holding //miners, your messiah has arrived
	name = "蓝空矿石袋"
	desc = "相比于普通矿石袋拥有革命性的便利性，不仅能储存大量矿石，还有一些防故障的安全措施."
	icon_state = "satchel_bspace"

/obj/item/storage/bag/ore/holding/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = INFINITY
	atom_storage.max_specific_storage = INFINITY
	atom_storage.max_total_storage = INFINITY

// -----------------------------
//          Plant bag
// -----------------------------

/obj/item/storage/bag/plants
	name = "种植袋"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "plantbag"
	worn_icon_state = "plantbag"
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/plants/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_total_storage = 100
	atom_storage.max_slots = 100
	atom_storage.set_holdable(list(
		/obj/item/food/grown,
		/obj/item/graft,
		/obj/item/grown,
		/obj/item/food/honeycomb,
		/obj/item/seeds,
	))

/obj/item/storage/bag/plants/portaseeder
	name = "便携式种子提取机"
	desc = "对于想要急速扩产的植物学家来说缺陷在于比固定式的生产效率低, 没株植物能生产一颗."
	icon_state = "portaseeder"

/obj/item/storage/bag/plants/portaseeder/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/storage/bag/plants/portaseeder/add_context(
	atom/source,
	list/context,
	obj/item/held_item,
	mob/living/user
)

	context[SCREENTIP_CONTEXT_CTRL_LMB] = "制作种子"
	return CONTEXTUAL_SCREENTIP_SET


/obj/item/storage/bag/plants/portaseeder/examine(mob/user)
	. = ..()
	. += span_notice("Ctrl+左键开始提取种子.")

/obj/item/storage/bag/plants/portaseeder/CtrlClick(mob/user)
	if(user.incapacitated())
		return
	for(var/obj/item/plant in contents)
		seedify(plant, 1)

// -----------------------------
//        Sheet Snatcher
// -----------------------------
// sorry sayu your sheet snatcher is now OBSOLETE but i'm leaving it because idc

/obj/item/storage/bag/sheetsnatcher
	name = "材料大师"
	desc = "用于大量储存如:铁板、木板等材料的Nanotrasen专利储存产品."
	icon = 'icons/obj/mining.dmi'
	icon_state = "sheetsnatcher"
	worn_icon_state = "satchel"

	var/capacity = 300 //the number of sheets it can carry.

/obj/item/storage/bag/sheetsnatcher/Initialize(mapload)
	. = ..()
	atom_storage.allow_quick_empty = TRUE
	atom_storage.allow_quick_gather = TRUE
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(
		can_hold_list = list(
			/obj/item/stack/sheet
		),
		cant_hold_list = list(
			/obj/item/stack/sheet/mineral/sandstone,
			/obj/item/stack/sheet/mineral/wood,
		),
	)
	atom_storage.max_total_storage = capacity / 2

// -----------------------------
//    Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/storage/bag/sheetsnatcher/borg
	name = "材料大师 9000"
	desc = ""
	capacity = 500//Borgs get more because >specialization

// -----------------------------
//           Book bag
// -----------------------------

/obj/item/storage/bag/books
	name = "书包"
	desc = "装书的包."
	icon = 'icons/obj/service/library.dmi'
	icon_state = "bookbag"
	worn_icon_state = "bookbag"
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/books/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_total_storage = 21
	atom_storage.max_slots = 7
	atom_storage.set_holdable(list(
		/obj/item/book,
		/obj/item/spellbook,
		/obj/item/poster,
	))

/*
 * Trays - Agouri
 */
/obj/item/storage/bag/tray
	name = "托盘"
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "tray"
	worn_icon_state = "tray"
	desc = "放食物的金属托盘."
	force = 5
	throwforce = 10
	throw_speed = 3
	throw_range = 5
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*1.5)
	custom_price = PAYCHECK_CREW * 0.6

/obj/item/storage/bag/tray/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY //Plates are required bulky to keep them out of backpacks
	atom_storage.set_holdable(
		can_hold_list = list(
			/obj/item/clothing/mask/cigarette,
			/obj/item/food,
			/obj/item/kitchen,
			/obj/item/lighter,
			/obj/item/organ,
			/obj/item/plate,
			/obj/item/reagent_containers/condiment,
			/obj/item/reagent_containers/cup,
			/obj/item/rollingpaper,
			/obj/item/storage/box/gum,
			/obj/item/storage/box/matches,
			/obj/item/storage/fancy,
			/obj/item/trash,
		),
		cant_hold_list = list(
			/obj/item/plate/oven_tray,
			/obj/item/reagent_containers/cup/soup_pot,
		),
	) //Should cover: Bottles, Beakers, Bowls, Booze, Glasses, Food, Food Containers, Food Trash, Organs, Tobacco Products, Lighters, and Kitchen Tools.
	atom_storage.insert_preposition = "on"
	atom_storage.max_slots = 8
	atom_storage.max_total_storage = 16

/obj/item/storage/bag/tray/attack(mob/living/M, mob/living/user)
	. = ..()
	// Drop all the things. All of them.
	var/list/obj/item/oldContents = contents.Copy()
	atom_storage.remove_all(user)
	// Make each item scatter a bit
	for(var/obj/item/tray_item in oldContents)
		do_scatter(tray_item)

	if(prob(50))
		playsound(M, 'sound/items/trayhit1.ogg', 50, TRUE)
	else
		playsound(M, 'sound/items/trayhit2.ogg', 50, TRUE)

	if(ishuman(M))
		if(prob(10))
			M.Paralyze(40)
	update_appearance()

/obj/item/storage/bag/tray/proc/do_scatter(obj/item/tray_item)
	var/delay = rand(2,4)
	var/datum/move_loop/loop = GLOB.move_manager.move_rand(tray_item, list(NORTH,SOUTH,EAST,WEST), delay, timeout = rand(1, 2) * delay, flags = MOVEMENT_LOOP_START_FAST)
	//This does mean scattering is tied to the tray. Not sure how better to handle it
	RegisterSignal(loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(change_speed))

/obj/item/storage/bag/tray/proc/change_speed(datum/move_loop/source)
	SIGNAL_HANDLER
	var/new_delay = rand(2, 4)
	var/count = source.lifetime / source.delay
	source.lifetime = count * new_delay
	source.delay = new_delay

/obj/item/storage/bag/tray/update_overlays()
	. = ..()
	for(var/obj/item/I in contents)
		var/mutable_appearance/I_copy = new(I)
		I_copy.plane = FLOAT_PLANE
		I_copy.layer = FLOAT_LAYER
		. += I_copy

/obj/item/storage/bag/tray/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	update_appearance()

/obj/item/storage/bag/tray/Exited(atom/movable/gone, direction)
	. = ..()
	update_appearance()

/obj/item/storage/bag/tray/cafeteria
	name = "自助餐厅托盘"
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "foodtray"
	desc = "A cheap metal tray to pile today's meal onto."

/*
 * Chemistry bag
 */

/obj/item/storage/bag/chemistry
	name = "化学用品袋"
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "bag"
	worn_icon_state = "chembag"
	desc = "用于集中储存贴片、药瓶或胶囊的袋子."
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/chemistry/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 200
	atom_storage.max_slots = 50
	atom_storage.set_holdable(list(
		/obj/item/reagent_containers/chem_pack,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/cup/glass/waterbottle,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/medigel,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
	))


/obj/item/storage/bag/bio
	name = "生化储存袋"
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "biobag"
	worn_icon_state = "biobag"
	desc = "用于安全运输和处置生物废物和其他有毒物质的袋子."
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/bio/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 200
	atom_storage.max_slots = 25
	atom_storage.set_holdable(list(
		/obj/item/bodypart,
		/obj/item/food/monkeycube,
		/obj/item/healthanalyzer,
		/obj/item/organ,
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/hypospray/medipen,
		/obj/item/reagent_containers/syringe,
	))

/*
 *  Science bag (mostly for xenobiologists)
 */

/obj/item/storage/bag/xeno
	name = "科研储存袋"
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "xenobag"
	worn_icon_state = "xenobag"
	desc = "用于集中储存异常材料的袋子."
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/xeno/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 200
	atom_storage.max_slots = 25
	atom_storage.set_holdable(list(
		/obj/item/bodypart,
		/obj/item/food/deadmouse,
		/obj/item/food/monkeycube,
		/obj/item/organ,
		/obj/item/petri_dish,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/syringe,
		/obj/item/slime_extract,
		/obj/item/swab,
	))

/*
 *  Construction bag (for engineering, holds stock parts and electronics)
 */

/obj/item/storage/bag/construction
	name = "建材包"
	icon = 'icons/obj/tools.dmi'
	icon_state = "construction_bag"
	worn_icon_state = "construction_bag"
	desc = "用于集中储存小型建材的小包."
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/construction/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 100
	atom_storage.max_slots = 50
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.set_holdable(list(
		/obj/item/assembly,
		/obj/item/circuitboard,
		/obj/item/electronics,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/stack/cable_coil,
		/obj/item/stack/ore/bluespace_crystal,
		/obj/item/stock_parts,
		/obj/item/wallframe/camera,
	))

/obj/item/storage/bag/harpoon_quiver
	name = "鱼叉箭袋"
	desc = "用来装鱼叉的箭袋."
	icon = 'icons/obj/weapons/bows/quivers.dmi'
	icon_state = "quiver"
	inhand_icon_state = null
	worn_icon_state = "harpoon_quiver"

/obj/item/storage/bag/harpoon_quiver/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_TINY
	atom_storage.max_slots = 40
	atom_storage.max_total_storage = 100
	atom_storage.set_holdable(/obj/item/ammo_casing/harpoon)

/obj/item/storage/bag/harpoon_quiver/PopulateContents()
	for(var/i in 1 to 40)
		new /obj/item/ammo_casing/harpoon(src)

/obj/item/storage/bag/rebar_quiver
	name = "钢筋弩箭袋"
	icon = 'icons/obj/weapons/bows/quivers.dmi'
	icon_state = "rebar_quiver"
	worn_icon_state = "rebar_quiver"
	inhand_icon_state = "rebar_quiver"
	desc = "通过将氧气罐破开，制成容纳钢筋弩箭的箭袋."
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_SUITSTORE
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/rebar_quiver/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_TINY
	atom_storage.max_slots = 10
	atom_storage.max_total_storage = 15
	atom_storage.set_holdable(list(
		/obj/item/ammo_casing/rebar,
		/obj/item/ammo_casing/rebar/syndie,
		/obj/item/ammo_casing/rebar/healium,
		/obj/item/ammo_casing/rebar/hydrogen,
		/obj/item/ammo_casing/rebar/zaukerite,
		/obj/item/ammo_casing/rebar/paperball,
		))

#undef ORE_BAG_BALOON_COOLDOWN
