/datum/design/experi_scanner
	name = "实验扫描仪"
	desc = "用于各种扫描实验的实验扫描仪."
	id = "experi_scanner"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/iron =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/experi_scanner
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
