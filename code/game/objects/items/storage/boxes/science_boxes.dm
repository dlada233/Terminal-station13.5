// This file contains all boxes used by the Science department and its purpose on the station.

/obj/item/storage/box/swab
	name = "微生物拭子盒"
	desc = "包含一些无菌拭子，用于收集微生物样本."
	illustration = "swab"

/obj/item/storage/box/swab/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/swab(src)

/obj/item/storage/box/petridish
	name = "培养皿盒"
	desc = "这个盒子包含了一些培养皿容器."
	illustration = "petridish"

/obj/item/storage/box/petridish/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/petri_dish(src)

/obj/item/storage/box/plumbing
	name = "水利用品箱"
	desc = "包含少量的管道供应，水循环器和连接到其他部分的铁."

//Disk boxes

/obj/item/storage/box/disks
	name = "磁盘盒"
	illustration = "disk_kit"

/obj/item/storage/box/disks/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/disk/data(src)

/obj/item/storage/box/monkeycubes
	name = "猴子方块盒"
	desc = "遇水即溶."
	icon_state = "monkeycubebox"
	illustration = null
	/// Which type of cube are we spawning in this box?
	var/cube_type = /obj/item/food/monkeycube

/obj/item/storage/box/monkeycubes/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 7
	atom_storage.set_holdable(list(/obj/item/food/monkeycube))

/obj/item/storage/box/monkeycubes/PopulateContents()
	for(var/i in 1 to 5)
		new cube_type(src)

/obj/item/storage/box/monkeycubes/syndicate
	desc = "Waffle公司的猴子方块，只要加水就行了!"
	cube_type = /obj/item/food/monkeycube/syndicate

/obj/item/storage/box/gorillacubes
	name = "大猩猩方块盒"
	desc = "Waffle公司的大猩猩方块，不要随便加水."
	icon_state = "monkeycubebox"
	illustration = null

/obj/item/storage/box/gorillacubes/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 3
	atom_storage.set_holdable(list(/obj/item/food/monkeycube))

/obj/item/storage/box/gorillacubes/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/food/monkeycube/gorilla(src)

/obj/item/storage/box/stockparts/basic //for ruins where it's a bad idea to give access to an autolathe/protolathe, but still want to make stock parts accessible
	name = "零件盒"
	desc = "包含各种基本机器零件."

/obj/item/storage/box/stockparts/basic/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/servo = 3,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/micro_laser = 3,
		/obj/item/stock_parts/scanning_module = 3,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/stockparts/deluxe
	name = "豪华零件盒"
	desc = "包含各种豪华机器零件."
	icon_state = "syndiebox"

/obj/item/storage/box/stockparts/deluxe/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stock_parts/capacitor/quadratic = 3,
		/obj/item/stock_parts/scanning_module/triphasic = 3,
		/obj/item/stock_parts/servo/femto = 3,
		/obj/item/stock_parts/micro_laser/quadultra = 3,
		/obj/item/stock_parts/matter_bin/bluespace = 3,
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/rndboards
	name = "\proper 解放者的遗产"
	desc = "一个盒子，里面装着给傀儡们的礼物."
	illustration = "scicircuit"

/obj/item/storage/box/rndboards/PopulateContents()
	new /obj/item/circuitboard/machine/protolathe/offstation(src)
	new /obj/item/circuitboard/machine/destructive_analyzer(src)
	new /obj/item/circuitboard/machine/circuit_imprinter/offstation(src)
	new /obj/item/circuitboard/computer/rdconsole(src)

/obj/item/storage/box/stabilized //every single stabilized extract from xenobiology
	name = "稳定提取物盒"
	icon_state = "syndiebox"

/obj/item/storage/box/stabilized/Initialize(mapload)
	. = ..()
	atom_storage.allow_big_nesting = TRUE
	atom_storage.max_slots = 99
	atom_storage.max_specific_storage = WEIGHT_CLASS_GIGANTIC
	atom_storage.max_total_storage = 99

/obj/item/storage/box/stabilized/PopulateContents()
	var/static/items_inside = list(
		/obj/item/slimecross/stabilized/adamantine=1,
		/obj/item/slimecross/stabilized/black=1,
		/obj/item/slimecross/stabilized/blue=1,
		/obj/item/slimecross/stabilized/bluespace=1,
		/obj/item/slimecross/stabilized/cerulean=1,
		/obj/item/slimecross/stabilized/darkblue=1,
		/obj/item/slimecross/stabilized/darkpurple=1,
		/obj/item/slimecross/stabilized/gold=1,
		/obj/item/slimecross/stabilized/green=1,
		/obj/item/slimecross/stabilized/grey=1,
		/obj/item/slimecross/stabilized/lightpink=1,
		/obj/item/slimecross/stabilized/metal=1,
		/obj/item/slimecross/stabilized/oil=1,
		/obj/item/slimecross/stabilized/orange=1,
		/obj/item/slimecross/stabilized/pink=1,
		/obj/item/slimecross/stabilized/purple=1,
		/obj/item/slimecross/stabilized/pyrite=1,
		/obj/item/slimecross/stabilized/rainbow=1,
		/obj/item/slimecross/stabilized/red=1,
		/obj/item/slimecross/stabilized/sepia=1,
		/obj/item/slimecross/stabilized/silver=1,
		/obj/item/slimecross/stabilized/yellow=1,
		)
	generate_items_inside(items_inside,src)
