/obj/machinery/plate_press
	name = "车牌打印机"
	desc = "你知道的，你在为一个没有车的地方打印车牌."
	icon = 'icons/obj/machines/prison.dmi'
	icon_state = "offline"
	use_power = IDLE_POWER_USE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.02
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.05
	var/obj/item/stack/license_plates/empty/current_plate
	var/pressing = FALSE

/obj/machinery/plate_press/update_icon_state()
	if(!is_operational)
		icon_state = "offline"
		return ..()
	if(pressing)
		icon_state = "loop"
		return ..()
	if(current_plate)
		icon_state = "online_loaded"
		return ..()
	icon_state = "online"
	return ..()

/obj/machinery/plate_press/Destroy()
	QDEL_NULL(current_plate)
	. = ..()

/obj/machinery/plate_press/attackby(obj/item/I, mob/living/user, params)
	if(!is_operational)
		to_chat(user, span_warning("[src]必须打开才能做!"))
		return FALSE
	if(current_plate)
		to_chat(user, span_warning("[src]里面已经有一块空车牌了!"))
		return FALSE
	if(istype(I, /obj/item/stack/license_plates/empty))
		var/obj/item/stack/license_plates/empty/plate = I
		plate.use(1)
		current_plate = new plate.type(src, 1) //Spawn a new single sheet in the machine
		update_appearance()
	else
		return ..()

/obj/machinery/plate_press/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!pressing && current_plate)
		work_press(user)

///This proc attempts to create a plate. User cannot move during this process.
/obj/machinery/plate_press/proc/work_press(mob/living/user)

	pressing = TRUE
	update_appearance()
	to_chat(user, span_notice("你开始打印新的车牌!"))

	if(!do_after(user, 4 SECONDS, target = src))
		pressing = FALSE
		update_appearance()
		return FALSE

	use_energy(active_power_usage)
	to_chat(user, span_notice("你打印完了一张新车牌!"))

	pressing = FALSE
	QDEL_NULL(current_plate)
	update_appearance()

	new /obj/item/stack/license_plates/filled(drop_location(), 1)
