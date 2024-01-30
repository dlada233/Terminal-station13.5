// This file contains all boxes used by the Engineering department and its purpose on the station. Also contains stuff we use when we wanna fix up stuff as well or helping us live when shit goes southwardly.

/obj/item/storage/box/metalfoam
	name = "金属泡沫手榴弹盒"
	desc = "用于快速密封船体裂口."
	illustration = "grenade"

/obj/item/storage/box/metalfoam/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/metalfoam(src)

/obj/item/storage/box/smart_metal_foam
	name = "智能金属泡沫手榴弹盒"
	desc = "用于快速密封船体裂口，智能金属使得它会自适应该地区的墙壁类型。"
	illustration = "grenade"

/obj/item/storage/box/smart_metal_foam/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/smart_metal_foam(src)

/obj/item/storage/box/material
	name = "材料盒"
	illustration = "implant"

/obj/item/storage/box/material/Initialize(mapload)
	. = ..()
	atom_storage.allow_big_nesting = TRUE
	atom_storage.max_slots = 99
	atom_storage.max_specific_storage = WEIGHT_CLASS_GIGANTIC
	atom_storage.max_total_storage = 99

/obj/item/storage/box/material/PopulateContents() //less uranium because radioactive
	var/static/items_inside = list(
		/obj/item/stack/sheet/iron/fifty=1,
		/obj/item/stack/sheet/glass/fifty=1,
		/obj/item/stack/sheet/rglass=50,
		/obj/item/stack/sheet/plasmaglass=50,
		/obj/item/stack/sheet/titaniumglass=50,
		/obj/item/stack/sheet/plastitaniumglass=50,
		/obj/item/stack/sheet/plasteel=50,
		/obj/item/stack/sheet/mineral/plastitanium=50,
		/obj/item/stack/sheet/mineral/titanium=50,
		/obj/item/stack/sheet/mineral/gold=50,
		/obj/item/stack/sheet/mineral/silver=50,
		/obj/item/stack/sheet/mineral/plasma=50,
		/obj/item/stack/sheet/mineral/uranium=20,
		/obj/item/stack/sheet/mineral/diamond=50,
		/obj/item/stack/sheet/bluespace_crystal=50,
		/obj/item/stack/sheet/mineral/bananium=50,
		/obj/item/stack/sheet/mineral/wood=50,
		/obj/item/stack/sheet/plastic/fifty=1,
		/obj/item/stack/sheet/runed_metal/fifty=1,
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/debugtools
	name = "调试工具箱"
	icon_state = "syndiebox"

/obj/item/storage/box/debugtools/Initialize(mapload)
	. = ..()
	atom_storage.allow_big_nesting = TRUE
	atom_storage.max_slots = 99
	atom_storage.max_specific_storage = WEIGHT_CLASS_GIGANTIC
	atom_storage.max_total_storage = 99

/obj/item/storage/box/debugtools/PopulateContents()
	var/static/items_inside = list(
		/obj/item/card/emag=1,
		/obj/item/construction/rcd/combat/admin=1,
		/obj/item/disk/tech_disk/debug=1,
		/obj/item/flashlight/emp/debug=1,
		/obj/item/geiger_counter=1,
		/obj/item/healthanalyzer/advanced=1,
		/obj/item/modular_computer/pda/heads/captain=1,
		/obj/item/pipe_dispenser=1,
		/obj/item/stack/spacecash/c1000=50,
		/obj/item/storage/box/beakers/bluespace=1,
		/obj/item/storage/box/beakers/variety=1,
		/obj/item/storage/box/material=1,
		/obj/item/uplink/debug=1,
		/obj/item/uplink/nuclear/debug=1,
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/plastic
	name = "塑料盒"
	desc = "它是一个坚固的塑料盒."
	icon_state = "plasticbox"
	foldable_result = null
	illustration = "writing"
	custom_materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT) //You lose most if recycled.

/obj/item/storage/box/emergencytank
	name = "应急氧气瓶盒"
	desc = "一盒应急氧气瓶."
	illustration = "emergencytank"

/obj/item/storage/box/emergencytank/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/tank/internals/emergency_oxygen(src) //in case anyone ever wants to do anything with spawning them, apart from crafting the box

/obj/item/storage/box/engitank
	name = "大容量应急氧气瓶盒"
	desc = "一盒大容量应急氧气瓶."
	illustration = "extendedtank"

/obj/item/storage/box/engitank/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/tank/internals/emergency_oxygen/engi(src) //in case anyone ever wants to do anything with spawning them, apart from crafting the box
