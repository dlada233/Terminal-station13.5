/obj/item/ammo_box/magazine/sniper_rounds
	name = "反器材狙击弹匣(.50 BMG)"
	icon_state = ".50mag"
	base_icon_state = ".50mag"
	ammo_type = /obj/item/ammo_casing/p50
	max_ammo = 6
	caliber = CALIBER_50BMG

/obj/item/ammo_box/magazine/sniper_rounds/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][ammo_count() ? "-ammo" : ""]"

/obj/item/ammo_box/magazine/sniper_rounds/surplus
	name = "反器材狙击弹匣(.50 BMG 批发版)"
	icon_state = "surplus"
	base_icon_state = "surplus"
	ammo_type = /obj/item/ammo_casing/p50/surplus

/obj/item/ammo_box/magazine/sniper_rounds/disruptor
	name = "反器材狙击弹匣 (.50 BMG 干扰弹)"
	desc = "干扰狙击弹匣，内部混合有特殊的催眠化学物质和电磁载荷，可以让任何东西停止行动."
	base_icon_state = "disruptor"
	ammo_type = /obj/item/ammo_casing/p50/disruptor

/obj/item/ammo_box/magazine/sniper_rounds/incendiary
	name = "反器材狙击弹匣 (.50 BMG 燃烧弹)"
	desc = "燃烧狙击弹匣，在子弹落点引发剧烈燃烧."
	base_icon_state = "incendiary"
	ammo_type = /obj/item/ammo_casing/p50/incendiary

/obj/item/ammo_box/magazine/sniper_rounds/penetrator
	name = "反器材狙击弹匣 (.50 BMG 钻头弹)"
	desc = "这是一种威力极大的子弹，可以直接穿过掩体，击中任何不幸躲在后面的人."
	base_icon_state = "penetrator"
	ammo_type = /obj/item/ammo_casing/p50/penetrator

/obj/item/ammo_box/magazine/sniper_rounds/marksman
	name = "反器材狙击弹匣 (.50 BMG 射手弹)"
	desc = "这是一种速度极快的狙击弹几乎可以瞬间击穿物体."
	base_icon_state = "marksman"
	ammo_type = /obj/item/ammo_casing/p50/marksman
