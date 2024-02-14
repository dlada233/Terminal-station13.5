// Hand of Midas

/obj/item/gun/magic/midas_hand
	name = "弥达斯之手"
	desc = "一把充满了希腊国王弥达斯力量的古埃及火绳手枪，不要质疑这其中的文化或宗教含义."
	ammo_type = /obj/item/ammo_casing/magic/midas_round
	icon_state = "midas_hand"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	pinless = TRUE
	max_charges = 1
	can_charge = FALSE
	item_flags = NEEDS_PERMIT
	w_class = WEIGHT_CLASS_BULKY // Should fit on a belt.
	force = 3
	trigger_guard = TRIGGER_GUARD_NORMAL
	antimagic_flags = NONE
	can_hold_up = FALSE

	/// The length of the Midas Blight debuff, dependant on the amount of gold reagent we've sucked up.
	var/gold_timer = 3 SECONDS
	/// The range that we can suck gold out of people's bodies
	var/gold_suck_range = 2

/obj/item/gun/magic/midas_hand/examine(mob/user)
	. = ..()
	var/gold_time_converted = gold_time_convert()
	. += span_notice("你的下一次射击将造成[gold_time_converted]秒的[gold_time_converted == 1 ? "" : ""]弥达斯之祸.")
	. += span_notice("右键敌人来从血液中吸取黄金来填充[src].")
	. += span_notice("[src]可以在必要时使用金币重新加载.")

/obj/item/gun/magic/midas_hand/shoot_with_empty_chamber(mob/living/user)
	. = ..()
	balloon_alert(user, "黄金不足")

// Siphon gold from a victim, recharging our gun & removing their Midas Blight debuff in the process.
/obj/item/gun/magic/midas_hand/afterattack_secondary(mob/living/victim, mob/living/user, proximity_flag, click_parameters)
	if(!isliving(victim) || !IN_GIVEN_RANGE(user, victim, gold_suck_range))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(victim == user)
		balloon_alert(user, "不能从自己身上吸取")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!victim.reagents)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/gold_amount = victim.reagents.get_reagent_amount(/datum/reagent/gold, type_check = REAGENT_SUB_TYPE)
	if(!gold_amount)
		balloon_alert(user, "血液中没有黄金")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/gold_beam = user.Beam(victim, icon_state="drain_gold")
	if(!do_after(user = user, delay = 1 SECONDS, target = victim, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE), extra_checks = CALLBACK(src, PROC_REF(check_gold_range), user, victim)))
		qdel(gold_beam)
		balloon_alert(user, "连接被破坏")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	handle_gold_charges(user, gold_amount)
	victim.reagents.remove_reagent(/datum/reagent/gold, gold_amount, include_subtypes = TRUE)
	victim.remove_status_effect(/datum/status_effect/midas_blight)
	qdel(gold_beam)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

// If we botch a shot, we have to start over again by inserting gold coins into the gun. Can only be done if it has no charges or gold.
/obj/item/gun/magic/midas_hand/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(charges || gold_timer)
		balloon_alert(user, "已经装填了")
		return
	if(istype(I, /obj/item/coin/gold))
		handle_gold_charges(user, 1.5 SECONDS)
		qdel(I)

/// Handles recharging & inserting gold amount
/obj/item/gun/magic/midas_hand/proc/handle_gold_charges(user, gold_amount)
	gold_timer += gold_amount
	var/gold_time_converted = gold_time_convert()
	balloon_alert(user, "[gold_time_converted]秒[gold_time_converted == 1 ? "" : ""]")
	if(!charges)
		instant_recharge()

/// Converts our gold_timer to time in seconds, for various ballons/examines
/obj/item/gun/magic/midas_hand/proc/gold_time_convert()
	return min(30 SECONDS, round(gold_timer, 0.2)) / 10

/// Checks our range to the person we're sucking gold out of. Double the initial range, so you need to get in close to start.
/obj/item/gun/magic/midas_hand/proc/check_gold_range(mob/living/user, mob/living/victim)
	return IN_GIVEN_RANGE(user, victim, gold_suck_range*2)

/obj/item/ammo_casing/magic/midas_round
	projectile_type = /obj/projectile/magic/midas_round


/obj/projectile/magic/midas_round
	name = "金弹丸"
	desc = "一个典型的燧发枪弹，只不过它是用被诅咒的埃及黄金制成的."
	damage_type = BRUTE
	damage = 10
	stamina = 20
	armour_penetration = 50
	hitsound = 'sound/effects/coin2.ogg'
	icon_state = "pellet"
	color = "#FFD700"
	/// The gold charge in this pellet
	var/gold_charge = 0


/obj/projectile/magic/midas_round/fire(setAngle)
	/// Transfer the gold energy to our bullet
	var/obj/item/gun/magic/midas_hand/my_gun = fired_from
	gold_charge = my_gun.gold_timer
	my_gun.gold_timer = 0
	..()

// Gives human targets Midas Blight.
/obj/projectile/magic/midas_round/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/my_guy = target
		if(isskeleton(my_guy)) // No cheap farming
			return
		my_guy.apply_status_effect(/datum/status_effect/midas_blight, min(30 SECONDS, round(gold_charge, 0.2))) // 100u gives 10 seconds
		return

/obj/item/gun/magic/midas_hand/suicide_act(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/victim = user
	victim.visible_message(span_suicide("[victim]拿着[src]的枪管对着自己的头，并点燃了导火索. 这是一种自杀行为!"))
	if(!do_after(victim, 1.5 SECONDS))
		return
	playsound(src, 'sound/weapons/gun/rifle/shot.ogg', 75, TRUE)
	to_chat(victim, span_danger("当你的身体完全变成一座金像的时候，你甚至没有时间听到枪响."))
	var/newcolors = list(rgb(206, 164, 50), rgb(146, 146, 139), rgb(28,28,28), rgb(0,0,0))
	victim.petrify(statue_timer = INFINITY, save_brain = FALSE, colorlist = newcolors)
	playsound(victim, 'sound/effects/coin2.ogg', 75, TRUE)
	charges = 0
	gold_timer = 0
	return OXYLOSS
