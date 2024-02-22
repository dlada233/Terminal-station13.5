/obj/item/wrench
	name = "扳手"
	desc = "一种常用扳手。可以在你的手上找到."
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"
	inhand_icon_state = "wrench"
	worn_icon_state = "wrench"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	demolition_mod = 1.25
	w_class = WEIGHT_CLASS_SMALL
	usesound = 'sound/items/ratchet.ogg'
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*1.5)
	drop_sound = 'sound/items/handling/wrench_drop.ogg'
	pickup_sound = 'sound/items/handling/wrench_pickup.ogg'

	attack_verb_continuous = list("bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("bash", "batter", "bludgeon", "whack")
	tool_behaviour = TOOL_WRENCH
	toolspeed = 1
	armor_type = /datum/armor/item_wrench

/datum/armor/item_wrench
	fire = 50
	acid = 30

/obj/item/wrench/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/falling_hazard, damage = force, wound_bonus = wound_bonus, hardhat_safety = TRUE, crushes = FALSE, impact_sound = hitsound)

/obj/item/wrench/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正在用[src]活活把[user.p_them()]自己打到死!看上去[user.p_theyre()]试图自杀!"))
	playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1)
	return BRUTELOSS

/obj/item/wrench/abductor
	name = "外星扳手"
	desc = "极化扳手。它会使夹在钳口之间的任何东西转动."
	icon = 'icons/obj/antags/abductor.dmi'
	belt_icon_state = "wrench_alien"
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT)
	usesound = 'sound/effects/empulse.ogg'
	toolspeed = 0.1


/obj/item/wrench/medical
	name = "医用扳手"
	desc = "一种常用（医用？）的医用扳手。可以在你的手上找到."
	icon_state = "wrench_medical"
	inhand_icon_state = "wrench_medical"
	force = 2 //MEDICAL
	throwforce = 4
	attack_verb_continuous = list("heals", "medicals", "taps", "pokes", "analyzes") //"cobbyed"
	attack_verb_simple = list("heal", "medical", "tap", "poke", "analyze")
	///var to hold the name of the person who suicided
	var/suicider

/obj/item/wrench/medical/examine(mob/user)
	. = ..()
	if(suicider)
		. += span_notice("出于某些原因，它让你想起[suicider].")

/obj/item/wrench/medical/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]祈祷医用扳手带走[user.p_their()]灵魂. 看起来[user.p_theyre()]试图自杀!"))
	user.Stun(100, ignore_canstun = TRUE)// Stun stops them from wandering off
	user.set_light_color(COLOR_VERY_SOFT_YELLOW)
	user.set_light(2)
	user.add_overlay(mutable_appearance('icons/mob/effects/genetics.dmi', "servitude", -MUTATIONS_LAYER))
	playsound(loc, 'sound/effects/pray.ogg', 50, TRUE, -1)

	// Let the sound effect finish playing
	add_fingerprint(user)
	sleep(2 SECONDS)
	if(!user)
		return
	for(var/obj/item/suicide_wrench in user)
		user.dropItemToGround(suicide_wrench)
	suicider = user.real_name
	user.dust()
	return OXYLOSS

/obj/item/wrench/cyborg
	name = "液压扳手"
	desc = "一种先进的机械扳手，由内部液压驱动.速度是手持版的两倍."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "wrench_cyborg"
	toolspeed = 0.5

/obj/item/wrench/combat
	name = "格斗扳手"
	desc = "和普通的扳手类似，但更加锋利。可以在战场上找到."
	icon_state = "wrench_combat"
	inhand_icon_state = "wrench_combat"
	belt_icon_state = "wrench_combat"
	attack_verb_continuous = list("devastates", "brutalizes", "commits a war crime against", "obliterates", "humiliates")
	attack_verb_simple = list("devastate", "brutalize", "commit a war crime against", "obliterate", "humiliate")
	tool_behaviour = null

/obj/item/wrench/combat/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = 6, \
		throwforce_on = 8, \
		hitsound_on = hitsound, \
		w_class_on = WEIGHT_CLASS_NORMAL, \
		clumsy_check = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Gives it wrench behaviors when active.
 */
/obj/item/wrench/combat/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = active ? TOOL_WRENCH : initial(tool_behaviour)
	if(user)
		balloon_alert(user, "[name] [active ? "active, woe!":"restrained"]")
	playsound(src, active ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 5, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/wrench/bolter
	name = "门栓扳手"
	desc = "一种设计用于抓取气闸门栓系统的扳手，并在不考虑气闸电源状态的情况下将其提升."
	icon_state = "bolter_wrench"
	inhand_icon_state = "bolter_wrench"
	w_class = WEIGHT_CLASS_NORMAL
