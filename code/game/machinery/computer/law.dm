

/obj/machinery/computer/upload
	var/mob/living/silicon/current = null //The target of future law uploads
	icon_screen = "command"
	time_to_unscrew = 6 SECONDS

/obj/machinery/computer/upload/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_silicon("\A [name] was created at [loc_name(src)].")
		message_admins("\A [name] was created at [ADMIN_VERBOSEJMP(src)].")

/obj/machinery/computer/upload/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/ai_module))
		var/obj/item/ai_module/M = O
		if(machine_stat & (NOPOWER|BROKEN|MAINT))
			return
		if(!current)
			to_chat(user, span_alert("你没有选择任何东西来传递法律!"))
			return
		if(!can_upload_to(current))
			to_chat(user, span_alert("上传失败! 确保[current.name]功能正常."))
			current = null
			return
		if(!is_valid_z_level(get_turf(current), get_turf(user)))
			to_chat(user, span_alert("上传失败! 无法与[current.name]建立连接. 你离得太远了!"))
			current = null
			return
		M.install(current.laws, user)
		imprint_gps(gps_tag = "微弱上传信号")
	else
		return ..()

/obj/machinery/computer/upload/proc/can_upload_to(mob/living/silicon/S)
	if(S.stat == DEAD)
		return FALSE
	return TRUE

/obj/machinery/computer/upload/ai
	name = "\improper AI上传终端"
	desc = "用于上传AI的法律."
	circuit = /obj/item/circuitboard/computer/aiupload

/obj/machinery/computer/upload/ai/Initialize(mapload)
	. = ..()
	if(mapload && HAS_TRAIT(SSstation, STATION_TRAIT_HUMAN_AI))
		return INITIALIZE_HINT_QDEL

/obj/machinery/computer/upload/ai/interact(mob/user)
	current = select_active_ai(user, z, TRUE)

	if (!current)
		to_chat(user, span_alert("未检测到活跃AI!"))
	else
		to_chat(user, span_notice("[current.name]将被改变法律."))

/obj/machinery/computer/upload/ai/can_upload_to(mob/living/silicon/ai/A)
	if(!A || !isAI(A))
		return FALSE
	if(A.control_disabled)
		return FALSE
	return ..()


/obj/machinery/computer/upload/borg
	name = "赛博格上传终端"
	desc = "上传赛博格的法律."
	circuit = /obj/item/circuitboard/computer/borgupload

/obj/machinery/computer/upload/borg/interact(mob/user)
	current = select_active_free_borg(user)

	if(!current)
		to_chat(user, span_alert("未检测到活跃的非奴隶赛博格."))
	else
		to_chat(user, span_notice("[current.name]将被改变法律."))

/obj/machinery/computer/upload/borg/can_upload_to(mob/living/silicon/robot/B)
	if(!B || !iscyborg(B))
		return FALSE
	if(B.scrambledcodes || B.emagged)
		return FALSE
	return ..()
