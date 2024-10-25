/obj/machinery/door/poddoor
	name = "防爆门"
	desc = "只能通过机械动力开启的重型防爆门."
	icon = 'icons/obj/doors/blastdoor.dmi' //ICON OVERRIDDEN IN SKYRAT AESTHETICS - SEE MODULE
	icon_state = "closed"
	layer = BLASTDOOR_LAYER
	closingLayer = CLOSED_BLASTDOOR_LAYER
	sub_door = TRUE
	explosion_block = 3
	heat_proof = TRUE
	safe = FALSE
	max_integrity = 600
	armor_type = /datum/armor/door_poddoor
	resistance_flags = FIRE_PROOF
	damage_deflection = 70
	can_open_with_hands = FALSE
	/// The recipe for this door
	var/datum/crafting_recipe/recipe_type = /datum/crafting_recipe/blast_doors
	/// The current deconstruction step
	var/deconstruction = BLASTDOOR_FINISHED
	/// The door's ID (used for buttons, etc to control the door)
	var/id = 1
	/// The sound that plays when the door opens/closes
	var/animation_sound = 'sound/machines/blastdoor.ogg'

/datum/armor/door_poddoor
	melee = 50
	bullet = 100
	laser = 100
	energy = 100
	bomb = 50
	fire = 100
	acid = 70

/obj/machinery/door/poddoor/get_save_vars()
	return ..() + NAMEOF(src, id)

/obj/machinery/door/poddoor/examine(mob/user)
	. = ..()
	if(panel_open)
		if(deconstruction == BLASTDOOR_FINISHED)
			. += span_notice("检修面板被打开，内部电子元件可以被撬出来.")
			. += span_notice("[src]可以用多功能工具标定到一扇防爆门的控制ID上.")
		else if(deconstruction == BLASTDOOR_NEEDS_ELECTRONICS)
			. += span_notice("<i>电子元件</i>缺失，有一些<b>线缆</b>暴露了出来.")
		else if(deconstruction == BLASTDOOR_NEEDS_WIRES)
			. += span_notice("<i>线缆</i>缺失，可以被焊枪拆解.")

/obj/machinery/door/poddoor/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(isnull(held_item))
		return NONE
	if(deconstruction == BLASTDOOR_NEEDS_WIRES && istype(held_item, /obj/item/stack/cable_coil))
		context[SCREENTIP_CONTEXT_LMB] = "接上线缆"
		return CONTEXTUAL_SCREENTIP_SET
	if(deconstruction == BLASTDOOR_NEEDS_ELECTRONICS && istype(held_item, /obj/item/electronics/airlock))
		context[SCREENTIP_CONTEXT_LMB] = "添加电子元件"
		return CONTEXTUAL_SCREENTIP_SET
	//we do not check for special effects like if they can actually perform the action because they will be told they can't do it when they try,
	//with feedback on what they have to do in order to do so.
	switch(held_item.tool_behaviour)
		if(TOOL_SCREWDRIVER)
			context[SCREENTIP_CONTEXT_LMB] = "打开检修盖"
			return CONTEXTUAL_SCREENTIP_SET
		if(TOOL_MULTITOOL)
			context[SCREENTIP_CONTEXT_LMB] = "标定ID"
			return CONTEXTUAL_SCREENTIP_SET
		if(TOOL_CROWBAR)
			context[SCREENTIP_CONTEXT_LMB] = "移除电子元件"
			return CONTEXTUAL_SCREENTIP_SET
		if(TOOL_WIRECUTTER)
			context[SCREENTIP_CONTEXT_LMB] = "移除线缆"
			return CONTEXTUAL_SCREENTIP_SET
		if(TOOL_WELDER)
			context[SCREENTIP_CONTEXT_LMB] = "拆解"
			return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/door/poddoor/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(deconstruction == BLASTDOOR_NEEDS_WIRES && istype(tool, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = tool
		var/datum/crafting_recipe/recipe = locate(recipe_type) in GLOB.crafting_recipes
		var/amount_needed = recipe.reqs[/obj/item/stack/cable_coil]
		if(coil.get_amount() < amount_needed)
			balloon_alert(user, "线缆不足!")
			return ITEM_INTERACT_SUCCESS
		balloon_alert(user, "添加线缆中...")
		if(!do_after(user, 5 SECONDS, src))
			return ITEM_INTERACT_SUCCESS
		coil.use(amount_needed)
		deconstruction = BLASTDOOR_NEEDS_ELECTRONICS
		balloon_alert(user, "线缆已添加")
		return ITEM_INTERACT_SUCCESS

	if(deconstruction == BLASTDOOR_NEEDS_ELECTRONICS && istype(tool, /obj/item/electronics/airlock))
		balloon_alert(user, "添加电子元件...")
		if(!do_after(user, 10 SECONDS, src))
			return ITEM_INTERACT_SUCCESS
		qdel(tool)
		balloon_alert(user, "电子元件已添加")
		deconstruction = BLASTDOOR_FINISHED
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/machinery/door/poddoor/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if (density)
		balloon_alert(user, "先打开门!")
		return ITEM_INTERACT_SUCCESS
	else if (default_deconstruction_screwdriver(user, icon_state, icon_state, tool))
		return ITEM_INTERACT_SUCCESS

/obj/machinery/door/poddoor/multitool_act(mob/living/user, obj/item/tool)
	. = ..()
	if (density)
		balloon_alert(user, "先打开门!")
		return ITEM_INTERACT_SUCCESS
	if (!panel_open)
		balloon_alert(user, "先打开检修面板!")
		return ITEM_INTERACT_SUCCESS
	if (deconstruction != BLASTDOOR_FINISHED)
		return
	var/change_id = tgui_input_number(user, "设定此门ID (当前: [id])", "门控制器ID", isnum(id) ? id : null, 100)
	if(!change_id || QDELETED(usr) || QDELETED(src) || !usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return
	id = change_id
	to_chat(user, span_notice("你更改ID为[id]."))
	balloon_alert(user, "id已改变")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/door/poddoor/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(machine_stat & NOPOWER)
		open(TRUE)
		return ITEM_INTERACT_SUCCESS
	if (density)
		balloon_alert(user, "先打开门!")
		return ITEM_INTERACT_SUCCESS
	if (!panel_open)
		balloon_alert(user, "先打开检修面板!")
		return ITEM_INTERACT_SUCCESS
	if (deconstruction != BLASTDOOR_FINISHED)
		return
	balloon_alert(user, "移除气闸电子元件...")
	if(tool.use_tool(src, user, 10 SECONDS, volume = 50))
		new /obj/item/electronics/airlock(loc)
		id = null
		deconstruction = BLASTDOOR_NEEDS_ELECTRONICS
		balloon_alert(user, "已移除气闸电子元件")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/door/poddoor/wirecutter_act(mob/living/user, obj/item/tool)
	. = ..()
	if (density)
		balloon_alert(user, "先打开门!")
		return ITEM_INTERACT_SUCCESS
	if (!panel_open)
		balloon_alert(user, "先打开检修面板!")
		return ITEM_INTERACT_SUCCESS
	if (deconstruction != BLASTDOOR_NEEDS_ELECTRONICS)
		return
	balloon_alert(user, "移除内部线缆...")
	if(tool.use_tool(src, user, 10 SECONDS, volume = 50))
		var/datum/crafting_recipe/recipe = locate(recipe_type) in GLOB.crafting_recipes
		var/amount = recipe.reqs[/obj/item/stack/cable_coil]
		new /obj/item/stack/cable_coil(loc, amount)
		deconstruction = BLASTDOOR_NEEDS_WIRES
		balloon_alert(user, "已移除外部线缆")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/door/poddoor/welder_act(mob/living/user, obj/item/tool)
	. = ..()
	if (density)
		balloon_alert(user, "先打开门!")
		return ITEM_INTERACT_SUCCESS
	if (!panel_open)
		balloon_alert(user, "先打开检修面板!")
		return ITEM_INTERACT_SUCCESS
	if (deconstruction != BLASTDOOR_NEEDS_WIRES)
		return
	balloon_alert(user, "切割...") //You're tearing me apart, Lisa!
	if(tool.use_tool(src, user, 15 SECONDS, volume = 50))
		var/datum/crafting_recipe/recipe = locate(recipe_type) in GLOB.crafting_recipes
		var/amount = recipe.reqs[/obj/item/stack/sheet/plasteel]
		new /obj/item/stack/sheet/plasteel(loc, amount)
		user.balloon_alert(user, "切割完成")
		qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/door/poddoor/connect_to_shuttle(mapload, obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	id = "[port.shuttle_id]_[id]"

//"BLAST" doors are obviously stronger than regular doors when it comes to BLASTS.
/obj/machinery/door/poddoor/ex_act(severity, target)
	if(severity <= EXPLODE_LIGHT)
		return FALSE
	return ..()

/obj/machinery/door/poddoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("opening", src)
			playsound(src, animation_sound, 50, TRUE)
		if("closing")
			flick("closing", src)
			playsound(src, animation_sound, 50, TRUE)

/obj/machinery/door/poddoor/update_icon_state()
	. = ..()
	icon_state = density ? "closed" : "open"

/obj/machinery/door/poddoor/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	if(density & !(resistance_flags & INDESTRUCTIBLE))
		add_fingerprint(user)
		user.visible_message(span_warning("[user]开始撬[src]."),\
					span_noticealien("你拼尽全力将爪子伸进[src]里!"),\
					span_warning("你听到金属撕裂声..."))
		playsound(src, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE)

		var/time_to_open = 5 SECONDS
		if(hasPower())
			time_to_open = 15 SECONDS

		if(do_after(user, time_to_open, src))
			if(density && !open(TRUE)) //The airlock is still closed, but something prevented it opening. (Another player noticed and bolted/welded the airlock in time!)
				to_chat(user, span_warning("尽管你努力尝试了, [src]还是成功阻止了你打开它!"))

	else
		return ..()

/obj/machinery/door/poddoor/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE

/obj/machinery/door/poddoor/ert
	name = "硬化防爆门"
	desc = "只在紧急情况下开启的重型防爆门."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

//special poddoors that open when emergency shuttle docks at centcom
/obj/machinery/door/poddoor/shuttledock
	var/checkdir = 4 //door won't open if turf in this dir is `turftype`
	var/turftype = /turf/open/space

/obj/machinery/door/poddoor/shuttledock/proc/check()
	var/turf/turf = get_step(src, checkdir)
	if(!istype(turf, turftype))
		INVOKE_ASYNC(src, PROC_REF(open))
	else
		INVOKE_ASYNC(src, PROC_REF(close))

/obj/machinery/door/poddoor/incinerator_ordmix
	name = "燃烧室通风门"
	id = INCINERATOR_ORDMIX_VENT

/obj/machinery/door/poddoor/incinerator_atmos_main
	name = "涡轮机通风门"
	id = INCINERATOR_ATMOS_MAINVENT

/obj/machinery/door/poddoor/incinerator_atmos_aux
	name = "燃烧室通风门"
	id = INCINERATOR_ATMOS_AUXVENT

/obj/machinery/door/poddoor/atmos_test_room_mainvent_1
	name = "测试1 通风门"
	id = TEST_ROOM_ATMOS_MAINVENT_1

/obj/machinery/door/poddoor/atmos_test_room_mainvent_2
	name = "测试2 通风门"
	id = TEST_ROOM_ATMOS_MAINVENT_2

/obj/machinery/door/poddoor/incinerator_syndicatelava_main
	name = "涡轮机通风门"
	id = INCINERATOR_SYNDICATELAVA_MAINVENT

/obj/machinery/door/poddoor/incinerator_syndicatelava_aux
	name = "燃烧室通风门"
	id = INCINERATOR_SYNDICATELAVA_AUXVENT

/obj/machinery/door/poddoor/massdriver_ordnance
	name = "军械发射门"
	id = MASSDRIVER_ORDNANCE

/obj/machinery/door/poddoor/massdriver_chapel
	name = "教堂发射门"
	id = MASSDRIVER_CHAPEL

/obj/machinery/door/poddoor/massdriver_trash
	name = "处置发射门"
	id = MASSDRIVER_DISPOSALS
