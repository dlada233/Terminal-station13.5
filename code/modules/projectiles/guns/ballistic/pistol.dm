/obj/item/gun/ballistic/automatic/pistol
	name = "马卡洛夫手枪"
//	desc = "A small, easily concealable 9mm handgun. Has a threaded barrel for suppressors."	// SKYRAT EDIT: Original
	desc = "一种小型易隐蔽的9x25毫米Mk.12手枪，配有可装消声器的螺纹枪管."	// SKYRAT EDIT: Calibre rename
	icon_state = "pistol"
	w_class = WEIGHT_CLASS_SMALL
	accepted_magazine_type = /obj/item/ammo_box/magazine/m9mm
	can_suppress = TRUE
	burst_size = 1
	fire_delay = 0
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	dry_fire_sound = 'sound/weapons/gun/pistol/dry_fire.ogg'
	suppressed_sound = 'sound/weapons/gun/pistol/shot_suppressed.ogg'
	load_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	load_empty_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	eject_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	eject_empty_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	rack_sound = 'sound/weapons/gun/pistol/rack_small.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/lock_small.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/drop_small.ogg'
	fire_sound_volume = 90
	bolt_wording = "滑动"
	suppressor_x_offset = 10
	suppressor_y_offset = -1

/obj/item/gun/ballistic/automatic/pistol/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/fire_mag
	spawn_magazine_type = /obj/item/ammo_box/magazine/m9mm/fire

/obj/item/gun/ballistic/automatic/pistol/suppressed/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/S = new(src)
	install_suppressor(S)

/obj/item/gun/ballistic/automatic/pistol/clandestine
	name = "安瑟姆手枪"
	desc = "马卡洛夫的精神继承者，或者只是有人把枪掉进了油漆桶里，口径为10毫米."
	icon_state = "pistol_evil"
	accepted_magazine_type = /obj/item/ammo_box/magazine/m10mm
	empty_indicator = TRUE
	suppressor_x_offset = 12

/obj/item/gun/ballistic/automatic/pistol/m1911 //ICON OVERRIDEN IN SKYRAT AESTHETICS - SEE MODULE
	name = "M1911"
	desc = "经典的.45口径手枪，弹夹容量小."
	icon_state = "m1911"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/m45
	can_suppress = FALSE
	fire_sound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	rack_sound = 'sound/weapons/gun/pistol/rack.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/slide_drop.ogg'

/**
 * Weak 1911 for syndicate chimps. It comes in a 4 TC kit.
 * 15 damage every.. second? 7 shots to kill. Not fast.
 */
/obj/item/gun/ballistic/automatic/pistol/m1911/chimpgun
	name = "CH1M911"
	desc = "忙碌的猴子黑手党使用的，使用.45子弹，有明显的香蕉味."
	projectile_damage_multiplier = 0.5
	projectile_wound_bonus = -12
	pin = /obj/item/firing_pin/monkey


/obj/item/gun/ballistic/automatic/pistol/m1911/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/deagle
	name = "沙漠之鹰"
	desc = "一把结实的.50口径手枪."
	icon_state = "deagle"
	force = 14
	accepted_magazine_type = /obj/item/ammo_box/magazine/m50
	can_suppress = FALSE
	mag_display = TRUE
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	rack_sound = 'sound/weapons/gun/pistol/rack.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/slide_drop.ogg'

/obj/item/gun/ballistic/automatic/pistol/deagle/gold
	desc = "这把镀金的沙漠之鹰被火星上的高级枪匠打磨了上百万次，使用.50 AE弹药."
	icon_state = "deagleg"
	inhand_icon_state = "deagleg"

/obj/item/gun/ballistic/automatic/pistol/deagle/camo
	desc = "这把镀金的沙漠之鹰被火星上的高级枪匠打磨了上百万次，使用.50 AE弹药."
	icon_state = "deaglecamo"
	inhand_icon_state = "deagleg"
	// SKYRAT EDIT - We don't actually have the right icons for this. When you add the icons you can remove this line!
	show_bolt_icon = FALSE
	// SKYRAT EDIT END

/obj/item/gun/ballistic/automatic/pistol/deagle/regal
	name = "皇家之鹰"
	desc = "与沙漠之鹰不同，这种武器似乎配备了某种先进的内部稳定系统，以使用更小的口径为代价，显著减少后坐力，提高整体精度. \
		这允许它进行一个非常快速的2轮爆发射击，使用10毫米弹药."
	icon_state = "reagle"
	inhand_icon_state = "deagleg"
	burst_size = 2
	fire_delay = 1
	projectile_damage_multiplier = 1.25
	accepted_magazine_type = /obj/item/ammo_box/magazine/r10mm
	actions_types = list(/datum/action/item_action/toggle_firemode)
	obj_flags = UNIQUE_RENAME // if you did the sidequest, you get the customization

/obj/item/gun/ballistic/automatic/pistol/aps
	name = "斯捷奇金APS自动手枪"
	desc = "苏联老式自动手枪的现代化复制品，它射得很快. 使用9毫米弹药，有可以装消声器的螺纹枪管." //SKYRAT EDIT
	icon_state = "aps"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/m9mm_aps
	can_suppress = TRUE
	burst_size = 3
	fire_delay = 3 //SKYRAT EDIT - Original: 1
	spread = 10
	actions_types = list(/datum/action/item_action/toggle_firemode)
	suppressor_x_offset = 6

/obj/item/gun/ballistic/automatic/pistol/stickman
	name = "平面枪"
	desc = "一把二维的枪?"
	icon_state = "flatgun"
	mag_display = FALSE
	show_bolt_icon = FALSE

/obj/item/gun/ballistic/automatic/pistol/stickman/equipped(mob/user, slot)
	..()
	to_chat(user, span_notice("当你试图操作[src]时，它就会从你手中滑走..."))
	if(prob(50))
		to_chat(user, span_notice("..从你的视野中消失了!它到底去哪了?"))
		qdel(src)
		user.update_icons()
	else
		to_chat(user, span_notice("..突然映入了眼帘，哇，好险啊."))
		user.dropItemToGround(src)
