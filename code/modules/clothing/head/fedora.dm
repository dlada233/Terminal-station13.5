/obj/item/clothing/head/fedora
	name = "软呢帽"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "fedora"
	inhand_icon_state = "fedora"
	desc = "如果你是黑帮成员，这是一个很酷的帽子；如果你不是，这就是一个很逊的帽子."

/obj/item/clothing/head/fedora/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/small/fedora)

/obj/item/clothing/head/fedora/white
	name = "白色软呢帽"
	icon_state = "fedora_white"
	inhand_icon_state = null

/obj/item/clothing/head/fedora/beige
	name = "米色软呢帽"
	icon_state = "fedora_beige"
	inhand_icon_state = null

/obj/item/clothing/head/fedora/suicide_act(mob/living/user)
	if(user.gender == FEMALE)
		return
	var/mob/living/carbon/human/H = user
	user.visible_message(span_suicide("[user] 戴上了 [src]！看起来试图吸引女孩."))
	user.say("女士", forced = "fedora suicide")
	sleep(1 SECONDS)
	H.facial_hairstyle = "络腮胡"
	return BRUTELOSS

/obj/item/clothing/head/fedora/carpskin
	name = "鲤鱼皮软呢帽"
	icon_state = "fedora_carpskin"
	inhand_icon_state = null
