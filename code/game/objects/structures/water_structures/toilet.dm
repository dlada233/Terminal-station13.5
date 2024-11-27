/obj/structure/toilet
	name = "马桶"
	desc = "HT-451是一种基于扭矩旋转的小物质废物处理装置，这台看起来非常干净."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00" //The first number represents if the toilet lid is up, the second is if the cistern is open.
	base_icon_state = "toilet"
	density = FALSE
	anchored = TRUE

	///Boolean if whether the toilet is currently flushing.
	var/flushing = FALSE
	///Boolean if the toilet seat is up.
	var/cover_open = FALSE
	///Boolean if the cistern is up, allowing items to be put in/out.
	var/cistern_open = FALSE
	///The combined weight of all items in the cistern put together.
	var/w_items = 0
	///Reference to the mob being given a swirlie.
	var/mob/living/swirlie
	///The type of material used to build the toilet.
	var/buildstacktype = /obj/item/stack/sheet/iron
	///How much of the buildstacktype is needed to construct the toilet.
	var/buildstackamount = 1
	///Lazylist of items in the cistern.
	var/list/cistern_items
	///Lazylist of fish in the toilet, not to be mixed with the items in the cistern. Max of 3
	var/list/fishes
	///Static toilet water overlay given to toilets that are facing a direction we can see the water in.
	var/static/mutable_appearance/toilet_water_overlay

/obj/structure/toilet/Initialize(mapload)
	. = ..()
	if(isnull(toilet_water_overlay))
		toilet_water_overlay = mutable_appearance(icon, "[base_icon_state]-water")
	cover_open = round(rand(0, 1))
	update_appearance(UPDATE_ICON)
	if(mapload && SSmapping.level_trait(z, ZTRAIT_STATION))
		AddElement(/datum/element/lazy_fishing_spot, /datum/fish_source/toilet)
	register_context()

/obj/structure/toilet/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(user.pulling && isliving(user.pulling))
		context[SCREENTIP_CONTEXT_LMB] = "按进马桶"
	else if(cover_open && istype(held_item, /obj/item/fish))
		context[SCREENTIP_CONTEXT_LMB] = "放鱼"
	else if(cover_open && LAZYLEN(fishes))
		context[SCREENTIP_CONTEXT_LMB] = "抓鱼"
	else if(cistern_open)
		if(isnull(held_item))
			context[SCREENTIP_CONTEXT_LMB] = "检查水箱"
		else
			context[SCREENTIP_CONTEXT_LMB] = "放入物品"
	context[SCREENTIP_CONTEXT_RMB] = "冲水"
	context[SCREENTIP_CONTEXT_ALT_LMB] = "[cover_open ? "关闭" : "打开"]马桶盖"
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/toilet/examine(mob/user)
	. = ..()
	if(cover_open && LAZYLEN(fishes))
		. += span_notice("你看到马桶里有鱼，也许你可以捞出来.")

/obj/structure/toilet/examine_more(mob/user)
	. = ..()
	if(cistern_open && LAZYLEN(cistern_items))
		. += span_notice("你看到[cistern_items.len]物品藏在水箱里.")

/obj/structure/toilet/Destroy(force)
	. = ..()
	QDEL_LAZYLIST(fishes)
	QDEL_LAZYLIST(cistern_items)

/obj/structure/toilet/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone in cistern_items)
		LAZYREMOVE(cistern_items, gone)
		return
	if(gone in fishes)
		LAZYREMOVE(fishes, gone)
		return

/obj/structure/toilet/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(swirlie)
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src.loc, SFX_SWING_HIT, 25, TRUE)
		swirlie.visible_message(span_danger("[user]把马桶盖重重地砸在[swirlie]的头上!"), span_userdanger("[user]把马桶盖重重地砸在你的头上!"), span_hear("你听到瓷器碰撞声."))
		log_combat(user, swirlie, "swirlied (brute)")
		swirlie.adjustBruteLoss(5)
		return

	if(user.pulling && isliving(user.pulling))
		user.changeNext_move(CLICK_CD_MELEE)
		var/mob/living/grabbed_mob = user.pulling
		if(user.grab_state < GRAB_AGGRESSIVE)
			to_chat(user, span_warning("你需要更紧地抓握!"))
			return
		if(grabbed_mob.loc != get_turf(src))
			to_chat(user, span_warning("[grabbed_mob]需要在[src]上!"))
			return
		if(swirlie)
			return
		if(cover_open)
			grabbed_mob.visible_message(span_danger("[user]开始把[grabbed_mob]按到马桶里冲水!"), span_userdanger("[user]开始把你按到马桶里冲水..."))
			swirlie = grabbed_mob
			var/was_alive = (swirlie.stat != DEAD)
			if(!do_after(user, 3 SECONDS, target = src, timed_action_flags = IGNORE_HELD_ITEM))
				swirlie = null
				return
			grabbed_mob.visible_message(span_danger("[user]把[grabbed_mob]按到马桶里冲水!"), span_userdanger("[user]把你按到马桶里冲水!"), span_hear("你听到马桶冲水声."))
			if(iscarbon(grabbed_mob))
				var/mob/living/carbon/carbon_grabbed = grabbed_mob
				if(!carbon_grabbed.internal)
					log_combat(user, carbon_grabbed, "swirlied (oxy)")
					carbon_grabbed.adjustOxyLoss(5)
			else
				log_combat(user, grabbed_mob, "swirlied (oxy)")
				grabbed_mob.adjustOxyLoss(5)
			if(was_alive && swirlie.stat == DEAD && swirlie.client)
				swirlie.client.give_award(/datum/award/achievement/misc/swirlie, swirlie) // just like space high school all over again!
			swirlie = null
		else
			playsound(src.loc, 'sound/effects/bang.ogg', 25, TRUE)
			grabbed_mob.visible_message(span_danger("[user]把[grabbed_mob.name]砸进[src]!"), span_userdanger("[user]把你砸进[src]!"))
			log_combat(user, grabbed_mob, "toilet slammed")
			grabbed_mob.adjustBruteLoss(5)
		return

	if(cistern_open && !cover_open && user.CanReach(src))
		if(!LAZYLEN(cistern_items))
			to_chat(user, span_notice("水箱是空的."))
			return
		var/obj/item/random_cistern_item = pick(cistern_items)
		if(ishuman(user))
			user.put_in_hands(random_cistern_item)
		else
			random_cistern_item.forceMove(drop_location())
		to_chat(user, span_notice("你在水箱里找到了[random_cistern_item]."))
		w_items -= random_cistern_item.w_class
		return

	if(!flushing && LAZYLEN(fishes) && cover_open)
		var/obj/item/random_fish = pick(fishes)
		if(ishuman(user))
			user.put_in_hands(random_fish)
		else
			random_fish.forceMove(drop_location())
		to_chat(user, span_notice("你把[random_fish]从马桶里捞了出来，可怜的家伙."))

/obj/structure/toilet/click_alt(mob/living/user)
	if(flushing)
		return CLICK_ACTION_BLOCKING
	cover_open = !cover_open
	update_appearance(UPDATE_ICON)
	return CLICK_ACTION_SUCCESS

/obj/structure/toilet/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(flushing)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	flushing = TRUE
	playsound(src, 'sound/machines/toilet_flush.ogg', cover_open ? 40 : 20, TRUE)
	if(cover_open && (dir & SOUTH))
		update_appearance(UPDATE_OVERLAYS)
		flick_overlay_view(mutable_appearance(icon, "[base_icon_state]-water-flick"), 3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(end_flushing)), 4 SECONDS)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/toilet/update_icon_state()
	icon_state = "[base_icon_state][cover_open][cistern_open]"
	return ..()

/obj/structure/toilet/update_overlays()
	. = ..()
	if(!flushing && cover_open && (dir & SOUTH))
		. += toilet_water_overlay

/obj/structure/toilet/atom_deconstruct(dissambled = TRUE)
	for(var/obj/toilet_item in cistern_items)
		toilet_item.forceMove(drop_location())
	if(buildstacktype)
		new buildstacktype(loc,buildstackamount)
	else
		for(var/datum/material/M as anything in custom_materials)
			new M.sheet_type(loc, FLOOR(custom_materials[M] / SHEET_MATERIAL_AMOUNT, 1))

/obj/structure/toilet/attackby(obj/item/attacking_item, mob/living/user, params)
	add_fingerprint(user)
	if(cover_open && istype(attacking_item, /obj/item/fish))
		if(fishes >= 3)
			to_chat(user, span_warning("鱼太多了，得先把它们冲下去"))
			return
		if(!user.transferItemToLoc(attacking_item, src))
			to_chat(user, span_warning("[attacking_item]粘在了你的手上!"))
			return
		var/obj/item/fish/the_fish = attacking_item
		if(the_fish.status == FISH_DEAD)
			to_chat(user, span_warning("你把[attacking_item]放进[src]，愿它安息."))
		else
			to_chat(user, span_notice("你把[attacking_item]放进[src]，希望没人会错过它!"))
		LAZYADD(fishes, attacking_item)
		return

	if(cistern_open && !user.combat_mode)
		if(attacking_item.w_class > WEIGHT_CLASS_NORMAL)
			to_chat(user, span_warning("[attacking_item]不合适!"))
			return
		if(w_items + attacking_item.w_class > WEIGHT_CLASS_HUGE)
			to_chat(user, span_warning("水箱满了!"))
			return
		if(!user.transferItemToLoc(attacking_item, src))
			to_chat(user, span_warning("[attacking_item]粘在了你的手上，你无法把它放进水箱里!"))
			return
		LAZYADD(cistern_items, attacking_item)
		w_items += attacking_item.w_class
		to_chat(user, span_notice("你小心地把[attacking_item]放进水箱里."))
		return

	if(is_reagent_container(attacking_item) && !user.combat_mode)
		if (!cover_open)
			return
		if(istype(attacking_item, /obj/item/food/monkeycube))
			var/obj/item/food/monkeycube/cube = attacking_item
			cube.Expand()
			return
		var/obj/item/reagent_containers/RG = attacking_item
		RG.reagents.add_reagent(/datum/reagent/water, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		to_chat(user, span_notice("你用[src]填充[RG]. 恶心."))
	return ..()

/obj/structure/toilet/crowbar_act(mob/living/user, obj/item/tool)
	to_chat(user, span_notice("你开始[cistern_open ? "放回水箱的盖子" : "移开水箱的盖子"]..."))
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
	if(tool.use_tool(src, user, 30))
		user.visible_message(
			span_notice("[user][cistern_open ? "放回了水箱的盖子" : "移开了水箱的盖子"]!"),
			span_notice("你[cistern_open ? "放回了水箱的盖子" : "移开了水箱的盖子"]!"),
			span_hear("你听到陶瓷摩擦声."))
		cistern_open = !cistern_open
		update_appearance(UPDATE_ICON_STATE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/toilet/wrench_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	deconstruct()
	return ITEM_INTERACT_SUCCESS

///Ends the flushing animation and updates overlays if necessary
/obj/structure/toilet/proc/end_flushing()
	flushing = FALSE
	if(cover_open && (dir & SOUTH))
		update_appearance(UPDATE_OVERLAYS)
	QDEL_LAZYLIST(fishes)

/obj/structure/toilet/greyscale
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	buildstacktype = null

/obj/structure/toilet/secret
	var/secret_type = null

/obj/structure/toilet/secret/Initialize(mapload)
	. = ..()
	if(secret_type)
		var/obj/item/secret = new secret_type(src)
		secret.desc += " 它是个秘密!"
		w_items += secret.w_class
		LAZYADD(cistern_items, secret)
