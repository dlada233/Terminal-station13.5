/* Diffrent misc types of sheets
 * Contains:
 * Iron
 * Plasteel
 * Wood
 * Cloth
 * Plastic
 * Cardboard
 * Paper Frames
 * Runed Metal (cult)
 * Bronze (bake brass)
 */

/*
 * Iron
 */
GLOBAL_LIST_INIT(metal_recipes, list ( \
	new/datum/stack_recipe("stool-凳子", /obj/structure/chair/stool, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("bar stool-酒吧凳", /obj/structure/chair/stool/bar, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("bed-床", /obj/structure/bed, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("double bed-双人床", /obj/structure/bed/double, 4, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	null, \
	new/datum/stack_recipe_list("office chairs-办公椅", list( \
		new/datum/stack_recipe("dark office chair-黑色办公椅", /obj/structure/chair/office, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new/datum/stack_recipe("light office chair-白色办公椅", /obj/structure/chair/office/light, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		)), \
	new/datum/stack_recipe_list("comfy chairs-扶手椅", list( \
		new/datum/stack_recipe("beige comfy chair-米色扶手椅", /obj/structure/chair/comfy/beige, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new/datum/stack_recipe("black comfy chair-黑色扶手椅", /obj/structure/chair/comfy/black, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new/datum/stack_recipe("brown comfy chair-棕色扶手椅", /obj/structure/chair/comfy/brown, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new/datum/stack_recipe("lime comfy chair-黄绿扶手椅", /obj/structure/chair/comfy/lime, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new/datum/stack_recipe("teal comfy chair-蓝绿扶手椅", /obj/structure/chair/comfy/teal, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		)), \
	new/datum/stack_recipe_list("sofas", list(
		new /datum/stack_recipe("sofa (middle)", /obj/structure/chair/sofa/middle, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("sofa (left)", /obj/structure/chair/sofa/left, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("sofa (right)", /obj/structure/chair/sofa/right, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("sofa (corner)", /obj/structure/chair/sofa/corner, 1, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE)
		)), \
	new/datum/stack_recipe_list("corporate sofas", list( \
		new /datum/stack_recipe("sofa (middle)", /obj/structure/chair/sofa/corp, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("sofa (left)", /obj/structure/chair/sofa/corp/left, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("sofa (right)", /obj/structure/chair/sofa/corp/right, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("sofa (corner)", /obj/structure/chair/sofa/corp/corner, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		)), \
	new /datum/stack_recipe_list("benches-长椅", list( \
		new /datum/stack_recipe("长椅(middle)", /obj/structure/chair/sofa/bench, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("长椅(left)", /obj/structure/chair/sofa/bench/left, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("长椅(right)", /obj/structure/chair/sofa/bench/right, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("长椅(corner)", /obj/structure/chair/sofa/bench/corner, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("电车长椅(solo)", /obj/structure/chair/sofa/bench/tram/solo, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("电车长椅(middle)", /obj/structure/chair/sofa/bench/tram, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("电车长椅(left)", /obj/structure/chair/sofa/bench/tram/left, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("电车长椅(right)", /obj/structure/chair/sofa/bench/tram/right, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		new /datum/stack_recipe("电车长椅(corner)", /obj/structure/chair/sofa/bench/tram/corner, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
		)), \
	new /datum/stack_recipe_list("chess pieces-国际象棋", list( \
		new /datum/stack_recipe("White Pawn-白兵", /obj/structure/chess/whitepawn, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("White Rook-白车", /obj/structure/chess/whiterook, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("White Knight-白马", /obj/structure/chess/whiteknight, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("White Bishop-白主教", /obj/structure/chess/whitebishop, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("White Queen-白后", /obj/structure/chess/whitequeen, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("White King-白王", /obj/structure/chess/whiteking, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Black Pawn-黑兵", /obj/structure/chess/blackpawn, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Black Rook-黑车", /obj/structure/chess/blackrook, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Black Knight-黑马", /obj/structure/chess/blackknight, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Black Bishop-黑主教", /obj/structure/chess/blackbishop, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Black Queen-黑后", /obj/structure/chess/blackqueen, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Black King-黑王", /obj/structure/chess/blackking, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
	)),
	new /datum/stack_recipe_list("checkers pieces", list( \
		new /datum/stack_recipe("White Checker Man", /obj/structure/chess/checker/whiteman, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("White Checker King", /obj/structure/chess/checker/whiteking, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Black Checker Man", /obj/structure/chess/checker/blackman, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
		new /datum/stack_recipe("Black Checker King", /obj/structure/chess/checker/blackking, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
	)),
	null, \
	new/datum/stack_recipe("rack parts-支架", /obj/item/rack_parts, category = CAT_FURNITURE), \
	new/datum/stack_recipe("closet-锁柜", /obj/structure/closet, 2, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	null, \
	new/datum/stack_recipe("atmos canister-气罐", /obj/machinery/portable_atmospherics/canister, 10, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ATMOSPHERIC), \
	new/datum/stack_recipe("pipe", /obj/item/pipe/quaternary/pipe/crafted, 1, time = 4 SECONDS, crafting_flags = NONE, category = CAT_ATMOSPHERIC), \
	null, \
	new/datum/stack_recipe("floor tile-地板", /obj/item/stack/tile/iron/base, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("iron rod-铁棒", /obj/item/stack/rods, 1, 2, 60, category = CAT_MISC), \
	null, \
	new/datum/stack_recipe("wall girders-结构梁(已固定)", /obj/structure/girder, 2, time = 4 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, placement_checks = STACK_CHECK_TRAM_FORBIDDEN, trait_booster = TRAIT_QUICK_BUILD, trait_modifier = 0.75, category = CAT_STRUCTURE), \
	null, \
	null, \
	new/datum/stack_recipe("computer frame-电脑框架", /obj/structure/frame/computer, 5, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("modular console-模块终端", /obj/machinery/modular_computer, 10, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("machine frame-机器框架", /obj/structure/frame/machine, 5, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_EQUIPMENT), \
	null, \
	new /datum/stack_recipe_list("airlock assemblies", list( \
		new /datum/stack_recipe("standard airlock assembly", /obj/structure/door_assembly, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("public airlock assembly", /obj/structure/door_assembly/door_assembly_public, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("command airlock assembly", /obj/structure/door_assembly/door_assembly_com, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("security airlock assembly", /obj/structure/door_assembly/door_assembly_sec, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("engineering airlock assembly", /obj/structure/door_assembly/door_assembly_eng, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("mining airlock assembly", /obj/structure/door_assembly/door_assembly_min, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("atmospherics airlock assembly", /obj/structure/door_assembly/door_assembly_atmo, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("research airlock assembly", /obj/structure/door_assembly/door_assembly_research, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("freezer airlock assembly", /obj/structure/door_assembly/door_assembly_fre, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("science airlock assembly", /obj/structure/door_assembly/door_assembly_science, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("medical airlock assembly", /obj/structure/door_assembly/door_assembly_med, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("hydroponics airlock assembly", /obj/structure/door_assembly/door_assembly_hydro, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("virology airlock assembly", /obj/structure/door_assembly/door_assembly_viro, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("maintenance airlock assembly", /obj/structure/door_assembly/door_assembly_mai, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("external airlock assembly", /obj/structure/door_assembly/door_assembly_ext, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("external maintenance airlock assembly", /obj/structure/door_assembly/door_assembly_extmai, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("airtight hatch assembly", /obj/structure/door_assembly/door_assembly_hatch, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
		new /datum/stack_recipe("maintenance hatch assembly", /obj/structure/door_assembly/door_assembly_mhatch, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
	)), \
	null, \
	new/datum/stack_recipe("firelock frame", /obj/structure/firelock_frame, 3, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
	new/datum/stack_recipe("turret frame", /obj/machinery/porta_turret_construct, 5, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("meatspike frame", /obj/structure/kitchenspike_frame, 5, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("reflector frame", /obj/structure/reflector, 5, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_EQUIPMENT), \
	null, \
	new/datum/stack_recipe("grenade casing-手雷外壳", /obj/item/grenade/chem_grenade, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("light fixture frame-灯具框架", /obj/item/wallframe/light_fixture, 2, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("small light fixture frame-小型灯具框架", /obj/item/wallframe/light_fixture/small, 1, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	null, \
	new/datum/stack_recipe("apc frame-apc框架", /obj/item/wallframe/apc, 2, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("air alarm frame-空气警报框架", /obj/item/wallframe/airalarm, 2, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("fire alarm frame-火警框架", /obj/item/wallframe/firealarm, 2, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("extinguisher cabinet frame-灭火器柜框架", /obj/item/wallframe/extinguisher_cabinet, 2, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("button frame-按钮框架", /obj/item/wallframe/button, 1, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	null, \
	new/datum/stack_recipe("iron door-铁门", /obj/structure/mineral_door/iron, 20, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND | CRAFT_APPLIES_MATS, category = CAT_DOORS), \
	new/datum/stack_recipe("filing cabinet-文件柜", /obj/structure/filingcabinet, 2, time = 10 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("desk bell-桌铃", /obj/structure/desk_bell, 2, time = 3 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("floodlight frame-泛光灯框架", /obj/structure/floodlight_frame, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("voting box-投票箱", /obj/structure/votebox, 15, time = 5 SECONDS, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("pestle-杵", /obj/item/pestle, 1, time = 5 SECONDS, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("hygienebot assembly", /obj/item/bot_assembly/hygienebot, 2, time = 5 SECONDS, crafting_flags = NONE, category = CAT_ROBOT), \
	new/datum/stack_recipe("shower frame-淋浴器框架", /obj/structure/showerframe, 2, time = 2 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("urinal-小便池", /obj/item/wallframe/urinal, 2, time = 1 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE)
))

/obj/item/stack/sheet/iron
	name = "铁"
	desc = "铁."
	singular_name = "铁"
	icon_state = "sheet-metal"
	inhand_icon_state = "sheet-metal"
	mats_per_unit = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)
	throwforce = 10
	obj_flags = CONDUCTS_ELECTRICITY
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/iron
	grind_results = list(/datum/reagent/iron = 20)
	gulag_valid = TRUE
	tableVariant = /obj/structure/table
	material_type = /datum/material/iron
	matter_amount = 4
	cost = SHEET_MATERIAL_AMOUNT
	source = /datum/robot_energy_storage/material/iron
	stairs_type = /obj/structure/stairs
	sniffable = TRUE

/obj/item/stack/sheet/iron/Initialize(mapload)
	. = ..()
	var/static/list/tool_behaviors = list(
		TOOL_WELDER = list(
			SCREENTIP_CONTEXT_LMB = "制作铁棒",
			SCREENTIP_CONTEXT_RMB = "制作地板",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

/obj/item/stack/sheet/iron/examine(mob/user)
	. = ..()
	. += span_notice("You can build a wall girder (unanchored) by right clicking on an empty floor.")

/obj/item/stack/sheet/iron/narsie_act()
	new /obj/item/stack/sheet/runed_metal(loc, amount)
	qdel(src)

/obj/item/stack/sheet/iron/fifty
	amount = 50

/obj/item/stack/sheet/iron/twenty
	amount = 20

/obj/item/stack/sheet/iron/ten
	amount = 10

/obj/item/stack/sheet/iron/five
	amount = 5

/obj/item/stack/sheet/iron/get_main_recipes()
	. = ..()
	. += GLOB.metal_recipes

/obj/item/stack/sheet/iron/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins whacking [user.p_them()]self over the head with \the [src]! 看起来是在尝试自杀!"))
	return BRUTELOSS

/obj/item/stack/sheet/iron/welder_act(mob/living/user, obj/item/tool)
	if(tool.use_tool(src, user, delay = 0, volume = 40))
		var/obj/item/stack/rods/two/new_item = new(user.loc)
		user.visible_message(
			span_notice("[user.name] shaped [src] into floor rods with [tool]."),
			blind_message = span_hear("你听到焊接声."),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
		use(1)
		user.put_in_inactive_hand(new_item)
		return ITEM_INTERACT_SUCCESS

/obj/item/stack/sheet/iron/welder_act_secondary(mob/living/user, obj/item/tool)
	if(tool.use_tool(src, user, delay = 0, volume = 40))
		var/obj/item/stack/tile/iron/four/new_item = new(user.loc)
		user.visible_message(
			span_notice("[user.name] shaped [src] into floor tiles with [tool]."),
			blind_message = span_hear("你听到焊接声."),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
		use(1)
		user.put_in_inactive_hand(new_item)
		return ITEM_INTERACT_SUCCESS

/obj/item/stack/sheet/iron/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isopenturf(interacting_with))
		return NONE
	var/turf/open/build_on = interacting_with
	if(!user.Adjacent(build_on))
		return ITEM_INTERACT_BLOCKING
	if(isgroundlessturf(build_on))
		user.balloon_alert(user, "can't place it here!")
		return ITEM_INTERACT_BLOCKING
	if(build_on.is_blocked_turf())
		user.balloon_alert(user, "something is blocking the tile!")
		return ITEM_INTERACT_BLOCKING
	if(get_amount() < 2)
		user.balloon_alert(user, "not enough material!")
		return ITEM_INTERACT_BLOCKING
	var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/construction, SKILL_SPEED_MODIFIER) //SKYRAT EDIT: Construction Skill
	if(!do_after(user, 4 SECONDS * skill_modifier, build_on))
		return ITEM_INTERACT_BLOCKING
	if(build_on.is_blocked_turf())
		user.balloon_alert(user, "something is blocking the tile!")
		return ITEM_INTERACT_BLOCKING
	if(!use(2))
		user.balloon_alert(user, "not enough material!")
		return ITEM_INTERACT_BLOCKING
	new/obj/structure/girder/displaced(build_on)
	user.mind.adjust_experience(/datum/skill/construction, 5) //SKYRAT EDIT: Construction Skill
	return ITEM_INTERACT_SUCCESS

/*
 * Plasteel
 */
GLOBAL_LIST_INIT(plasteel_recipes, list ( \
	new/datum/stack_recipe("AI core", /obj/structure/ai_core, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF, category = CAT_ROBOT),
	new/datum/stack_recipe("bomb assembly-炸弹组装", /obj/machinery/syndicatebomb/empty, 10, time = 5 SECONDS, crafting_flags = NONE, category = CAT_CHEMISTRY),
	new/datum/stack_recipe("Large Gas Tank", /obj/structure/tank_frame, 4, time=1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF, category = CAT_ATMOSPHERIC),
	new/datum/stack_recipe("shutter assembly", /obj/machinery/door/poddoor/shutters/preopen/deconstructed, 5, time = 5 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF, category = CAT_DOORS),
	null,
	new /datum/stack_recipe_list("airlock assemblies", list( \
		new/datum/stack_recipe("high security airlock assembly", /obj/structure/door_assembly/door_assembly_highsecurity, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS),
		new/datum/stack_recipe("vault door assembly", /obj/structure/door_assembly/door_assembly_vault, 6, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS),
	)), \
))

/obj/item/stack/sheet/plasteel
	name = "等离子铁"
	singular_name = "等离子铁"
	desc = "This sheet is an alloy of iron and plasma."
	icon_state = "sheet-plasteel"
	inhand_icon_state = "sheet-plasteel"
	mats_per_unit = list(/datum/material/alloy/plasteel=SHEET_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/plasteel
	throwforce = 10
	obj_flags = CONDUCTS_ELECTRICITY
	armor_type = /datum/armor/sheet_plasteel
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/plasteel
	grind_results = list(/datum/reagent/iron = 20, /datum/reagent/toxin/plasma = 20)
	gulag_valid = TRUE
	tableVariant = /obj/structure/table/reinforced
	material_flags = NONE
	matter_amount = 12

/datum/armor/sheet_plasteel
	fire = 100
	acid = 80

/obj/item/stack/sheet/plasteel/get_main_recipes()
	. = ..()
	. += GLOB.plasteel_recipes

/obj/item/stack/sheet/plasteel/twenty
	amount = 20

/obj/item/stack/sheet/plasteel/fifty
	amount = 50

/*
 * Wood
 */
GLOBAL_LIST_INIT(wood_recipes, list ( \
	new/datum/stack_recipe("wooden sandals-木制凉鞋", /obj/item/clothing/shoes/sandal, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20, crafting_flags = NONE, category = CAT_TILES), \
	new/datum/stack_recipe("wood table frame", /obj/structure/table_frame/wood, 2, time = 1 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("rolling pin-擀面杖", /obj/item/kitchen/rollingpin, 2, time = 3 SECONDS, crafting_flags = NONE, category = CAT_TOOLS), \
	new/datum/stack_recipe("wooden chair", /obj/structure/chair/wood/, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("winged wooden chair", /obj/structure/chair/wood/wings, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("wooden barricade-木制路障", /obj/structure/barricade/wooden, 5, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("wooden door", /obj/structure/mineral_door/wood, 10, time = 2 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
	new/datum/stack_recipe("wooden stairs frame", /obj/structure/stairs_frame/wood, 10, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("wooden fence-木栅栏", /obj/structure/railing/wooden_fence, 2, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("raptor trough", /obj/structure/ore_container/food_trough/raptor_trough, 5, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("cat house", /obj/structure/cat_house, 5, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("coffin-棺材", /obj/structure/closet/crate/coffin, 5, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("book case-书柜", /obj/structure/bookcase, 4, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("drying rack-干燥器", /obj/machinery/smartfridge/drying_rack, 10, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_TOOLS), \
	new/datum/stack_recipe("wooden barrel-木桶", /obj/structure/fermenting_barrel, 8, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("dog bed", /obj/structure/bed/dogbed, 10, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("dresser-梳妆台", /obj/structure/dresser, 10, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("picture frame-相框", /obj/item/wallframe/picture, 1, time = 1 SECONDS, crafting_flags = NONE, category = CAT_ENTERTAINMENT),\
	new/datum/stack_recipe("painting frame-画框", /obj/item/wallframe/painting, 1, time = 1 SECONDS, crafting_flags = NONE, category = CAT_ENTERTAINMENT),\
	new/datum/stack_recipe("display case chassis-展示柜", /obj/structure/displaycase_chassis, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("wooden buckler-木盾", /obj/item/shield/buckler, 20, time = 4 SECONDS, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("apiary-蜂箱", /obj/structure/beebox, 40, time = 5 SECONDS, crafting_flags = NONE, category = CAT_TOOLS),\
	new/datum/stack_recipe("mannequin-人体模型", /obj/structure/mannequin/wood, 25, time = 5 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("tiki mask", /obj/item/clothing/mask/gas/tiki_mask, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("smoking pipe-烟斗", /obj/item/clothing/mask/cigarette/pipe, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("honey frame-蜂蜜架", /obj/item/honey_frame, 5, time = 1 SECONDS, crafting_flags = NONE, category = CAT_TOOLS),\
	new/datum/stack_recipe("wooden bucket-木水桶", /obj/item/reagent_containers/cup/bucket/wooden, 3, time = 1 SECONDS, crafting_flags = NONE, category = CAT_CONTAINERS),\
	new/datum/stack_recipe("rake-耙", /obj/item/cultivator/rake, 5, time = 1 SECONDS, crafting_flags = NONE, category = CAT_TOOLS),\
	new/datum/stack_recipe("ore box-矿石箱", /obj/structure/ore_box, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_CONTAINERS),\
	new/datum/stack_recipe("wooden crate-木制货箱", /obj/structure/closet/crate/wooden, 6, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),\
	new/datum/stack_recipe("baseball bat-棒球棒", /obj/item/melee/baseball_bat, 5, time = 1.5 SECONDS, crafting_flags = NONE, category = CAT_WEAPON_MELEE),\
	new/datum/stack_recipe("wooden crutch", /obj/item/cane/crutch/wood, 5, time = 1.5 SECONDS, crafting_flags = NONE, category = CAT_WEAPON_MELEE),\
	new/datum/stack_recipe("loom-织布机", /obj/structure/loom, 10, time = 1.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_TOOLS), \
	new/datum/stack_recipe("mortar-研钵", /obj/item/reagent_containers/cup/mortar, 3, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("firebrand-火把", /obj/item/match/firebrand, 2, time = 10 SECONDS, crafting_flags = NONE, category = CAT_TOOLS), \
	new/datum/stack_recipe("bonfire-篝火", /obj/structure/bonfire/player_made, 10, time = 6 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_TOOLS), /* SKYRAT EDIT - Pollution - ORIGINAL: /obj/structure/bonfire */ \
	new/datum/stack_recipe("easel-画架", /obj/structure/easel, 5, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("noticeboard-布告栏", /obj/item/wallframe/noticeboard, 1, time = 1 SECONDS, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("test tube rack-试管架", /obj/item/storage/test_tube_rack, 1, time = 1 SECONDS, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	null, \
	new/datum/stack_recipe_list("教堂长椅", list(
		new /datum/stack_recipe("教堂长椅(middle)", /obj/structure/chair/pew, 3, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("教堂长椅(left)", /obj/structure/chair/pew/left, 3, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("教堂长椅(right)", /obj/structure/chair/pew/right, 3, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE)
		)),
	new/datum/stack_recipe_list("peg limbs", list(
		new /datum/stack_recipe("peg arm (left)", /obj/item/bodypart/arm/left/ghetto, 2, crafting_flags = NONE, category = CAT_MISC),
		new /datum/stack_recipe("peg arm (right)", /obj/item/bodypart/arm/right/ghetto, 2, crafting_flags = NONE, category = CAT_MISC),
		new /datum/stack_recipe("peg leg (left)", /obj/item/bodypart/leg/left/ghetto, 2, crafting_flags = NONE, category = CAT_MISC),
		new /datum/stack_recipe("peg leg (right)", /obj/item/bodypart/leg/right/ghetto, 2, crafting_flags = NONE, category = CAT_MISC)
	)),
	null, \
	))

/obj/item/stack/sheet/mineral/wood
	name = "木材"
	desc = "One can only guess that this is a bunch of wood."
	singular_name = "木材"
	icon_state = "sheet-wood"
	inhand_icon_state = "sheet-wood"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/wood=SHEET_MATERIAL_AMOUNT)
	sheettype = "wood"
	armor_type = /datum/armor/mineral_wood
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/sheet/mineral/wood
	material_type = /datum/material/wood
	grind_results = list(/datum/reagent/cellulose = 20) //no lignocellulose or lignin reagents yet,
	walltype = /turf/closed/wall/mineral/wood
	stairs_type = /obj/structure/stairs/wood

/datum/armor/mineral_wood
	fire = 50

/obj/item/stack/sheet/mineral/wood/get_main_recipes()
	. = ..()
	. += GLOB.wood_recipes

/obj/item/stack/sheet/mineral/wood/fifty
	amount = 50

/obj/item/stack/sheet/mineral/wood/interact_with_atom(mob/living/carbon/human/target, mob/user)
	if(!istype(target))
		return NONE

	var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(user.zone_selected))
	if(affecting && IS_PEG_LIMB(affecting))
		if(user == target)
			user.visible_message(span_notice("[user] starts to fix their [affecting.name]."), span_notice("You start fixing [target == user ? "your" : "[target]'s"] [affecting.name]."))
			if(!do_after(user, 5 SECONDS, target))
				return ITEM_INTERACT_FAILURE
		if(target.item_heal(user, brute_heal = 15, burn_heal = 15, heal_message_brute = "splintering", heal_message_burn = "charring", required_bodytype = BODYTYPE_PEG))
			use(1)
		return ITEM_INTERACT_SUCCESS
	else
		return NONE
/*
 * Bamboo
 */

GLOBAL_LIST_INIT(bamboo_recipes, list ( \
	new/datum/stack_recipe("punji sticks trap-木刺陷阱", /obj/structure/punji_sticks, 5, time = 3 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("bamboo spear-竹矛", /obj/item/spear/bamboospear, 25, time = 9 SECONDS, crafting_flags = NONE, category = CAT_WEAPON_MELEE), \
	new/datum/stack_recipe("blow gun-吹箭", /obj/item/gun/syringe/blowgun, 10, time = 7 SECONDS, crafting_flags = NONE, category = CAT_WEAPON_RANGED), \
	new/datum/stack_recipe("crude syringe-竹制注射器", /obj/item/reagent_containers/syringe/crude, 5, time = 1 SECONDS, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("rice hat-斗笠", /obj/item/clothing/head/costume/rice_hat, 10, time = 7 SECONDS, crafting_flags = NONE, category = CAT_CLOTHING), \
	null, \
	new/datum/stack_recipe("bamboo stool-竹凳", /obj/structure/chair/stool/bamboo, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("bamboo mat piece", /obj/item/stack/tile/bamboo, 1, 4, 20, crafting_flags = NONE, category = CAT_TILES), \
	null, \
	new/datum/stack_recipe_list("bamboo benches", list(
		new /datum/stack_recipe("bamboo bench (middle)", /obj/structure/chair/sofa/bamboo, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("bamboo bench (left)", /obj/structure/chair/sofa/bamboo/left, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE),
		new /datum/stack_recipe("bamboo bench (right)", /obj/structure/chair/sofa/bamboo/right, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE)
		)),	\
	))

/obj/item/stack/sheet/mineral/bamboo
	name = "竹子"
	desc = "Finely cut bamboo sticks."
	singular_name = "竹子"
	icon_state = "sheet-bamboo"
	inhand_icon_state = "sheet-bamboo"
	icon = 'icons/obj/stack_objects.dmi'
	sheettype = "bamboo"
	mats_per_unit = list(/datum/material/bamboo = SHEET_MATERIAL_AMOUNT)
	throwforce = 15
	armor_type = /datum/armor/mineral_bamboo
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/sheet/mineral/bamboo
	grind_results = list(/datum/reagent/cellulose = 10)
	material_type = /datum/material/bamboo
	walltype = /turf/closed/wall/mineral/bamboo

/datum/armor/mineral_bamboo
	fire = 50

/obj/item/stack/sheet/mineral/bamboo/get_main_recipes()
	. = ..()
	. += GLOB.bamboo_recipes

/obj/item/stack/sheet/mineral/bamboo/fifty
	amount = 50

/*
 * Cloth
 */
GLOBAL_LIST_INIT(cloth_recipes, list ( \
	new/datum/stack_recipe("white jumpskirt", /obj/item/clothing/under/color/jumpskirt/white, 3, crafting_flags = NONE, category = CAT_CLOTHING), /*Ladies first*/ \
	new/datum/stack_recipe("white jumpsuit", /obj/item/clothing/under/color/white, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("white shoes", /obj/item/clothing/shoes/sneakers/white, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("white scarf", /obj/item/clothing/neck/scarf, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("white bandana", /obj/item/clothing/mask/bandana/white, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	null, \
	new/datum/stack_recipe("backpack", /obj/item/storage/backpack, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("satchel", /obj/item/storage/backpack/satchel, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("messenger bag", /obj/item/storage/backpack/messenger, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("duffel bag", /obj/item/storage/backpack/duffelbag, 6, crafting_flags = NONE, category = CAT_CONTAINERS), \
	null, \
	new/datum/stack_recipe("plant bag", /obj/item/storage/bag/plants, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("book bag", /obj/item/storage/bag/books, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("mining satchel", /obj/item/storage/bag/ore, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("chemistry bag", /obj/item/storage/bag/chemistry, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("bio bag", /obj/item/storage/bag/bio, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("science bag", /obj/item/storage/bag/xeno, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("construction bag", /obj/item/storage/bag/construction, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	null, \
	new/datum/stack_recipe("improvised gauze", /obj/item/stack/medical/gauze/improvised, 1, 2, 6, crafting_flags = NONE, category = CAT_TOOLS), \
	new/datum/stack_recipe("rag", /obj/item/reagent_containers/cup/rag, 1, crafting_flags = NONE, category = CAT_CHEMISTRY), \
	new/datum/stack_recipe("bedsheet", /obj/item/bedsheet, 3, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("double bedsheet", /obj/item/bedsheet/double, 6, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("empty sandbag", /obj/item/emptysandbag, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
	null, \
	new/datum/stack_recipe("fingerless gloves", /obj/item/clothing/gloves/fingerless, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("white gloves", /obj/item/clothing/gloves/color/white, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("white softcap", /obj/item/clothing/head/soft/mime, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("white beanie", /obj/item/clothing/head/beanie, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	null, \
	new/datum/stack_recipe("blindfold", /obj/item/clothing/glasses/blindfold, 2, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	null, \
	new/datum/stack_recipe("19x19 canvas", /obj/item/canvas/nineteen_nineteen, 3, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("23x19 canvas", /obj/item/canvas/twentythree_nineteen, 4, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("23x23 canvas", /obj/item/canvas/twentythree_twentythree, 5, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("pillow", /obj/item/pillow, 3, category = CAT_FURNITURE), \
	))

/obj/item/stack/sheet/cloth
	name = "布料"
	desc = "Is it cotton? Linen? Denim? Burlap? Canvas? You can't tell."
	singular_name = "布料"
	icon_state = "sheet-cloth"
	inhand_icon_state = null
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cloth
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound = 'sound/items/handling/cloth_pickup.ogg'
	grind_results = list(/datum/reagent/cellulose = 20)

/obj/item/stack/sheet/cloth/get_main_recipes()
	. = ..()
	. += GLOB.cloth_recipes

/obj/item/stack/sheet/cloth/ten
	amount = 10

/obj/item/stack/sheet/cloth/five
	amount = 5

GLOBAL_LIST_INIT(durathread_recipes, list ( \
	new/datum/stack_recipe("durathread jumpsuit", /obj/item/clothing/under/misc/durathread, 4, time = 4 SECONDS, crafting_flags = NONE, category = CAT_CLOTHING),
	new/datum/stack_recipe("durathread beret", /obj/item/clothing/head/beret/durathread, 2, time = 4 SECONDS, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("durathread beanie", /obj/item/clothing/head/beanie/durathread, 2, time = 4 SECONDS, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("durathread bandana", /obj/item/clothing/mask/bandana/durathread, 1, time = 2.5 SECONDS, crafting_flags = NONE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/durathread
	name = "杜拉棉"
	desc = "A fabric sown from incredibly durable threads, known for its usefulness in armor production."
	singular_name = "杜拉棉"
	icon_state = "sheet-durathread"
	inhand_icon_state = null
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/durathread
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound = 'sound/items/handling/cloth_pickup.ogg'

/obj/item/stack/sheet/durathread/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/durathread_helmet, /datum/crafting_recipe/durathread_vest)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/stack/sheet/durathread/get_main_recipes()
	. = ..()
	. += GLOB.durathread_recipes

/obj/item/stack/sheet/durathread/on_item_crafted(mob/builder, atom/created)
	created.set_armor_rating(CONSUME, max(50, created.get_armor_rating(CONSUME)))

/obj/item/stack/sheet/cotton
	name = "raw cotton bundle"
	desc = "A bundle of raw cotton ready to be spun on the loom."
	singular_name = "raw cotton ball"
	icon_state = "sheet-cotton"
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cotton
	grind_results = list(/datum/reagent/cellulose = 20)
	var/loom_result = /obj/item/stack/sheet/cloth
	var/loom_time = 1 SECONDS

/obj/item/stack/sheet/cotton/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/loomable, resulting_atom = loom_result, loom_time = loom_time)

/obj/item/stack/sheet/cotton/durathread
	name = "raw durathread bundle"
	desc = "A bundle of raw durathread ready to be spun on the loom."
	singular_name = "raw durathread ball"
	icon_state = "sheet-durathreadraw"
	merge_type = /obj/item/stack/sheet/cotton/durathread
	grind_results = list()
	loom_result = /obj/item/stack/sheet/durathread

/obj/item/stack/sheet/cotton/wool
	name = "raw wool bundle"
	desc = "A bundle of raw wool ready to be spun on the loom."
	singular_name = "raw wool ball"
	icon_state = "sheet-wool"
	merge_type = /obj/item/stack/sheet/cotton/wool
	grind_results = list()
	loom_result = /obj/item/stack/sheet/cloth

/*
 * Cardboard
 */
GLOBAL_LIST_INIT(cardboard_recipes, list ( \
	new/datum/stack_recipe("box", /obj/item/storage/box, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("cardborg suit", /obj/item/clothing/suit/costume/cardborg, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("cardborg helmet", /obj/item/clothing/head/costume/cardborg, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("large box", /obj/structure/closet/cardboard, 4, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("cardboard cutout", /obj/item/cardboard_cutout, 5, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	null, \

	new/datum/stack_recipe("pizza box", /obj/item/pizzabox, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("folder", /obj/item/folder, crafting_flags = NONE, category = CAT_CONTAINERS), \
	null, \
	//TO-DO: Find a proper way to just change the illustration on the box. Code isn't the issue, input is.
	new/datum/stack_recipe_list("fancy boxes", list(
		new /datum/stack_recipe("donut box", /obj/item/storage/fancy/donut_box, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("egg box", /obj/item/storage/fancy/egg_box, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets box", /obj/item/storage/box/donkpockets, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets spicy box", /obj/item/storage/box/donkpockets/donkpocketspicy, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets teriyaki box", /obj/item/storage/box/donkpockets/donkpocketteriyaki, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets pizza box", /obj/item/storage/box/donkpockets/donkpocketpizza, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets berry box", /obj/item/storage/box/donkpockets/donkpocketberry, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("donk-pockets honk box", /obj/item/storage/box/donkpockets/donkpockethonk, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("monkey cube box", /obj/item/storage/box/monkeycubes, crafting_flags = NONE, category = CAT_CONTAINERS),
		new /datum/stack_recipe("nugget box", /obj/item/storage/fancy/nugget_box, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("drinking glasses box", /obj/item/storage/box/drinkingglasses, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("paper cups box", /obj/item/storage/box/cups, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("cigar case", /obj/item/storage/fancy/cigarettes/cigars, crafting_flags = NONE, category = CAT_CONTAINERS), \
		null, \

		new /datum/stack_recipe("lethal ammo box", /obj/item/storage/box/lethalshot, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("rubber shot ammo box", /obj/item/storage/box/rubbershot, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("bean bag ammo box", /obj/item/storage/box/beanbag, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("flashbang box", /obj/item/storage/box/flashbangs, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("flashes box", /obj/item/storage/box/flashes, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("handcuffs box", /obj/item/storage/box/handcuffs, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("ID card box", /obj/item/storage/box/ids, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("PDA box", /obj/item/storage/box/pdas, crafting_flags = NONE, category = CAT_CONTAINERS), \
		null, \

		new /datum/stack_recipe("pillbottle box", /obj/item/storage/box/pillbottles, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("medical gels box", /obj/item/storage/box/medigels, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("beaker box", /obj/item/storage/box/beakers, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("syringe box", /obj/item/storage/box/syringes, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("latex gloves box", /obj/item/storage/box/gloves, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("sterile masks box", /obj/item/storage/box/masks, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("body bag box", /obj/item/storage/box/bodybags, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("prescription glasses box", /obj/item/storage/box/rxglasses, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("medipen box", /obj/item/storage/box/medipens, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("DNA injectors box", /obj/item/storage/box/injectors, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("oxygen tank box", /obj/item/storage/box/emergencytank, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("extended oxygen tank box", /obj/item/storage/box/engitank, crafting_flags = NONE, category = CAT_CONTAINERS), \
		null, \

		new /datum/stack_recipe("survival box", /obj/item/storage/box/survival/crafted, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("extended tank survival box", /obj/item/storage/box/survival/engineer/crafted, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("disk box", /obj/item/storage/box/disks, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("light tubes box", /obj/item/storage/box/lights/tubes, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("light bulbs box", /obj/item/storage/box/lights/bulbs, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("mixed lights box", /obj/item/storage/box/lights/mixed, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("mouse traps box", /obj/item/storage/box/mousetraps, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("candle box", /obj/item/storage/fancy/candle_box, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new /datum/stack_recipe("bandage box", /obj/item/storage/box/bandages, crafting_flags = NONE, category = CAT_CONTAINERS)
		)),

	null, \
))

/obj/item/stack/sheet/cardboard //BubbleWrap //it's cardboard you fuck
	name = "纸板"
	desc = "Large sheets of card, like boxes folded flat."
	singular_name = "纸板"
	icon_state = "sheet-card"
	inhand_icon_state = "sheet-card"
	mats_per_unit = list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT)
	resistance_flags = FLAMMABLE
	force = 0
	throwforce = 0
	merge_type = /obj/item/stack/sheet/cardboard
	grind_results = list(/datum/reagent/cellulose = 10)
	material_type = /datum/material/cardboard

/obj/item/stack/sheet/cardboard/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/cardboard_id)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/stack/sheet/cardboard/get_main_recipes()
	. = ..()
	. += GLOB.cardboard_recipes

/obj/item/stack/sheet/cardboard/fifty
	amount = 50

/obj/item/stack/sheet/cardboard/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stamp/clown) && !istype(loc, /obj/item/storage))
		var/atom/droploc = drop_location()
		if(use(1))
			playsound(I, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
			to_chat(user, span_notice("You stamp the cardboard! It's a clown box! Honk!"))
			if (amount >= 0)
				new/obj/item/storage/box/clown(droploc) //bugfix
	if(istype(I, /obj/item/stamp/chameleon) && !istype(loc, /obj/item/storage))
		var/atom/droploc = drop_location()
		if(use(1))
			to_chat(user, span_notice("You stamp the cardboard in a sinister way."))
			if (amount >= 0)
				new/obj/item/storage/box/syndie_kit(droploc)
	else
		. = ..()

/*
 * Bronze
 */

GLOBAL_LIST_INIT(bronze_recipes, list ( \
	new/datum/stack_recipe("wall gear-构墙齿轮", /obj/structure/girder/bronze, 2, time = 2 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	null,
	new/datum/stack_recipe("directional bronze window", /obj/structure/window/bronze/unanchored, time = 0, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_CHECK_DIRECTION, category = CAT_WINDOWS), \
	new/datum/stack_recipe("fulltile bronze window", /obj/structure/window/bronze/fulltile/unanchored, 2, time = 0, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_IS_FULLTILE, category = CAT_WINDOWS), \
	new/datum/stack_recipe("pinion airlock assembly", /obj/structure/door_assembly/door_assembly_bronze, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
	new/datum/stack_recipe("bronze pinion airlock assembly", /obj/structure/door_assembly/door_assembly_bronze/seethru, 4, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_DOORS), \
	new/datum/stack_recipe("bronze floor tile", /obj/item/stack/tile/bronze, 1, 4, 20, crafting_flags = NONE, category = CAT_TILES), \
	new/datum/stack_recipe("bronze hat", /obj/item/clothing/head/costume/bronze, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("bronze suit", /obj/item/clothing/suit/costume/bronze, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("bronze boots", /obj/item/clothing/shoes/bronze, crafting_flags = NONE, category = CAT_CLOTHING), \
	null,
	new/datum/stack_recipe("bronze chair", /obj/structure/chair/bronze, 1, time = 0, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
))

/obj/item/stack/sheet/bronze
	name = "青铜"
	desc = "On closer inspection, what appears to be wholly-unsuitable-for-building brass is actually more structurally stable bronze."
	singular_name = "青铜"
	icon_state = "sheet-brass"
	inhand_icon_state = "sheet-brass"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/bronze = SHEET_MATERIAL_AMOUNT)
	lefthand_file = 'icons/mob/inhands/items/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/sheets_righthand.dmi'
	resistance_flags = FIRE_PROOF | ACID_PROOF
	sheettype = "bronze"
	force = 5
	throwforce = 10
	max_amount = 50
	throw_speed = 1
	throw_range = 3
	novariants = FALSE
	grind_results = list(/datum/reagent/iron = 20, /datum/reagent/copper = 12) //we have no "tin" reagent so this is the closest thing
	merge_type = /obj/item/stack/sheet/bronze
	tableVariant = /obj/structure/table/bronze
	material_type = /datum/material/bronze
	walltype = /turf/closed/wall/mineral/bronze
	has_unique_girder = TRUE

/obj/item/stack/sheet/bronze/get_main_recipes()
	. = ..()
	. += GLOB.bronze_recipes

/obj/item/stack/sheet/paperframes/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = 0
	pixel_y = 0

/obj/item/stack/sheet/bronze/thirty
	amount = 30

/*
 * Lesser and Greater gems - unused
 */
/obj/item/stack/sheet/lessergem
	name = "lesser gems"
	desc = "Rare kind of gems which are only gained by blood sacrifice to minor deities. They are needed in crafting powerful objects."
	singular_name = "lesser gem"
	icon_state = "sheet-lessergem"
	inhand_icon_state = null
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/lessergem

/obj/item/stack/sheet/greatergem
	name = "greater gems"
	desc = "Rare kind of gems which are only gained by blood sacrifice to minor deities. They are needed in crafting powerful objects."
	singular_name = "greater gem"
	icon_state = "sheet-greatergem"
	inhand_icon_state = null
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/greatergem

/*
 * Bones
 */
/obj/item/stack/sheet/bone
	name = "骨头"
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "bone"
	inhand_icon_state = null
	mats_per_unit = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)
	singular_name = "骨头"
	desc = "Someone's been drinking their milk."
	force = 7
	throwforce = 5
	max_amount = 12
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	grind_results = list(/datum/reagent/carbon = 10)
	merge_type = /obj/item/stack/sheet/bone
	material_type = /datum/material/bone

/obj/item/stack/sheet/bone/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()

	// As bone and sinew have just a little too many recipes for this, we'll just split them up.
	// Sinew slapcrafting will mostly-sinew recipes, and bones will have mostly-bones recipes.
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/bonearmor,
		/datum/crafting_recipe/boneaxe,
		/datum/crafting_recipe/bonedagger,
		/datum/crafting_recipe/bonespear,
		/datum/crafting_recipe/bracers,
		/datum/crafting_recipe/skullhelm,
		/datum/crafting_recipe/ash_recipe/bone_greaves, /* SKYRAT EDIT ADDITION */
	)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)
GLOBAL_LIST_INIT(plastic_recipes, list(
	new /datum/stack_recipe("plastic floor tile-塑料地板", /obj/item/stack/tile/plastic, 1, 4, 20, time = 2 SECONDS, crafting_flags = NONE, category = CAT_TILES), \
	new /datum/stack_recipe("light tram tile-电车亮色地板", /obj/item/stack/thermoplastic/light, 1, 4, 20, time = 2 SECONDS, crafting_flags = NONE, category = CAT_TILES), \
	new /datum/stack_recipe("dark tram tile-电车深色地板", /obj/item/stack/thermoplastic, 1, 4, 20, time = 2 SECONDS, crafting_flags = NONE, category = CAT_TILES), \
	new /datum/stack_recipe("folding plastic chair-折叠塑料椅", /obj/structure/chair/plastic, 2, crafting_flags = NONE, category = CAT_FURNITURE), \
	new /datum/stack_recipe("plastic flaps-塑料挡板", /obj/structure/plasticflaps, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, time = 4 SECONDS, category = CAT_FURNITURE), \
	new /datum/stack_recipe("water bottle-塑料水杯", /obj/item/reagent_containers/cup/glass/waterbottle/empty, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new /datum/stack_recipe("large water bottle-大塑料水杯", /obj/item/reagent_containers/cup/glass/waterbottle/large/empty, 3, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new /datum/stack_recipe("colo cups-可乐杯", /obj/item/reagent_containers/cup/glass/colocup, 1, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new /datum/stack_recipe("mannequin-人体模型", /obj/structure/mannequin/plastic, 25, time = 5 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF, category = CAT_ENTERTAINMENT), \
	new /datum/stack_recipe("wet floor sign-地面湿滑标志", /obj/item/clothing/suit/caution, 2, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new /datum/stack_recipe("warning cone-警示锥", /obj/item/clothing/head/cone, 2, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new /datum/stack_recipe("blank wall sign-墙牌", /obj/item/sign, 1, crafting_flags = NONE, category = CAT_FURNITURE), \
	new /datum/stack_recipe("rebellion mask-叛乱面具", /obj/item/clothing/mask/rebellion, 1, crafting_flags = NONE, category = CAT_CLOTHING)))

/obj/item/stack/sheet/plastic
	name = "塑料"
	desc = "Compress dinosaur over millions of years, then refine, split and mold, and voila! You have plastic."
	singular_name = "塑料"
	icon_state = "sheet-plastic"
	inhand_icon_state = "sheet-plastic"
	mats_per_unit = list(/datum/material/plastic=SHEET_MATERIAL_AMOUNT)
	throwforce = 7
	material_type = /datum/material/plastic
	merge_type = /obj/item/stack/sheet/plastic

/obj/item/stack/sheet/plastic/fifty
	amount = 50

/obj/item/stack/sheet/plastic/five
	amount = 5

/obj/item/stack/sheet/plastic/get_main_recipes()
	. = ..()
	. += GLOB.plastic_recipes

GLOBAL_LIST_INIT(paperframe_recipes, list(
new /datum/stack_recipe("paper frame separator", /obj/structure/window/paperframe, 2, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND | CRAFT_IS_FULLTILE, time = 1 SECONDS), \
new /datum/stack_recipe("paper frame door", /obj/structure/mineral_door/paperframe, 3, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, time = 1 SECONDS )))

/obj/item/stack/sheet/paperframes
	name = "paper frames"
	desc = "A thin wooden frame with paper attached."
	singular_name = "paper frame"
	icon_state = "sheet-paper"
	inhand_icon_state = "sheet-paper"
	mats_per_unit = list(/datum/material/paper = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/paperframes
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 20)
	material_type = /datum/material/paper

/obj/item/stack/sheet/paperframes/get_main_recipes()
	. = ..()
	. += GLOB.paperframe_recipes
/obj/item/stack/sheet/paperframes/five
	amount = 5
/obj/item/stack/sheet/paperframes/twenty
	amount = 20
/obj/item/stack/sheet/paperframes/fifty
	amount = 50

/obj/item/stack/sheet/meat
	name = "meat sheets"
	desc = "Something's bloody meat compressed into a nice solid sheet."
	singular_name = "meat sheet"
	icon_state = "sheet-meat"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR
	mats_per_unit = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/meat
	material_type = /datum/material/meat
	material_modifier = 1 //None of that wussy stuff

/obj/item/stack/sheet/meat/fifty
	amount = 50
/obj/item/stack/sheet/meat/twenty
	amount = 20
/obj/item/stack/sheet/meat/five
	amount = 5

/obj/item/stack/sheet/pizza
	name = "pepperoni sheetzzas"
	desc = "It's a delicious pepperoni sheetzza!"
	singular_name = "pepperoni sheetzza"
	icon_state = "sheet-pizza"
	mats_per_unit = list(/datum/material/pizza = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/pizza
	material_type = /datum/material/pizza
	material_modifier = 1

/obj/item/stack/sheet/pizza/fifty
	amount = 50
/obj/item/stack/sheet/pizza/twenty
	amount = 20
/obj/item/stack/sheet/pizza/five
	amount = 5

/obj/item/stack/sheet/sandblock
	name = "blocks of sand"
	desc = "You're too old to be playing with sandcastles. Now you build... sandstations."
	singular_name = "sand block"
	icon_state = "sheet-sandstone"
	mats_per_unit = list(/datum/material/sand = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/sandblock
	material_type = /datum/material/sand
	material_modifier = 1

/obj/item/stack/sheet/sandblock/fifty
	amount = 50
/obj/item/stack/sheet/sandblock/twenty
	amount = 20
/obj/item/stack/sheet/sandblock/five
	amount = 5


/obj/item/stack/sheet/hauntium
	name = "haunted sheets"
	desc = "These sheets seem cursed."
	singular_name = "haunted sheet"
	icon_state = "sheet-meat"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR
	mats_per_unit = list(/datum/material/hauntium = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/hauntium
	material_type = /datum/material/hauntium
	material_modifier = 1 //None of that wussy stuff
	grind_results = list(/datum/reagent/hauntium = 20)

/obj/item/stack/sheet/hauntium/fifty
	amount = 50
/obj/item/stack/sheet/hauntium/twenty
	amount = 20
/obj/item/stack/sheet/hauntium/five
	amount = 5
