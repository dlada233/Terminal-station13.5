// Deprecated, you do not need to use this type for melee weapons.
/obj/item/melee
	item_flags = NEEDS_PERMIT

/obj/item/melee/chainofcommand
	name = "指挥之链"
	desc = "伟人用来安抚口吐白沫的人们的工具."
	icon = 'icons/obj/weapons/whip.dmi'
	icon_state = "chain"
	inhand_icon_state = "chain"
	worn_icon_state = "whip"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	force = 10
	throwforce = 7
	demolition_mod = 0.25
	wound_bonus = 15
	bare_wound_bonus = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("鞭笞了", "抽打了", "鞭打了", "调教了")
	attack_verb_simple = list("鞭笞了", "抽打了", "鞭打了", "调教了")
	hitsound = 'sound/weapons/chainhit.ogg'
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/melee/chainofcommand/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 用 [src] 勒住了自己! 看起来 [user.p_theyre()] 正在试图自杀!"))
	return OXYLOSS

/obj/item/melee/synthetic_arm_blade
	name = "合成臂刃"
	desc = "一把令人作呕的刀刃，近看材质像是由合成肉制成, 但作为一把武器, 它仍会造成严重的伤害."
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "arm_blade"
	inhand_icon_state = "arm_blade"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 20
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("攻击了", "砍中了", "刺中了", "切削了", "撕开了", "割裂了", "扯开了", "切碎了", "切中了")
	attack_verb_simple = list("攻击了", "砍中了", "刺中了", "切削了", "撕开了", "割裂了", "扯开了", "切碎了", "切中了")
	sharpness = SHARP_EDGED

/obj/item/melee/synthetic_arm_blade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 6 SECONDS, \
	effectiveness = 80, \
	)
	//very imprecise

/obj/item/melee/sabre
	name = "军官佩剑" //SKYRAT EDIT - Buffed in modular_skyrat/modules/modular_weapons/code/melee.dm
	desc = "一把优雅的武器, 它的单分子刀刃能够轻松地切割骨骼和肉体。."
	icon = 'icons/obj/weapons/sword.dmi'
	icon_state = "sabre"
	inhand_icon_state = "sabre"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY | UNIQUE_RENAME
	force = 15
	throwforce = 10
	demolition_mod = 0.75 //but not metal
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 50
	armour_penetration = 75
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("砍中了", "切中了")
	attack_verb_simple = list("砍中了", "切中了")
	block_sound = 'sound/weapons/parry.ogg'
	hitsound = 'sound/weapons/rapierhit.ogg'
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	wound_bonus = 10
	bare_wound_bonus = 25

/obj/item/melee/sabre/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/jousting)
	//fast and effective, but as a sword, it might damage the results.
	AddComponent(/datum/component/butchering, \
		speed = 3 SECONDS, \
		effectiveness = 95, \
		bonus_modifier = 5, \
	)
	// The weight of authority comes down on the tider's crimes.
	AddElement(/datum/element/bane, target_type = /mob/living/carbon/human, damage_multiplier = 0.35)
	RegisterSignal(src, COMSIG_OBJECT_PRE_BANING, PROC_REF(attempt_bane))
	RegisterSignal(src, COMSIG_OBJECT_ON_BANING, PROC_REF(bane_effects))

/**
 * If the target reeks of maintenance, the blade can tear through their body with a total of 20 damage.
 */
/obj/item/melee/sabre/proc/attempt_bane(element_owner, mob/living/carbon/criminal)
	SIGNAL_HANDLER
	var/obj/item/organ/internal/liver/liver = criminal.get_organ_slot(ORGAN_SLOT_LIVER)
	if(isnull(liver) || !HAS_TRAIT(liver, TRAIT_MAINTENANCE_METABOLISM))
		return COMPONENT_CANCEL_BANING

/**
 * Assistants should fear this weapon.
 */
/obj/item/melee/sabre/proc/bane_effects(element_owner, mob/living/carbon/human/baned_target)
	SIGNAL_HANDLER
	baned_target.visible_message(
		span_warning("[src] 以不自然的方式轻松撕开了 [baned_target]!"),
		span_userdanger("当 [src] 撕开进入你的身体时, 你能感受到权威的重量塌入你的伤口中!"),
	)
	INVOKE_ASYNC(baned_target, TYPE_PROC_REF(/mob/living/carbon/human, emote), "scream")

/obj/item/melee/sabre/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "攻击", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == PROJECTILE_ATTACK || attack_type == LEAP_ATTACK)
		final_block_chance = 0 //Don't bring a sword to a gunfight, and also you aren't going to really block someone full body tackling you with a sword
	return ..()

/obj/item/melee/sabre/on_exit_storage(datum/storage/container)
	playsound(container.parent, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/melee/sabre/on_enter_storage(datum/storage/container)
	playsound(container.parent, 'sound/items/sheath.ogg', 25, TRUE)

/obj/item/melee/sabre/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 正试图用 [src] 砍掉所有的肢体! 看起来 [user.p_theyre()] 正在试图自杀!"))
	var/i = 0
	ADD_TRAIT(src, TRAIT_NODROP, SABRE_SUICIDE_TRAIT)
	if(iscarbon(user))
		var/mob/living/carbon/Cuser = user
		var/obj/item/bodypart/holding_bodypart = Cuser.get_holding_bodypart_of_item(src)
		var/list/limbs_to_dismember
		var/list/arms = list()
		var/list/legs = list()
		var/obj/item/bodypart/bodypart

		for(bodypart in Cuser.bodyparts)
			if(bodypart == holding_bodypart)
				continue
			if(bodypart.body_part & ARMS)
				arms += bodypart
			else if (bodypart.body_part & LEGS)
				legs += bodypart

		limbs_to_dismember = arms + legs
		if(holding_bodypart)
			limbs_to_dismember += holding_bodypart

		var/speedbase = abs((4 SECONDS) / limbs_to_dismember.len)
		for(bodypart in limbs_to_dismember)
			i++
			addtimer(CALLBACK(src, PROC_REF(suicide_dismember), user, bodypart), speedbase * i)
	addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), (5 SECONDS) * i)
	return MANUAL_SUICIDE

/obj/item/melee/sabre/proc/suicide_dismember(mob/living/user, obj/item/bodypart/affecting)
	if(!QDELETED(affecting) && !(affecting.bodypart_flags & BODYPART_UNREMOVABLE) && affecting.owner == user && !QDELETED(user))
		playsound(user, hitsound, 25, TRUE)
		affecting.dismember(BRUTE)
		user.adjustBruteLoss(20)

/obj/item/melee/sabre/proc/manual_suicide(mob/living/user, originally_nodropped)
	if(!QDELETED(user))
		user.adjustBruteLoss(200)
		user.death(FALSE)
	REMOVE_TRAIT(src, TRAIT_NODROP, SABRE_SUICIDE_TRAIT)

/obj/item/melee/beesword
	name = "毒刺"
	desc = "取自一只巨大的蜜蜂, 在纯蜂蜜中包折了一千多次. 可以刺穿任何东西."
	icon = 'icons/obj/weapons/sword.dmi'
	icon_state = "beesword"
	inhand_icon_state = "stinger"
	worn_icon_state = "stinger"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 5
	w_class = WEIGHT_CLASS_BULKY
	sharpness = SHARP_EDGED
	throwforce = 10
	attack_speed = CLICK_CD_RAPID
	block_chance = 20
	armour_penetration = 65
	attack_verb_continuous = list("砍中了", "叮咬了", "戳刺了", "戳了戳")
	attack_verb_simple = list("砍中了", "叮咬了", "戳刺了", "戳了戳")
	hitsound = 'sound/weapons/rapierhit.ogg'
	block_sound = 'sound/weapons/parry.ogg'

/obj/item/melee/beesword/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == PROJECTILE_ATTACK || attack_type == LEAP_ATTACK)
		final_block_chance = 0 //Don't bring a sword to a gunfight, and also you aren't going to really block someone full body tackling you with a sword
	return ..()

/obj/item/melee/beesword/afterattack(atom/target, mob/user, click_parameters)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.reagents.add_reagent(/datum/reagent/toxin, 4)

/obj/item/melee/beesword/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 正在用 [src] 刺伤自己的喉咙! 看起来 [user.p_theyre()] 正在试图自杀!"))
	playsound(get_turf(src), hitsound, 75, TRUE, -1)
	return TOXLOSS

/obj/item/melee/supermatter_sword
	name = "超物质剑"
	desc = "在一个满是馊主意的站点, 这可能是非常糟糕的."
	icon = 'icons/obj/weapons/sword.dmi'
	icon_state = "supermatter_sword_balanced"
	inhand_icon_state = "supermatter_sword"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	slot_flags = null
	w_class = WEIGHT_CLASS_BULKY
	force = 0.001
	armour_penetration = 1000
	force_string = "无限"
	item_flags = NEEDS_PERMIT|NO_BLOOD_ON_ITEM
	var/obj/machinery/power/supermatter_crystal/shard
	var/balanced = 1

/obj/item/melee/supermatter_sword/Initialize(mapload)
	. = ..()
	shard = new /obj/machinery/power/supermatter_crystal(src)
	qdel(shard.countdown)
	shard.countdown = null
	START_PROCESSING(SSobj, src)
	visible_message(span_warning("[src] 出现了, 完美地平衡在剑柄上. 这一点丝毫不带有不祥之兆."))
	RegisterSignal(src, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(eat_bullets))

/obj/item/melee/supermatter_sword/process()
	if(balanced || throwing || ismob(src.loc) || isnull(src.loc))
		return
	if(!isturf(src.loc))
		var/atom/target = src.loc
		forceMove(target.loc)
		consume_everything(target)
	else
		var/turf/turf = get_turf(src)
		if(!isspaceturf(turf))
			consume_turf(turf)

/obj/item/melee/supermatter_sword/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(.)
		return .

	if(A == user)
		user.dropItemToGround(src, TRUE)
	else
		user.do_attack_animation(A)
	consume_everything(A)
	return TRUE

/obj/item/melee/supermatter_sword/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(ismob(hit_atom))
		var/mob/mob = hit_atom
		if(src.loc == mob)
			mob.dropItemToGround(src, TRUE)
	consume_everything(hit_atom)

/obj/item/melee/supermatter_sword/pickup(user)
	..()
	balanced = 0
	icon_state = "supermatter_sword"

/obj/item/melee/supermatter_sword/ex_act(severity, target)
	visible_message(
		span_danger("爆炸冲击波猛然撞击 [src], 迅速将其瞬间化为灰烬."),
		span_hear("你听到一声巨响, 同时被一股热浪所包围.")
	)
	consume_everything()
	return TRUE

/obj/item/melee/supermatter_sword/acid_act()
	visible_message(span_danger("酸液猛然撞击 [src], 迅速将其迅燃成灰."),\
	span_hear("你听到一声巨响, 同时被一股热浪所包围."))
	consume_everything()
	return TRUE

/obj/item/melee/supermatter_sword/proc/eat_bullets(datum/source, obj/projectile/hitting_projectile)
	SIGNAL_HANDLER

	visible_message(
		span_danger("[hitting_projectile] 猛然撞击 [source], 迅速将其迅燃成灰."),
		null,
		span_hear("你听到一声巨响, 同时被一股热浪所包围."),
	)
	consume_everything(hitting_projectile)
	return COMPONENT_BULLET_BLOCKED

/obj/item/melee/supermatter_sword/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 触摸了 [src] 的剑刃. 看起来 [user.p_theyre()] 已经厌倦了等待被辐射杀死!"))
	user.dropItemToGround(src, TRUE)
	shard.Bumped(user)

/obj/item/melee/supermatter_sword/proc/consume_everything(target)
	if(isnull(target))
		shard.Bump(target)
	else if(!isturf(target))
		shard.Bumped(target)
	else
		consume_turf(target)

/obj/item/melee/supermatter_sword/proc/consume_turf(turf/turf)
	var/oldtype = turf.type
	var/turf/newT = turf.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	if(newT.type == oldtype)
		return
	playsound(turf, 'sound/effects/supermatter.ogg', 50, TRUE)
	turf.visible_message(
		span_danger("[turf] 猛然撞击 [src], 迅速将其迅燃成灰."),
		span_hear("你听到一声巨响, 同时被一股热浪所包围."),
	)
	shard.Bump(turf)

/obj/item/melee/curator_whip
	name = "馆长之鞭"
	desc = "虽然有点古怪和过时, 但被它抽打还是会痛不欲生."
	icon = 'icons/obj/weapons/whip.dmi'
	icon_state = "whip"
	inhand_icon_state = "chain"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	worn_icon_state = "whip"
	slot_flags = ITEM_SLOT_BELT
	force = 15
	demolition_mod = 0.25
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("鞭笞了", "抽打了", "鞭打了", "调教了")
	attack_verb_simple = list("鞭笞了", "抽打了", "鞭打了", "调教了")
	hitsound = 'sound/weapons/whip.ogg'

/obj/item/melee/curator_whip/afterattack(atom/target, mob/user, click_parameters)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		human_target.drop_all_held_items()
		human_target.visible_message(span_danger("[user] 解除了 [human_target] 的武装!"), span_userdanger("[user] 解除了你的武装!"))

/obj/item/melee/roastingstick
	name = "高级烤肉棍"
	desc = "一把伸缩式的烤肉棍, 内置微型护盾发生器, 设计用于确保能够进入各种带有屏蔽功能的高科技烹饪炉和火坑."
	icon = 'icons/obj/service/kitchen.dmi'
	icon_state = "roastingstick"
	inhand_icon_state = null
	worn_icon_state = "tele_baton"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NONE
	force = 0
	attack_verb_continuous = list("打了打", "戳了戳")
	attack_verb_simple = list("打了打", "戳了戳")
	/// The sausage attatched to our stick.
	var/obj/item/food/sausage/held_sausage
	/// Static list of things our roasting stick can interact with.
	var/static/list/ovens
	/// The beam that links to the oven we use
	var/datum/beam/beam

/obj/item/melee/roastingstick/Initialize(mapload)
	. = ..()
	if (!ovens)
		ovens = typecacheof(list(/obj/singularity, /obj/energy_ball, /obj/machinery/power/supermatter_crystal, /obj/structure/bonfire))
	AddComponent( \
		/datum/component/transforming, \
		hitsound_on = hitsound, \
		clumsy_check = FALSE, \
		inhand_icon_change = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_PRE_TRANSFORM, PROC_REF(attempt_transform))
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_PRE_TRANSFORM].
 *
 * If there is a sausage attached, returns COMPONENT_BLOCK_TRANSFORM.
 */
/obj/item/melee/roastingstick/proc/attempt_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(held_sausage)
		to_chat(user, span_warning("当 [src] 上附着 [held_sausage] 时, 你无法收回 [src]!"))
		return COMPONENT_BLOCK_TRANSFORM

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Gives feedback on stick extension.
 */
/obj/item/melee/roastingstick/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	inhand_icon_state = active ? "nullrod" : null
	if(user)
		balloon_alert(user, "[active ? "伸展" : "折叠"] [src]")
	playsound(src, 'sound/weapons/batonextend.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/melee/roastingstick/attackby(atom/target, mob/user)
	..()
	if (istype(target, /obj/item/food/sausage))
		if (!HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
			to_chat(user, span_warning("你必须将 [src] 伸展开来才能附着任何东西!"))
			return
		if (held_sausage)
			to_chat(user, span_warning("[held_sausage] 已经附着在 [src] 上了!"))
			return
		if (user.transferItemToLoc(target, src))
			held_sausage = target
		else
			to_chat(user, span_warning("[target] 似乎不想在 [src] 上面!"))
	update_appearance()

/obj/item/melee/roastingstick/attack_hand(mob/user, list/modifiers)
	..()
	if (held_sausage)
		user.put_in_hands(held_sausage)

/obj/item/melee/roastingstick/update_overlays()
	. = ..()
	if(held_sausage)
		. += mutable_appearance(icon, "roastingstick_sausage")

/obj/item/melee/roastingstick/Exited(atom/movable/gone, direction)
	. = ..()
	if (gone == held_sausage)
		held_sausage = null
		update_appearance()

/obj/item/melee/roastingstick/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if (!HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		return NONE
	if (!is_type_in_typecache(interacting_with, ovens))
		return NONE
	if (istype(interacting_with, /obj/singularity) && get_dist(user, interacting_with) < 10)
		to_chat(user, span_notice("你将[held_sausage]朝[interacting_with]扔去."))
		playsound(src, 'sound/items/rped.ogg', 50, TRUE)
		beam = user.Beam(interacting_with, icon_state = "rped_upgrade", time = 10 SECONDS)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/melee/roastingstick/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if (!HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		return NONE
	if (!is_type_in_typecache(interacting_with, ovens))
		return NONE
	to_chat(user, span_notice("你将[src]伸展到[interacting_with]."))
	playsound(src, 'sound/weapons/batonextend.ogg', 50, TRUE)
	finish_roasting(user, interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/melee/roastingstick/proc/finish_roasting(user, atom/target)
	if(do_after(user, 10 SECONDS, target = user))
		to_chat(user, span_notice("你完成了对 [held_sausage] 的烤制."))
		playsound(src, 'sound/items/welder2.ogg', 50, TRUE)
		held_sausage.add_atom_colour(rgb(103, 63, 24), FIXED_COLOUR_PRIORITY)
		held_sausage.name = "[target.name]-烤制完成 [held_sausage.name]"
		held_sausage.desc = "[held_sausage.desc] 它在[target]上被烹饪得完美无瑕."
		update_appearance()
	else
		QDEL_NULL(beam)
		playsound(src, 'sound/weapons/batonextend.ogg', 50, TRUE)
		to_chat(user, span_notice("你收起 [src]."))

/obj/item/melee/cleric_mace
	name = "牧师权杖"
	desc = "它是棍棒的后代, 也是棒球棒的前辈. 在过去的岁月里, 它被圣职团体广泛使用."
	icon = 'icons/obj/weapons/cleric_mace.dmi'
	icon_state = "default"
	inhand_icon_state = "default"
	worn_icon_state = "default_worn"

	greyscale_config = /datum/greyscale_config/cleric_mace
	greyscale_config_inhand_left = /datum/greyscale_config/cleric_mace_lefthand
	greyscale_config_inhand_right = /datum/greyscale_config/cleric_mace_righthand
	greyscale_config_worn = /datum/greyscale_config/cleric_mace
	greyscale_colors = COLOR_WHITE

	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_GREYSCALE | MATERIAL_AFFECT_STATISTICS //Material type changes the prefix as well as the color.
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*6)  //Defaults to an Iron Mace.
	slot_flags = ITEM_SLOT_BELT
	force = 14
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 8
	block_chance = 10
	block_sound = 'sound/weapons/genhit.ogg'
	armour_penetration = 50
	attack_verb_continuous = list("猛击了", "打击了", "砸中了", "猛击了")
	attack_verb_simple = list("猛击了", "打击了", "砸中了", "猛击了")

/obj/item/melee/cleric_mace/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "攻击", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == PROJECTILE_ATTACK || attack_type == LEAP_ATTACK)
		final_block_chance = 0 //Don't bring a...mace to a gunfight, and also you aren't going to really block someone full body tackling you with a mace
	return ..()
