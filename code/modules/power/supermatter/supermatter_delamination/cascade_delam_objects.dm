/obj/crystal_mass
	name = "结晶状物"
	desc = "你看到这个巨大的水晶团块向你逼近，在每一个看似随机的运动中破裂和尖啸."
	icon = 'icons/turf/walls.dmi'
	icon_state = "crystal_cascade_1"
	layer = AREA_LAYER
	plane = ABOVE_LIGHTING_PLANE
	opacity = FALSE
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	light_power = 1
	light_range = 5
	light_color = COLOR_VIVID_YELLOW
	move_resist = INFINITY
	///All dirs we can expand to
	var/list/available_dirs = list(NORTH,SOUTH,EAST,WEST,UP,DOWN)
	///Handler that helps with properly killing mobs that the crystal grows over
	var/datum/component/supermatter_crystal/sm_comp
	///Cooldown on the expansion process
	COOLDOWN_DECLARE(sm_wall_cooldown)

/obj/crystal_mass/Initialize(mapload, dir_to_remove)
	. = ..()
	icon_state = "crystal_cascade_[rand(1,6)]"
	START_PROCESSING(SSsupermatter_cascade, src)

	sm_comp = AddComponent(/datum/component/supermatter_crystal, null, null)

	playsound(src, 'sound/misc/cracking_crystal.ogg', 45, TRUE)

	available_dirs -= dir_to_remove

	var/turf/our_turf = get_turf(src)

	if(our_turf)
		our_turf.opacity = FALSE

	// Ideally this'd be part of the SM component, but the SM itself snowflakes bullets (emitters are bullets).
	RegisterSignal(src, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(eat_bullets))

/obj/crystal_mass/process()

	if(!COOLDOWN_FINISHED(src, sm_wall_cooldown))
		return

	if(!available_dirs || available_dirs.len <= 0)
		return PROCESS_KILL

	COOLDOWN_START(src, sm_wall_cooldown, rand(0, 3 SECONDS))

	var/picked_dir = pick_n_take(available_dirs)
	var/turf/next_turf = get_step_multiz(src, picked_dir)

	icon_state = "crystal_cascade_[rand(1,6)]"

	if(!next_turf || locate(/obj/crystal_mass) in next_turf)
		return

	for(var/atom/movable/checked_atom as anything in next_turf)
		if(isliving(checked_atom))
			sm_comp.dust_mob(src, checked_atom, span_danger("[src]突进到[checked_atom], 触摸到了[checked_atom.p_them()]... \
					[checked_atom.p_their()]身体发出耀眼的光芒，然后由内到外的结晶化并与[src]融合!"),
				span_userdanger("晶体块向你突进过来，击中了你的胸部，你的视野立刻就充满了炫目的光芒，你对自己说\"麻了.\""))
		else if(istype(checked_atom, /obj/cascade_portal))
			checked_atom.visible_message(span_userdanger("[checked_atom]在被[src]击中时发出尖啸并关闭! 太晚了!"))
			playsound(get_turf(checked_atom), 'sound/magic/charge.ogg', 50, TRUE)
			playsound(get_turf(checked_atom), 'sound/effects/supermatter.ogg', 50, TRUE)
			qdel(checked_atom)
		else if(isitem(checked_atom))
			playsound(get_turf(checked_atom), 'sound/effects/supermatter.ogg', 50, TRUE)
			qdel(checked_atom)

	new /obj/crystal_mass(next_turf, get_dir(next_turf, src))

/obj/crystal_mass/proc/eat_bullets(datum/source, obj/projectile/hitting_projectile)
	SIGNAL_HANDLER

	visible_message(
		span_warning("[hitting_projectile]伴随着一声巨响飞进[src]，然后迅速化成了灰烬."),
		null,
		span_hear("当你被一股热浪冲刷时，你听到一声巨响."),
	)

	playsound(src, 'sound/effects/supermatter.ogg', 50, TRUE)
	qdel(hitting_projectile)
	return COMPONENT_BULLET_BLOCKED

/obj/crystal_mass/singularity_act()
	return

/obj/crystal_mass/attack_tk(mob/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/jedi = user
	to_chat(jedi, span_userdanger("这真是一个深奥的想法."))
	jedi.ghostize()
	var/obj/item/organ/internal/brain/rip_u = locate(/obj/item/organ/internal/brain) in jedi.organs
	if(rip_u)
		rip_u.Remove(jedi)
		qdel(rip_u)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/crystal_mass/Destroy()
	STOP_PROCESSING(SSsupermatter_cascade, src)
	sm_comp = null
	return ..()

/obj/cascade_portal
	name = "蓝空裂痕"
	desc = "当你试图理解所看到的东西时，你的大脑感到天旋地转."
	icon = 'icons/effects/224x224.dmi'
	icon_state = "reality"
	anchored = TRUE
	appearance_flags = LONG_GLIDE
	density = TRUE
	plane = MASSIVE_OBJ_PLANE
	light_color = COLOR_RED
	light_power = 0.7
	light_range = 15
	move_resist = INFINITY
	pixel_x = -96
	pixel_y = -96
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/cascade_portal/Initialize(mapload)
	. = ..()
	var/turf/location = get_turf(src)
	var/area_name = get_area_name(src)
	message_admins("Exit rift created at [area_name]. [ADMIN_VERBOSEJMP(location)]")
	log_game("Bluespace Exit Rift was created at [area_name].")
	investigate_log("created at [area_name].", INVESTIGATE_ENGINE)

/obj/cascade_portal/Destroy(force)
	var/turf/location = get_turf(src)
	var/area_name = get_area_name(src)
	message_admins("Exit rift at [area_name] deleted. [ADMIN_VERBOSEJMP(location)]")
	log_game("Bluespace Exit Rift at [area_name] was deleted.")
	investigate_log("was deleted.", INVESTIGATE_ENGINE)
	return ..()

/obj/cascade_portal/Bumped(atom/movable/hit_object)
	consume(hit_object)
	new /obj/effect/particle_effect/sparks(loc)
	playsound(loc, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/**
 * Proc to consume the objects colliding with the portal
 *
 * Arguments: atom/movable/consumed_object is the object hitting the portal
 */
/obj/cascade_portal/proc/consume(atom/movable/consumed_object)
	if(isliving(consumed_object))
		consumed_object.visible_message(span_danger("[consumed_object]走入了[src]... \
			在炫目的闪光后，其身体彻底的消失了!"),
			span_userdanger("随着你走入[src]，你的身体被强大的蓝光冲刷殆尽. \
				在脸朝下落在冰冷的地板上前，你还能重新思考刚刚的所作所为."),
			span_hear("你听到一声巨响，一股扭曲的气流穿过你的身体."))

		var/list/arrival_turfs = get_area_turfs(/area/centcom/central_command_areas/evacuation)
		var/turf/arrival_turf
		do
			arrival_turf = pick_n_take(arrival_turfs)
		while(!is_safe_turf(arrival_turf))

		var/mob/living/consumed_mob = consumed_object
		message_admins("[key_name_admin(consumed_mob)] has entered [src] [ADMIN_VERBOSEJMP(src)].")
		investigate_log("was entered by [key_name(consumed_mob)].", INVESTIGATE_ENGINE)
		consumed_mob.forceMove(arrival_turf)
		consumed_mob.Paralyze(100)
		consumed_mob.adjustBruteLoss(30)
		consumed_mob.flash_act(1, TRUE, TRUE)

		new /obj/effect/particle_effect/sparks(consumed_object)
		playsound(consumed_object, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	else if(isitem(consumed_object))
		consumed_object.visible_message(span_danger("[consumed_object]撞上了[src]，然后消失在了视野内."), null,
			span_hear("当一个小的扭曲穿过你的身体时，你听到一声巨响."))

		qdel(consumed_object)
