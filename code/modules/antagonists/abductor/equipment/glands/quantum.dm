/obj/item/organ/internal/heart/gland/quantum
	abductor_hint = "量子去观测矩阵. 被劫持者周期性地与视野中的随机一个人建立量子连接，并在随后与其交换位置."
	cooldown_low = 150
	cooldown_high = 150
	uses = -1
	icon_state = "emp"
	mind_control_uses = 2
	mind_control_duration = 1200
	var/mob/living/carbon/entangled_mob

/obj/item/organ/internal/heart/gland/quantum/activate()
	if(entangled_mob)
		return
	for(var/mob/M in oview(owner, 7))
		if(!iscarbon(M))
			continue
		entangled_mob = M
		addtimer(CALLBACK(src, PROC_REF(quantum_swap)), rand(600, 2400))
		return

/obj/item/organ/internal/heart/gland/quantum/proc/quantum_swap()
	if(QDELETED(entangled_mob))
		entangled_mob = null
		return
	var/turf/T = get_turf(owner)
	do_teleport(owner, get_turf(entangled_mob), null, channel = TELEPORT_CHANNEL_QUANTUM)
	do_teleport(entangled_mob, T, null, channel = TELEPORT_CHANNEL_QUANTUM)
	to_chat(owner, span_warning("你突然发现自己在另一个地方!"))
	to_chat(entangled_mob, span_warning("你突然发现自己在另一个地方!"))
	if(!active_mind_control) //Do not reset entangled mob while mind control is active
		entangled_mob = null

/obj/item/organ/internal/heart/gland/quantum/mind_control(command, mob/living/user)
	if(..())
		if(entangled_mob && ishuman(entangled_mob) && (entangled_mob.stat < DEAD))
			to_chat(entangled_mob, span_userdanger("你突然感到一种无法抗拒的冲动，不得不去执行一个命令..."))
			to_chat(entangled_mob, span_mind_control("[command]"))
			var/atom/movable/screen/alert/mind_control/mind_alert = entangled_mob.throw_alert(ALERT_MIND_CONTROL, /atom/movable/screen/alert/mind_control)
			mind_alert.command = command
			message_admins("[key_name(owner)]将劫持者心灵控制信息镜像发送给了[key_name(entangled_mob)]: [command]")
			user.log_message("将劫持者心灵控制信息镜像发送给了[key_name(entangled_mob)]: [command]", LOG_GAME)
			update_gland_hud()

/obj/item/organ/internal/heart/gland/quantum/clear_mind_control()
	if(active_mind_control)
		to_chat(entangled_mob, span_userdanger("你感到冲动消退并完全忘记了之前的命令."))
		entangled_mob.clear_alert(ALERT_MIND_CONTROL)
	..()
