#define SPAM_CD (3 SECONDS)

/obj/machinery/prisongate
	name = "监狱安检门"
	desc = "侧面装有身份扫描的硬光门，即使是最顽固的员工也能被组织."
	icon = 'icons/obj/machines/sec.dmi'
	icon_state = "prisongate_on"
	/// roughly the same health/armor as an airlock
	max_integrity = 450
	damage_deflection = 30
	armor_type = /datum/armor/machinery_prisongate
	use_power = IDLE_POWER_USE
	power_channel = AREA_USAGE_EQUIP
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.05
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.03
	anchored = TRUE
	/// dictates whether the gate barrier is up or not
	var/gate_active = TRUE
	COOLDOWN_DECLARE(spam_cooldown_time)

/datum/armor/machinery_prisongate
	melee = 30
	bullet = 30
	laser = 20
	energy = 20
	bomb = 10
	fire = 80
	acid = 70

/obj/machinery/prisongate/power_change()
	. = ..()
	if(!powered())
		visible_message(span_notice("随着几下闪烁，[src]的硬光栅失去了凝结力并消散到了空中!"))
		gate_active = FALSE
		flick("prisongate_turningoff", src)
		icon_state = "prisongate_off"
		update_use_power(IDLE_POWER_USE)
	else
		gate_active = TRUE
		visible_message(span_notice("[src]的硬光栅重新填满门框内."))
		flick("prisongate_turningon", src)
		icon_state = "prisongate_on"
		update_use_power(ACTIVE_POWER_USE)

/obj/machinery/prisongate/CanAllowThrough(atom/movable/gate_toucher, border_dir)
	. = ..()
	if(!iscarbon(gate_toucher))
		if(!isstructure(gate_toucher))
			return TRUE
		var/obj/structure/cargobay = gate_toucher
		for(var/mob/living/stowaway in cargobay.contents) //nice try bub
			if(COOLDOWN_FINISHED(src, spam_cooldown_time))
				say("检测到藏有偷乘者，访问被拒绝.")
				playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
				COOLDOWN_START(src, spam_cooldown_time, SPAM_CD)
			return FALSE
	var/mob/living/carbon/the_toucher = gate_toucher
	if(gate_active == FALSE)
		return TRUE
	for(var/obj/item/card/id/regular_id in the_toucher.get_all_contents())
		var/list/id_access = regular_id.GetAccess()
		if(ACCESS_BRIG in id_access)
			if(COOLDOWN_FINISHED(src, spam_cooldown_time))
				say("检测到安保大门出入许可，已授予访问权限.")
				playsound(src, 'sound/machines/chime.ogg', 50, FALSE)
				COOLDOWN_START(src, spam_cooldown_time, SPAM_CD)
			return TRUE
	for(var/obj/item/card/id/advanced/prisoner/prison_id in the_toucher.get_all_contents())
		if(!prison_id.timed)
			continue
		if(prison_id.time_to_assign)
			say("检测到待服刑的囚犯ID. 祝您在我们的企业矫正中心[prison_id.registered_name]度过愉快时光!")
			playsound(src, 'sound/machines/chime.ogg', 50, FALSE)
			prison_id.time_left = prison_id.time_to_assign
			prison_id.time_to_assign = initial(prison_id.time_to_assign)
			prison_id.start_timer()
			return TRUE
		if(prison_id.time_left <= 0)
			say("检测到服刑期满的囚犯ID，已授予访问权限.")
			prison_id.timed = FALSE //disables the id check from earlier so you can't just throw it back into perma for mass escapes
			playsound(src, 'sound/machines/chime.ogg', 50, FALSE)
			return TRUE
		if(COOLDOWN_FINISHED(src, spam_cooldown_time))
			say("检测到正在服刑的囚犯ID. 访问被拒绝.")
			playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
			COOLDOWN_START(src, spam_cooldown_time, SPAM_CD)
		return FALSE
	if(COOLDOWN_FINISHED(src, spam_cooldown_time))
		to_chat(the_toucher, span_warning("你尝试穿过硬光栅，但收效甚微."))
		COOLDOWN_START(src, spam_cooldown_time, SPAM_CD)
	return FALSE

#undef SPAM_CD
