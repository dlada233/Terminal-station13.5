//Bureaucracy machine!
//Simply set this up in the hopline and you can serve people based on ticket numbers

/obj/machinery/ticket_machine
	name = "取票机"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "ticketmachine"
	base_icon_state = "ticketmachine"
	desc = "这是一个行政工程的杰作，被包裹在一个高效的塑料外壳中，它可以使用手动标签机的替换卷进行补充，并通过多用途工具与按钮进行连接."
	density = FALSE
	maptext_height = 26
	maptext_width = 32
	maptext_x = 7
	maptext_y = 10
	layer = HIGH_OBJ_LAYER
	///Increment the ticket number whenever the HOP presses his button
	var/ticket_number = 0
	///What ticket number are we currently serving?
	var/current_number = 0
	///At this point, you need to refill it.
	var/max_number = 100
	var/cooldown = 5 SECONDS
	var/ready = TRUE
	var/id = "ticket_machine_default" //For buttons
	var/list/ticket_holders = list()
	///List of tickets that exist currently
	var/list/obj/item/ticket_machine_ticket/tickets = list()
	///Current ticket to be served, essentially the head of the tickets queue
	var/obj/item/ticket_machine_ticket/current_ticket

/obj/machinery/ticket_machine/Initialize(mapload)
	. = ..()
	update_appearance()
	find_and_hang_on_wall()

/obj/machinery/ticket_machine/Destroy()
	for(var/obj/item/ticket_machine_ticket/ticket in tickets)
		ticket.source = null
	tickets.Cut()
	return ..()

/obj/machinery/ticket_machine/on_deconstruction(disassembled = TRUE)
	new /obj/item/wallframe/ticket_machine(loc)

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/ticket_machine, 32)

/obj/machinery/ticket_machine/examine(mob/user)
	. = ..()
	. += span_notice("The ticket machine shows that ticket #[current_number] is currently being served.")
	. += span_notice("You can take a ticket out with <b>Left-Click</b> to be number [ticket_number + 1] in queue.")

/obj/machinery/ticket_machine/multitool_act(mob/living/user, obj/item/I)
	if(!multitool_check_buffer(user, I)) //make sure it has a data buffer
		return
	var/obj/item/multitool/M = I
	M.set_buffer(src)
	balloon_alert(user, "已保存到多功能工具缓冲区")
	return TRUE

/obj/machinery/ticket_machine/emag_act(mob/user, obj/item/card/emag/emag_card) //Emag the ticket machine to dispense burning tickets, as well as randomize its number to destroy the HoP's mind.
	if(obj_flags & EMAGGED)
		return FALSE
	balloon_alert(user, "bureaucratic nightmare engaged")
	ticket_number = rand(0,max_number)
	current_number = ticket_number
	obj_flags |= EMAGGED
	if(tickets.len)
		for(var/obj/item/ticket_machine_ticket/ticket in tickets)
			ticket.audible_message(span_notice("\the [ticket] disperses!"), hearing_distance = SAMETILE_MESSAGE_RANGE)
			qdel(ticket)
		tickets.Cut()
	update_appearance()
	return TRUE

/obj/item/wallframe/ticket_machine
	name = "取票机框架"
	desc = "一台未安装的取票机，安装在墙上即可使用."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "ticketmachine_off"
	result_path = /obj/machinery/ticket_machine
	pixel_shift = 32

///Increments the counter by one, if there is a ticket after the current one we are serving.
///If we have a current ticket, remove it from the top of our tickets list and replace it with the next one if applicable
/obj/machinery/ticket_machine/proc/increment()
	if(!(obj_flags & EMAGGED) && current_ticket)
		current_ticket.audible_message(span_notice("\the [current_ticket] disperses!"), hearing_distance = SAMETILE_MESSAGE_RANGE)
		tickets.Cut(1,2)
		QDEL_NULL(current_ticket)
	if(LAZYLEN(tickets))
		current_ticket = tickets[1]
		current_number++ //Increment the one we're serving.
		playsound(src, 'sound/misc/announce_dig.ogg', 50, FALSE)
		say("Now serving [current_ticket]!")
		if(!(obj_flags & EMAGGED))
			current_ticket.audible_message(span_notice("\the [current_ticket] vibrates!"), hearing_distance = SAMETILE_MESSAGE_RANGE)
		update_appearance() //Update our icon here rather than when they take a ticket to show the current ticket number being served

/obj/machinery/button/ticket_machine
	name = "推进票列"
	desc = "在办理服务完成后，请按此按钮通知下一位持票人上前."
	device_type = /obj/item/assembly/control/ticket_machine
	req_access = list()
	id = "ticket_machine_default"

/obj/machinery/button/ticket_machine/Initialize(mapload)
	. = ..()
	if(device)
		var/obj/item/assembly/control/ticket_machine/ours = device
		ours.id = id

/obj/machinery/button/ticket_machine/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(I.tool_behaviour == TOOL_MULTITOOL)
		var/obj/item/multitool/M = I
		if(M.buffer && !istype(M.buffer, /obj/machinery/ticket_machine))
			return
		var/obj/item/assembly/control/ticket_machine/controller = device
		controller.ticket_machine_ref = WEAKREF(M.buffer)
		id = null
		controller.id = null
		to_chat(user, span_warning("You've linked [src] to [M.buffer]."))

/obj/item/assembly/control/ticket_machine
	name = "取票机控制"
	desc = "远程控制HoP的取票机."
	///Weakref to our ticket machine
	var/datum/weakref/ticket_machine_ref

/obj/item/assembly/control/ticket_machine/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/assembly/control/ticket_machine/LateInitialize()
	find_machine()

/// Locate the ticket machine to which we're linked by our ID
/obj/item/assembly/control/ticket_machine/proc/find_machine()
	for(var/obj/machinery/ticket_machine/ticketsplease as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/ticket_machine))
		if(ticketsplease.id == id)
			ticket_machine_ref = WEAKREF(ticketsplease)
	if(ticket_machine_ref)
		return TRUE
	else
		return FALSE

/obj/item/assembly/control/ticket_machine/activate(mob/activator)
	if(cooldown)
		return
	if(!ticket_machine_ref)
		return
	var/obj/machinery/ticket_machine/machine = ticket_machine_ref.resolve()
	if(!machine)
		return
	cooldown = TRUE
	machine.increment()
	if(isnull(machine.current_ticket))
		to_chat(activator, span_notice("The button light indicates that there are no more tickets to be processed."))
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 1 SECONDS)

/obj/machinery/ticket_machine/update_icon()
	. = ..()
	handle_maptext()

/obj/machinery/ticket_machine/update_icon_state()
	switch(ticket_number) //Gives you an idea of how many tickets are left
		if(0 to 99)
			icon_state = "[base_icon_state]"
		if(100)
			icon_state = "[base_icon_state]_empty"
	return ..()

/obj/machinery/ticket_machine/proc/handle_maptext()
	switch(current_number) //This is here to handle maptext offsets so that the numbers align.
		if(0 to 9)
			maptext_x = 9
		if(10 to 99)
			maptext_x = 6
		if(100)
			maptext_x = 4
	maptext = MAPTEXT(current_number) //Finally, apply the maptext

/obj/machinery/ticket_machine/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/hand_labeler_refill))
		if(!(ticket_number >= max_number))
			to_chat(user, span_notice("[src] refuses [I]! There [max_number - ticket_number == 1 ? "is" : "are"] still [max_number - ticket_number] ticket\s left!"))
			return
		to_chat(user, span_notice("You start to refill [src]'s ticket holder (doing this will reset its ticket count!)."))
		if(do_after(user, 3 SECONDS, target = src))
			to_chat(user, span_notice("You insert [I] into [src] as it whirs nondescriptly."))
			qdel(I)
			ticket_number = 0
			current_number = 0
			if(tickets.len)
				for(var/obj/item/ticket_machine_ticket/ticket in tickets)
					ticket.audible_message(span_notice("\the [ticket] disperses!"), hearing_distance = SAMETILE_MESSAGE_RANGE)
					qdel(ticket)
				tickets.Cut()
			max_number = initial(max_number)
			update_appearance()
			return

/obj/machinery/ticket_machine/proc/reset_cooldown()
	ready = TRUE

/obj/machinery/ticket_machine/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	if(!ready)
		to_chat(user,span_warning("You press the button, but nothing happens..."))
		return
	if(ticket_number >= max_number)
		to_chat(user,span_warning("Ticket supply depleted, please refill this unit with a hand labeller refill cartridge!"))
		return
	var/user_ref = REF(user)
	if((user_ref in ticket_holders) && !(obj_flags & EMAGGED))
		to_chat(user, span_warning("You already have a ticket!"))
		return
	playsound(src, 'sound/machines/terminal_insert_disc.ogg', 100, FALSE)
	ticket_number++
	to_chat(user, span_notice("You take a ticket from [src], looks like you're number [ticket_number] in queue..."))
	var/obj/item/ticket_machine_ticket/theirticket = new (get_turf(src), ticket_number)
	theirticket.source = src
	theirticket.owner_ref = user_ref
	user.put_in_hands(theirticket)
	ticket_holders += user_ref
	tickets += theirticket
	if(obj_flags & EMAGGED) //Emag the machine to destroy the HOP's life.
		ready = FALSE
		addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), cooldown)//Small cooldown to prevent piles of flaming tickets
		theirticket.fire_act()
		user.dropItemToGround(theirticket)
		user.adjust_fire_stacks(1)
		user.ignite_mob()
	update_appearance()

/obj/item/ticket_machine_ticket
	name = "票"
	desc = "一张显示您在人事部门队列中的位置的票据，由纳米传讯专利的NanoPaper®制成，尽管质地坚固，但其外观似乎略有闪烁，感觉与真纸无异（包括燃烧效果）."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "ticket"
	maptext_x = 7
	maptext_y = 10
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_integrity = 50
	var/number
	var/saved_maptext = null
	var/owner_ref // A ref to our owner. Doesn't need to be weak because mobs have unique refs
	var/obj/machinery/ticket_machine/source

/obj/item/ticket_machine_ticket/Initialize(mapload, num)
	. = ..()
	number = num
	if(!isnull(num))
		name += " #[num]"
		saved_maptext = MAPTEXT(num)
		maptext = saved_maptext

/obj/item/ticket_machine_ticket/examine(mob/user)
	. = ..()
	if(!isnull(number))
		. += span_notice("The ticket reads shimmering text that tells you that you are number [number] in queue.")
		if(source)
			. += span_notice("Below that, you can see that you are [number - source.current_number] spot\s away from being served.")

/obj/item/ticket_machine_ticket/attack_hand(mob/user, list/modifiers)
	. = ..()
	maptext = saved_maptext //For some reason, storage code removes all maptext off objs, this stops its number from being wiped off when taken out of storage.

/obj/item/ticket_machine_ticket/attackby(obj/item/P, mob/living/carbon/human/user, params) //Stolen from papercode
	if(burn_paper_product_attackby_check(P, user))
		return

	return ..()

/obj/item/ticket_machine_ticket/Destroy()
	if(source)
		source.ticket_holders -= owner_ref
		source.tickets -= src
		if(source.current_ticket == src)
			source.current_ticket = null
		source = null
	return ..()
