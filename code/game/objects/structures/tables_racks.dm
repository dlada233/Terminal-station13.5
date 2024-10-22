/* Tables and Racks
 * Contains:
 * Tables
 * Glass Tables
 * Wooden Tables
 * Reinforced Tables
 * Racks
 * Rack Parts
 */

/*
 * Tables
 */

/obj/structure/table
	name = "桌子"
	desc = "四根金属桌腿加上一张大金属板，无法被移动."
	icon = 'icons/obj/smooth_structures/table.dmi'
	icon_state = "table-0"
	base_icon_state = "table"
	density = TRUE
	anchored = TRUE
	pass_flags_self = PASSTABLE | LETPASSTHROW
	layer = TABLE_LAYER
	obj_flags = CAN_BE_HIT | IGNORE_DENSITY
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT)
	max_integrity = 100
	integrity_failure = 0.33
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TABLES
	canSmoothWith = SMOOTH_GROUP_TABLES
	var/frame = /obj/structure/table_frame
	var/framestack = /obj/item/stack/rods
	var/glass_shard_type = /obj/item/shard
	var/buildstack = /obj/item/stack/sheet/iron
	var/busy = FALSE
	var/buildstackamount = 1
	var/framestackamount = 2
	var/deconstruction_ready = TRUE

/obj/structure/table/Initialize(mapload, _buildstack)
	. = ..()
	if(_buildstack)
		buildstack = _buildstack
	AddElement(/datum/element/footstep_override, priority = STEP_SOUND_TABLE_PRIORITY)

	make_climbable()

	var/static/list/loc_connections = list(
		COMSIG_LIVING_DISARM_COLLIDE = PROC_REF(table_living),
	)

	AddElement(/datum/element/connect_loc, loc_connections)
	var/static/list/give_turf_traits = list(TRAIT_TURF_IGNORE_SLOWDOWN, TRAIT_TURF_IGNORE_SLIPPERY, TRAIT_IMMERSE_STOPPED)
	AddElement(/datum/element/give_turf_traits, give_turf_traits)
	register_context()

///Adds the element used to make the object climbable, and also the one that shift the mob buckled to it up.
/obj/structure/table/proc/make_climbable()
	AddElement(/datum/element/climbable)
	AddElement(/datum/element/elevation, pixel_shift = 12)

/obj/structure/table/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if(isnull(held_item))
		return NONE

	if(istype(held_item, /obj/item/toy/cards/deck))
		var/obj/item/toy/cards/deck/dealer_deck = held_item
		if(HAS_TRAIT(dealer_deck, TRAIT_WIELDED))
			context[SCREENTIP_CONTEXT_LMB] = "发卡"
			context[SCREENTIP_CONTEXT_RMB] = "卡面朝上发卡"
			. = CONTEXTUAL_SCREENTIP_SET

	if(deconstruction_ready)
		if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
			context[SCREENTIP_CONTEXT_RMB] = "拆卸"
			. = CONTEXTUAL_SCREENTIP_SET
		if(held_item.tool_behaviour == TOOL_WRENCH)
			context[SCREENTIP_CONTEXT_RMB] = "拆除"
			. = CONTEXTUAL_SCREENTIP_SET

	return . || NONE

/obj/structure/table/examine(mob/user)
	. = ..()
	. += deconstruction_hints(user)

/obj/structure/table/proc/deconstruction_hints(mob/user)
	return span_notice("顶部用<b>螺丝</b>固定, 同时<b>主螺栓</b>也清晰可见.")

/obj/structure/table/update_icon(updates=ALL)
	. = ..()
	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)))
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

/obj/structure/table/narsie_act()
	var/atom/A = loc
	qdel(src)
	new /obj/structure/table/wood(A)

/obj/structure/table/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/table/attack_hand(mob/living/user, list/modifiers)
	if(Adjacent(user) && user.pulling)
		if(isliving(user.pulling))
			var/mob/living/pushed_mob = user.pulling
			if(pushed_mob.buckled)
				if(pushed_mob.buckled == src)
					//Already buckled to the table, you probably meant to unbuckle them
					return ..()
				to_chat(user, span_warning("[pushed_mob]被压到[pushed_mob.buckled]上!"))
				return
			if(user.combat_mode)
				switch(user.grab_state)
					if(GRAB_PASSIVE)
						to_chat(user, span_warning("你需要更紧地抓握才能做到!"))
						return
					if(GRAB_AGGRESSIVE)
						tablepush(user, pushed_mob)
					if(GRAB_NECK to GRAB_KILL)
						tablelimbsmash(user, pushed_mob)
			else
				pushed_mob.visible_message(span_notice("[user]开始放置[pushed_mob]到[src]上..."), \
									span_userdanger("[user]开始放置[pushed_mob]到[src]上..."))
				if(do_after(user, 3.5 SECONDS, target = pushed_mob))
					tableplace(user, pushed_mob)
				else
					return
			user.stop_pulling()
		else if(user.pulling.pass_flags & PASSTABLE)
			user.Move_Pulled(src)
			if (user.pulling.loc == loc)
				user.visible_message(span_notice("[user]放置[user.pulling]到[src]上."),
					span_notice("你放置[user.pulling]到[src]上."))
				user.stop_pulling()
	return ..()

/obj/structure/table/attack_tk(mob/user)
	return

/obj/structure/table/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return
	if(mover.throwing)
		return TRUE
	if(locate(/obj/structure/table) in get_turf(mover))
		return TRUE

/obj/structure/table/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(!density)
		return TRUE
	if(pass_info.pass_flags & PASSTABLE)
		return TRUE
	return FALSE

/obj/structure/table/proc/tableplace(mob/living/user, mob/living/pushed_mob)
	pushed_mob.forceMove(loc)
	pushed_mob.set_resting(TRUE, TRUE)
	pushed_mob.visible_message(span_notice("[user]放置[pushed_mob]到[src]上."), \
								span_notice("[user]放置[pushed_mob]到[src]上."))
	log_combat(user, pushed_mob, "places", null, "onto [src]")

/obj/structure/table/proc/tablepush(mob/living/user, mob/living/pushed_mob)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_danger("将[pushed_mob]扔到桌子上可能会造成伤害!"))
		return
	var/passtable_key = REF(user)
	passtable_on(pushed_mob, passtable_key)
	for (var/obj/obj in user.loc.contents)
		if(!obj.CanAllowThrough(pushed_mob))
			return
	pushed_mob.Move(src.loc)
	passtable_off(pushed_mob, passtable_key)
	if(pushed_mob.loc != loc) //Something prevented the tabling
		return
	pushed_mob.Knockdown(30)
	pushed_mob.apply_damage(10, BRUTE)
	pushed_mob.apply_damage(40, STAMINA)
	if(user.mind?.martial_art?.smashes_tables && user.mind?.martial_art.can_use(user))
		deconstruct(FALSE)
	playsound(pushed_mob, 'sound/effects/tableslam.ogg', 90, TRUE)
	pushed_mob.visible_message(span_danger("[user]把[pushed_mob]摔倒[src]上!"), \
								span_userdanger("[user]把你摔倒[src]上!"))
	log_combat(user, pushed_mob, "tabled", null, "onto [src]")
	pushed_mob.add_mood_event("table", /datum/mood_event/table)

/obj/structure/table/proc/tablelimbsmash(mob/living/user, mob/living/pushed_mob)
	pushed_mob.Knockdown(30)
	var/obj/item/bodypart/banged_limb = pushed_mob.get_bodypart(user.zone_selected) || pushed_mob.get_bodypart(BODY_ZONE_HEAD)
	var/extra_wound = 0
	if(HAS_TRAIT(user, TRAIT_HULK))
		extra_wound = 20
	banged_limb?.receive_damage(30, wound_bonus = extra_wound)
	pushed_mob.apply_damage(60, STAMINA)
	take_damage(50)
	if(user.mind?.martial_art?.smashes_tables && user.mind?.martial_art.can_use(user))
		deconstruct(FALSE)
	playsound(pushed_mob, 'sound/effects/bang.ogg', 90, TRUE)
	pushed_mob.visible_message(span_danger("[user]将[pushed_mob]的[banged_limb.plaintext_zone]砸在桌子上[src]!"),
								span_userdanger("[user]将你的[banged_limb.plaintext_zone]砸在桌子上[src]"))
	log_combat(user, pushed_mob, "head slammed", null, "against [src]")
	pushed_mob.add_mood_event("table", /datum/mood_event/table_limbsmash, banged_limb)

/obj/structure/table/screwdriver_act_secondary(mob/living/user, obj/item/tool)
	if(!deconstruction_ready)
		return NONE
	to_chat(user, span_notice("你开始拆卸[src]..."))
	if(tool.use_tool(src, user, 2 SECONDS, volume=50))
		deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/table/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(!deconstruction_ready)
		return NONE
	to_chat(user, span_notice("你开始拆除[src]..."))
	if(tool.use_tool(src, user, 4 SECONDS, volume=50))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		frame = null
		deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/table/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.tool_behaviour == TOOL_SCREWDRIVER || tool.tool_behaviour == TOOL_WRENCH)
		// continue to tool act
		// ...we need a better way to do this natively.
		// maybe flag to call tool acts before item interaction specifically?
		return NONE
	if(istype(tool, /obj/item/construction/rcd))
		return NONE

	if(istype(tool, /obj/item/toy/cards/deck))
		var/obj/item/toy/cards/deck/dealer_deck = tool
		if(HAS_TRAIT(dealer_deck, TRAIT_WIELDED)) // deal a card faceup on the table
			var/obj/item/toy/singlecard/card = dealer_deck.draw(user)
			if(card)
				card.Flip()
				attackby(card, user, list2params(modifiers))
			return ITEM_INTERACT_SUCCESS

	return item_interaction(user, tool, modifiers)

/obj/structure/table/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/storage/bag/tray))
		var/obj/item/storage/bag/tray/tray = tool
		if(tray.contents.len > 0) // If the tray isn't empty
			for(var/obj/item/thing in tray.contents)
				AfterPutItemOnTable(thing, user)
			tool.atom_storage.remove_all(drop_location())
			user.visible_message(span_notice("[user]清空[tool]在[src]上."))
			return ITEM_INTERACT_SUCCESS
		// If the tray IS empty, continue on (tray will be placed on the table like other items)

	if(istype(tool, /obj/item/toy/cards/deck))
		var/obj/item/toy/cards/deck/dealer_deck = tool
		if(HAS_TRAIT(dealer_deck, TRAIT_WIELDED)) // deal a card facedown on the table
			var/obj/item/toy/singlecard/card = dealer_deck.draw(user)
			if(card)
				attackby(card, user, list2params(modifiers))
			return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/riding_offhand))
		var/obj/item/riding_offhand/riding_item = tool
		var/mob/living/carried_mob = riding_item.rider
		if(carried_mob == user) //Piggyback user.
			return NONE
		if(user.combat_mode)
			user.unbuckle_mob(carried_mob)
			tablelimbsmash(user, carried_mob)
		else
			var/tableplace_delay = 3.5 SECONDS
			var/skills_space = ""
			if(HAS_TRAIT(user, TRAIT_QUICKER_CARRY))
				tableplace_delay = 2 SECONDS
				skills_space = "熟练地"
			else if(HAS_TRAIT(user, TRAIT_QUICK_CARRY))
				tableplace_delay = 2.75 SECONDS
				skills_space = "快速地"
			carried_mob.visible_message(span_notice("[user]开始[skills_space]放置[carried_mob]到[src]上..."),
				span_userdanger("[user]开始[skills_space]放置[carried_mob]到[src]上..."))
			if(do_after(user, tableplace_delay, target = carried_mob))
				user.unbuckle_mob(carried_mob)
				tableplace(user, carried_mob)
		return ITEM_INTERACT_SUCCESS

	// Where putting things on tables is handled.
	if(!user.combat_mode && !(tool.item_flags & ABSTRACT) && user.transferItemToLoc(tool, drop_location(), silent = FALSE))
		//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
		tool.pixel_x = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(world.icon_size/2), world.icon_size/2)
		tool.pixel_y = clamp(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(world.icon_size/2), world.icon_size/2)
		AfterPutItemOnTable(tool, user)
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/structure/table/proc/AfterPutItemOnTable(obj/item/thing, mob/living/user)
	return

/obj/structure/table/atom_deconstruct(disassembled = TRUE)
	var/turf/target_turf = get_turf(src)
	if(buildstack)
		new buildstack(target_turf, buildstackamount)
	else
		for(var/datum/material/mat in custom_materials)
			new mat.sheet_type(target_turf, FLOOR(custom_materials[mat] / SHEET_MATERIAL_AMOUNT, 1))

	if(frame)
		new frame(target_turf)
	else
		new framestack(get_turf(src), framestackamount)

/obj/structure/table/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_DECONSTRUCT)
		return list("delay" = 2.4 SECONDS, "cost" = 16)
	return FALSE

/obj/structure/table/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	if(rcd_data["[RCD_DESIGN_MODE]"] == RCD_DECONSTRUCT)
		qdel(src)
		return TRUE
	return FALSE

/obj/structure/table/proc/table_living(datum/source, mob/living/shover, mob/living/target, shove_flags, obj/item/weapon)
	SIGNAL_HANDLER
	if((shove_flags & SHOVE_KNOCKDOWN_BLOCKED) || !(shove_flags & SHOVE_BLOCKED))
		return
	target.Knockdown(SHOVE_KNOCKDOWN_TABLE)
	target.visible_message(span_danger("[shover.name]把[target.name]推到[src]上!"),
		span_userdanger("你被[shover.name]推到[src]上!"), span_hear("你听到冲动的推搡声，然后是砰的一声!"), COMBAT_MESSAGE_RANGE, shover)
	to_chat(shover, span_danger("你把[target.name]推到[src]上!"))
	target.throw_at(src, 1, 1, null, FALSE) //1 speed throws with no spin are basically just forcemoves with a hard collision check
	log_combat(shover, target, "shoved", "onto [src] (table)[weapon ? " with [weapon]" : ""]")
	return COMSIG_LIVING_SHOVE_HANDLED

/obj/structure/table/greyscale
	icon = 'icons/obj/smooth_structures/table_greyscale.dmi'
	icon_state = "table_greyscale-0"
	base_icon_state = "table_greyscale"
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	buildstack = null //No buildstack, so generate from mat datums

/obj/structure/table/greyscale/set_custom_materials(list/materials, multiplier)
	. = ..()
	var/list/materials_list = list()
	for(var/custom_material in custom_materials)
		var/datum/material/current_material = GET_MATERIAL_REF(custom_material)
		materials_list += "[current_material.name]"
	desc = "一块由[english_list(materials_list)]制成的[(materials_list.len > 1) ? "合成板材" : "板材"]加上四条桌腿. 无法被移动."

///Table on wheels
/obj/structure/table/rolling
	name = "滚轮桌"
	desc = "一张NT牌\"Rolly poly\"滚轮桌. 可以移动."
	anchored = FALSE
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null
	icon = 'icons/obj/smooth_structures/rollingtable.dmi'
	icon_state = "rollingtable"
	/// Lazylist of the items that we have on our surface.
	var/list/attached_items = null

/obj/structure/table/rolling/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noisy_movement)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_our_moved))

/obj/structure/table/rolling/Destroy()
	for(var/item in attached_items)
		clear_item_reference(item)
	LAZYNULL(attached_items) // safety
	return ..()

/obj/structure/table/rolling/AfterPutItemOnTable(obj/item/thing, mob/living/user)
	. = ..()
	LAZYADD(attached_items, thing)
	RegisterSignal(thing, COMSIG_MOVABLE_MOVED, PROC_REF(on_item_moved))

/// Handles cases where any attached item moves, with or without the table. If we get picked up or anything, unregister the signal so we don't move with the table after removal from the surface.
/obj/structure/table/rolling/proc/on_item_moved(datum/source, atom/old_loc, dir, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER

	var/atom/thing = source // let it runtime if it doesn't work because that is mad wack
	if(thing.loc == loc) // if we move with the table, move on
		return

	clear_item_reference(thing)

/// Handles movement of the table itself, as well as moving along any atoms we have on our surface.
/obj/structure/table/rolling/proc/on_our_moved(datum/source, atom/old_loc, dir, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER
	if(isnull(loc)) // aw hell naw
		return

	for(var/mob/living/living_mob in old_loc.contents)//Kidnap everyone on top
		living_mob.forceMove(loc)

	for(var/atom/movable/attached_movable as anything in attached_items)
		if(!attached_movable.Move(loc)) // weird
			clear_item_reference(attached_movable) // we check again in on_item_moved() just in case something's wacky tobaccy

/// Removes the signal and the entrance from the list.
/obj/structure/table/rolling/proc/clear_item_reference(obj/item/thing)
	UnregisterSignal(thing, COMSIG_MOVABLE_MOVED)
	LAZYREMOVE(attached_items, thing)

/*
 * Glass tables
 */
/obj/structure/table/glass
	name = "玻璃桌"
	desc = "我不是说了不要站在玻璃桌子上了吗，现在你得做手术了."
	icon = 'icons/obj/smooth_structures/glass_table.dmi'
	icon_state = "glass_table-0"
	base_icon_state = "glass_table"
	custom_materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT)
	buildstack = /obj/item/stack/sheet/glass
	smoothing_groups = SMOOTH_GROUP_GLASS_TABLES
	canSmoothWith = SMOOTH_GROUP_GLASS_TABLES
	max_integrity = 70
	resistance_flags = ACID_PROOF
	armor_type = /datum/armor/table_glass

/datum/armor/table_glass
	fire = 80
	acid = 100

/obj/structure/table/glass/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/table/glass/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	if(!isliving(AM))
		return
	// Don't break if they're just flying past
	if(AM.throwing)
		addtimer(CALLBACK(src, PROC_REF(throw_check), AM), 0.5 SECONDS)
	else
		check_break(AM)

/obj/structure/table/glass/proc/throw_check(mob/living/M)
	if(M.loc == get_turf(src))
		check_break(M)

/obj/structure/table/glass/proc/check_break(mob/living/M)
	if(M.has_gravity() && M.mob_size > MOB_SIZE_SMALL && !(M.movement_type & MOVETYPES_NOT_TOUCHING_GROUND) && (!isteshari(M))) //SKYRAT EDIT ADDITION - Allows Teshari to climb on glassies safely.
		table_shatter(M)

/obj/structure/table/glass/proc/table_shatter(mob/living/victim)
	visible_message(span_warning("[src]碎了!"),
		span_danger("你听到玻璃碎裂声."))

	playsound(loc, SFX_SHATTER, 50, TRUE)

	new frame(loc)

	var/obj/item/shard/shard = new glass_shard_type(loc)
	shard.throw_impact(victim)

	victim.Paralyze(100)
	qdel(src)

/obj/structure/table/glass/atom_deconstruct(disassembled = TRUE)
	if(disassembled)
		..()
		return
	else
		var/turf/T = get_turf(src)
		playsound(T, SFX_SHATTER, 50, TRUE)

		new frame(loc)
		new glass_shard_type(loc)

/obj/structure/table/glass/narsie_act()
	color = NARSIE_WINDOW_COLOUR

/obj/structure/table/glass/plasmaglass
	name = "等离子玻璃桌"
	desc = "有人认为这是一个好注意."
	icon = 'icons/obj/smooth_structures/plasmaglass_table.dmi'
	icon_state = "plasmaglass_table-0"
	base_icon_state = "plasmaglass_table"
	custom_materials = list(/datum/material/alloy/plasmaglass =SHEET_MATERIAL_AMOUNT)
	buildstack = /obj/item/stack/sheet/plasmaglass
	glass_shard_type = /obj/item/shard/plasma
	max_integrity = 100

/*
 * Wooden tables
 */

/obj/structure/table/wood
	name = "木桌"
	desc = "不要在上面用火，有说它很易燃."
	icon = 'icons/obj/smooth_structures/wood_table.dmi'
	icon_state = "wood_table-0"
	base_icon_state = "wood_table"
	frame = /obj/structure/table_frame/wood
	framestack = /obj/item/stack/sheet/mineral/wood
	buildstack = /obj/item/stack/sheet/mineral/wood
	resistance_flags = FLAMMABLE
	max_integrity = 70
	smoothing_groups = SMOOTH_GROUP_WOOD_TABLES //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = SMOOTH_GROUP_WOOD_TABLES

/obj/structure/table/wood/narsie_act(total_override = TRUE)
	if(!total_override)
		..()

/obj/structure/table/wood/poker //No specialties, Just a mapping object.
	name = "赌桌"
	desc = "肮脏地方进行肮脏交易的肮脏桌子."
	icon = 'icons/obj/smooth_structures/poker_table.dmi'
	icon_state = "poker_table-0"
	base_icon_state = "poker_table"
	buildstack = /obj/item/stack/tile/carpet

/obj/structure/table/wood/poker/narsie_act()
	..(FALSE)

/obj/structure/table/wood/fancy
	name = "华丽桌子"
	desc = "标准的金属桌架，但是覆盖了华丽的花纹布."
	icon = 'icons/obj/structures.dmi'
	icon_state = "fancy_table"
	base_icon_state = "fancy_table"
	frame = /obj/structure/table_frame
	framestack = /obj/item/stack/rods
	buildstack = /obj/item/stack/tile/carpet
	smoothing_groups = SMOOTH_GROUP_FANCY_WOOD_TABLES //Don't smooth with SMOOTH_GROUP_TABLES or SMOOTH_GROUP_WOOD_TABLES
	canSmoothWith = SMOOTH_GROUP_FANCY_WOOD_TABLES
	var/smooth_icon = 'icons/obj/smooth_structures/fancy_table.dmi' // see Initialize()

/obj/structure/table/wood/fancy/Initialize(mapload)
	. = ..()
	// Needs to be set dynamically because table smooth sprites are 32x34,
	// which the editor treats as a two-tile-tall object. The sprites are that
	// size so that the north/south corners look nice - examine the detail on
	// the sprites in the editor to see why.
	icon = smooth_icon

/obj/structure/table/wood/fancy/black
	icon_state = "fancy_table_black"
	base_icon_state = "fancy_table_black"
	buildstack = /obj/item/stack/tile/carpet/black
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_black.dmi'

/obj/structure/table/wood/fancy/blue
	icon_state = "fancy_table_blue"
	base_icon_state = "fancy_table_blue"
	buildstack = /obj/item/stack/tile/carpet/blue
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_blue.dmi'

/obj/structure/table/wood/fancy/cyan
	icon_state = "fancy_table_cyan"
	base_icon_state = "fancy_table_cyan"
	buildstack = /obj/item/stack/tile/carpet/cyan
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_cyan.dmi'

/obj/structure/table/wood/fancy/green
	icon_state = "fancy_table_green"
	base_icon_state = "fancy_table_green"
	buildstack = /obj/item/stack/tile/carpet/green
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_green.dmi'

/obj/structure/table/wood/fancy/orange
	icon_state = "fancy_table_orange"
	base_icon_state = "fancy_table_orange"
	buildstack = /obj/item/stack/tile/carpet/orange
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_orange.dmi'

/obj/structure/table/wood/fancy/purple
	icon_state = "fancy_table_purple"
	base_icon_state = "fancy_table_purple"
	buildstack = /obj/item/stack/tile/carpet/purple
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_purple.dmi'

/obj/structure/table/wood/fancy/red
	icon_state = "fancy_table_red"
	base_icon_state = "fancy_table_red"
	buildstack = /obj/item/stack/tile/carpet/red
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_red.dmi'

/obj/structure/table/wood/fancy/royalblack
	icon_state = "fancy_table_royalblack"
	base_icon_state = "fancy_table_royalblack"
	buildstack = /obj/item/stack/tile/carpet/royalblack
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_royalblack.dmi'

/obj/structure/table/wood/fancy/royalblue
	icon_state = "fancy_table_royalblue"
	base_icon_state = "fancy_table_royalblue"
	buildstack = /obj/item/stack/tile/carpet/royalblue
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_royalblue.dmi'

/*
 * Reinforced tables
 */
/obj/structure/table/reinforced
	name = "加固桌"
	desc = "四条腿的桌子的加固版."
	icon = 'icons/obj/smooth_structures/reinforced_table.dmi'
	icon_state = "reinforced_table-0"
	base_icon_state = "reinforced_table"
	deconstruction_ready = FALSE
	buildstack = /obj/item/stack/sheet/plasteel
	max_integrity = 200
	integrity_failure = 0.25
	armor_type = /datum/armor/table_reinforced

/datum/armor/table_reinforced
	melee = 10
	bullet = 30
	laser = 30
	energy = 100
	bomb = 20
	fire = 80
	acid = 70

/obj/structure/table/reinforced/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if(isnull(held_item))
		return NONE

	if(held_item.tool_behaviour == TOOL_WELDER)
		context[SCREENTIP_CONTEXT_RMB] = deconstruction_ready ? "加固" : "削弱"
		. = CONTEXTUAL_SCREENTIP_SET

	return . || NONE

/obj/structure/table/reinforced/deconstruction_hints(mob/user)
	if(deconstruction_ready)
		return span_notice("桌板已经被<i>焊开</i>，主框架的<b>螺栓</b>暴露在外.")
	else
		return span_notice("桌板被牢固地<b>焊接</b>了.")

/obj/structure/table/reinforced/welder_act_secondary(mob/living/user, obj/item/tool)
	if(tool.tool_start_check(user, amount = 0))
		if(deconstruction_ready)
			to_chat(user, span_notice("你开始加固桌子..."))
			if (tool.use_tool(src, user, 50, volume = 50))
				to_chat(user, span_notice("你加固了桌子."))
				deconstruction_ready = FALSE
				return ITEM_INTERACT_SUCCESS
		else
			to_chat(user, span_notice("你开始削弱桌子..."))
			if (tool.use_tool(src, user, 50, volume = 50))
				to_chat(user, span_notice("你削弱了桌子."))
				deconstruction_ready = TRUE
				return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/structure/table/reinforced/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.tool_behaviour == TOOL_WELDER)
		return NONE

	return ..()

/obj/structure/table/bronze
	name = "青铜桌"
	desc = "青铜制成的实心桌子."
	icon = 'icons/obj/smooth_structures/brass_table.dmi'
	icon_state = "brass_table-0"
	base_icon_state = "brass_table"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	buildstack = /obj/item/stack/sheet/bronze
	smoothing_groups = SMOOTH_GROUP_BRONZE_TABLES //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = SMOOTH_GROUP_BRONZE_TABLES

/obj/structure/table/bronze/tablepush(mob/living/user, mob/living/pushed_mob)
	..()
	playsound(src, 'sound/magic/clockwork/fellowship_armory.ogg', 50, TRUE)

/obj/structure/table/reinforced/rglass
	name = "强化玻璃桌"
	desc = "强化过的玻璃桌."
	icon = 'icons/obj/smooth_structures/rglass_table.dmi'
	icon_state = "rglass_table-0"
	base_icon_state = "rglass_table"
	custom_materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/iron =SHEET_MATERIAL_AMOUNT)
	buildstack = /obj/item/stack/sheet/rglass
	max_integrity = 150

/obj/structure/table/reinforced/plasmarglass
	name = "强化等离子玻璃桌"
	desc = "强化过的等离子玻璃桌."
	icon = 'icons/obj/smooth_structures/rplasmaglass_table.dmi'
	icon_state = "rplasmaglass_table-0"
	base_icon_state = "rplasmaglass_table"
	custom_materials = list(/datum/material/alloy/plasmaglass =SHEET_MATERIAL_AMOUNT, /datum/material/iron =SHEET_MATERIAL_AMOUNT)
	buildstack = /obj/item/stack/sheet/plasmarglass

/obj/structure/table/reinforced/titaniumglass
	name = "钛钢玻璃桌"
	desc = "用钛合金强化的玻璃桌，涂上了一层NT白色漆."
	icon = 'icons/obj/smooth_structures/titaniumglass_table.dmi'
	icon_state = "titaniumglass_table-0"
	base_icon_state = "titaniumglass_table"
	custom_materials = list(/datum/material/alloy/titaniumglass =SHEET_MATERIAL_AMOUNT)
	buildstack = /obj/item/stack/sheet/titaniumglass
	max_integrity = 250

/obj/structure/table/reinforced/plastitaniumglass
	name = "塑钢玻璃桌"
	desc = "用塑钢强化的玻璃桌，看起来很耐用."
	icon = 'icons/obj/smooth_structures/plastitaniumglass_table.dmi'
	icon_state = "plastitaniumglass_table-0"
	base_icon_state = "plastitaniumglass_table"
	custom_materials = list(/datum/material/alloy/plastitaniumglass =SHEET_MATERIAL_AMOUNT)
	buildstack = /obj/item/stack/sheet/plastitaniumglass
	max_integrity = 300

/*
 * Surgery Tables
 */

/obj/structure/table/optable//SKYRAT EDIT - ICON OVERRIDEN BY AESTHETICS - SEE MODULE
	name = "手术台"
	desc = "用于进行精密手术."
	icon = 'icons/obj/medical/surgery_table.dmi'
	icon_state = "surgery_table"
	buildstack = /obj/item/stack/sheet/mineral/silver
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null
	can_buckle = TRUE
	buckle_lying = 90
	custom_materials = list(/datum/material/silver =SHEET_MATERIAL_AMOUNT)
	var/mob/living/carbon/patient = null
	var/obj/machinery/computer/operating/computer = null

/obj/structure/table/optable/Initialize(mapload)
	. = ..()
	for(var/direction in GLOB.alldirs)
		computer = locate(/obj/machinery/computer/operating) in get_step(src, direction)
		if(computer)
			computer.table = src
			break

	RegisterSignal(loc, COMSIG_ATOM_ENTERED, PROC_REF(mark_patient))
	RegisterSignal(loc, COMSIG_ATOM_EXITED, PROC_REF(unmark_patient))

/obj/structure/table/optable/Destroy()
	if(computer && computer.table == src)
		computer.table = null
	patient = null
	UnregisterSignal(loc, COMSIG_ATOM_ENTERED)
	UnregisterSignal(loc, COMSIG_ATOM_EXITED)
	return ..()

/obj/structure/table/optable/make_climbable()
	AddElement(/datum/element/elevation, pixel_shift = 12)

/obj/structure/table/optable/tablepush(mob/living/user, mob/living/pushed_mob)
	pushed_mob.forceMove(loc)
	pushed_mob.set_resting(TRUE, TRUE)
	visible_message(span_notice("[user]把[pushed_mob]放到[src]上."))

///Align the mob with the table when buckled.
/obj/structure/table/optable/post_buckle_mob(mob/living/buckled)
	. = ..()
	buckled.pixel_y += 6

///Disalign the mob with the table when unbuckled.
/obj/structure/table/optable/post_unbuckle_mob(mob/living/buckled)
	. = ..()
	buckled.pixel_y -= 6

/// Any mob that enters our tile will be marked as a potential patient. They will be turned into a patient if they lie down.
/obj/structure/table/optable/proc/mark_patient(datum/source, mob/living/carbon/potential_patient)
	SIGNAL_HANDLER
	if(!istype(potential_patient))
		return
	RegisterSignal(potential_patient, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(recheck_patient))
	recheck_patient(potential_patient) // In case the mob is already lying down before they entered.

/// Unmark the potential patient.
/obj/structure/table/optable/proc/unmark_patient(datum/source, mob/living/carbon/potential_patient)
	SIGNAL_HANDLER
	if(!istype(potential_patient))
		return
	if(potential_patient == patient)
		recheck_patient(patient) // Can just set patient to null, but doing the recheck lets us find a replacement patient.
	UnregisterSignal(potential_patient, COMSIG_LIVING_SET_BODY_POSITION)

/// Someone on our tile just lied down, got up, moved in, or moved out.
/// potential_patient is the mob that had one of those four things change.
/// The check is a bit broad so we can find a replacement patient.
/obj/structure/table/optable/proc/recheck_patient(mob/living/carbon/potential_patient)
	SIGNAL_HANDLER
	if(patient && patient != potential_patient)
		return

	if(potential_patient.body_position == LYING_DOWN && potential_patient.loc == loc)
		patient = potential_patient
		chill_out(patient) // SKYRAT EDIT - Operation Table Numbing
		return

	if(!isnull(patient)) // SKYRAT EDIT - Operation Table Numbing
		thaw_them(patient) // SKYRAT EDIT - Operation Table Numbing

	// Find another lying mob as a replacement.
	for (var/mob/living/carbon/replacement_patient in loc.contents)
		if(replacement_patient.body_position == LYING_DOWN)
			patient = replacement_patient
			return
	patient = null

/*
 * Racks
 */
/obj/structure/rack
	name = "物品架"
	desc = "与中世纪版本的不同."
	icon = 'icons/obj/structures.dmi'
	icon_state = "rack"
	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	pass_flags_self = LETPASSTHROW //You can throw objects over this, despite it's density.
	max_integrity = 20

/obj/structure/rack/skeletal
	name = "骷髅迷你吧台"
	desc = "你就是酒篓子."
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "minibar"

/obj/structure/rack/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)
	AddElement(/datum/element/elevation, pixel_shift = 12)
	register_context()

/obj/structure/rack/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item))
		return NONE

	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_RMB] = "拆除"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/structure/rack/examine(mob/user)
	. = ..()
	. += span_notice("它是由几对<b>螺栓</b>固定在一起的.")

/obj/structure/rack/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return
	if(istype(mover) && (mover.pass_flags & PASSTABLE))
		return TRUE

/obj/structure/rack/wrench_act_secondary(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/rack/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.tool_behaviour == TOOL_WRENCH)
		return NONE

	return item_interaction(user, tool, modifiers)

/obj/structure/rack/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if((tool.item_flags & ABSTRACT) || user.combat_mode)
		return NONE
	if(user.transferItemToLoc(tool, drop_location(), silent = FALSE))
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/structure/rack/attack_paw(mob/living/user, list/modifiers)
	attack_hand(user, modifiers)

/obj/structure/rack/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user.combat_mode || user.body_position == LYING_DOWN || user.usable_legs < 2)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_KICK)
	user.visible_message(span_danger("[user]踢了踢[src]."), null, null, COMBAT_MESSAGE_RANGE)
	take_damage(rand(4,8), BRUTE, MELEE, 1)

/obj/structure/rack/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(loc, 'sound/items/dodgeball.ogg', 80, TRUE)
			else
				playsound(loc, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 40, TRUE)

/*
 * Rack destruction
 */

/obj/structure/rack/atom_deconstruct(disassembled = TRUE)
	set_density(FALSE)
	var/obj/item/rack_parts/newparts = new(loc)
	transfer_fingerprints_to(newparts)


/*
 * Rack Parts
 */

/obj/item/rack_parts
	name = "物品架部件"
	desc = "物品架的一部分."
	icon = 'icons/obj/structures.dmi'
	icon_state = "rack_parts"
	inhand_icon_state = "rack_parts"
	obj_flags = CONDUCTS_ELECTRICITY
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)
	var/building = FALSE

/obj/item/rack_parts/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/rack_parts/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item))
		return NONE

	if(held_item == src)
		context[SCREENTIP_CONTEXT_LMB] = "搭建物品架"
		return CONTEXTUAL_SCREENTIP_SET

	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = "拆除"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/rack_parts/wrench_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/item/rack_parts/atom_deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/iron(drop_location())

/obj/item/rack_parts/attack_self(mob/user)
	if(building)
		return
	building = TRUE
	to_chat(user, span_notice("你开始搭建物品架..."))
	if(do_after(user, 5 SECONDS, target = user, progress=TRUE))
		if(!user.temporarilyRemoveItemFromInventory(src))
			return
		var/obj/structure/rack/R = new /obj/structure/rack(get_turf(src))
		user.visible_message("<span class='notice'>[user]组装了一个[R].\
			</span>", span_notice("你组装了一个[R]."))
		R.add_fingerprint(user)
		qdel(src)
	building = FALSE
