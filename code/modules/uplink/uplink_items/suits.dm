// File ordered by progression

/datum/uplink_category/suits
	name = "太空服"
	weight = 3

/datum/uplink_item/suits
	category = /datum/uplink_category/suits
	surplus = 40

/datum/uplink_item/suits/infiltrator_bundle
	name = "渗透者模块服"
	desc = "由Roseus Galactic Actors Guild和Gorlex Marauders联合开发的一种城市作战功能装， \
			这种套装比标准的模块服便宜且更加敏捷，但代价是没法使穿戴者免受太空真空的影响."
	item = /obj/item/mod/control/pre_equipped/infiltrator
	cost = 6
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/suits/space_suit
	name = "辛迪加太空服"
	desc = "这种红黑相间的辛迪加太空服比Nanotrasen宇航服更轻便，可以装在包里，还有一个武器槽. \
			然而，Nanotrasen的船员大都对红色太空服相当警觉."
	item = /obj/item/storage/box/syndie_kit/space
	cost = 4

/datum/uplink_item/suits/modsuit
	name = "辛迪加模块服"
	desc = "辛迪加特工的模块服，特点是扩展装甲和内置推进器."
	item = /obj/item/mod/control/pre_equipped/traitor
	cost = 8
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS) //you can't buy it in nuke, because the elite modsuit costs the same while being better

/datum/uplink_item/suits/thermal
	name = "热成像模块"
	desc = "模块服用的热成像模块让你可以透过墙壁看到生物."
	item = /obj/item/mod/module/visor/thermal
	cost = 3

/datum/uplink_item/suits/night
	name = "夜视模块"
	desc = "模块服用的夜视模块让你可以在黑暗里看清物体."
	item = /obj/item/mod/module/visor/night
	cost = 2

/datum/uplink_item/suits/chameleon
	name = "变色龙模块"
	desc = "模块服用的变色龙模块可以让模块服伪装成其他物体."
	item = /obj/item/mod/module/chameleon
	cost = 2

/datum/uplink_item/suits/plate_compression
	name = "铠甲压缩模块"
	desc = "模块服用的铠甲压缩模块可以让模块服压缩成更小的尺寸，与存储模块与渗透者模块服不兼容."
	item = /obj/item/mod/module/plate_compression
	cost = 2

/datum/uplink_item/suits/noslip
	name = "防滑模块"
	desc = "模块服用的防滑模块可以防止使用者在水上滑倒."
	item = /obj/item/mod/module/noslip
	cost = 2

/datum/uplink_item/suits/shock_absorber
	name = "MODsuit Shock-Absorber Module"
	desc = "A MODsuit module preventing the user from getting knocked down by batons."
	item = /obj/item/mod/module/shock_absorber
	cost = 2

/datum/uplink_item/suits/modsuit/elite_traitor
	name = "精英辛迪加模块服"
	desc = "辛迪加模块服的升级精英版，与标准辛迪加模块服相比它拥有更好的装甲、机动性与防火."
	item = /obj/item/mod/control/pre_equipped/traitor_elite
	// This one costs more than the nuke op counterpart
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS | UPLINK_SPY)
	progression_minimum = 90 MINUTES
	cost = 16
