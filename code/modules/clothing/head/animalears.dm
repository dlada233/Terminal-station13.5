/obj/item/clothing/head/costume/kitty
	name = "猫耳"
	desc = "一对猫耳，喵!"
	icon_state = "kitty"
	color = "#999999"

	dog_fashion = /datum/dog_fashion/head/kitty

/obj/item/clothing/head/costume/kitty/visual_equipped(mob/living/carbon/human/user, slot)
	if(ishuman(user) && (slot & ITEM_SLOT_HEAD))
		update_icon(ALL, user)
		user.update_worn_head() //Color might have been changed by update_appearance.
	..()

/obj/item/clothing/head/costume/kitty/update_icon(updates=ALL, mob/living/carbon/human/user)
	. = ..()
	if(ishuman(user))
		add_atom_colour(user.hair_color, FIXED_COLOUR_PRIORITY)

/obj/item/clothing/head/costume/kitty/genuine
	desc = "一对猫耳，内部标签说 \"原生态真猫亲手采摘.\""

/obj/item/clothing/head/costume/rabbitears
	name = "兔耳"
	desc = "穿上这个只会显得你很没用并增加你的性感程度."
	icon_state = "bunny"

	dog_fashion = /datum/dog_fashion/head/rabbit
