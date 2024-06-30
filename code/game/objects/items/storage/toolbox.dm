/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage/toolbox.dmi'
	icon_state = "toolbox_default"
	inhand_icon_state = "toolbox_default"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	force = 12
	throwforce = 12
	throw_speed = 2
	throw_range = 7
	demolition_mod = 1.25
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*5)
	attack_verb_continuous = list("robusts")
	attack_verb_simple = list("robust")
	hitsound = 'sound/weapons/smash.ogg'
	drop_sound = 'sound/items/handling/toolbox_drop.ogg'
	pickup_sound = 'sound/items/handling/toolbox_pickup.ogg'
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR
	var/latches = "single_latch"
	var/has_latches = TRUE
	wound_bonus = 5

/obj/item/storage/toolbox/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	if(has_latches)
		if(prob(10))
			latches = "double_latch"
			if(prob(1))
				latches = "triple_latch"
	update_appearance()

	AddElement(/datum/element/falling_hazard, damage = force, wound_bonus = wound_bonus, hardhat_safety = TRUE, crushes = FALSE, impact_sound = hitsound)

/obj/item/storage/toolbox/update_overlays()
	. = ..()
	if(has_latches)
		. += latches

/obj/item/storage/toolbox/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]用[src]猛击自己! 这是一种自杀行为."))
	return BRUTELOSS

/obj/item/storage/toolbox/emergency
	name = "应急工具箱"
	icon_state = "red"
	inhand_icon_state = "toolbox_red"
	material_flags = NONE
	throw_speed = 3 // red ones go faster

/obj/item/storage/toolbox/emergency/PopulateContents()
	new /obj/item/crowbar/red(src)
	new /obj/item/weldingtool/mini(src)
	new /obj/item/extinguisher/mini(src)
	switch(rand(1,3))
		if(1)
			new /obj/item/flashlight(src)
		if(2)
			new /obj/item/flashlight/glowstick(src)
		if(3)
			new /obj/item/flashlight/flare(src)
	new /obj/item/radio/off(src)

/obj/item/storage/toolbox/emergency/old
	name = "生锈的红色工具箱"
	icon_state = "toolbox_red_old"
	has_latches = FALSE
	material_flags = NONE

/obj/item/storage/toolbox/mechanical
	name = "机械工具箱"
	icon_state = "blue"
	inhand_icon_state = "toolbox_blue"
	material_flags = NONE
	/// If FALSE, someone with a ensouled soulstone can sacrifice a spirit to change the sprite of this toolbox.
	var/has_soul = FALSE

/obj/item/storage/toolbox/mechanical/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/analyzer(src)
	new /obj/item/wirecutters(src)

/obj/item/storage/toolbox/mechanical/old
	name = "生锈的蓝色工具箱"
	icon_state = "toolbox_blue_old"
	has_latches = FALSE
	has_soul = TRUE

/obj/item/storage/toolbox/mechanical/old/heirloom
	name = "工具箱" //this will be named "X family toolbox"
	desc = "它曾有过辉煌的日子."
	force = 5
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/toolbox/mechanical/old/heirloom/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL

/obj/item/storage/toolbox/mechanical/old/heirloom/PopulateContents()
	return

/obj/item/storage/toolbox/mechanical/old/clean // the assistant traitor toolbox, damage scales with TC inside
	name = "工具箱"
	desc = "一个旧的蓝色工具箱，看起来很结实."
	icon_state = "oldtoolboxclean"
	inhand_icon_state = "toolbox_blue"
	has_latches = FALSE
	force = 19
	throwforce = 22

/obj/item/storage/toolbox/mechanical/old/clean/proc/calc_damage()
	var/power = 0
	for (var/obj/item/stack/telecrystal/stored_crystals in get_all_contents())
		power += (stored_crystals.amount / 2)
	force = 19 + power
	throwforce = 22 + power

/obj/item/storage/toolbox/mechanical/old/clean/attack(mob/target, mob/living/user)
	calc_damage()
	..()

/obj/item/storage/toolbox/mechanical/old/clean/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	calc_damage()
	..()

/obj/item/storage/toolbox/mechanical/old/clean/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)
	new /obj/item/clothing/gloves/color/yellow(src)

/obj/item/storage/toolbox/electrical
	name = "电力工具箱"
	icon_state = "yellow"
	inhand_icon_state = "toolbox_yellow"
	material_flags = NONE

/obj/item/storage/toolbox/electrical/PopulateContents()
	var/pickedcolor = pick(GLOB.cable_colors)
	new /obj/item/screwdriver(src)
	new /obj/item/wirecutters(src)
	new /obj/item/t_scanner(src)
	new /obj/item/crowbar(src)
	var/obj/item/stack/cable_coil/new_cable_one = new(src, MAXCOIL)
	new_cable_one.set_cable_color(pickedcolor)
	var/obj/item/stack/cable_coil/new_cable_two = new(src, MAXCOIL)
	new_cable_two.set_cable_color(pickedcolor)
	if(prob(5))
		new /obj/item/clothing/gloves/color/yellow(src)
	else
		var/obj/item/stack/cable_coil/new_cable_three = new(src, MAXCOIL)
		new_cable_three.set_cable_color(pickedcolor)

/obj/item/storage/toolbox/syndicate
	name = "战术工具箱" //SKYRAT EDIT
	icon_state = "syndicate"
	inhand_icon_state = "toolbox_syndi"
	force = 15
	throwforce = 18
	material_flags = NONE
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // Skyrat edit
	special_desc = "辛迪加制造的工具箱，里面有额外的战术工具；用比一般工具箱更坚固的材料制成." // Skyrat edit

/obj/item/storage/toolbox/syndicate/Initialize(mapload)
	. = ..()
	atom_storage.silent = TRUE

/obj/item/storage/toolbox/syndicate/PopulateContents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/crowbar/red(src)
	new /obj/item/wirecutters(src, "red")
	new /obj/item/multitool(src)
	new /obj/item/clothing/gloves/combat(src)

/obj/item/storage/toolbox/drone
	name = "机械工具箱"
	icon_state = "blue"
	inhand_icon_state = "toolbox_blue"
	material_flags = NONE

/obj/item/storage/toolbox/drone/PopulateContents()
	var/pickedcolor = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src,MAXCOIL,pickedcolor)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)

/obj/item/storage/toolbox/artistic
	name = "艺术工具箱"
	desc = "一个漆成亮绿色的工具箱，你不明白为什么有人能把美术用品放在工具箱里，但它有足够的额外空间."
	icon_state = "green"
	inhand_icon_state = "artistic_toolbox"
	w_class = WEIGHT_CLASS_GIGANTIC //Holds more than a regular toolbox!
	material_flags = NONE

/obj/item/storage/toolbox/artistic/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 20
	atom_storage.max_slots = 11

/obj/item/storage/toolbox/artistic/PopulateContents()
	new /obj/item/storage/crayons(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/pipe_cleaner_coil/red(src)
	new /obj/item/stack/pipe_cleaner_coil/yellow(src)
	new /obj/item/stack/pipe_cleaner_coil/blue(src)
	new /obj/item/stack/pipe_cleaner_coil/green(src)
	new /obj/item/stack/pipe_cleaner_coil/pink(src)
	new /obj/item/stack/pipe_cleaner_coil/orange(src)
	new /obj/item/stack/pipe_cleaner_coil/cyan(src)
	new /obj/item/stack/pipe_cleaner_coil/white(src)
	new /obj/item/stack/pipe_cleaner_coil/brown(src)

/obj/item/storage/toolbox/ammobox
	name = "弹药筒"
	desc = "设计用来装弹药的金属筒."
	icon_state = "ammobox"
	inhand_icon_state = "ammobox"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	has_latches = FALSE
	drop_sound = 'sound/items/handling/ammobox_drop.ogg'
	pickup_sound = 'sound/items/handling/ammobox_pickup.ogg'
	var/ammo_to_spawn

/obj/item/storage/toolbox/ammobox/PopulateContents()
	if(!isnull(ammo_to_spawn))
		for(var/i in 1 to 6)
			new ammo_to_spawn(src)

/obj/item/storage/toolbox/ammobox/strilka310
	name = ".310 Strilka 弹药箱 (存货?)"
	desc = "它包含几个弹匣. 啊, 闻起来真糟糕. \
		这东西在仓库里放了几个世纪了吗?"
	ammo_to_spawn = /obj/item/ammo_box/strilka310

/obj/item/storage/toolbox/ammobox/strilka310/surplus
	ammo_to_spawn = /obj/item/ammo_box/strilka310/surplus

/obj/item/storage/toolbox/ammobox/wt550m9
	name = "4.6x30mm 弹药箱"
	ammo_to_spawn = /obj/item/ammo_box/magazine/wt550m9

/obj/item/storage/toolbox/ammobox/wt550m9ap
	name = "4.6x30mm AP 弹药箱"
	ammo_to_spawn = /obj/item/ammo_box/magazine/wt550m9/wtap

/obj/item/storage/toolbox/maint_kit
	name = "枪械维护包"
	desc = "里面有一些枪支维修用品."
	icon_state = "maint_kit"
	inhand_icon_state = "ammobox"
	has_latches = FALSE
	drop_sound = 'sound/items/handling/ammobox_drop.ogg'
	pickup_sound = 'sound/items/handling/ammobox_pickup.ogg'

/obj/item/storage/toolbox/maint_kit/PopulateContents()
	new /obj/item/gun_maintenance_supplies(src)
	new /obj/item/gun_maintenance_supplies(src)
	new /obj/item/gun_maintenance_supplies(src)

//floorbot assembly
/obj/item/storage/toolbox/attackby(obj/item/stack/tile/iron/T, mob/user, params)
	var/list/allowed_toolbox = list(/obj/item/storage/toolbox/emergency, //which toolboxes can be made into floorbots
							/obj/item/storage/toolbox/electrical,
							/obj/item/storage/toolbox/mechanical,
							/obj/item/storage/toolbox/artistic,
							/obj/item/storage/toolbox/syndicate)

	if(!istype(T, /obj/item/stack/tile/iron))
		..()
		return
	if(!is_type_in_list(src, allowed_toolbox) && (type != /obj/item/storage/toolbox))
		return
	if(contents.len >= 1)
		balloon_alert(user, "不是空的!")
		return
	if(T.use(10))
		var/obj/item/bot_assembly/floorbot/B = new
		B.toolbox = type
		switch(B.toolbox)
			if(/obj/item/storage/toolbox)
				B.toolbox_color = "r"
			if(/obj/item/storage/toolbox/emergency)
				B.toolbox_color = "r"
			if(/obj/item/storage/toolbox/electrical)
				B.toolbox_color = "y"
			if(/obj/item/storage/toolbox/artistic)
				B.toolbox_color = "g"
			if(/obj/item/storage/toolbox/syndicate)
				B.toolbox_color = "s"
		user.put_in_hands(B)
		B.update_appearance()
		B.balloon_alert(user, "tiles added")
		qdel(src)
	else
		balloon_alert(user, "needs 10 tiles!")
		return

/obj/item/storage/toolbox/haunted
	name = "old toolbox"
	custom_materials = list(/datum/material/hauntium = SMALL_MATERIAL_AMOUNT*5)

/obj/item/storage/toolbox/guncase
	name = "枪箱"
	desc = "一个武器箱，封面上有一个血红色的“S”."
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "infiltrator_case"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	inhand_icon_state = "infiltrator_case"
	has_latches = FALSE
	var/weapon_to_spawn = /obj/item/gun/ballistic/automatic/pistol
	var/extra_to_spawn = /obj/item/ammo_box/magazine/m9mm

/obj/item/storage/toolbox/guncase/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.max_total_storage = 7 //enough to hold ONE bulky gun and the ammo boxes
	atom_storage.max_slots = 4

/obj/item/storage/toolbox/guncase/PopulateContents()
	new weapon_to_spawn (src)
	for(var/i in 1 to 3)
		new extra_to_spawn (src)

/obj/item/storage/toolbox/guncase/bulldog
	name = "斗牛犬枪箱"
	weapon_to_spawn = /obj/item/gun/ballistic/shotgun/bulldog
	extra_to_spawn = /obj/item/ammo_box/magazine/m12g

/obj/item/storage/toolbox/guncase/c20r
	name = "c-20r 枪箱"
	weapon_to_spawn = /obj/item/gun/ballistic/automatic/c20r
	extra_to_spawn = /obj/item/ammo_box/magazine/smgm45

/obj/item/storage/toolbox/guncase/clandestine
	name = "秘密枪箱"
	weapon_to_spawn = /obj/item/gun/ballistic/automatic/pistol/clandestine
	extra_to_spawn = /obj/item/ammo_box/magazine/m10mm

/obj/item/storage/toolbox/guncase/m90gl
	name = "m-90gl 枪箱"
	weapon_to_spawn = /obj/item/gun/ballistic/automatic/m90
	extra_to_spawn = /obj/item/ammo_box/magazine/m223

/obj/item/storage/toolbox/guncase/m90gl/PopulateContents()
	new weapon_to_spawn (src)
	for(var/i in 1 to 2)
		new extra_to_spawn (src)
	new /obj/item/ammo_box/a40mm/rubber (src)

/obj/item/storage/toolbox/guncase/rocketlauncher
	name = "火箭发射器箱"
	weapon_to_spawn = /obj/item/gun/ballistic/rocketlauncher
	extra_to_spawn = /obj/item/ammo_box/rocket

/obj/item/storage/toolbox/guncase/rocketlauncher/PopulateContents()
	new weapon_to_spawn (src)
	new extra_to_spawn (src)

/obj/item/storage/toolbox/guncase/revolver
	name = "左轮枪箱"
	weapon_to_spawn = /obj/item/gun/ballistic/revolver/syndicate/nuclear
	extra_to_spawn = /obj/item/ammo_box/a357

/obj/item/storage/toolbox/guncase/sword_and_board
	name = "激光剑盾武器箱"
	weapon_to_spawn = /obj/item/melee/energy/sword
	extra_to_spawn = /obj/item/shield/energy

/obj/item/storage/toolbox/guncase/sword_and_board/PopulateContents()
	new weapon_to_spawn (src)
	new extra_to_spawn (src)
	new /obj/item/clothing/head/costume/knight (src)

/obj/item/storage/toolbox/guncase/cqc
	name = "CQC装备箱"
	weapon_to_spawn = /obj/item/book/granter/martial/cqc
	extra_to_spawn = /obj/item/storage/box/syndie_kit/imp_stealth

/obj/item/storage/toolbox/guncase/cqc/PopulateContents()
	new weapon_to_spawn (src)
	new extra_to_spawn (src)
	new /obj/item/clothing/head/costume/snakeeater (src)
	new /obj/item/storage/fancy/cigarettes/cigpack_syndicate (src)

/obj/item/clothing/head/costume/snakeeater
	name = "奇怪的头巾"
	desc = "一个头巾. 上面绣了一条小鲤鱼, 还有汉字 '魚'."
	icon_state = "snake_eater"
	inhand_icon_state = null

/obj/item/clothing/head/costume/knight
	name = "玩具中世纪头盔"
	desc = "一个经典的金属头盔，不过，这个看起来很明显是假的..."
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "knight_green"
	inhand_icon_state = "knight_helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	dog_fashion = null

/obj/item/storage/toolbox/guncase/doublesword
	name = "双刃激光武器箱"
	weapon_to_spawn = /obj/item/dualsaber
	extra_to_spawn = /obj/item/soap/syndie

/obj/item/storage/toolbox/guncase/doublesword/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.max_total_storage = 10 //it'll hold enough
	atom_storage.max_slots = 5

/obj/item/storage/toolbox/guncase/doublesword/PopulateContents()
	new weapon_to_spawn (src)
	new extra_to_spawn (src)
	new /obj/item/mod/module/noslip (src)
	new /obj/item/reagent_containers/hypospray/medipen/methamphetamine (src)
	new /obj/item/clothing/under/rank/prisoner/nosensor (src)

/obj/item/storage/toolbox/guncase/soviet
	name = "古代枪箱"
	desc = "一个武器箱，侧面有第三苏联的标志."
	icon_state = "sakhno_case"
	inhand_icon_state = "sakhno_case"
	weapon_to_spawn = /obj/effect/spawner/random/sakhno
	extra_to_spawn = /obj/effect/spawner/random/sakhno/ammo

/obj/item/storage/toolbox/guncase/soviet/plastikov
	name = "古代盈余枪箱"
	desc = "一个武器箱，侧面有第三苏联的标志."
	weapon_to_spawn = /obj/item/gun/ballistic/automatic/plastikov
	extra_to_spawn = /obj/item/food/rationpack //sorry comrade, cannot get you more ammo, here, have lunch

/obj/item/storage/toolbox/guncase/monkeycase
	name = "猴子枪箱"
	desc = "所有猴子需要的东西，箱子前面有个爪子锁。"

/obj/item/storage/toolbox/guncase/monkeycase/Initialize(mapload)
	. = ..()
	atom_storage.locked = STORAGE_SOFT_LOCKED

/obj/item/storage/toolbox/guncase/monkeycase/attack_self(mob/user, modifiers)
	if(!monkey_check(user))
		return
	return ..()

/obj/item/storage/toolbox/guncase/monkeycase/attack_self_secondary(mob/user, modifiers)
	attack_self(user, modifiers)
	return

/obj/item/storage/toolbox/guncase/monkeycase/attack_hand(mob/user, list/modifiers)
	if(!monkey_check(user))
		return
	return ..()

/obj/item/storage/toolbox/guncase/monkeycase/proc/monkey_check(mob/user)
	if(atom_storage.locked == STORAGE_NOT_LOCKED)
		return TRUE

	if(is_simian(user))
		atom_storage.locked = STORAGE_NOT_LOCKED
		to_chat(user, span_notice("你把你的爪子放在爪子扫描器上，听到[src]解锁的一声轻响!"))
		playsound(src, 'sound/items/click.ogg', 25, TRUE)
		return TRUE
	to_chat(user, span_warning("你把你的手放在手扫描仪上，它用愤怒的黑猩猩尖叫拒绝你!"))
	playsound(src, "sound/creatures/monkey/monkey_screech_[rand(1,7)].ogg", 75, TRUE)
	return FALSE

/obj/item/storage/toolbox/guncase/monkeycase/PopulateContents()
	switch(rand(1, 3))
		if(1)
			// Uzi with a boxcutter.
			new /obj/item/gun/ballistic/automatic/mini_uzi/chimpgun(src)
			new /obj/item/ammo_box/magazine/uzim9mm(src)
			new /obj/item/ammo_box/magazine/uzim9mm(src)
			new /obj/item/boxcutter/extended(src)
		if(2)
			// Thompson with a boxcutter.
			new /obj/item/gun/ballistic/automatic/tommygun/chimpgun(src)
			new /obj/item/ammo_box/magazine/tommygunm45(src)
			new /obj/item/ammo_box/magazine/tommygunm45(src)
			new /obj/item/boxcutter/extended(src)
		if(3)
			// M1911 with a switchblade and an extra banana bomb.
			new /obj/item/gun/ballistic/automatic/pistol/m1911/chimpgun(src)
			new /obj/item/ammo_box/magazine/m45(src)
			new /obj/item/ammo_box/magazine/m45(src)
			new /obj/item/switchblade/extended(src)
			new /obj/item/food/grown/banana/bunch/monkeybomb(src)

	// Banana bomb! Basically a tiny flashbang for monkeys.
	new /obj/item/food/grown/banana/bunch/monkeybomb(src)
	// Somewhere to store it all.
	new /obj/item/storage/backpack/messenger(src)
