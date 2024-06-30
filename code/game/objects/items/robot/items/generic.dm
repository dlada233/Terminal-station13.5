#define HUG_MODE_NICE 0
#define HUG_MODE_HUG 1
#define HUG_MODE_SHOCK 2
#define HUG_MODE_CRUSH 3

#define HUG_SHOCK_COOLDOWN (2 SECONDS)
#define HUG_CRUSH_COOLDOWN (1 SECONDS)

#define HARM_ALARM_NO_SAFETY_COOLDOWN (60 SECONDS)
#define HARM_ALARM_SAFETY_COOLDOWN (20 SECONDS)

/obj/item/borg
	icon = 'icons/mob/silicon/robot_items.dmi'

/// Cost to use the stun arm
#define CYBORG_STUN_CHARGE_COST (0.2 * STANDARD_CELL_CHARGE)

/obj/item/borg/stun
	name = "电击臂"
	icon_state = "elecarm"
	var/stamina_damage = 60 //Same as normal batong
	var/cooldown_check = 0
	/// cooldown between attacks
	var/cooldown = 4 SECONDS // same as baton

/obj/item/borg/stun/attack(mob/living/attacked_mob, mob/living/user)
	if(cooldown_check > world.time)
		user.balloon_alert(user, "still recharging!")
		return
	if(ishuman(attacked_mob))
		var/mob/living/carbon/human/human = attacked_mob
		if(human.check_block(src, 0, "[attacked_mob]'s [name]", MELEE_ATTACK))
			playsound(attacked_mob, 'sound/weapons/genhit.ogg', 50, TRUE)
			return FALSE
	if(iscyborg(user))
		var/mob/living/silicon/robot/robot_user = user
		if(!robot_user.cell.use(CYBORG_STUN_CHARGE_COST))
			return

	user.do_attack_animation(attacked_mob)
	attacked_mob.adjustStaminaLoss(stamina_damage)
	attacked_mob.set_confusion_if_lower(5 SECONDS)
	attacked_mob.adjust_stutter(20 SECONDS)
	attacked_mob.set_jitter_if_lower(5 SECONDS)
	if(issilicon(attacked_mob))
		attacked_mob.emp_act(EMP_HEAVY)
		attacked_mob.visible_message(
			span_danger("[user]用[src]电了[attacked_mob]!"),
			span_userdanger("[user]用[src]电了你!"),
		)
	else
		attacked_mob.visible_message(
			span_danger("[user]用[src]触摸了[attacked_mob]!"),
			span_userdanger("[user]用[src]触摸了你!"),
		)

	playsound(loc, 'sound/weapons/egloves.ogg', 50, TRUE, -1)
	cooldown_check = world.time + cooldown
	log_combat(user, attacked_mob, "stunned", src, "(Combat mode: [user.combat_mode ? "On" : "Off"])")

#undef CYBORG_STUN_CHARGE_COST

/obj/item/borg/cyborghug
	name = "拥抱模块"
	icon_state = "hugmodule"
	desc = "给那些真的需要一个拥抱的人."
	/// Hug mode
	var/mode = HUG_MODE_NICE
	/// Crush cooldown
	COOLDOWN_DECLARE(crush_cooldown)
	/// Shock cooldown
	COOLDOWN_DECLARE(shock_cooldown)
	/// Can it be a stunarm when emagged. Only PK borgs get this by default.
	var/shockallowed = FALSE
	var/boop = FALSE

/obj/item/borg/cyborghug/attack_self(mob/living/user)
	if(iscyborg(user))
		var/mob/living/silicon/robot/robot_user = user
		if(robot_user.emagged && shockallowed == 1)
			if(mode < HUG_MODE_CRUSH)
				mode++
			else
				mode = HUG_MODE_NICE
		else if(mode < HUG_MODE_HUG)
			mode++
		else
			mode = HUG_MODE_NICE
	switch(mode)
		if(HUG_MODE_NICE)
			to_chat(user, "<span class='infoplain'>Power reset. Hugs!</span>")
		if(HUG_MODE_HUG)
			to_chat(user, "<span class='infoplain'>Power increased!</span>")
		if(HUG_MODE_SHOCK)
			to_chat(user, "<span class='warningplain'>BZZT. Electrifying arms...</span>")
		if(HUG_MODE_CRUSH)
			to_chat(user, "<span class='warningplain'>ERROR: ARM ACTUATORS OVERLOADED.</span>")

/obj/item/borg/cyborghug/attack(mob/living/attacked_mob, mob/living/silicon/robot/user, params)
	if(attacked_mob == user)
		return
	if(attacked_mob.health < 0)
		return
	switch(mode)
		if(HUG_MODE_NICE)
			if(isanimal_or_basicmob(attacked_mob))
				var/list/modifiers = params2list(params)
				if (!user.combat_mode && !LAZYACCESS(modifiers, RIGHT_CLICK))
					attacked_mob.attack_hand(user, modifiers) //This enables borgs to get the floating heart icon and mob emote from simple_animal's that have petbonus == true.
				return
			if(user.zone_selected == BODY_ZONE_HEAD)
				user.visible_message(
					span_notice("[user] 开玩笑似地敲了敲 [attacked_mob] 的头."),
					span_notice("你 开玩笑似地敲了敲 [attacked_mob] 的头."),
				)
				user.do_attack_animation(attacked_mob, ATTACK_EFFECT_BOOP)
				playsound(loc, 'sound/weapons/tap.ogg', 50, TRUE, -1)
			else if(ishuman(attacked_mob))
				if(user.body_position == LYING_DOWN)
					user.visible_message(
						span_notice("[user] 摇了摇 [attacked_mob] 想让其从地上起来."),
						span_notice("你摇了摇 [attacked_mob] 想让其从地上起来."),
					)
				else
					user.visible_message(
						span_notice("[user]拥抱了[attacked_mob]，使其精神振作."),
						span_notice("你拥抱了[attacked_mob]，使其精神振作."),
					)
				if(attacked_mob.resting)
					attacked_mob.set_resting(FALSE, TRUE)
			else
				user.visible_message(
					span_notice("[user] 宠爱了一把 [attacked_mob]!"),
					span_notice("你宠爱了一把 [attacked_mob]!"),
				)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
		if(HUG_MODE_HUG)
			if(ishuman(attacked_mob))
				attacked_mob.adjust_status_effects_on_shake_up()
				if(attacked_mob.body_position == LYING_DOWN)
					user.visible_message(
						span_notice("[user] 摇了摇 [attacked_mob] 想让其从地上起来."),
						span_notice("你摇了摇 [attacked_mob] 想让其从地上起来."),
					)
				else if(user.zone_selected == BODY_ZONE_HEAD)
					user.visible_message(span_warning("[user]敲击了[attacked_mob]的头!"),
						span_warning("你敲击了[attacked_mob]的头!"),
					)
					user.do_attack_animation(attacked_mob, ATTACK_EFFECT_PUNCH)
				else
					if(!(SEND_SIGNAL(attacked_mob, COMSIG_BORG_HUG_MOB, user) & COMSIG_BORG_HUG_HANDLED))
						user.visible_message(
							span_warning("[user]给了[attacked_mob]一个熊抱! [attacked_mob]脸色看起来不是很好..."),
							span_warning("你给了[attacked_mob]一个熊抱! [attacked_mob]脸色看起来不是很好..."),
						)
				if(attacked_mob.resting)
					attacked_mob.set_resting(FALSE, TRUE)
			else
				user.visible_message(
					span_warning("[user]敲击了[attacked_mob]的头!"),
					span_warning("你敲击了[attacked_mob]的头!"),
				)
			playsound(loc, 'sound/weapons/tap.ogg', 50, TRUE, -1)
		if(HUG_MODE_SHOCK)
			if (!COOLDOWN_FINISHED(src, shock_cooldown))
				return
			if(ishuman(attacked_mob))
				attacked_mob.electrocute_act(5, "[user]", flags = SHOCK_NOGLOVES | SHOCK_NOSTUN)
				attacked_mob.dropItemToGround(attacked_mob.get_active_held_item())
				attacked_mob.dropItemToGround(attacked_mob.get_inactive_held_item())
				user.visible_message(
					span_userdanger("[user]强力电击了[attacked_mob]"),
					span_danger("你强力电击了[attacked_mob]!"),
				)
			else
				if(!iscyborg(attacked_mob))
					attacked_mob.adjustFireLoss(10)
					user.visible_message(
						span_userdanger("[user]电击了[attacked_mob]!"),
						span_danger("你电击了[attacked_mob]!"),
					)
				else
					user.visible_message(
						span_userdanger("[user]电击了[attacked_mob]，但似乎没什么效果"),
						span_danger("你电击了[attacked_mob]，但似乎没什么效果."),
					)
			playsound(loc, 'sound/effects/sparks2.ogg', 50, TRUE, -1)
			user.cell.use(0.5 * STANDARD_CELL_CHARGE, force = TRUE)
			COOLDOWN_START(src, shock_cooldown, HUG_SHOCK_COOLDOWN)
		if(HUG_MODE_CRUSH)
			if (!COOLDOWN_FINISHED(src, crush_cooldown))
				return
			if(ishuman(attacked_mob))
				user.visible_message(
					span_userdanger("[user]把[attacked_mob]抓在手中!"),
					span_danger("你把[attacked_mob]抓在手中!"),
				)
			else
				user.visible_message(
					span_userdanger("[user]压碎了[attacked_mob]!"),
						span_danger("你压碎了[attacked_mob]!"),
				)
			playsound(loc, 'sound/weapons/smash.ogg', 50, TRUE, -1)
			attacked_mob.adjustBruteLoss(15)
			user.cell.use(0.3 * STANDARD_CELL_CHARGE, force = TRUE)
			COOLDOWN_START(src, crush_cooldown, HUG_CRUSH_COOLDOWN)

/obj/item/borg/cyborghug/peacekeeper
	shockallowed = TRUE

/obj/item/borg/cyborghug/medical
	boop = TRUE

/obj/item/borg/charger
	name = "电源接口"
	icon_state = "charger_draw"
	item_flags = NOBLUDGEON
	/// Charging mode
	var/mode = "draw"
	/// Whitelist of charging machines
	var/static/list/charge_machines = typecacheof(list(/obj/machinery/cell_charger, /obj/machinery/recharger, /obj/machinery/recharge_station, /obj/machinery/mech_bay_recharge_port))
	/// Whitelist of chargable items
	var/static/list/charge_items = typecacheof(list(/obj/item/stock_parts/cell, /obj/item/gun/energy))

/obj/item/borg/charger/update_icon_state()
	icon_state = "charger_[mode]"
	return ..()

/obj/item/borg/charger/attack_self(mob/user)
	if(mode == "draw")
		mode = "charge"
	else
		mode = "draw"
	to_chat(user, span_notice("You toggle [src] to \"[mode]\" mode."))
	update_appearance()

/obj/item/borg/charger/afterattack(obj/item/target, mob/living/silicon/robot/user, proximity_flag)
	. = ..()
	if(!proximity_flag || !iscyborg(user))
		return
	. |= AFTERATTACK_PROCESSED_ITEM
	if(mode == "draw")
		if(is_type_in_list(target, charge_machines))
			var/obj/machinery/target_machine = target
			if((target_machine.machine_stat & (NOPOWER|BROKEN)) || !target_machine.anchored)
				to_chat(user, span_warning("[target_machine] is unpowered!"))
				return

			to_chat(user, span_notice("You connect to [target_machine]'s power line..."))
			while(do_after(user, 1.5 SECONDS, target = target_machine, progress = FALSE))
				if(!user || !user.cell || mode != "draw")
					return

				if((target_machine.machine_stat & (NOPOWER|BROKEN)) || !target_machine.anchored)
					break

				target_machine.charge_cell(0.15 * STANDARD_CELL_CHARGE, user.cell)

			to_chat(user, span_notice("You stop charging yourself."))

		else if(is_type_in_list(target, charge_items))
			var/obj/item/stock_parts/cell/cell = target
			if(!istype(cell))
				cell = locate(/obj/item/stock_parts/cell) in target
			if(!cell)
				to_chat(user, span_warning("[target] has no power cell!"))
				return

			if(istype(target, /obj/item/gun/energy))
				var/obj/item/gun/energy/energy_gun = target
				if(!energy_gun.can_charge)
					to_chat(user, span_warning("[target] has no power port!"))
					return

			if(!cell.charge)
				to_chat(user, span_warning("[target] has no power!"))


			to_chat(user, span_notice("You connect to [target]'s power port..."))

			while(do_after(user, 1.5 SECONDS, target = target, progress = FALSE))
				if(!user || !user.cell || mode != "draw")
					return

				if(!cell || !target)
					return

				if(cell != target && cell.loc != target)
					return

				var/draw = min(cell.charge, cell.chargerate*0.5, user.cell.maxcharge - user.cell.charge)
				if(!cell.use(draw))
					break
				if(!user.cell.give(draw))
					break
				target.update_appearance()

			to_chat(user, span_notice("You stop charging yourself."))

	else if(is_type_in_list(target, charge_items))
		var/obj/item/stock_parts/cell/cell = target
		if(!istype(cell))
			cell = locate(/obj/item/stock_parts/cell) in target
		if(!cell)
			to_chat(user, span_warning("[target] has no power cell!"))
			return

		if(istype(target, /obj/item/gun/energy))
			var/obj/item/gun/energy/energy_gun = target
			if(!energy_gun.can_charge)
				to_chat(user, span_warning("[target] has no power port!"))
				return

		if(cell.charge >= cell.maxcharge)
			to_chat(user, span_warning("[target] is already charged!"))

		to_chat(user, span_notice("You connect to [target]'s power port..."))

		while(do_after(user, 1.5 SECONDS, target = target, progress = FALSE))
			if(!user || !user.cell || mode != "charge")
				return

			if(!cell || !target)
				return

			if(cell != target && cell.loc != target)
				return

			var/draw = min(user.cell.charge, cell.chargerate * 0.5, cell.maxcharge - cell.charge)
			if(!user.cell.use(draw))
				break
			if(!cell.give(draw))
				break
			target.update_appearance()

		to_chat(user, span_notice("You stop charging [target]."))

/obj/item/harmalarm
	name = "\improper 声波防害工具"
	desc = "释放一股无害的音爆使得大多数有机生命倒下. For when the harm is JUST TOO MUCH."
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "megaphone"
	/// Harm alarm cooldown
	COOLDOWN_DECLARE(alarm_cooldown)

/obj/item/harmalarm/emag_act(mob/user, obj/item/card/emag/emag_card)
	obj_flags ^= EMAGGED
	if(obj_flags & EMAGGED)
		balloon_alert(user, "safeties shorted")
	else
		balloon_alert(user, "safeties reset")
	return TRUE

/obj/item/harmalarm/attack_self(mob/user)
	var/safety = !(obj_flags & EMAGGED)
	if (!COOLDOWN_FINISHED(src, alarm_cooldown))
		to_chat(user, "<font color='red'>The device is still recharging!</font>")
		return

	if(iscyborg(user))
		var/mob/living/silicon/robot/robot_user = user
		if(!robot_user.cell || robot_user.cell.charge < 1200)
			to_chat(user, span_warning("You don't have enough charge to do this!"))
			return
		robot_user.cell.charge -= 1000
		if(robot_user.emagged)
			safety = FALSE

	if(safety == TRUE)
		user.visible_message(
			"<font color='red' size='2'>[user] blares out a near-deafening siren from its speakers!</font>",
			span_userdanger("Your siren blares around [iscyborg(user) ? "you" : "and confuses you"]!"),
			span_danger("The siren pierces your hearing!"),
		)
		for(var/mob/living/carbon/carbon in get_hearers_in_view(9, user))
			if(carbon.get_ear_protection())
				continue
			carbon.adjust_confusion(6 SECONDS)

		audible_message("<font color='red' size='7'>HUMAN HARM</font>")
		playsound(get_turf(src), 'sound/ai/harmalarm.ogg', 70, 3)
		COOLDOWN_START(src, alarm_cooldown, HARM_ALARM_SAFETY_COOLDOWN)
		user.log_message("used a Cyborg Harm Alarm", LOG_ATTACK)
		if(iscyborg(user))
			var/mob/living/silicon/robot/robot_user = user
			to_chat(robot_user.connected_ai, "<br>[span_notice("NOTICE - Peacekeeping 'HARM ALARM' used by: [user]")]<br>")
	else
		user.audible_message("<font color='red' size='7'>BZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZT</font>")
		for(var/mob/living/carbon/carbon in get_hearers_in_view(9, user))
			var/bang_effect = carbon.soundbang_act(2, 0, 0, 5)
			switch(bang_effect)
				if(1)
					carbon.adjust_confusion(5 SECONDS)
					carbon.adjust_stutter(20 SECONDS)
					carbon.adjust_jitter(20 SECONDS)
				if(2)
					carbon.Paralyze(40)
					carbon.adjust_confusion(10 SECONDS)
					carbon.adjust_stutter(30 SECONDS)
					carbon.adjust_jitter(50 SECONDS)
		playsound(get_turf(src), 'sound/machines/warning-buzzer.ogg', 130, 3)
		COOLDOWN_START(src, alarm_cooldown, HARM_ALARM_NO_SAFETY_COOLDOWN)
		user.log_message("used an emagged Cyborg Harm Alarm", LOG_ATTACK)

#undef HUG_MODE_NICE
#undef HUG_MODE_HUG
#undef HUG_MODE_SHOCK
#undef HUG_MODE_CRUSH

#undef HUG_SHOCK_COOLDOWN
#undef HUG_CRUSH_COOLDOWN

#undef HARM_ALARM_NO_SAFETY_COOLDOWN
#undef HARM_ALARM_SAFETY_COOLDOWN
