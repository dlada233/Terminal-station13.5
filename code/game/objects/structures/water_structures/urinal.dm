/obj/structure/urinal
	name = "小便池"
	desc = "HU-452，实验性的小便池，配有实验性的便池块."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE
	/// Can you currently put an item inside
	var/exposed = FALSE
	/// What's in the urinal
	var/obj/item/hidden_item

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/urinal, 32)

/obj/structure/urinal/Initialize(mapload)
	. = ..()
	if(mapload)
		hidden_item = new /obj/item/food/urinalcake(src)
	find_and_hang_on_wall()

/obj/structure/urinal/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == hidden_item)
		hidden_item = null

/obj/structure/urinal/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(user.pulling && isliving(user.pulling))
		var/mob/living/grabbed_mob = user.pulling
		if(user.grab_state >= GRAB_AGGRESSIVE)
			if(grabbed_mob.loc != get_turf(src))
				to_chat(user, span_notice("[grabbed_mob.name]需要位于[src]上面."))
				return
			user.changeNext_move(CLICK_CD_MELEE)
			user.visible_message(span_danger("[user]把[grabbed_mob]砸进[src]!"), span_danger("你把[grabbed_mob]砸进[src]!"))
			grabbed_mob.emote("scream")
			grabbed_mob.adjustBruteLoss(8)
		else
			to_chat(user, span_warning("你需要更紧地抓握!"))
		return

	if(exposed)
		if(hidden_item)
			to_chat(user, span_notice("你从排水盖子里捞出了[hidden_item]."))
			user.put_in_hands(hidden_item)
		else
			to_chat(user, span_warning("排水盖子里没有任何东西!"))
		return
	return ..()

/obj/structure/urinal/attackby(obj/item/attacking_item, mob/user, params)
	if(exposed)
		if(hidden_item)
			to_chat(user, span_warning("排水盖子里已经有东西了!"))
			return
		if(attacking_item.w_class > WEIGHT_CLASS_TINY)
			to_chat(user, span_warning("[attacking_item]对排水盖子来说太大了."))
			return
		if(!user.transferItemToLoc(attacking_item, src))
			to_chat(user, span_warning("[attacking_item]粘在了你的手上，你不能把它放进排水盖子里!"))
			return
		hidden_item = attacking_item
		to_chat(user, span_notice("你把[attacking_item]放进排水盖子里."))
		return
	return ..()

/obj/structure/urinal/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	to_chat(user, span_notice("你开始[exposed ? "把盖子拧回原位" : "拧开排水保护器的盖子"]..."))
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
	if(I.use_tool(src, user, 20))
		user.visible_message(span_notice("[user][exposed ? "把盖子拧回了原位" : "拧开了排水保护器的盖子"]!"),
			span_notice("你[exposed ? "把盖子拧回了原位" : "拧开了排水保护器的盖子"]!"),
			span_hear("你听到了金属挤压的声音."))
		exposed = !exposed
	return TRUE

/obj/structure/urinal/wrench_act_secondary(mob/living/user, obj/item/tool)
	tool.play_tool_sound(user)
	deconstruct(TRUE)
	balloon_alert(user, "移除小便池")
	return ITEM_INTERACT_SUCCESS

/obj/structure/urinal/atom_deconstruct(disassembled = TRUE)
	new /obj/item/wallframe/urinal(loc)
	hidden_item?.forceMove(drop_location())

/obj/item/wallframe/urinal
	name = "小便池框架"
	desc = "一个未安装的小便池，需要将其安装在墙上才能使用."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	result_path = /obj/structure/urinal
	pixel_shift = 32

/obj/item/food/urinalcake
	name = "便池块"
	desc = "高贵的小便池块，保护管道免受尿液腐蚀，请勿食用."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinalcake"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(
		/datum/reagent/chlorine = 3,
		/datum/reagent/ammonia = 1,
	)
	foodtypes = TOXIC | GROSS
	preserved_food = TRUE

/obj/item/food/urinalcake/attack_self(mob/living/user)
	user.visible_message(span_notice("[user]挤压[src]!"), span_notice("你挤压[src]."), "<i>你听到挤压声.</i>")
	icon_state = "urinalcake_squish"
	addtimer(VARSET_CALLBACK(src, icon_state, "urinalcake"), 0.8 SECONDS)
