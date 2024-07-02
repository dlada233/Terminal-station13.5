/obj/item/melee/energy
	icon = 'icons/obj/weapons/transforming_energy.dmi'
	max_integrity = 200
	armor_type = /datum/armor/melee_energy
	attack_verb_continuous = list("打了打", "敲了敲", "戳了戳")
	attack_verb_simple = list("打了打", "敲了敲", "戳了戳")
	resistance_flags = FIRE_PROOF
	light_system = OVERLAY_LIGHT
	light_range = 3
	light_power = 1
	light_on = FALSE
	bare_wound_bonus = 20
	demolition_mod = 1.5 //1.5x damage to objects, robots, etc.
	stealthy_audio = TRUE
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NO_BLOOD_ON_ITEM

	/// The color of this energy based sword, for use in editing the icon_state.
	var/sword_color_icon
	/// Force while active.
	var/active_force = 30
	/// Throwforce while active.
	var/active_throwforce = 20
	/// Sharpness while active.
	var/active_sharpness = SHARP_EDGED
	/// Hitsound played attacking while active.
	var/active_hitsound = 'sound/weapons/blade1.ogg'
	/// Weight class while active.
	var/active_w_class = WEIGHT_CLASS_BULKY
	/// The heat given off when active.
	var/active_heat = 3500

	// SKYRAT EDIT ADD START

	/// The sound played when the item is turned on
	var/enable_sound = 'sound/weapons/saberon.ogg'

	/// The sound played when the item is turned off
	var/disable_sound = 'sound/weapons/saberoff.ogg'

	// SKYRAT EDIT ADD END

/datum/armor/melee_energy
	fire = 100
	acid = 30

/obj/item/melee/energy/get_all_tool_behaviours()
	return list(TOOL_SAW)

/obj/item/melee/energy/Initialize(mapload)
	. = ..()
	make_transformable()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(
		/datum/component/butchering, \
		speed = 5 SECONDS, \
		butcher_sound = active_hitsound, \
	)

/obj/item/melee/energy/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/*
 * Gives our item the transforming component, passing in our various vars.
 */
/obj/item/melee/energy/proc/make_transformable()
	AddComponent( \
		/datum/component/transforming, \
		force_on = active_force, \
		throwforce_on = active_throwforce, \
		throw_speed_on = 4, \
		sharpness_on = active_sharpness, \
		hitsound_on = active_hitsound, \
		w_class_on = active_w_class, \
		attack_verb_continuous_on = list("攻击了", "砍中了", "刺中了", "切削了", "撕开了", "割裂了", "扯开了", "切碎了", "切中了"), \
		attack_verb_simple_on = list("攻击了", "砍中了", "刺中了", "切削了", "撕开了", "割裂了", "扯开了", "切碎了", "切中了"), \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/melee/energy/suicide_act(mob/living/user)
	if(!HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		attack_self(user)
	user.visible_message(span_suicide("[user] [pick("用 [src] 切开了胃", "倒在了 [src] 上")]! 看起来 [user.p_theyre()] 正在试图切腹自尽!"))
	return (BRUTELOSS|FIRELOSS)

/obj/item/melee/energy/process(seconds_per_tick)
	if(heat)
		open_flame()

/obj/item/melee/energy/ignition_effect(atom/atom, mob/user)
	if(!heat && !HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		return ""

	var/in_mouth = ""
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		if(carbon_user.wear_mask)
			in_mouth = ", barely missing [carbon_user.p_their()] nose"
	. = span_warning("[user] swings [user.p_their()] [name][in_mouth]. [user.p_They()] light[user.p_s()] [user.p_their()] [atom.name] in the process.")
	playsound(loc, hitsound, get_clamped_volume(), TRUE, -1)
	add_fingerprint(user)

/obj/item/melee/energy/update_icon_state()
	. = ..()
	if(!sword_color_icon)
		return
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		icon_state = "[base_icon_state]_on_[sword_color_icon]" // "esword_on_red"
		inhand_icon_state = icon_state
	else
		icon_state = base_icon_state
		inhand_icon_state = base_icon_state

/**
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Updates some of the stuff the transforming comp doesn't, such as heat and embedding.
 *
 * Also gives feedback to the user and activates or deactives the glow.
 */
/obj/item/melee/energy/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		if(embedding)
			updateEmbedding()
		heat = active_heat
		START_PROCESSING(SSobj, src)
	else
		if(embedding)
			disableEmbedding()
		heat = initial(heat)
		STOP_PROCESSING(SSobj, src)

	tool_behaviour = (active ? TOOL_SAW : NONE) //Lets energy weapons cut trees. Also lets them do bonecutting surgery, which is kinda metal!
	if(user)
		balloon_alert(user, "[name] [active ? "已激活":"未激活"]")
	playsound(src, active ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 35, TRUE)
	set_light_on(active)
	update_appearance(UPDATE_ICON_STATE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/// Energy axe - extremely strong.
/obj/item/melee/energy/axe
	name = "能量斧"
	desc = "充满电活力的战斧."
	icon_state = "axe"
	inhand_icon_state = "axe"
	base_icon_state = "axe"
	lefthand_file = 'icons/mob/inhands/weapons/axes_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/axes_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("攻击了", "剁碎了", "劈开了", "撕开了", "割裂了", "切中了")
	attack_verb_simple = list("攻击了", "剁碎了", "劈开了", "撕开了", "割裂了", "切中了")
	force = 40
	throwforce = 25
	throw_speed = 3
	throw_range = 5
	armour_penetration = 100
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_NORMAL
	obj_flags = CONDUCTS_ELECTRICITY
	light_color = LIGHT_COLOR_LIGHT_CYAN

	active_force = 150
	active_throwforce = 30
	active_w_class = WEIGHT_CLASS_HUGE

/obj/item/melee/energy/axe/make_transformable()
	AddComponent( \
		/datum/component/transforming, \
		force_on = active_force, \
		throwforce_on = active_throwforce, \
		throw_speed_on = throw_speed, \
		sharpness_on = sharpness, \
		w_class_on = active_w_class, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/melee/energy/axe/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 挥舞着 [src] 向着自己的头! 看起来 [user.p_theyre()] 正在试图自杀!"))
	return (BRUTELOSS|FIRELOSS)

/// Energy swords.
/obj/item/melee/energy/sword
	name = "能量剑"
	desc = "愿原力与你同在."
	icon_state = "e_sword"
	base_icon_state = "e_sword"
	inhand_icon_state = "e_sword"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = SFX_SWING_HIT
	force = 3
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	armour_penetration = 35
	block_chance = 50
	block_sound = 'sound/weapons/block_blade.ogg'
	embedding = list("embed_chance" = 75, "impact_pain_mult" = 10)

/obj/item/melee/energy/sword/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(!HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		return FALSE

	if(attack_type == LEAP_ATTACK)
		final_block_chance -= 25 //OH GOD GET IT OFF ME

	return ..()

/obj/item/melee/energy/sword/cyborg
	name = "赛博能量剑"
	sword_color_icon = "red"
	/// The cell cost of hitting something.
	var/hitcost = 0.05 * STANDARD_CELL_CHARGE

/obj/item/melee/energy/sword/cyborg/attack(mob/target, mob/living/silicon/robot/user)
	if(!user.cell)
		return

	var/obj/item/stock_parts/cell/our_cell = user.cell
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE) && !(our_cell.use(hitcost)))
		attack_self(user)
		to_chat(user, span_notice("它没电了!"))
		return
	return ..()

/obj/item/melee/energy/sword/cyborg/cyborg_unequip(mob/user)
	if(!HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		return
	attack_self(user)

/obj/item/melee/energy/sword/cyborg/saw //Used by medical Syndicate cyborgs
	name = "能量锯"
	desc = "用于重型切割. 除了碳纤刀片, 它还有可切换的强光刀刃, 明显增加了尖锐度."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "esaw"
	hitsound = 'sound/weapons/circsawhit.ogg'
	force = 18
	hitcost = 0.075 * STANDARD_CELL_CHARGE // Costs more than a standard cyborg esword.
	w_class = WEIGHT_CLASS_NORMAL
	sharpness = SHARP_EDGED
	light_color = LIGHT_COLOR_LIGHT_CYAN
	tool_behaviour = TOOL_SAW
	toolspeed = 0.7 // Faster than a normal saw.

	active_force = 30
	sword_color_icon = null // Stops icon from breaking when turned on.

/obj/item/melee/energy/sword/cyborg/saw/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	return FALSE

// The colored energy swords we all know and love.
/obj/item/melee/energy/sword/saber
	/// Assoc list of all possible saber colors to color define. If you add a new color, make sure to update /obj/item/toy/sword too!
	var/list/possible_sword_colors = list(
		"red" = COLOR_SOFT_RED,
		"blue" = LIGHT_COLOR_LIGHT_CYAN,
		"green" = LIGHT_COLOR_GREEN,
		"purple" = LIGHT_COLOR_LAVENDER,
	)
	/// Whether this saber has been multitooled.
	var/hacked = FALSE
	var/hacked_color

/obj/item/melee/energy/sword/saber/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/jousting, damage_boost_per_tile = 1, knockdown_chance_per_tile = 10)
	if(!sword_color_icon && LAZYLEN(possible_sword_colors))
		sword_color_icon = pick(possible_sword_colors)

	if(sword_color_icon)
		set_light_color(possible_sword_colors[sword_color_icon])

/obj/item/melee/energy/sword/saber/process()
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE) || !hacked)
		return

	if(!LAZYLEN(possible_sword_colors))
		possible_sword_colors = list(
			"red" = COLOR_SOFT_RED,
			"blue" = LIGHT_COLOR_LIGHT_CYAN,
			"green" = LIGHT_COLOR_GREEN,
			"purple" = LIGHT_COLOR_LAVENDER,
		)
		possible_sword_colors -= hacked_color

	hacked_color = pick(possible_sword_colors)
	set_light_color(possible_sword_colors[hacked_color])
	possible_sword_colors -= hacked_color

/obj/item/melee/energy/sword/saber/red
	sword_color_icon = "red"

/obj/item/melee/energy/sword/saber/blue
	sword_color_icon = "blue"

/obj/item/melee/energy/sword/saber/green
	sword_color_icon = "green"

/obj/item/melee/energy/sword/saber/purple
	sword_color_icon = "purple"

/obj/item/melee/energy/sword/saber/multitool_act(mob/living/user, obj/item/tool)
	if(hacked)
		to_chat(user, span_warning("这已经很好了!"))
		return
	hacked = TRUE
	sword_color_icon = "rainbow"
	to_chat(user, span_warning("RNBW_ENGAGE"))
	update_appearance(UPDATE_ICON_STATE)

/obj/item/melee/energy/sword/pirate
	name = "能量弯刀"
	desc = "Arrrr matey."
	icon_state = "e_cutlass"
	inhand_icon_state = "e_cutlass"
	base_icon_state = "e_cutlass"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	light_color = COLOR_RED

/// Energy blades, which are effectively perma-extended energy swords
/obj/item/melee/energy/blade
	name = "能量叶刃"
	desc = "叶片状的集中光束. 非常时尚新潮... 还有致命."
	icon_state = "blade"
	base_icon_state = "blade"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/blade1.ogg'
	attack_verb_continuous = list("攻击了", "砍中了", "刺中了", "切削了", "撕开了", "割裂了", "扯开了", "切碎了", "切中了")
	attack_verb_simple = list("攻击了", "砍中了", "刺中了", "切削了", "撕开了", "割裂了", "扯开了", "切碎了", "切中了")
	force = 30
	throwforce = 1 // Throwing or dropping the item deletes it.
	throw_speed = 3
	throw_range = 1
	sharpness = SHARP_EDGED
	heat = 3500
	w_class = WEIGHT_CLASS_BULKY
	/// Our linked spark system that emits from our sword.
	var/datum/effect_system/spark_spread/spark_system

//Most of the other special functions are handled in their own files. aka special snowflake code so kewl
/obj/item/melee/energy/blade/Initialize(mapload)
	. = ..()
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	START_PROCESSING(SSobj, src)
	ADD_TRAIT(src, TRAIT_TRANSFORM_ACTIVE, INNATE_TRAIT) // Functions as an extended esword

/obj/item/melee/energy/blade/Destroy()
	QDEL_NULL(spark_system)
	return ..()

/obj/item/melee/energy/blade/make_transformable()
	return FALSE

/obj/item/melee/energy/blade/hardlight
	name = "强光刃"
	desc = "一种用强光制成的极其锋利的刀刃. 从外观上看起来十分具有冲击力."
	icon_state = "lightblade"
	inhand_icon_state = "lightblade"
	base_icon_state = "lightblade"
