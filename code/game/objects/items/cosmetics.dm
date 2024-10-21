#define UPPER_LIP "Upper"
#define MIDDLE_LIP "Middle"
#define LOWER_LIP "Lower"

/obj/item/lipstick
	gender = PLURAL
	name = "红口红"
	desc = "普通牌子的口红."
	icon =  'modular_skyrat/modules/salon/icons/items.dmi' //SKYRAT EDIT CHANGE - ORIGINAL: icon = 'icons/obj/cosmetic.dmi'
	icon_state = "lipstick"
	inhand_icon_state = "lipstick"
	w_class = WEIGHT_CLASS_TINY
	interaction_flags_click = NEED_DEXTERITY|NEED_HANDS|ALLOW_RESTING
	var/open = FALSE
	/// Actual color of the lipstick, also gets applied to the human
	var/lipstick_color = COLOR_RED
	/// The style of lipstick. Upper, middle, or lower lip. Default is middle.
	var/style = "lipstick"
	/// A trait that's applied while someone has this lipstick applied, and is removed when the lipstick is removed
	var/lipstick_trait

/obj/item/lipstick/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	update_appearance(UPDATE_ICON)

/obj/item/lipstick/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, open))
		update_appearance(UPDATE_ICON)

/obj/item/lipstick/examine(mob/user)
	. = ..()
	. += "Alt加左键改变样式."

/obj/item/lipstick/update_icon_state()
	icon_state = "lipstick[open ? "_uncap" : null]"
	inhand_icon_state = "lipstick[open ? "open" : null]"
	return ..()

/obj/item/lipstick/update_overlays()
	. = ..()
	if(!open)
		return
	var/mutable_appearance/colored_overlay = mutable_appearance(icon, "lipstick_uncap_color")
	colored_overlay.color = lipstick_color
	. += colored_overlay

/obj/item/lipstick/click_alt(mob/user)
	display_radial_menu(user)
	return CLICK_ACTION_SUCCESS

/obj/item/lipstick/proc/display_radial_menu(mob/living/carbon/human/user)
	var/style_options = list(
		UPPER_LIP = icon('icons/hud/radial.dmi', UPPER_LIP),
		MIDDLE_LIP = icon('icons/hud/radial.dmi', MIDDLE_LIP),
		LOWER_LIP = icon('icons/hud/radial.dmi', LOWER_LIP),
	)
	var/pick = show_radial_menu(user, src, style_options, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
	if(!pick)
		return TRUE

	switch(pick)
		if(MIDDLE_LIP)
			style = "lipstick"
		if(LOWER_LIP)
			style = "lipstick_lower"
		if(UPPER_LIP)
			style = "lipstick_upper"
	return TRUE

/obj/item/lipstick/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

/obj/item/lipstick/purple
	name = "紫色口红"
	lipstick_color = COLOR_PURPLE

/obj/item/lipstick/jade
	name = "翠色口红"
	lipstick_color = COLOR_JADE

/obj/item/lipstick/blue
	name = "蓝色口红"
	lipstick_color = COLOR_BLUE

/obj/item/lipstick/green
	name = "绿色口红"
	lipstick_color = COLOR_GREEN

/obj/item/lipstick/white
	name = "白色口红"
	lipstick_color = COLOR_WHITE

/obj/item/lipstick/black
	name = "黑色口红"
	lipstick_color = COLOR_BLACK

/obj/item/lipstick/black/death
	name = "\improper 死亡一吻"
	desc = "这只口红由可怕的黄斑太空蜥的毒液制成！它既致命又美丽，尽量不要涂抹它."
	lipstick_trait = TRAIT_KISS_OF_DEATH

/obj/item/lipstick/random
	name = "lipstick"
	icon_state = "random_lipstick"

/obj/item/lipstick/random/Initialize(mapload)
	. = ..()
	icon_state = "lipstick"
	var/static/list/possible_colors
	if(!possible_colors)
		possible_colors = list()
		for(var/obj/item/lipstick/lipstick_path as anything in (typesof(/obj/item/lipstick) - src.type))
			if(!initial(lipstick_path.lipstick_color))
				continue
			possible_colors[initial(lipstick_path.lipstick_color)] = initial(lipstick_path.name)
	lipstick_color = pick(possible_colors)
	name = possible_colors[lipstick_color]
	update_appearance()

/obj/item/lipstick/attack_self(mob/user)
	to_chat(user, span_notice("你扭开 [src] [open ? "closed" : "open"]."))
	open = !open
	update_appearance(UPDATE_ICON)

/obj/item/lipstick/attack(mob/M, mob/user)
	if(!open || !ismob(M))
		return

	if(!ishuman(M))
		to_chat(user, span_warning("嘴唇在那里？"))
		return

	var/mob/living/carbon/human/target = M
	if(target.is_mouth_covered())
		to_chat(user, span_warning("移开 [ target == user ? "你的" : "[target.p_their()]" ] 面罩先"))
		return
	if(target.lip_style) //if they already have lipstick on
		to_chat(user, span_warning("你得先把旧口红妆擦干净!"))
		return

	if(target == user)
		user.visible_message(span_notice("[user]用[src]涂抹其嘴唇."), \
			span_notice("你花了点时间涂[src]. Perfect!"))
		target.update_lips(style, lipstick_color, lipstick_trait)
		return

	user.visible_message(span_warning("[user]用[src]涂抹[target]的嘴唇上."), \
		span_notice("你把[src]涂在[target]上..."))
	if(!do_after(user, 2 SECONDS, target = target))
		return
	user.visible_message(span_notice("[user]用[src]涂抹在了[target]的嘴唇上."), \
		span_notice("你把[src]涂在[target]上."))
	target.update_lips(style, lipstick_color, lipstick_trait)

//you can wipe off lipstick with paper!
/obj/item/paper/attack(mob/M, mob/user)
	if(user.zone_selected != BODY_ZONE_PRECISE_MOUTH || !ishuman(M))
		return ..()

	var/mob/living/carbon/human/target = M
	if(target == user)
		to_chat(user, span_notice("你用[src]擦去口红."))
		target.update_lips(null)
		return

	user.visible_message(span_warning("[user]开始用[src]擦去[target]口红."), \
		span_notice("你开始擦去[target]的口红..."))
	if(!do_after(user, 10, target = target))
		return
	user.visible_message(span_notice("[user]用[src]擦去了[target]口红."), \
		span_notice("你擦去了[target]的口红."))
	target.update_lips(null)

/* SKYRAT EDIT REMOVAL
/obj/item/razor
	name = "electric razor"
	desc = "The latest and greatest power razor born from the science of shaving."
	icon = 'icons/obj/cosmetic.dmi'
	icon_state = "razor"
	inhand_icon_state = "razor"
	obj_flags = CONDUCTS_ELECTRICITY
	w_class = WEIGHT_CLASS_TINY

/obj/item/razor/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins shaving [user.p_them()]self without the razor guard! 看起来是在尝试自杀!"))
	shave(user, BODY_ZONE_PRECISE_MOUTH)
	shave(user, BODY_ZONE_HEAD)//doesnt need to be BODY_ZONE_HEAD specifically, but whatever
	return BRUTELOSS

/obj/item/razor/proc/shave(mob/living/carbon/human/skinhead, location = BODY_ZONE_PRECISE_MOUTH)
	if(location == BODY_ZONE_PRECISE_MOUTH)
		skinhead.set_facial_hairstyle("Shaved", update = TRUE)
	else
		skinhead.set_hairstyle("Skinhead", update = TRUE)
	playsound(loc, 'sound/items/welder2.ogg', 20, TRUE)

/obj/item/razor/attack(mob/target_mob, mob/living/user, params)
	if(!ishuman(target_mob))
		return ..()
	var/mob/living/carbon/human/human_target = target_mob
	var/obj/item/bodypart/head/noggin =  human_target.get_bodypart(BODY_ZONE_HEAD)
	var/location = user.zone_selected
	var/static/list/head_zones = list(BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_HEAD)
	if(!noggin && (location in head_zones))
		to_chat(user, span_warning("[human_target] doesn't have a head!"))
		return
	if(location == BODY_ZONE_PRECISE_MOUTH)
		if(!user.combat_mode)
			if(human_target.gender == MALE)
				if(human_target == user)
					to_chat(user, span_warning("You need a mirror to properly style your own facial hair!"))
					return
				if(!user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
					return
				var/new_style = tgui_input_list(user, "Select a facial hairstyle", "Grooming", SSaccessories.facial_hairstyles_list)
				if(isnull(new_style))
					return
				if(!get_location_accessible(human_target, location))
					to_chat(user, span_warning("The headgear is in the way!"))
					return
				if(!(noggin.head_flags & HEAD_FACIAL_HAIR))
					to_chat(user, span_warning("There is no facial hair to style!"))
					return
				if(HAS_TRAIT(human_target, TRAIT_SHAVED))
					to_chat(user, span_warning("[human_target] is just way too shaved. Like, really really shaved."))
					return
				user.visible_message(span_notice("[user] tries to change [human_target]'s facial hairstyle using [src]."), span_notice("You try to change [human_target]'s facial hairstyle using [src]."))
				if(new_style && do_after(user, 6 SECONDS, target = human_target))
					user.visible_message(span_notice("[user] successfully changes [human_target]'s facial hairstyle using [src]."), span_notice("You successfully change [human_target]'s facial hairstyle using [src]."))
					human_target.set_facial_hairstyle(new_style, update = TRUE)
					return
			else
				return
		else
			if(!get_location_accessible(human_target, location))
				to_chat(user, span_warning("The mask is in the way!"))
				return
			if(!(noggin.head_flags & HEAD_FACIAL_HAIR))
				to_chat(user, span_warning("There is no facial hair to shave!"))
				return
			if(human_target.facial_hairstyle == "Shaved")
				to_chat(user, span_warning("Already clean-shaven!"))
				return

			if(human_target == user) //shaving yourself
				user.visible_message(span_notice("[user] starts to shave [user.p_their()] facial hair with [src]."), \
					span_notice("You take a moment to shave your facial hair with [src]..."))
				if(do_after(user, 5 SECONDS, target = user))
					user.visible_message(span_notice("[user] shaves [user.p_their()] facial hair clean with [src]."), \
						span_notice("You finish shaving with [src]. Fast and clean!"))
					shave(user, location)
				return
			else
				user.visible_message(span_warning("[user] tries to shave [human_target]'s facial hair with [src]."), \
					span_notice("You start shaving [human_target]'s facial hair..."))
				if(do_after(user, 5 SECONDS, target = human_target))
					user.visible_message(span_warning("[user] shaves off [human_target]'s facial hair with [src]."), \
						span_notice("You shave [human_target]'s facial hair clean off."))
					shave(human_target, location)
				return
	else if(location == BODY_ZONE_HEAD)
		if(!user.combat_mode)
			if(human_target == user)
				to_chat(user, span_warning("You need a mirror to properly style your own hair!"))
				return
			if(!user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
				return
			var/new_style = tgui_input_list(user, "Select a hairstyle", "Grooming", SSaccessories.hairstyles_list)
			if(isnull(new_style))
				return
			if(!get_location_accessible(human_target, location))
				to_chat(user, span_warning("The headgear is in the way!"))
				return
			if(!(noggin.head_flags & HEAD_HAIR))
				to_chat(user, span_warning("There is no hair to style!"))
				return
			if(HAS_TRAIT(human_target, TRAIT_BALD))
				to_chat(user, span_warning("[human_target] is just way too bald. Like, really really bald."))
				return
			user.visible_message(span_notice("[user] tries to change [human_target]'s hairstyle using [src]."), span_notice("You try to change [human_target]'s hairstyle using [src]."))
			if(new_style && do_after(user, 6 SECONDS, target = human_target))
				user.visible_message(span_notice("[user] successfully changes [human_target]'s hairstyle using [src]."), span_notice("You successfully change [human_target]'s hairstyle using [src]."))
				human_target.set_hairstyle(new_style, update = TRUE)
				return
		else
			if(!get_location_accessible(human_target, location))
				to_chat(user, span_warning("The headgear is in the way!"))
				return
			if(!(noggin.head_flags & HEAD_HAIR))
				to_chat(user, span_warning("There is no hair to shave!"))
				return
			if(human_target.hairstyle == "Bald" || human_target.hairstyle == "Balding Hair" || human_target.hairstyle == "Skinhead")
				to_chat(user, span_warning("There is not enough hair left to shave!"))
				return

			if(human_target == user) //shaving yourself
				user.visible_message(span_notice("[user] starts to shave [user.p_their()] head with [src]."), \
					span_notice("You start to shave your head with [src]..."))
				if(do_after(user, 5 SECONDS, target = user))
					user.visible_message(span_notice("[user] shaves [user.p_their()] head with [src]."), \
						span_notice("You finish shaving with [src]."))
					shave(user, location)
				return
			else
				user.visible_message(span_warning("[user] tries to shave [human_target]'s head with [src]!"), \
					span_notice("You start shaving [human_target]'s head..."))
				if(do_after(user, 5 SECONDS, target = human_target))
					user.visible_message(span_warning("[user] shaves [human_target]'s head bald with [src]!"), \
						span_notice("You shave [human_target]'s head bald."))
					shave(human_target, location)
				return
	return ..()
*/

/obj/item/razor/surgery
	name = "手术剃须刀"
	desc = "医用级剃须刀，精密的刀片结构为手术提供干净的剃须操作."
	icon = 'icons/obj/cosmetic.dmi'
	icon_state = "medrazor"

/obj/item/razor/surgery/get_surgery_tool_overlay(tray_extended)
	return "razor"

#undef UPPER_LIP
#undef MIDDLE_LIP
#undef LOWER_LIP
