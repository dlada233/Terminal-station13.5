/obj/item/gun/energy/laser/musket
	name = "激光滑膛枪"
	desc = "这是一种手工制作的激光武器，它的侧面有一个手动曲柄来给它充电."
	icon_state = "musket"
	inhand_icon_state = "musket"
	worn_icon_state = "las_musket"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/musket)
	slot_flags = ITEM_SLOT_BACK
	obj_flags = UNIQUE_RENAME
	can_bayonet = TRUE
	knife_x_offset = 22
	knife_y_offset = 11

/obj/item/gun/energy/laser/musket/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands = TRUE, force_wielded = 10)
	AddComponent( \
		/datum/component/crank_recharge, \
		charging_cell = get_cell(), \
		charge_amount = 500, \
		cooldown_time = 2 SECONDS, \
		charge_sound = 'sound/weapons/laser_crank.ogg', \
		charge_sound_cooldown_time = 1.8 SECONDS, \
	)

/obj/item/gun/energy/laser/musket/update_icon_state()
	inhand_icon_state = "[initial(inhand_icon_state)][(get_charge_ratio() == 4 ? "已充能" : "")]"
	return ..()

/obj/item/gun/energy/laser/musket/prime
	name = "英雄激光滑膛枪"
	desc = "一种精心设计、手动充电的激光武器，它的电容器积满了电压."
	icon_state = "musket_prime"
	inhand_icon_state = "musket_prime"
	worn_icon_state = "las_musket_prime"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/musket/prime)


/obj/item/gun/energy/disabler/smoothbore
	name = "滑膛镇暴枪"
	desc = "一种手工制作的镇暴枪，通过对能量电池的冲压来发射镇暴光束，但缺乏聚焦系统也意味着它没有任何准确性."
	icon_state = "smoothbore"
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/smoothbore)
	shaded_charge = 1
	charge_sections = 1
	spread = 22.5

/obj/item/gun/energy/disabler/smoothbore/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/crank_recharge, \
		charging_cell = get_cell(), \
		charge_amount = 1000, \
		cooldown_time = 2 SECONDS, \
		charge_sound = 'sound/weapons/laser_crank.ogg', \
		charge_sound_cooldown_time = 1.8 SECONDS, \
	)

/obj/item/gun/energy/disabler/smoothbore/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 18, \
		overlay_y = 12, \
	) //i swear 1812 being the overlay numbers was accidental

/obj/item/gun/energy/disabler/smoothbore/prime //much stronger than the other prime variants, so dont just put this in as maint loot
	name = "精英滑膛镇暴枪"
	desc = "滑膛镇暴枪的增强版，改进了光学和电池设计，拥有了良好的精度和二次发射的能力."
	icon_state = "smoothbore_prime"
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/smoothbore/prime)
	charge_sections = 2
	spread = 0 //could be like 5, but having just very tiny spread kinda feels like bullshit
