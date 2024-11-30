
#define ROBOTIC_LIGHT_BRUTE_MSG "损伤的"
#define ROBOTIC_MEDIUM_BRUTE_MSG "凹陷的"
#define ROBOTIC_HEAVY_BRUTE_MSG "散架的"

#define ROBOTIC_LIGHT_BURN_MSG "烧黑的"
#define ROBOTIC_MEDIUM_BURN_MSG "烧焦的"
#define ROBOTIC_HEAVY_BURN_MSG "烧毁的"

//For ye whom may venture here, split up arm / hand sprites are formatted as "l_hand" & "l_arm".
//The complete sprite (displayed when the limb is on the ground) should be named "borg_l_arm".
//Failure to follow this pattern will cause the hand's icons to be missing due to the way get_limb_icon() works to generate the mob's icons using the aux_zone var.

/obj/item/bodypart/arm/left/robot
	name = "赛博左臂"
	desc = "被伪肌肉包裹的骨骼状肢体，外加低导电性外壳."
	limb_id = BODYPART_ID_ROBOTIC
	attack_verb_simple = list("用巴掌扇", "用拳头揍")
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	icon_static = 'icons/mob/augmentation/augments.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "borg_l_arm"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	disabling_threshold_percentage = 1
	bodypart_flags = BODYPART_UNHUSKABLE

/obj/item/bodypart/arm/right/robot
	name = "赛博右臂"
	desc = "被伪肌肉包裹的骨骼状肢体，外加低导电性外壳."
	attack_verb_simple = list("用巴掌扇", "用拳头揍")
	inhand_icon_state = "buildpipe"
	icon_static = 'icons/mob/augmentation/augments.dmi'
	icon = 'icons/mob/augmentation/augments.dmi'
	limb_id = BODYPART_ID_ROBOTIC
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "borg_r_arm"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	disabling_threshold_percentage = 1

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	bodypart_flags = BODYPART_UNHUSKABLE

/obj/item/bodypart/leg/left/robot
	name = "赛博左腿"
	desc = "一个被伪肌肉包裹的骨骼状肢体，外面覆有一层低导电性的外壳."
	attack_verb_simple = list("踢", "踹")
	inhand_icon_state = "buildpipe"
	icon_static = 'icons/mob/augmentation/augments.dmi'
	icon = 'icons/mob/augmentation/augments.dmi'
	limb_id = BODYPART_ID_ROBOTIC
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "borg_l_leg"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	disabling_threshold_percentage = 1

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	bodypart_flags = BODYPART_UNHUSKABLE

/obj/item/bodypart/leg/left/robot/emp_effect(severity, protection)
	. = ..()
	if(!. || isnull(owner))
		return

	var/knockdown_time = AUGGED_LEG_EMP_KNOCKDOWN_TIME
	if (severity == EMP_HEAVY)
		knockdown_time *= 2
	owner.Knockdown(knockdown_time)
	if(owner.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB)) // So the message isn't duplicated. If they were stunned beforehand by something else, then the message not showing makes more sense anyways.
		return FALSE
	to_chat(owner, span_danger("你的[plaintext_zone]意外发生故障，导致你摔倒在地!"))
	return

/obj/item/bodypart/leg/right/robot
	name = "赛博右腿"
	desc = "一个被伪肌肉包裹的骨骼状肢体，外面覆有一层低导电性的外壳."
	attack_verb_simple = list("踢", "踹")
	inhand_icon_state = "buildpipe"
	icon_static =  'icons/mob/augmentation/augments.dmi'
	icon = 'icons/mob/augmentation/augments.dmi'
	limb_id = BODYPART_ID_ROBOTIC
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "borg_r_leg"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	disabling_threshold_percentage = 1

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	bodypart_flags = BODYPART_UNHUSKABLE

/obj/item/bodypart/leg/right/robot/emp_effect(severity, protection)
	. = ..()
	if(!. || isnull(owner))
		return

	var/knockdown_time = AUGGED_LEG_EMP_KNOCKDOWN_TIME
	if (severity == EMP_HEAVY)
		knockdown_time *= 2
	owner.Knockdown(knockdown_time)
	if(owner.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB)) // So the message isn't duplicated. If they were stunned beforehand by something else, then the message not showing makes more sense anyways.
		return FALSE
	to_chat(owner, span_danger("你的[plaintext_zone]意外发生故障，导致你摔倒在地!"))
	return

/obj/item/bodypart/chest/robot
	name = "赛博躯干"
	desc = "一个装有机械人逻辑电路板的加固型外壳，内部留有标准电池单元的空间."
	inhand_icon_state = "buildpipe"
	icon_static =  'icons/mob/augmentation/augments.dmi'
	icon = 'icons/mob/augmentation/augments.dmi'
	limb_id = BODYPART_ID_ROBOTIC
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "borg_chest"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	bodypart_flags = BODYPART_UNHUSKABLE

	robotic_emp_paralyze_damage_percent_threshold = 0.6

	wing_types = list(/obj/item/organ/external/wings/functional/robotic)

	var/wired = FALSE
	var/obj/item/stock_parts/cell/cell = null

/obj/item/bodypart/chest/robot/emp_effect(severity, protection)
	. = ..()
	if(!. || isnull(owner))
		return

	var/stun_time = 0
	var/shift_x = 3
	var/shift_y = 0
	var/shake_duration = AUGGED_CHEST_EMP_SHAKE_TIME

	if(severity == EMP_HEAVY)
		stun_time = AUGGED_CHEST_EMP_STUN_TIME

		shift_x = 5
		shift_y = 2

	var/damage_percent_to_max = (get_damage() / max_damage)
	if (stun_time && (damage_percent_to_max >= robotic_emp_paralyze_damage_percent_threshold))
		to_chat(owner, span_danger("你[plaintext_zone]的逻辑电路板暂时失去响应!"))
		owner.Stun(stun_time)
	owner.Shake(pixelshiftx = shift_x, pixelshifty = shift_y, duration = shake_duration)
	return

/obj/item/bodypart/chest/robot/get_cell()
	return cell

/obj/item/bodypart/chest/robot/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == cell)
		cell = null

/obj/item/bodypart/chest/robot/Destroy()
	QDEL_NULL(cell)
	UnregisterSignal(src, COMSIG_BODYPART_ATTACHED)
	return ..()

/obj/item/bodypart/chest/robot/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_BODYPART_ATTACHED, PROC_REF(on_attached))
	RegisterSignal(src, COMSIG_BODYPART_REMOVED, PROC_REF(on_detached))

/obj/item/bodypart/chest/robot/proc/on_attached(obj/item/bodypart/chest/robot/this_bodypart, mob/living/carbon/human/new_owner)
	SIGNAL_HANDLER

	RegisterSignals(new_owner, list(COMSIG_CARBON_POST_ATTACH_LIMB, COMSIG_CARBON_POST_REMOVE_LIMB), PROC_REF(check_limbs))

/obj/item/bodypart/chest/robot/proc/on_detached(obj/item/bodypart/chest/robot/this_bodypart, mob/living/carbon/human/old_owner)
	SIGNAL_HANDLER

	UnregisterSignal(old_owner, list(COMSIG_CARBON_POST_ATTACH_LIMB, COMSIG_CARBON_POST_REMOVE_LIMB))

/obj/item/bodypart/chest/robot/proc/check_limbs()
	SIGNAL_HANDLER

	var/all_robotic = TRUE
	for(var/obj/item/bodypart/part in owner.bodyparts)
		all_robotic = all_robotic && IS_ROBOTIC_LIMB(part)

	if(all_robotic)
		owner.add_traits(list(
			/* SKYRAT EDIT REMOVAL BEGIN - Synths are not immune to temperature
			TRAIT_RESISTCOLD,
			TRAIT_RESISTHEAT,
			SKYRAT EDIT REMOVAL END */
			TRAIT_RESISTLOWPRESSURE,
			TRAIT_RESISTHIGHPRESSURE,
			), AUGMENTATION_TRAIT)
	else
		owner.remove_traits(list(
			/* SKYRAT EDIT REMOVAL BEGIN - Synths are not immune to temperature
			TRAIT_RESISTCOLD,
			TRAIT_RESISTHEAT,
			SKYRAT EDIT REMOVAL END */
			TRAIT_RESISTLOWPRESSURE,
			TRAIT_RESISTHIGHPRESSURE,
			), AUGMENTATION_TRAIT)

/obj/item/bodypart/chest/robot/attackby(obj/item/weapon, mob/user, params)
	if(istype(weapon, /obj/item/stock_parts/cell))
		if(cell)
			to_chat(user, span_warning("你已经插入了一个电池单元!"))
			return
		else
			if(!user.transferItemToLoc(weapon, src))
				return
			cell = weapon
			to_chat(user, span_notice("你插入了电池."))
	else if(istype(weapon, /obj/item/stack/cable_coil))
		if(wired)
			to_chat(user, span_warning("你已经接入了电缆!"))
			return
		var/obj/item/stack/cable_coil/coil = weapon
		if (coil.use(1))
			wired = TRUE
			to_chat(user, span_notice("你接入了电缆."))
		else
			to_chat(user, span_warning("你需要一段电线圈来接线!"))
	else
		return ..()

/obj/item/bodypart/chest/robot/wirecutter_act(mob/living/user, obj/item/cutter)
	. = ..()
	if(!wired)
		return
	. = TRUE
	cutter.play_tool_sound(src)
	to_chat(user, span_notice("你已从[src]中剪断了电缆."))
	new /obj/item/stack/cable_coil(drop_location(), 1)
	wired = FALSE

/obj/item/bodypart/chest/robot/screwdriver_act(mob/living/user, obj/item/screwtool)
	..()
	. = TRUE
	if(!cell)
		to_chat(user, span_warning("在[src]中没有安装电池单元!"))
		return
	screwtool.play_tool_sound(src)
	to_chat(user, span_notice("已从[src]中移除了[cell]."))
	cell.forceMove(drop_location())

/obj/item/bodypart/chest/robot/examine(mob/user)
	. = ..()
	if(cell)
		. += {"它已插入了一个[cell].\n
		[span_info("你可以使用<b>螺丝刀</b>来移除[cell].")]"}
	else
		. += span_info("它有一个空的电池端口，用于安装<b>电池单元</b>.")
	if(wired)
		. += "它已全部接线完毕[cell ? "并准备好使用" : ""].\n"+\
		span_info("你可以使用<b>剪线钳</b>来移除电线.")
	else
		. += span_info("它还有几个位置需要<b>接线</b>.")

/obj/item/bodypart/chest/robot/drop_organs(mob/user, violent_removal)
	var/atom/drop_loc = drop_location()
	if(wired)
		new /obj/item/stack/cable_coil(drop_loc, 1)
		wired = FALSE
	cell?.forceMove(drop_loc)
	return ..()

/obj/item/bodypart/head/robot
	name = "赛博头部"
	desc = "一个标准加固型脑壳，配备有脊髓连接神经接口和传感器万向节."
	inhand_icon_state = "buildpipe"
	icon_static = 'icons/mob/augmentation/augments.dmi'
	icon = 'icons/mob/augmentation/augments.dmi'
	limb_id = BODYPART_ID_ROBOTIC
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "borg_head"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = BP_BLOCK_CHANGE_SPECIES
	dmg_overlay_type = "robotic"

	brute_modifier = 0.8
	burn_modifier = 0.8

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC)

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)

	head_flags = HEAD_EYESPRITES
	bodypart_flags = BODYPART_UNHUSKABLE

	var/obj/item/assembly/flash/handheld/flash1 = null
	var/obj/item/assembly/flash/handheld/flash2 = null

#define EMP_GLITCH "EMP_GLITCH"

/obj/item/bodypart/head/robot/emp_effect(severity, protection)
	. = ..()
	if(!. || isnull(owner))
		return

	to_chat(owner, span_danger("你[plaintext_zone]的光学转发器出现故障并发生异常!"))

	var/glitch_duration = AUGGED_HEAD_EMP_GLITCH_DURATION
	if (severity == EMP_HEAVY)
		glitch_duration *= 2

	owner.add_client_colour(/datum/client_colour/malfunction)

	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, remove_client_colour), /datum/client_colour/malfunction), glitch_duration)
	return

#undef EMP_GLITCH

/obj/item/bodypart/head/robot/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == flash1)
		flash1 = null
	if(gone == flash2)
		flash2 = null

/obj/item/bodypart/head/robot/Destroy()
	QDEL_NULL(flash1)
	QDEL_NULL(flash2)
	return ..()

/obj/item/bodypart/head/robot/examine(mob/user)
	. = ..()
	if(!flash1 && !flash2)
		. += span_info("它有两个空的眼窝用于安装<b>闪光灯</b>.")
	else
		if(!flash1 || !flash2)
			. += {"它的一个眼窝当前已被闪光灯占据.\n
			[span_info("它还有一个空的眼窝可用于安装另一个<b>闪光灯</b>.")]"}
		else
			. += "它的两个眼窝都已被闪光灯占据."
		. += span_notice("你可以使用<b>撬棍</b>来移除已安装的闪光灯.")

/obj/item/bodypart/head/robot/attackby(obj/item/weapon, mob/user, params)
	if(istype(weapon, /obj/item/assembly/flash/handheld))
		var/obj/item/assembly/flash/handheld/flash = weapon
		if(flash1 && flash2)
			to_chat(user, span_warning("你已经插入了闪光灯到两个眼窝中!"))
			return
		else if(flash.burnt_out)
			to_chat(user, span_warning("你不能使用损坏的闪光灯!"))
			return
		else
			if(!user.transferItemToLoc(flash, src))
				return
			if(flash1)
				flash2 = flash
			else
				flash1 = flash
			to_chat(user, span_notice("你已将闪光灯插入眼窝中."))
			return
	return ..()

/obj/item/bodypart/head/robot/crowbar_act(mob/living/user, obj/item/prytool)
	..()
	if(flash1 || flash2)
		prytool.play_tool_sound(src)
		to_chat(user, span_notice("你从[src]取出了闪光灯."))
		flash1?.forceMove(drop_location())
		flash2?.forceMove(drop_location())
	else
		to_chat(user, span_warning("[src]里没有闪光灯可移除."))
	return TRUE

/obj/item/bodypart/head/robot/drop_organs(mob/user, violent_removal)
	var/atom/drop_loc = drop_location()
	flash1?.forceMove(drop_loc)
	flash2?.forceMove(drop_loc)
	return ..()

// Prosthetics - Cheap, mediocre, and worse than organic limbs
// Actively make you less healthy by being on your body, contributing a whopping 250% to overall health at only 20 max health
// They also suck to punch with.

/obj/item/bodypart/arm/left/robot/surplus
	name = "廉价左臂假肢"
	desc = "这是一具骸骨般的机械臂，虽然它已经过时且脆弱，但总比什么都没有要好."
	icon_static = 'icons/mob/augmentation/surplus_augments.dmi'
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	burn_modifier = 1
	brute_modifier = 1
	unarmed_damage_low = 1
	unarmed_damage_high = 5
	unarmed_effectiveness = 0 //Bro, you look huge.
	max_damage = LIMB_MAX_HP_PROSTHESIS
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/arm/right/robot/surplus
	name = "廉价右臂假肢"
	desc = "这是一具形似骨架的机械臂，虽然它已经过时且脆弱，但总比什么都没有要好."
	icon_static = 'icons/mob/augmentation/surplus_augments.dmi'
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	burn_modifier = 1
	brute_modifier = 1
	unarmed_damage_low = 1
	unarmed_damage_high = 5
	unarmed_effectiveness = 0
	max_damage = LIMB_MAX_HP_PROSTHESIS
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/left/robot/surplus
	name = "廉价左腿假肢"
	desc = "这是一具形似骨架的机械假肢，虽然它已经过时且易碎，但相比之下，仍然胜过一无所有."
	icon_static = 'icons/mob/augmentation/surplus_augments.dmi'
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_modifier = 1
	burn_modifier = 1
	unarmed_damage_low = 2
	unarmed_damage_high = 10
	unarmed_effectiveness = 0
	max_damage = LIMB_MAX_HP_PROSTHESIS
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/right/robot/surplus
	name = "廉价右腿假肢"
	desc = "这是一具形似骨架的机械假肢，虽然它已经过时且易碎，但相比之下，仍然胜过一无所有."
	icon_static = 'icons/mob/augmentation/surplus_augments.dmi'
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_modifier = 1
	burn_modifier = 1
	unarmed_damage_low = 2
	unarmed_damage_high = 10
	unarmed_effectiveness = 0
	max_damage = LIMB_MAX_HP_PROSTHESIS
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

// Advanced Limbs: More durable, high punching force

/obj/item/bodypart/arm/left/robot/advanced
	name = "高级机械左臂"
	desc = "一只先进的机械臂，具备更强的力量和耐用性，能够完成更出色的壮举."
	icon_static = 'icons/mob/augmentation/advanced_augments.dmi'
	icon = 'icons/mob/augmentation/advanced_augments.dmi'
	unarmed_damage_low = 5
	unarmed_damage_high = 13
	unarmed_effectiveness = 20
	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

/obj/item/bodypart/arm/right/robot/advanced
	name = "高级机械右臂"
	desc = "一只先进的机械臂，具备更强的力量和耐用性，能够完成更出色的壮举."
	icon_static = 'icons/mob/augmentation/advanced_augments.dmi'
	icon = 'icons/mob/augmentation/advanced_augments.dmi'
	unarmed_damage_low = 5
	unarmed_damage_high = 13
	unarmed_effectiveness = 20
	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

/obj/item/bodypart/leg/left/robot/advanced
	name = "高级机械左腿"
	desc = "一条先进的机械腿，拥有更强的力量和更高的耐用性，能够展现出更出色的性能."
	icon_static = 'icons/mob/augmentation/advanced_augments.dmi'
	icon = 'icons/mob/augmentation/advanced_augments.dmi'
	unarmed_damage_low = 7
	unarmed_damage_high = 17
	unarmed_effectiveness = 20
	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

/obj/item/bodypart/leg/right/robot/advanced
	name = "高级机械右腿"
	desc = "一条先进的机械腿，拥有更强的力量和更高的耐用性，能够展现出更出色的性能."
	icon_static = 'icons/mob/augmentation/advanced_augments.dmi'
	icon = 'icons/mob/augmentation/advanced_augments.dmi'
	unarmed_damage_low = 7
	unarmed_damage_high = 17
	unarmed_effectiveness = 20
	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG
