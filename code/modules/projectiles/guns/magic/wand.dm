/obj/item/gun/magic/wand
	name = "wand"
	desc = "You shouldn't have this."
	ammo_type = /obj/item/ammo_casing/magic
	icon_state = "nothingwand"
	inhand_icon_state = "wand"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	base_icon_state = "nothingwand"
	w_class = WEIGHT_CLASS_SMALL
	can_charge = FALSE
	max_charges = 100 //100, 50, 50, 34 (max charge distribution by 25%ths)
	var/variable_charges = TRUE

/obj/item/gun/magic/wand/Initialize(mapload)
	if(prob(75) && variable_charges) //25% chance of listed max charges, 50% chance of 1/2 max charges, 25% chance of 1/3 max charges
		if(prob(33))
			max_charges = CEILING(max_charges / 3, 1)
		else
			max_charges = CEILING(max_charges / 2, 1)
	return ..()

/obj/item/gun/magic/wand/examine(mob/user)
	. = ..()
	. += "拥有[charges]次充能."

/obj/item/gun/magic/wand/update_icon_state()
	icon_state = "[base_icon_state][charges ? null : "-drained"]"
	return ..()

/obj/item/gun/magic/wand/attack(atom/target, mob/living/user)
	if(target == user)
		return
	..()

/obj/item/gun/magic/wand/afterattack(atom/target, mob/living/user)
	. |= AFTERATTACK_PROCESSED_ITEM
	if(!charges)
		shoot_with_empty_chamber(user)
		return
	if(target == user)
		if(no_den_usage)
			var/area/A = get_area(user)
			if(istype(A, /area/centcom/wizard_station))
				to_chat(user, span_warning("你知道不能破坏据点的安全，最好等到离开后再使用[src]."))
				return
			else
				no_den_usage = 0
		zap_self(user)
	else
		. |= ..()
	update_appearance()


/obj/item/gun/magic/wand/proc/zap_self(mob/living/user)
	user.visible_message(span_danger("[user]用[src]攻击自己."))
	playsound(user, fire_sound, 50, TRUE)
	user.log_message("zapped [user.p_them()]self with a <b>[src]</b>", LOG_ATTACK)


/////////////////////////////////////
//WAND OF DEATH
/////////////////////////////////////

/obj/item/gun/magic/wand/death
	name = "死亡魔杖"
	desc = "这支致命的魔杖用纯净的能量淹没受害者的身体，万无一失地杀死他们."
	school = SCHOOL_NECROMANCY
	fire_sound = 'sound/magic/wandodeath.ogg'
	ammo_type = /obj/item/ammo_casing/magic/death
	icon_state = "deathwand"
	base_icon_state = "deathwand"
	max_charges = 3 //3, 2, 2, 1

/obj/item/gun/magic/wand/death/zap_self(mob/living/user)
	..()
	charges--
	if(user.can_block_magic())
		user.visible_message(span_warning("[src]对[user]没有效果!"))
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.mob_biotypes & MOB_UNDEAD) //negative energy heals the undead
			user.revive(ADMIN_HEAL_ALL, force_grab_ghost = TRUE) // This heals suicides
			to_chat(user, span_notice("你感觉很好!"))
			return
	to_chat(user, "<span class='warning'>你用纯粹的负能量照射自己! \
	[pick("不要走，不要去收集200魔域点.","你感觉你更擅长施法了.","你死了...","你想要确认自己的所有吗?")]\
	</span>")
	user.death(FALSE)

/obj/item/gun/magic/wand/death/debug
	desc = "在一些不知名的圈子里，这被称为“克隆测试者之友”."
	max_charges = 500
	variable_charges = FALSE
	can_charge = TRUE
	recharge_rate = 1


/////////////////////////////////////
//WAND OF HEALING
/////////////////////////////////////

/obj/item/gun/magic/wand/resurrection
	name = "治愈魔杖"
	desc = "这根魔杖使用治疗魔法来治疗和复活，由于某些原因，它们很少在巫师联合会中使用."
	school = SCHOOL_RESTORATION
	ammo_type = /obj/item/ammo_casing/magic/heal
	fire_sound = 'sound/magic/staff_healing.ogg'
	icon_state = "revivewand"
	base_icon_state = "revivewand"
	max_charges = 10 //10, 5, 5, 4

/obj/item/gun/magic/wand/resurrection/zap_self(mob/living/user)
	..()
	charges--
	if(user.can_block_magic())
		user.visible_message(span_warning("[src]对[user]没有效果!"))
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			to_chat(user, "<span class='warning'>你纯粹的正面能量照射自己! \
			[pick("不要走，不要去收集200魔域点.","你感觉你更擅长施法了.","你死了...","你想要确认自己的所有吗?")]\
			</span>")
			user.investigate_log("has been killed by a bolt of resurrection.", INVESTIGATE_DEATHS)
			user.death(FALSE)
			return
	user.revive(ADMIN_HEAL_ALL, force_grab_ghost = TRUE) // This heals suicides
	to_chat(user, span_notice("你感觉很好!"))

/obj/item/gun/magic/wand/resurrection/debug //for testing
	desc = "还有比普通魔法更强大的东西吗?这根魔杖就是."
	max_charges = 500
	variable_charges = FALSE
	can_charge = TRUE
	recharge_rate = 1

/////////////////////////////////////
//WAND OF POLYMORPH
/////////////////////////////////////

/obj/item/gun/magic/wand/polymorph
	name = "变形魔杖"
	desc = "这根魔杖与混沌相协调，将彻底改变目标的形态."
	school = SCHOOL_TRANSMUTATION
	ammo_type = /obj/item/ammo_casing/magic/change
	icon_state = "polywand"
	base_icon_state = "polywand"
	fire_sound = 'sound/magic/staff_change.ogg'
	max_charges = 10 //10, 5, 5, 4

/obj/item/gun/magic/wand/polymorph/zap_self(mob/living/user)
	. = ..() //because the user mob ceases to exists by the time wabbajack fully resolves

	user.wabbajack()
	charges--

/////////////////////////////////////
//WAND OF TELEPORTATION
/////////////////////////////////////

/obj/item/gun/magic/wand/teleport
	name = "传送魔杖"
	desc = "这根魔杖会扭曲目标的空间和时间，把他们移到其他地方."
	school = SCHOOL_TRANSLOCATION
	ammo_type = /obj/item/ammo_casing/magic/teleport
	fire_sound = 'sound/magic/wand_teleport.ogg'
	icon_state = "telewand"
	base_icon_state = "telewand"
	max_charges = 10 //10, 5, 5, 4
	no_den_usage = TRUE

/obj/item/gun/magic/wand/teleport/zap_self(mob/living/user)
	if(do_teleport(user, user, 10, channel = TELEPORT_CHANNEL_MAGIC))
		var/datum/effect_system/fluid_spread/smoke/smoke = new
		smoke.set_up(3, holder = src, location = user.loc)
		smoke.start()
		charges--
	..()

/obj/item/gun/magic/wand/safety
	name = "安全魔杖"
	desc = "这个魔杖将使用最轻的蓝色空间电流将目标放置在安全的地方."
	school = SCHOOL_TRANSLOCATION
	ammo_type = /obj/item/ammo_casing/magic/safety
	fire_sound = 'sound/magic/wand_teleport.ogg'
	icon_state = "telewand"
	base_icon_state = "telewand"
	max_charges = 10 //10, 5, 5, 4
	no_den_usage = FALSE

/obj/item/gun/magic/wand/safety/zap_self(mob/living/user)
	var/turf/origin = get_turf(user)
	var/turf/destination = find_safe_turf()

	if(do_teleport(user, destination, channel=TELEPORT_CHANNEL_MAGIC))
		for(var/t in list(origin, destination))
			var/datum/effect_system/fluid_spread/smoke/smoke = new
			smoke.set_up(0, holder = src, location = t)
			smoke.start()
	..()

/obj/item/gun/magic/wand/safety/debug
	desc = "这根魔杖的蓝色木头上刻着'find_safe_turf()'，也许是一段密文?"
	max_charges = 500
	variable_charges = FALSE
	can_charge = TRUE
	recharge_rate = 1


/////////////////////////////////////
//WAND OF DOOR CREATION
/////////////////////////////////////

/obj/item/gun/magic/wand/door
	name = "造门魔杖"
	desc = "这种特殊的魔杖可以在任何墙壁上为那些不择手段的巫师创造大门."
	school = SCHOOL_TRANSMUTATION
	ammo_type = /obj/item/ammo_casing/magic/door
	icon_state = "doorwand"
	base_icon_state = "doorwand"
	fire_sound = 'sound/magic/staff_door.ogg'
	max_charges = 20 //20, 10, 10, 7
	no_den_usage = 1

/obj/item/gun/magic/wand/door/zap_self(mob/living/user)
	to_chat(user, span_notice("你隐约觉得自己的心情更开放了."))
	charges--
	..()

/////////////////////////////////////
//WAND OF FIREBALL
/////////////////////////////////////

/obj/item/gun/magic/wand/fireball
	name = "火球魔杖"
	desc = "这根魔杖射出灼热的火球，然后爆炸成毁灭性的火焰."
	school = SCHOOL_EVOCATION
	fire_sound = 'sound/magic/fireball.ogg'
	ammo_type = /obj/item/ammo_casing/magic/fireball
	icon_state = "firewand"
	base_icon_state = "firewand"
	max_charges = 8 //8, 4, 4, 3

/obj/item/gun/magic/wand/fireball/zap_self(mob/living/user)
	..()
	explosion(user, devastation_range = -1, light_impact_range = 2, flame_range = 2, flash_range = 3, adminlog = FALSE, explosion_cause = src)
	charges--

/////////////////////////////////////
//WAND OF NOTHING
/////////////////////////////////////

/obj/item/gun/magic/wand/nothing
	name = "空魔杖"
	desc = "这不仅仅是一根棍子，它是一根魔法棒?"
	ammo_type = /obj/item/ammo_casing/magic/nothing
