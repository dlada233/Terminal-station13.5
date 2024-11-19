// Medical Designs
/datum/design/pillbottle
	name = "Pill Bottle-药瓶"
	id = "pillbottle"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SMALL_MATERIAL_AMOUNT*0.2, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/storage/pill_bottle
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/stethoscope
	name = "Stethoscope-听诊器"
	id = "stethoscope"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/clothing/neck/stethoscope
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/sticky_tape/surgical
	name = "Surgical Tape-手术胶带"
	id = "surgical_tape"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/stack/sticky_tape/surgical
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

// Science Designs
/datum/design/slime_scanner
	name = "Slime Scanner-史莱姆扫描仪"
	id = "slime_scanner"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/slime_scanner
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_XENOBIOLOGY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/petridish
	name = "Petri Dish-培养皿"
	id = "petri_dish"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/petri_dish
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_XENOBIOLOGY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/swab
	name = "Sterile Swab-无菌拭子"
	id = "swab"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/plastic =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/swab
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_XENOBIOLOGY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/telescreen_research
	name = "Research Telescreen-科研监控屏"
	id = "telescreen_research"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 5,
	)
	build_path = /obj/item/wallframe/telescreen/research
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/telescreen_ordnance
	name = "Ordnance Telescreen-军械室监控屏"
	id = "telescreen_ordnance"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 5,
	)
	build_path = /obj/item/wallframe/telescreen/ordnance
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// MedSci Designs
/datum/design/syringe
	name = "Syringe-注射器"
	id = "syringe"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.1, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.2)
	build_path = /obj/item/reagent_containers/syringe
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/dropper
	name = "Dropper-滴管"
	id = "dropper"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.1, /datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.3)
	build_path = /obj/item/reagent_containers/dropper
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/blood_filter
	name = "Blood Filter-血液过滤器"
	id = "blood_filter"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/blood_filter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/scalpel
	name = "Scalpel-手术刀"
	id = "scalpel"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/scalpel
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/circular_saw
	name = "Circular Saw-圆锯"
	id = "circular_saw"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/circular_saw
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/bonesetter
	name = "Bonesetter-接骨器"
	id = "bonesetter"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 5,  /datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.25)
	build_path = /obj/item/bonesetter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/surgicaldrill
	name = "Surgical Drill-外科电钻"
	id = "surgicaldrill"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/surgicaldrill
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/retractor
	name = "Retractor-牵开器"
	id = "retractor"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/retractor
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/cautery
	name = "Cautery-缝合器"
	id = "cautery"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 7.5)
	build_path = /obj/item/cautery
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/hemostat
	name = "Hemostat-止血钳"
	id = "hemostat"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.25)
	build_path = /obj/item/hemostat
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
