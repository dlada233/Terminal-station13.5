/obj/structure/cable/multilayer/multiz //This bridges powernets betwen Z levels
	name = "垂直电缆集线器"
	desc = "允许你进行跨Z层的连线."
	icon = 'icons/obj/pipes_n_cables/structures.dmi'
	icon_state = "cablerelay-on"
	cable_layer = CABLE_LAYER_1|CABLE_LAYER_2|CABLE_LAYER_3

/obj/structure/cable/multilayer/multiz/get_cable_connections(powernetless_only)
	. = ..()
	var/turf/T = get_turf(src)
	. += locate(/obj/structure/cable/multilayer/multiz) in (GET_TURF_BELOW(T))
	. += locate(/obj/structure/cable/multilayer/multiz) in (GET_TURF_ABOVE(T))

/obj/structure/cable/multilayer/multiz/examine(mob/user)
	. = ..()
	var/turf/T = get_turf(src)
	. += span_notice("[locate(/obj/structure/cable/multilayer/multiz) in (GET_TURF_BELOW(T)) ? "检测到" : "未检测到"]上方集线器.")
	. += span_notice("[locate(/obj/structure/cable/multilayer/multiz) in (GET_TURF_ABOVE(T)) ? "检测到" : "未检测到"]下方集线器.")
