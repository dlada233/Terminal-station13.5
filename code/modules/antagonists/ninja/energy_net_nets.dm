/**
 * # Energy Net
 *
 * Energy net which ensnares prey until it is destroyed.  Used by space ninjas.
 *
 * Energy net which keeps its target from moving until it is destroyed.  Used to send
 * players to a holding area in which they could never leave, but such feature has since
 * been removed.
 */
/obj/structure/energy_net
	name = "能量网"
	desc = "氪绿色能量织成的网."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	density = TRUE //Can't pass through.
	anchored = TRUE //Can't drag/grab the net.
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	max_integrity = 60 //How much health it has.
	can_buckle = TRUE
	buckle_lying = 0
	buckle_prevents_pull = TRUE

/obj/structure/energy_net/Initialize(mapload)
	. = ..()
	var/image/underlay = image(icon, "energynet_underlay")
	underlay.layer = BELOW_MOB_LAYER
	SET_PLANE_EXPLICIT(underlay, GAME_PLANE, src)
	add_overlay(underlay)

/obj/structure/energy_net/play_attack_sound(damage, damage_type = BRUTE, damage_flag = 0)
	if(damage_type == BRUTE || damage_type == BURN)
		playsound(src, 'sound/weapons/slash.ogg', 80, TRUE)

/obj/structure/energy_net/atom_destruction(damage_flag)
	for(var/mob/recovered_mob as anything in buckled_mobs)
		recovered_mob.visible_message(span_notice("[recovered_mob]从能量网中恢复过来了!"), span_notice("你从能量网中恢复过来了!"), span_hear("你听到一声咕哝."))
	return ..()

/obj/structure/energy_net/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/energy_net/user_buckle_mob(mob/living/buckled_mob, mob/user, check_loc = TRUE)
	return//We only want our target to be buckled

/obj/structure/energy_net/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	return//The net must be destroyed to free the target
