/obj/item/clothing/head/wig
	name = "假发"
	desc = "一堆没连着脑袋的头发."
	icon = 'icons/mob/human/human_face.dmi'   // default icon for all hairs
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "hair_vlong"
	inhand_icon_state = "pwig"
	worn_icon_state = "wig"
	flags_inv = HIDEHAIR
	color = COLOR_BLACK
	var/hairstyle = "Very Long Hair"
	var/adjustablecolor = TRUE //can color be changed manually?

/obj/item/clothing/head/wig/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/clothing/head/wig/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user) && (slot & ITEM_SLOT_HEAD))
		item_flags |= EXAMINE_SKIP

/obj/item/clothing/head/wig/dropped(mob/user)
	. = ..()
	item_flags &= ~EXAMINE_SKIP

/obj/item/clothing/head/wig/update_icon_state()
	var/datum/sprite_accessory/hair/hair_style = SSaccessories.hairstyles_list[hairstyle]
	if(hair_style)
		icon = hair_style.icon
		icon_state = hair_style.icon_state
	return ..()

/obj/item/clothing/head/wig/worn_overlays(mutable_appearance/standing, isinhands = FALSE, file2use)
	. = ..()
	if(isinhands)
		return

	var/datum/sprite_accessory/hair/hair = SSaccessories.hairstyles_list[hairstyle]
	if(!hair)
		return

	var/mutable_appearance/hair_overlay = mutable_appearance(hair.icon, hair.icon_state, layer = -HAIR_LAYER, appearance_flags = RESET_COLOR)
	hair_overlay.color = color
	hair_overlay.pixel_y = hair.y_offset
	. += hair_overlay

	// So that the wig actually blocks emissives.
	hair_overlay.overlays += emissive_blocker(hair_overlay.icon, hair_overlay.icon_state, src, alpha = hair_overlay.alpha)

/obj/item/clothing/head/wig/attack_self(mob/user)
	var/new_style = tgui_input_list(user, "选择一个发型", "假发造型", SSaccessories.hairstyles_list - "Bald")
	var/newcolor = adjustablecolor ? input(usr,"","选择颜色",color) as color|null : null
	if(!user.can_perform_action(src))
		return
	if(new_style && new_style != hairstyle)
		hairstyle = new_style
		user.visible_message(span_notice("[user] 将 [src] 的发型更改为 [new_style]."), span_notice("你将 [src] 的发型更改为 [new_style]."))
	if(newcolor && newcolor != color) // 仅在必要时更新
		add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)
	update_appearance()

/obj/item/clothing/head/wig/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/clothing/head/wig/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with) || interacting_with == user)
		return NONE
	var/mob/living/carbon/human/target = interacting_with
	if(target.head)
		var/obj/item/clothing/head = target.head
		if((head.flags_inv & HIDEHAIR) && !istype(head, /obj/item/clothing/head/wig))
			to_chat(user, span_warning("你无法看清这个人的头发！"))
			return
	var/obj/item/bodypart/head/noggin = target.get_bodypart(BODY_ZONE_HEAD)
	if(!noggin)
		to_chat(user, span_warning("这个人没有头！"))
		return

	var/selected_hairstyle = null
	var/selected_hairstyle_color = null
	if(istype(target.head, /obj/item/clothing/head/wig))
		var/obj/item/clothing/head/wig/wig = target.head
		selected_hairstyle = wig.hairstyle
		selected_hairstyle_color = wig.color
	else if((noggin.head_flags & HEAD_HAIR) && target.hairstyle != "Bald")
		selected_hairstyle = target.hairstyle
		selected_hairstyle_color = "[target.hair_color]"

	if(selected_hairstyle)
		to_chat(user, span_notice("你将 [src] 调整得像 [target.name] 的 [selected_hairstyle] 一样."))
		add_atom_colour(selected_hairstyle_color, FIXED_COLOUR_PRIORITY)
		hairstyle = selected_hairstyle
		update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/clothing/head/wig/random/Initialize(mapload)
	hairstyle = pick(SSaccessories.hairstyles_list - "Bald") //Don't want invisible wig
	add_atom_colour("#[random_short_color()]", FIXED_COLOUR_PRIORITY)
	. = ..()

/obj/item/clothing/head/wig/natural
	name = "自然假发"
	desc = "一堆没连着脑袋的头发，这种假发会根据佩戴者的头发颜色而变化. 其实一点也不自然."
	color = COLOR_WHITE
	adjustablecolor = FALSE
	custom_price = PAYCHECK_COMMAND

/obj/item/clothing/head/wig/natural/Initialize(mapload)
	hairstyle = pick(SSaccessories.hairstyles_list - "Bald")
	. = ..()

/obj/item/clothing/head/wig/natural/visual_equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(ishuman(user) && (slot & ITEM_SLOT_HEAD))
		if(color != user.hair_color) // only update if necessary
			add_atom_colour(user.hair_color, FIXED_COLOUR_PRIORITY)
			update_appearance()
		user.update_worn_head()
