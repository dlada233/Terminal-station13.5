/obj/item/gun/magic/staff
	slot_flags = ITEM_SLOT_BACK
	ammo_type = /obj/item/ammo_casing/magic/nothing
	worn_icon_state = null
	icon_state = "staff"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	item_flags = NEEDS_PERMIT | NO_MAT_REDEMPTION
	/// Can non-magic folk use our staff?
	/// If FALSE, only wizards or survivalists can use the staff to its full potential - If TRUE, anyone can
	var/allow_intruder_use = FALSE

/obj/item/gun/magic/staff/proc/is_wizard_or_friend(mob/user)
	if(!HAS_MIND_TRAIT(user, TRAIT_MAGICALLY_GIFTED) && !allow_intruder_use)
		return FALSE
	return TRUE

/obj/item/gun/magic/staff/can_trigger_gun(mob/living/user, akimbo_usage)
	if(akimbo_usage && !is_wizard_or_friend(user))
		return FALSE
	return ..()

/obj/item/gun/magic/staff/check_botched(mob/living/user, atom/target)
	if(!is_wizard_or_friend(user))
		return !on_intruder_use(user, target)
	return ..()

/// Called when someone who isn't a wizard or magician uses this staff.
/// Return TRUE to allow usage.
/obj/item/gun/magic/staff/proc/on_intruder_use(mob/living/user, atom/target)
	return TRUE

/obj/item/gun/magic/staff/change
	name = "变化法杖"
	desc = "能射出耀眼能量使目标变形."
	fire_sound = 'sound/magic/staff_change.ogg'
	ammo_type = /obj/item/ammo_casing/magic/change
	icon_state = "staffofchange"
	inhand_icon_state = "staffofchange"
	school = SCHOOL_TRANSMUTATION
	/// If set, all wabbajacks this staff produces will be of this type, instead of random
	var/preset_wabbajack_type
	/// If set, all wabbajacks this staff produces will be of this changeflag, instead of only WABBAJACK
	var/preset_wabbajack_changeflag

/obj/item/gun/magic/staff/change/unrestricted
	allow_intruder_use = TRUE

/obj/item/gun/magic/staff/change/pickup(mob/user)
	. = ..()
	if(!is_wizard_or_friend(user))
		to_chat(user, span_hypnophrase("<span style='font-size: 24px'>你觉得自己不够强大，无法驾驭这支法杖!</span>"))
		balloon_alert(user, "拿着这根法杖你觉得很虚弱")

/obj/item/gun/magic/staff/change/on_intruder_use(mob/living/user, atom/target)
	user.dropItemToGround(src, TRUE)
	var/wabbajack_into = preset_wabbajack_type || pick(WABBAJACK_MONKEY, WABBAJACK_HUMAN, WABBAJACK_ANIMAL)
	var/mob/living/new_body = user.wabbajack(wabbajack_into, preset_wabbajack_changeflag)
	if(!new_body)
		return

	balloon_alert(new_body, "瓦巴杰克，瓦巴杰克!")

/obj/item/gun/magic/staff/animate
	name = "活力法杖"
	desc = "能射出生命之力的神器，能让被它击中的物体复活！但不会影响机器."
	fire_sound = 'sound/magic/staff_animation.ogg'
	ammo_type = /obj/item/ammo_casing/magic/animate
	icon_state = "staffofanimation"
	inhand_icon_state = "staffofanimation"
	school = SCHOOL_EVOCATION

/obj/item/gun/magic/staff/healing
	name = "治愈法杖"
	desc = "能射出恢复魔法的神器，可以治愈各种疾病，甚至起死回生."
	fire_sound = 'sound/magic/staff_healing.ogg'
	ammo_type = /obj/item/ammo_casing/magic/heal
	icon_state = "staffofhealing"
	inhand_icon_state = "staffofhealing"
	school = SCHOOL_RESTORATION
	/// Our internal healbeam, used if an intruder (non-magic person) tries to use our staff
	var/obj/item/gun/medbeam/healing_beam

/obj/item/gun/magic/staff/healing/pickup(mob/user)
	. = ..()
	if(!is_wizard_or_friend(user))
		to_chat(user, span_hypnophrase("<span style='font-size: 24px'>当你触摸它时，它的能量变弱了</span>"))
		user.balloon_alert(user, "魔杖能量在你触摸到的瞬间变弱了")

/obj/item/gun/magic/staff/healing/examine(mob/user)
	. = ..()
	if(!is_wizard_or_friend(user))
		. += span_notice("手柄上雕刻着美丽的高挑太空人形象，\"光柱不可相交.\"")

/obj/item/gun/magic/staff/healing/Initialize(mapload)
	. = ..()
	healing_beam = new(src)
	healing_beam.mounted = TRUE

/obj/item/gun/magic/staff/healing/Destroy()
	QDEL_NULL(healing_beam)
	return ..()

/obj/item/gun/magic/staff/healing/unrestricted
	allow_intruder_use = TRUE

/obj/item/gun/magic/staff/healing/on_intruder_use(mob/living/user, atom/target)
	if(target == user)
		return FALSE
	healing_beam.process_fire(target, user)
	return FALSE

/obj/item/gun/magic/staff/healing/dropped(mob/user)
	healing_beam.LoseTarget()
	return ..()

/obj/item/gun/magic/staff/healing/handle_suicide() //Stops people trying to commit suicide to heal themselves
	return

/obj/item/gun/magic/staff/chaos
	name = "混乱法杖"
	desc = "能释放出混乱魔法的神器，可以做到任何事."
	fire_sound = 'sound/magic/staff_chaos.ogg'
	ammo_type = /obj/item/ammo_casing/magic/chaos
	icon_state = "staffofchaos"
	inhand_icon_state = "staffofchaos"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1
	school = SCHOOL_FORBIDDEN //this staff is evil. okay? it just is. look at this projectile type list. this is wrong.

	/// List of all projectiles we can fire from our staff.
	/// Doesn't contain all subtypes of magic projectiles, unlike what it looks like
	var/list/allowed_projectile_types = list(
		/obj/projectile/magic/animate,
		/obj/projectile/magic/antimagic,
		/obj/projectile/magic/arcane_barrage,
		/obj/projectile/magic/bounty,
		///obj/projectile/magic/change, //SKYRAT EDIT REMOVAL
		/obj/projectile/magic/death,
		/obj/projectile/magic/door,
		/obj/projectile/magic/fetch,
		/obj/projectile/magic/fireball,
		/obj/projectile/magic/flying,
		/obj/projectile/magic/locker,
		/obj/projectile/magic/necropotence,
		/obj/projectile/magic/resurrection,
		/obj/projectile/magic/babel,
		/obj/projectile/magic/spellblade,
		/obj/projectile/magic/teleport,
		/obj/projectile/magic/wipe,
		/obj/projectile/temp/chill,
		/obj/projectile/magic/shrink
	)

/obj/item/gun/magic/staff/chaos/unrestricted
	allow_intruder_use = TRUE

/obj/item/gun/magic/staff/chaos/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	chambered.projectile_type = pick(allowed_projectile_types)
	return ..()

/obj/item/gun/magic/staff/chaos/on_intruder_use(mob/living/user)
	if(!user.can_cast_magic()) // Don't let people with antimagic use the staff of chaos.
		balloon_alert(user, "法杖拒绝开火!")
		return FALSE

	if(prob(95)) // You have a 5% chance of hitting yourself when using the staff of chaos.
		return TRUE
	balloon_alert(user, "混沌!")
	user.dropItemToGround(src, TRUE)
	process_fire(user, user, FALSE)
	return FALSE

/**
 * Staff of chaos given to the wizard upon completing a cheesy grand ritual. Is completely evil and if something
 * breaks, it's completely intended. Fuck off.
 * Also can be used by everyone, because why not.
 */
/obj/item/gun/magic/staff/chaos/true_wabbajack
	name = "瓦巴杰克"
	desc = "如果真有神灵，他们在创造这个之前肯定没有经过心理咨询."
	icon_state = "the_wabbajack"
	inhand_icon_state = "the_wabbajack"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF //fuck you
	max_charges = 999999 //fuck you
	recharge_rate = 1
	allow_intruder_use = TRUE

/obj/item/gun/magic/staff/chaos/true_wabbajack/Initialize(mapload)
	. = ..()
	allowed_projectile_types |= subtypesof(/obj/projectile/bullet/cannonball)
	allowed_projectile_types |= subtypesof(/obj/projectile/bullet/rocket)
	allowed_projectile_types |= subtypesof(/obj/projectile/energy/tesla)
	allowed_projectile_types |= subtypesof(/obj/projectile/magic)
	allowed_projectile_types |= subtypesof(/obj/projectile/temp)
	allowed_projectile_types |= list(
		/obj/projectile/beam/mindflayer,
		/obj/projectile/bullet/gyro,
		/obj/projectile/bullet/honker,
		/obj/projectile/bullet/mime,
		/obj/projectile/curse_hand,
		/obj/projectile/energy/electrode,
		/obj/projectile/energy/net,
		/obj/projectile/energy/nuclear_particle,
		/obj/projectile/gravityattract,
		/obj/projectile/gravitychaos,
		/obj/projectile/gravityrepulse,
		/obj/projectile/ion,
		/obj/projectile/meteor,
		/obj/projectile/neurotoxin,
		/obj/projectile/plasma,
	) //if you ever try to expand this list, avoid adding bullets/energy projectiles, this ain't supposed to be a gun... unless it's funny

/obj/item/gun/magic/staff/door
	name = "造门法杖"
	desc = "能释放变形魔法的神器，可以在墙上造出门来."
	fire_sound = 'sound/magic/staff_door.ogg'
	ammo_type = /obj/item/ammo_casing/magic/door
	icon_state = "staffofdoor"
	inhand_icon_state = "staffofdoor"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1
	school = SCHOOL_TRANSMUTATION

/obj/item/gun/magic/staff/honk
	name = "小丑之母法杖"
	desc = "Honk."
	fire_sound = 'sound/items/airhorn.ogg'
	ammo_type = /obj/item/ammo_casing/magic/honk
	icon_state = "honker"
	inhand_icon_state = "honker"
	max_charges = 4
	recharge_rate = 8
	school = SCHOOL_EVOCATION

/obj/item/gun/magic/staff/spellblade
	name = "魔刃"
	desc = "怠惰与嗜血的致命结合，这把剑可以让使用者毫不费力地肢解敌人."
	fire_sound = 'sound/magic/fireball.ogg'
	ammo_type = /obj/item/ammo_casing/magic/spellblade
	icon_state = "spellblade"
	inhand_icon_state = "spellblade"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/rapierhit.ogg'
	block_sound = 'sound/weapons/parry.ogg'
	force = 20
	armour_penetration = 75
	block_chance = 50
	sharpness = SHARP_EDGED
	max_charges = 4
	school = SCHOOL_EVOCATION

/obj/item/gun/magic/staff/spellblade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
		speed = 1.5 SECONDS, \
		effectiveness = 125, \
		bonus_modifier = 0, \
		butcher_sound = hitsound, \
	)

/obj/item/gun/magic/staff/spellblade/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == PROJECTILE_ATTACK || attack_type == LEAP_ATTACK)
		final_block_chance = 0 //Don't bring a sword to a gunfight, and also you aren't going to really block someone full body tackling you with a sword
	return ..()

/obj/item/gun/magic/staff/locker
	name = "秘法锁柜法杖"
	desc = "能射出秘法锁柜的神器，使你的敌人丧失行为能力."
	fire_sound = 'sound/magic/staff_change.ogg'
	ammo_type = /obj/item/ammo_casing/magic/locker
	icon_state = "locker"
	inhand_icon_state = "locker"
	worn_icon_state = "lockerstaff"
	max_charges = 6
	recharge_rate = 4
	school = SCHOOL_TRANSMUTATION //in a way

//yes, they don't have sounds. they're admin staves, and their projectiles will play the chaos bolt sound anyway so why bother?

/obj/item/gun/magic/staff/flying
	name = "飞行术法杖"
	desc = "能释放出优雅魔法的神器，能让东西飞出去."
	fire_sound = 'sound/magic/staff_healing.ogg'
	ammo_type = /obj/item/ammo_casing/magic/flying
	icon_state = "staffofflight"
	inhand_icon_state = "staffofchange"
	worn_icon_state = "flightstaff"
	school = SCHOOL_EVOCATION

/obj/item/gun/magic/staff/babel
	name = "巴别法杖"
	desc = "能释放出混乱魔法的神器，能让人绝望，语无伦次."
	fire_sound = 'sound/magic/staff_change.ogg'
	ammo_type = /obj/item/ammo_casing/magic/babel
	icon_state = "staffofbabel"
	inhand_icon_state = "staffofdoor"
	worn_icon_state = "babelstaff"
	school = SCHOOL_FORBIDDEN //evil

/obj/item/gun/magic/staff/necropotence
	name = "亡灵法杖"
	desc = "能释放死亡魔法的神器可以改变灵魂的归途."
	fire_sound = 'sound/magic/staff_change.ogg'
	ammo_type = /obj/item/ammo_casing/magic/necropotence
	icon_state = "staffofnecropotence"
	inhand_icon_state = "staffofchaos"
	worn_icon_state = "necrostaff"
	school = SCHOOL_NECROMANCY //REALLY evil

/obj/item/gun/magic/staff/wipe
	name = "附体法杖"
	desc = "能释放出灵魂解锁魔法的神器，能让灵魂侵入目标的身心."
	fire_sound = 'sound/magic/staff_change.ogg'
	ammo_type = /obj/item/ammo_casing/magic/wipe
	icon_state = "staffofwipe"
	inhand_icon_state = "pharoah_sceptre"
	worn_icon_state = "wipestaff"
	school = SCHOOL_FORBIDDEN //arguably the worst staff in the entire game effect wise

/obj/item/gun/magic/staff/shrink
	name = "缩小法杖"
	desc = "一种能够射出缩小闪电的器物，很容易被误认成魔杖."
	fire_sound = 'sound/magic/staff_shrink.ogg'
	ammo_type = /obj/item/ammo_casing/magic/shrink
	icon_state = "shrinkstaff"
	inhand_icon_state = "staff"
	max_charges = 10 // slightly more/faster charges since this will be used on walls and such
	recharge_rate = 5
	no_den_usage = TRUE
	school = SCHOOL_TRANSMUTATION
	slot_flags = NONE //too small to wear on your back
	w_class = WEIGHT_CLASS_NORMAL //but small enough for a bag
