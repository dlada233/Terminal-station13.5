

//The ammo/gun is stored in a back slot item
/obj/item/minigunpack
	name = "电源背包"
	desc = "供能量加特林枪使用的巨大外部电源背包."
	icon = 'icons/obj/weapons/guns/minigun.dmi'
	icon_state = "holstered"
	inhand_icon_state = "backpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE

	var/obj/item/gun/energy/minigun/gun
	var/obj/item/stock_parts/cell/minigun/battery
	var/armed = FALSE //whether the gun is attached, FALSE is attached, TRUE is the gun is wielded.
	var/overheat = 0
	var/overheat_max = 40
	var/heat_diffusion = 0.5

/obj/item/minigunpack/Initialize(mapload)
	. = ..()
	gun = new(src)
	battery = new(src)
	START_PROCESSING(SSobj, src)

/obj/item/minigunpack/Destroy()
	if(!QDELETED(gun))
		qdel(gun)
	gun = null
	QDEL_NULL(battery)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/minigunpack/process(seconds_per_tick)
	overheat = max(0, overheat - heat_diffusion * seconds_per_tick)

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/minigunpack/attack_hand(mob/living/carbon/user, list/modifiers)
	if(src.loc == user)
		if(!armed)
			if(user.get_item_by_slot(ITEM_SLOT_BACK) == src)
				armed = TRUE
				if(!user.put_in_hands(gun))
					armed = FALSE
					to_chat(user, span_warning("你需要空着手来拿枪!"))
					return
				update_appearance()
				user.update_worn_back()
		else
			to_chat(user, span_warning("你已经拿着枪了!"))
	else
		..()

/obj/item/minigunpack/attackby(obj/item/W, mob/user, params)
	if(W == gun) //Don't need armed check, because if you have the gun assume its armed.
		user.dropItemToGround(gun, TRUE)
	else
		..()

/obj/item/minigunpack/dropped(mob/user)
	. = ..()
	if(armed)
		user.dropItemToGround(gun, TRUE)

/obj/item/minigunpack/mouse_drop_dragged(atom/over_object, mob/user)
	if(armed)
		return

	if(iscarbon(user))
		if(istype(over_object, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over_object
			user.putItemFromInventoryInHandIfPossible(src, H.held_index)

/obj/item/minigunpack/update_icon_state()
	icon_state = armed ? "notholstered" : "holstered"
	return ..()

/obj/item/minigunpack/proc/attach_gun(mob/user)
	if(!gun)
		gun = new(src)
	gun.forceMove(src)
	armed = FALSE
	if(user)
		to_chat(user, span_notice("你连接[gun.name]到[name]."))
	else
		src.visible_message(span_warning("[gun.name]弹回到[name]!"))
	update_appearance()
	user.update_worn_back()


/obj/item/gun/energy/minigun
	name = "能量加特林机枪"
	desc = "先进的能量炮，射速惊人，但需要一个笨重的电源背包供电."
	icon = 'icons/obj/weapons/guns/minigun.dmi'
	icon_state = "minigun_spin"
	inhand_icon_state = "minigun"
	slowdown = 1
	slot_flags = null
	w_class = WEIGHT_CLASS_HUGE
	custom_materials = null
	weapon_weight = WEAPON_HEAVY
	ammo_type = list(/obj/item/ammo_casing/energy/laser/minigun)
	cell_type = /obj/item/stock_parts/cell/crap
	item_flags = NEEDS_PERMIT | SLOWS_WHILE_IN_HAND
	can_charge = FALSE
	var/obj/item/minigunpack/ammo_pack

/obj/item/gun/energy/minigun/Initialize(mapload)
	if(!istype(loc, /obj/item/minigunpack)) //We should spawn inside an ammo pack so let's use that one.
		return INITIALIZE_HINT_QDEL //No pack, no gun
	ammo_pack = loc
	AddElement(/datum/element/update_icon_blocker)
	AddComponent(/datum/component/automatic_fire, 0.2 SECONDS)
	return ..()

/obj/item/gun/energy/minigun/Destroy()
	if(!QDELETED(ammo_pack))
		qdel(ammo_pack)
	ammo_pack = null
	return ..()

/obj/item/gun/energy/minigun/attack_self(mob/living/user)
	return

/obj/item/gun/energy/minigun/dropped(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	if(ammo_pack)
		ammo_pack.attach_gun(user)
	else
		qdel(src)

/obj/item/gun/energy/minigun/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(ammo_pack && ammo_pack.overheat >= ammo_pack.overheat_max)
		to_chat(user, span_warning("透镜过热，热传感器锁定了扳机!"))
		return
	..()
	ammo_pack.overheat++
	if(ammo_pack.battery)
		var/transferred = ammo_pack.battery.use(cell.maxcharge - cell.charge, force = TRUE)
		cell.give(transferred)


/obj/item/gun/energy/minigun/try_fire_gun(atom/target, mob/living/user, params)
	if(!ammo_pack || ammo_pack.loc != user)
		to_chat(user, span_warning("你需要电源背包来开火!"))
		return FALSE
	return ..()

/obj/item/stock_parts/cell/minigun
	name = "加特林机枪聚变核心"
	desc = "你从哪弄来的?"
	maxcharge = 500 * STANDARD_CELL_CHARGE
	chargerate = 5 * STANDARD_CELL_CHARGE
