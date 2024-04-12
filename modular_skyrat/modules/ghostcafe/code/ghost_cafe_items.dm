/obj/structure/showcase/fake_cafe_console
	name = "民用控制台"
	desc = "一台固定式计算机.这台预装了通用程序."
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "computer"

/obj/structure/showcase/fake_cafe_console/rd
	name = "R&D 控制台"
	desc = "A console used to interface with R&D tools."

/obj/structure/showcase/fake_cafe_console/rd/Initialize(mapload)
	. = ..()
	add_overlay("rdcomp")
	add_overlay("rd_key")

