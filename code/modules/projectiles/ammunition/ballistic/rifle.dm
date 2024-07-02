// .310 Strilka (Sakhno Rifle)

/obj/item/ammo_casing/strilka310
	name = ".310子弹"
	desc = "一颗.310子弹. 外壳只是谎言，压根就没有外壳，有的只是红色的火药."
	icon_state = "310-casing"
	caliber = CALIBER_STRILKA310
	projectile_type = /obj/projectile/bullet/strilka310

/obj/item/ammo_casing/strilka310/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/strilka310/surplus
	name = ".310廉价子弹"
	desc = "一颗.310子弹. 外壳只是谎言，压根就没有外壳，有的只是红色的火药，甚至还有些潮湿了."
	projectile_type = /obj/projectile/bullet/strilka310/surplus

/obj/item/ammo_casing/strilka310/enchanted
	projectile_type = /obj/projectile/bullet/strilka310/enchanted

// .223 (M-90gl Carbine)

/obj/item/ammo_casing/a223
	name = ".223子弹"
	desc = "一颗.223子弹."
	caliber = CALIBER_A223
	projectile_type = /obj/projectile/bullet/a223

/obj/item/ammo_casing/a223/phasic
	name = ".223相位弹"
	desc = "一颗.223相位子弹."
	projectile_type = /obj/projectile/bullet/a223/phasic

/obj/item/ammo_casing/a223/weak
	projectile_type = /obj/projectile/bullet/a223/weak

// 40mm (Grenade Launcher)

/obj/item/ammo_casing/a40mm
	name = "40mm HE 榴弹"
	desc = "一颗高爆榴弹，只有用榴弹发射器发射出去后才会引爆."
	caliber = CALIBER_40MM
	icon_state = "40mmHE"
	projectile_type = /obj/projectile/bullet/a40mm

/obj/item/ammo_casing/a40mm/rubber
	name = "40mm 橡胶榴弹"
	desc = "一颗一下就能把人击晕的橡胶榴弹，是豆袋弹的大哥，对抗装甲目标时则没那么管用."
	projectile_type = /obj/projectile/bullet/shotgun_beanbag/a40mm

/obj/item/ammo_casing/rebar
	name = "磨尖铁棒"
	desc = "一根磨尖的铁棒，尖锐且锋利!"
	caliber = CALIBER_REBAR
	icon_state = "rod_sharp"
	base_icon_state = "rod_sharp"
	projectile_type = /obj/projectile/bullet/rebar

/obj/item/ammo_casing/rebar/syndie
	name = "锯齿铁棒"
	desc = "一根锯齿铁棒，排布着锯齿状的切口. 你真的不想被它刺进身体."
	caliber = CALIBER_REBAR
	icon_state = "rod_jagged"
	base_icon_state = "rod_jagged"
	projectile_type = /obj/projectile/bullet/rebar/syndie

/obj/item/ammo_casing/rebar/zaukerite
	name = "Zaukerite Sliver"
	desc = "A sliver of a zaukerite crystal. Due to its irregular, jagged edges, removal of an embedded zaukerite sliver should only be done by trained surgeons."
	caliber = CALIBER_REBAR
	icon_state = "rod_zaukerite"
	base_icon_state = "rod_zaukerite"
	projectile_type = /obj/projectile/bullet/rebar/zaukerite

/obj/item/ammo_casing/rebar/hydrogen
	name = "Metallic Hydrogen Bolt"
	desc = "An ultra-sharp rod made from pure metallic hydrogen. Armor may as well not exist."
	caliber = CALIBER_REBAR
	icon_state = "rod_hydrogen"
	base_icon_state = "rod_hydrogen"
	projectile_type = /obj/projectile/bullet/rebar/hydrogen

/obj/item/ammo_casing/rebar/healium
	name = "Healium Crystal Bolt"
	desc = "Who needs a syringe gun, anyway?"
	caliber = CALIBER_REBAR
	icon_state = "rod_healium"
	base_icon_state =  "rod_healium"
	projectile_type = /obj/projectile/bullet/rebar/healium

/obj/item/ammo_casing/rebar/supermatter
	name = "Supermatter Bolt"
	desc = "Wait, how is the bow capable of firing this without dusting?"
	caliber = CALIBER_REBAR
	icon_state = "rod_supermatter"
	base_icon_state = "rod_supermatter"
	projectile_type = /obj/projectile/bullet/rebar/supermatter

/obj/item/ammo_casing/rebar/paperball
	name = "Paper Ball"
	desc = "Doink!"
	caliber = CALIBER_REBAR
	icon_state = "paperball"
	base_icon_state = "paperball"
	projectile_type = /obj/projectile/bullet/paperball

/obj/item/ammo_casing/rebar/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless, TRUE)

/obj/item/ammo_casing/rebar/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]"

