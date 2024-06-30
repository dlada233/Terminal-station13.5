//KEEP IN MIND: These are different from gun/grenadelauncher. These are designed to shoot premade rocket and grenade projectiles, not flashbangs or chemistry casings etc.
//Put handheld rocket launchers here if someone ever decides to make something so hilarious ~Paprika

/obj/item/gun/ballistic/revolver/grenadelauncher//this is only used for underbarrel grenade launchers at the moment, but admins can still spawn it if they feel like being assholes
	desc = "一种简易榴弹发射器."
	name = "榴弹发射器"
	icon_state = "dshotgun_sawn"
	inhand_icon_state = "gun"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/grenadelauncher
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	pin = /obj/item/firing_pin/implant/pindicate
	bolt_type = BOLT_TYPE_NO_BOLT

/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/grenadelauncher/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/ammo_box) || isammocasing(A))
		chamber_round()

/obj/item/gun/ballistic/revolver/grenadelauncher/cyborg
	desc = "六连装榴弹发射器."
	name = "多管榴弹发射器"
	icon = 'icons/obj/devices/mecha_equipment.dmi'
	icon_state = "mecha_grenadelnchr"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/grenademulti
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/grenadelauncher/cyborg/attack_self()
	return

/obj/item/gun/ballistic/automatic/gyropistol
	name = "火箭手枪"
	desc = "一种设计用来发射火箭的原型手枪."
	icon_state = "gyropistol"
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	accepted_magazine_type = /obj/item/ammo_box/magazine/m75
	burst_size = 1
	fire_delay = 0
	casing_ejector = FALSE

/obj/item/gun/ballistic/rocketlauncher
	name = "PML-9"
	desc = "一种可重复使用的火箭推进器. 枪管附近写有\"请看纳米狗\"的字样与箭头涂鸦. \
	在靠近观瞄具的附近还有一段提示标签，写着\"开火前确保后方无人\""
	icon = 'icons/obj/weapons/guns/wide_guns.dmi'
	icon_state = "rocketlauncher"
	inhand_icon_state = "rocketlauncher"
	worn_icon_state = "rocketlauncher"
	SET_BASE_PIXEL(-8, 0)
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rocketlauncher
	fire_sound = 'sound/weapons/gun/general/rocket_launch.ogg'
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	can_suppress = FALSE
	pin = /obj/item/firing_pin/implant/pindicate
	burst_size = 1
	fire_delay = 0
	casing_ejector = FALSE
	weapon_weight = WEAPON_HEAVY
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	cartridge_wording = "rocket"
	empty_indicator = TRUE
	tac_reloads = FALSE
	/// Do we shit flames behind us when we fire?
	var/backblast = TRUE

/obj/item/gun/ballistic/rocketlauncher/Initialize(mapload)
	. = ..()
	if(backblast)
		AddElement(/datum/element/backblast)

/obj/item/gun/ballistic/rocketlauncher/unrestricted
	desc = "A reusable rocket propelled grenade launcher. An arrow pointing toward the front of the launcher \
		alongside the words \"Front Toward Enemy\" are printed on the tube. \
		A sticker near the back of the launcher warn to \"CHECK BACKBLAST CLEAR BEFORE FIRING\", whatever that means."
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/rocketlauncher/nobackblast
	name = "无焰PML-11"
	desc = "一种可重复使用的火箭推进器，这一个已经配备了一个特殊的冷却回路，以避免尴尬的友军伤害."
	backblast = FALSE

/obj/item/gun/ballistic/rocketlauncher/afterattack()
	. = ..()
	magazine.get_round(FALSE) //Hack to clear the mag after it's fired

/obj/item/gun/ballistic/rocketlauncher/attack_self_tk(mob/user)
	return //too difficult to remove the rocket with TK

/obj/item/gun/ballistic/rocketlauncher/update_overlays()
	. = ..()
	if(get_ammo())
		. += "rocketlauncher_loaded"

/obj/item/gun/ballistic/rocketlauncher/suicide_act(mob/living/user)
	user.visible_message(span_warning("[user]用[src]瞄准地面! 看起来试图表演一个经典的火箭跳!"), \
		span_userdanger("你用[src]瞄准地面看起像是在表演火箭跳一样..."))
	if(can_shoot())
		ADD_TRAIT(user, TRAIT_NO_TRANSFORM, REF(src))
		playsound(src, 'sound/vehicles/rocketlaunch.ogg', 80, TRUE, 5)
		animate(user, pixel_z = 300, time = 30, flags = ANIMATION_RELATIVE, easing = LINEAR_EASING)
		sleep(7 SECONDS)
		animate(user, pixel_z = -300, time = 5, flags = ANIMATION_RELATIVE, easing = LINEAR_EASING)
		sleep(0.5 SECONDS)
		REMOVE_TRAIT(user, TRAIT_NO_TRANSFORM, REF(src))
		process_fire(user, user, TRUE)
		if(!QDELETED(user)) //if they weren't gibbed by the explosion, take care of them for good.
			user.gib(DROP_ALL_REMAINS)
		return MANUAL_SUICIDE
	else
		sleep(0.5 SECONDS)
		shoot_with_empty_chamber(user)
		sleep(2 SECONDS)
		user.visible_message(span_warning("[user]环顾四周，发现自己还在此地. 于是决定使用[src]让自己窒息而死!"), \
			span_userdanger("你环顾四周，发现自己还在此地. 于是决定使用[src]让自己窒息而死!"))
		sleep(2 SECONDS)
		return OXYLOSS
