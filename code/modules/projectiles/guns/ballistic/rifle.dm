/obj/item/gun/ballistic/rifle
	name = "栓动步枪"
	desc = "Some kind of bolt action rifle. You get the feeling you shouldn't have this."
	icon = 'icons/obj/weapons/guns/wide_guns.dmi'
	icon_state = "sakhno"
	w_class = WEIGHT_CLASS_BULKY
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction
	bolt_wording = "枪栓"
	bolt_type = BOLT_TYPE_LOCKING
	semi_auto = FALSE
	internal_magazine = TRUE
	fire_sound = 'sound/weapons/gun/rifle/shot_heavy.ogg'
	fire_sound_volume = 90
	rack_sound = 'sound/weapons/gun/rifle/bolt_out.ogg'
	bolt_drop_sound = 'sound/weapons/gun/rifle/bolt_in.ogg'
	tac_reloads = FALSE

/obj/item/gun/ballistic/rifle/rack(mob/user = null)
	if (bolt_locked == FALSE)
		balloon_alert(user, "拉动枪栓")
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		process_chamber(FALSE, FALSE, FALSE)
		bolt_locked = TRUE
		update_appearance()
		return
	drop_bolt(user)


/obj/item/gun/ballistic/rifle/can_shoot()
	if (bolt_locked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/rifle/examine(mob/user)
	. = ..()
	. += "该枪栓已经[bolt_locked ? "拉开" : "闭合"]."

///////////////////////
// BOLT ACTION RIFLE //
///////////////////////

/obj/item/gun/ballistic/rifle/boltaction
	name = "萨赫诺精确步枪"
	desc = "萨赫诺精确步枪，一种栓动式步枪，一直以来受到拓荒者、货仓技工、私人安保武装、探险家及其他恶人的欢迎. 这种特殊的步枪可以追溯到2440年."
	sawn_desc = "锯短的萨赫诺精确步枪，俗称‘步兵式’，没有一开始就这么设计可能是有原因的，虽然改造方式很粗野，但武器看起来依然状况良好."

	icon_state = "sakhno"
	inhand_icon_state = "sakhno"
	worn_icon_state = "sakhno"

	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction
	can_bayonet = TRUE
	knife_x_offset = 42
	knife_y_offset = 12
	can_be_sawn_off = TRUE
	weapon_weight = WEAPON_HEAVY
	var/jamming_chance = 20
	var/unjam_chance = 10
	var/jamming_increment = 5
	var/jammed = FALSE
	var/can_jam = FALSE

	SET_BASE_PIXEL(-8, 0)

/obj/item/gun/ballistic/rifle/boltaction/sawoff(mob/user)
	. = ..()
	if(.)
		spread = 36
		can_bayonet = FALSE
		SET_BASE_PIXEL(0, 0)
		update_appearance()

/obj/item/gun/ballistic/rifle/boltaction/attack_self(mob/user)
	if(can_jam)
		if(jammed)
			if(prob(unjam_chance))
				jammed = FALSE
				unjam_chance = 10
			else
				unjam_chance += 10
				balloon_alert(user, "卡壳!")
				playsound(user,'sound/weapons/jammed.ogg', 75, TRUE)
				return FALSE
	..()

/obj/item/gun/ballistic/rifle/boltaction/process_fire(mob/user)
	if(can_jam)
		if(chambered.loaded_projectile)
			if(prob(jamming_chance))
				jammed = TRUE
			jamming_chance += jamming_increment
			jamming_chance = clamp (jamming_chance, 0, 100)
	return ..()

/obj/item/gun/ballistic/rifle/boltaction/attackby(obj/item/item, mob/user, params)
	if(!bolt_locked && !istype(item, /obj/item/knife))
		balloon_alert(user, "枪栓闭合!")
		return

	. = ..()

	if(istype(item, /obj/item/gun_maintenance_supplies))
		if(!can_jam)
			balloon_alert(user, "无法卡壳!")
			return
		if(do_after(user, 10 SECONDS, target = src))
			user.visible_message(span_notice("[user]完成了维护[src]."))
			jamming_chance = initial(jamming_chance)
			qdel(item)

/obj/item/gun/ballistic/rifle/boltaction/blow_up(mob/user)
	. = FALSE
	if(chambered?.loaded_projectile)
		process_fire(user, user, FALSE)
		. = TRUE

/obj/item/gun/ballistic/rifle/boltaction/harpoon
	name = "弹道鱼叉枪"
	desc = "这是鲤鱼猎人喜欢的武器，但动物权利联盟的特工们为了讽刺也曾用它来对付人类."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "speargun"
	inhand_icon_state = "speargun"
	worn_icon_state = "speargun"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/harpoon
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	can_be_sawn_off = FALSE

	SET_BASE_PIXEL(0, 0)

/obj/item/gun/ballistic/rifle/boltaction/surplus
	name = "萨赫诺-M2442军用式"
	desc = "萨赫诺精确步枪的改型，\"Sakhno M2442 Army\"被印在了枪身上. \
		目前尚不知道哪支军队设计制造这种型号的萨赫诺步枪，也不知道它被那支军队使用过. \
		但你依然可以看出，前任主人并没有很细心的保养这把武器，内部都是潮湿的."
	sawn_desc = "锯短的Sakhno-萨赫诺精确步枪，俗称‘步兵式’，没有一开始就这么设计可能是有原因的. \
		\"Sakhno M2442 Army\"被印在了枪身上，虽然改造方式很粗野，但武器看起来依然状况良好."
	icon_state = "sakhno_tactifucked"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/surplus
	can_jam = TRUE

/obj/item/gun/ballistic/rifle/boltaction/prime
	name = "萨赫诺-桎梏运动步枪"
	desc = "原始萨赫诺步枪的现代化升级，使用了现代材料重铸，并加装了瞄准镜等其他的先进技术.."
	icon_state = "zhihao"
	inhand_icon_state = "zhihao"
	worn_icon_state = "zhihao"
	can_be_sawn_off = TRUE
	sawn_desc = "锯短的萨赫诺-桎梏运动步枪...就这么锯短它是一种罪过，但只要你开心就好. 你现在是全宇宙为数不多的拥有\"现代步兵式\"的人了."

/obj/item/gun/ballistic/rifle/boltaction/prime/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.5)

/obj/item/gun/ballistic/rifle/boltaction/prime/sawoff(mob/user)
	. = ..()
	if(.)
		name = "萨赫诺现代步兵式" // wear it loud and proud

/obj/item/gun/ballistic/rifle/rebarxbow
	name = "热熔钢筋弩"
	desc = "这把弩由无线充电器、铁棒和电线做成，它发射的是磨尖的铁棒，一般来讲弹匣中只能容纳一发，但你若要用撬棍也可以强行塞入第二根铁棒，不过得小心失火或更糟事情发生..."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "rebarxbow"
	inhand_icon_state = "rebarxbow"
	worn_icon_state = "rebarxbow"
	rack_sound = 'sound/weapons/gun/sniper/rack.ogg'
	must_hold_to_load = TRUE
	mag_display = FALSE
	empty_indicator = TRUE
	bolt_type = BOLT_TYPE_LOCKING
	semi_auto = FALSE
	internal_magazine = TRUE
	can_modify_ammo = FALSE
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_SUITSTORE
	bolt_wording = "弩弦"
	magazine_wording = "铁棒"
	cartridge_wording = "铁棒"
	misfire_probability = 25
	weapon_weight = WEAPON_HEAVY
	initial_caliber = CALIBER_REBAR
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/rebarxbow/normal
	fire_sound = 'sound/items/syringeproj.ogg'
	can_be_sawn_off = FALSE
	tac_reloads = FALSE
	var/draw_time = 3 SECONDS
	SET_BASE_PIXEL(0, 0)

/obj/item/gun/ballistic/rifle/rebarxbow/rack(mob/user = null)
	if (bolt_locked)
		drop_bolt(user)
		return
	balloon_alert(user, "弩弦松开")
	playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
	handle_chamber(empty_chamber =  FALSE, from_firing = FALSE, chamber_next_round = FALSE)
	bolt_locked = TRUE
	update_appearance()

/obj/item/gun/ballistic/rifle/rebarxbow/drop_bolt(mob/user = null)
	if(!do_after(user, draw_time, target = src))
		return
	playsound(src, bolt_drop_sound, bolt_drop_sound_volume, FALSE)
	balloon_alert(user, "弩弦拉开")
	chamber_round()
	bolt_locked = FALSE
	update_appearance()

/obj/item/gun/ballistic/rifle/rebarxbow/can_shoot()
	if (bolt_locked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/rifle/rebarxbow/examine(mob/user)
	. = ..()
	. += "十字弩[bolt_locked ? "没准备好" : "准备好了"]开火."

/obj/item/gun/ballistic/rifle/rebarxbow/forced
	name = "重压钢筋弩"
	desc = "一些白痴决定冒着朝自己脸上开枪的风险做出了这个弩，这意味着他们可以在这个弩里多一点弹药，希望这是值得的."
	// Feel free to add a recipe to allow you to change it back if you would like, I just wasn't sure if you could have two recipes for the same thing.
	can_misfire = TRUE
	misfire_probability = 25
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/rebarxbow/force

/obj/item/gun/ballistic/rifle/rebarxbow/syndie
	name = "辛迪加钢筋弩"
	desc = "辛迪加很喜欢纳米工程师制造的钢筋弩，所以他们展示了如果充分开发的话，它可以是什么样子的；拥有三发弹匣，内置瞄准镜，还发射特殊的辛迪加锯齿铁棒，当然也可以射击正常铁棒."
	icon_state = "rebarxbowsyndie"
	inhand_icon_state = "rebarxbowsyndie"
	worn_icon_state = "rebarxbowsyndie"
	w_class = WEIGHT_CLASS_NORMAL
	can_modify_ammo = TRUE
	initial_caliber = CALIBER_REBAR_SYNDIE
	alternative_caliber = CALIBER_REBAR_SYNDIE_NORMAL
	alternative_ammo_misfires = FALSE
	draw_time = 1
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/rebarxbow/syndie

/obj/item/gun/ballistic/rifle/rebarxbow/syndie/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2) //enough range to at least be useful for stealth

/obj/item/gun/ballistic/rifle/boltaction/pipegun
	name = "管道枪"
	desc = "这种出色的武器可以消灭地道里的老鼠和敌对助手，但它的膛线还有很多地方需要改进."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "musket"
	inhand_icon_state = "musket"
	worn_icon_state = "musket"
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/pipegun
	initial_caliber = CALIBER_SHOTGUN
	alternative_caliber = CALIBER_STRILKA310
	initial_fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	alternative_fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'
	can_modify_ammo = TRUE
	can_bayonet = TRUE
	knife_y_offset = 11
	can_be_sawn_off = FALSE
	projectile_damage_multiplier = 0.75

	SET_BASE_PIXEL(0, 0)

/obj/item/gun/ballistic/rifle/boltaction/pipegun/handle_chamber()
	. = ..()
	do_sparks(1, TRUE, src)

/obj/item/gun/ballistic/rifle/boltaction/pipegun/prime
	name = "帝王管道枪"
	desc = "年长的助手领主通常拥有更有价值的战利品."
	icon_state = "musket_prime"
	inhand_icon_state = "musket_prime"
	worn_icon_state = "musket_prime"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/pipegun/prime
	projectile_damage_multiplier = 1

/// MAGICAL BOLT ACTIONS + ARCANE BARRAGE? ///

/obj/item/gun/ballistic/rifle/enchanted
	name = "附魔栓动步枪"
	desc = "小心别丢了脑袋."
	icon_state = "enchanted_rifle"
	inhand_icon_state = "enchanted_rifle"
	worn_icon_state = "enchanted_rifle"
	slot_flags = ITEM_SLOT_BACK
	var/guns_left = 30
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/enchanted
	can_be_sawn_off = FALSE

	SET_BASE_PIXEL(-8, 0)

/obj/item/gun/ballistic/rifle/enchanted/dropped()
	. = ..()
	guns_left = 0
	magazine = null
	chambered = null

/obj/item/gun/ballistic/rifle/enchanted/proc/discard_gun(mob/living/user)
	user.throw_item(pick(oview(7,get_turf(user))))

/obj/item/gun/ballistic/rifle/enchanted/attack_self()
	return

/obj/item/gun/ballistic/rifle/enchanted/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	if(!.)
		return
	if(guns_left)
		var/obj/item/gun/ballistic/rifle/enchanted/gun = new type
		gun.guns_left = guns_left - 1
		discard_gun(user)
		user.swap_hand()
		user.put_in_hands(gun)
	else
		user.dropItemToGround(src, TRUE)

// SNIPER //

/obj/item/gun/ballistic/rifle/sniper_rifle
	name = "反器材狙击步枪"
	desc = "栓动式反器材狙击步枪，使用.50 BMG子弹. 虽然在技术上它已经过时了，但作为一种大口径步枪，它的性能仍然非常好. \
		在模块服全面列装的今天，这种穿甲武器在战场上更是有了新的职责，然而这种穿甲效率也并非百分之一百..."
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "sniper"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	weapon_weight = WEAPON_HEAVY
	inhand_icon_state = "sniper"
	worn_icon_state = null
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	fire_sound_volume = 90
	load_sound = 'sound/weapons/gun/sniper/mag_insert.ogg'
	rack_sound = 'sound/weapons/gun/sniper/rack.ogg'
	suppressed_sound = 'sound/weapons/gun/general/heavy_shot_suppressed.ogg'
	recoil = 2
	accepted_magazine_type = /obj/item/ammo_box/magazine/sniper_rounds
	internal_magazine = FALSE
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK
	mag_display = TRUE
	tac_reloads = TRUE
	rack_delay = 1 SECONDS
	can_suppress = TRUE
	can_unsuppress = TRUE
	suppressor_x_offset = 3
	suppressor_y_offset = 3

/obj/item/gun/ballistic/rifle/sniper_rifle/examine(mob/user)
	. = ..()
	. += span_warning("<b>它似乎有一个警告标签:</b> 不要，在任何情况下，试图用这支步枪'快速瞄准'.")

/obj/item/gun/ballistic/rifle/sniper_rifle/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 4) //enough range to at least make extremely good use of the penetrator rounds

/obj/item/gun/ballistic/rifle/sniper_rifle/reset_semicd()
	. = ..()
	if(suppressed)
		playsound(src, 'sound/machines/eject.ogg', 25, TRUE, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
	else
		playsound(src, 'sound/machines/eject.ogg', 50, TRUE)

/obj/item/gun/ballistic/rifle/sniper_rifle/syndicate
	desc = "栓动式反器材狙击步枪，使用.50 BMG子弹. 虽然在技术上它已经过时了，但作为一种大口径步枪，它的性能仍然非常好. \
		在模块服全面列装的今天，这种穿甲武器在战场上更是有了新的职责，然而这种穿甲效率也并非百分之一百...这把枪似乎印有一个穿着血红色模块服小人指着绿色软盘，什么意思啊？"
	pin = /obj/item/firing_pin/implant/pindicate
