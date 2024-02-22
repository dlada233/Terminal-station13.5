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

/obj/item/ammo_casing/rebar/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless, TRUE)

/obj/item/ammo_casing/rebar/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]"

/obj/item/ammo_casing/rebar/syndie
	name = "锯齿铁棒"
	desc = "一根锯齿铁棒，排布着锯齿状的切口. 你真的不想被它刺进身体."
	caliber = CALIBER_REBAR_SYNDIE
	icon_state = "rod_jagged"
	base_icon_state = "rod_jagged"
	projectile_type = /obj/projectile/bullet/rebarsyndie
