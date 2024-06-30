/// Normal SM with it's processing disabled.
/obj/machinery/power/supermatter_crystal/hugbox
	disable_damage = TRUE
	disable_gas =  TRUE
	disable_power_change = TRUE
	disable_process = SM_PROCESS_DISABLED

/// Normal SM designated as main engine.
/obj/machinery/power/supermatter_crystal/engine
	is_main_engine = TRUE

/// Shard SM.
/obj/machinery/power/supermatter_crystal/shard
	name = "超物质碎片"
	desc = "一种奇怪的半透明和虹色晶体，看起来像它曾经是一个更大结构的一部分."
	base_icon_state = "sm_shard"
	icon_state = "sm_shard"
	anchored = FALSE
	absorption_ratio = 0.125
	explosion_power = 12
	layer = ABOVE_MOB_LAYER
	moveable = TRUE


/obj/machinery/power/supermatter_crystal/shard/Initialize(mapload)
	. = ..()

	register_context()


/obj/machinery/power/supermatter_crystal/shard/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(held_item?.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = anchored ? "Unanchor" : "Anchor"
		return CONTEXTUAL_SCREENTIP_SET


/// Shard SM with it's processing disabled.
/obj/machinery/power/supermatter_crystal/shard/hugbox
	name = "锚定的超物质碎片"
	disable_damage = TRUE
	disable_gas =  TRUE
	disable_power_change = TRUE
	disable_process = SM_PROCESS_DISABLED
	moveable = FALSE
	anchored = TRUE

/// Shard SM designated as the main engine.
/obj/machinery/power/supermatter_crystal/shard/engine
	name = "锚定的超物质碎片"
	is_main_engine = TRUE
	anchored = TRUE
	moveable = FALSE

/atom/movable/supermatter_warp_effect
	plane = GRAVITY_PULSE_PLANE
	appearance_flags = PIXEL_SCALE // no tile bound so you can see it around corners and so
	icon = 'icons/effects/light_overlays/light_352.dmi'
	icon_state = "light"
	pixel_x = -176
	pixel_y = -176
