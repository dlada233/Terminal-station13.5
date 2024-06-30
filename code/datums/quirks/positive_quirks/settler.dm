/datum/quirk/item_quirk/settler
	name = "Settler-开拓者"
	desc = "你的血脉追溯至最早太空开拓者! 尽管你们家族几代人经受着不同重力的影响， \
		导致身高... 普遍比同物种其他族群低， \
		但你们在户外生存和搬运重物方面更胜一筹，并且善于与动物相处.然而，因为腿比较短，你的移动速度也稍慢"
	gain_text = span_bold("整个世界都是你的舞台!")
	lose_text = span_danger("你感觉今天应该待在家里.")
	icon = FA_ICON_HOUSE
	value = 4
	mob_trait = TRAIT_SETTLER
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	medical_record_text = "Patient appears to be abnormally stout."
	mail_goodies = list(
		/obj/item/clothing/shoes/workboots/mining,
		/obj/item/gps,
	)

/datum/quirk/item_quirk/settler/add(client/client_source)
	var/mob/living/carbon/human/human_quirkholder = quirk_holder
	//SKYRAT EDIT BEGIN - This is so Teshari don't get the height decrease.
	if(!isteshari(human_quirkholder))
		human_quirkholder.set_mob_height(HUMAN_HEIGHT_SHORTEST)
	//SKYRAT EDIT END
	human_quirkholder.add_movespeed_modifier(/datum/movespeed_modifier/settler)
	human_quirkholder.physiology.hunger_mod *= 0.5 //good for you, shortass, you don't get hungry nearly as often

/datum/quirk/item_quirk/settler/add_unique(client/client_source)
	give_item_to_holder(/obj/item/storage/box/papersack/wheat, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
	give_item_to_holder(/obj/item/storage/toolbox/fishing/small, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/settler/remove()
	if(QDELING(quirk_holder))
		return
	var/mob/living/carbon/human/human_quirkholder = quirk_holder
	human_quirkholder.set_mob_height(HUMAN_HEIGHT_MEDIUM)
	human_quirkholder.remove_movespeed_modifier(/datum/movespeed_modifier/settler)
	human_quirkholder.physiology.hunger_mod *= 2
