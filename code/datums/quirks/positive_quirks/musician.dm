/datum/quirk/item_quirk/musician
	name = "Musician-音乐家"
	desc = "你能调谐手中乐器，为听众演奏出旋律，抚平负面影响和抚慰心灵。."
	icon = FA_ICON_GUITAR
	value = 2
	mob_trait = TRAIT_MUSICIAN
	gain_text = span_notice("你对乐器无比通晓.")
	lose_text = span_danger("你忘了如何弹奏乐器.")
	medical_record_text = "脑部扫描显示患者的听觉通路高度发达."
	mail_goodies = list(/obj/effect/spawner/random/entertainment/musical_instrument, /obj/item/instrument/piano_synth/headphones)

/datum/quirk/item_quirk/musician/add_unique(client/client_source)
	give_item_to_holder(/obj/item/choice_beacon/music, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
