/datum/uplink_category/species
	name = "种族限制"
	weight = 1

/datum/uplink_item/species_restricted
	category = /datum/uplink_category/species
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS | UPLINK_SPY)

/datum/uplink_item/species_restricted/moth_lantern
	name = "极光灯笼"
	desc = "我们听说像你这样的飞蛾真的很喜欢灯，所以我们决定提前给你一个原型产品：\"极光灯笼™\"，好好享受它吧."
	cost = 2
	item = /obj/item/flashlight/lantern/syndicate
	restricted_species = list(SPECIES_MOTH)
	surplus = 0
