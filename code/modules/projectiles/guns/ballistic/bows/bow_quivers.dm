
/obj/item/storage/bag/quiver
	name = "箭袋"
	desc = "为你的弓储存箭矢，总比把箭矢装口袋里好."
	icon = 'icons/obj/weapons/bows/quivers.dmi'
	icon_state = "quiver"
	inhand_icon_state = null
	worn_icon_state = "harpoon_quiver"
	/// type of arrow the quivel should hold
	var/arrow_path = /obj/item/ammo_casing/arrow

/obj/item/storage/bag/quiver/Initialize(mapload)
	. = ..()
	atom_storage.numerical_stacking = TRUE
	atom_storage.max_specific_storage = WEIGHT_CLASS_TINY
	atom_storage.max_slots = 40
	atom_storage.max_total_storage = 100
	atom_storage.set_holdable(list(
		/obj/item/ammo_casing/arrow,
	))

/obj/item/storage/bag/quiver/PopulateContents()
	. = ..()
	for(var/i in 1 to 10)
		new arrow_path(src)

/obj/item/storage/bag/quiver/holy
	name = "神圣箭袋"
	desc = "为你的神圣弓储存神圣箭，在那里它们等待着目标."
	icon_state = "holyquiver"
	inhand_icon_state = "holyquiver"
	worn_icon_state = "holyquiver"
	arrow_path = /obj/item/ammo_casing/arrow/holy
