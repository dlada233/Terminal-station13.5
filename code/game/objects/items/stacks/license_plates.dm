/obj/item/stack/license_plates
	name = "废车牌"
	desc = "someone fucked up"
	icon = 'icons/obj/machines/prison.dmi'
	icon_state = "empty_plate"
	novariants = FALSE
	max_amount = 50

/obj/item/stack/license_plates/empty
	name = "空车牌"
	singular_name = "empty license plate"
	desc = "Instead of a license plate number, this could contain a quote like \"Live laugh love\"."
	merge_type = /obj/item/stack/license_plates/empty

/obj/item/stack/license_plates/empty/fifty
	amount = 50

/obj/item/stack/license_plates/filled
	name = "车牌"
	singular_name = "车牌"
	desc = "Prison labor paying off."
	icon_state = "filled_plate_1_1"
	merge_type = /obj/item/stack/license_plates/filled

///Override to allow for variations
/obj/item/stack/license_plates/filled/update_icon_state()
	. = ..()
	if(novariants)
		return
	if(amount <= (max_amount * (1/3)))
		icon_state = "filled_plate_[rand(1,6)]_1"
		return
	if (amount <= (max_amount * (2/3)))
		icon_state = "filled_plate_[rand(1,6)]_2"
		return
	icon_state = "filled_plate_[rand(1,6)]_3"
