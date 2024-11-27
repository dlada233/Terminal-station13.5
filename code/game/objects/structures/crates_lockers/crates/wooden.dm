/obj/structure/closet/crate/wooden
	name = "木制货箱"
	desc = "和金属箱一样好用."
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 6
	icon_state = "wooden"
	base_icon_state = "wooden"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	paint_jobs = null
	cutting_tool = /obj/item/crowbar

/obj/structure/closet/crate/wooden/toy
	name = "玩具箱"
	desc = "下面用记号笔写着:\"小丑 + 哑剧\"."

/obj/structure/closet/crate/wooden/toy/PopulateContents()
	. = ..()
	new /obj/item/megaphone/clown(src)
	new /obj/item/reagent_containers/cup/soda_cans/canned_laughter(src)
	new /obj/item/pneumatic_cannon/pie(src)
	new /obj/item/food/pie/cream(src)
	new /obj/item/storage/crayons(src)
