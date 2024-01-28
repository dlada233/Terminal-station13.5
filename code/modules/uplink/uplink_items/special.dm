/datum/uplink_category/special
	name = "特殊"
	weight = -3

/datum/uplink_item/special
	category = /datum/uplink_category/special
	cant_discount = TRUE
	surplus = 0
	purchasable_from = NONE

/datum/uplink_item/special/autosurgeon
	name = "辛迪加自动手术仪"
	desc = "一个多功能的自动手术仪可以给你植入任何义体."
	item = /obj/item/autosurgeon/syndicate
	cost = 5

/datum/uplink_item/special/autosurgeon/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		purchasable_from |= UPLINK_TRAITORS
