/obj/machinery/abductor/gland_dispenser
	name = "移植器官储存库"
	desc = "一个装满了器官的储存库."
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "dispenser"
	density = TRUE
	var/list/gland_types
	var/list/gland_colors
	var/list/amounts

/obj/machinery/abductor/gland_dispenser/proc/random_color()
	//TODO : replace with presets or spectrum
	return rgb(rand(0,255),rand(0,255),rand(0,255))

/obj/machinery/abductor/gland_dispenser/Initialize(mapload)
	. = ..()
	gland_types = subtypesof(/obj/item/organ/internal/heart/gland)
	gland_types = shuffle(gland_types)
	gland_colors = new/list(gland_types.len)
	amounts = new/list(gland_types.len)
	for(var/i in 1 to gland_types.len)
		gland_colors[i] = random_color()
		amounts[i] = rand(1,5)

/obj/machinery/abductor/gland_dispenser/ui_status(mob/user, datum/ui_state/state)
	if(!isabductor(user) && !isobserver(user))
		return UI_CLOSE
	return ..()

/obj/machinery/abductor/gland_dispenser/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/abductor/gland_dispenser/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GlandDispenser", name)
		ui.open()

/obj/machinery/abductor/gland_dispenser/ui_data(mob/user)
	var/list/data = list()
	data["glands"] = list()
	for(var/gland_number in 1 to gland_colors.len)
		var/list/gland_information = list(
			"color" = gland_colors[gland_number],
			"amount" = amounts[gland_number],
			"id" = gland_number,
		)
		data["glands"] += list(gland_information)
	return data

/obj/machinery/abductor/gland_dispenser/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("dispense")
			var/gland_id = text2num(params["gland_id"])
			if(!gland_id)
				return
			Dispense(gland_id)
			return TRUE

/obj/machinery/abductor/gland_dispenser/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/organ/internal/heart/gland))
		if(!user.transferItemToLoc(W, src))
			return
		for(var/i in 1 to gland_colors.len)
			if(gland_types[i] == W.type)
				amounts[i]++
	else
		return ..()

/obj/machinery/abductor/gland_dispenser/proc/Dispense(count)
	if(amounts[count]>0)
		amounts[count]--
		var/T = gland_types[count]
		new T(get_turf(src))
