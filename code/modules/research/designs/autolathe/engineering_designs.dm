/datum/design/solar
	name = "Solar Panel Frame-太阳能板框架"
	id = "solar_panel"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.75, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/solar_assembly
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/sparker
	name = "Sparker WallFrame-电火花器壁式框架"
	id = "sparker"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/wallframe/sparker
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/tracker_electronics
	name = "Solar Tracking Electronics-太阳能跟踪电路板"
	id = "solar_tracker"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/electronics/tracker
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ELECTRONICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/control
	name = "Blast Door Controller-防爆门控制器"
	id = "blast"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/assembly/control
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ELECTRONICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/ignition_control
	name = "Ignition Switch Controller-点火开关控制器"
	id = "ignition"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/assembly/control/igniter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ELECTRONICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/custom_vendor_refill
	name = "Custom Vendor Refill-自定义贩卖机装填"
	id = "custom_vendor_refill"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/vending_refill/custom
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_MISC,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING


/datum/design/miniature_power_cell
	name = "Light Fixture Battery-灯管支架电池"
	id = "miniature_power_cell"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*0.2)
	build_path = /obj/item/stock_parts/cell/emergency_light
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_LIGHTING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/geiger
	name = "Geiger Counter-盖革计数器"
	id = "geigercounter"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*1.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT*1.5)
	build_path = /obj/item/geiger_counter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/turret_control_frame
	name = "Turret Control Frame-炮塔控制装置框架"
	id = "turret_control"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*6)
	build_path = /obj/item/wallframe/turret_control
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/large_welding_tool
	name = "Industrial Welding Tool-工业用焊接工具"
	id = "large_welding_tool"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.7, /datum/material/glass = SMALL_MATERIAL_AMOUNT*0.6)
	build_path = /obj/item/weldingtool/largetank/empty
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/camera_assembly
	name = "Camera Assembly-摄像头组件"
	id = "camera_assembly"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*4, /datum/material/glass = SMALL_MATERIAL_AMOUNT*2.5)
	build_path = /obj/item/wallframe/camera
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/newscaster_frame
	name = "Newscaster Frame-新闻广播器框架"
	id = "newscaster_frame"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*7, /datum/material/glass = SHEET_MATERIAL_AMOUNT*4)
	build_path = /obj/item/wallframe/newscaster
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/status_display_frame
	name = "Status Display Frame-状态显示器框架"
	id = "status_display_frame"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*7, /datum/material/glass = SHEET_MATERIAL_AMOUNT*4)
	build_path = /obj/item/wallframe/status_display
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING


/datum/design/intercom_frame
	name = "Intercom Frame-对讲机框架"
	id = "intercom_frame"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.75, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.25)
	build_path = /obj/item/wallframe/intercom
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/earmuffs
	name = "Earmuffs-耳罩"
	id = "earmuffs"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/ears/earmuffs
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/pipe_painter
	name = "Pipe Painter-管道涂手"
	id = "pipe_painter"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/pipe_painter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/airlock_painter
	name = "Airlock Painter-气闸涂手"
	id = "airlock_painter"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/airlock_painter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/airlock_painter/decal
	name = "Decal Painter-气闸涂手+"
	id = "decal_painter"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/airlock_painter/decal
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/airlock_painter/decal/tile
	name = "Tile Sprayer-地板涂手"
	id = "tile_sprayer"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/airlock_painter/decal/tile
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/apc_board
	name = "APC Module-APC模块"
	id = "power_control"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/electronics/apc
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ELECTRONICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/airlock_board
	name = "Airlock Electronics-气闸电路板"
	id = "airlock_board"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/electronics/airlock
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ELECTRONICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/firelock_board
	name = "Firelock Circuitry-防火闸电路板"
	id = "firelock_board"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/electronics/firelock
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ELECTRONICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/airalarm_electronics
	name = "Air Alarm Electronics-空气警报器电路板"
	id = "airalarm_electronics"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/electronics/airalarm
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ELECTRONICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/firealarm_electronics
	name = "Fire Alarm Electronics-火灾警报器电路板"
	id = "firealarm_electronics"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/electronics/firealarm
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ELECTRONICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/trapdoor_electronics
	name = "Trapdoor Controller Electronics-活板门控制器电路板"
	id = "trapdoor_electronics"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/assembly/trapdoor
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_ELECTRONICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/extinguisher
	name = "Fire Extinguisher-灭火器"
	id = "extinguisher"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/extinguisher/empty
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ATMOSPHERICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/pocketfireextinguisher
	name = "Pocket Fire Extinguisher-便携式灭火器"
	id = "pocketfireextinguisher"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT*0.4)
	build_path = /obj/item/extinguisher/mini/empty
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ATMOSPHERICS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/requests_console
	name = "Requests Console Frame-请求控制台框架"
	id = "requests_console"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*7, /datum/material/glass = SHEET_MATERIAL_AMOUNT*4)
	build_path = /obj/item/wallframe/requests_console
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/light_switch_frame
	name = "Light Switch Frame-灯开关框架"
	id = "light_switch_frame"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.75, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.25)
	build_path = /obj/item/wallframe/light_switch
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/telescreen_turbine
	name = "Turbine Telescreen-涡轮机电幕"
	id = "telescreen_turbine"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/wallframe/telescreen/turbine
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/telescreen_engine
	name = "Engine Telescreen-工程电幕"
	id = "telescreen_engine"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/wallframe/telescreen/engine
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/telescreen_auxbase
	name = "Auxiliary Base Telescreen-辅助基地电幕"
	id = "telescreen_auxbase"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/wallframe/telescreen/auxbase
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/tram_controller
	name = "Tram Controller Cabinet-电车主控柜"
	id = "tram_controller"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 7,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 7,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/wallframe/tram/controller
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/tram_display
	name = "Tram Indicator Display-电车指示显示器"
	id = "tram_display"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/wallframe/indicator_display
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/tram_floor_dark
	name = "Dark Tram Tile-暗色电车地板"
	id = "tram_floor_dark"
	build_type = PROTOLATHE
	materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 0.25)
	build_path = /obj/item/stack/thermoplastic
	maxstack = 50
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/tram_floor_light
	name = "Light Tram Tile-亮色电车地板"
	id = "tram_floor_light"
	build_type = PROTOLATHE
	materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 0.25)
	build_path = /obj/item/stack/thermoplastic/light
	maxstack = 50
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING
