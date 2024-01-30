/obj/item/storage/box/trackimp
	name = "跟踪植入物盒"
	desc = "一盒人渣追踪工具."
	icon_state = "secbox"
	illustration = "implant"

/obj/item/storage/box/trackimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/tracking = 4,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
		/obj/item/locator = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/minertracker
	name = "追踪植入物盒"
	desc = "找到那些死在熔岩世界的人."
	illustration = "implant"

/obj/item/storage/box/minertracker/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/tracking = 2,
		/obj/item/implantcase/beacon = 2,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
		/obj/item/locator = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/chemimp
	name = "化学植入物盒"
	desc = "一盒用来植入化学物质的东西."
	illustration = "implant"

/obj/item/storage/box/chemimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/chem = 5,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/exileimp
	name = "流放植入物盒"
	desc = "流放植入物的盒子，上面有一张小丑被踢进星门的照片."
	illustration = "implant"

/obj/item/storage/box/exileimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/exile = 5,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/beaconimp
	name = "信标植入物盒"
	desc = "包含一组信标植入物。侧面有一个警告标签，警告你要经常检查你的传送目的地是否安全， \
		并附有安保的漫画形象，上面写着'三思而后行!'"
	illustration = "implant"

/obj/item/storage/box/beaconimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/beacon = 3,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/teleport_blocker
	name = "蓝空绝缘植入物"
	desc = "蓝空绝缘植入物盒子，侧面有一幅画一个人穿着吓人的长袍，皱着眉头，流着一滴眼泪."
	illustration = "implant"

/obj/item/storage/box/teleport_blocker/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/teleport_blocker = 2,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
	)
	generate_items_inside(items_inside,src)
