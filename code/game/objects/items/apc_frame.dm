// APC HULL
/obj/item/wallframe/apc
	name = "\improper APC 框架"
	desc = "用于维修或建造APC."
	icon_state = "apc"
	result_path = /obj/machinery/power/apc/auto_name

/obj/item/wallframe/apc/try_build(turf/on_wall, user)
	if(!..())
		return
	var/turf/T = get_turf(on_wall) //the user is not where it needs to be.
	var/area/A = get_area(user)
	if(A.apc)
		to_chat(user, span_warning("这个区域已经有APC了!"))
		return //only one APC per area
	if(!A.requires_power)
		to_chat(user, span_warning("你不能把[src]安装在这个区域!"))
		return //can't place apcs in areas with no power requirement
	for(var/obj/machinery/power/terminal/E in T)
		if(E.master)
			to_chat(user, span_warning("这里已经有另一个电网端口了!"))
			return
		else
			new /obj/item/stack/cable_coil(T, 10)
			to_chat(user, span_notice("你剪断电线并拆下了未使用的电力端口."))
			qdel(E)
	return TRUE

/obj/item/wallframe/apc/screwdriver_act(mob/living/user, obj/item/tool)
	//overriding the wallframe parent screwdriver act with this one which allows applying to existing apc frames.

	var/turf/turf = get_step(get_turf(user), user.dir)
	if(iswallturf(turf))
		if(locate(/obj/machinery/power/apc) in get_turf(user))
			var/obj/machinery/power/apc/mounted_apc = locate(/obj/machinery/power/apc) in get_turf(user)
			mounted_apc.wallframe_act(user, src)
			return ITEM_INTERACT_SUCCESS
		turf.attackby(src, user)
	return ITEM_INTERACT_SUCCESS
