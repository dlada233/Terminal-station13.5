/datum/uplink_category/implants
	name = "植入物"
	weight = 2


/datum/uplink_item/implants
	category = /datum/uplink_category/implants
	surplus = 50

/datum/uplink_item/implants/freedom
	name = "自由植入物"
	desc = "植入后，你可以激活技能来摆脱手铐、脚镣."
	item = /obj/item/storage/box/syndie_kit/imp_freedom
	cost = 5

/datum/uplink_item/implants/freedom/New()
	. = ..()
	desc += "植入物的能量还能供[FREEDOM_IMPLANT_CHARGES]次使用，用尽之后便会无害地自我降解."

/datum/uplink_item/implants/radio
	name = "无线电植入物"
	desc = "将植入物注入体内，你就可以不带外部设备的使用辛迪加内部的无线电频道了. \
			你可以随时关闭它，继续用普通的无线电耳机，这样可以减少怀疑."
	item = /obj/item/storage/box/syndie_kit/imp_radio
	cost = 4
	restricted = TRUE


/datum/uplink_item/implants/stealthimplant
	name = "隐形植入物"
	desc = "这个独一无二的植入物会让你几乎隐形，在此期间你可以随意移动！\
			激活后，它会把你藏在一个变色龙纸箱里，只有当有人撞到它时才会显形."
	item = /obj/item/storage/box/syndie_kit/imp_stealth
	cost = 8

/datum/uplink_item/implants/storage
	name = "储存植入物"
	desc = "这种植入物注射到体内，会按使用者的意愿激活，\
			激活后，它会打开一个蓝空口袋，里面可以存放两个普通大小的物品."
	item = /obj/item/storage/box/syndie_kit/imp_storage
	cost = 8

/datum/uplink_item/implants/uplink
	name = "上行链路植入物"
	desc = "这种植入物能直接把上行链路打到使用者体内，然后按使用者的意愿激活. \
			它还有一个优点是难以被检测，只有通过做植入物手术可以被查出来."
	item = /obj/item/storage/box/syndie_kit // the actual uplink implant is generated later on in spawn_item
	cost = UPLINK_IMPLANT_TELECRYSTAL_COST
	// An empty uplink is kinda useless.
	surplus = 0
	restricted = TRUE

/datum/uplink_item/implants/uplink/spawn_item(spawn_path, mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	var/obj/item/storage/box/syndie_kit/uplink_box = ..()
	uplink_box.name = "上行链路植入物盒"
	new /obj/item/implanter/uplink(uplink_box, uplink_handler)
	return uplink_box
