/*
	Changeling Mutations! ~By Miauw (ALL OF IT :V)
	Contains:
		Arm Blade
		Space Suit
		Shield
		Armor
		Tentacles
*/


//Parent to shields and blades because muh copypasted code.
/datum/action/changeling/weapon
	name = "Organic Weapon"
	desc = "Go tell a coder if you see this"
	helptext = "Yell at Miauw and/or Perakp"
	chemical_cost = 1000
	dna_cost = CHANGELING_POWER_UNOBTAINABLE

	var/silent = FALSE
	var/weapon_type
	var/weapon_name_simple

/datum/action/changeling/weapon/Grant(mob/granted_to)
	. = ..()
	if (!owner || !req_human)
		return
	RegisterSignal(granted_to, COMSIG_HUMAN_MONKEYIZE, PROC_REF(became_monkey))

/datum/action/changeling/weapon/Remove(mob/remove_from)
	UnregisterSignal(remove_from, COMSIG_HUMAN_MONKEYIZE)
	unequip_held(remove_from)
	return ..()

/// Remove weapons if we become a monkey
/datum/action/changeling/weapon/proc/became_monkey(mob/source)
	SIGNAL_HANDLER
	unequip_held(source)

/// Removes weapon if it exists, returns true if we removed something
/datum/action/changeling/weapon/proc/unequip_held(mob/user)
	var/found_weapon = FALSE
	for(var/obj/item/held in user.held_items)
		found_weapon = check_weapon(user, held) || found_weapon
	return found_weapon

/datum/action/changeling/weapon/try_to_sting(mob/user, mob/target)
	if (unequip_held(user))
		return
	..(user, target)

/datum/action/changeling/weapon/proc/check_weapon(mob/user, obj/item/hand_item)
	if(istype(hand_item, weapon_type))
		user.temporarilyRemoveItemFromInventory(hand_item, TRUE) //DROPDEL will delete the item
		if(!silent)
			playsound(user, 'sound/effects/blobattack.ogg', 30, TRUE)
			user.visible_message(span_warning("伴随着令人作呕的嘎吱声，[user]将自己的[weapon_name_simple]化成了一只手臂!"), span_notice("我们将[weapon_name_simple]收回我们的身体."), "<span class='italics>你听到有机物撕扯的声音!</span>")
		user.update_held_items()
		return TRUE

/datum/action/changeling/weapon/sting_action(mob/living/carbon/user)
	var/obj/item/held = user.get_active_held_item()
	if(held && !user.dropItemToGround(held))
		user.balloon_alert(user, "手部被占用!")
		return
	if(!istype(user))
		user.balloon_alert(user, "形状错误!")
		return
	..()
	var/limb_regen = 0
	if(HAS_TRAIT_FROM_ONLY(user, TRAIT_PARALYSIS_L_ARM, CHANGELING_TRAIT) || HAS_TRAIT_FROM_ONLY(user, TRAIT_PARALYSIS_R_ARM, CHANGELING_TRAIT))
		user.balloon_alert(user, "not enough muscle!") // no cheesing repuprosed glands
		return
	if(user.active_hand_index % 2 == 0) //we regen the arm before changing it into the weapon
		limb_regen = user.regenerate_limb(BODY_ZONE_R_ARM, 1)
	else
		limb_regen = user.regenerate_limb(BODY_ZONE_L_ARM, 1)
	if(limb_regen)
		user.visible_message(span_warning("[user]丢失的手臂重新生长，发出一种响亮而怪异的声音!"), span_userdanger("伴随着巨大的痛苦你们的手臂重新长了出来，还发出了嘎吱嘎吱的声音！"), span_hear("你听到有机物撕扯的声音!"))
		user.emote("scream")
	var/obj/item/W = new weapon_type(user, silent)
	user.put_in_hands(W)
	if(!silent)
		playsound(user, 'sound/effects/blobattack.ogg', 30, TRUE)
	return W


//Parent to space suits and armor.
/datum/action/changeling/suit
	name = "Organic Suit"
	desc = "Go tell a coder if you see this"
	helptext = "Yell at Miauw and/or Perakp"
	chemical_cost = 1000
	dna_cost = CHANGELING_POWER_UNOBTAINABLE

	var/helmet_type = null
	var/suit_type = null
	var/suit_name_simple = "    "
	var/helmet_name_simple = "     "
	var/recharge_slowdown = 0
	var/blood_on_castoff = 0

/datum/action/changeling/suit/Grant(mob/granted_to)
	. = ..()
	if (!owner || !req_human)
		return
	RegisterSignal(granted_to, COMSIG_HUMAN_MONKEYIZE, PROC_REF(became_monkey))

/datum/action/changeling/suit/Remove(mob/remove_from)
	UnregisterSignal(remove_from, COMSIG_HUMAN_MONKEYIZE)
	check_suit(remove_from)
	return ..()

/// Remove suit if we become a monkey
/datum/action/changeling/suit/proc/became_monkey()
	SIGNAL_HANDLER
	check_suit(owner)

/datum/action/changeling/suit/try_to_sting(mob/user, mob/target)
	if(check_suit(user))
		return
	var/mob/living/carbon/human/H = user
	..(H, target)

//checks if we already have an organic suit and casts it off.
/datum/action/changeling/suit/proc/check_suit(mob/user)
	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user)
	if(!ishuman(user) || !changeling)
		return 1
	var/mob/living/carbon/human/H = user

	if(istype(H.wear_suit, suit_type) || istype(H.head, helmet_type))
		var/name_to_use = (isnull(suit_type) ? helmet_name_simple : suit_name_simple)
		H.visible_message(span_warning("[H]褪下了[name_to_use]!"), span_warning("我们褪下自己的[name_to_use]."), span_hear("你听到有机物撕扯的声音!"))
		if(!isnull(helmet_type))
			H.temporarilyRemoveItemFromInventory(H.head, TRUE) //The qdel on dropped() takes care of it
		if(!isnull(suit_type))
			H.temporarilyRemoveItemFromInventory(H.wear_suit, TRUE)
		H.update_worn_oversuit()
		H.update_worn_head()
		H.update_body_parts()

		if(blood_on_castoff)
			H.add_splatter_floor()
			playsound(H.loc, 'sound/effects/splat.ogg', 50, TRUE) //So real sounds

		changeling.chem_recharge_slowdown -= recharge_slowdown
		return 1

/datum/action/changeling/suit/sting_action(mob/living/carbon/human/user)
	if(!user.canUnEquip(user.wear_suit) && !isnull(suit_type))
		user.balloon_alert(user, "身体部位被占用!")
		return
	if(!user.canUnEquip(user.head) && !isnull(helmet_type))
		user.balloon_alert(user, "头部被占用!")
		return
	..()
	if(!isnull(suit_type))
		user.dropItemToGround(user.wear_suit)
		user.equip_to_slot_if_possible(new suit_type(user), ITEM_SLOT_OCLOTHING, 1, 1, 1)
	if(!isnull(helmet_type))
		user.dropItemToGround(user.head)
		user.equip_to_slot_if_possible(new helmet_type(user), ITEM_SLOT_HEAD, 1, 1, 1)

	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user)
	changeling.chem_recharge_slowdown += recharge_slowdown
	return TRUE


//fancy headers yo
/***************************************\
|***************ARM BLADE***************|
\***************************************/
/datum/action/changeling/weapon/arm_blade
	name = "臂刃"
	desc = "我们将一条手臂化成致命的利刃，消耗20点化学物质来变异出来."
	helptext = "我们也可以随时收回臂刃，但在退形的情况下无法使用."
	button_icon_state = "armblade"
	chemical_cost = 20
	dna_cost = 2
	req_human = TRUE
	weapon_type = /obj/item/melee/arm_blade
	weapon_name_simple = "臂刃"

/obj/item/melee/arm_blade
	name = "臂刃"
	desc = "一把由骨头和血肉制成的怪异刀刃，能像热刀切黄油那样切人."
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "arm_blade"
	inhand_icon_state = "arm_blade"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 25
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("攻击", "劈向", "刺向", "削向", "砍向", "撕裂", "切向", "斩向", "斜斩")
	attack_verb_simple = list("攻击", "劈向", "刺向", "削向", "砍向", "撕裂", "切向", "斩向", "斜斩")
	sharpness = SHARP_EDGED
	wound_bonus = 10
	bare_wound_bonus = 10
	armour_penetration = 35
	var/can_drop = FALSE
	var/fake = FALSE

/obj/item/melee/arm_blade/Initialize(mapload,silent,synthetic)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc) && !silent)
		loc.visible_message(span_warning("[loc.name]的手臂周围长出了怪异刀刃!"), span_warning("我们的手臂扭曲变异，化成了致命的臂刃."), span_hear("你听到有机物撕扯的声音!"))
	if(synthetic)
		can_drop = TRUE
	AddComponent(/datum/component/butchering, \
	speed = 6 SECONDS, \
	effectiveness = 80, \
	)

/obj/item/melee/arm_blade/afterattack(atom/target, mob/user, click_parameters)
	if(istype(target, /obj/structure/table))
		var/obj/smash = target
		smash.deconstruct(FALSE)

	else if(istype(target, /obj/machinery/computer))
		target.attack_alien(user) //muh copypasta

	else if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/opening = target

		if((!opening.requiresID() || opening.allowed(user)) && opening.hasPower()) //This is to prevent stupid shit like hitting a door with an arm blade, the door opening because you have acces and still getting a "the airlocks motors resist our efforts to force it" message, power requirement is so this doesn't stop unpowered doors from being pried open if you have access
			return
		if(opening.locked)
			opening.balloon_alert(user, "被拴上了!")
			return

		if(opening.hasPower())
			user.visible_message(span_warning("[user]将[src]插入气闸门中并强行起撬!"), span_warning("我们开始强行撬开[opening]."), \
			span_hear("你听到金属扭曲带来的刺耳声音."))
			playsound(opening, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE)
			if(!do_after(user, 10 SECONDS, target = opening))
				return
		//user.say("Heeeeeeeeeerrre's Johnny!")
		user.visible_message(span_warning("[user]用[src]强行撬开了气闸门!"), span_warning("我们强行撬开了[opening]."), \
		span_hear("你听到金属扭曲带来的刺耳声音."))
		opening.open(BYPASS_DOOR_CHECKS)

/obj/item/melee/arm_blade/dropped(mob/user)
	..()
	if(can_drop)
		new /obj/item/melee/synthetic_arm_blade(get_turf(user))

/***************************************\
|***********COMBAT TENTACLES*************|
\***************************************/

/datum/action/changeling/weapon/tentacle
	name = "触手"
	desc = "我们进化出触手来远程抓取物品或猎物，花费10点化学物质来变异出来."
	helptext = "我们可以用它来远距离抓取物体. 对生物的效果视我们自身是否处于战斗模式而不同: \
	非战斗模式下，左键只会简单地将对象抓近；右键则会将抓取对象手中的物品； \
	在战斗模式下，我们将对象抓近的同时保持抓取，并且若我们另一只手持有锐器，还将在抓近的同时刺向对象. \
	此外无法在退形的情况下使用."
	button_icon_state = "tentacle"
	chemical_cost = 10
	dna_cost = 2
	req_human = TRUE
	weapon_type = /obj/item/gun/magic/tentacle
	weapon_name_simple = "触手"
	silent = TRUE

/obj/item/gun/magic/tentacle
	name = "触手"
	desc = "能伸长抓取远距离物体的肉质触手."
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "tentacle"
	inhand_icon_state = "tentacle"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	antimagic_flags = NONE
	pinless = TRUE
	ammo_type = /obj/item/ammo_casing/magic/tentacle
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	can_hold_up = FALSE

/obj/item/gun/magic/tentacle/Initialize(mapload, silent)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc))
		if(!silent)
			loc.visible_message(span_warning("[loc.name]的手臂开始非人地伸展!"), span_warning("你们的手臂扭曲变异，变成了触手."), span_hear("你听到有机物撕扯的声音!"))
		else
			to_chat(loc, span_notice("你准备长出触手."))


/obj/item/gun/magic/tentacle/shoot_with_empty_chamber(mob/living/user as mob|obj)
	user.balloon_alert(user, "没准备好!")

/obj/item/gun/magic/tentacle/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	var/obj/projectile/tentacle/tentacle_shot = chambered.loaded_projectile //Gets the actual projectile we will fire
	tentacle_shot.fire_modifiers = params2list(params)
	. = ..()
	if(charges == 0)
		qdel(src)

/obj/item/gun/magic/tentacle/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]把[src]紧紧地缠绕在自己的脖子上! 这是一种自杀行为!"))
	return OXYLOSS

/obj/item/ammo_casing/magic/tentacle
	name = "触手"
	desc = "一条触手."
	projectile_type = /obj/projectile/tentacle
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	var/obj/item/gun/magic/tentacle/gun //the item that shot it

/obj/item/ammo_casing/magic/tentacle/Initialize(mapload)
	gun = loc
	. = ..()

/obj/item/ammo_casing/magic/tentacle/Destroy()
	gun = null
	return ..()

/obj/projectile/tentacle
	name = "触手"
	icon_state = "tentacle_end"
	pass_flags = PASSTABLE
	damage = 0
	damage_type = BRUTE
	range = 8
	hitsound = 'sound/weapons/thudswoosh.ogg'
	var/chain
	var/obj/item/ammo_casing/magic/tentacle/source //the item that shot it
	///Click params that were used to fire the tentacle shot
	var/list/fire_modifiers

/obj/projectile/tentacle/Initialize(mapload)
	source = loc
	. = ..()

/obj/projectile/tentacle/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "tentacle", emissive = FALSE)
	..()

/obj/projectile/tentacle/proc/reset_throw(mob/living/carbon/human/H)
	if(H.throw_mode)
		H.throw_mode_off(THROW_MODE_TOGGLE) //Don't annoy the changeling if he doesn't catch the item

/obj/projectile/tentacle/proc/tentacle_grab(mob/living/carbon/human/H, mob/living/carbon/C)
	if(H.Adjacent(C))
		if(H.get_active_held_item() && !H.get_inactive_held_item())
			H.swap_hand()
		if(H.get_active_held_item())
			return
		C.grabbedby(H)
		C.grippedby(H, instant = TRUE) //instant aggro grab
		for(var/obj/item/I in H.held_items)
			if(I.get_sharpness())
				C.visible_message(span_danger("[H]用[I.name]刺穿了[C]!"), span_userdanger("[H]用[I.name]刺穿了你!"))
				C.apply_damage(I.force, BRUTE, BODY_ZONE_CHEST, attacking_item = I)
				H.do_item_attack_animation(C, used_item = I)
				H.add_mob_blood(C)
				playsound(get_turf(H),I.hitsound,75,TRUE)
				return

/obj/projectile/tentacle/on_hit(atom/movable/target, blocked = 0, pierce_hit)
	if(!isliving(firer) || !ismovable(target))
		return ..()

	if(blocked >= 100)
		return BULLET_ACT_BLOCK

	var/mob/living/ling = firer
	if(isitem(target) && iscarbon(ling))
		var/obj/item/catching = target
		if(catching.anchored)
			return BULLET_ACT_BLOCK

		var/mob/living/carbon/carbon_ling = ling
		to_chat(carbon_ling, span_notice("你们将[catching]拉向自己."))
		carbon_ling.throw_mode_on(THROW_MODE_TOGGLE)
		catching.throw_at(
			target = carbon_ling,
			range = 10,
			speed = 2,
			thrower = carbon_ling,
			diagonals_first = TRUE,
			callback = CALLBACK(src, PROC_REF(reset_throw), carbon_ling),
			gentle = TRUE,
		)
		return BULLET_ACT_HIT

	. = ..()
	if(. != BULLET_ACT_HIT)
		return .
	var/mob/living/victim = target
	if(!isliving(victim) || target.anchored || victim.throwing)
		return BULLET_ACT_BLOCK

	if(!iscarbon(victim) || !ishuman(ling) || !ling.combat_mode)
		victim.visible_message(
			span_danger("[victim]被[ling]的[src]抓住!"),
			span_userdanger("一条[src]把你抓向[ling]!"),
		)
		victim.throw_at(
			target = get_step_towards(ling, victim),
			range = 8,
			speed = 2,
			thrower = ling,
			diagonals_first = TRUE,
			gentle = TRUE,
		)
		return BULLET_ACT_HIT

	if(LAZYACCESS(fire_modifiers, RIGHT_CLICK))
		var/obj/item/stealing = victim.get_active_held_item()
		if(!isnull(stealing))
			if(victim.dropItemToGround(stealing))
				victim.visible_message(
					span_danger("[victim]手中的[stealing]被[src]夺走了!"),
					span_userdanger("你手中的[stealing]被[src]夺走了!"),
				)
				return on_hit(stealing) //grab the item as if you had hit it directly with the tentacle

			to_chat(ling, span_warning("你们无法将[stealing]从[victim]手中夺走!"))
			return BULLET_ACT_BLOCK

		to_chat(ling, span_danger("[victim]手中没有可缴械的物品!"))
		return BULLET_ACT_HIT

	if(ling.combat_mode)
		victim.visible_message(
			span_danger("[victim]被一条[src]甩向[ling]!"),
			span_userdanger("[src]抓住并将你甩向[ling]!"),
		)
		victim.throw_at(
			target = get_step_towards(ling, victim),
			range  = 8,
			speed = 2,
			thrower = ling,
			diagonals_first = TRUE,
			callback = CALLBACK(src, PROC_REF(tentacle_grab), ling, victim),
			gentle = TRUE,
		)

	return BULLET_ACT_HIT

/obj/projectile/tentacle/Destroy()
	qdel(chain)
	source = null
	return ..()


/***************************************\
|****************SHIELD*****************|
\***************************************/
/datum/action/changeling/weapon/shield
	name = "有机盾牌"
	desc = "我们把一条手臂改造成坚固的盾牌. 变异将花费20点化学物质."
	helptext = "有机组织无法一直阻挡伤害，在被击中太多次之后会破裂，但通过吸收更多的基因组可以强化这面盾牌.此外无法在退形的情况下使用该能力."
	button_icon_state = "organic_shield"
	chemical_cost = 20
	dna_cost = 1
	req_human = TRUE

	weapon_type = /obj/item/shield/changeling
	weapon_name_simple = "shield"

/datum/action/changeling/weapon/shield/sting_action(mob/user)
	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user) //So we can read the absorbed_count.
	if(!changeling)
		return

	var/obj/item/shield/changeling/S = ..(user)
	S.remaining_uses = round(changeling.absorbed_count * 3)
	return TRUE

/obj/item/shield/changeling
	name = "大盾块"
	desc = "一团坚硬的骨组织，你甚至能看到手指的形状嵌在盾牌表面."
	item_flags = ABSTRACT | DROPDEL
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "ling_shield"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	block_chance = 50

	var/remaining_uses //Set by the changeling ability.

/obj/item/shield/changeling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc))
		loc.visible_message(span_warning("[loc.name]的手臂末端迅速膨胀，形成巨大的盾状物体!"), span_warning("我们将手臂膨胀成一面坚固的盾牌."), span_hear("你听到有机物撕扯的声音!"))

/obj/item/shield/changeling/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "攻击", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(remaining_uses < 1)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.visible_message(span_warning("伴随着令人作呕的嘎吱声，[H]的手臂化成了一面盾牌!"), span_notice("我们将盾牌吸收回体内"), "<span class='italics>你听到有机物撕扯的声音!</span>")
		qdel(src)
		return 0
	else
		remaining_uses--
		return ..()

/***************************************\
|*****************ARMOR*****************|
\***************************************/
/datum/action/changeling/suit/armor
	name = "几丁质护甲"
	desc = "我们硬化皮肤成坚固的几丁质以保护自己，变异将花费20点化学物质."
	helptext = "护甲对实体和能量武器均有很好的抗性，但维持护甲需要很少量的化学物质.此外退形状态下无法使用该能力."
	button_icon_state = "chitinous_armor"
	chemical_cost = 20
	dna_cost = 1
	req_human = TRUE
	recharge_slowdown = 0.125

	suit_type = /obj/item/clothing/suit/armor/changeling
	helmet_type = /obj/item/clothing/head/helmet/changeling
	suit_name_simple = "护甲"
	helmet_name_simple = "头盔"

/obj/item/clothing/suit/armor/changeling
	name = "几丁质团块"
	desc = "坚硬的黑色几丁质覆盖物."
	icon_state = "lingarmor"
	inhand_icon_state = null
	item_flags = DROPDEL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/armor_changeling
	flags_inv = HIDEJUMPSUIT
	cold_protection = 0
	heat_protection = 0

/datum/armor/armor_changeling
	melee = 40
	bullet = 40
	laser = 40
	energy = 50
	bomb = 10
	bio = 10
	fire = 90
	acid = 90

/obj/item/clothing/suit/armor/changeling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc))
		loc.visible_message(span_warning("[loc.name]的皮肤变黑并硬化成了坚硬的几丁质团块!"), span_warning("我们硬化肉体，生长出了一套盔甲！"), span_hear("你听到有机物撕扯的声音!"))

/obj/item/clothing/head/helmet/changeling
	name = "几丁质团块"
	desc = "坚硬的黑色几丁质外壳包裹在侧后，面部则有透明的几丁质."
	icon_state = "lingarmorhelmet"
	inhand_icon_state = null
	item_flags = DROPDEL
	armor_type = /datum/armor/helmet_changeling
	flags_inv = HIDEEARS|HIDEHAIR|HIDEEYES|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT

/datum/armor/helmet_changeling
	melee = 40
	bullet = 40
	laser = 40
	energy = 50
	bomb = 10
	bio = 10
	fire = 90
	acid = 90

/obj/item/clothing/head/helmet/changeling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)

/datum/action/changeling/suit/hive_head
	name = "蜂巢头"
	desc = "在我们的头上裹上一层类似于蜂巢的蜡质外层，可以生产蜜蜂来公攻击敌人. 变异将花费15点化学物质."
	helptext = "蜂巢头防护作用有限，但允许使用者派遣蜜蜂去攻击敌人，将化学试剂倒入蜂巢还将使生产出来的蜜蜂向敌人注射试剂."
	button_icon_state = "hive_head"
	chemical_cost = 15
	dna_cost = 2
	req_human = FALSE
	blood_on_castoff = TRUE

	helmet_type = /obj/item/clothing/head/helmet/changeling_hivehead
	helmet_name_simple = "hive head"

/obj/item/clothing/head/helmet/changeling_hivehead
	name = "蜂巢头"
	desc = "奇怪的蜡质外层覆盖在你的头上，会让你感到耳鸣."
	icon_state = "hivehead"
	inhand_icon_state = null
	flash_protect = FLASH_PROTECTION_FLASH
	item_flags = DROPDEL
	armor_type = /datum/armor/changeling_hivehead
	flags_inv = HIDEEARS|HIDEHAIR|HIDEEYES|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT
	actions_types = list(/datum/action/cooldown/hivehead_spawn_minions)
	///Does this hive head hold reagents?
	var/holds_reagents = TRUE

/obj/item/clothing/head/helmet/changeling_hivehead/Initialize(mapload)
	. = ..()
	if(holds_reagents)
		create_reagents(50, REFILLABLE)

/datum/armor/changeling_hivehead
	melee = 10
	bullet = 10
	laser = 10
	energy = 10
	bio = 50

/obj/item/clothing/head/helmet/changeling_hivehead/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)

/obj/item/clothing/head/helmet/changeling_hivehead/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(!istype(attacking_item, /obj/item/organ/internal/monster_core/regenerative_core/legion) || !holds_reagents)
		return
	visible_message(span_boldwarning("[user]将[attacking_item]推入[src]，[src]开始了变异."))
	var/mob/living/carbon/wearer = loc
	playsound(wearer, 'sound/effects/attackblob.ogg', 60, TRUE)
	wearer.temporarilyRemoveItemFromInventory(wearer.head, TRUE)
	wearer.equip_to_slot_if_possible(new /obj/item/clothing/head/helmet/changeling_hivehead/legion(wearer), ITEM_SLOT_HEAD, 1, 1, 1)
	qdel(attacking_item)


/datum/action/cooldown/hivehead_spawn_minions
	name = "释放蜜蜂"
	desc = "释放一群蜜蜂攻击除你之外的所有生命体."
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"
	button_icon = 'icons/mob/simple/bees.dmi'
	button_icon_state = "queen_item"
	cooldown_time = 30 SECONDS
	///The mob we're going to spawn
	var/spawn_type = /mob/living/basic/bee/timed/short
	///How many are we going to spawn
	var/spawn_count = 6

/datum/action/cooldown/hivehead_spawn_minions/PreActivate(atom/target)
	if(owner.movement_type & VENTCRAWLING)
		owner.balloon_alert(owner, "unavailable here")
		return
	return ..()

/datum/action/cooldown/hivehead_spawn_minions/Activate(atom/target)
	. = ..()
	do_tell()
	var/spawns = spawn_count
	if(owner.stat >= HARD_CRIT)
		spawns = 1
	for(var/i in 1 to spawns)
		var/mob/living/basic/summoned_minion = new spawn_type(get_turf(owner))
		summoned_minion.faction = list("[REF(owner)]")
		minion_additional_changes(summoned_minion)

///Our tell that we're using this ability. Usually a sound and a visible message.area
/datum/action/cooldown/hivehead_spawn_minions/proc/do_tell()
	owner.visible_message(span_warning("[owner]'s head begins to buzz as bees begin to pour out!"), span_warning("We release the bees."), span_hear("You hear a loud buzzing sound!"))
	playsound(owner, 'sound/creatures/bee_swarm.ogg', 60, TRUE)

///Stuff we want to do to our minions. This is in its own proc so subtypes can override this behaviour.
/datum/action/cooldown/hivehead_spawn_minions/proc/minion_additional_changes(mob/living/basic/minion)
	var/mob/living/basic/bee/summoned_bee = minion
	var/mob/living/carbon/wearer = owner
	if(istype(summoned_bee) && length(wearer.head.reagents.reagent_list))
		summoned_bee.assign_reagent(pick(wearer.head.reagents.reagent_list))

/obj/item/clothing/head/helmet/changeling_hivehead/legion
	name = "军团蜂巢头"
	desc = "A strange, boney coating covering your head with a fleshy inside. Surprisingly comfortable."
	icon_state = "hivehead_legion"
	actions_types = list(/datum/action/cooldown/hivehead_spawn_minions/legion)
	holds_reagents = FALSE

/datum/action/cooldown/hivehead_spawn_minions/legion
	name = "释放军团"
	desc = "Release a group of legion to attack all other lifeforms."
	button_icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	button_icon_state = "legion_head"
	cooldown_time = 15 SECONDS
	spawn_type = /mob/living/basic/legion_brood
	spawn_count = 4

/datum/action/cooldown/hivehead_spawn_minions/legion/do_tell()
	owner.visible_message(span_warning("[owner]'s head begins to shake as legion begin to pour out!"), span_warning("We release the legion."), span_hear("You hear a loud squishing sound!"))
	playsound(owner, 'sound/effects/attackblob.ogg', 60, TRUE)

/datum/action/cooldown/hivehead_spawn_minions/legion/minion_additional_changes(mob/living/basic/minion)
	var/mob/living/basic/legion_brood/brood = minion
	if (istype(brood))
		brood.assign_creator(owner, FALSE)
