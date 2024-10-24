//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.

/obj/structure/bed/nest
	name = "异形窝"
	desc = "这是个由一大堆厚而黏的树脂组成的, 形状像巢穴一样的东西."
	icon = 'icons/obj/smooth_structures/alien/nest.dmi'
	icon_state = "nest-0"
	base_icon_state = "nest"
	max_integrity = 120
	can_be_unanchored = FALSE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_ALIEN_NEST
	canSmoothWith = SMOOTH_GROUP_ALIEN_NEST
	build_stack_type = null
	elevation = 0
	var/static/mutable_appearance/nest_overlay = mutable_appearance('icons/mob/nonhuman-player/alien.dmi', "nestoverlay", LYING_MOB_LAYER)

/obj/structure/bed/nest/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(held_item?.tool_behaviour == TOOL_WRENCH)
		return NONE

	return ..()

/obj/structure/bed/nest/wrench_act_secondary(mob/living/user, obj/item/weapon)
	return ITEM_INTERACT_BLOCKING


/obj/structure/bed/nest/user_unbuckle_mob(mob/living/captive, mob/living/hero)
	if(!length(buckled_mobs))
		return

	if(hero.get_organ_by_type(/obj/item/organ/internal/alien/plasmavessel))
		unbuckle_mob(captive)
		add_fingerprint(hero)
		return

	if(captive != hero)
		captive.visible_message(span_notice("[hero.name] 把 [captive.name] 从异形巢里解救了出来!"),
			span_notice("[hero.name] 把你从胶状的树脂中拉了出来."),
			span_hear("你听到扑哧的声音..."))
		unbuckle_mob(captive)
		add_fingerprint(hero)
		return

	captive.visible_message(span_warning("[captive.name] 试图从胶状的树脂中挣脱出来!"),
		span_notice("你试图从胶状的树脂中挣脱出来... (保持站立大约一分半.)"),
		span_hear("你听到扑哧的声音..."))

	if(!do_after(captive, 100 SECONDS, target = src, hidden = TRUE))
		if(captive.buckled)
			to_chat(captive, span_warning("你没能将自己从这上面解开!"))
		return

	captive.visible_message(span_warning("[captive.name] 从胶状的树脂中挣脱了出来!"),
		span_notice("你从胶状的树脂中挣脱了出来!"),
		span_hear("你听到扑哧的声音..."))

	unbuckle_mob(captive)
	add_fingerprint(hero)

/obj/structure/bed/nest/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.incapacitated() || M.buckled )
		return

	if(M.get_organ_by_type(/obj/item/organ/internal/alien/plasmavessel))
		return
	if(!user.get_organ_by_type(/obj/item/organ/internal/alien/plasmavessel))
		return

	if(has_buckled_mobs())
		unbuckle_all_mobs()

	if(buckle_mob(M))
		M.visible_message(span_notice("[user.name] 分泌出一种粘稠的肮脏粘液, 将 [M.name] 固定在 [src] 中!"),\
			span_danger("[user.name] 在你身上涂满难闻的树脂, 将你困在 [src] 中!"),\
			span_hear("你听到扑哧的声音..."))

/obj/structure/bed/nest/post_buckle_mob(mob/living/M)
	ADD_TRAIT(M, TRAIT_HANDS_BLOCKED, type)
	M.pixel_y = M.base_pixel_y
	M.pixel_x = M.base_pixel_x + 2
	M.layer = BELOW_MOB_LAYER
	add_overlay(nest_overlay)

	if(ishuman(M))
		var/mob/living/carbon/human/victim = M
		if(((victim.wear_mask && istype(victim.wear_mask, /obj/item/clothing/mask/facehugger)) || HAS_TRAIT(victim, TRAIT_XENO_HOST)) && victim.stat != DEAD) //If they're a host or have a facehugger currently infecting them. Must be alive.
			victim.apply_status_effect(/datum/status_effect/nest_sustenance)

/obj/structure/bed/nest/post_unbuckle_mob(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_HANDS_BLOCKED, type)
	M.pixel_x = M.base_pixel_x + M.body_position_pixel_x_offset
	M.pixel_y = M.base_pixel_y + M.body_position_pixel_y_offset
	M.layer = initial(M.layer)
	cut_overlay(nest_overlay)
	M.remove_status_effect(/datum/status_effect/nest_sustenance)

/obj/structure/bed/nest/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 100, TRUE)

/obj/structure/bed/nest/attack_alien(mob/living/carbon/alien/user, list/modifiers)
	if(!user.combat_mode)
		return attack_hand(user, modifiers)
	else
		return ..()
