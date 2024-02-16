/obj/item/crowbar
	name = "口袋撬棍"
	desc = "一根小撬棍.这把趁手的工具对做很多事情都很有用,比如撬开地砖或者无动力门."
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar"
	inhand_icon_state = "crowbar"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	usesound = 'sound/items/crowbar.ogg'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	demolition_mod = 1.25
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5)
	drop_sound = 'sound/items/handling/crowbar_drop.ogg'
	pickup_sound = 'sound/items/handling/crowbar_pickup.ogg'

	attack_verb_continuous = list("attacks", "bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("attack", "bash", "batter", "bludgeon", "whack")
	tool_behaviour = TOOL_CROWBAR
	toolspeed = 1
	armor_type = /datum/armor/item_crowbar
	var/force_opens = FALSE

/datum/armor/item_crowbar
	fire = 50
	acid = 30

/obj/item/crowbar/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/falling_hazard, damage = force, wound_bonus = wound_bonus, hardhat_safety = TRUE, crushes = FALSE, impact_sound = hitsound)

/obj/item/crowbar/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正在用[src]活活把[user.p_them()]自己打到死!看上去[user.p_theyre()]试图自杀!"))
	playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1)
	return BRUTELOSS

/obj/item/crowbar/red
	icon_state = "crowbar_red"
	inhand_icon_state = "crowbar_red"
	force = 8

/obj/item/crowbar/abductor
	name = "外星撬棍"
	desc = "一根坚硬轻巧的撬棍.它似乎不需要任何外力就能自己撬动."
	icon = 'icons/obj/antags/abductor.dmi'
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT)
	icon_state = "crowbar"
	belt_icon_state = "crowbar_alien"
	toolspeed = 0.1


/obj/item/crowbar/large
	name = "大撬棍"
	desc = "这是一把大撬棍.它放不进你的口袋里，因为它太大了."
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 3
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.7)
	icon_state = "crowbar_large"
	worn_icon_state = "crowbar"
	toolspeed = 0.7

/obj/item/crowbar/large/emergency
	name = "应急撬棍"
	desc = "这是一把笨重的撬棍.它似乎是被故意设计成不能放进背包里的."
	w_class = WEIGHT_CLASS_BULKY

/obj/item/crowbar/hammer
	name = "羊角锤"
	desc = "这是一把沉重的锤子，锤头另一侧带有撬棍。虽然钉子在太空中并不常见，但这把工具仍然可以用作武器或撬棍."
	force = 11
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'icons/obj/weapons/hammer.dmi'
	icon_state = "clawhammer"
	lefthand_file = 'icons/mob/inhands/weapons/hammers_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/hammers_righthand.dmi'
	inhand_icon_state = "clawhammer"
	belt_icon_state = "clawhammer"
	throwforce = 10
	throw_range = 5
	throw_speed = 3
	toolspeed = 2
	custom_materials = list(/datum/material/wood=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/iron=SMALL_MATERIAL_AMOUNT*0.7)
	wound_bonus = 35

/obj/item/crowbar/large/heavy //from space ruin
	name = "重型撬棍"
	desc = "这是一把大撬棍.它放不进你的口袋里,因为它很大.拿起来感觉异常地沉重..."
	force = 20
	icon_state = "crowbar_powergame"
	inhand_icon_state = "crowbar_red"

/obj/item/crowbar/large/old
	name = "旧式撬棍"
	desc = "这是一把老撬棍.比那些口袋大小的要大得多,也重得多.他们已经不再做这种结实耐用的工具了."
	throwforce = 10
	throw_speed = 2

/obj/item/crowbar/large/old/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "crowbar_powergame"

/obj/item/crowbar/power
	name = "救生颚"
	desc = "一副被科学的魔力压缩的生命之颚."
	icon_state = "jaws"
	inhand_icon_state = "jawsoflife"
	worn_icon_state = "jawsoflife"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2.25, /datum/material/silver = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/titanium = SHEET_MATERIAL_AMOUNT*1.75)
	usesound = 'sound/items/jaws_pry.ogg'
	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7
	force_opens = TRUE
	/// Used on Initialize, how much time to cut cable restraints and zipties.
	var/snap_time_weak_handcuffs = 0 SECONDS
	/// Used on Initialize, how much time to cut real handcuffs. Null means it can't.
	var/snap_time_strong_handcuffs = 0 SECONDS

/obj/item/crowbar/power/get_all_tool_behaviours()
	return list(TOOL_CROWBAR, TOOL_WIRECUTTER)

/obj/item/crowbar/power/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE, \
		inhand_icon_change = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between crowbar and wirecutters and gives feedback to the user.
 */
/obj/item/crowbar/power/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_WIRECUTTER : TOOL_CROWBAR)
	if(user)
		balloon_alert(user, "attached [active ? "cutting" : "prying"]")
	playsound(src, 'sound/items/change_jaws.ogg', 50, TRUE)
	if(tool_behaviour == TOOL_CROWBAR)
		RemoveElement(/datum/element/cuffsnapping, snap_time_weak_handcuffs, snap_time_strong_handcuffs)
	else
		AddElement(/datum/element/cuffsnapping, snap_time_weak_handcuffs, snap_time_strong_handcuffs)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/crowbar/power/syndicate
	name = "辛迪加救生颚"
	desc = "一个口袋大小的纳米传讯牌救生鄂的再设计复制品. 可以在它的撬棍模式下强行打开气闸."
	icon_state = "jaws_syndie"
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5
	force_opens = TRUE

/obj/item/crowbar/power/examine()
	. = ..()
	. += " It's fitted with a [tool_behaviour == TOOL_CROWBAR ? "prying" : "cutting"] head."

/obj/item/crowbar/power/suicide_act(mob/living/user)
	if(tool_behaviour == TOOL_CROWBAR)
		user.visible_message(span_suicide("[user]正在把[user.p_their()]头部放进[src],看上去[user.p_theyre()]试图自杀!"))
		playsound(loc, 'sound/items/jaws_pry.ogg', 50, TRUE, -1)
	else
		user.visible_message(span_suicide("[user] is wrapping \the [src] around [user.p_their()] neck. It looks like [user.p_theyre()] trying to rip [user.p_their()] head off!"))
		playsound(loc, 'sound/items/jaws_cut.ogg', 50, TRUE, -1)
		if(iscarbon(user))
			var/mob/living/carbon/suicide_victim = user
			var/obj/item/bodypart/target_bodypart = suicide_victim.get_bodypart(BODY_ZONE_HEAD)
			if(target_bodypart)
				target_bodypart.drop_limb()
				playsound(loc, SFX_DESECRATION, 50, TRUE, -1)
	return BRUTELOSS

/obj/item/crowbar/cyborg
	name = "液压撬棍"
	desc = "液压撬具，构造简单但功能强大."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "crowbar_cyborg"
	worn_icon_state = "crowbar"
	usesound = 'sound/items/jaws_pry.ogg'
	force = 10
	toolspeed = 0.5

/obj/item/crowbar/mechremoval
	name = "机甲拆卸工具"
	desc = "一根…非常大的撬棍. 你很肯定它能撬开一台机甲, 但除此之外，它似乎很笨重."
	icon_state = "mechremoval0"
	base_icon_state = "mechremoval"
	inhand_icon_state = null
	icon = 'icons/obj/mechremoval.dmi'
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	toolspeed = 1.25
	armor_type = /datum/armor/crowbar_mechremoval
	resistance_flags = FIRE_PROOF
	bare_wound_bonus = 15
	wound_bonus = 10

/datum/armor/crowbar_mechremoval
	bomb = 100
	fire = 100

/obj/item/crowbar/mechremoval/Initialize(mapload)
	. = ..()
	transform = transform.Translate(0, -8)
	AddComponent(/datum/component/two_handed, force_unwielded = 5, force_wielded = 19, icon_wielded = "[base_icon_state]1")

/obj/item/crowbar/mechremoval/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/obj/item/crowbar/mechremoval/proc/empty_mech(obj/vehicle/sealed/mecha/mech, mob/user)
	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		mech.balloon_alert(user, "not wielded!")
		return
	if(!LAZYLEN(mech.occupants) || (LAZYLEN(mech.occupants) == 1 && mech.mecha_flags & SILICON_PILOT)) //if no occupants, or only an ai
		mech.balloon_alert(user, "it's empty!")
		return
	user.log_message("试图撬开[mech], located at [loc_name(mech)], which is currently occupied by [mech.occupants.Join(", ")].", LOG_ATTACK)
	var/mech_dir = mech.dir
	mech.balloon_alert(user, "撬开中...")
	playsound(mech, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE)
	if(!use_tool(mech, user, mech.enclosed ? 5 SECONDS : 3 SECONDS, volume = 0, extra_checks = CALLBACK(src, PROC_REF(extra_checks), mech, mech_dir)))
		mech.balloon_alert(user, "中断!")
		return
	user.log_message("已撬开[mech], located at [loc_name(mech)], which is currently occupied by [mech.occupants.Join(", ")].", LOG_ATTACK)
	for(var/mob/living/occupant as anything in mech.occupants)
		if(isAI(occupant))
			continue
		mech.mob_exit(occupant, randomstep = TRUE)
	playsound(mech, 'sound/machines/airlockforced.ogg', 75, TRUE)

/obj/item/crowbar/mechremoval/proc/extra_checks(obj/vehicle/sealed/mecha/mech, mech_dir)
	return HAS_TRAIT(src, TRAIT_WIELDED) && LAZYLEN(mech.occupants) && mech.dir == mech_dir
