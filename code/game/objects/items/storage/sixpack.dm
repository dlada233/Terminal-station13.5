/obj/item/storage/cans
	name = "饮料环"
	desc = "最多可容纳六个饮料罐."
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "canholder"
	inhand_icon_state = "cola"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	custom_materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT*1.2)
	max_integrity = 500

/obj/item/storage/cans/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]开始和男孩们一起打开最后一瓶饮料! 这是一种自杀行为!"))
	return BRUTELOSS

/obj/item/storage/cans/update_icon_state()
	icon_state = "[initial(icon_state)][contents.len]"
	return ..()

/obj/item/storage/cans/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/storage/cans/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.max_total_storage = 12
	atom_storage.max_slots = 6
	atom_storage.set_holdable(list(
		/obj/item/reagent_containers/cup/soda_cans,
		/obj/item/reagent_containers/cup/glass/bottle/beer,
		/obj/item/reagent_containers/cup/glass/bottle/ale,
		/obj/item/reagent_containers/cup/glass/waterbottle,
	))

/obj/item/storage/cans/sixsoda
	name = "汽水环"
	desc = "能装六个汽水罐，用完后记得回收!"

/obj/item/storage/cans/sixsoda/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/cup/soda_cans/cola(src)

/obj/item/storage/cans/sixbeer
	name = "啤酒环"
	desc = "能装六个啤酒罐，用完后记得回收!"

/obj/item/storage/cans/sixbeer/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/cup/glass/bottle/beer(src)
