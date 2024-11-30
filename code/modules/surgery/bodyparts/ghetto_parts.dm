/obj/item/bodypart/arm/left/ghetto
	name = "木钩左臂"
	desc = "一个原本应是前臂的位置，被一根粗略雕刻的木钩代替. 它简单而结实，显然是用手头能找到的任何材料匆忙制成的. 尽管外观简陋，但它能发挥作用."
	icon = 'icons/mob/human/species/ghetto.dmi'
	icon_static = 'icons/mob/human/species/ghetto.dmi'
	limb_id = BODYPART_ID_PEG
	icon_state = "peg_l_arm"
	bodytype = BODYTYPE_PEG
	should_draw_greyscale = FALSE
	attack_verb_simple = list("猛击", "劈钩")
	unarmed_damage_low = 3
	unarmed_damage_high = 9
	unarmed_effectiveness = 5
	brute_modifier = 1.2
	burn_modifier = 1.5
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)
	disabling_threshold_percentage = 1
	bodypart_flags = BODYPART_UNHUSKABLE
	biological_state = (BIO_JOINTED)

/obj/item/bodypart/arm/left/ghetto/Initialize(mapload, ...)
	. = ..()
	ADD_TRAIT(src, TRAIT_EASY_ATTACH, INNATE_TRAIT)

/obj/item/bodypart/arm/right/ghetto
	name = "木钩右臂"
	desc = "一个原本应是前臂的位置，被一根粗略雕刻的木钩代替. 它简单而结实，显然是用手头能找到的任何材料匆忙制成的. 尽管外观简陋，但它能发挥作用."
	icon = 'icons/mob/human/species/ghetto.dmi'
	icon_static = 'icons/mob/human/species/ghetto.dmi'
	limb_id = BODYPART_ID_PEG
	icon_state = "peg_r_arm"
	bodytype = BODYTYPE_PEG
	should_draw_greyscale = FALSE
	attack_verb_simple = list("猛击", "劈钩")
	unarmed_damage_low = 3
	unarmed_damage_high = 9
	unarmed_effectiveness = 5
	brute_modifier = 1.2
	burn_modifier = 1.5
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)
	disabling_threshold_percentage = 1
	bodypart_flags = BODYPART_UNHUSKABLE
	biological_state = (BIO_JOINTED)

/obj/item/bodypart/arm/right/ghetto/Initialize(mapload, ...)
	. = ..()
	ADD_TRAIT(src, TRAIT_EASY_ATTACH, INNATE_TRAIT)

/obj/item/bodypart/leg/left/ghetto
	name = "木制左腿"
	desc = "这条用疑似桌腿改造而成的木腿，为‘边走边用餐’赋予了全新的含义. 它走起路来摇摇晃晃，每一步都发出不祥的吱嘎声，但至少你可以宣称自己是七海之上饮食最均衡的人."
	icon = 'icons/mob/human/species/ghetto.dmi'
	icon_static = 'icons/mob/human/species/ghetto.dmi'
	limb_id = BODYPART_ID_PEG
	icon_state = "peg_l_leg"
	bodytype = BODYTYPE_PEG
	should_draw_greyscale = FALSE
	unarmed_damage_low = 2
	unarmed_damage_high = 5
	unarmed_effectiveness = 10
	brute_modifier = 1.2
	burn_modifier = 1.5
	disabling_threshold_percentage = 1
	bodypart_flags = BODYPART_UNHUSKABLE
	biological_state = (BIO_JOINTED)

/obj/item/bodypart/leg/left/ghetto/Initialize(mapload, ...)
	. = ..()
	ADD_TRAIT(src, TRAIT_EASY_ATTACH, INNATE_TRAIT)

/obj/item/bodypart/leg/right/ghetto
	name = "木制右腿"
	desc = "这条用疑似桌腿改造而成的木腿，为‘边走边用餐’赋予了全新的含义. 它走起路来摇摇晃晃，每一步都发出不祥的吱嘎声，但至少你可以宣称自己是七海之上饮食最均衡的人."
	icon = 'icons/mob/human/species/ghetto.dmi'
	icon_static = 'icons/mob/human/species/ghetto.dmi'
	limb_id = BODYPART_ID_PEG
	icon_state = "peg_r_leg"
	bodytype = BODYTYPE_PEG
	should_draw_greyscale = FALSE
	unarmed_damage_low = 2
	unarmed_damage_high = 5
	unarmed_effectiveness = 10
	brute_modifier = 1.2
	burn_modifier = 1.5
	disabling_threshold_percentage = 1
	bodypart_flags = BODYPART_UNHUSKABLE
	biological_state = (BIO_JOINTED)

/obj/item/bodypart/leg/right/ghetto/Initialize(mapload, ...)
	. = ..()
	ADD_TRAIT(src, TRAIT_EASY_ATTACH, INNATE_TRAIT)
