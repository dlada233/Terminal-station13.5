/obj/item/clothing/head/costume/pirate
	name = "海盗帽"
	desc = "Yarr."
	icon_state = "pirate"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head/pirate

/obj/item/clothing/head/costume/pirate
	var/datum/language/piratespeak/L = new

/obj/item/clothing/head/costume/pirate/equipped(mob/user, slot)
	. = ..()
	if(!(slot_flags & slot))
		return
	user.grant_language(/datum/language/piratespeak, source = LANGUAGE_HAT)
	to_chat(user, span_boldnotice("你突然学会了如何像海盗一样说话！"))

/obj/item/clothing/head/costume/pirate/dropped(mob/user)
	. = ..()
	if(QDELETED(src)) //This can be called as a part of destroy
		return
	user.remove_language(/datum/language/piratespeak, source = LANGUAGE_HAT)
	to_chat(user, span_boldnotice("你再也不能像海盗一样说话了。"))

/obj/item/clothing/head/costume/pirate/armored
	armor_type = /datum/armor/pirate_armored
	strip_delay = 40
	equip_delay_other = 20

/datum/armor/pirate_armored
	melee = 30
	bullet = 50
	laser = 30
	energy = 40
	bomb = 30
	bio = 30
	fire = 60
	acid = 75

/obj/item/clothing/head/costume/pirate/captain
	name = "海盗船长帽"
	icon_state = "hgpiratecap"
	inhand_icon_state = null

/obj/item/clothing/head/costume/pirate/bandana
	name = "海盗头巾"
	desc = "Yarr."
	icon_state = "bandana"
	inhand_icon_state = null

/obj/item/clothing/head/costume/pirate/bandana/armored
	armor_type = /datum/armor/bandana_armored
	strip_delay = 40
	equip_delay_other = 20

/datum/armor/bandana_armored
	melee = 30
	bullet = 50
	laser = 30
	energy = 40
	bomb = 30
	bio = 30
	fire = 60
	acid = 75
