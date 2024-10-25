/obj/item/disk
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	w_class = WEIGHT_CLASS_TINY
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	icon_state = "datadisk0"
	drop_sound = 'sound/items/handling/disk_drop.ogg'
	pickup_sound = 'sound/items/handling/disk_pickup.ogg'

// DAT FUKKEN DISK.
/obj/item/disk/nuclear
	name = "核认证磁盘"
	desc = "最好保管好这个."
	icon_state = "nucleardisk"
	max_integrity = 250
	armor_type = /datum/armor/disk_nuclear
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	/// Whether we're a real nuke disk or not.
	var/fake = FALSE

/datum/armor/disk_nuclear
	bomb = 30
	fire = 100
	acid = 100

/obj/item/disk/nuclear/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bed_tuckable, mapload, 6, -6, 0)
	AddComponent(/datum/component/stationloving, !fake)

	if(!fake)
		AddComponent(/datum/component/keep_me_secure, CALLBACK(src, PROC_REF(secured_process)), CALLBACK(src, PROC_REF(unsecured_process)))
		SSpoints_of_interest.make_point_of_interest(src)
	else
		AddComponent(/datum/component/keep_me_secure)

/obj/item/disk/nuclear/proc/secured_process(last_move)
	var/turf/new_turf = get_turf(src)
	var/datum/round_event_control/operative/loneop = locate(/datum/round_event_control/operative) in SSevents.control
	if(istype(loneop) && loneop.occurrences < loneop.max_occurrences && prob(loneop.weight))
		loneop.weight = max(loneop.weight - 1, 0)
		if(loneop.weight % 5 == 0 && SSticker.totalPlayers > 1)
			message_admins("[src]被保管好了(当前在[ADMIN_VERBOSEJMP(new_turf)]). 当前独狼核特工权重为[loneop.weight].")
		log_game("[src]被保管好了，独狼核特工权重降低至[loneop.weight].")

/obj/item/disk/nuclear/proc/unsecured_process(last_move)
	var/turf/new_turf = get_turf(src)
	/// How comfy is our disk?
	var/disk_comfort_level = 0

	//Go through and check for items that make disk comfy
	for(var/obj/comfort_item in loc)
		if(istype(comfort_item, /obj/item/bedsheet) || istype(comfort_item, /obj/structure/bed))
			disk_comfort_level++

	if(last_move < world.time - 500 SECONDS && prob((world.time - 500 SECONDS - last_move)*0.0001))
		var/datum/round_event_control/operative/loneop = locate(/datum/round_event_control/operative) in SSevents.control
		if(istype(loneop) && loneop.occurrences < loneop.max_occurrences)
			loneop.weight += 1
			if(loneop.weight % 5 == 0 && SSticker.totalPlayers > 1)
				if(disk_comfort_level >= 2)
					visible_message(span_notice("[src]睡得很香. 晚安，小磁盘."))
				message_admins("[src]不再被保管了在[ADMIN_VERBOSEJMP(new_turf)]. 独狼独狼核特工权重为[loneop.weight].")
			log_game("[src]不再被保管了在[loc_name(new_turf)]. 独狼核特工权重增加至[loneop.weight].")

/obj/item/disk/nuclear/examine(mob/user)
	. = ..()
	if(!fake)
		return

	if(isobserver(user) || HAS_MIND_TRAIT(user, TRAIT_DISK_VERIFIER))
		. += span_warning("[src]的序列号不正确.")

/*
 * You can't accidentally eat the nuke disk, bro
 */
/obj/item/disk/nuclear/on_accidental_consumption(mob/living/carbon/M, mob/living/carbon/user, obj/item/source_item, discover_after = TRUE)
	M.visible_message(span_warning("[M]好像咬到了什么重要的东西."), \
						span_warning("等等，这是核磁盘?"))

	return discover_after

/obj/item/disk/nuclear/attackby(obj/item/weapon, mob/living/user, params)
	if(istype(weapon, /obj/item/claymore/highlander) && !fake)
		var/obj/item/claymore/highlander/claymore = weapon
		if(claymore.nuke_disk)
			to_chat(user, span_notice("等等...什么?"))
			qdel(claymore.nuke_disk)
			claymore.nuke_disk = null
			return

		user.visible_message(
			span_warning("[user]夺取了[src]!"),
			span_userdanger("你得到了磁盘!用生命去捍卫它!"),
		)
		forceMove(claymore)
		claymore.nuke_disk = src
		return TRUE

	return ..()

/obj/item/disk/nuclear/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is going delta! 看起来是在尝试自杀!"))
	playsound(src, 'sound/machines/alarm.ogg', 50, -1, TRUE)
	for(var/i in 1 to 100)
		addtimer(CALLBACK(user, TYPE_PROC_REF(/atom, add_atom_colour), (i % 2)? COLOR_VIBRANT_LIME : COLOR_RED, ADMIN_COLOUR_PRIORITY), i)
	addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), 101)
	return MANUAL_SUICIDE

/obj/item/disk/nuclear/proc/manual_suicide(mob/living/user)
	user.remove_atom_colour(ADMIN_COLOUR_PRIORITY)
	user.visible_message(span_suicide("[user]被核爆摧毁了!"))
	user.adjustOxyLoss(200)
	user.death(FALSE)

/obj/item/disk/nuclear/fake
	fake = TRUE

/obj/item/disk/nuclear/fake/obvious
	name = "廉价塑料仿制核认证磁盘"
	desc = "真搞不懂怎么会有人把这当成真的."
