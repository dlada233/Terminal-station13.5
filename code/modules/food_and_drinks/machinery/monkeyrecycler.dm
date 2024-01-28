GLOBAL_LIST_EMPTY(monkey_recyclers)

/obj/machinery/monkey_recycler
	name = "猴子回收机"
	desc = "把死猴子再循环成猴子方块的机器."
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "grinder"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	circuit = /obj/item/circuitboard/machine/monkey_recycler
	var/stored_matter = 0
	var/cube_production = 0.2
	var/list/connected = list() //Keeps track of connected xenobio consoles, for deletion in /Destroy()

/obj/machinery/monkey_recycler/Initialize(mapload)
	. = ..()
	if (mapload)
		GLOB.monkey_recyclers += src

/obj/machinery/monkey_recycler/Destroy()
	GLOB.monkey_recyclers -= src
	for(var/thing in connected)
		var/obj/machinery/computer/camera_advanced/xenobio/console = thing
		console.connected_recycler = null
	connected.Cut()
	return ..()

/obj/machinery/monkey_recycler/RefreshParts() //Ranges from 0.2 to 0.8 per monkey recycled
	. = ..()
	cube_production = 0
	for(var/datum/stock_part/servo/servo in component_parts)
		cube_production += servo.tier * 0.2 // SKYRAT EDIT CHANGE - buffs to allow 1.2 cubes per monkey at T4 - ORIGINAL: cube_production += manipulator.tier * 0.1
	for(var/datum/stock_part/matter_bin/matter_bin in component_parts)
		cube_production += matter_bin.tier * 0.2 // SKYRAT EDIT CHANGE - buffs to allow 1.2 cubes per monkey at T4 - ORIGINAL: cube_production += matter_bin.tier * 0.1

/obj/machinery/monkey_recycler/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("状态显示为: 每只猴子生产<b>[cube_production]</b>方块.")

/obj/machinery/monkey_recycler/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(default_unfasten_wrench(user, tool))
		power_change()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/monkey_recycler/attackby(obj/item/O, mob/user, params)
	if(default_deconstruction_screwdriver(user, "grinder_open", "grinder", O))
		return

	if(default_pry_open(O, close_after_pry = TRUE))
		return

	if(default_deconstruction_crowbar(O))
		return

	if(machine_stat) //NOPOWER etc
		return
	else
		return ..()

/obj/machinery/monkey_recycler/MouseDrop_T(mob/living/target, mob/living/user)
	if(!istype(target))
		return
	if(ismonkey(target))
		stuff_monkey_in(target, user)

/obj/machinery/monkey_recycler/proc/stuff_monkey_in(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target))
		return
	if(target.stat == CONSCIOUS)
		to_chat(user, span_warning("猴子挣扎得太厉害了，没法把它放进回收站."))
		return
	if(target.buckled || target.has_buckled_mobs())
		to_chat(user, span_warning("这只猴子连着什么东西."))
		return
	qdel(target)
	to_chat(user, span_notice("你把猴子塞进机器."))
	playsound(src.loc, 'sound/machines/juicer.ogg', 50, TRUE)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 200) //start shaking
	use_power(active_power_usage)
	stored_matter += cube_production
	addtimer(VARSET_CALLBACK(src, pixel_x, base_pixel_x))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), user, span_notice("这台机器现在有[stored_matter]只猴子的材料储存.")))

/obj/machinery/monkey_recycler/interact(mob/user)
	if(stored_matter >= 1)
		to_chat(user, span_notice("机器在压缩磨碎的猴肉时发出巨大的嘶嘶声，过了一会儿，它分发了一个全新的猴子立方体."))
		playsound(src.loc, 'sound/machines/hiss.ogg', 50, TRUE)
		for(var/i in 1 to FLOOR(stored_matter, 1))
			new /obj/item/food/monkeycube(src.loc)
			stored_matter--
		to_chat(user, span_notice("这台机器的显示器闪烁着，展示还有[stored_matter]只猴子的材料储存."))
	else
		to_chat(user, span_danger("这台机器至少需要一只猴子的材料来生产一个猴子立方体. 它当前有[stored_matter]."))

/obj/machinery/monkey_recycler/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if(istype(I))
		I.set_buffer(src)
		balloon_alert(user, "保存到多功能缓冲区.")
		return TRUE
