
/obj/item/melee/sickly_blade
	name = "\improper 病态弯刃"
	desc = "一柄病态的绿色新月形弯刃，带有眼睛装饰，你感觉自己被监视了..."
	icon = 'icons/obj/weapons/khopesh.dmi'
	icon_state = "eldritch_blade"
	inhand_icon_state = "eldritch_blade"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	obj_flags = CONDUCTS_ELECTRICITY
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_NORMAL
	force = 20
	throwforce = 10
	wound_bonus = 5
	bare_wound_bonus = 15
	toolspeed = 0.375
	demolition_mod = 0.8
	hitsound = 'sound/weapons/bladeslice.ogg'
	armour_penetration = 35
	attack_verb_continuous = list("攻击", "挥砍", "斩击", "切割", "刺击", "伤害", "横劈", "猛切", "划伤")
	attack_verb_simple = list("攻击", "挥砍", "斩击", "切割", "刺击", "伤害", "横劈", "猛切", "划伤")
	var/after_use_message = ""

/obj/item/melee/sickly_blade/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(.)
		return .
	if(!IS_HERETIC_OR_MONSTER(user))
		to_chat(user, span_danger("你感到异域的心愫冲击着你的思维."))
		user.AdjustParalyzed(5 SECONDS)
		return TRUE
	return .

/obj/item/melee/sickly_blade/afterattack(atom/target, mob/user, click_parameters)
	if(isliving(target))
		SEND_SIGNAL(user, COMSIG_HERETIC_BLADE_ATTACK, target, src)

/obj/item/melee/sickly_blade/attack_self(mob/user)
	var/turf/safe_turf = find_safe_turf(zlevel = z, extended_safety_checks = TRUE)
	if(IS_HERETIC_OR_MONSTER(user))
		if(do_teleport(user, safe_turf, channel = TELEPORT_CHANNEL_MAGIC))
			to_chat(user, span_warning("当你粉碎[src]时，你感到一股能量流经你的身体. [after_use_message]"))
		else
			to_chat(user, span_warning("你粉碎了[src]，但请求没有被回应."))
	else
		to_chat(user,span_warning("你粉碎了[src]."))
	playsound(src, SFX_SHATTER, 70, TRUE) //copied from the code for smashing a glass sheet onto the ground to turn it into a shard
	qdel(src)

/obj/item/melee/sickly_blade/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isliving(interacting_with))
		SEND_SIGNAL(user, COMSIG_HERETIC_RANGED_BLADE_ATTACK, interacting_with, src)
		return ITEM_INTERACT_BLOCKING

/obj/item/melee/sickly_blade/examine(mob/user)
	. = ..()
	if(!IS_HERETIC_OR_MONSTER(user))
		return

	. += span_notice("<b>在手中使用刀刃<b>将粉碎刀刃并将你传送到一个随机、但安全(大多数情况下是的)的位置.")

// Path of Rust's blade
/obj/item/melee/sickly_blade/rust
	name = "\improper 铁锈之刃"
	desc = "这把新月形的刀刃破败不堪，正逐渐生锈腐化. \
		然而它依然锋利异常，以锯齿般的腐朽牙齿撕裂着肉和骨头。."
	icon_state = "rust_blade"
	inhand_icon_state = "rust_blade"
	after_use_message = "锈山听到了你的呼唤..."

// Path of Ash's blade
/obj/item/melee/sickly_blade/ash
	name = "\improper 灰烬之刃"
	desc = "熔化而未加工的一块金属，扭曲成灰烬和熔渣. \
		未成形的金属渴望超越自身，用钝刃割开布满煤烟的伤口."
	icon_state = "ash_blade"
	inhand_icon_state = "ash_blade"
	after_use_message = "守夜人听到了你的呼唤..."
	resistance_flags = FIRE_PROOF

// Path of Flesh's blade
/obj/item/melee/sickly_blade/flesh
	name = "\improper 血腥之刃"
	desc = "一把由生物异变而成的新月刀刃. \
		意识敏锐，试图将它从可怕的起源中所承受的痛苦传播给其他人."
	icon_state = "flesh_blade"
	inhand_icon_state = "flesh_blade"
	after_use_message = "元帅听到了你的呼唤..."

/obj/item/melee/sickly_blade/flesh/Initialize(mapload)
	. = ..()

	AddComponent(
		/datum/component/blood_walk,\
		blood_type = /obj/effect/decal/cleanable/blood,\
		blood_spawn_chance = 66.6,\
		max_blood = INFINITY,\
	)

	AddComponent(
		/datum/component/bloody_spreader,\
		blood_left = INFINITY,\
		blood_dna = list("未知DNA" = "X*"),\
		diseases = null,\
	)

// Path of Void's blade
/obj/item/melee/sickly_blade/void
	name = "\improper 虚无之刃"
	desc = "毫无实质的存在，这把刀刃中反射出的只有空白. \
		它是纯净的真实描绘，以及在实施后随之而来的混沌."
	icon_state = "void_blade"
	inhand_icon_state = "void_blade"
	after_use_message = "贵族听到了你的呼唤..."

// Path of the Blade's... blade.
// Opting for /dark instead of /blade to avoid "sickly_blade/blade".
/obj/item/melee/sickly_blade/dark
	name = "\improper 碎裂之刃"
	desc = "一把刀刃，破碎却华美. \
		刀刃躁动不安，银色的疤痕下深藏着阴暗的密谋."
	icon_state = "dark_blade"
	inhand_icon_state = "dark_blade"
	after_use_message = "撕裂斗士听到了你的呼唤..."

// Path of Cosmos's blade
/obj/item/melee/sickly_blade/cosmic
	name = "\improper 宇宙之刃"
	desc = "一粒天体共鸣，织就星纹之刃. \
		彩虹般的流亡者，刻出光阴的轨迹，苦寻万千的合一."
	icon_state = "cosmic_blade"
	inhand_icon_state = "cosmic_blade"
	after_use_message = "观星者听到了你的呼唤..."

// Path of Knock's blade
/obj/item/melee/sickly_blade/lock
	name = "\improper 钥匙之刃"
	desc = "既是刃也是钥匙，但锁在何处?\
		又是哪扇大门将要开启?"
	icon_state = "key_blade"
	inhand_icon_state = "key_blade"
	after_use_message = "管家听到了你的呼唤..."
	tool_behaviour = TOOL_CROWBAR
	toolspeed = 1.3

// Path of Moon's blade
/obj/item/melee/sickly_blade/moon
	name = "\improper 月之刃"
	desc = "刃面中显映这片土地上的真相: 终有一天我都会在剧团相聚. \
		剧团不分男女老幼，只为他们在脸上刻满微笑."
	icon_state = "moon_blade"
	inhand_icon_state = "moon_blade"
	after_use_message = "月亮听到了你的呼唤..."
