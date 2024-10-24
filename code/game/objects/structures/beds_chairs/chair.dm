/obj/structure/chair
	name = "椅子"
	desc = "你坐在这上面. 不管是自愿还是被迫的."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "chair"
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 0 //you sit in a chair, not lay
	resistance_flags = NONE
	max_integrity = 250
	integrity_failure = 0.1
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT)
	layer = OBJ_LAYER
	interaction_flags_mouse_drop = ALLOW_RESTING

	var/buildstacktype = /obj/item/stack/sheet/iron
	var/buildstackamount = 1
	var/item_chair = /obj/item/chair // if null it can't be picked up


/obj/structure/chair/examine(mob/user)
	. = ..()
	. += span_notice("它由几个<b>螺栓</b>固定在一起.")
	if(!has_buckled_mobs() && can_buckle)
		. += span_notice("站在 [src] 上时, 将你的贴图拖拽到 [src] 上来将自己扣在上面.")

/obj/structure/chair/Initialize(mapload)
	. = ..()
	if(prob(0.2))
		name = "战术 [name]"
	MakeRotate()

///This proc adds the rotate component, overwrite this if you for some reason want to change some specific args.
/obj/structure/chair/proc/MakeRotate()
	AddComponent(/datum/component/simple_rotation, ROTATION_IGNORE_ANCHORED|ROTATION_GHOSTS_ALLOWED)

/obj/structure/chair/Destroy()
	SSjob.latejoin_trackers -= src //These may be here due to the arrivals shuttle
	return ..()

/obj/structure/chair/atom_deconstruct(disassembled)
	if(buildstacktype)
		new buildstacktype(loc,buildstackamount)
	else
		for(var/datum/material/mat as anything in custom_materials)
			new mat.sheet_type(loc, FLOOR(custom_materials[mat] / SHEET_MATERIAL_AMOUNT, 1))

/obj/structure/chair/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/chair/narsie_act()
	var/obj/structure/chair/wood/W = new/obj/structure/chair/wood(get_turf(src))
	W.setDir(dir)
	qdel(src)

/obj/structure/chair/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/assembly/shock_kit) && !HAS_TRAIT(src, TRAIT_ELECTRIFIED_BUCKLE))
		electrify_self(W, user)
		return
	. = ..()


///allows each chair to request the electrified_buckle component with overlays that dont look ridiculous
/obj/structure/chair/proc/electrify_self(obj/item/assembly/shock_kit/input_shock_kit, mob/user, list/overlays_from_child_procs)
	SHOULD_CALL_PARENT(TRUE)
	if(!user.temporarilyRemoveItemFromInventory(input_shock_kit))
		return
	if(!overlays_from_child_procs || overlays_from_child_procs.len == 0)
		var/image/echair_over_overlay = image('icons/obj/chairs.dmi', loc, "echair_over")
		AddComponent(/datum/component/electrified_buckle, (SHOCK_REQUIREMENT_ITEM | SHOCK_REQUIREMENT_LIVE_CABLE | SHOCK_REQUIREMENT_SIGNAL_RECEIVED_TOGGLE), input_shock_kit, list(echair_over_overlay), FALSE)
	else
		AddComponent(/datum/component/electrified_buckle, (SHOCK_REQUIREMENT_ITEM | SHOCK_REQUIREMENT_LIVE_CABLE | SHOCK_REQUIREMENT_SIGNAL_RECEIVED_TOGGLE), input_shock_kit, overlays_from_child_procs, FALSE)

	if(HAS_TRAIT(src, TRAIT_ELECTRIFIED_BUCKLE))
		to_chat(user, span_notice("你将电击背包连接到了 [name], 并通上了电."))
	else
		user.put_in_active_hand(input_shock_kit)
		to_chat(user, "<span class='notice'> 你无法将电击背包安装到 [name]!")


/obj/structure/chair/wrench_act_secondary(mob/living/user, obj/item/weapon)
	..()
	weapon.play_tool_sound(src)
	deconstruct(disassembled = TRUE)
	return TRUE

/obj/structure/chair/attack_tk(mob/user)
	if(!anchored || has_buckled_mobs() || !isturf(user.loc))
		return ..()
	setDir(turn(dir,-90))
	return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/structure/chair/proc/handle_rotation(direction)
	handle_layer()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.setDir(direction)

/obj/structure/chair/proc/handle_layer()
	if(has_buckled_mobs() && dir == NORTH)
		layer = ABOVE_MOB_LAYER
	else
		layer = OBJ_LAYER

/obj/structure/chair/post_buckle_mob(mob/living/M)
	. = ..()
	handle_layer()
	//SKYRAT EDIT ADDITION
	if(HAS_TRAIT(M, TRAIT_OVERSIZED))
		visible_message(span_warning("[src] 被 [M] 的重量所压弯, 导致其最终断裂了!"))
		playsound(src, 'modular_skyrat/modules/oversized/sound/chair_break.ogg', 70, TRUE)
		deconstruct()
	//SKYRAT EDIT END
/obj/structure/chair/post_unbuckle_mob()
	. = ..()
	handle_layer()

/obj/structure/chair/setDir(newdir)
	..()
	handle_rotation(newdir)

// Chair types

///Material chair
/obj/structure/chair/greyscale
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	item_chair = /obj/item/chair/greyscale
	buildstacktype = null //Custom mats handle this


/obj/structure/chair/wood
	icon_state = "wooden_chair"
	name = "木椅子"
	desc = "无论它有多老也不会老到不流行."
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 3
	item_chair = /obj/item/chair/wood

/obj/structure/chair/wood/narsie_act()
	return

/obj/structure/chair/wood/wings
	icon_state = "wooden_chair_wings"
	item_chair = /obj/item/chair/wood/wings

/obj/structure/chair/comfy
	name = "康乐椅"
	desc = "看起来很舒适."
	icon_state = "comfychair"
	color = rgb(255, 255, 255)
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstackamount = 2
	item_chair = null
	// The mutable appearance used for the overlay over buckled mobs.
	var/mutable_appearance/armrest

/obj/structure/chair/comfy/Initialize(mapload)
	gen_armrest()
	return ..()

/obj/structure/chair/comfy/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents)
	if(same_z_layer)
		return ..()
	cut_overlay(armrest)
	QDEL_NULL(armrest)
	gen_armrest()
	return ..()

/obj/structure/chair/comfy/proc/gen_armrest()
	armrest = GetArmrest()
	armrest.layer = ABOVE_MOB_LAYER
	update_armrest()

/obj/structure/chair/comfy/proc/GetArmrest()
	return mutable_appearance(icon, "[icon_state]_armrest")

/obj/structure/chair/comfy/Destroy()
	QDEL_NULL(armrest)
	return ..()

/obj/structure/chair/comfy/post_buckle_mob(mob/living/M)
	. = ..()
	update_armrest()

/obj/structure/chair/comfy/proc/update_armrest()
	if(has_buckled_mobs())
		add_overlay(armrest)
	else
		cut_overlay(armrest)

/obj/structure/chair/comfy/post_unbuckle_mob()
	. = ..()
	update_armrest()

/obj/structure/chair/comfy/brown
	color = rgb(70, 47, 28)

/obj/structure/chair/comfy/beige
	color = rgb(240, 238, 198)

/obj/structure/chair/comfy/teal
	color = rgb(117, 214, 214)

/obj/structure/chair/comfy/black
	color = rgb(61, 60, 56)

/obj/structure/chair/comfy/lime
	color = rgb(193, 248, 104)

/obj/structure/chair/comfy/shuttle
	name = "太空穿梭机椅"
	desc = "一个舒适, 安全的座椅. 拥有一个更牢固的安全带系统, 带来更舒适的飞行体验."
	icon_state = "shuttle_chair"
	buildstacktype = /obj/item/stack/sheet/mineral/titanium

/obj/structure/chair/comfy/shuttle/electrify_self(obj/item/assembly/shock_kit/input_shock_kit, mob/user, list/overlays_from_child_procs)
	if(!overlays_from_child_procs)
		overlays_from_child_procs = list(image('icons/obj/chairs.dmi', loc, "echair_over", pixel_x = -1))
	. = ..()

/obj/structure/chair/comfy/shuttle/tactical
	name = "战术椅"

/obj/structure/chair/comfy/carp
	name = "鲤鱼皮椅"
	desc = "一把豪华的椅子, 上面的紫色鳞片用一种很舒适的方式反射着光线. "
	icon_state = "carp_chair"
	buildstacktype = /obj/item/stack/sheet/animalhide/carp

/obj/structure/chair/office
	anchored = FALSE
	buildstackamount = 5
	item_chair = null
	icon_state = "officechair_dark"

/obj/structure/chair/office/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noisy_movement)

/obj/structure/chair/office/electrify_self(obj/item/assembly/shock_kit/input_shock_kit, mob/user, list/overlays_from_child_procs)
	if(!overlays_from_child_procs)
		overlays_from_child_procs = list(image('icons/obj/chairs.dmi', loc, "echair_over", pixel_x = -1))
	. = ..()

/obj/structure/chair/office/tactical
	name = "战术转椅"

/obj/structure/chair/office/light
	icon_state = "officechair_white"

//Stool

/obj/structure/chair/stool
	name = "凳子"
	desc = "对他使用你的屁股."
	icon_state = "stool"
	can_buckle = FALSE
	buildstackamount = 1
	item_chair = /obj/item/chair/stool

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/chair/stool, 0)

/obj/structure/chair/stool/narsie_act()
	return

/obj/structure/chair/mouse_drop_dragged(atom/over_object, mob/user, src_location, over_location, params)
	if(over_object == user)
		if(!item_chair || has_buckled_mobs())
			return
		user.visible_message(span_notice("[user] grabs \the [src.name]."), span_notice("You grab \the [src.name]."))
		var/obj/item/C = new item_chair(loc)
		C.set_custom_materials(custom_materials)
		TransferComponents(C)
		user.put_in_hands(C)
		qdel(src)

/obj/structure/chair/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return ..()

/obj/structure/chair/stool/bar
	name = "酒吧高脚凳"
	desc = "上面有一些令人讨厌的污渍..."
	icon_state = "bar"
	item_chair = /obj/item/chair/stool/bar

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/chair/stool/bar, 0)

/obj/structure/chair/stool/bamboo
	name = "竹凳子"
	desc = "一把临时拼凑出来的竹凳子, 看起来带有一点乡村气息."
	icon_state = "bamboo_stool"
	resistance_flags = FLAMMABLE
	max_integrity = 60
	buildstacktype = /obj/item/stack/sheet/mineral/bamboo
	buildstackamount = 2
	item_chair = /obj/item/chair/stool/bamboo

/obj/item/chair
	name = "椅子"
	desc = "酒吧斗殴的利器."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "chair_toppled"
	inhand_icon_state = "chair"
	lefthand_file = 'icons/mob/inhands/items/chairs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/chairs_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 8
	throwforce = 10
	demolition_mod = 1.25
	throw_range = 3
	hitsound = 'sound/items/trayhit1.ogg'
	hit_reaction_chance = 50
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT)
	item_flags = SKIP_FANTASY_ON_SPAWN
	var/break_chance = 5 //Likely hood of smashing the chair.
	var/obj/structure/chair/origin_type = /obj/structure/chair

/obj/item/chair/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] 开始用\the [src] 殴打[user.p_them()] ! 看起来 [user.p_theyre()] 在试着自杀!"))
	playsound(src,hitsound,50,TRUE)
	return BRUTELOSS

/obj/item/chair/narsie_act()
	var/obj/item/chair/wood/W = new/obj/item/chair/wood(get_turf(src))
	W.setDir(dir)
	qdel(src)

/obj/item/chair/attack_self(mob/user)
	plant(user)

/obj/item/chair/proc/plant(mob/user)
	var/turf/T = get_turf(loc)
	if(isgroundlessturf(T))
		to_chat(user, span_warning("你需要足够的空间来放下它!"))
		return
	for(var/obj/A in T)
		if(istype(A, /obj/structure/chair))
			to_chat(user, span_warning("这里已经放了一把椅子了!"))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(user, span_warning("这里已经放了别的东西了!"))
			return

	user.visible_message(span_notice("[user] 扶正了 \the [src.name]."), span_notice("你扶正了 \the [name]."))
	var/obj/structure/chair/C = new origin_type(get_turf(loc))
	C.set_custom_materials(custom_materials)
	TransferComponents(C)
	C.setDir(user.dir)
	qdel(src)

/obj/item/chair/proc/smash(mob/living/user)
	var/stack_type = initial(origin_type.buildstacktype)
	if(!stack_type)
		return
	var/remaining_mats = initial(origin_type.buildstackamount)
	remaining_mats-- //Part of the chair was rendered completely unusable. It magically dissapears. Maybe make some dirt?
	if(remaining_mats)
		for(var/M=1 to remaining_mats)
			new stack_type(get_turf(loc))
	else if(custom_materials[GET_MATERIAL_REF(/datum/material/iron)])
		new /obj/item/stack/rods(get_turf(loc), 2)
	qdel(src)

/obj/item/chair/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == UNARMED_ATTACK && prob(hit_reaction_chance) || attack_type == LEAP_ATTACK && prob(hit_reaction_chance))
		owner.visible_message(span_danger("[owner] 用 [src] 挡开了 [attack_text]!"))
		return TRUE
	return FALSE

/obj/item/chair/afterattack(atom/target, mob/user, click_parameters)
	if(!prob(break_chance))
		return
	user.visible_message(span_danger("[user] 用 [src] 猛击 [target], 将[src]砸成了碎片! "))
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(C.health < C.maxHealth*0.5)
			C.Paralyze(20)
	smash(user)

/obj/item/chair/greyscale
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	origin_type = /obj/structure/chair/greyscale

/obj/item/chair/stool
	name = "凳子"
	icon_state = "stool_toppled"
	inhand_icon_state = "stool"
	origin_type = /obj/structure/chair/stool
	break_chance = 0 //It's too sturdy.

/obj/item/chair/stool/bar
	name = "酒吧高脚凳"
	icon_state = "bar_toppled"
	inhand_icon_state = "stool_bar"
	origin_type = /obj/structure/chair/stool/bar

/obj/item/chair/stool/bamboo
	name = "竹凳子"
	icon_state = "bamboo_stool"
	inhand_icon_state = "stool_bamboo"
	hitsound = 'sound/weapons/genhit1.ogg'
	origin_type = /obj/structure/chair/stool/bamboo
	break_chance = 50	//Submissive and breakable unlike the chad iron stool

/obj/item/chair/stool/narsie_act()
	return //sturdy enough to ignore a god

/obj/item/chair/wood
	name = "木椅子"
	icon_state = "wooden_chair_toppled"
	inhand_icon_state = "woodenchair"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	hitsound = 'sound/weapons/genhit1.ogg'
	origin_type = /obj/structure/chair/wood
	custom_materials = null
	break_chance = 50

/obj/item/chair/wood/narsie_act()
	return

/obj/item/chair/wood/wings
	icon_state = "wooden_chair_wings_toppled"
	origin_type = /obj/structure/chair/wood/wings

/obj/structure/chair/old
	name = "奇怪的椅子"
	desc = "你坐在这上面, 不管是被迫的还是自愿的. 看起来 非常 不舒服."
	icon_state = "chairold"
	item_chair = null

/obj/structure/chair/bronze
	name = "黄铜椅子"
	desc = "一把用青铜制作的转来转去的椅子. 它上面有一些小齿轮方便旋转!"
	anchored = FALSE
	icon_state = "brass_chair"
	buildstacktype = /obj/item/stack/sheet/bronze
	buildstackamount = 1
	item_chair = null
	/// Total rotations made
	var/turns = 0

/obj/structure/chair/bronze/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noisy_movement, 'sound/machines/clockcult/integration_cog_install.ogg', 50)

/obj/structure/chair/bronze/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	. = ..()

/obj/structure/chair/bronze/process()
	setDir(turn(dir,-90))
	playsound(src, 'sound/effects/servostep.ogg', 50, FALSE)
	turns++
	if(turns >= 8)
		STOP_PROCESSING(SSfastprocess, src)

/obj/structure/chair/bronze/click_alt(mob/user)
	turns = 0
	if(!(datum_flags & DF_ISPROCESSING))
		user.visible_message(span_notice("[user] 将 [src] 转来转去, Ratvarian的科技在这世上留下的最后一丝痕迹让它保持转动, 直到永远."), \
		span_notice("会自动旋转的椅子. 远古Ratvarian科技的巅峰之作."))
		START_PROCESSING(SSfastprocess, src)
	else
		user.visible_message(span_notice("[user] 停下了 [src]的不可操控的旋转."), \
		span_notice("你抓住了 [src] 并停下了它疯狂的旋转."))
		STOP_PROCESSING(SSfastprocess, src)
	return CLICK_ACTION_SUCCESS

/obj/structure/chair/mime
	name = "隐形椅子"
	desc = "默剧需要坐在这上面, 并闭上他的嘴."
	anchored = FALSE
	icon_state = null
	buildstacktype = null
	item_chair = null
	obj_flags = parent_type::obj_flags | NO_DEBRIS_AFTER_DECONSTRUCTION
	alpha = 0

/obj/structure/chair/mime/wrench_act_secondary(mob/living/user, obj/item/weapon)
	return NONE

/obj/structure/chair/mime/post_buckle_mob(mob/living/M)
	M.pixel_y += 5

/obj/structure/chair/mime/post_unbuckle_mob(mob/living/M)
	M.pixel_y -= 5


/obj/structure/chair/plastic
	icon_state = "塑料椅子"
	name = "folding plastic chair"
	desc = "不管你如何改变坐姿, 它依然坐起来不舒服."
	resistance_flags = FLAMMABLE
	max_integrity = 50
	custom_materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	buildstacktype = /obj/item/stack/sheet/plastic
	buildstackamount = 2
	item_chair = /obj/item/chair/plastic

/obj/structure/chair/plastic/post_buckle_mob(mob/living/Mob)
	Mob.pixel_y += 2
	.=..()
	if(iscarbon(Mob))
		INVOKE_ASYNC(src, PROC_REF(snap_check), Mob)

/obj/structure/chair/plastic/post_unbuckle_mob(mob/living/Mob)
	Mob.pixel_y -= 2

/obj/structure/chair/plastic/proc/snap_check(mob/living/carbon/Mob)
	if (Mob.nutrition >= NUTRITION_LEVEL_FAT)
		to_chat(Mob, span_warning("椅子开始发出嘎吱声并断裂, 你太重了!"))
		if(do_after(Mob, 6 SECONDS, progress = FALSE))
			Mob.visible_message(span_notice("塑料椅子在 [Mob] 的重量下折断了!"))
			new /obj/effect/decal/cleanable/plastic(loc)
			qdel(src)

/obj/item/chair/plastic
	name = "折起来的塑料椅子"
	desc = "不知为何, 你总能在摔跤场下面找到一个."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "folded_chair"
	inhand_icon_state = "folded_chair"
	lefthand_file = 'icons/mob/inhands/items/chairs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/chairs_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 7
	throw_range = 5 //Lighter Weight --> Flies Farther.
	custom_materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	break_chance = 25
	origin_type = /obj/structure/chair/plastic

/obj/structure/chair/musical
	name = "音乐椅子"
	desc = "你听着这个. 不管是被迫的还是自愿的."
	item_chair = /obj/item/chair/musical
	particles = new /particles/musical_notes

/obj/item/chair/musical
	name = "音乐椅子"
	desc = "哦, 所以这就像是一团糟的大富翁游戏, 完全没有规则, 你可以随意捡起或放下音乐椅子, 太妙了."
	particles = new /particles/musical_notes
	origin_type = /obj/structure/chair/musical
