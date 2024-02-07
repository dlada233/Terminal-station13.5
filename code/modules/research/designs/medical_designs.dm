/////////////////////////////////////////
////////////Medical Tools////////////////
/////////////////////////////////////////

/datum/design/healthanalyzer
	name = "健康分析仪-Health Analyzer"
	id = "healthanalyzer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/healthanalyzer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/autopsy_scanner
	name = "尸检扫描仪-Autopsy Scanner"
	id = "autopsyscanner"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*5, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/autopsy_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/bluespacebeaker
	name = "蓝空烧杯-Bluespace Beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/plastic =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace =HALF_SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	build_path = /obj/item/reagent_containers/cup/beaker/bluespace
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/noreactbeaker
	name = "冷冻烧杯-Cryostasis Beaker"
	desc = "防止化学品反应的冷冻烧杯.可以装下150单位."
	id = "splitbeaker"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	build_path = /obj/item/reagent_containers/cup/beaker/noreact
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/xlarge_beaker
	name = "X-大烧杯-X-large Beaker"
	id = "xlarge_beaker"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*2.5, /datum/material/plastic =SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	build_path = /obj/item/reagent_containers/cup/beaker/plastic
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/meta_beaker
	name = "超材料烧杯-Metamaterial Beaker"
	id = "meta_beaker"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*2.5, /datum/material/plastic =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	build_path = /obj/item/reagent_containers/cup/beaker/meta
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/ph_meter
	name = "化学物质分析仪-Chemical Analyzer"
	id = "ph_meter"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*2.5, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/ph_meter
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/bluespacesyringe
	name = "蓝空注射器-Bluespace Syringe"
	desc = "一种先进的注射器,可以装下60单位化学品"
	id = "bluespacesyringe"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/reagent_containers/syringe/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/dna_disk
	name = "基因数据盘-Genetic Data Disk"
	desc = "Produce additional disks for storing genetic data."
	id = "dna_disk"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass =SMALL_MATERIAL_AMOUNT, /datum/material/silver =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/disk/data
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GENETICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/piercesyringe
	name = "穿刺型注射器-Piercing Syringe"
	desc = "一个钻石尖端的注射器，以高速发射出去时能刺穿装甲.可以装下10单位."
	id = "piercesyringe"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/reagent_containers/syringe/piercing
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/bluespacebodybag
	name = "蓝空裹尸袋-Bluespace Body Bag"
	desc = "使用实验性蓝空技术的蓝空裹尸袋.它可以容纳大量尸体和体型最大的生物."
	id = "bluespacebodybag"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plasma =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SMALL_MATERIAL_AMOUNT*5, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/bodybag/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/plasmarefiller
	name = "等离子人灭火服补充包-Plasmaman Jumpsuit Refill"
	desc = "等离子人服装上的自动灭火器的补充包."
	id = "plasmarefiller" //Why did this have no plasmatech
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/extinguisher_refill
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GAS_TANKS_EQUIPMENT
	)
	departmental_flags = ALL

/datum/design/crewpinpointer
	name = "船员追踪器-Crew Pinpointer"
	desc = "Allows tracking of someone's location if their suit sensors are turned to tracking beacon."
	id = "crewpinpointer"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/pinpointer/crew
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/defibrillator
	name = "除颤器-Defibrillator"
	desc = "A portable defibrillator, used for resuscitating recently deceased crew."
	id = "defibrillator"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/defibrillator
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*4, /datum/material/glass = SHEET_MATERIAL_AMOUNT*2, /datum/material/silver =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/defibrillator_mount
	name = "壁挂式除颤器-Defibrillator Wall Mount"
	desc = "A mounted frame for holding defibrillators, providing easy security."
	id = "defibmountdefault"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/wallframe/defib_mount
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/defibrillator_mount_charging
	name = "PENLITE型壁挂式除颤器-PENLITE Defibrillator Wall Mount"
	desc = "一款多功能壁挂式支架，用于容纳除颤器支架配有 ID 锁定夹具和充电线.PENLITE型号还可以为除颤器被动的缓慢充能."
	id = "defibmount"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/wallframe/defib_mount/charging
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/defibrillator_compact
	name = "紧凑型除颤器-Compact Defibrillator"
	desc = "一款可穿戴在腰部的紧凑型除颤器."
	id = "defibrillator_compact"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/defibrillator/compact
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*6, /datum/material/glass = SHEET_MATERIAL_AMOUNT*4, /datum/material/silver = SHEET_MATERIAL_AMOUNT*3, /datum/material/gold =SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/genescanner
	name = "基因序列分析仪-Genetic Sequence Analyzer"
	desc = "A handy hand-held analyzers for quickly determining mutations and collecting the full sequence."
	id = "genescanner"
	build_path = /obj/item/sequence_scanner
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GENETICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/healthanalyzer_advanced
	name = "高级健康分析仪-Advanced Health Analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject with high accuracy."
	id = "healthanalyzer_advanced"
	build_path = /obj/item/healthanalyzer/advanced
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/silver =SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/medigel
	name = "医用凝胶-Medical Gel"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap."
	id = "medigel"
	build_path = /obj/item/reagent_containers/medigel
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/surgical_drapes
	name = "手术布-Surgical Drapes"
	id = "surgical_drapes"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/surgical_drapes
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/laserscalpel
	name = "激光手术刀-Laser Scalpel"
	desc = "A laser scalpel used for precise cutting."
	id = "laserscalpel"
	build_path = /obj/item/scalpel/advanced
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/diamond =SMALL_MATERIAL_AMOUNT * 2, /datum/material/titanium = SHEET_MATERIAL_AMOUNT*2)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/mechanicalpinches
	name = "机械缩剪器-Mechanical Pinches"
	desc = "These pinches can be either used as retractor or hemostat."
	id = "mechanicalpinches"
	build_path = /obj/item/retractor/advanced
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*6, /datum/material/glass = SHEET_MATERIAL_AMOUNT*2, /datum/material/silver = SHEET_MATERIAL_AMOUNT*2, /datum/material/titanium =SHEET_MATERIAL_AMOUNT * 2.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/searingtool
	name = "烙合器-Searing Tool"
	desc = "Used to mend tissue together. Or drill tissue away."
	id = "searingtool"
	build_path = /obj/item/cautery/advanced
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/plasma =SHEET_MATERIAL_AMOUNT, /datum/material/uranium =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/titanium =SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/medical_spray_bottle
	name = "医疗喷雾瓶-Medical Spray Bottle"
	desc = "A traditional spray bottle used to generate a fine mist. Not to be confused with a medspray."
	id = "med_spray_bottle"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/reagent_containers/spray/medical
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/chem_pack
	name = "静脉注射医疗袋-Intravenous Medicine Bag"
	desc = "A plastic pressure bag for IV administration of drugs."
	id = "chem_pack"
	build_type = PROTOLATHE | AWAY_LATHE
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/reagent_containers/chem_pack
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/blood_pack
	name = "血袋-Blood Pack"
	desc = "Is used to contain blood used for transfusion. Must be attached to an IV drip."
	id = "blood_pack"
	build_type = PROTOLATHE | AWAY_LATHE
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
	materials = list(/datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/reagent_containers/blood
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/portable_chem_mixer
	name = "便携式化学混合器-Portable Chemical Mixer"
	desc = "A portable device that dispenses and mixes chemicals. Reagents have to be supplied with beakers."
	id = "portable_chem_mixer"
	build_type = PROTOLATHE | AWAY_LATHE
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/storage/portable_chem_mixer
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/medical_bed
	name = "医疗床-Medical Bed"
	desc = "A bed made of sterile materials ideal for use in the medical field. Patient assistance or joyriding, it'll do it all!"
	id = "medicalbed"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2.7, /datum/material/plastic = SHEET_MATERIAL_AMOUNT * 1.7)
	build_path = /obj/structure/bed/medical
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/emergency_bed
	name = "应急医疗床-Medical Bed (Emergency)"
	desc = "A portable, foldable version of the medical bed. Perfect for paramedics or whenever you have mass casualties!"
	id = "medicalbed_emergency"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2.7, /datum/material/plastic = SHEET_MATERIAL_AMOUNT * 1.7)
	build_path = /obj/item/emergency_bed
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/penlight
	name = "笔形电筒-Penlight"
	id = "penlight"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/flashlight/pen
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/penlight_paramedic
	name = "护理员笔形电筒-Paramedic Penlight"
	id = "penlight_paramedic"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*1)
	build_path = /obj/item/flashlight/pen/paramedic
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/////////////////////////////////////////
//////////Cybernetic Implants////////////
/////////////////////////////////////////

/datum/design/cyberimp_breather
	name = "呼吸管植入物-Breathing Tube Implant"
	desc = "这个简单的植入物在你的背部添加了一个呼吸配件连接器，可以让你在没有佩戴面罩的情况下使用呼吸配件并防止你窒息."
	id = "ci-breather"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 35
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*6, /datum/material/glass = SMALL_MATERIAL_AMOUNT*2.5)
	build_path = /obj/item/organ/internal/cyberimp/mouth/breathing_tube
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_surgical
	name = "外科手术臂植入物-Surgical Arm Implant"
	desc = "一套手术用具，收纳于使用者手臂上的隐蔽嵌板."
	id = "ci-surgery"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list (/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	construction_time =SMALL_MATERIAL_AMOUNT * 2
	build_path = /obj/item/organ/internal/cyberimp/arm/surgery
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_toolset
	name = "工具臂植入物-Toolset Arm Implant"
	desc = "一套精简版的工程赛博工具组，可安装在对象的手臂上."
	id = "ci-toolset"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list (/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	construction_time =SMALL_MATERIAL_AMOUNT * 2
	build_path = /obj/item/organ/internal/cyberimp/arm/toolset
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_medical_hud
	name = "医疗HUD植入物-Medical HUD Implant"
	desc = "这对电子眼会在你视野内的一切活物上显示医疗HUD.转动眼球来控制."
	id = "ci-medhud"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 50
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/internal/cyberimp/eyes/hud/medical
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_security_hud
	name = "安保HUD植入物-Security HUD Implant"
	desc = "这对电子眼会在你视野内的一切东西上显示安保HUD.转动眼球来控制."
	id = "ci-sechud"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 50
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*7.5,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*7.5,
	)
	build_path = /obj/item/organ/internal/cyberimp/eyes/hud/security
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_diagnostic_hud
	name = "诊断HUD植入物-Diagnostic HUD Implant"
	desc = "这对电子眼会在你视野内的一切上显示诊断HUD.转动眼球来控制.."
	id = "ci-diaghud"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 50
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*6,
	)
	build_path = /obj/item/organ/internal/cyberimp/eyes/hud/diagnostic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_xray
	name = "X光眼-X-ray Eyes"
	desc = "这对电子眼球会带给你X射线视觉.眨眼变得毫无意义."
	id = "ci-xray"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 60
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/internal/eyes/robotic/xray
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_xray/moth
	name = "X光蛾眼-Moth X-ray Eyes"
	id = "ci-xray-moth"
	build_path = /obj/item/organ/internal/eyes/robotic/xray/moth

/datum/design/cyberimp_thermals
	name = "热成像眼-Thermal Eyes"
	desc = "这对电子眼球会带给你热视觉.带有缝状竖瞳."
	id = "ci-thermals"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 60
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond =SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/internal/eyes/robotic/thermals
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_thermals/moth
	name = "热成像蛾眼-Moth Thermal Eyes"
	id = "ci-thermals-moth"
	build_path = /obj/item/organ/internal/eyes/robotic/thermals/moth

/datum/design/cyberimp_antidrop
	name = "防掉落植入物-Anti-Drop Implant"
	desc = "这个脑部电子植入物能够让你的手部肌肉强制收缩，以防止物品从手中掉落.抽动耳朵来切换."
	id = "ci-antidrop"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 60
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*4,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*4,
	)
	build_path = /obj/item/organ/internal/cyberimp/brain/anti_drop
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_antistun
	name = "中枢神经重启植入物-CNS Rebooter Implant"
	desc = "这个植入物将自动恢复你对中枢神经系统的控制，减少晕眩的恢复时间."
	id = "ci-antistun"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 60
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/internal/cyberimp/brain/anti_stun
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_nutriment
	name = "营养泵植入物-Nutriment Pump Implant"
	desc = "这个植入物会在使用者饥饿时合成并泵入少量营养物质到血液中."
	id = "ci-nutriment"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/internal/cyberimp/chest/nutriment
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_nutriment_plus
	name = "高级营养泵植入物-Nutriment Pump Implant PLUS"
	desc = "这个植入物会在使用者饥饿时合成并泵入少量营养物质到血液中."
	id = "ci-nutrimentplus"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 50
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT*7.5,
	)
	build_path = /obj/item/organ/internal/cyberimp/chest/nutriment/plus
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_reviver
	name = "复活植入物-Reviver Implant"
	desc = "这个植入物在你失去意识时会尝试唤醒你.适合那些胆小的人"
	id = "ci-reviver"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 60
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*8,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*8,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/internal/cyberimp/chest/reviver
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_thrusters
	name = "内嵌推进器植入物-Thrusters Set Implant"
	desc = "这个植入物可以让你在零重力条件下使用环境气体或呼吸配件内的气体来推进."
	id = "ci-thrusters"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 80
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*2,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT,
		/datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/internal/cyberimp/chest/thrusters
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/////////////////////////////////////////
////////////Regular Implants/////////////
/////////////////////////////////////////

/datum/design/implanter
	name = "植入器-Implanter"
	desc = "一个无菌自动植入物注射器."
	id = "implanter"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*6, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/implanter
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/implantcase
	name = "植入物盒-Implant Case"
	desc = "一个用来装植入物的玻璃盒."
	id = "implantcase"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/implantcase
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/implant_sadtrombone
	name = "'悲伤长号'植入物盒"
	desc = "令死亡也能引人发笑."
	id = "implant_trombone"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/bananium =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/implantcase/sad_trombone
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/implant_chem
	name = "'化合物'植入物盒-Chemical Implant Case"
	desc = "一个包含植入物的玻璃盒."
	id = "implant_chem"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = SMALL_MATERIAL_AMOUNT*7)
	build_path = /obj/item/implantcase/chem
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/implant_tracking
	name = "'跟踪'植入物盒-Tracking Implant Case"
	desc = "一个包含植入物的玻璃盒."
	id = "implant_tracking"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/implantcase/tracking
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_MEDICAL

//Cybernetic organs

/datum/design/cybernetic_liver
	name = "初级电子肝-Basic Cybernetic Liver"
	desc = "A basic cybernetic liver."
	id = "cybernetic_liver"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/liver/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_liver/tier2
	name = "电子肝-Cybernetic Liver"
	desc = "一块电子肝."
	id = "cybernetic_liver_tier2"
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/liver/cybernetic/tier2
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_liver/tier3
	name = "高级电子肝-Upgraded Cybernetic Liver"
	desc = "一块升级的电子肝."
	id = "cybernetic_liver_tier3"
	construction_time = 50
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver=SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/liver/cybernetic/tier3
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_heart
	name = "初级电子心-Basic Cybernetic Heart"
	desc = "一颗初级电子心."
	id = "cybernetic_heart"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/heart/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_heart/tier2
	name = "电子心-Cybernetic Heart"
	desc = "一颗电子心."
	id = "cybernetic_heart_tier2"
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/heart/cybernetic/tier2
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_heart/tier3
	name = "高级电子心-Upgraded Cybernetic Heart"
	desc = "一块升级的电子心脏."
	id = "cybernetic_heart_tier3"
	construction_time = 50
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver=SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/heart/cybernetic/tier3
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_lungs
	name = "初级电子肺-Basic Cybernetic Lungs"
	desc = "A basic pair of cybernetic lungs."
	id = "cybernetic_lungs"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/lungs/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_lungs/tier2
	name = "电子肺-Cybernetic Lungs"
	desc = "一对电子肺."
	id = "cybernetic_lungs_tier2"
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/lungs/cybernetic/tier2
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_lungs/tier3
	name = "高级电子肺-Upgraded Cybernetic Lungs"
	desc = "A pair of upgraded cybernetic lungs."
	id = "cybernetic_lungs_tier3"
	construction_time = 50
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/lungs/cybernetic/tier3
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_stomach
	name = "初级电子胃-Basic Cybernetic Stomach"
	desc = "一块初级电子胃."
	id = "cybernetic_stomach"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/stomach/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_stomach/tier2
	name = "电子胃-Cybernetic Stomach"
	desc = "一块电子胃."
	id = "cybernetic_stomach_tier2"
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/stomach/cybernetic/tier2
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_stomach/tier3
	name = "高级电子胃-Upgraded Cybernetic Stomach"
	desc = "一个升级的电子胃."
	id = "cybernetic_stomach_tier3"
	construction_time = 50
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/internal/stomach/cybernetic/tier3
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_ears
	name = "初级电子耳-Basic Cybernetic Ears"
	desc = "一对初级电子耳."
	id = "cybernetic_ears"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT*4)
	build_path = /obj/item/organ/internal/ears/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_ears_u
	name = "电子耳-Cybernetic Ears"
	desc = "一对电子耳."
	id = "cybernetic_ears_u"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/internal/ears/cybernetic/upgraded
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_ears_whisper
	name = "微敏电子耳-Whisper-sensitive Cybernetic Ears"
	desc = "A pair of whisper-sensitive cybernetic ears."
	id = "cybernetic_ears_whisper"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/internal/ears/cybernetic/whisper
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_ears_xray
	name = "穿墙电子耳-Wall-penetrating Cybernetic Ears"
	desc = "A pair of wall-penetrating cybernetic ears."
	id = "cybernetic_ears_xray"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/internal/ears/cybernetic/xray
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_eyes
	name = "初级电子耳-Basic Cybernetic Eyes"
	desc = "一对基础电子眼."
	id = "cybernetic_eyes"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT*4)
	build_path = /obj/item/organ/internal/eyes/robotic/basic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_eyes/moth
	name = "初级电子蛾眼-Basic Cybernetic Moth Eyes"
	id = "cybernetic_eyes_moth"
	build_path = /obj/item/organ/internal/eyes/robotic/basic/moth

/datum/design/cybernetic_eyes/improved
	name = "电子眼-Cybernetic Eyes"
	desc = "一对电子眼."
	id = "cybernetic_eyes_improved"
	build_path = /obj/item/organ/internal/eyes/robotic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_eyes/improved/moth
	name = "电子蛾眼-Cybernetic Moth Eyes"
	id = "cybernetic_eyes_improved_moth"
	build_path = /obj/item/organ/internal/eyes/robotic/moth

/datum/design/cyberimp_welding
	name = "机械屏障眼-Welding Shield Eyes"
	desc = "这些反应式微型屏障会保护你的眼睛免受焊光和闪光弹的伤害，并且不会减弱你的视力."
	id = "ci-welding"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*6, /datum/material/glass = SMALL_MATERIAL_AMOUNT*4)
	build_path = /obj/item/organ/internal/eyes/robotic/shield
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_welding/moth
	name = "机械屏障蛾眼-Welding Shield Moth Eyes"
	id = "ci-welding-moth"
	build_path = /obj/item/organ/internal/eyes/robotic/shield/moth

/datum/design/cyberimp_gloweyes
	name = "荧光眼-Luminescent Eyes"
	desc = "A pair of cybernetic eyes that can emit multicolored light"
	id = "ci-gloweyes"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*6, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/organ/internal/eyes/robotic/glow
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_gloweyes/moth
	name = "荧光蛾眼-Luminescent Moth Eyes"
	id = "ci-gloweyes-moth"
	build_path = /obj/item/organ/internal/eyes/robotic/glow/moth

/////////////////////
///Surgery Designs///
/////////////////////

/datum/design/surgery
	name = "Surgery Design"
	desc = "what"
	id = "surgery_parent"
	research_icon = 'icons/obj/medical/surgery_ui.dmi'
	research_icon_state = "surgery_any"
	var/surgery

/datum/design/surgery/lobotomy
	name = "脑叶切除术-Lobotomy"
	desc = "一种侵入性外科手术，可以保证能移除几乎所有的脑创伤，但也可能造成另一种永久性的创伤."
	id = "surgery_lobotomy"
	surgery = /datum/surgery/advanced/lobotomy
	research_icon_state = "surgery_head"

/datum/design/surgery/pacify
	name = "无害化手术-Pacification"
	desc = "一种抑制大脑攻击性中枢神经的永久性手术, 使患者无法再造成直接伤害."
	id = "surgery_pacify"
	surgery = /datum/surgery/advanced/pacify
	research_icon_state = "surgery_head"

/datum/design/surgery/viral_bonding
	name = "病毒结合术-Viral Bonding"
	desc = "一种迫使病毒与宿主之间形成共生关系的手术. 术后患者必须服用 太空西林('Spaceacillin')、病毒食物('Virus food') 与甲醛('Formaldehyde')."
	id = "surgery_viral_bond"
	surgery = /datum/surgery/advanced/viral_bonding
	research_icon_state = "surgery_chest"

/datum/design/surgery/healing //PLEASE ACCOUNT FOR UNIQUE HEALING BRANCHES IN THE hptech HREF (currently 2 for Brute/Burn; Combo is bonus)
	name = "伤口护理-Tend Wounds"
	desc = "An upgraded version of the original surgery."
	id = "surgery_healing_base" //holder because CI cries otherwise. Not used in techweb unlocks.
	surgery = /datum/surgery/healing
	research_icon_state = "surgery_chest"

/datum/design/surgery/healing/brute_upgrade
	name = "伤口护理 (创伤) 升级-Tend Wounds (Brute) Upgrade"
	surgery = /datum/surgery/healing/brute/upgraded
	id = "surgery_heal_brute_upgrade"

/datum/design/surgery/healing/brute_upgrade_2
	name = "伤口护理 (创伤) 升级-Tend Wounds (Brute) Upgrade"
	surgery = /datum/surgery/healing/brute/upgraded/femto
	id = "surgery_heal_brute_upgrade_femto"

/datum/design/surgery/healing/burn_upgrade
	name = "伤口护理 (烧伤) 升级-Tend Wounds (Burn) Upgrade"
	surgery = /datum/surgery/healing/burn/upgraded
	id = "surgery_heal_burn_upgrade"

/datum/design/surgery/healing/burn_upgrade_2
	name = "伤口护理 (烧伤) 升级-Tend Wounds (Burn) Upgrade"
	surgery = /datum/surgery/healing/burn/upgraded/femto
	id = "surgery_heal_burn_upgrade_femto"

/datum/design/surgery/healing/combo
	name = "伤口护理 (躯体)-Tend Wounds (Physical)"
	desc = "A surgical procedure that repairs both bruises and burns. Repair efficiency is not as high as the individual surgeries but it is faster."
	surgery = /datum/surgery/healing/combo
	id = "surgery_heal_combo"

/datum/design/surgery/healing/combo_upgrade
	name = "伤口护理 (躯体) 升级-Tend Wounds (Physical) Upgrade"
	surgery = /datum/surgery/healing/combo/upgraded
	id = "surgery_heal_combo_upgrade"

/datum/design/surgery/healing/combo_upgrade_2
	name = "伤口护理 (躯体) 升级-Tend Wounds (Physical) Upgrade"
	desc = "A surgical procedure that repairs both bruises and burns faster than their individual counterparts. It is more effective than both the individual surgeries."
	surgery = /datum/surgery/healing/combo/upgraded/femto
	id = "surgery_heal_combo_upgrade_femto"

/datum/design/surgery/brainwashing
	name = "洗脑-Brainwashing"
	desc = "能将指令直接植入病人大脑的外科手术，使指令成为他们的首要任务.可以用心灵护盾植入物取消这种状态."
	id = "surgery_brainwashing"
	surgery = /datum/surgery/advanced/brainwashing
	research_icon_state = "surgery_head"

/datum/design/surgery/nerve_splicing
	name = "神经拼接-Nerve Splicing"
	desc = "一种将神经拼接起来的增强手术，使得躯体更能抵抗眩晕."
	id = "surgery_nerve_splice"
	surgery = /datum/surgery/advanced/bioware/nerve_splicing
	research_icon_state = "surgery_chest"

/datum/design/surgery/nerve_grounding
	name = "神经接地-Nerve Grounding"
	desc = "一种将神经如接地棒般运作的增强手术，使得躯体免受电击."
	id = "surgery_nerve_ground"
	surgery = /datum/surgery/advanced/bioware/nerve_grounding
	research_icon_state = "surgery_chest"

/datum/design/surgery/vein_threading
	name = "脉络穿线-Vein Threading"
	desc = "一种能大大减少伤口出血量的增强手术."
	id = "surgery_vein_thread"
	surgery = /datum/surgery/advanced/bioware/vein_threading
	research_icon_state = "surgery_chest"

/datum/design/surgery/muscled_veins
	name = "脉络肌肉膜-Vein Muscle Membrane"
	desc = "一种在血管上覆盖肌肉膜的增强手术，使得无需心脏即可依靠血管自身泵血."
	id = "surgery_muscled_veins"
	surgery = /datum/surgery/advanced/bioware/muscled_veins
	research_icon_state = "surgery_chest"

/datum/design/surgery/ligament_hook
	name = "韧带钩-Ligament Hook"
	desc = "一种外科手术，在躯干和四肢的关节处添加一层保护组织和骨骼囊，防止肢体断裂.然而，这种手术也会使神经连接更容易中断，从而导致受损肢体失能."
	id = "surgery_ligament_hook"
	surgery = /datum/surgery/advanced/bioware/ligament_hook
	research_icon_state = "surgery_chest"

/datum/design/surgery/ligament_reinforcement
	name = "韧带加固-Ligament Reinforcement"
	desc = "一种重塑身体躯干和四肢之间的关节的外科手术，即使四肢被切断，也可以手动重新接回.然而，这种手术也会削弱关节连接强度，更容易再次脱落."
	id = "surgery_ligament_reinforcement"
	surgery = /datum/surgery/advanced/bioware/ligament_reinforcement
	research_icon_state = "surgery_chest"

/datum/design/surgery/cortex_imprint
	name = "皮层印迹-Cortex Imprint"
	desc = "一种将大脑皮层改造为冗余神经模式的增强手术，使大脑能够避免较微脑损伤带来的不必要麻烦."
	id = "surgery_cortex_imprint"
	surgery = /datum/surgery/advanced/bioware/cortex_imprint
	research_icon_state = "surgery_head"

/datum/design/surgery/cortex_folding
	name = "皮层折叠-Cortex Folding"
	desc = "一种将大脑皮层折叠成复杂褶皱的增强手术，为非标准神经模式提供了更多空间."
	id = "surgery_cortex_folding"
	surgery = /datum/surgery/advanced/bioware/cortex_folding
	research_icon_state = "surgery_head"

/datum/design/surgery/necrotic_revival
	name = "坏死复苏-Necrotic Revival"
	desc = "刺激患者脑内罗梅罗肿瘤生长的实验性外科手术，手术需要zombie powder(尸粉)或rezadone(类泽多)."
	id = "surgery_zombie"
	surgery = /datum/surgery/advanced/necrotic_revival
	research_icon_state = "surgery_head"

/datum/design/surgery/wing_reconstruction
	name = "翅膀重构-Wing Reconstruction"
	desc = "一种重构蛾类人受损的翅膀的实验性手术. 需要 合成肉'Synthflesh'."
	id = "surgery_wing_reconstruction"
	surgery = /datum/surgery/advanced/wing_reconstruction
	research_icon_state = "surgery_chest"

/datum/design/surgery/advanced_plastic_surgery
	name = "高级整形手术-Advanced Plastic Surgery"
	desc = "一种高级整形手术，可通过照片模板调整患者的五官和声音."
	surgery = /datum/surgery/plastic_surgery/advanced
	id = "surgery_advanced_plastic_surgery"
	research_icon_state = "surgery_head"

/datum/design/surgery/experimental_dissection
	name = "实验性解剖-Experimental Dissection"
	desc = "一种实验性外科手术，用于解剖尸体，并通过古老的研发控制台换取研究点数."
	id = "surgery_oldstation_dissection"
	surgery = /datum/surgery/advanced/experimental_dissection
	research_icon_state = "surgery_chest"
