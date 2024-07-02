// The mawed crucible, a heretic structure that can create potions from bodyparts and organs.
/obj/structure/destructible/eldritch_crucible
	name = "喰食坩埚"
	desc = "一口铸铁制成的大锅，被钢铁般的牙齿固定住. \
		只是凝视着其中的邪恶汁液，可怕的想法就会充满你的脑海."
	icon = 'icons/obj/antags/eldritch.dmi'
	icon_state = "crucible"
	base_icon_state = "crucible"
	break_sound = 'sound/hallucinations/wail.ogg'
	light_power = 1
	anchored = TRUE
	density = TRUE
	///How much mass this currently holds
	var/current_mass = 5
	///Maximum amount of mass
	var/max_mass = 5
	///Check to see if it is currently being used.
	var/in_use = FALSE

/obj/structure/destructible/eldritch_crucible/Initialize(mapload)
	. = ..()
	break_message = span_warning("[src]砰的一声裂开了!")

/obj/structure/destructible/eldritch_crucible/atom_deconstruct(disassembled = TRUE)
	// Create a spillage if we were destroyed with leftover mass
	if(current_mass)
		break_message = span_warning("[src]砰的一声裂开了，闪闪发光的汁液洒得到处都是!")
		var/turf/our_turf = get_turf(src)

		new /obj/effect/decal/cleanable/greenglow(our_turf)
		for(var/turf/nearby_turf as anything in get_adjacent_open_turfs(our_turf))
			if(prob(10 * current_mass))
				new /obj/effect/decal/cleanable/greenglow(nearby_turf)
		playsound(our_turf, 'sound/effects/bubbles2.ogg', 50, TRUE)

	return ..()

/obj/structure/destructible/eldritch_crucible/examine(mob/user)
	. = ..()
	if(!IS_HERETIC_OR_MONSTER(user) && !isobserver(user))
		return

	if(current_mass < max_mass)
		var/to_fill = max_mass - current_mass
		. += span_notice("[src]需要<b>[to_fill]</b>以上的器官或身体部位.")
	else
		. += span_boldnotice("[src]里的粘稠液体溢满边缘，正冒着泡泡准备下次使用.")

	. += span_notice("你可以用<b>疤痕法典</b>或<b>漫宿之握</b>将[src]<b>[anchored ? "解除固定":"固定在原地"]</b>.")
	. += span_info("可调制下列药水:")
	for(var/obj/item/eldritch_potion/potion as anything in subtypesof(/obj/item/eldritch_potion))
		var/potion_string = span_info(initial(potion.name) + " - " + initial(potion.crucible_tip))
		. += potion_string

/obj/structure/destructible/eldritch_crucible/examine_status(mob/user)
	if(IS_HERETIC_OR_MONSTER(user) || isobserver(user))
		return span_notice("它处于<b>[round(atom_integrity * 100 / max_integrity)]%</b>的稳定度.")
	return ..()

/obj/structure/destructible/eldritch_crucible/attacked_by(obj/item/weapon, mob/living/user)
	if(!iscarbon(user))
		return ..()

	if(!IS_HERETIC_OR_MONSTER(user))
		bite_the_hand(user)
		return TRUE

	if(istype(weapon, /obj/item/codex_cicatrix) || istype(weapon, /obj/item/melee/touch_attack/mansus_fist))
		playsound(src, 'sound/items/deconstruct.ogg', 30, TRUE, ignore_walls = FALSE)
		set_anchored(!anchored)
		balloon_alert(user, "[anchored ? "":"解除"]固定")
		return TRUE

	if(isbodypart(weapon))

		var/obj/item/bodypart/consumed = weapon
		if(!IS_ORGANIC_LIMB(consumed))
			balloon_alert(user, "不是有机的!")
			return

		consume_fuel(user, consumed)
		return TRUE

	if(isorgan(weapon))
		var/obj/item/organ/consumed = weapon
		if(!IS_ORGANIC_ORGAN(consumed))
			balloon_alert(user, "不是有机的!")
			return
		if(consumed.organ_flags & ORGAN_VITAL) // Basically, don't eat organs like brains
			balloon_alert(user, "无效器官!")
			return

		consume_fuel(user, consumed)
		return TRUE

	return ..()

/obj/structure/destructible/eldritch_crucible/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(!isliving(user))
		return

	if(!IS_HERETIC_OR_MONSTER(user))
		if(iscarbon(user))
			bite_the_hand(user)
		return TRUE

	if(in_use)
		balloon_alert(user, "在使用中!")
		return TRUE

	if(current_mass < max_mass)
		balloon_alert(user, "不够饱!")
		return TRUE

	INVOKE_ASYNC(src, PROC_REF(show_radial), user)
	return TRUE

/*
 * Wrapper for show_radial() to ensure in_use is enabled and disabled correctly.
 */
/obj/structure/destructible/eldritch_crucible/proc/show_radial(mob/living/user)
	in_use = TRUE
	create_potion(user)
	in_use = FALSE

/*
 * Shows the user of radial of possible potions,
 * and create the potion they chose.
 */
/obj/structure/destructible/eldritch_crucible/proc/create_potion(mob/living/user)

	// Assoc list of [name] to [image] for the radial
	var/static/list/choices = list()
	// Assoc list of [name] to [path] for after the radial, to spawn it
	var/static/list/names_to_path = list()
	if(!choices.len || !names_to_path.len)
		for(var/obj/item/eldritch_potion/potion as anything in subtypesof(/obj/item/eldritch_potion))
			names_to_path[initial(potion.name)] = potion
			choices[initial(potion.name)] = image(icon = initial(potion.icon), icon_state = initial(potion.icon_state))

	var/picked_choice = show_radial_menu(
		user,
		src,
		choices,
		require_near = TRUE,
		tooltips = TRUE,
		)

	if(isnull(picked_choice))
		return

	var/spawned_type = names_to_path[picked_choice]
	if(!ispath(spawned_type, /obj/item/eldritch_potion))
		CRASH("[type] attempted to create a potion that wasn't an eldritch potion! (got: [spawned_type])")

	var/obj/item/spawned_pot = new spawned_type(drop_location())

	playsound(src, 'sound/misc/desecration-02.ogg', 75, TRUE)
	visible_message(span_notice("[src]的发光液体流入烧瓶，一瓶[spawned_pot.name]做好了!"))
	balloon_alert(user, "药水已制造")

	current_mass = 0
	update_appearance(UPDATE_ICON_STATE)

/*
 * "Bites the hand that feeds it", except more literally.
 * Called when a non-heretic interacts with the crucible,
 * causing them to lose their active hand to it.
 */
/obj/structure/destructible/eldritch_crucible/proc/bite_the_hand(mob/living/carbon/user)
	if(HAS_TRAIT(user, TRAIT_NODISMEMBER))
		return

	var/obj/item/bodypart/arm = user.get_active_hand()
	if(QDELETED(arm))
		return

	to_chat(user, span_userdanger("[src]抓住你的[arm.name]!"))
	arm.dismember()
	consume_fuel(consumed = arm)

/*
 * Consumes an organ or bodypart and increases the mass of the crucible.
 * If feeder is supplied, gives some feedback.
 */
/obj/structure/destructible/eldritch_crucible/proc/consume_fuel(mob/living/feeder, obj/item/consumed)
	if(current_mass >= max_mass)
		if(feeder)
			balloon_alert(feeder, "坩埚饱了!")
		return

	current_mass++
	playsound(src, 'sound/items/eatfood.ogg', 100, TRUE)
	visible_message(span_notice("[src]吞食了[consumed]，锅内增加了少许液体!"))

	if(feeder)
		balloon_alert(feeder, "坩埚胃口 ([current_mass] / [max_mass])")

	qdel(consumed)
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/destructible/eldritch_crucible/update_icon_state()
	icon_state = "[base_icon_state][(current_mass == max_mass) ? null : "_empty"]"
	return ..()

// Potions created by the mawed crucible.
/obj/item/eldritch_potion
	name = "日与夜的药水"
	desc = "你不应该看到这个."
	icon = 'icons/obj/antags/eldritch.dmi'
	w_class = WEIGHT_CLASS_SMALL
	/// When a heretic examines a mawed crucible, shows a list of possible potions by name + includes this tip to explain what it does.
	var/crucible_tip = "不会做任何事情."
	/// Typepath to the status effect this applies
	var/status_effect

/obj/item/eldritch_potion/examine(mob/user)
	. = ..()
	if(!IS_HERETIC_OR_MONSTER(user) && !isobserver(user))
		return

	. += span_notice(crucible_tip)

/obj/item/eldritch_potion/attack_self(mob/user)
	. = ..()
	if(.)
		return

	if(!iscarbon(user))
		return

	playsound(src, 'sound/effects/bubbles.ogg', 50, TRUE)

	if(!IS_HERETIC_OR_MONSTER(user))
		to_chat(user, span_danger("你喝下[src]中的液体，味道让你感到恶心，喝完后瓶子也消失了."))
		user.reagents?.add_reagent(/datum/reagent/eldritch, 10)
		user.adjust_disgust(50)
		qdel(src)
		return TRUE

	to_chat(user, span_notice("你喝下[src]中的粘稠液体，喝完后瓶子也消失了."))
	potion_effect(user)
	qdel(src)
	return TRUE

/**
 * The effect of the potion, if it has any special one.
 * In general try not to override this
 * and utilize the status_effect var to make custom effects.
 */
/obj/item/eldritch_potion/proc/potion_effect(mob/user)
	var/mob/living/carbon/carbon_user = user
	carbon_user.apply_status_effect(status_effect)

/obj/item/eldritch_potion/crucible_soul
	name = "坩埚之魂的药水"
	desc = "装有亮橙色半透明液体的玻璃瓶."
	icon_state = "crucible_soul"
	status_effect = /datum/status_effect/crucible_soul
	crucible_tip = "喝下后15秒内你可以穿墙移动，持续时间结束后传送回原来的位置."

/obj/item/eldritch_potion/duskndawn
	name = "黄昏与黎明的药水"
	desc = "装有暗黄色液体的玻璃瓶，随着某种规律时隐时现."
	icon_state = "clarity"
	status_effect = /datum/status_effect/duskndawn
	crucible_tip = "喝下后60秒内可以透视墙壁与物体."

/obj/item/eldritch_potion/wounded
	name = "伤兵的药水"
	desc = "装有无色、暗淡的液体的玻璃瓶."
	icon_state = "marshal"
	status_effect = /datum/status_effect/marshal
	crucible_tip = "喝下后60秒内，你的重伤口将会产生治疗效果，骨折、扭伤、切口和穿刺伤将治疗创伤，肉体损伤将治愈烧伤. 伤势越严重，治愈力越强.\
		此外在时效内还能消除你受伤导致的减速. "
