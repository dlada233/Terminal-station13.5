//Recharge subtype - used by stuff like protokinetic accelerators and ebows, one shot at a time, recharges.
/obj/item/gun/energy/recharge
	icon_state = "kineticgun"
	base_icon_state = "kineticgun"
	desc = "自动充电的枪，一次只能容纳一发."
	automatic_charge_overlays = FALSE
	cell_type = /obj/item/stock_parts/cell/emproof
	/// If set to something, instead of an overlay, sets the icon_state directly.
	var/no_charge_state
	/// Does it hold charge when not put away?
	var/holds_charge = FALSE
	/// How much time we need to recharge
	var/recharge_time = 1.6 SECONDS
	/// Sound we use when recharged
	var/recharge_sound = 'sound/weapons/kinetic_reload.ogg'
	/// An ID for our recharging timer.
	var/recharge_timerid
	/// Do we recharge slower with more of our type?
	var/unique_frequency = FALSE

/obj/item/gun/energy/recharge/apply_fantasy_bonuses(bonus)
	. = ..()
	recharge_time = modify_fantasy_variable("recharge_time", recharge_time, -bonus, minimum = 0.2 SECONDS)

/obj/item/gun/energy/recharge/remove_fantasy_bonuses(bonus)
	recharge_time = reset_fantasy_variable("recharge_time", recharge_time)
	return ..()

/obj/item/gun/energy/recharge/Initialize(mapload)
	. = ..()
	if(!holds_charge)
		empty()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)

/obj/item/gun/energy/recharge/shoot_live_shot(mob/living/user, pointblank = 0, atom/pbtarget = null, message = 1)
	. = ..()
	attempt_reload()

/obj/item/gun/energy/recharge/equipped(mob/user)
	. = ..()
	if(!can_shoot())
		attempt_reload()

/obj/item/gun/energy/recharge/dropped()
	. = ..()
	if(!QDELING(src) && !holds_charge)
		// Put it on a delay because moving item from slot to hand
		// calls dropped().
		addtimer(CALLBACK(src, PROC_REF(empty_if_not_held)), 0.1 SECONDS)

/obj/item/gun/energy/recharge/handle_chamber()
	. = ..()
	attempt_reload()

/obj/item/gun/energy/recharge/proc/empty_if_not_held()
	if(!ismob(loc))
		empty()
		deltimer(recharge_timerid)

/obj/item/gun/energy/recharge/proc/empty()
	if(cell)
		cell.use(cell.charge)
	update_appearance()

/obj/item/gun/energy/recharge/proc/attempt_reload(set_recharge_time)
	if(!cell)
		return
	if(cell.charge == cell.maxcharge)
		return
	if(!set_recharge_time)
		set_recharge_time = recharge_time
	var/carried = 0
	if(!unique_frequency)
		for(var/obj/item/gun/energy/recharge/recharging_gun in loc.get_all_contents())
			if(recharging_gun.type != type || recharging_gun.unique_frequency)
				continue
			carried++
	carried = max(carried, 1)
	deltimer(recharge_timerid)
	recharge_timerid = addtimer(CALLBACK(src, PROC_REF(reload)), set_recharge_time * carried, TIMER_STOPPABLE)

/obj/item/gun/energy/recharge/proc/reload()
	cell.give(cell.maxcharge)
	if(!suppressed && recharge_sound)
		playsound(src.loc, recharge_sound, 60, TRUE)
	else
		to_chat(loc, span_warning("[src]默默地充电."))
	update_appearance()

/obj/item/gun/energy/recharge/update_overlays()
	. = ..()
	if(!no_charge_state && !can_shoot())
		. += "[base_icon_state]_empty"

/obj/item/gun/energy/recharge/update_icon_state()
	. = ..()
	if(no_charge_state && !can_shoot())
		icon_state = no_charge_state

/obj/item/gun/energy/recharge/ebow
	name = "迷你能量弩"
	desc = "这是辛迪加潜行专家喜欢的武器."
	icon_state = "crossbow"
	base_icon_state = "crossbow"
	inhand_icon_state = "crossbow"
	no_charge_state = "crossbow_empty"
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)
	suppressed = TRUE
	ammo_type = list(/obj/item/ammo_casing/energy/bolt)
	recharge_time = 2 SECONDS
	holds_charge = TRUE
	unique_frequency = TRUE
	can_bayonet = TRUE
	knife_x_offset = 20
	knife_y_offset = 12

/obj/item/gun/energy/recharge/ebow/halloween
	name = "玉米糖弩"
	desc = "辛迪加玩不给糖就捣蛋的人喜欢的武器."
	icon_state = "crossbow_halloween"
	base_icon_state = "crossbow_halloween"
	no_charge_state = "crossbow_halloween_empty"
	ammo_type = list(/obj/item/ammo_casing/energy/bolt/halloween)

/obj/item/gun/energy/recharge/ebow/large
	name = "能量弩"
	desc = "使用辛迪加技术的逆向工程武器."
	icon_state = "crossbowlarge"
	base_icon_state = "crossbowlarge"
	no_charge_state = "crossbowlarge_empty"
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2)
	suppressed = null
	ammo_type = list(/obj/item/ammo_casing/energy/bolt/large)

/// A silly gun that does literally zero damage, but disrupts electrical sources of light, like flashlights.
/obj/item/gun/energy/recharge/fisher
	name = "SC/FISHER 干扰者"
	desc = "一个自充电的，经过非常随意的改造后的动能加速器手枪，除了瘫痪灯具和摄像头，它什么都做不了. \
	每两次射击进行一次充能，在精准射击的情况下可以穿透机械."
	icon_state = "fisher"
	base_icon_state = "fisher"
	dry_fire_sound_volume = 10
	w_class = WEIGHT_CLASS_SMALL
	holds_charge = TRUE
	suppressed = TRUE
	recharge_time = 1.2 SECONDS
	ammo_type = list(/obj/item/ammo_casing/energy/fisher)

/obj/item/gun/energy/recharge/fisher/examine_more(mob/user)
	. = ..()
	. += span_notice("SC/FISHER 是一种非法改装的动能加速器，被锯短并改装成了一个小型能量枪壳，原本的压力室被削弱，发射出的动能爆破只能<b>暂时瘫痪灯具和摄像头</b>. \
	该效果同样对<b>赛博格头灯<b>有用, 并在近距离时持续效果更长.<br><br>\
	虽然有些人觉得这是很糟糕的设计，但有些人显然能从破坏照明资源中获得快乐，望购者自慎.")

/obj/item/gun/energy/recharge/fisher/attack(mob/living/target_mob, mob/living/user, params)
	. = ..()
	if(.)
		return
	var/obj/projectile/energy/fisher/melee/simulated_hit = new
	simulated_hit.firer = user
	simulated_hit.on_hit(target_mob)

/obj/item/gun/energy/recharge/fisher/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	// ...you reeeeeally just shoot them, but in case you can't/won't
	. = ..()
	var/obj/projectile/energy/fisher/melee/simulated_hit = new
	simulated_hit.firer = throwingdatum.get_thrower()
	simulated_hit.on_hit(hit_atom)
