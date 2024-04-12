/obj/structure/light_construct
	name = "灯具框架"
	desc = "正在建造的灯具."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = TRUE
	layer = WALL_OBJ_LAYER
	max_integrity = 200
	armor_type = /datum/armor/structure_light_construct

	///Light construction stage (LIGHT_CONSTRUCT_EMPTY, LIGHT_CONSTRUCT_WIRED, LIGHT_CONSTRUCT_CLOSED)
	var/stage = LIGHT_CONSTRUCT_EMPTY
	///Type of fixture for icon state
	var/fixture_type = "tube"
	///Amount of sheets gained on deconstruction
	var/sheets_refunded = 2
	///Reference for light object
	var/obj/machinery/light/new_light = null
	///Reference for the internal cell
	var/obj/item/stock_parts/cell/cell
	///Can we support a cell?
	var/cell_connectors = TRUE

/datum/armor/structure_light_construct
	melee = 50
	bullet = 10
	laser = 10
	fire = 80
	acid = 50

/obj/structure/light_construct/Initialize(mapload, ndir, building)
	. = ..()
	if(building)
		setDir(ndir)
	find_and_hang_on_wall()

/obj/structure/light_construct/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/structure/light_construct/get_cell()
	return cell

/obj/structure/light_construct/examine(mob/user)
	. = ..()
	switch(stage)
		if(LIGHT_CONSTRUCT_EMPTY)
			. += "它是一个空框架."
		if(LIGHT_CONSTRUCT_WIRED)
			. += "它已经连线."
		if(LIGHT_CONSTRUCT_CLOSED)
			. += "套管已关闭."
	if(cell_connectors)
		if(cell)
			. += "你看到[cell]在套管里."
		else
			. += "没有备用电池在套管里."
	else
		. += span_danger("这个套管不支持备用电池.")

/obj/structure/light_construct/attack_hand(mob/user, list/modifiers)
	if(!cell)
		return
	user.visible_message(span_notice("[user]从[src]移除[cell]!"), span_notice("你移除[cell]."))
	user.put_in_hands(cell)
	cell.update_appearance()
	cell = null
	add_fingerprint(user)

/obj/structure/light_construct/attack_tk(mob/user)
	if(!cell)
		return
	to_chat(user, span_notice("你用灵能移走了[cell]."))
	var/obj/item/stock_parts/cell/cell_reference = cell
	cell = null
	cell_reference.forceMove(drop_location())
	return cell_reference.attack_tk(user)

/obj/structure/light_construct/attackby(obj/item/tool, mob/user, params)
	add_fingerprint(user)
	if(istype(tool, /obj/item/stock_parts/cell))
		if(!cell_connectors)
			to_chat(user, span_warning("这个[name]不支持电池!"))
			return
		if(HAS_TRAIT(tool, TRAIT_NODROP))
			to_chat(user, span_warning("[tool]粘在了你的手上!"))
			return
		if(cell)
			to_chat(user, span_warning("已经安装了一个电池!"))
			return
		if(user.temporarilyRemoveItemFromInventory(tool))
			user.visible_message(span_notice("[user]将[tool]连接到[src]."), \
			span_notice("你添加[tool]到[src]."))
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
			tool.forceMove(src)
			cell = tool
			add_fingerprint(user)
			return
	if(istype(tool, /obj/item/light))
		to_chat(user, span_warning("这个[name]还没有完成设置!"))
		return

	switch(stage)
		if(LIGHT_CONSTRUCT_EMPTY)
			if(tool.tool_behaviour == TOOL_WRENCH)
				if(cell)
					to_chat(user, span_warning("你得先移除电池!"))
					return
				to_chat(user, span_notice("你开始拆解[src]..."))
				if (tool.use_tool(src, user, 30, volume=50))
					new /obj/item/stack/sheet/iron(drop_location(), sheets_refunded)
					user.visible_message(span_notice("[user.name]拆解[src]."), \
						span_notice("你拆解[src]."), span_hear("你听到棘轮声."))
					playsound(src, 'sound/items/deconstruct.ogg', 75, TRUE)
					qdel(src)
				return

			if(istype(tool, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/coil = tool
				if(coil.use(1))
					icon_state = "[fixture_type]-construct-stage2"
					stage = LIGHT_CONSTRUCT_WIRED
					user.visible_message(span_notice("[user.name]添加到电线到[src]."), \
						span_notice("你添加到电线到[src]."))
				else
					to_chat(user, span_warning("你需要一根足够长的电线来连接[src]!"))
				return
		if(LIGHT_CONSTRUCT_WIRED)
			if(tool.tool_behaviour == TOOL_WRENCH)
				to_chat(usr, span_warning("你得先移除电线!"))
				return

			if(tool.tool_behaviour == TOOL_WIRECUTTER)
				stage = LIGHT_CONSTRUCT_EMPTY
				icon_state = "[fixture_type]-construct-stage1"
				new /obj/item/stack/cable_coil(drop_location(), 1, "red")
				user.visible_message(span_notice("[user.name]从[src]移除电线."), \
					span_notice("你从[src]中移除电线."), span_hear("你听到咔哒声."))
				tool.play_tool_sound(src, 100)
				return

			if(tool.tool_behaviour == TOOL_SCREWDRIVER)
				user.visible_message(span_notice("[user.name]关上[src]的套管."), \
					span_notice("你关上[src]的套管."), span_hear("你听到了螺丝刀的声音."))
				tool.play_tool_sound(src, 75)
				switch(fixture_type)
					if("tube")
						new_light = new /obj/machinery/light/built(loc)
					if("bulb")
						new_light = new /obj/machinery/light/small/built(loc)
				new_light.setDir(dir)
				transfer_fingerprints_to(new_light)
				if(!QDELETED(cell))
					new_light.cell = cell
					cell.forceMove(new_light)
					cell = null
				qdel(src)
				return
	return ..()

/obj/structure/light_construct/blob_act(obj/structure/blob/attacking_blob)
	if(attacking_blob && attacking_blob.loc == loc)
		qdel(src)

/obj/structure/light_construct/deconstruct(disassembled = TRUE)
	if(!(obj_flags & NO_DECONSTRUCTION))
		new /obj/item/stack/sheet/iron(loc, sheets_refunded)
	qdel(src)

/obj/structure/light_construct/small
	name = "小型灯具框架"
	icon_state = "bulb-construct-stage1"
	fixture_type = "bulb"
	sheets_refunded = 1
