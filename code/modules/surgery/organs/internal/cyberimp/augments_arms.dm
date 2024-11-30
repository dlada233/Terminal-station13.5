/obj/item/organ/internal/cyberimp/arm
	name = "arm-mounted implant"
	desc = "You shouldn't see this! Adminhelp and report this as an issue on github!"
	zone = BODY_ZONE_R_ARM
	icon_state = "implant-toolkit"
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/item_action/organ_action/toggle)
	///A ref for the arm we're taking up. Mostly for the unregister signal upon removal
	var/obj/hand
	//A list of typepaths to create and insert into ourself on init
	var/list/items_to_create = list()
	/// Used to store a list of all items inside, for multi-item implants.
	var/list/items_list = list()// I would use contents, but they shuffle on every activation/deactivation leading to interface inconsistencies.
	/// You can use this var for item path, it would be converted into an item on New().
	var/obj/item/active_item
	/// Sound played when extending
	var/extend_sound = 'sound/mecha/mechmove03.ogg'
	/// Sound played when retracting
	var/retract_sound = 'sound/mecha/mechmove03.ogg'

/obj/item/organ/internal/cyberimp/arm/Initialize(mapload)
	. = ..()
	if(ispath(active_item))
		active_item = new active_item(src)
		items_list += WEAKREF(active_item)

	for(var/typepath in items_to_create)
		var/atom/new_item = new typepath(src)
		items_list += WEAKREF(new_item)

	update_appearance()
	SetSlotFromZone()

/obj/item/organ/internal/cyberimp/arm/Destroy()
	hand = null
	active_item = null
	for(var/datum/weakref/ref in items_list)
		var/obj/item/to_del = ref.resolve()
		if(!to_del)
			continue
		qdel(to_del)
	items_list.Cut()
	return ..()

/datum/action/item_action/organ_action/toggle/toolkit
	desc = "你也可以激活你的空手或手中的工具来打开工具的快捷菜单."

/obj/item/organ/internal/cyberimp/arm/proc/SetSlotFromZone()
	switch(zone)
		if(BODY_ZONE_L_ARM)
			slot = ORGAN_SLOT_LEFT_ARM_AUG
		if(BODY_ZONE_R_ARM)
			slot = ORGAN_SLOT_RIGHT_ARM_AUG
		else
			CRASH("Invalid zone for [type]")

/obj/item/organ/internal/cyberimp/arm/update_icon()
	. = ..()
	transform = (zone == BODY_ZONE_R_ARM) ? null : matrix(-1, 0, 0, 0, 1, 0)

/obj/item/organ/internal/cyberimp/arm/examine(mob/user)
	. = ..()
	if(IS_ROBOTIC_ORGAN(src))
		. += span_info("[src]是以[zone == BODY_ZONE_R_ARM ? "右" : "左"]臂配置进行组装的. 你可以使用螺丝刀来重新组装它.")

/obj/item/organ/internal/cyberimp/arm/screwdriver_act(mob/living/user, obj/item/screwtool)
	. = ..()
	if(.)
		return TRUE
	screwtool.play_tool_sound(src)
	if(zone == BODY_ZONE_R_ARM)
		zone = BODY_ZONE_L_ARM
	else
		zone = BODY_ZONE_R_ARM
	SetSlotFromZone()
	to_chat(user, span_notice("你将[src]改装为安装在[zone == BODY_ZONE_R_ARM ? "右" : "左"]手臂上."))
	update_appearance()

/obj/item/organ/internal/cyberimp/arm/on_mob_insert(mob/living/carbon/arm_owner)
	. = ..()
	RegisterSignal(arm_owner, COMSIG_CARBON_POST_ATTACH_LIMB, PROC_REF(on_limb_attached))
	RegisterSignal(arm_owner, COMSIG_KB_MOB_DROPITEM_DOWN, PROC_REF(dropkey)) //We're nodrop, but we'll watch for the drop hotkey anyway and then stow if possible.
	on_limb_attached(arm_owner, arm_owner.hand_bodyparts[zone == BODY_ZONE_R_ARM ? RIGHT_HANDS : LEFT_HANDS])

/obj/item/organ/internal/cyberimp/arm/on_mob_remove(mob/living/carbon/arm_owner)
	. = ..()
	Retract()
	UnregisterSignal(arm_owner, list(COMSIG_CARBON_POST_ATTACH_LIMB, COMSIG_KB_MOB_DROPITEM_DOWN))
	on_limb_detached(hand)

/obj/item/organ/internal/cyberimp/arm/proc/on_limb_attached(mob/living/carbon/source, obj/item/bodypart/limb)
	SIGNAL_HANDLER
	if(!limb || QDELETED(limb) || limb.body_zone != zone)
		return
	if(hand)
		on_limb_detached(hand)
	RegisterSignal(limb, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_item_attack_self))
	RegisterSignal(limb, COMSIG_BODYPART_REMOVED, PROC_REF(on_limb_detached))
	hand = limb

/obj/item/organ/internal/cyberimp/arm/proc/on_limb_detached(obj/item/bodypart/source)
	SIGNAL_HANDLER
	if(source != hand || QDELETED(hand))
		return
	UnregisterSignal(hand, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_BODYPART_REMOVED))
	hand = null

/obj/item/organ/internal/cyberimp/arm/proc/on_item_attack_self()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(ui_action_click))

/obj/item/organ/internal/cyberimp/arm/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	if(prob(15/severity) && owner)
		to_chat(owner, span_warning("电磁脉冲导致[src]故障!"))
		// give the owner an idea about why his implant is glitching
		Retract()

/**
 * Called when the mob uses the "drop item" hotkey
 *
 * Items inside toolset implants have TRAIT_NODROP, but we can still use the drop item hotkey as a
 * quick way to store implant items. In this case, we check to make sure the user has the correct arm
 * selected, and that the item is actually owned by us, and then we'll hand off the rest to Retract()
**/
/obj/item/organ/internal/cyberimp/arm/proc/dropkey(mob/living/carbon/host)
	SIGNAL_HANDLER
	if(!host)
		return //How did we even get here
	if(hand != host.hand_bodyparts[host.active_hand_index])
		return //wrong hand
	if(Retract())
		return COMSIG_KB_ACTIVATED

/obj/item/organ/internal/cyberimp/arm/proc/Retract()
	if(!active_item || (active_item in src))
		return FALSE
	if(owner)
		owner.visible_message(
			span_notice("[owner]将[active_item]收回至[zone == BODY_ZONE_R_ARM ? "右" : "左"]臂."),
			span_notice("[active_item]迅速收回至你的[zone == BODY_ZONE_R_ARM ? "右" : "左"]臂."),
			span_hear("你听到一声短暂的机械噪音."),
		)

		owner.transferItemToLoc(active_item, src, TRUE)
	else
		active_item.forceMove(src)

	UnregisterSignal(active_item, COMSIG_ITEM_ATTACK_SELF)
	UnregisterSignal(active_item, COMSIG_ITEM_ATTACK_SELF_SECONDARY)
	active_item = null
	playsound(get_turf(owner), retract_sound, 50, TRUE)
	return TRUE

/obj/item/organ/internal/cyberimp/arm/proc/Extend(obj/item/augment)
	if(!(augment in src))
		return

	active_item = augment

	active_item.resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	ADD_TRAIT(active_item, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	active_item.slot_flags = null
	active_item.set_custom_materials(null)

	var/side = zone == BODY_ZONE_R_ARM? RIGHT_HANDS : LEFT_HANDS
	var/hand = owner.get_empty_held_index_for_side(side)
	if(hand)
		owner.put_in_hand(active_item, hand)
	else
		var/list/hand_items = owner.get_held_items_for_side(side, all = TRUE)
		var/success = FALSE
		var/list/failure_message = list()
		for(var/i in 1 to hand_items.len) //Can't just use *in* here.
			var/hand_item = hand_items[i]
			if(!owner.dropItemToGround(hand_item))
				failure_message += span_warning("你的[hand_item]干扰了[src]!")
				continue
			to_chat(owner, span_notice("你放下[hand_item]来激活[src]!"))
			success = owner.put_in_hand(active_item, owner.get_empty_held_index_for_side(side))
			break
		if(!success)
			for(var/i in failure_message)
				to_chat(owner, i)
			return
	owner.visible_message(span_notice("[owner]从其[zone == BODY_ZONE_R_ARM ? "右" : "左"]手臂中伸出[active_item]."),
		span_notice("你从其[zone == BODY_ZONE_R_ARM ? "右" : "左"]手臂中伸出[active_item]."),
		span_hear("你听到一声短暂的机械声."))
	playsound(get_turf(owner), extend_sound, 50, TRUE)

	if(length(items_list) > 1)
		RegisterSignals(active_item, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_ITEM_ATTACK_SELF_SECONDARY), PROC_REF(swap_tools)) // secondary for welders

/obj/item/organ/internal/cyberimp/arm/proc/swap_tools(active_item)
	SIGNAL_HANDLER
	Retract(active_item)
	INVOKE_ASYNC(src, PROC_REF(ui_action_click))

/obj/item/organ/internal/cyberimp/arm/ui_action_click()
	if((organ_flags & ORGAN_FAILING) || (!active_item && !contents.len))
		to_chat(owner, span_warning("植入物没有反应，好像坏了..."))
		return

	if(!active_item || (active_item in src))
		active_item = null
		if(contents.len == 1)
			Extend(contents[1])
		else
			var/list/choice_list = list()
			for(var/datum/weakref/augment_ref in items_list)
				var/obj/item/augment_item = augment_ref.resolve()
				if(!augment_item)
					items_list -= augment_ref
					continue
				choice_list[augment_item] = image(augment_item)
			var/obj/item/choice = show_radial_menu(owner, owner, choice_list)
			if(owner && owner == usr && owner.stat != DEAD && (src in owner.organs) && !active_item && (choice in contents))
				// This monster sanity check is a nice example of how bad input is.
				Extend(choice)
	else
		Retract()


/obj/item/organ/internal/cyberimp/arm/gun/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(prob(30/severity) && owner && !(organ_flags & ORGAN_FAILING))
		Retract()
		owner.visible_message(span_danger("一声巨响来自[owner]的[zone == BODY_ZONE_R_ARM ? "右" : "左"]臂!"))
		playsound(get_turf(owner), 'sound/weapons/flashbang.ogg', 100, TRUE)
		to_chat(owner, span_userdanger("你感到你的[zone == BODY_ZONE_R_ARM ? "右" : "左"]手臂内发生了爆炸，因为你的植入物损坏了!"))
		owner.adjust_fire_stacks(20)
		owner.ignite_mob()
		owner.adjustFireLoss(25)
		organ_flags |= ORGAN_FAILING


/obj/item/organ/internal/cyberimp/arm/gun/laser
	name = "臂载激光植入物"
	desc = "一种臂炮植入物的变种，发射致命激光束，管从使用者的手臂中伸出，不使用时则收回."
	icon_state = "arm_laser"
	items_to_create = list(/obj/item/gun/energy/laser/mounted/augment)

/obj/item/organ/internal/cyberimp/arm/gun/laser/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/internal/cyberimp/arm/gun/taser
	name = "臂载电击枪植入物"
	desc = "一种臂炮植入物的变种，发射电极和禁用弹，炮管从使用者的手臂中伸出，不使用时则收回."
	icon_state = "arm_taser"
	items_to_create = list(/obj/item/gun/energy/e_gun/advtaser/mounted)

/obj/item/organ/internal/cyberimp/arm/gun/taser/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/internal/cyberimp/arm/toolset
	name = "集成工具组植入物"
	desc = "工程生化人工具组的简化版，设计用于安装在使用者的手臂上，包含每种工具的先进版本."
	actions_types = list(/datum/action/item_action/organ_action/toggle/toolkit)
	items_to_create = list(
		/obj/item/screwdriver/cyborg,
		/obj/item/wrench/cyborg,
		/obj/item/weldingtool/largetank/cyborg,
		/obj/item/crowbar/cyborg,
		/obj/item/wirecutters/cyborg,
		/obj/item/multitool/cyborg,
	)

/obj/item/organ/internal/cyberimp/arm/toolset/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/internal/cyberimp/arm/toolset/emag_act(mob/user, obj/item/card/emag/emag_card)
	for(var/datum/weakref/created_item in items_list)
		var/obj/potential_knife = created_item.resolve()
		if(istype(/obj/item/knife/combat/cyborg, potential_knife))
			return FALSE

	balloon_alert(user, "集成匕首已解锁")
	items_list += WEAKREF(new /obj/item/knife/combat/cyborg(src))
	return TRUE

/obj/item/organ/internal/cyberimp/arm/esword
	name = "臂载能量剑"
	desc = "一种非法且极其危险的机械植入物，能投射出致命的能量刀刃."
	items_to_create = list(/obj/item/melee/energy/blade/hardlight)

/obj/item/organ/internal/cyberimp/arm/medibeam
	name = "集成医疗光束枪"
	desc = "一种机械植入物，允许使用者从手部投射出治疗光束."
	items_to_create = list(/obj/item/gun/medbeam)


/obj/item/organ/internal/cyberimp/arm/flash
	name = "集成高强度光子投射器" //Why not
	desc = "一种安装在用户手臂上的集成投射器，可用作强大的闪光装置."
	items_to_create = list(/obj/item/assembly/flash/armimplant)

/obj/item/organ/internal/cyberimp/arm/flash/Initialize(mapload)
	. = ..()
	for(var/datum/weakref/created_item in items_list)
		var/obj/potential_flash = created_item.resolve()
		if(!istype(potential_flash, /obj/item/assembly/flash/armimplant))
			continue
		var/obj/item/assembly/flash/armimplant/flash = potential_flash
		flash.arm = WEAKREF(src)

/obj/item/organ/internal/cyberimp/arm/flash/Extend()
	. = ..()
	active_item.set_light_range(7)
	active_item.set_light_on(TRUE)

/obj/item/organ/internal/cyberimp/arm/flash/Retract()
	if(active_item)
		active_item.set_light_on(FALSE)
	return ..()

/obj/item/organ/internal/cyberimp/arm/baton
	name = "电击臂植入物"
	desc = "一种非法的战斗植入物，允许使用者通过手臂释放使人丧失行动能力的电击."
	items_to_create = list(/obj/item/borg/stun)

/obj/item/organ/internal/cyberimp/arm/combat
	name = "战斗型机械臂植入物"
	desc = "种强大的机械臂植入物，内置多种战斗模块."
	items_to_create = list(
		/obj/item/melee/energy/blade/hardlight,
		/obj/item/gun/medbeam,
		/obj/item/borg/stun,
		/obj/item/assembly/flash/armimplant,
	)

/obj/item/organ/internal/cyberimp/arm/combat/Initialize(mapload)
	. = ..()
	for(var/datum/weakref/created_item in items_list)
		var/obj/potential_flash = created_item.resolve()
		if(!istype(potential_flash, /obj/item/assembly/flash/armimplant))
			continue
		var/obj/item/assembly/flash/armimplant/flash = potential_flash
		flash.arm = WEAKREF(src)

/obj/item/organ/internal/cyberimp/arm/surgery
	name = "外科手术植入物"
	desc = "一组隐藏在用户手臂隐蔽面板后的手术工具."
	actions_types = list(/datum/action/item_action/organ_action/toggle/toolkit)
	items_to_create = list(
		/obj/item/retractor/augment,
		/obj/item/hemostat/augment,
		/obj/item/cautery/augment,
		/obj/item/surgicaldrill/augment,
		/obj/item/scalpel/augment,
		/obj/item/circular_saw/augment,
		/obj/item/surgical_drapes,
	)

/obj/item/organ/internal/cyberimp/arm/surgery/emagged
	name = "被破解的外科手术植入物"
	desc = "一组隐藏在用户手臂隐蔽面板后的手术工具，这个似乎被破解篡改了."
	items_to_create = list(
		/obj/item/retractor/augment,
		/obj/item/hemostat/augment,
		/obj/item/cautery/augment,
		/obj/item/surgicaldrill/augment,
		/obj/item/scalpel/augment,
		/obj/item/circular_saw/augment,
		/obj/item/surgical_drapes,
		/obj/item/knife/combat/cyborg,
	)

/obj/item/organ/internal/cyberimp/arm/muscle
	name = "肌肉增强臂植入物"
	desc = "植入后，此机械植入物将增强手臂肌肉，以提高每次动作的力量."
	icon_state = "muscle_implant"

	zone = BODY_ZONE_R_ARM
	slot = ORGAN_SLOT_RIGHT_ARM_AUG

	actions_types = list()

	///The amount of damage the implant adds to our unarmed attacks.
	var/punch_damage = 5
	///IF true, the throw attack will not smash people into walls
	var/non_harmful_throw = TRUE
	///How far away your attack will throw your oponent
	var/attack_throw_range = 1
	///Minimum throw power of the attack
	var/throw_power_min = 1
	///Maximum throw power of the attack
	var/throw_power_max = 4
	///How long will the implant malfunction if it is EMP'd
	var/emp_base_duration = 9 SECONDS

/obj/item/organ/internal/cyberimp/arm/muscle/on_mob_insert(mob/living/carbon/arm_owner)
	. = ..()
	if(ishuman(arm_owner)) //Sorry, only humans
		RegisterSignal(arm_owner, COMSIG_LIVING_EARLY_UNARMED_ATTACK, PROC_REF(on_attack_hand))

/obj/item/organ/internal/cyberimp/arm/muscle/on_mob_remove(mob/living/carbon/arm_owner)
	. = ..()
	UnregisterSignal(arm_owner, COMSIG_LIVING_EARLY_UNARMED_ATTACK)

/obj/item/organ/internal/cyberimp/arm/muscle/emp_act(severity)
	. = ..()
	if((organ_flags & ORGAN_FAILING) || . & EMP_PROTECT_SELF)
		return
	owner.balloon_alert(owner, "你的胳膊痉挛得厉害!")
	organ_flags |= ORGAN_FAILING
	addtimer(CALLBACK(src, PROC_REF(reboot)), 90 / severity)

/obj/item/organ/internal/cyberimp/arm/muscle/proc/reboot()
	organ_flags &= ~ORGAN_FAILING
	owner.balloon_alert(owner, "你的胳膊停止了痉挛!")

/obj/item/organ/internal/cyberimp/arm/muscle/proc/on_attack_hand(mob/living/carbon/human/source, atom/target, proximity, modifiers)
	SIGNAL_HANDLER

	if(source.get_active_hand() != hand || !proximity)
		return NONE
	if(!source.combat_mode || LAZYACCESS(modifiers, RIGHT_CLICK))
		return NONE
	if(!isliving(target))
		return NONE
	var/datum/dna/dna = source.has_dna()
	if(dna?.check_mutation(/datum/mutation/human/hulk)) //NO HULK
		return NONE
	if(!source.can_unarmed_attack())
		return COMPONENT_SKIP_ATTACK

	var/mob/living/living_target = target
	source.changeNext_move(CLICK_CD_MELEE)
	var/picked_hit_type = pick("拳击", "猛砸", "揍击", "痛击", "重击")

	if(organ_flags & ORGAN_FAILING)
		if(source.body_position != LYING_DOWN && living_target != source && prob(50))
			to_chat(source, span_danger("你试着[picked_hit_type][living_target]，但是失去了平衡，摔倒了!"))
			source.Knockdown(3 SECONDS)
			source.forceMove(get_turf(living_target))
		else
			to_chat(source, span_danger("你的肌肉痉挛!"))
			source.Paralyze(1 SECONDS)
		return COMPONENT_CANCEL_ATTACK_CHAIN

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.check_block(source, punch_damage, "[source]的[picked_hit_type]"))
			source.do_attack_animation(target)
			playsound(living_target.loc, 'sound/weapons/punchmiss.ogg', 25, TRUE, -1)
			log_combat(source, target, "attempted to [picked_hit_type]", "muscle implant")
			return COMPONENT_CANCEL_ATTACK_CHAIN

	var/potential_damage = punch_damage
	var/obj/item/bodypart/attacking_bodypart = hand
	potential_damage += rand(attacking_bodypart.unarmed_damage_low, attacking_bodypart.unarmed_damage_high)

	source.do_attack_animation(target, ATTACK_EFFECT_SMASH)
	playsound(living_target.loc, 'sound/weapons/punch1.ogg', 25, TRUE, -1)

	var/target_zone = living_target.get_random_valid_zone(source.zone_selected)
	var/armor_block = living_target.run_armor_check(target_zone, MELEE, armour_penetration = attacking_bodypart.unarmed_effectiveness)
	living_target.apply_damage(potential_damage, attacking_bodypart.attack_type, target_zone, armor_block)
	living_target.apply_damage(potential_damage*1.5, STAMINA, target_zone, armor_block)

	if(source.body_position != LYING_DOWN) //Throw them if we are standing
		var/atom/throw_target = get_edge_target_turf(living_target, source.dir)
		living_target.throw_at(throw_target, attack_throw_range, rand(throw_power_min,throw_power_max), source, gentle = non_harmful_throw)

	living_target.visible_message(
		span_danger("[source][picked_hit_type]了[living_target]!"),
		span_userdanger("你被[source][picked_hit_type]了!"),
		span_hear("你听到激烈的肉体撞击声!"),
		COMBAT_MESSAGE_RANGE,
		source,
	)

	to_chat(source, span_danger("你[picked_hit_type]了[target]!"))

	log_combat(source, target, "[picked_hit_type]了", "muscle implant")

	return COMPONENT_CANCEL_ATTACK_CHAIN
