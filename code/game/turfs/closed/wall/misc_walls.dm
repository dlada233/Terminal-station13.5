/turf/closed/wall/mineral/cult
	name = "符文金属墙壁"
	desc = "刻着难懂符号的冰冷金属墙壁，尝试研究只会让你头疼."
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult_wall-0"
	base_icon_state = "cult_wall"
	turf_flags = IS_SOLID
	smoothing_flags = SMOOTH_BITMASK
	canSmoothWith = null
	sheet_type = /obj/item/stack/sheet/runed_metal
	sheet_amount = 1
	girder_type = /obj/structure/girder/cult

/turf/closed/wall/mineral/cult/Initialize(mapload)
	new /obj/effect/temp_visual/cult/turf(src)
	. = ..()

/turf/closed/wall/mineral/cult/devastate_wall()
	new sheet_type(get_turf(src), sheet_amount)

/turf/closed/wall/mineral/cult/artificer
	name = "符文石墙"
	desc = "刻着难懂符号的冰冷石墙，尝试研究只会让你头疼."

/turf/closed/wall/mineral/cult/artificer/break_wall()
	new /obj/effect/temp_visual/cult/turf(get_turf(src))
	return null //excuse me we want no runed metal here

/turf/closed/wall/mineral/cult/artificer/devastate_wall()
	new /obj/effect/temp_visual/cult/turf(get_turf(src))

/turf/closed/wall/ice
	icon = 'icons/turf/walls/icedmetal_wall.dmi'
	icon_state = "icedmetal_wall-0"
	base_icon_state = "icedmetal_wall"
	desc = "被厚实冰块覆盖的墙."
	turf_flags = IS_SOLID
	smoothing_flags = SMOOTH_BITMASK
	canSmoothWith = null
	rcd_memory = null
	hardness = 35
	slicing_duration = 150 //welding through the ice+metal
	bullet_sizzle = TRUE

/turf/closed/wall/rust
	//SDMM supports colors, this is simply for easier mapping
	//and should be removed on initialize
	color = MAP_SWITCH(null, COLOR_ORANGE_BROWN)

/turf/closed/wall/rust/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/rust)

/turf/closed/wall/r_wall/rust
	//SDMM supports colors, this is simply for easier mapping
	//and should be removed on initialize
	color = MAP_SWITCH(null, COLOR_ORANGE_BROWN)
	base_decon_state = "rusty_r_wall"

/turf/closed/wall/r_wall/rust/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/rust)

/turf/closed/wall/mineral/bronze
	name = "发条墙壁"
	desc = "一大块青铜，装饰有齿轮和齿轮."
	icon = 'icons/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall-0"
	base_icon_state = "clockwork_wall"
	turf_flags = IS_SOLID
	smoothing_flags = SMOOTH_BITMASK
	sheet_type = /obj/item/stack/sheet/bronze
	sheet_amount = 2
	girder_type = /obj/structure/girder/bronze

/turf/closed/wall/rock
	name = "加固岩石"
	desc = "它有金属支柱，开采前需要进行焊接."
	icon = 'icons/turf/walls/reinforced_rock.dmi'
	icon_state = "porous_rock-0"
	base_icon_state = "porous_rock"
	turf_flags = NO_RUST
	sheet_amount = 1
	hardness = 50
	girder_type = null
	decon_type = /turf/closed/mineral/asteroid

/turf/closed/wall/rock/porous
	name = "加固多孔岩石"
	desc = "这块岩石充满了可呼吸的空气，开采前需要进行焊接."
	decon_type = /turf/closed/mineral/asteroid/porous

/turf/closed/wall/space
	name = "幻术墙"
	icon = 'icons/turf/space.dmi'
	icon_state = "space"
	plane = PLANE_SPACE
	turf_flags = NO_RUST
	smoothing_flags = NONE
	canSmoothWith = null
	smoothing_groups = null

/turf/closed/wall/material/meat
	name = "活体墙"
	baseturfs = /turf/open/floor/material/meat
	girder_type = null
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS

/turf/closed/wall/material/meat/Initialize(mapload)
	. = ..()
	set_custom_materials(list(GET_MATERIAL_REF(/datum/material/meat) = SHEET_MATERIAL_AMOUNT))

/turf/closed/wall/material/meat/airless
	baseturfs = /turf/open/floor/material/meat/airless
