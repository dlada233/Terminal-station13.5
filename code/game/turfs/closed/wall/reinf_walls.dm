/turf/closed/wall/r_wall
	name = "加固墙壁"
	desc = "用于分隔空间的大块加固金属."
	icon = 'icons/turf/walls/reinforced_wall.dmi' //ICON OVERRIDDEN IN SKYRAT AESTHETICS - SEE MODULE
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"
	opacity = TRUE
	density = TRUE
	turf_flags = IS_SOLID
	smoothing_flags = SMOOTH_BITMASK
	hardness = 10
	sheet_type = /obj/item/stack/sheet/plasteel
	sheet_amount = 1
	girder_type = /obj/structure/girder/reinforced
	explosive_resistance = 2
	rad_insulation = RAD_HEAVY_INSULATION
	rust_resistance = RUST_RESISTANCE_REINFORCED
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall. also indicates the temperature at wich the wall will melt (currently only able to melt with H/E pipes)
	///Dismantled state, related to deconstruction.
	var/d_state = INTACT
	///Base icon state to use for deconstruction
	var/base_decon_state = "r_wall"

/turf/closed/wall/r_wall/deconstruction_hints(mob/user)
	switch(d_state)
		if(INTACT)
			return span_notice("<b>外部格栅</b>完好无损.")
		if(SUPPORT_LINES)
			return span_notice("<i>外部格栅</i>已被拆开, 暴露出来的支撑条被<b>螺丝</b>钉在了外壳上.")
		if(COVER)
			return span_notice("支撑条上的<i>螺丝</i>已经被拧掉, 其后的金属盖板被牢牢<b>焊接</b>在位置上.")
		if(CUT_COVER)
			return span_notice("金属盖板的焊接点已被<i>焊枪</i>切割开来, 盖板现在<b>不牢固地贴合</b>在结构梁上.")
		if(ANCHOR_BOLTS)
			return span_notice("外部覆盖已经被<i>撬开</i>, 其内部支撑杆的螺栓可以用<b>扳手</b>拧开.")
		if(SUPPORT_RODS)
			return span_notice("内部支撑杆的<i>螺栓</i>, 但仍被牢固地<b>焊接</b>在结构梁上.")
		if(SHEATH)
			return span_notice("支撑杆已被<i>焊枪</i>切割断, 其护套<b>不牢固地贴合</b>在结构梁上.")

/turf/closed/wall/r_wall/devastate_wall()
	new sheet_type(src, sheet_amount)
	new /obj/item/stack/sheet/iron(src, 2)

/turf/closed/wall/r_wall/hulk_recoil(obj/item/bodypart/arm, mob/living/carbon/human/hulkman, damage = 41)
	return ..()

/turf/closed/wall/r_wall/try_decon(obj/item/W, mob/user, turf/T)
	//DECONSTRUCTION
	switch(d_state)
		if(INTACT)
			if(W.tool_behaviour == TOOL_WIRECUTTER)
				W.play_tool_sound(src, 100)
				d_state = SUPPORT_LINES
				update_appearance()
				to_chat(user, span_notice("你拆开了外部格栅."))
				return TRUE

		if(SUPPORT_LINES)
			if(W.tool_behaviour == TOOL_SCREWDRIVER)
				to_chat(user, span_notice("你开始取下支撑条..."))
				if(W.use_tool(src, user, 40, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != SUPPORT_LINES)
						return TRUE
					d_state = COVER
					update_appearance()
					to_chat(user, span_notice("你取下了支撑条."))
				return TRUE

			else if(W.tool_behaviour == TOOL_WIRECUTTER)
				W.play_tool_sound(src, 100)
				d_state = INTACT
				update_appearance()
				to_chat(user, span_notice("你修复了外部格栅."))
				return TRUE

		if(COVER)
			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=2))
					return
				to_chat(user, span_notice("你开始切割金属盖板焊接点..."))
				if(W.use_tool(src, user, 60, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != COVER)
						return TRUE
					d_state = CUT_COVER
					update_appearance()
					to_chat(user, span_notice("你切割了金属盖板焊接点."))
				return TRUE

			if(W.tool_behaviour == TOOL_SCREWDRIVER)
				to_chat(user, span_notice("你开始固定支撑条..."))
				if(W.use_tool(src, user, 40, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != COVER)
						return TRUE
					d_state = SUPPORT_LINES
					update_appearance()
					to_chat(user, span_notice("支撑条被固定好了."))
				return TRUE

		if(CUT_COVER)
			if(W.tool_behaviour == TOOL_CROWBAR)
				to_chat(user, span_notice("你开始撬开金属盖板..."))
				if(W.use_tool(src, user, 100, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != CUT_COVER)
						return TRUE
					d_state = ANCHOR_BOLTS
					update_appearance()
					to_chat(user, span_notice("你撬开了金属盖板."))
				return TRUE

			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=2))
					return
				to_chat(user, span_notice("你开始将金属盖板焊接到框架上..."))
				if(W.use_tool(src, user, 60, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != CUT_COVER)
						return TRUE
					d_state = COVER
					update_appearance()
					to_chat(user, span_notice("金属盖板已经被焊接到位."))
				return TRUE

		if(ANCHOR_BOLTS)
			if(W.tool_behaviour == TOOL_WRENCH)
				to_chat(user, span_notice("你开始拧动内部支撑杆上的螺栓..."))
				if(W.use_tool(src, user, 40, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != ANCHOR_BOLTS)
						return TRUE
					d_state = SUPPORT_RODS
					update_appearance()
					to_chat(user, span_notice("你取下了内部支撑杆上的螺栓."))
				return TRUE

			if(W.tool_behaviour == TOOL_CROWBAR)
				to_chat(user, span_notice("你开始将撬开的金属盖板贴回框架上..."))
				if(W.use_tool(src, user, 20, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != ANCHOR_BOLTS)
						return TRUE
					d_state = CUT_COVER
					update_appearance()
					to_chat(user, span_notice("被撬开的金属盖板回到了框架上."))
				return TRUE

		if(SUPPORT_RODS)
			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=2))
					return
				to_chat(user, span_notice("你开始切断支撑杆..."))
				if(W.use_tool(src, user, 100, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != SUPPORT_RODS)
						return TRUE
					d_state = SHEATH
					update_appearance()
					to_chat(user, span_notice("你切断了支撑杆."))
				return TRUE

			if(W.tool_behaviour == TOOL_WRENCH)
				to_chat(user, span_notice("你开始用螺栓将内部支撑杆固定到结构梁上..."))
				W.play_tool_sound(src, 100)
				if(W.use_tool(src, user, 40))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != SUPPORT_RODS)
						return TRUE
					d_state = ANCHOR_BOLTS
					update_appearance()
					to_chat(user, span_notice("你用螺栓将内部支撑杆固定到了结构梁上."))
				return TRUE

		if(SHEATH)
			if(W.tool_behaviour == TOOL_CROWBAR)
				to_chat(user, span_notice("你开始撬出护套..."))
				if(W.use_tool(src, user, 100, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != SHEATH)
						return TRUE
					to_chat(user, span_notice("你撬出了护套."))
					dismantle_wall()
				return TRUE

			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return
				to_chat(user, span_notice("你开始焊接内部支撑杆..."))
				if(W.use_tool(src, user, 100, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != SHEATH)
						return TRUE
					d_state = SUPPORT_RODS
					update_appearance()
					to_chat(user, span_notice("你把内部支撑杆焊接到了一起."))
				return TRUE
	return FALSE

/turf/closed/wall/r_wall/update_icon(updates=ALL)
	. = ..()
	if(d_state != INTACT)
		smoothing_flags = NONE
		return
	if (!(updates & UPDATE_SMOOTHING))
		return
	smoothing_flags = SMOOTH_BITMASK
	QUEUE_SMOOTH_NEIGHBORS(src)
	QUEUE_SMOOTH(src)

// We don't react to smoothing changing here because this else exists only to "revert" intact changes
/turf/closed/wall/r_wall/update_icon_state()
	if(d_state != INTACT)
		icon = 'modular_skyrat/modules/aesthetics/walls/icons/reinforced_wall.dmi' // SKYRAT EDIT CHANGE - ORIGINAL: icon = 'icons/turf/walls/reinforced_states.dmi'
		icon_state = "[base_decon_state]-[d_state]"
	else
		icon = 'modular_skyrat/modules/aesthetics/walls/icons/reinforced_wall.dmi' // SKYRAT EDIT CHANGE - ORIGINAL: icon = 'icons/turf/walls/reinforced_wall.dmi'
		icon_state = "[base_icon_state]-[smoothing_junction]"
	return ..()

/turf/closed/wall/r_wall/wall_singularity_pull(current_size)
	if(current_size >= STAGE_FIVE)
		if(prob(30))
			dismantle_wall()

/turf/closed/wall/r_wall/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.canRturf || the_rcd.construction_mode == RCD_WALLFRAME)
		return ..()


/turf/closed/wall/r_wall/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	if(the_rcd.canRturf || rcd_data["[RCD_DESIGN_MODE]"] == RCD_WALLFRAME)
		return ..()

/turf/closed/wall/r_wall/rust_turf()
	if(HAS_TRAIT(src, TRAIT_RUSTY))
		ChangeTurf(/turf/closed/wall/rust)
		return
	return ..()

/turf/closed/wall/r_wall/syndicate
	name = "船体"
	desc = "一艘不详之船的装甲船体."
	icon = 'icons/turf/walls/plastitanium_wall.dmi'
	icon_state = "plastitanium_wall-0"
	base_icon_state = "plastitanium_wall"
	explosive_resistance = 20
	sheet_type = /obj/item/stack/sheet/mineral/plastitanium
	hardness = 25 //plastitanium
	turf_flags = IS_SOLID
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_SYNDICATE_WALLS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_PLASTITANIUM_WALLS + SMOOTH_GROUP_SYNDICATE_WALLS
	rust_resistance = RUST_RESISTANCE_TITANIUM

/turf/closed/wall/r_wall/syndicate/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	return FALSE

/turf/closed/wall/r_wall/syndicate/nodiagonal
	icon = 'icons/turf/walls/plastitanium_wall.dmi'
	icon_state = "map-shuttle_nd"
	base_icon_state = "plastitanium_wall"
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/wall/r_wall/syndicate/overspace
	icon_state = "map-overspace"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	fixed_underlay = list("space" = TRUE)
