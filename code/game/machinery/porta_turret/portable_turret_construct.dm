#define PTURRET_UNSECURED  0
#define PTURRET_BOLTED  1
#define PTURRET_START_INTERNAL_ARMOUR  2
#define PTURRET_INTERNAL_ARMOUR_ON  3
#define PTURRET_GUN_EQUIPPED  4
#define PTURRET_SENSORS_ON  5
#define PTURRET_CLOSED  6
#define PTURRET_START_EXTERNAL_ARMOUR  7
#define PTURRET_EXTERNAL_ARMOUR_ON  8

/obj/machinery/porta_turret_construct
	name = "炮塔框架"
	icon = 'icons/obj/weapons/turrets.dmi'
	icon_state = "turret_frame"
	desc = "未完工的炮塔框架."
	anchored = FALSE
	density = TRUE
	use_power = NO_POWER_USE
	var/build_step = PTURRET_UNSECURED //the current step in the building process
	var/finish_name = "炮塔" //the name applied to the product turret
	var/obj/item/gun/installed_gun = null

/obj/machinery/porta_turret_construct/examine(mob/user)
	. = ..()
	switch(build_step)
		if(PTURRET_UNSECURED)
			. += span_notice("外部螺栓未用扳手拧紧, 框架可以被撬棍撬开.")
		if(PTURRET_BOLTED)
			. += span_notice("需要金属作为内部装甲, 外部螺栓可以被扳手拧开.")
		if(PTURRET_START_INTERNAL_ARMOUR)
			. += span_notice("装甲需要用螺栓固定到位, 用焊枪焊接以拆下装甲.")
		if(PTURRET_INTERNAL_ARMOUR_ON)
			. += span_notice("炮塔需要一把能量武器才能工作, 装甲上的螺栓可以被拧开.")
		if(PTURRET_GUN_EQUIPPED)
			. += span_notice("炮塔需要一个距离传感器才能工作, 内部能量武器可以被移除.")
		if(PTURRET_SENSORS_ON)
			. += span_notice("炮塔检修口盖子未用螺丝固定, 距离传感器可以被移除.")
		if(PTURRET_CLOSED)
			. += span_notice("炮塔需要金属作为外部装甲, 检修口盖子可以通过拧螺丝打开.")
		if(PTURRET_START_EXTERNAL_ARMOUR)
			. += span_notice("炮塔外部装甲需要焊接到位, 现在看起来能被撬开.")

/obj/machinery/porta_turret_construct/attackby(obj/item/used, mob/user, params)
	//this is a bit unwieldy but self-explanatory
	switch(build_step)
		if(PTURRET_UNSECURED) //first step
			if(used.tool_behaviour == TOOL_WRENCH && !anchored)
				used.play_tool_sound(src, 100)
				to_chat(user, span_notice("你固定了外部螺栓."))
				set_anchored(TRUE)
				build_step = PTURRET_BOLTED
				return

			else if(used.tool_behaviour == TOOL_CROWBAR && !anchored)
				used.play_tool_sound(src, 75)
				to_chat(user, span_notice("你拆除了炮塔结构."))
				new /obj/item/stack/sheet/iron(loc, 5)
				qdel(src)
				return

		if(PTURRET_BOLTED)
			if(istype(used, /obj/item/stack/sheet/iron))
				var/obj/item/stack/sheet/iron/sheet = used
				if(sheet.use(2))
					to_chat(user, span_notice("你添加了一些金属作为炮塔内部装甲."))
					build_step = PTURRET_START_INTERNAL_ARMOUR
					icon_state = "turret_frame2"
				else
					to_chat(user, span_warning("你需要2份铁进行建造!"))
				return

			else if(used.tool_behaviour == TOOL_WRENCH)
				used.play_tool_sound(src, 75)
				to_chat(user, span_notice("你拧开了外部螺栓."))
				set_anchored(FALSE)
				build_step = PTURRET_UNSECURED
				return


		if(PTURRET_START_INTERNAL_ARMOUR)
			if(used.tool_behaviour == TOOL_WRENCH)
				used.play_tool_sound(src, 100)
				to_chat(user, span_notice("你将内部装甲固定到位."))
				build_step = PTURRET_INTERNAL_ARMOUR_ON
				return

			else if(used.tool_behaviour == TOOL_WELDER)
				if(!used.tool_start_check(user, amount = 5)) //uses up 5 fuel
					return

				to_chat(user, span_notice("你开始移除炮塔内部装甲..."))

				if(used.use_tool(src, user, 20, volume = 50, amount = 5)) //uses up 5 fuel
					build_step = PTURRET_BOLTED
					to_chat(user, span_notice("你移除了炮塔内部装甲."))
					new /obj/item/stack/sheet/iron(drop_location(), 2)
					return


		if(PTURRET_INTERNAL_ARMOUR_ON)
			if(istype(used, /obj/item/gun/energy)) //the gun installation part
				var/obj/item/gun/energy/egun = used
				if(egun.gun_flags & TURRET_INCOMPATIBLE)
					to_chat(user, span_notice("你觉得在炮塔上加[used]是不对的"))
					return
				if(!user.transferItemToLoc(egun, src))
					return
				installed_gun = egun
				to_chat(user, span_notice("你添加[used]到炮塔上."))
				build_step = PTURRET_GUN_EQUIPPED
				return
			else if(used.tool_behaviour == TOOL_WRENCH)
				used.play_tool_sound(src, 100)
				to_chat(user, span_notice("你拧开了炮塔的内部装甲螺栓."))
				build_step = PTURRET_START_INTERNAL_ARMOUR
				return

		if(PTURRET_GUN_EQUIPPED)
			if(isprox(used))
				build_step = PTURRET_SENSORS_ON
				if(!user.temporarilyRemoveItemFromInventory(used))
					return
				to_chat(user, span_notice("你添加距离传感器到炮塔上."))
				qdel(used)
				return


		if(PTURRET_SENSORS_ON)
			if(used.tool_behaviour == TOOL_SCREWDRIVER)
				used.play_tool_sound(src, 100)
				build_step = PTURRET_CLOSED
				to_chat(user, span_notice("你关上了炮塔内部检修口."))
				return


		if(PTURRET_CLOSED)
			if(istype(used, /obj/item/stack/sheet/iron))
				var/obj/item/stack/sheet/iron/sheet = used
				if(sheet.use(2))
					to_chat(user, span_notice("你添加一些金属到炮塔外部框架上."))
					build_step = PTURRET_START_EXTERNAL_ARMOUR
				else
					to_chat(user, span_warning("你需要2份铁来继续建造!"))
				return

			else if(used.tool_behaviour == TOOL_SCREWDRIVER)
				used.play_tool_sound(src, 100)
				build_step = PTURRET_SENSORS_ON
				to_chat(user, span_notice("你打开了炮塔内部检修口."))
				return

		if(PTURRET_START_EXTERNAL_ARMOUR)
			if(used.tool_behaviour == TOOL_WELDER)
				if(!used.tool_start_check(user, amount = 5))
					return

				to_chat(user, span_notice("你开始焊接炮塔装甲..."))
				if(used.use_tool(src, user, 30, volume = 50, amount = 5))
					build_step = PTURRET_EXTERNAL_ARMOUR_ON
					to_chat(user, span_notice("你完成了焊接炮塔装甲."))

					//The final step: create a full turret

					var/obj/machinery/porta_turret/turret
					//fuck lasertag turrets
					if(istype(installed_gun, /obj/item/gun/energy/laser/bluetag) || istype(installed_gun, /obj/item/gun/energy/laser/redtag))
						turret = new/obj/machinery/porta_turret/lasertag(loc)
					else
						turret = new/obj/machinery/porta_turret(loc)
					turret.name = finish_name
					turret.installation = installed_gun.type
					turret.setup(installed_gun)
					turret.locked = FALSE
					qdel(src)
					return

			else if(used.tool_behaviour == TOOL_CROWBAR)
				used.play_tool_sound(src, 75)
				to_chat(user, span_notice("你撬开了炮塔外部装甲."))
				new /obj/item/stack/sheet/iron(loc, 2)
				build_step = PTURRET_CLOSED
				return

	if(used.get_writing_implement_details()?["interaction_mode"] == MODE_WRITING) //you can rename turrets like bots!
		var/choice = tgui_input_text(user, "输入炮塔名称", "炮塔编目", finish_name, MAX_NAME_LEN)
		if(!choice)
			return
		if(!user.can_perform_action(src))
			return

		finish_name = choice
		return
	return ..()


/obj/machinery/porta_turret_construct/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	switch(build_step)
		if(PTURRET_GUN_EQUIPPED)
			build_step = PTURRET_INTERNAL_ARMOUR_ON

			installed_gun.forceMove(loc)
			to_chat(user, span_notice("你移除了[installed_gun]从炮塔框架."))
			installed_gun = null

		if(PTURRET_SENSORS_ON)
			to_chat(user, span_notice("你移除了距离传感器从炮塔框架."))
			new /obj/item/assembly/prox_sensor(loc)
			build_step = PTURRET_GUN_EQUIPPED

/obj/machinery/porta_turret_construct/attack_ai()
	return

#undef PTURRET_BOLTED
#undef PTURRET_CLOSED
#undef PTURRET_EXTERNAL_ARMOUR_ON
#undef PTURRET_GUN_EQUIPPED
#undef PTURRET_INTERNAL_ARMOUR_ON
#undef PTURRET_SENSORS_ON
#undef PTURRET_START_EXTERNAL_ARMOUR
#undef PTURRET_START_INTERNAL_ARMOUR
#undef PTURRET_UNSECURED
