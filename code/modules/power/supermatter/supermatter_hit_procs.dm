/// Consume things that run into the supermatter from the tram. The tram calls forceMove (doesn't call Bump/ed) and not Move, and I'm afraid changing it will do something chaotic
/obj/machinery/power/supermatter_crystal/proc/tram_contents_consume(datum/source, list/tram_contents)
	SIGNAL_HANDLER

	for(var/atom/thing_to_consume as anything in tram_contents)
		Bumped(thing_to_consume)

/obj/machinery/power/supermatter_crystal/proc/eat_bullets(datum/source, obj/projectile/projectile)
	SIGNAL_HANDLER

	var/turf/local_turf = loc
	if(!istype(local_turf))
		return NONE

	var/kiss_power = 0
	switch(projectile.type)
		if(/obj/projectile/kiss)
			kiss_power = 60
		if(/obj/projectile/kiss/death)
			kiss_power = 20000

	if(!istype(projectile.firer, /obj/machinery/power/emitter))
		investigate_log("has been hit by [projectile] fired by [key_name(projectile.firer)]", INVESTIGATE_ENGINE)
	if(projectile.armor_flag != BULLET || kiss_power)
		if(kiss_power)
			psy_coeff = 1
		external_power_immediate += projectile.damage * bullet_energy + kiss_power
		log_activation(who = projectile.firer, how = projectile.fired_from)
	else
		external_damage_immediate += projectile.damage * bullet_energy * 0.1
		// Stop taking damage at emergency point, yell to players at danger point.
		// This isn't clean and we are repeating [/obj/machinery/power/supermatter_crystal/proc/calculate_damage], sorry for this.
		var/damage_to_be = damage + external_damage_immediate * clamp((emergency_point - damage) / emergency_point, 0, 1)
		if(damage_to_be > danger_point)
			visible_message(span_notice("[src]在压力下压缩, 抵抗进一步冲击!"))
		playsound(src, 'sound/effects/supermatter.ogg', 50, TRUE)

	qdel(projectile)
	return COMPONENT_BULLET_BLOCKED

/obj/machinery/power/supermatter_crystal/singularity_act()
	var/gain = 100
	investigate_log("was consumed by a singularity.", INVESTIGATE_ENGINE)
	message_admins("Singularity has consumed a supermatter shard and can now become stage six.")
	visible_message(span_userdanger("[src] is consumed by the singularity!"))
	var/turf/sm_turf = get_turf(src)
	for(var/mob/hearing_mob as anything in GLOB.player_list)
		if(!is_valid_z_level(get_turf(hearing_mob), sm_turf))
			continue
		SEND_SOUND(hearing_mob, 'sound/effects/supermatter.ogg') //everyone goan know bout this
		to_chat(hearing_mob, span_boldannounce("可怖的尖啸声充满你的耳朵，恐惧的浪潮席卷而来..."))
	qdel(src)
	return gain

/obj/machinery/power/supermatter_crystal/attack_tk(mob/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/jedi = user
	to_chat(jedi, span_userdanger("这真是一个深奥的想法."))
	jedi.investigate_log("had [jedi.p_their()] brain dusted by touching [src] with telekinesis.", INVESTIGATE_DEATHS)
	jedi.ghostize()
	var/obj/item/organ/internal/brain/rip_u = locate(/obj/item/organ/internal/brain) in jedi.organs
	if(rip_u)
		rip_u.Remove(jedi)
		qdel(rip_u)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/machinery/power/supermatter_crystal/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/scalpel/supermatter))
		var/obj/item/scalpel/supermatter/scalpel = item
		to_chat(user, span_notice("你小心翼翼地开始用[scalpel]刮[src]..."))
		if(!scalpel.use_tool(src, user, 60, volume=100))
			return
		if (scalpel.usesLeft)
			to_chat(user, span_danger("你从[src]中提取出了碎片. [src]开始剧烈反应!"))
			new /obj/item/nuke_core/supermatter_sliver(src.drop_location())
			supermatter_sliver_removed = TRUE
			external_power_trickle += 800
			log_activation(who = user, how = scalpel)
			scalpel.usesLeft--
			if (!scalpel.usesLeft)
				to_chat(user, span_notice("[scalpel]上的一些物质脱落了, 现在它失去了作用!"))
		else
			to_chat(user, span_warning("你从[src]里提取碎片失败了! [scalpel]已经不够锋利了."))
		return

	if(istype(item, /obj/item/destabilizing_crystal))
		var/obj/item/destabilizing_crystal/destabilizing_crystal = item

		if(!is_main_engine)
			to_chat(user, span_warning("你不能使用[destabilizing_crystal]在[name]上."))
			return

		if(get_integrity_percent() < SUPERMATTER_CASCADE_PERCENT)
			to_chat(user, span_warning("你只能应用[destabilizing_crystal]在[name]上，且是在至少有[SUPERMATTER_CASCADE_PERCENT]%完整度的情况下."))
			return

		to_chat(user, span_warning("你开始连接[destabilizing_crystal]到[src]..."))
		if(do_after(user, 3 SECONDS, src))
			message_admins("[ADMIN_LOOKUPFLW(user)] attached [destabilizing_crystal] to the supermatter at [ADMIN_VERBOSEJMP(src)].")
			user.log_message("attached [destabilizing_crystal] to the supermatter", LOG_GAME)
			user.investigate_log("attached [destabilizing_crystal] to a supermatter crystal.", INVESTIGATE_ENGINE)
			to_chat(user, span_danger("[destabilizing_crystal]紧贴[src]."))
			set_delam(SM_DELAM_PRIO_IN_GAME, /datum/sm_delam/cascade)
			external_damage_immediate += 10
			external_power_trickle += 500
			log_activation(who = user, how = destabilizing_crystal)
			qdel(destabilizing_crystal)
		return

	return ..()

//Do not blow up our internal radio
/obj/machinery/power/supermatter_crystal/contents_explosion(severity, target)
	return

/obj/machinery/power/supermatter_crystal/proc/wrench_act_callback(mob/user, obj/item/tool)
	if(moveable)
		default_unfasten_wrench(user, tool)

/obj/machinery/power/supermatter_crystal/proc/consume_callback(matter_increase, damage_increase)
	external_power_trickle += matter_increase
	external_damage_immediate += damage_increase
