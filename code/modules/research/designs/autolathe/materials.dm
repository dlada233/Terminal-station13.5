/datum/design/iron
	name = "iron-铁"
	id = "iron"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/iron
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50

/datum/design/rods
	name = "Iron Rod-铁棒"
	id = "rods"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/rods
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50

/datum/design/glass
	name = "Glass-玻璃"
	id = "glass"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/glass
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50

/datum/design/rglass
	name = "Reinforced Glass-强化玻璃"
	id = "rglass"
	build_type = AUTOLATHE | SMELTER | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/rglass
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/silver
	name = "Silver-银"
	id = "silver"
	build_type = AUTOLATHE
	materials = list(/datum/material/silver = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/silver
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50

/datum/design/gold
	name = "Gold-金"
	id = "gold"
	build_type = AUTOLATHE
	materials = list(/datum/material/gold = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/gold
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50

/datum/design/diamond
	name = "Diamond-钻石"
	id = "diamond"
	build_type = AUTOLATHE
	materials = list(/datum/material/diamond = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/diamond
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50

/datum/design/plasma
	name = "Plasma-等离子"
	id = "plasma"
	build_type = AUTOLATHE
	materials = list(/datum/material/plasma = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/plasma
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50

/datum/design/uranium
	name = "Uranium-铀"
	id = "uranium"
	build_type = AUTOLATHE
	materials = list(/datum/material/uranium = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/uranium
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50

/datum/design/bananium
	name = "Bananium-蕉矿"
	id = "bananium"
	build_type = AUTOLATHE
	materials = list(/datum/material/bananium = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/bananium
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50

/datum/design/titanium
	name = "Titanium-钛钢"
	id = "titanium"
	build_type = AUTOLATHE
	materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/titanium
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50

/datum/design/plastic
	name = "Plastic-塑料"
	id = "plastic"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plastic
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	maxstack = 50
