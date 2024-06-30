#define WAND_OPEN "open"
#define WAND_BOLT "bolt"
#define WAND_EMERGENCY "emergency"

/obj/item/door_remote
	icon_state = "remote"
	base_icon_state = "remote"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	icon = 'icons/obj/devices/remote.dmi'
	name = "control wand"
	desc = "A remote for controlling a set of airlocks."
	w_class = WEIGHT_CLASS_TINY

	var/department = "civilian"
	var/mode = WAND_OPEN
	var/region_access = REGION_GENERAL
	var/list/access_list

/obj/item/door_remote/Initialize(mapload)
	. = ..()
	access_list = SSid_access.get_region_access_list(list(region_access))
	update_icon_state()

/obj/item/door_remote/attack_self(mob/user)
	var/static/list/desc = list(WAND_OPEN = "开关门", WAND_BOLT = "解锁门", WAND_EMERGENCY = "应急权限")
	switch(mode)
		if(WAND_OPEN)
			mode = WAND_BOLT
		if(WAND_BOLT)
			mode = WAND_EMERGENCY
		if(WAND_EMERGENCY)
			mode = WAND_OPEN
	update_icon_state()
	balloon_alert(user, "mode: [desc[mode]]")

// Airlock remote works by sending NTNet packets to whatever it's pointed at.
/obj/item/door_remote/afterattack(atom/target, mob/user)
	. = ..()

	var/obj/machinery/door/door

	if (istype(target, /obj/machinery/door))
		door = target

		if (!door.opens_with_door_remote)
			return
	else
		for (var/obj/machinery/door/door_on_turf in get_turf(target))
			if (door_on_turf.opens_with_door_remote)
				door = door_on_turf
				break

		if (isnull(door))
			return

	if (!door.check_access_list(access_list) || !door.requiresID())
		target.balloon_alert(user, "无法访问!")
		return

	var/obj/machinery/door/airlock/airlock = door

	if (!door.hasPower() || (istype(airlock) && !airlock.canAIControl()))
		target.balloon_alert(user, mode == WAND_OPEN ? "它没有动！" : "无事发生！")
		return

	switch (mode)
		if (WAND_OPEN)
			if (door.density)
				door.open()
			else
				door.close()
		if (WAND_BOLT)
			if (!istype(airlock))
				target.balloon_alert(user, "气闸门专用!")
				return

			if (airlock.locked)
				airlock.unbolt()
				log_combat(user, airlock, "unbolted", src)
			else
				airlock.bolt()
				log_combat(user, airlock, "bolted", src)
		if (WAND_EMERGENCY)
			if (!istype(airlock))
				target.balloon_alert(user, "气闸门专用!")
				return

			airlock.emergency = !airlock.emergency
			airlock.update_appearance(UPDATE_ICON)

/obj/item/door_remote/update_icon_state()
	var/icon_state_mode
	switch(mode)
		if(WAND_OPEN)
			icon_state_mode = "open"
		if(WAND_BOLT)
			icon_state_mode = "bolt"
		if(WAND_EMERGENCY)
			icon_state_mode = "emergency"

	icon_state = "[base_icon_state]_[department]_[icon_state_mode]"
	return ..()

/obj/item/door_remote/omni
	name = "omni door remote"
	desc = "This control wand can access any door on the station."
	department = "omni"
	region_access = REGION_ALL_STATION

/obj/item/door_remote/captain
	name = "指挥大门遥控器"
	department = "command"
	region_access = REGION_COMMAND

/obj/item/door_remote/chief_engineer
	name = "工程大门遥控器"
	department = "engi"
	region_access = REGION_ENGINEERING

/obj/item/door_remote/research_director
	name = "科研大门遥控器"
	department = "sci"
	region_access = REGION_RESEARCH

/obj/item/door_remote/head_of_security
	name = "安保大门遥控器"
	department = "security"
	region_access = REGION_SECURITY

/obj/item/door_remote/quartermaster
	name = "货仓大门遥控器"
	desc = "远程控制气阀门的遥控器，这个还有金库门的权限."
	department = "cargo"
	region_access = REGION_SUPPLY

/obj/item/door_remote/chief_medical_officer
	name = "医疗大门遥控器"
	department = "med"
	region_access = REGION_MEDBAY

/obj/item/door_remote/civilian
	name = "民用大门遥控器"
	department = "civilian"
	region_access = REGION_GENERAL

#undef WAND_OPEN
#undef WAND_BOLT
#undef WAND_EMERGENCY
