/obj/item/gun/energy/taser
	name = "taser gun"
	desc = "A low-capacity, energy-based stun gun used by security teams to subdue targets at range."
	icon_state = "taser"
	inhand_icon_state = null //so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/electrode)
	ammo_x_offset = 3

/obj/item/gun/energy/e_gun/advtaser
	name = "hybrid taser"
	desc = "A dual-mode taser designed to fire both short-range high-power electrodes and long-range disabler beams."
	icon_state = "advtaser"
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 2

/obj/item/gun/energy/e_gun/advtaser/cyborg
	name = "cyborg taser"
	desc = "An integrated hybrid taser that draws directly from a cyborg's power cell. The weapon contains a limiter to prevent the cyborg's power cell from overheating."
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/e_gun/advtaser/cyborg/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)

/obj/item/gun/energy/e_gun/advtaser/cyborg/add_seclight_point()
	return

/obj/item/gun/energy/disabler
	name = "镇暴光枪"
	desc = "这是一种自卫武器，持续命中将耗尽有机目标的耐力直至倒地."
	icon_state = "disabler"
	inhand_icon_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 2

/obj/item/gun/energy/disabler/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 10)

/obj/item/gun/energy/disabler/smg
	name = "镇暴冲锋枪"
	desc = "一种镇暴光枪改型，以略微降低光束效能为代价，换来了拥有更高的弹药容量和更快的射速."
	icon_state = "disabler_smg"
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/smg)
	shaded_charge = 1

/obj/item/gun/energy/disabler/smg/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.15 SECONDS, allow_akimbo = FALSE)

/obj/item/gun/energy/disabler/add_seclight_point()
	AddComponent(\
		/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 13, \
	)

/obj/item/gun/energy/disabler/cyborg
	name = "赛博镇暴光枪"
	desc = "用赛博格电池供电的镇暴光枪，上面装有热传感器防止内部电池过热."
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/disabler/cyborg/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)
