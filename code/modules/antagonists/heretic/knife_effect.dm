// "Floating ghost blade" effect for blade heretics
/obj/effect/floating_blade
	name = "刀"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "dio_knife"
	layer = LOW_MOB_LAYER
	/// The color the knife glows around it.
	var/glow_color = "#ececff"

/obj/effect/floating_blade/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/movetype_handler)
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)
	add_filter("dio_knife", 2, list("type" = "outline", "color" = glow_color, "size" = 1))
