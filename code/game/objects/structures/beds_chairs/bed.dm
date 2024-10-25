/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * Beds
 * Medical beds
 * Roller beds
 * Pet beds
 */

/// Beds
/obj/structure/bed
	name = "床"
	desc = "用来躺在上面, 睡觉或者绑在上面."
	icon_state = "bed"
	icon = 'icons/obj/bed.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	resistance_flags = FLAMMABLE
	max_integrity = 100
	integrity_failure = 0.35
	/// What material this bed is made of
	var/build_stack_type = /obj/item/stack/sheet/iron
	/// How many mats to drop when deconstructed
	var/build_stack_amount = 2
	/// Mobs standing on it are nudged up by this amount. Also used to align the person back when buckled to it after init.
	var/elevation = 8

/obj/structure/bed/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/soft_landing)
	if(elevation)
		AddElement(/datum/element/elevation, pixel_shift = elevation)
	register_context()

/obj/structure/bed/examine(mob/user)
	. = ..()
	. += span_notice("它由几个<b>螺栓</b>固定在一起.")

/obj/structure/bed/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(held_item)
		if(held_item.tool_behaviour != TOOL_WRENCH)
			return

		context[SCREENTIP_CONTEXT_RMB] = "拆除"
		return CONTEXTUAL_SCREENTIP_SET

	else if(has_buckled_mobs())
		context[SCREENTIP_CONTEXT_LMB] = "Unbuckle"
		return CONTEXTUAL_SCREENTIP_SET

/obj/structure/bed/atom_deconstruct(disassembled = TRUE)
	if(build_stack_type)
		new build_stack_type(loc, build_stack_amount)

/obj/structure/bed/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/bed/wrench_act_secondary(mob/living/user, obj/item/weapon)
	..()
	weapon.play_tool_sound(src)
	deconstruct(disassembled = TRUE)
	return TRUE

/// Medical beds
/obj/structure/bed/medical
	name = "医疗床"
	icon = 'icons/obj/medical/medical_bed.dmi'
	desc = "一张带有轮子的医疗床, 用于辅助患者移动或举办医疗部漂移大赛."
	icon_state = "med_down"
	base_icon_state = "med"
	anchored = FALSE
	resistance_flags = NONE
	build_stack_type = /obj/item/stack/sheet/mineral/titanium
	build_stack_amount = 1
	elevation = 0
	/// The item it spawns when it's folded up.
	var/foldable_type

/obj/structure/bed/medical/anchored
	anchored = TRUE

/obj/structure/bed/medical/emergency
	name = "紧急医疗床"
	desc = "一张紧凑的医疗床. 这款紧急版本可以折叠并放进包里携带, 以便快速运输."
	icon_state = "emerg_down"
	base_icon_state = "emerg"
	foldable_type = /obj/item/emergency_bed

/obj/structure/bed/medical/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noisy_movement)
	if(anchored)
		update_appearance()

/obj/structure/bed/medical/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	context[SCREENTIP_CONTEXT_ALT_LMB] = "[anchored ? "关闭制动器" : "启动制动器"]"
	if(!isnull(foldable_type) && !has_buckled_mobs())
		context[SCREENTIP_CONTEXT_RMB] = "折起"

	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/bed/medical/examine(mob/user)
	. = ..()
	if(anchored)
		. += span_notice("制动器被启动了. 可以通过Alt+LMB关闭制动器.")
	else
		. += span_notice("制动器可以通过Alt+LMB启动.")

	if(!isnull(foldable_type))
		. += span_notice("你可以通过RMB将它折叠起来.")

/obj/structure/bed/medical/click_alt(mob/user)
	if(has_buckled_mobs() && (user in buckled_mobs))
		return CLICK_ACTION_BLOCKING

	anchored = !anchored
	balloon_alert(user, "制动器 [anchored ? "启动" : "关闭"]")
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/structure/bed/medical/post_buckle_mob(mob/living/buckled)
	. = ..()
	set_density(TRUE)
	update_appearance()

/obj/structure/bed/medical/post_unbuckle_mob(mob/living/buckled)
	. = ..()
	set_density(FALSE)
	update_appearance()

/obj/structure/bed/medical/update_icon_state()
	. = ..()
	if(has_buckled_mobs())
		icon_state = "[base_icon_state]_up"
		// Push them up from the normal lying position
		if(buckled_mobs.len > 1)
			for(var/mob/living/patient as anything in buckled_mobs)
				patient.pixel_y = patient.base_pixel_y
		else
			buckled_mobs[1].pixel_y = buckled_mobs[1].base_pixel_y
	else
		icon_state = "[base_icon_state]_down"

/obj/structure/bed/medical/update_overlays()
	. = ..()
	if(!anchored)
		return

	if(has_buckled_mobs())
		. += mutable_appearance(icon, "brakes_up")
		. += emissive_appearance(icon, "brakes_up", src, alpha = src.alpha)
	else
		. += mutable_appearance(icon, "brakes_down")
		. += emissive_appearance(icon, "brakes_down", src, alpha = src.alpha)

/obj/structure/bed/medical/emergency/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/emergency_bed/silicon))
		var/obj/item/emergency_bed/silicon/silicon_bed = item
		if(silicon_bed.loaded)
			to_chat(user, span_warning("你的床坞内已经储存了一张医疗床!"))
			return

		if(has_buckled_mobs())
			if(buckled_mobs.len > 1)
				unbuckle_all_mobs()
				user.visible_message(span_notice("[user] unbuckles all creatures from [src]."))
			else
				user_unbuckle_mob(buckled_mobs[1],user)
		else
			silicon_bed.loaded = src
			forceMove(silicon_bed)
			user.visible_message(span_notice("[user] 收集了 [src]."), span_notice("你收集了 [src]."))
		return TRUE
	else
		return ..()

/obj/structure/bed/medical/emergency/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!ishuman(user) || !user.can_perform_action(src))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(has_buckled_mobs())
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	user.visible_message(span_notice("[user] collapses [src]."), span_notice("You collapse [src]."))
	var/obj/structure/bed/medical/emergency/folding_bed = new foldable_type(get_turf(src))
	user.put_in_hands(folding_bed)
	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/emergency_bed
	name = "滚轮床"
	desc = "一张可随身携带的折叠医疗床."
	icon = 'icons/obj/medical/medical_bed.dmi'
	icon_state = "emerg_folded"
	inhand_icon_state = "emergencybed"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL // No more excuses, stop getting blood everywhere

/obj/item/emergency_bed/attackby(obj/item/item, mob/living/user, params)
	if(istype(item, /obj/item/emergency_bed/silicon))
		var/obj/item/emergency_bed/silicon/silicon_bed = item
		if(silicon_bed.loaded)
			to_chat(user, span_warning("[silicon_bed] already has a roller bed loaded!"))
			return

		user.visible_message(span_notice("[user] loads [src]."), span_notice("You load [src] into [silicon_bed]."))
		silicon_bed.loaded = new/obj/structure/bed/medical/emergency(silicon_bed)
		qdel(src) //"Load"
		return

	else
		return ..()

/obj/item/emergency_bed/attack_self(mob/user)
	deploy_bed(user, user.loc)

/obj/item/emergency_bed/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isopenturf(interacting_with))
		deploy_bed(user, interacting_with)
		return ITEM_INTERACT_SUCCESS
	return NONE


/obj/item/emergency_bed/proc/deploy_bed(mob/user, atom/location)
	var/obj/structure/bed/medical/emergency/deployed = new /obj/structure/bed/medical/emergency(location)
	deployed.add_fingerprint(user)
	qdel(src)

/obj/item/emergency_bed/silicon // ROLLER ROBO DA!
	name = "紧急医疗床坞"
	desc = "一个存储紧急医疗床的床坞, 可以弹出床以备紧急使用. 弹出后须收集或更换."
	var/obj/structure/bed/medical/emergency/loaded = null

/obj/item/emergency_bed/silicon/Initialize(mapload)
	. = ..()
	loaded = new(src)

/obj/item/emergency_bed/silicon/examine(mob/user)
	. = ..()
	. += "床坞内 [loaded ? "储存了一张床" : "是空的"]."

/obj/item/emergency_bed/silicon/deploy_bed(mob/user, atom/location)
	if(loaded)
		loaded.forceMove(location)
		user.visible_message(span_notice("[user] deploys [loaded]."), span_notice("You deploy [loaded]."))
		loaded = null
	else
		to_chat(user, span_warning("床坞是空的!"))

/// Dog bed
/obj/structure/bed/dogbed
	name = "狗床"
	icon_state = "dogbed"
	desc = "一张看起来很舒服的狗床. 你可以将你的宠物绑在上面, 防止重力发生器暂时停机的情况出现."
	anchored = FALSE
	build_stack_type = /obj/item/stack/sheet/mineral/wood
	build_stack_amount = 10
	elevation = 0
	var/owned = FALSE

/obj/structure/bed/dogbed/ian
	desc = "Ian的床! 看起来很舒服."
	name = "Ian的床"
	anchored = TRUE

/obj/structure/bed/dogbed/cayenne
	desc = "Seems kind of... fishy."
	name = "Cayenne的床"
	anchored = TRUE

/obj/structure/bed/dogbed/misha
	desc = "这上面到处都是绒毛, 以及一些血迹..."
	name = "Misha的床"
	anchored = TRUE

/obj/structure/bed/dogbed/lia
	desc = "似乎有股... 可疑的鱼腥味."
	name = "Lia的床"
	anchored = TRUE

/obj/structure/bed/dogbed/renault
	desc = "Renault的床! 看起来很舒服. 一个狡猾的人需要一个像狐狸一样狡猾的宠物."
	name = "Renault的床"
	anchored = TRUE

/obj/structure/bed/dogbed/mcgriff
	desc = "McGriff'的床, 有时候罪犯打击者也需要打个盹."
	name = "McGriff的床"

/obj/structure/bed/dogbed/runtime
	desc = "一张看起来很舒服的猫床. 你可以将你的宠物绑在上面, 防止重力发生器暂时停机的情况出现."
	name = "Runtime的床"
	anchored = TRUE

///Used to set the owner of a dogbed, returns FALSE if called on an owned bed or an invalid one, TRUE if the possesion succeeds
/obj/structure/bed/dogbed/proc/update_owner(mob/living/furball)
	if(owned || type != /obj/structure/bed/dogbed) //Only marked beds work, this is hacky but I'm a hacky man
		return FALSE //Failed

	owned = TRUE
	name = "[furball]的床"
	desc = "[furball]的床! 看起来很舒服."
	return TRUE // Let any callers know that this bed is ours now

/obj/structure/bed/dogbed/buckle_mob(mob/living/furball, force, check_loc)
	. = ..()
	update_owner(furball)

/obj/structure/bed/maint
	name = "脏床垫"
	desc = "一张肮脏的旧床垫. 你试着不去想是什么造成了那些污渍."
	icon_state = "dirty_mattress"
	elevation = 7

/obj/structure/bed/maint/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOLD, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 25)

// Double Beds, for luxurious sleeping, i.e. the captain and maybe heads- if people use this for ERP, send them to skyrat
/obj/structure/bed/double
	name = "双人床"
	desc = "一张豪华的双人床, 对于那些不屑于做小梦的人."
	icon_state = "bed_double"
	build_stack_amount = 4
	max_buckled_mobs = 2
	/// The mob who buckled to this bed second, to avoid other mobs getting pixel-shifted before he unbuckles.
	var/mob/living/goldilocks

/obj/structure/bed/double/post_buckle_mob(mob/living/target)
	. = ..()
	if(buckled_mobs.len > 1 && !goldilocks) // Push the second buckled mob a bit higher from the normal lying position
		target.pixel_y += 6
		goldilocks = target

/obj/structure/bed/double/post_unbuckle_mob(mob/living/target)
	. = ..()
	if(target == goldilocks)
		target.pixel_y -= 6
		goldilocks = null
