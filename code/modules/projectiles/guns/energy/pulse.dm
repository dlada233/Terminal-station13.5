/obj/item/gun/energy/pulse
	name = "脉冲步枪"
	desc = "一个重型的、有三种模式的能量步枪，前线作战人员的首选."
	icon_state = "pulse"
	inhand_icon_state = null
	worn_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	modifystate = TRUE
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse, /obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
	cell_type = /obj/item/stock_parts/cell/pulse

/obj/item/gun/energy/pulse/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)

/obj/item/gun/energy/pulse/prize
	pin = /obj/item/firing_pin

/obj/item/gun/energy/pulse/prize/Initialize(mapload)
	. = ..()
	SSpoints_of_interest.make_point_of_interest(src)
	var/turf/T = get_turf(src)

	message_admins("A pulse rifle prize has been created at [ADMIN_VERBOSEJMP(T)]")
	log_game("A pulse rifle prize has been created at [AREACOORD(T)]")

	notify_ghosts(
		"有人赢得了一把脉冲步枪作为奖励!",
		source = src,
		header = "脉冲步枪奖",
	)

/obj/item/gun/energy/pulse/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/energy/pulse/carbine
	name = "脉冲卡宾枪"
	desc = "脉冲步枪的紧凑型，火力更少，但更易携带."
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_BULKY
	icon_state = "pulse_carbine"
	worn_icon_state = "gun"
	inhand_icon_state = null
	cell_type = /obj/item/stock_parts/cell/pulse/carbine

/obj/item/gun/energy/pulse/carbine/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 18, \
		overlay_y = 12)

/obj/item/gun/energy/pulse/carbine/lethal
	ammo_type = list(/obj/item/ammo_casing/energy/laser, /obj/item/ammo_casing/energy/laser/pulse, /obj/item/ammo_casing/energy/electrode)

/obj/item/gun/energy/pulse/carbine/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/energy/pulse/destroyer
	name = "脉冲毁灭者"
	desc = "一种为纯粹的毁灭而制造的重型能量步枪."
	worn_icon_state = "pulse"
	cell_type = /obj/item/stock_parts/cell/infinite
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse)

/obj/item/gun/energy/pulse/destroyer/attack_self(mob/living/user)
	to_chat(user, span_danger("[src.name]有三种模式，它们全都叫毁灭模式！"))

/obj/item/gun/energy/pulse/pistol
	name = "脉冲手枪"
	desc = "低容量的脉冲手枪."
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	icon_state = "pulse_pistol"
	worn_icon_state = "gun"
	inhand_icon_state = "gun"
	cell_type = /obj/item/stock_parts/cell/pulse/pistol

/obj/item/gun/energy/pulse/pistol/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/energy/pulse/pistol/m1911
	name = "M1911-P"
	desc = "微型的脉冲核心装在经典的手枪外壳中，一般供纳米官员使用，关键不在于枪的大小，而在于它能把人穿出多大的洞."
	icon_state = "m1911"
	inhand_icon_state = "gun"
	cell_type = /obj/item/stock_parts/cell/infinite
