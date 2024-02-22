/obj/item/ammo_box/a357
	name = "快速装弹器(.357)"
	desc = "设计用于快速填装左轮手枪."
	icon_state = "357"
	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 7
	multiple_sprites = AMMO_BOX_PER_BULLET
	item_flags = NO_MAT_REDEMPTION
	ammo_band_icon = "+357_ammo_band"
	ammo_band_color = null

/obj/item/ammo_box/a357/match
	name = "快速装弹器(.357 竞赛弹)"
	desc = "设计用于快速填装左轮手枪. 这些子弹是在非常严格的公差范围内制造出来的，使它们很容易用来进行特技射击."
	ammo_type = /obj/item/ammo_casing/a357/match
	ammo_band_color = "#77828a"

/obj/item/ammo_box/a357/phasic
	name = "快速装弹器(.357 相位弹)"
	desc = "设计用于快速填装左轮手枪. 这些子弹是由一种名为“幽灵铅”的实验合金制成的，这种合金几乎可以穿透任何非有机材料."
	ammo_type = /obj/item/ammo_casing/a357/phasic
	ammo_band_color = "#693a6a"

/obj/item/ammo_box/a357/heartseeker
	name = "快速装弹器(.357 寻心弹)"
	desc = "设计用于快速填装左轮手枪. 装有寻心弹，能以未知的方式精确地瞄准目标，据说是通过脑内神经脉冲来预测运动的! "
	ammo_type = /obj/item/ammo_casing/a357/heartseeker
	ammo_band_color = "#a91e1e"

/obj/item/ammo_box/c38
	name = "快速装弹器(.38)"
	desc = "设计用于快速填装左轮手枪."
	icon_state = "38"
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = AMMO_BOX_PER_BULLET
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*10)
	ammo_band_icon = "+38_ammo_band"
	ammo_band_color = null

/obj/item/ammo_box/c38/trac
	name = "快速装弹器(.38 TRAC)"
	desc = "设计用于快速填装左轮手枪. TRAC会在目标体内植入追踪装置."
	ammo_type = /obj/item/ammo_casing/c38/trac
	ammo_band_color = "#7b6383"

/obj/item/ammo_box/c38/match
	name = "快速装弹器(.38 竞赛弹)"
	desc = "设计用于快速填装左轮手枪. 这些子弹是在非常严格的公差范围内制造出来的，使它们很容易用来进行特技射击."
	ammo_type = /obj/item/ammo_casing/c38/match
	ammo_band_color = "#77828a"

/obj/item/ammo_box/c38/match/bouncy
	name = "快速装弹器(.38 橡胶弹)"
	desc = "设计用于快速填装左轮手枪. 这些子弹具有令人难以置信的弹性，并且几乎是非致命的，使它们很容易用来进行特技射击."
	ammo_type = /obj/item/ammo_casing/c38/match/bouncy
	ammo_band_color = "#556696"

/obj/item/ammo_box/c38/dumdum
	name = "快速装弹器(.38 达姆弹)"
	desc = "设计用于快速填装左轮手枪. 这些子弹在射入人体时扩张或破裂，对目标造成恐怖的撕裂伤和大出血，但在对抗装甲和远距离目标时威力骤减."
	ammo_type = /obj/item/ammo_casing/c38/dumdum
	ammo_band_color = "#969578"

/obj/item/ammo_box/c38/hotshot
	name = "快速装弹器(.38 热射弹)"
	desc = "设计用于快速填装左轮手枪. 热射弹含有易燃装药."
	ammo_type = /obj/item/ammo_casing/c38/hotshot
	ammo_band_color = "#805a57"

/obj/item/ammo_box/c38/iceblox
	name = "快速装弹器(.38 冰霜弹)"
	desc = "设计用于快速填装左轮手枪. 冰霜弹含有可致低温的化学装药."
	ammo_type = /obj/item/ammo_casing/c38/iceblox
	ammo_band_color = "#658e94"

/obj/item/ammo_box/c9mm
	name = "弹药盒(9mm)"
	icon_state = "9mmbox"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_box/c10mm
	name = "弹药盒(10mm)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 20

/obj/item/ammo_box/c45
	name = "弹药盒(.45)"
	icon_state = "45box"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 20

/obj/item/ammo_box/a40mm
	name = "弹药盒(40mm榴弹)"
	icon_state = "40mm"
	ammo_type = /obj/item/ammo_casing/a40mm
	max_ammo = 4
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/ammo_box/a40mm/rubber
	name = "弹药盒(40mm橡胶弹)"
	ammo_type = /obj/item/ammo_casing/a40mm/rubber

/obj/item/ammo_box/rocket
	name = "火箭弹束(84mm HE)"
	icon_state = "rocketbundle"
	ammo_type = /obj/item/ammo_casing/rocket
	max_ammo = 3
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/ammo_box/rocket/can_load(mob/user)
	return FALSE

/obj/item/ammo_box/strilka310
	name = "填弹条(.310 Strilka)"
	desc = "一条填弹条."
	icon_state = "310_strip"
	ammo_type = /obj/item/ammo_casing/strilka310
	max_ammo = 5
	caliber = CALIBER_STRILKA310
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/ammo_box/strilka310/surplus
	name = "填弹条(.310 廉价版)"
	ammo_type = /obj/item/ammo_casing/strilka310/surplus

/obj/item/ammo_box/n762
	name = "弹药盒(7.62x38mmR)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/n762
	max_ammo = 14

/obj/item/ammo_box/foambox
	name = "弹药盒(泡沫弹)"
	icon = 'icons/obj/weapons/guns/toy.dmi'
	icon_state = "foambox"
	ammo_type = /obj/item/ammo_casing/foam_dart
	max_ammo = 40
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*5)

/obj/item/ammo_box/foambox/mini
	icon_state = "foambox_mini"
	max_ammo = 20
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*2.5)

/obj/item/ammo_box/foambox/riot
	icon_state = "foambox_riot"
	ammo_type = /obj/item/ammo_casing/foam_dart/riot
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*25)

/obj/item/ammo_box/foambox/riot/mini
	icon_state = "foambox_riot_mini"
	max_ammo = 20
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*12.5)
