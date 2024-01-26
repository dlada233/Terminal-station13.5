/obj/item/tank/jetpack
	name = "喷气背包(空)"
	desc = "在零重力空间中用作推进的压缩气体罐，谨慎使用."
	icon_state = "jetpack"
	inhand_icon_state = "jetpack"
	lefthand_file = 'icons/mob/inhands/equipment/jetpacks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/jetpacks_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	actions_types = list(/datum/action/item_action/set_internals, /datum/action/item_action/toggle_jetpack, /datum/action/item_action/jetpack_stabilization)
	var/gas_type = /datum/gas/oxygen
	var/on = FALSE
	var/full_speed = TRUE // If the jetpack will have a speedboost in space/nograv or not
	var/stabilize = FALSE
	var/thrust_callback

/obj/item/tank/jetpack/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, ITEM_SLOT_SUITSTORE)
	thrust_callback = CALLBACK(src, PROC_REF(allow_thrust), 0.01)
	configure_jetpack(stabilize)

/obj/item/tank/jetpack/Destroy()
	thrust_callback = null
	return ..()

/**
 * configures/re-configures the jetpack component
 *
 * Arguments
 * stabilize - Should this jetpack be stabalized
 */
/obj/item/tank/jetpack/proc/configure_jetpack(stabilize)
	src.stabilize = stabilize

	AddComponent( \
		/datum/component/jetpack, \
		src.stabilize, \
		COMSIG_JETPACK_ACTIVATED, \
		COMSIG_JETPACK_DEACTIVATED, \
		JETPACK_ACTIVATION_FAILED, \
		thrust_callback, \
		/datum/effect_system/trail_follow/ion \
	)

/obj/item/tank/jetpack/item_action_slot_check(slot)
	if(slot & slot_flags)
		return TRUE

/obj/item/tank/jetpack/equipped(mob/user, slot, initial)
	. = ..()
	if(on && !(slot & slot_flags))
		turn_off(user)

/obj/item/tank/jetpack/dropped(mob/user, silent)
	. = ..()
	if(on)
		turn_off(user)

/obj/item/tank/jetpack/populate_gas()
	if(gas_type)
		var/datum/gas_mixture/our_mix = return_air()
		our_mix.assert_gas(gas_type)
		our_mix.gases[gas_type][MOLES] = ((6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))

/obj/item/tank/jetpack/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/toggle_jetpack))
		cycle(user)
	else if(istype(action, /datum/action/item_action/jetpack_stabilization))
		if(on)
			configure_jetpack(!stabilize)
			to_chat(user, span_notice("你开关稳定装置 [stabilize ? "on" : "off"]."))
	else
		toggle_internals(user)

/obj/item/tank/jetpack/proc/cycle(mob/user)
	if(user.incapacitated())
		return

	if(!on)
		if(turn_on(user))
			to_chat(user, span_notice("你开启了喷气背包."))
		else
			to_chat(user, span_notice("你没能开启喷气背包."))
			return
	else
		turn_off(user)
		to_chat(user, span_notice("你关上了喷气背包."))

	update_item_action_buttons()

/obj/item/tank/jetpack/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][on ? "-on" : ""]"

/obj/item/tank/jetpack/proc/turn_on(mob/user)
	if(SEND_SIGNAL(src, COMSIG_JETPACK_ACTIVATED, user) & JETPACK_ACTIVATION_FAILED)
		return FALSE
	on = TRUE
	update_icon(UPDATE_ICON_STATE)
	if(full_speed)
		user.add_movespeed_modifier(/datum/movespeed_modifier/jetpack/fullspeed)
	return TRUE

/obj/item/tank/jetpack/proc/turn_off(mob/user)
	SEND_SIGNAL(src, COMSIG_JETPACK_DEACTIVATED, user)
	on = FALSE
	update_icon(UPDATE_ICON_STATE)
	if(user)
		user.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack/fullspeed)

/obj/item/tank/jetpack/proc/allow_thrust(num, use_fuel = TRUE)
	if(!ismob(loc))
		return FALSE
	var/mob/user = loc

	if((num < 0.005 || air_contents.total_moles() < num))
		turn_off(user)
		return FALSE

	// We've got the gas, it's chill
	if(!use_fuel)
		return TRUE

	var/datum/gas_mixture/removed = remove_air(num)
	if(removed.total_moles() < 0.005)
		turn_off(user)
		return FALSE

	var/turf/T = get_turf(src)
	T.assume_air(removed)
	return TRUE

/obj/item/tank/jetpack/suicide_act(mob/living/user)
	if (!ishuman(user))
		return
	var/mob/living/carbon/human/suffocater = user
	suffocater.say("纳尼！里面装的是二氧化碳！")
	suffocater.visible_message(span_suicide("[user]不小心使自己窒息了!一定是因为没有仔细看喷气背包上写的说明."))
	return OXYLOSS

/obj/item/tank/jetpack/improvised
	name = "简易喷气背包"
	desc = "由俩个气瓶、一个灭火器和一些大气设备组成的喷气背包，看起来装不了很多东西."
	icon_state = "jetpack-improvised"
	inhand_icon_state = "jetpack-improvised"
	worn_icon = null
	worn_icon_state = "jetpack-improvised"
	volume = 20 //normal jetpacks have 70 volume
	gas_type = null //it starts empty
	full_speed = FALSE //moves at modsuit jetpack speeds

/obj/item/tank/jetpack/improvised/allow_thrust(num)
	if(!ismob(loc))
		return FALSE

	var/mob/user = loc
	if(rand(0,250) == 0)
		to_chat(user, span_notice("你感觉喷气背包引擎故障了."))
		turn_off(user)
		return
	return ..()

/obj/item/tank/jetpack/void
	name = "真空用喷气背包(O2)"
	desc = "It works well in a void."
	icon_state = "jetpack-void"
	inhand_icon_state = "jetpack-void"

/obj/item/tank/jetpack/oxygen
	name = "喷气背包(O2)"
	desc = "在零重力空间中用作推进的压缩气体罐，请谨慎使用."
	icon_state = "jetpack"
	inhand_icon_state = "jetpack"

/obj/item/tank/jetpack/oxygen/harness
	name = "jet harness (oxygen)"
	desc = "A lightweight tactical harness, used by those who don't want to be weighed down by traditional jetpacks."
	icon_state = "jetpack-mini"
	inhand_icon_state = "jetpack-black"
	volume = 40
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/tank/jetpack/oxygen/captain
	name = "舰长喷气背包"
	desc = "一种紧凑、轻便的喷气背包，含有大量的压缩氧气."
	icon_state = "jetpack-captain"
	inhand_icon_state = "jetpack-captain"
	w_class = WEIGHT_CLASS_NORMAL
	volume = 90
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF //steal objective items are hard to destroy.
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE

/obj/item/tank/jetpack/oxygen/security
	name = "安保喷气背包(O2)"
	desc = "安保部队在零重力地区用做推进装置的压缩氧气瓶."
	icon_state = "jetpack-sec"
	inhand_icon_state = "jetpack-sec"



/obj/item/tank/jetpack/carbondioxide
	name = "喷气背包(CO2)"
	desc = "在零重力空间中用作推进的压缩气体罐，涂成黑色表明千万不要用于吸入."
	icon_state = "jetpack-black"
	inhand_icon_state = "jetpack-black"
	distribute_pressure = 0
	gas_type = /datum/gas/carbon_dioxide
