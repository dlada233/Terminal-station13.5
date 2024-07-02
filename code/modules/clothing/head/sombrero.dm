/obj/item/clothing/head/costume/sombrero
	name = "墨西哥帽"
	icon = 'icons/obj/clothing/head/sombrero.dmi'
	icon_state = "sombrero"
	inhand_icon_state = "sombrero"
	desc = "让你尝到节日的狂欢味道."
	flags_inv = HIDEHAIR

	dog_fashion = /datum/dog_fashion/head/sombrero

	greyscale_config = /datum/greyscale_config/sombrero
	greyscale_config_worn = /datum/greyscale_config/sombrero/worn
	greyscale_config_inhand_left = /datum/greyscale_config/sombrero/lefthand
	greyscale_config_inhand_right = /datum/greyscale_config/sombrero/righthand

/obj/item/clothing/head/costume/sombrero/green
	name = "绿色墨西哥帽"
	desc = "像跳舞的仙人掌一样优雅."
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS
	dog_fashion = null
	greyscale_colors = "#13d968#ffffff"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/sombrero/shamebrero
	name = "羞耻帽"
	icon_state = "shamebrero"
	desc = "一旦戴上，就永远无法取下."
	dog_fashion = null
	greyscale_colors = "#d565d3#f8db18"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/sombrero/shamebrero/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, SHAMEBRERO_TRAIT)
