/obj/item/pinpointer/nuke
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/mode = TRACK_NUKE_DISK

/obj/item/pinpointer/nuke/examine(mob/user)
	. = ..()
	var/msg = "它的追踪指示器显示 "
	switch(mode)
		if(TRACK_NUKE_DISK)
			msg += "\"nuclear_disk\"."
		if(TRACK_MALF_AI)
			msg += "\"01000001 01001001\"."
		if(TRACK_INFILTRATOR)
			msg += "\"vasvygengbefuvc\"."
		/// SKYRAT EDIT BEGIN
		if(TRACK_GOLDENEYE)
			msg += "\"goldeneye_key\"."
		/// SKYRAT EDIT END
		else
			msg = "追踪指示器一片空白."
	. += msg
	for(var/obj/machinery/nuclearbomb/bomb as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/nuclearbomb))
		if(bomb.timing)
			. += "极度危险. 检测到启动信号. 时间剩余: [bomb.get_time_left()]."

/obj/item/pinpointer/nuke/process(seconds_per_tick)
	..()
	if(!active || alert)
		return
	for(var/obj/machinery/nuclearbomb/bomb as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/nuclearbomb))
		if(!bomb.timing)
			continue
		alert = TRUE
		playsound(src, 'sound/items/nuke_toy_lowpower.ogg', 50, FALSE)
		if(isliving(loc))
			var/mob/living/alerted_holder = loc
			to_chat(alerted_holder, span_userdanger("你的[name]震动并发出不详的警报. 啊哦."))
		return

/obj/item/pinpointer/nuke/scan_for_target()
	target = null
	switch(mode)
		if(TRACK_NUKE_DISK)
			var/obj/item/disk/nuclear/N = locate() in SSpoints_of_interest.real_nuclear_disks
			target = N
		if(TRACK_MALF_AI)
			for(var/V in GLOB.ai_list)
				var/mob/living/silicon/ai/A = V
				if(A.nuking)
					target = A
			for(var/obj/machinery/power/apc/apc as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/power/apc))
				if(apc.malfhack && apc.occupier)
					target = apc
		if(TRACK_INFILTRATOR)
			target = SSshuttle.getShuttle("syndicate")
		// SKYRAT EDIT ADDITION
		if(TRACK_GOLDENEYE)
			target = SSgoldeneye.goldeneye_keys[1] // Track the first goldeneye key in existence.
		// SKYRAT EDIT END
	..()

/obj/item/pinpointer/nuke/proc/switch_mode_to(new_mode)
	if(isliving(loc))
		var/mob/living/L = loc
		to_chat(L, span_userdanger("你的[name]重新配置了追踪算法并嗡嗡作响."))
		playsound(L, 'sound/machines/triple_beep.ogg', 50, TRUE)
	mode = new_mode
	scan_for_target()

/obj/item/pinpointer/nuke/syndicate // Syndicate pinpointers automatically point towards the infiltrator once the nuke is active.
	name = "辛迪加指示器"
	desc = "一种能锁定特定信号的手持式追踪装置，一旦检测到核装置的激活信号，它就会切换到追踪模式."
	icon_state = "pinpointer_syndicate"
	worn_icon_state = "pinpointer_black"

/obj/item/pinpointer/syndicate_cyborg // Cyborg pinpointers just look for a random operative.
	name = "赛博辛迪加指示器"
	desc = "集成在机体内部的追踪装置，用来搜寻活着的辛迪加特工."
	flags_1 = NONE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/pinpointer/syndicate_cyborg/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CYBORG_ITEM_TRAIT)

/obj/item/pinpointer/syndicate_cyborg/cyborg_unequip(mob/user)
	if(!active)
		return
	toggle_on()

/obj/item/pinpointer/syndicate_cyborg/scan_for_target()
	target = null
	var/list/possible_targets = list()
	var/turf/here = get_turf(src)
	for(var/V in get_antag_minds(/datum/antagonist/nukeop))
		var/datum/mind/M = V
		if(ishuman(M.current) && M.current.stat != DEAD)
			possible_targets |= M.current
	var/mob/living/closest_operative = get_closest_atom(/mob/living/carbon/human, possible_targets, here)
	if(closest_operative)
		target = closest_operative
	..()
