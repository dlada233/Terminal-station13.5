/obj/item/gun/ballistic/revolver
	name = ".357 左轮手枪"
	desc = "一把可疑的左轮手枪，打.357子弹."
	icon_state = "revolver"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	load_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	eject_sound = 'sound/weapons/gun/revolver/empty.ogg'
	fire_sound_volume = 90
	dry_fire_sound = 'sound/weapons/gun/revolver/dry_fire.ogg'
	casing_ejector = FALSE
	internal_magazine = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	tac_reloads = FALSE
	var/spin_delay = 10
	var/recent_spin = 0
	var/last_fire = 0

/obj/item/gun/ballistic/revolver/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	..()
	last_fire = world.time


/obj/item/gun/ballistic/revolver/chamber_round(spin_cylinder = TRUE, replace_new_round)
	if(!magazine) //if it mag was qdel'd somehow.
		CRASH("revolver tried to chamber a round without a magazine!")
	if(chambered)
		UnregisterSignal(chambered, COMSIG_MOVABLE_MOVED)
	if(spin_cylinder)
		chambered = magazine.get_round(TRUE)
	else
		chambered = magazine.stored_ammo[1]
	if(chambered)
		RegisterSignal(chambered, COMSIG_MOVABLE_MOVED, PROC_REF(clear_chambered))

/obj/item/gun/ballistic/revolver/shoot_with_empty_chamber(mob/living/user as mob|obj)
	..()
	chamber_round()

/obj/item/gun/ballistic/revolver/click_alt(mob/user)
	spin()
	return CLICK_ACTION_SUCCESS

/obj/item/gun/ballistic/revolver/fire_sounds()
	var/frequency_to_use = sin((90/magazine?.max_ammo) * get_ammo(TRUE, FALSE)) // fucking REVOLVERS
	var/click_frequency_to_use = 1 - frequency_to_use * 0.75
	var/play_click = sqrt(magazine?.max_ammo) > get_ammo(TRUE, FALSE)
	if(suppressed)
		playsound(src, suppressed_sound, suppressed_volume, vary_fire_sound, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
		if(play_click)
			playsound(src, 'sound/weapons/gun/general/ballistic_click.ogg', suppressed_volume, vary_fire_sound, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0, frequency = click_frequency_to_use)
	else
		playsound(src, fire_sound, fire_sound_volume, vary_fire_sound)
		if(play_click)
			playsound(src, 'sound/weapons/gun/general/ballistic_click.ogg', fire_sound_volume, vary_fire_sound, frequency = click_frequency_to_use)


/obj/item/gun/ballistic/revolver/verb/spin()
	set name = "旋转弹巢"
	set category = "物件"
	set desc = "点击旋转左轮手枪的枪膛."

	var/mob/user = usr

	if(user.stat || !in_range(user, src))
		return

	if (recent_spin > world.time)
		return
	recent_spin = world.time + spin_delay

	if(do_spin())
		playsound(usr, SFX_REVOLVER_SPIN, 30, FALSE)
		visible_message(span_notice("[user]旋转[src]的弹巢."), span_notice("你旋转了[src]的弹巢."))
		balloon_alert(user, "弹巢旋转")
	else
		verbs -= /obj/item/gun/ballistic/revolver/verb/spin

/obj/item/gun/ballistic/revolver/proc/do_spin()
	var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
	. = istype(C)
	if(.)
		C.spin()
		chamber_round(spin_cylinder = FALSE)

/obj/item/gun/ballistic/revolver/get_ammo(countchambered = FALSE, countempties = TRUE)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/gun/ballistic/revolver/examine(mob/user)
	. = ..()
	var/live_ammo = get_ammo(FALSE, FALSE)
	. += "[live_ammo ? live_ammo : "零"]发实弹."
	if (current_skin)
		. += "<b>Alt加左键</b>旋转弹巢"

/obj/item/gun/ballistic/revolver/ignition_effect(atom/A, mob/user)
	if(last_fire && last_fire + 15 SECONDS > world.time)
		. = span_notice("[user]触摸[src]到[A]的末端，利用余热点燃了它，产生了一股厌恶. 真是个坏蛋.")

/obj/item/gun/ballistic/revolver/c38
	name = ".38 左轮手枪"
	desc = "经典的致命武器，可以使用.38特制子弹."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38
	icon_state = "c38"
	fire_sound = 'sound/weapons/gun/revolver/shot.ogg'

/obj/item/gun/ballistic/revolver/c38/detective
	name = "柯尔特警探型左轮手枪"
	desc = "经典的执法武器，可以使用.38特制子弹. 有传言说，用扳手松开枪管，你将‘改进’这把枪."

	can_modify_ammo = TRUE
	initial_caliber = CALIBER_38
	initial_fire_sound = 'sound/weapons/gun/revolver/shot.ogg'
	alternative_caliber = CALIBER_357
	alternative_fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	alternative_ammo_misfires = TRUE
	misfire_probability = 0
	misfire_percentage_increment = 25 //about 1 in 4 rounds, which increases rapidly every shot

	obj_flags = UNIQUE_RENAME
	unique_reskin = list(
		"原厂" = "c38",
		"菲茨特辑" = "c38_fitz",
		"警正特辑" = "c38_police",
		"法蓝钢" = "c38_blued",
		"不锈钢" = "c38_stainless",
		"金边" = "c38_trim",
		"黄金" = "c38_gold",
		"和平缔造者" = "c38_peacemaker",
		"黑豹" = "c38_panther"
	)

/obj/item/gun/ballistic/revolver/syndicate
	name = "辛迪加左轮"
	desc = "Waffle公司生产的现代化7发左轮手枪，使用.357弹药."
	icon_state = "revolversyndie"

/obj/item/gun/ballistic/revolver/syndicate/nuclear
	pin = /obj/item/firing_pin/implant/pindicate

/obj/item/gun/ballistic/revolver/syndicate/cowboy
	desc = "一把经典的左轮手枪，经过翻新以供现代使用，使用.357子弹."
	//There's already a cowboy sprite in there!
	icon_state = "lucky"

/obj/item/gun/ballistic/revolver/syndicate/cowboy/nuclear
	pin = /obj/item/firing_pin/implant/pindicate

/obj/item/gun/ballistic/revolver/mateba
	name = "尤尼卡6自动左轮"
	desc = "一种复古的大口径自动左轮手枪，通常由新俄罗斯军队的军官使用，使用.357子弹."
	icon_state = "mateba"

/obj/item/gun/ballistic/revolver/golden
	name = "黄金左轮"
	desc = "这不是游戏，这不是表演，我很乐意干掉你认识的最年长的女人. 使用.357子弹."
	icon_state = "goldrevolver"
	fire_sound = 'sound/weapons/resonator_blast.ogg'
	recoil = 8
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/nagant
	name = "纳甘左轮"
	desc = "原产于俄罗斯的老式左轮手枪，使用7.62x38mmR弹药."
	icon_state = "nagant"
	can_suppress = TRUE

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rev762


// A gun to play Russian Roulette!
// You can spin the chamber to randomize the position of the bullet.

/obj/item/gun/ballistic/revolver/russian
	name = "俄制左轮"
	desc = "一种俄国制造的左轮手枪，用于酒局游戏. 使用.357子弹，每次扣动扳机前都要旋转枪膛."
	icon_state = "russianrevolver"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rus357
	var/spun = FALSE
	hidden_chambered = TRUE //Cheater.
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/ballistic/revolver/russian/do_spin()
	. = ..()
	if(.)
		spun = TRUE

/obj/item/gun/ballistic/revolver/russian/attackby(obj/item/A, mob/user, params)
	..()
	if(get_ammo() > 0)
		spin()
	update_appearance()
	A.update_appearance()
	return

/obj/item/gun/ballistic/revolver/russian/can_trigger_gun(mob/living/user, akimbo_usage)
	if(akimbo_usage)
		return FALSE
	return ..()

/obj/item/gun/ballistic/revolver/russian/attack_self(mob/user)
	if(!spun)
		spin()
		spun = TRUE
		return
	..()

/obj/item/gun/ballistic/revolver/russian/fire_gun(atom/target, mob/living/user, flag, params)
	. = ..(null, user, flag, params)

	var/tk_controlled = FALSE
	if(flag)
		if(!(target in user.contents) && ismob(target))
			if(user.combat_mode) // Flogging action
				return
	else if (HAS_TRAIT_FROM_ONLY(src, TRAIT_TELEKINESIS_CONTROLLED, REF(user))) // if we're far away, you can still fire it at yourself if you have TK.
		tk_controlled = TRUE

	if(isliving(user))
		if(!can_trigger_gun(user))
			return
	if(target != user)
		playsound(src, dry_fire_sound, 30, TRUE)
		user.visible_message(
			span_danger("[user.name]试图同时触发[src]，但只成功地让自己看起来像个白痴."),
			span_danger("[src]的反战斗机制可以防止你向任何人开火，除了你自己!"),
		)
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!spun)
			to_chat(user, span_warning("你得先旋转[src]的弹巢!"))
			return

		spun = FALSE

		var/zone = check_zone(user.zone_selected)
		var/obj/item/bodypart/affecting = H.get_bodypart(zone)
		var/is_target_face = zone == BODY_ZONE_HEAD || zone == BODY_ZONE_PRECISE_EYES || zone == BODY_ZONE_PRECISE_MOUTH
		var/loaded_rounds = get_ammo(FALSE, FALSE) // check before it is fired

		if(HAS_TRAIT(user, TRAIT_CURSED)) // I cannot live, I cannot die, trapped in myself, body my holding cell.
			to_chat(user, span_warning("多么可怕的夜晚...有诅咒!"))
			return

		if(loaded_rounds && is_target_face)
			add_memory_in_range(user, 7, /datum/memory/witnessed_russian_roulette, \
				protagonist = user, \
				antagonist = src, \
				rounds_loaded = loaded_rounds, \
				aimed_at =  affecting.name, \
				result = (chambered ? "输了" : "赢了"), \
			)

		if(chambered)
			var/obj/item/ammo_casing/AC = chambered
			if(AC.fire_casing(user, user, params, distro = 0, quiet = 0, zone_override = null, spread = 0, fired_from = src))
				playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
				if(is_target_face)
					shoot_self(user, affecting)
				else if(tk_controlled) // the consequence of you doing the telekinesis stuff
					to_chat(user, span_userdanger("当你的注意力集中在左轮手枪上时，你意识到它指向你的头有点太晚了!"))
					shoot_self(user, BODY_ZONE_HEAD)
				else
					user.visible_message(span_danger("[user.name]向[affecting.name]上懦弱地发射[src]!"), span_userdanger("你向[affecting.name]上懦弱地发射[src]!"), span_hear("你听到一声枪响!"))
				chambered = null
				user.add_mood_event("russian_roulette_lose", /datum/mood_event/russian_roulette_lose)
				return

		if(loaded_rounds && is_target_face)
			user.add_mood_event("russian_roulette_win", /datum/mood_event/russian_roulette_win, loaded_rounds)

		user.visible_message(span_danger("*click*"))
		playsound(src, dry_fire_sound, 30, TRUE)

/obj/item/gun/ballistic/revolver/russian/proc/shoot_self(mob/living/carbon/human/user, affecting = BODY_ZONE_HEAD)
	user.apply_damage(300, BRUTE, affecting)
	user.visible_message(span_danger("[user.name]用[src]向自己的头部开火!"), span_userdanger("你用[src]向自己的头部开火!"), span_hear("你听到一声枪响!"))

/obj/item/gun/ballistic/revolver/russian/soul
	name = "被诅咒的俄制左轮"
	desc = "玩这把左轮手枪需要赌上你的灵魂."

/obj/item/gun/ballistic/revolver/russian/soul/shoot_self(mob/living/user)
	. = ..()
	var/obj/item/soulstone/anybody/revolver/stone = new /obj/item/soulstone/anybody/revolver(get_turf(src))
	if(!stone.capture_soul(user, forced = TRUE)) //Something went wrong
		qdel(stone)
		return
	user.visible_message(span_danger("[user.name]的灵魂被[src]没收了!"), span_userdanger("你输掉了赌博! 你输掉了自己的灵魂!"))

/obj/item/gun/ballistic/revolver/reverse //Fires directly at its user... unless the user is a clown, of course.
	name = /obj/item/gun/ballistic/revolver/syndicate::name
	desc = /obj/item/gun/ballistic/revolver/syndicate::desc
	clumsy_check = FALSE
	icon_state = "revolversyndie"

/obj/item/gun/ballistic/revolver/reverse/can_trigger_gun(mob/living/user, akimbo_usage)
	if(akimbo_usage)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_CLUMSY) || is_clown_job(user.mind?.assigned_role))
		return ..()
	if(process_fire(user, user, FALSE, null, BODY_ZONE_HEAD))
		user.visible_message(span_warning("[user]不知何故没法射击自己的脸!"), span_userdanger("你竟然朝自己脸上开了一枪!怎么回事?!"))
		user.emote("scream")
		user.drop_all_held_items()
		user.Paralyze(80)

/obj/item/gun/ballistic/revolver/reverse/mateba
	name = /obj/item/gun/ballistic/revolver/mateba::name
	desc = /obj/item/gun/ballistic/revolver/mateba::desc
	clumsy_check = FALSE
	icon_state = "mateba"

