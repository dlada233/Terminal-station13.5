/datum/design/cyberimp_mantis
	name = "螳螂刀植入物-Mantis Blade Implant"
	desc = "一种安装在前臂内的的螳螂状刀片，锋利无比，作为致命的自卫武器。."
	id = "ci-mantis"
	build_type = MECHFAB
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 200
	build_path = /obj/item/organ/internal/cyberimp/arm/armblade
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/cyberimp_claws
	name = "指尖剃刃植入物-Razor Claws Implant"
	desc = "植入式双刃型指尖剃刃，适用于各种切割场景."
	id = "ci-razor"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	build_path = /obj/item/organ/internal/cyberimp/arm/razor_claws
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SECURITY

/datum/design/cyberimp_hacker
	name = "骇客臂植入物-Hacking Hand Implant"
	desc = "一套安装在使用者手臂上的植入物，收纳了高级黑客工具和机器改装工具组."
	id = "ci-hacker"
	build_type = MECHFAB
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 200
	build_path = /obj/item/organ/internal/cyberimp/arm/hacker
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/cyberimp_flash
	name = "光子投影植入物-Photon Projector Implant"
	desc = "一种安装在使用者手臂上的集成投影仪，可以用作强力闪光灯."
	id = "ci-flash"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 200
	build_path = /obj/item/organ/internal/cyberimp/arm/flash
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_botany
	name = "植物学臂植入物-Botany Arm Implant"
	desc = "一套手臂植入物，包含植物学家所需的一切工具，可安装在使用者手臂上."
	id = "ci-botany"
	build_type = MECHFAB | PROTOLATHE
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 200
	build_path = /obj/item/organ/internal/cyberimp/arm/botany
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SERVICE

/datum/design/cyberimp_nv
	name = "夜视眼-Night Vision Eyes"
	desc = "这对仿生眼能提供夜视功能.外观大而狰狞，绿油油的."
	id = "ci-nv"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/internal/eyes/night_vision/cyber
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_antisleep
	name = "中枢神经唤醒植入物-CNS Jumpstarter Implant"
	desc = "这个植入物将自动尝试电击来唤醒使用者，每次电击之间会有短暂的冷却时间.无法与中枢神经重启植入物同时安装."
	id = "ci-antisleep"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 60
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		)
	build_path = /obj/item/organ/internal/cyberimp/brain/anti_sleep
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_scanner
	name = "内置医疗分析仪-Internal Medical Analyzer"
	desc = "这个植入物直接与使用者身体相连，能实时监测身体状况，并通过意念指令获取详细读数."
	id = "ci-scanner"
	build_type = MECHFAB | PROTOLATHE
	construction_time = 40
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/internal/cyberimp/chest/scanner
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_janitor
	name = "清洁工臂植入物-Janitor Arm Implant"
	desc = "一套手臂植入物，包含多种清洁工具，可安装在使用者手臂上."
	id = "ci-janitor"
	build_type = PROTOLATHE | MECHFAB
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 200
	build_path = /obj/item/organ/internal/cyberimp/arm/janitor
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SERVICE

/datum/design/cyberimp_lighter
	name = "打火机臂植入物-Lighter Arm Implant"
	desc = "植入手臂的打火机，毫无意义."
	id = "ci-lighter"
	build_type = PROTOLATHE | MECHFAB
	materials = list (
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 100
	build_path = /obj/item/organ/internal/cyberimp/arm/lighter
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_MISC,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SERVICE

/datum/design/cyberimp_thermals
	name = "热成像眼-Thermal Eyes"
	id = "ci-thermals"
	build_type = AWAY_LATHE | MECHFAB
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/cyberimp_reviver
	name = "复活植入物-Reviver Implant"
	id = "ci-reviver"
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
