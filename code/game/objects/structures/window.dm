/obj/structure/window
	name = "窗户"
	desc = "一面窗."
	icon_state = "window"
	density = TRUE
	layer = ABOVE_OBJ_LAYER //Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = TRUE //initially is 0 for tile smoothing
	flags_1 = ON_BORDER_1
	obj_flags = CAN_BE_HIT | BLOCKS_CONSTRUCTION_DIR | IGNORE_DENSITY
	max_integrity = 50
	can_be_unanchored = TRUE
	resistance_flags = ACID_PROOF
	armor_type = /datum/armor/structure_window
	can_atmos_pass = ATMOS_PASS_PROC
	rad_insulation = RAD_VERY_LIGHT_INSULATION
	pass_flags_self = PASSGLASS | PASSWINDOW
	set_dir_on_move = FALSE
	flags_ricochet = RICOCHET_HARD
	receive_ricochet_chance_mod = 0.5
	var/state = WINDOW_OUT_OF_FRAME
	var/reinf = FALSE
	var/heat_resistance = 800
	var/decon_speed = 30
	var/wtype = "glass"
	var/fulltile = FALSE
	var/glass_type = /obj/item/stack/sheet/glass
	var/glass_amount = 1
	var/real_explosion_block //ignore this, just use explosion_block
	var/break_sound = SFX_SHATTER
	var/knock_sound = 'sound/effects/glassknock.ogg'
	var/bash_sound = 'sound/effects/glassbash.ogg'
	var/hit_sound = 'sound/effects/glasshit.ogg'
	/// If some inconsiderate jerk has had their blood spilled on this window, thus making it cleanable
	var/bloodied = FALSE
	///Datum that the shard and debris type is pulled from for when the glass is broken.
	var/datum/material/glass_material_datum = /datum/material/glass

/datum/armor/structure_window
	melee = 50
	fire = 80
	acid = 100

/obj/structure/window/Initialize(mapload, direct)
	AddElement(/datum/element/blocks_explosives)
	. = ..()
	if(direct)
		setDir(direct)
	if(reinf && anchored)
		state = RWINDOW_SECURE

	if(!reinf && anchored)
		state = WINDOW_SCREWED_TO_FRAME

	air_update_turf(TRUE, TRUE)

	if(fulltile)
		setDir()
		obj_flags &= ~BLOCKS_CONSTRUCTION_DIR
		obj_flags &= ~IGNORE_DENSITY
		AddElement(/datum/element/can_barricade)

	//windows only block while reinforced and fulltile
	if(!reinf || !fulltile)
		set_explosion_block(0)

	flags_1 |= ALLOW_DARK_PAINTS_1
	RegisterSignal(src, COMSIG_OBJ_PAINTED, PROC_REF(on_painted))
	AddElement(/datum/element/atmos_sensitive, mapload)
	AddComponent(/datum/component/simple_rotation, ROTATION_NEEDS_ROOM, post_rotation = CALLBACK(src, PROC_REF(post_rotation)))

	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit),
	)

	if (flags_1 & ON_BORDER_1)
		AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/window/examine(mob/user)
	. = ..()

	switch(state)
		if(WINDOW_SCREWED_TO_FRAME)
			. += span_notice("窗户被<b>螺丝</b>固定在框架上.")
		if(WINDOW_IN_FRAME)
			. += span_notice("固定窗户的<i>螺丝</i>已经被取下了，窗户现在可以被<b>撬开</b>.")
		if(WINDOW_OUT_OF_FRAME)
			if (anchored)
				. += span_notice("窗户被<b>螺丝</b>固定在地板上.")
			else
				. += span_notice("固定窗户到地板上的<i>螺丝</i>已经被取下了, 窗户现在可以用<b>扳手</b>拆除.")

/obj/structure/window/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_DECONSTRUCT)
		return list("delay" = 2 SECONDS, "cost" = 5)
	return FALSE

/obj/structure/window/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	if(rcd_data["[RCD_DESIGN_MODE]"] == RCD_DECONSTRUCT)
		qdel(src)
		return TRUE
	return FALSE

/obj/structure/window/narsie_act()
	add_atom_colour(NARSIE_WINDOW_COLOUR, FIXED_COLOUR_PRIORITY)

/obj/structure/window/singularity_pull(S, current_size)
	..()
	if(anchored && current_size >= STAGE_FIVE) //SKYRAT EDIT CHANGE
		set_anchored(FALSE)
	if(current_size >= STAGE_FIVE)
		deconstruct(FALSE)

/obj/structure/window/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return

	if(fulltile)
		return FALSE

	if(border_dir == dir)
		return FALSE

	if(istype(mover, /obj/structure/window))
		var/obj/structure/window/moved_window = mover
		return valid_build_direction(loc, moved_window.dir, is_fulltile = moved_window.fulltile)

	if(istype(mover, /obj/structure/windoor_assembly) || istype(mover, /obj/machinery/door/window))
		return valid_build_direction(loc, mover.dir, is_fulltile = FALSE)

	return TRUE

/obj/structure/window/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving.movement_type & PHASING)
		return

	if(leaving == src)
		return // Let's not block ourselves.

	if (leaving.pass_flags & pass_flags_self)
		return

	if (fulltile)
		return

	if(direction == dir && density)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/window/attack_tk(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_notice("什么东西敲了敲[src]."))
	add_fingerprint(user)
	playsound(src, knock_sound, 50, TRUE)
	return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/structure/window/attack_hulk(mob/living/carbon/human/user, does_attack_animation = 0)
	if(!can_be_reached(user))
		return
	. = ..()

/obj/structure/window/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!can_be_reached(user))
		return
	user.changeNext_move(CLICK_CD_MELEE)

	if(!user.combat_mode)
		user.visible_message(span_notice("[user]敲了敲[src]."), \
			span_notice("你敲了敲[src]."))
		playsound(src, knock_sound, 50, TRUE)
	else
		user.visible_message(span_warning("[user]猛击[src]!"), \
			span_warning("你猛击了[src]!"))
		playsound(src, bash_sound, 100, TRUE)

/obj/structure/window/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/window/attack_generic(mob/user, damage_amount = 0, damage_type = BRUTE, damage_flag = 0, sound_effect = 1) //used by attack_alien, attack_animal
	if(!can_be_reached(user))
		return
	return ..()

/obj/structure/window/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!can_be_reached(user))
		return ITEM_INTERACT_SKIP_TO_ATTACK // Guess you get to hit it
	add_fingerprint(user)
	return NONE

/obj/structure/window/welder_act(mob/living/user, obj/item/tool)
	if(atom_integrity >= max_integrity)
		to_chat(user, span_warning("[src]状态良好!"))
		return ITEM_INTERACT_SUCCESS
	if(!tool.tool_start_check(user, amount = 0))
		return FALSE
	to_chat(user, span_notice("你开始修补[src]..."))
	if(tool.use_tool(src, user, 4 SECONDS, volume = 50))
		atom_integrity = max_integrity
		update_nearby_icons()
		to_chat(user, span_notice("你修补好了[src]."))
	return ITEM_INTERACT_SUCCESS

/obj/structure/window/screwdriver_act(mob/living/user, obj/item/tool)

	switch(state)
		if(WINDOW_SCREWED_TO_FRAME)
			to_chat(user, span_notice("你开始拧下窗户的螺丝..."))
			if(tool.use_tool(src, user, decon_speed, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_state_and_anchored), state, anchored)))
				state = WINDOW_IN_FRAME
				to_chat(user, span_notice("你把窗户的固定螺丝拧开了."))
		if(WINDOW_IN_FRAME)
			to_chat(user, span_notice("你开始给窗户上螺丝..."))
			if(tool.use_tool(src, user, decon_speed, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_state_and_anchored), state, anchored)))
				state = WINDOW_SCREWED_TO_FRAME
				to_chat(user, span_notice("你把窗户固定在了窗框上."))
		if(WINDOW_OUT_OF_FRAME)
			if(anchored)
				to_chat(user, span_notice("你开始拧下窗户的地板螺丝..."))
				if(tool.use_tool(src, user, decon_speed, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_state_and_anchored), state, anchored)))
					set_anchored(FALSE)
					to_chat(user, span_notice("你把窗户的地板螺丝拧开了."))
			else
				to_chat(user, span_notice("你开始给窗户上地板螺丝..."))
				if(tool.use_tool(src, user, decon_speed, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_state_and_anchored), state, anchored)))
					set_anchored(TRUE)
					to_chat(user, span_notice("你把窗户固定在地板上."))
	return ITEM_INTERACT_SUCCESS

/obj/structure/window/wrench_act(mob/living/user, obj/item/tool)
	if(anchored)
		return FALSE
	if(reinf && state >= RWINDOW_FRAME_BOLTED)
		return FALSE

	to_chat(user, span_notice("你开始拆解[src]..."))
	if(!tool.use_tool(src, user, decon_speed, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_state_and_anchored), state, anchored)))
		return ITEM_INTERACT_SUCCESS
	var/obj/item/stack/sheet/G = new glass_type(user.loc, glass_amount)
	if (!QDELETED(G))
		G.add_fingerprint(user)
	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	to_chat(user, span_notice("你成功拆解了[src]."))
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/structure/window/crowbar_act(mob/living/user, obj/item/tool)
	if(!anchored)
		return FALSE

	switch(state)
		if(WINDOW_IN_FRAME)
			to_chat(user, span_notice("你开始将窗户从窗框里撬出来..."))
			if(tool.use_tool(src, user, 10 SECONDS, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_state_and_anchored), state, anchored)))
				state = WINDOW_OUT_OF_FRAME
				to_chat(user, span_notice("你将窗户从窗框里撬了出来."))
		if(WINDOW_OUT_OF_FRAME)
			to_chat(user, span_notice("你开始将窗户塞进窗框里..."))
			if(tool.use_tool(src, user, 5 SECONDS, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_state_and_anchored), state, anchored)))
				state = WINDOW_SCREWED_TO_FRAME
				to_chat(user, span_notice("你开始将窗户塞进窗框里."))
		else
			return FALSE

	return ITEM_INTERACT_SUCCESS

/obj/structure/window/attackby(obj/item/I, mob/living/user, params)
	if(!can_be_reached(user))
		return TRUE //skip the afterattack

	add_fingerprint(user)
	return ..()


/obj/structure/window/set_anchored(anchorvalue)
	..()
	air_update_turf(TRUE, anchorvalue)
	update_nearby_icons()

/obj/structure/window/proc/check_state(checked_state)
	if(state == checked_state)
		return TRUE

/obj/structure/window/proc/check_anchored(checked_anchored)
	if(anchored == checked_anchored)
		return TRUE

/obj/structure/window/proc/check_state_and_anchored(checked_state, checked_anchored)
	return check_state(checked_state) && check_anchored(checked_anchored)


/obj/structure/window/proc/can_be_reached(mob/user)
	if(fulltile)
		return TRUE
	var/checking_dir = get_dir(user, src)
	if(!(checking_dir & dir))
		return TRUE // Only windows on the other side may be blocked by other things.
	checking_dir = REVERSE_DIR(checking_dir)
	for(var/obj/blocker in loc)
		if(!blocker.CanPass(user, checking_dir))
			return FALSE
	return TRUE


/obj/structure/window/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armour_penetration = 0)
	. = ..()
	if(.) //received damage
		update_nearby_icons()

/obj/structure/window/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, hit_sound, 75, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 100, TRUE)


/obj/structure/window/atom_deconstruct(disassembled = TRUE)
	if(!disassembled)
		playsound(src, break_sound, 70, TRUE)
		for(var/obj/item/shard/debris in spawn_debris(drop_location()))
			transfer_fingerprints_to(debris) // transfer fingerprints to shards only
	update_nearby_icons()

///Spawns shard and debris decal based on the glass_material_datum, spawns rods if window is reinforned and number of shards/rods is determined by the window being fulltile or not.
/obj/structure/window/proc/spawn_debris(location)
	var/datum/material/glass_material_ref = GET_MATERIAL_REF(glass_material_datum)
	var/obj/item/shard_type = glass_material_ref.shard_type
	var/obj/effect/decal/debris_type = glass_material_ref.debris_type
	var/list/dropped_debris = list()
	if(!isnull(shard_type))
		dropped_debris += new shard_type(location)
		if (fulltile)
			dropped_debris += new shard_type(location)
	if(!isnull(debris_type))
		dropped_debris += new debris_type(location)
	if (reinf)
		dropped_debris += new /obj/item/stack/rods(location, (fulltile ? 2 : 1))
	return dropped_debris

/obj/structure/window/proc/post_rotation(mob/user, degrees)
	air_update_turf(TRUE, FALSE)

/obj/structure/window/proc/on_painted(obj/structure/window/source, mob/user, obj/item/toy/crayon/spraycan/spraycan, is_dark_color)
	SIGNAL_HANDLER
	if(!spraycan.actually_paints)
		return
	if (is_dark_color && fulltile) //Opaque directional windows restrict vision even in directions they are not placed in, please don't do this
		set_opacity(255)
	else
		set_opacity(initial(opacity))

/obj/structure/window/wash(clean_types)
	. = ..()
	if(!(clean_types & CLEAN_SCRUB))
		return
	set_opacity(initial(opacity))
	remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	for(var/atom/movable/cleanables as anything in src)
		if(cleanables == src)
			continue
		if(!cleanables.wash(clean_types))
			continue
		vis_contents -= cleanables
	bloodied = FALSE

/obj/structure/window/Destroy()
	set_density(FALSE)
	air_update_turf(TRUE, FALSE)
	update_nearby_icons()
	return ..()

/obj/structure/window/Move()
	var/turf/T = loc
	. = ..()
	if(anchored)
		move_update_air(T)

/obj/structure/window/can_atmos_pass(turf/T, vertical = FALSE)
	if(!anchored || !density)
		return TRUE
	return !(fulltile || dir == get_dir(loc, T))

//This proc is used to update the icons of nearby windows.
/obj/structure/window/proc/update_nearby_icons()
	update_appearance()
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH_NEIGHBORS(src)

//merges adjacent full-tile windows into one
/obj/structure/window/update_overlays(updates=ALL)
	. = ..()
	if(QDELETED(src) || !fulltile)
		return

	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)))
		QUEUE_SMOOTH(src)

	var/ratio = atom_integrity / max_integrity
	ratio = CEILING(ratio*4, 1) * 25
	if(ratio > 75)
		return
	. += mutable_appearance('icons/obj/structures.dmi', "damage[ratio]", -(layer+0.1))

/obj/structure/window/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > T0C + heat_resistance

/obj/structure/window/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	take_damage(round(air.return_volume() / 100), BURN, 0, 0)

/obj/structure/window/get_dumping_location()
	return null

/obj/structure/window/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(!density)
		return TRUE
	if(fulltile || (dir == to_dir))
		return FALSE

	return TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/window/spawner, 0)

/obj/structure/window/unanchored
	anchored = FALSE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/window/unanchored/spawner, 0)

/obj/structure/window/reinforced
	name = "加固窗"
	desc = "用众多金属杆加固的窗户."
	icon_state = "rwindow"
	reinf = TRUE
	heat_resistance = 1600
	armor_type = /datum/armor/window_reinforced
	max_integrity = 75
	explosion_block = 1
	damage_deflection = 11
	state = RWINDOW_SECURE
	glass_type = /obj/item/stack/sheet/rglass
	rad_insulation = RAD_LIGHT_INSULATION
	receive_ricochet_chance_mod = 1.1

//this is shitcode but all of construction is shitcode and needs a refactor, it works for now
//If you find this like 4 years later and construction still hasn't been refactored, I'm so sorry for this

//Adding a timestamp, I found this in 2020, I hope it's from this year -Lemon
//2021 AND STILLLL GOING STRONG
//2022 BABYYYYY ~lewc
//2023 ONE YEAR TO GO! -LT3
/datum/armor/window_reinforced
	melee = 50
	bomb = 25
	fire = 80
	acid = 100

/obj/structure/window/reinforced/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_DECONSTRUCT)
		return list("delay" = 3 SECONDS, "cost" = 15)
	return FALSE

/obj/structure/window/reinforced/attackby_secondary(obj/item/tool, mob/user, params)
	switch(state)
		if(RWINDOW_SECURE)
			if(tool.tool_behaviour == TOOL_WELDER)
				if(tool.tool_start_check(user))
					user.visible_message(span_notice("[user]将[tool]靠近[src]的安全螺丝..."),
						span_notice("你开始加热[src]的安全螺丝..."))
					if(tool.use_tool(src, user, 15 SECONDS, volume = 100))
						to_chat(user, span_notice("安全螺丝发出白热光，看起来随时可以被拆除."))
						state = RWINDOW_BOLTS_HEATED
						addtimer(CALLBACK(src, PROC_REF(cool_bolts)), 30 SECONDS)
			else if (tool.tool_behaviour)
				to_chat(user, span_warning("需要先加热安全螺丝!"))

		if(RWINDOW_BOLTS_HEATED)
			if(tool.tool_behaviour == TOOL_SCREWDRIVER)
				user.visible_message(span_notice("[user]开始尝试拆卸被加热的安全螺丝..."),
										span_notice("你拧动被加热的安全螺丝..."))
				if(tool.use_tool(src, user, 50, volume = 50))
					state = RWINDOW_BOLTS_OUT
					to_chat(user, span_notice("安全螺丝被拆卸了，窗口边缘多出了一些空隙."))
			else if (tool.tool_behaviour)
				to_chat(user, span_warning("需要先移除安全螺丝!"))

		if(RWINDOW_BOLTS_OUT)
			if(tool.tool_behaviour == TOOL_CROWBAR)
				user.visible_message(span_notice("[user]将[tool]楔入窗口边缘的空隙中，开始了撬动..."),
										span_notice("你将[tool]楔入窗口边缘的空隙中，开始了撬动..."))
				if(tool.use_tool(src, user, 40, volume = 50))
					state = RWINDOW_POPPED
					to_chat(user, span_notice("盖板被撬开，露出了一些可以切割的薄金属封条"))
			else if (tool.tool_behaviour)
				to_chat(user, span_warning("需要先撬开窗口!"))

		if(RWINDOW_POPPED)
			if(tool.tool_behaviour == TOOL_WIRECUTTER)
				user.visible_message(span_notice("[user]开始切割[src]上暴露的金属封条..."),
										span_notice("你开始切割[src]上暴露的金属封条..."))
				if(tool.use_tool(src, user, 20, volume = 50))
					state = RWINDOW_BARS_CUT
					to_chat(user, span_notice("金属封条被切断，露出了螺栓."))
			else if (tool.tool_behaviour)
				to_chat(user, span_warning("需要先切断金属封条!"))

		if(RWINDOW_BARS_CUT)
			if(tool.tool_behaviour == TOOL_WRENCH)
				user.visible_message(span_notice("[user]开始解除[src]的固定螺栓..."),
					span_notice("你开始解除固定螺栓..."))
				if(tool.use_tool(src, user, 40, volume = 50))
					to_chat(user, span_notice("你解除了窗户的固定螺栓."))
					state = WINDOW_OUT_OF_FRAME
					set_anchored(FALSE)
			else if (tool.tool_behaviour)
				to_chat(user, span_warning("需要先解除固定螺栓!"))


	if (tool.tool_behaviour)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	return ..()

/obj/structure/window/reinforced/crowbar_act(mob/living/user, obj/item/tool)
	if(!anchored)
		return FALSE
	if(state != WINDOW_OUT_OF_FRAME)
		return FALSE
	to_chat(user, span_notice("你开始将窗户塞进窗框里..."))
	if(tool.use_tool(src, user, 10 SECONDS, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_state_and_anchored), state, anchored)))
		state = RWINDOW_SECURE
		to_chat(user, span_notice("你将窗户塞进了窗框里."))
	return ITEM_INTERACT_SUCCESS

/obj/structure/window/proc/cool_bolts()
	if(state == RWINDOW_BOLTS_HEATED)
		state = RWINDOW_SECURE
		visible_message(span_notice("[src]的安全螺丝看起来已经冷却下来了..."))

/obj/structure/window/reinforced/examine(mob/user)
	. = ..()

	switch(state)
		if(RWINDOW_SECURE)
			. += span_notice("它被一种单向螺丝固定, 你能通过<b>加热软化</b>才能有机会将其取出.")
		if(RWINDOW_BOLTS_HEATED)
			. += span_notice("螺丝发出白热光，你现在可以用<b>螺丝刀</b>取出.")
		if(RWINDOW_BOLTS_OUT)
			. += span_notice("安全螺丝被拆卸了，窗口边缘多出了一些可以塞入<b>撬棍类工具</b>的空隙.")
		if(RWINDOW_POPPED)
			. += span_notice("窗口盖板被取出，露出了一些可以被<b>剪线钳</b>切断的薄金属封条.")
		if(RWINDOW_BARS_CUT)
			. += span_notice("主窗格可以被轻松地移除，露出了可以被<b>扳手</b>拧开的固定螺栓.")

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/window/reinforced/spawner, 0)

/obj/structure/window/reinforced/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/window/reinforced/unanchored/spawner, 0)

/obj/structure/window/plasma
	name = "等离子窗"
	desc = "由等离子硅酸盐合金制成的窗户，看起来坚固且耐热."
	icon_state = "plasmawindow"
	reinf = FALSE
	heat_resistance = 25000
	armor_type = /datum/armor/window_plasma
	max_integrity = 200
	explosion_block = 1
	glass_type = /obj/item/stack/sheet/plasmaglass
	rad_insulation = RAD_MEDIUM_INSULATION
	glass_material_datum = /datum/material/alloy/plasmaglass

/datum/armor/window_plasma
	melee = 80
	bullet = 5
	bomb = 45
	fire = 99
	acid = 100

/obj/structure/window/plasma/Initialize(mapload, direct)
	. = ..()
	RemoveElement(/datum/element/atmos_sensitive)

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/window/plasma/spawner, 0)

/obj/structure/window/plasma/unanchored
	anchored = FALSE

/obj/structure/window/reinforced/plasma
	name = "等离子加固窗"
	desc = "由等离子硅酸盐合金制成的加固窗户，看起来坚固且极度耐热."
	icon_state = "plasmarwindow"
	reinf = TRUE
	heat_resistance = 50000
	armor_type = /datum/armor/reinforced_plasma
	max_integrity = 500
	damage_deflection = 21
	explosion_block = 2
	glass_type = /obj/item/stack/sheet/plasmarglass
	rad_insulation = RAD_HEAVY_INSULATION
	glass_material_datum = /datum/material/alloy/plasmaglass

/datum/armor/reinforced_plasma
	melee = 80
	bullet = 20
	bomb = 60
	fire = 99
	acid = 100

/obj/structure/window/reinforced/plasma/block_superconductivity()
	return TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/window/reinforced/plasma/spawner, 0)

/obj/structure/window/reinforced/plasma/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

/obj/structure/window/reinforced/tinted
	name = "有色玻璃窗"
	icon_state = "twindow"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/window/reinforced/tinted/spawner, 0)

/obj/structure/window/reinforced/tinted/frosted
	name = "磨砂窗"
	icon_state = "fwindow"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/window/reinforced/tinted/frosted/spawner, 0)

/* Full Tile Windows (more atom_integrity) */

/obj/structure/window/fulltile
	name = "全地块窗"
	desc = "全地块窗."
	icon = 'icons/obj/smooth_structures/window.dmi' //ICON OVERRIDDEN IN SKYRAT AESTHETICS - SEE MODULE
	icon_state = "window-0"
	base_icon_state = "window"
	max_integrity = 100
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	obj_flags = CAN_BE_HIT
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WINDOW_FULLTILE
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE
	glass_amount = 2

/obj/structure/window/fulltile/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_DECONSTRUCT)
		return list("delay" = 2.5 SECONDS, "cost" = 10)
	return FALSE

/obj/structure/window/fulltile/unanchored
	anchored = FALSE

/obj/structure/window/plasma/fulltile
	icon = 'icons/obj/smooth_structures/plasma_window.dmi' //ICON OVERRIDDEN IN SKYRAT AESTHETICS - SEE MODULE
	icon_state = "plasma_window-0"
	base_icon_state = "plasma_window"
	max_integrity = 400
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	obj_flags = CAN_BE_HIT
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WINDOW_FULLTILE
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE
	glass_amount = 2

/obj/structure/window/plasma/fulltile/unanchored
	anchored = FALSE

/obj/structure/window/reinforced/plasma/fulltile
	icon = 'icons/obj/smooth_structures/rplasma_window.dmi' //ICON OVERRIDEN IN SKYRAT AESTHETICS - SEE MODULE
	icon_state = "rplasma_window-0"
	base_icon_state = "rplasma_window"
	state = RWINDOW_SECURE
	max_integrity = 1000
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	obj_flags = CAN_BE_HIT
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WINDOW_FULLTILE
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE
	glass_amount = 2

/obj/structure/window/reinforced/plasma/fulltile/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

/obj/structure/window/reinforced/fulltile
	name = "全地块加固窗"
	desc = "用金属杆加固的全地块窗."
	icon = 'icons/obj/smooth_structures/reinforced_window.dmi' //ICON OVERRIDDEN IN SKYRAT AESTHETICS - SEE MODULE
	icon_state = "reinforced_window-0"
	base_icon_state = "reinforced_window"
	max_integrity = 150
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	obj_flags = CAN_BE_HIT
	state = RWINDOW_SECURE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WINDOW_FULLTILE
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE
	glass_amount = 2

/obj/structure/window/reinforced/fulltile/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_DECONSTRUCT)
		return list("mode" = RCD_DECONSTRUCT, "delay" = 4 SECONDS, "cost" = 20)
	return FALSE

/obj/structure/window/reinforced/fulltile/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

/obj/structure/window/reinforced/tinted/fulltile
	icon = 'icons/obj/smooth_structures/tinted_window.dmi' //ICON OVERRIDEN IN SKYRAT AESTHETICS - SEE MODULE
	icon_state = "tinted_window-0"
	base_icon_state = "tinted_window"
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	obj_flags = CAN_BE_HIT
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WINDOW_FULLTILE
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE
	glass_amount = 2
	// Not on the parent because directional opacity does NOT WORK
	opacity = TRUE

/obj/structure/window/reinforced/fulltile/ice
	icon = 'icons/obj/smooth_structures/rice_window.dmi'
	icon_state = "rice_window-0"
	base_icon_state = "rice_window"
	max_integrity = 150
	glass_amount = 2

//there is a sub shuttle window in survival_pod.dm for mining pods
/obj/structure/window/reinforced/shuttle//this is called reinforced because it is reinforced w/titanium
	name = "飞船窗户"
	desc = "加固的气密窗."
	icon = 'icons/obj/smooth_structures/shuttle_window.dmi'
	icon_state = "shuttle_window-0"
	base_icon_state = "shuttle_window"
	max_integrity = 150
	wtype = "shuttle"
	reinf = TRUE
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	obj_flags = CAN_BE_HIT
	reinf = TRUE
	heat_resistance = 1600
	armor_type = /datum/armor/reinforced_shuttle
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE
	explosion_block = 3
	glass_type = /obj/item/stack/sheet/titaniumglass
	glass_amount = 2
	receive_ricochet_chance_mod = 1.2
	rad_insulation = RAD_MEDIUM_INSULATION
	glass_material_datum = /datum/material/alloy/titaniumglass

/datum/armor/reinforced_shuttle
	melee = 90
	bomb = 50
	fire = 80
	acid = 100

/obj/structure/window/reinforced/shuttle/narsie_act()
	add_atom_colour("#3C3434", FIXED_COLOUR_PRIORITY)

/obj/structure/window/reinforced/shuttle/tinted
	opacity = TRUE

/obj/structure/window/reinforced/shuttle/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

/obj/structure/window/reinforced/shuttle/indestructible
	name = "硬化飞船窗户"
	flags_1 = PREVENT_CLICK_UNDER_1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/window/reinforced/shuttle/indestructible/welder_act(mob/living/user, obj/item/tool)
	return NONE

/obj/structure/window/reinforced/shuttle/indestructible/screwdriver_act(mob/living/user, obj/item/tool)
	return NONE

/obj/structure/window/reinforced/shuttle/indestructible/wrench_act(mob/living/user, obj/item/tool)
	return NONE

/obj/structure/window/reinforced/shuttle/indestructible/crowbar_act(mob/living/user, obj/item/tool)
	return NONE

/obj/structure/window/reinforced/plasma/plastitanium
	name = "塑钢窗"
	desc = "由等离子和钛合金制成的坚固窗户."
	icon = 'icons/obj/smooth_structures/plastitanium_window.dmi'
	icon_state = "plastitanium_window-0"
	base_icon_state = "plastitanium_window"
	max_integrity = 1200
	wtype = "shuttle"
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	obj_flags = CAN_BE_HIT
	heat_resistance = 1600
	armor_type = /datum/armor/plasma_plastitanium
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM
	explosion_block = 3
	damage_deflection = 21 //The same as reinforced plasma windows.3
	glass_type = /obj/item/stack/sheet/plastitaniumglass
	glass_amount = 2
	rad_insulation = RAD_EXTREME_INSULATION
	glass_material_datum = /datum/material/alloy/plastitaniumglass

/datum/armor/plasma_plastitanium
	melee = 95
	bomb = 50
	fire = 80
	acid = 100

/obj/structure/window/reinforced/plasma/plastitanium/unanchored
	anchored = FALSE
	state = WINDOW_OUT_OF_FRAME

/obj/structure/window/paperframe
	name = "纸窗"
	desc = "由硬纸制成的脆弱窗框."
	icon = 'icons/obj/smooth_structures/paperframes.dmi'
	icon_state = "paperframes-0"
	base_icon_state = "paperframes"
	opacity = TRUE
	max_integrity = 15
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	obj_flags = CAN_BE_HIT
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_PAPERFRAME
	canSmoothWith = SMOOTH_GROUP_PAPERFRAME
	glass_amount = 2
	glass_type = /obj/item/stack/sheet/paperframes
	heat_resistance = 233
	decon_speed = 10
	can_atmos_pass = ATMOS_PASS_YES
	resistance_flags = FLAMMABLE
	armor_type = /datum/armor/none
	knock_sound = SFX_PAGE_TURN
	bash_sound = 'sound/weapons/slashmiss.ogg'
	break_sound = 'sound/items/poster_ripped.ogg'
	hit_sound = 'sound/weapons/slashmiss.ogg'
	var/static/mutable_appearance/torn = mutable_appearance('icons/obj/smooth_structures/structure_variations.dmi',icon_state = "paper-torn", layer = ABOVE_OBJ_LAYER - 0.1)
	var/static/mutable_appearance/paper = mutable_appearance('icons/obj/smooth_structures/structure_variations.dmi',icon_state = "paper-whole", layer = ABOVE_OBJ_LAYER - 0.1)

/obj/structure/window/paperframe/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/structure/window/paperframe/examine(mob/user)
	. = ..()
	if(atom_integrity < max_integrity)
		. += span_info("看起来受损了, 你可以用一些<b>纸</b>修好.")

/obj/structure/window/paperframe/spawn_debris(location)
	. = list(new /obj/item/stack/sheet/mineral/wood(location))
	for (var/i in 1 to rand(1,4))
		. += new /obj/item/paper/natural(location)

/obj/structure/window/paperframe/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.combat_mode)
		take_damage(4, BRUTE, MELEE, 0)
		if(!QDELETED(src))
			update_appearance()

/obj/structure/window/paperframe/update_appearance(updates)
	. = ..()
	set_opacity(atom_integrity >= max_integrity)

/obj/structure/window/paperframe/update_icon(updates=ALL)
	. = ..()
	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)))
		QUEUE_SMOOTH(src)

/obj/structure/window/paperframe/update_overlays()
	. = ..()
	. += (atom_integrity < max_integrity) ? torn : paper

/obj/structure/window/paperframe/attackby(obj/item/W, mob/living/user)
	if(W.get_temperature())
		fire_act(W.get_temperature())
		return
	if(user.combat_mode)
		return ..()
	if(istype(W, /obj/item/paper) && atom_integrity < max_integrity)
		user.visible_message(span_notice("[user]开始修补[src]上的洞."))
		if(do_after(user, 2 SECONDS, target = src))
			atom_integrity = min(atom_integrity+4,max_integrity)
			qdel(W)
			user.visible_message(span_notice("[user]开始修补[src]上的洞."))
			if(atom_integrity == max_integrity)
				update_appearance()
			return
	..()
	update_appearance()

/obj/structure/window/bronze
	name = "青铜窗"
	desc = "嵌着一块坚固的半透明青铜，相信我，弱青铜是这样的."
	icon = 'icons/obj/smooth_structures/structure_variations.dmi'
	icon_state = "clockwork_window-single"
	glass_type = /obj/item/stack/sheet/bronze

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/window/bronze/spawner, 0)

/obj/structure/window/bronze/unanchored
	anchored = FALSE

/obj/structure/window/bronze/fulltile
	icon = 'icons/obj/smooth_structures/clockwork_window.dmi'
	icon_state = "clockwork_window-0"
	base_icon_state = "clockwork_window"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WINDOW_FULLTILE_BRONZE + SMOOTH_GROUP_WINDOW_FULLTILE
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE_BRONZE
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	obj_flags = CAN_BE_HIT
	max_integrity = 50
	glass_amount = 2

/obj/structure/window/bronze/fulltile/unanchored
	anchored = FALSE
