/obj/item/tome
	name = "神秘古书"
	desc = "一本满是灰尘的旧书，边缘磨损，封面看起来也很邪恶."
	icon = 'icons/obj/antags/cult/items.dmi'
	icon_state ="tome"
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL

/obj/item/melee/cultblade/dagger
	name = "仪式匕首"
	desc = "一把奇怪的匕首，据说被邪恶的团体用于 \"装点\" 尸体，然后把它献给他们的黑暗神祇."
	icon = 'icons/obj/weapons/khopesh.dmi'
	icon_state = "render"
	inhand_icon_state = "cultdagger"
	worn_icon_state = "render"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	w_class = WEIGHT_CLASS_SMALL
	force = 15
	throwforce = 25
	block_chance = 25
	wound_bonus = -10
	bare_wound_bonus = 20
	armour_penetration = 35
	block_sound = 'sound/weapons/parry.ogg'

/obj/item/melee/cultblade/dagger/Initialize(mapload)
	. = ..()
	var/image/silicon_image = image(icon = 'icons/effects/blood.dmi' , icon_state = null, loc = src)
	silicon_image.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "cult_dagger", silicon_image)

	var/examine_text = {"解锁抄写Nar'Sie崇拜的血符文.
击打血教建筑可以将其固定或解除固定. 血教结构梁将在单次击打中被摧毁.
可以用来刮掉血符文，清除任何痕迹.
攻击教徒会清除他们身上所有的圣水成分，并将其变为邪水.
攻击非教徒只会撕裂其血肉."}

	AddComponent(/datum/component/cult_ritual_item, span_cult(examine_text))

/obj/item/melee/cultblade/dagger/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "攻击", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	var/block_message = "[owner]闪避了[src]的[attack_text]!"
	if(owner.get_active_held_item() != src)
		block_message = "[owner]闪避了[src]的[attack_text]!"

	if(IS_CULTIST(owner) && prob(final_block_chance) && attack_type != PROJECTILE_ATTACK)
		new /obj/effect/temp_visual/cult/sparks(get_turf(owner))
		owner.visible_message(span_danger("[block_message]"))
		return TRUE
	else
		return FALSE

/obj/item/melee/cultblade
	name = "邪血长剑"
	desc = "一把充满邪恶力量的长剑，发出微弱的红光."
	icon = 'icons/obj/weapons/sword.dmi'
	icon_state = "cultblade"
	inhand_icon_state = "cultblade"
	worn_icon_state = "cultblade"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	obj_flags = CONDUCTS_ELECTRICITY
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_BULKY
	force = 30 // whoever balanced this got beat in the head by a bible too many times good lord
	throwforce = 10
	block_chance = 50 // now it's officially a cult esword
	wound_bonus = -50
	bare_wound_bonus = 20
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_sound = 'sound/weapons/parry.ogg'
	attack_verb_continuous = list("攻击", "竖劈", "劈砍", "劈斩", "切斩", "猛砸", "挑刺")
	attack_verb_simple = list("攻击", "竖劈", "劈砍", "劈斩", "切斩", "猛砸", "挑刺")

/obj/item/melee/cultblade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 4 SECONDS, \
	effectiveness = 100, \
	)

/obj/item/melee/cultblade/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "攻击", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(IS_CULTIST(owner) && prob(final_block_chance))
		new /obj/effect/temp_visual/cult/sparks(get_turf(owner))
		owner.visible_message(span_danger("[owner]闪避了[src]的[attack_text]!"))
		return TRUE
	else
		return FALSE

/obj/item/melee/cultblade/attack(mob/living/target, mob/living/carbon/human/user)
	if(!IS_CULTIST(user))
		user.Paralyze(100)
		user.dropItemToGround(src, TRUE)
		user.visible_message(span_warning("一股强大的力量将[user]推离[target]!"), \
				span_cult_large("\"你不应该玩这么锐利的东西，你会把别人的眼睛戳出来的.\""))
		if(ishuman(user))
			var/mob/living/carbon/human/miscreant = user
			miscreant.apply_damage(rand(force/2, force), BRUTE, pick(GLOB.arm_zones))
		else
			user.adjustBruteLoss(rand(force/2,force))
		return
	..()

/obj/item/melee/cultblade/ghost
	name = "邪血剑"
	force = 19 //can't break normal airlocks
	item_flags = NEEDS_PERMIT | DROPDEL
	flags_1 = NONE
	block_chance = 25 //these dweebs don't get full block chance, because they're free cultists
	block_sound = 'sound/weapons/parry.ogg'

/obj/item/melee/cultblade/ghost/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)

/obj/item/melee/cultblade/pickup(mob/living/user)
	..()
	if(!IS_CULTIST(user))
		to_chat(user, span_cult_large("\"我不建议这么做.\""))

/datum/action/innate/dash/cult
	name = "揭开帷幕"
	desc = "用这把剑划开现实的脆弱结构，传送到你的目标位置."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "phaseshift"
	dash_sound = 'sound/magic/enter_blood.ogg'
	recharge_sound = 'sound/magic/exit_blood.ogg'
	beam_effect = "sendbeam"
	phasein = /obj/effect/temp_visual/dir_setting/cult/phase
	phaseout = /obj/effect/temp_visual/dir_setting/cult/phase/out

/datum/action/innate/dash/cult/IsAvailable(feedback = FALSE)
	if(IS_CULTIST(owner) && current_charges)
		return TRUE
	else
		return FALSE

/obj/item/restraints/legcuffs/bola/cult
	name = "\improper Nar'Sie流星索"
	desc = "强大的流星索，用黑魔法绑在了一起，可以让它无害地穿过Nar'Sie教徒，扔出去来绊倒你的目标，拖慢他的速度."
	icon_state = "bola_cult"
	inhand_icon_state = "bola_cult"
	breakouttime = 6 SECONDS
	knockdown = 30

#define CULT_BOLA_PICKUP_STUN (6 SECONDS)
/obj/item/restraints/legcuffs/bola/cult/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()

	if(IS_CULTIST(user) || !iscarbon(user))
		return
	var/mob/living/carbon/carbon_user = user
	if(user.num_legs < 2 || carbon_user.legcuffed) //if they can't be ensnared, stun for the same time as it takes to breakout of bola
		to_chat(user, span_cult_large("\"我不建议这么做.\""))
		user.dropItemToGround(src, TRUE)
		user.Paralyze(CULT_BOLA_PICKUP_STUN)
	else
		to_chat(user, span_warning("这条流星索好像有自己的生命!"))
		ensnare(user)
#undef CULT_BOLA_PICKUP_STUN


/obj/item/restraints/legcuffs/bola/cult/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/mob/hit_mob = hit_atom
	if (istype(hit_mob) && IS_CULTIST(hit_mob))
		return
	. = ..()


/obj/item/clothing/head/hooded/cult_hoodie
	name = "古代血教兜帽"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "culthood"
	inhand_icon_state = "culthood"
	desc = "满是灰尘的破旧兜帽，里面排列着奇怪的字母."
	flags_inv = HIDEFACE|HIDEHAIR|HIDEEARS
	flags_cover = HEADCOVERSEYES
	armor_type = /datum/armor/hooded_cult_hoodie
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT

/datum/armor/hooded_cult_hoodie
	melee = 40
	bullet = 30
	laser = 40
	energy = 40
	bomb = 25
	bio = 10
	fire = 10
	acid = 10

/obj/item/clothing/suit/hooded/cultrobes
	name = "古代血教长袍"
	desc = "满是灰尘的破旧长袍，里面排列着奇怪的字母."
	icon_state = "cultrobes"
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'
	inhand_icon_state = "cultrobes"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	armor_type = /datum/armor/hooded_cultrobes
	flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|ARMS
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie
	/// Whether the hood is flipped up
	var/hood_up = FALSE

/// Called when the hood is worn
/obj/item/clothing/suit/hooded/cultrobes/on_hood_up(obj/item/clothing/head/hooded/hood)
	hood_up = TRUE

/// Called when the hood is hidden
/obj/item/clothing/suit/hooded/cultrobes/on_hood_down(obj/item/clothing/head/hooded/hood)
	hood_up = FALSE

/datum/armor/hooded_cultrobes
	melee = 40
	bullet = 30
	laser = 40
	energy = 40
	bomb = 25
	bio = 10
	fire = 10
	acid = 10

/obj/item/clothing/head/hooded/cult_hoodie/alt
	name = "血教兜帽"
	desc = "Nar'Sie追随者所戴的一种带有装甲的兜帽."
	icon_state = "cult_hoodalt"
	inhand_icon_state = null

/obj/item/clothing/suit/hooded/cultrobes/alt
	name = "血教长袍"
	desc = "Nar'Sie追随者所戴的一种带有装甲的长袍."
	icon_state = "cultrobesalt"
	inhand_icon_state = null
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/alt

/obj/item/clothing/suit/hooded/cultrobes/alt/ghost
	item_flags = DROPDEL

/obj/item/clothing/suit/hooded/cultrobes/alt/ghost/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)

/obj/item/clothing/head/wizard/magus
	name = "血法头盔"
	icon_state = "magus"
	inhand_icon_state = null
	desc = "Nar'Sie追随者所佩戴的头盔."
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEARS|HIDEEYES|HIDESNOUT
	armor_type = /datum/armor/wizard_magus
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/datum/armor/wizard_magus
	melee = 50
	bullet = 30
	laser = 50
	energy = 50
	bomb = 25
	bio = 10
	fire = 10
	acid = 10

/obj/item/clothing/suit/magusred
	name = "血法盔甲"
	desc = "Nar'Sie追随者所穿戴的带甲长袍"
	icon_state = "magusred"
	icon = 'icons/obj/clothing/suits/wizard.dmi'
	worn_icon = 'icons/mob/clothing/suits/wizard.dmi'
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	armor_type = /datum/armor/suit_magusred
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/datum/armor/suit_magusred
	melee = 50
	bullet = 30
	laser = 50
	energy = 50
	bomb = 25
	bio = 10
	fire = 10
	acid = 10

/obj/item/clothing/suit/hooded/cultrobes/hardened
	name = "\improper Nar'Sie硬化甲"
	desc = "Nar'Sie信徒中战士所穿戴的重甲，可以承受真空."
	icon_state = "cult_armor"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade, /obj/item/tank/internals)
	armor_type = /datum/armor/cultrobes_hardened
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/hardened
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	flags_inv = HIDEGLOVES | HIDEJUMPSUIT | HIDETAIL // SKYRAT EDIT ADDITION - HIDETAIL
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = NONE

/datum/armor/cultrobes_hardened
	melee = 50
	bullet = 40
	laser = 50
	energy = 60
	bomb = 50
	bio = 100
	fire = 100
	acid = 100

/obj/item/clothing/head/hooded/cult_hoodie/hardened
	name = "\improper Nar'Sie硬化盔"
	desc = "Nar'Sie信徒中战士所穿戴的重盔，可以承受真空."
	icon_state = "cult_helmet"
	inhand_icon_state = null
	armor_type = /datum/armor/cult_hoodie_hardened
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT | STACKABLE_HELMET_EXEMPT | HEADINTERNALS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flash_protect = FLASH_PROTECTION_WELDER
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE

/datum/armor/cult_hoodie_hardened
	melee = 50
	bullet = 40
	laser = 50
	energy = 60
	bomb = 50
	bio = 100
	fire = 100
	acid = 100

/obj/item/sharpener/cult
	name = "邪恶磨刀石"
	desc = "一个被黑魔法附魔的方块，在磨刀石上使用锋利的武器来强化."
	icon = 'icons/obj/antags/cult/items.dmi'
	icon_state = "cult_sharpener"
	uses = 1
	increment = 5
	max = 40
	prefix = "darkened"

/obj/item/sharpener/cult/update_icon_state()
	icon_state = "cult_sharpener[(uses == 0) ? "_used" : ""]"
	return ..()

/obj/item/clothing/suit/hooded/cultrobes/cult_shield
	name = "强化血教护甲"
	desc = "能在使用者周围产生强力护盾的强化护甲."
	icon_state = "cult_armor"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	armor_type = /datum/armor/cultrobes_cult_shield
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/cult_shield

/datum/armor/cultrobes_cult_shield
	melee = 50
	bullet = 40
	laser = 50
	energy = 50
	bomb = 50
	bio = 30
	fire = 50
	acid = 60

/obj/item/clothing/suit/hooded/cultrobes/cult_shield/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/shielded, \
		recharge_start_delay = 0 SECONDS, \
		shield_icon_file = 'icons/effects/cult.dmi', \
		shield_icon = "shield-cult", \
		run_hit_callback = CALLBACK(src, PROC_REF(shield_damaged)), \
	)

/// A proc for callback when the shield breaks, since cult robes are stupid and have different effects
/obj/item/clothing/suit/hooded/cultrobes/cult_shield/proc/shield_damaged(mob/living/wearer, attack_text, new_current_charges)
	wearer.visible_message(span_danger("随着一阵血色火花，[wearer]的长袍中和了[attack_text]!"))
	new /obj/effect/temp_visual/cult/sparks(get_turf(wearer))
	if(new_current_charges == 0)
		wearer.visible_message(span_danger("[wearer]周身的符文护盾突然消失了!"))

/obj/item/clothing/head/hooded/cult_hoodie/cult_shield
	name = "强化血教头盔"
	desc = "能在使用者周围产生强力护盾的强化头盔."
	icon_state = "cult_hoodalt"
	armor_type = /datum/armor/cult_hoodie_cult_shield

/datum/armor/cult_hoodie_cult_shield
	melee = 50
	bullet = 40
	laser = 50
	energy = 50
	bomb = 50
	bio = 30
	fire = 50
	acid = 60

/obj/item/clothing/suit/hooded/cultrobes/cult_shield/equipped(mob/living/user, slot)
	..()
	if(!IS_CULTIST(user))
		to_chat(user, span_cult_large("\"我不建议这么做.\""))
		to_chat(user, span_warning("一种强烈的恶心感压倒了你!"))
		user.dropItemToGround(src, TRUE)
		user.set_dizzy_if_lower(1 MINUTES)
		user.Paralyze(100)

/obj/item/clothing/suit/hooded/cultrobes/berserker
	name = "苦修者长袍"
	desc = "染血长袍中被注入了黑魔法; 允许穿戴者以非人的速度移动，但代价是受到的伤害增加. 如果戴上兜帽，则获得速度还会更快."
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	armor_type = /datum/armor/cultrobes_berserker
	slowdown = -0.3 //the hood gives an additional -0.3 if you have it flipped up, for a total of -0.6
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/berserkerhood

/datum/armor/cultrobes_berserker
	melee = -45
	bullet = -45
	laser = -45
	energy = -55
	bomb = -45

/obj/item/clothing/head/hooded/cult_hoodie/berserkerhood
	name = "苦修者兜帽"
	desc = "染血兜帽中被注入了黑魔法."
	armor_type = /datum/armor/cult_hoodie_berserkerhood
	slowdown = -0.3

/datum/armor/cult_hoodie_berserkerhood
	melee = -45
	bullet = -45
	laser = -45
	energy = -55
	bomb = -45

/obj/item/clothing/suit/hooded/cultrobes/berserker/equipped(mob/living/user, slot)
	..()
	if(!IS_CULTIST(user))
		to_chat(user, span_cult_large("\"我不建议这么做.\""))
		to_chat(user, span_warning("一种强烈的恶心感压倒了你!"))
		user.dropItemToGround(src, TRUE)
		user.set_dizzy_if_lower(1 MINUTES)
		user.Paralyze(100)

/obj/item/clothing/glasses/hud/health/night/cultblind
	desc = "愿Nar'Sie指引你穿过黑暗，遮蔽光明."
	flags_cover = GLASSESCOVERSEYES
	name = "狂热者眼罩"
	icon_state = "blindfold"
	inhand_icon_state = "blindfold"
	flash_protect = FLASH_PROTECTION_WELDER

/obj/item/clothing/glasses/hud/health/night/cultblind/equipped(mob/living/user, slot)
	..()
	if(user.stat != DEAD && !IS_CULTIST(user) && (slot & ITEM_SLOT_EYES))
		to_chat(user, span_cult_large("\"你希望失明吗?\""))
		user.dropItemToGround(src, TRUE)
		user.set_dizzy_if_lower(1 MINUTES)
		user.Paralyze(100)
		user.adjust_temp_blindness(60 SECONDS)

/obj/item/reagent_containers/cup/beaker/unholywater
	name = "邪水瓶"
	desc = "对不信者有害. 可以让人重拾信仰 - 通过喝或者扔出去到目标身上."
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "unholyflask"
	inhand_icon_state = "holyflask"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/fuel/unholywater = 50)

///how many times can the shuttle be cursed?
#define MAX_SHUTTLE_CURSES 3
///if the max number of shuttle curses are used within this duration, the entire cult gets an achievement
#define SHUTTLE_CURSE_OMFG_TIMESPAN (10 SECONDS)

/obj/item/shuttle_curse
	name = "诅咒之球"
	desc = "你凝视着这颗烟雾弥漫的球体，瞥见了应急逃生穿梭机的可怕命运."
	icon = 'icons/obj/antags/cult/items.dmi'
	icon_state = "shuttlecurse"
	///how many times has the shuttle been cursed so far?
	var/static/totalcurses = 0
	///when was the first shuttle curse?
	var/static/first_curse_time
	///curse messages that have already been used
	var/static/list/remaining_curses

/obj/item/shuttle_curse/attack_self(mob/living/user)
	if(!IS_CULTIST(user))
		user.dropItemToGround(src, TRUE)
		user.Paralyze(100)
		to_chat(user, span_warning("一股强大的力量将你推离[src]!"))
		return
	if(totalcurses >= MAX_SHUTTLE_CURSES)
		to_chat(user, span_warning("你试图打碎这颗球体，但它如岩石一样坚固!"))
		to_chat(user, span_danger(span_big("看来血教已经耗尽了诅咒应急逃生穿梭机的能力，制造更多魔法球或者继续试图粉碎这个魔法球都是没有用的.")))
		return
	if(locate(/obj/narsie) in SSpoints_of_interest.narsies)
		to_chat(user, span_warning("Nar'Sie已经在这架穿梭机上了，结局不会有延误."))
		return

	if(SSshuttle.emergency.mode == SHUTTLE_CALL)
		var/cursetime = 3 MINUTES
		var/timer = SSshuttle.emergency.timeLeft(1) + cursetime
		var/security_num = SSsecurity_level.get_current_level_as_number()
		var/set_coefficient = 1

		if(totalcurses == 0)
			first_curse_time = world.time

		switch(security_num)
			if(SEC_LEVEL_GREEN)
				set_coefficient = 2
			if(SEC_LEVEL_BLUE)
				set_coefficient = 1
			else
				set_coefficient = 0.5
		var/surplus = timer - (SSshuttle.emergency_call_time * set_coefficient)
		SSshuttle.emergency.setTimer(timer)
		if(surplus > 0)
			SSshuttle.block_recall(surplus)
		totalcurses++
		to_chat(user, span_danger("你粉碎了魔法球，黑暗的物质在上空盘旋，然后消失了."))
		playsound(user.loc, 'sound/effects/glassbr1.ogg', 50, TRUE)

		if(!remaining_curses)
			remaining_curses = strings(CULT_SHUTTLE_CURSE, "curse_announce")

		var/curse_message = pick_n_take(remaining_curses) || "有些事情出现了可怕的问题..."

		curse_message += " 穿梭机将晚点三分钟."
		priority_announce("[curse_message]", "系统错误", 'sound/misc/notice1.ogg')
		if(MAX_SHUTTLE_CURSES-totalcurses <= 0)
			to_chat(user, span_danger(span_big("你感到应急逃生穿梭机已经不能再被诅咒了，制造更多的诅咒魔法球也没有用了.")))
		else if(MAX_SHUTTLE_CURSES-totalcurses == 1)
			to_chat(user, span_danger(span_big("你感到应急逃生穿梭机只能再被诅咒一次了.")))
		else
			to_chat(user, span_danger(span_big("你感到应急逃生穿梭机只能再被诅咒[MAX_SHUTTLE_CURSES-totalcurses]次了.")))

		if(totalcurses >= MAX_SHUTTLE_CURSES && (world.time < first_curse_time + SHUTTLE_CURSE_OMFG_TIMESPAN))
			var/omfg_message = pick_list(CULT_SHUTTLE_CURSE, "omfg_announce") || "别来烦我!"
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(priority_announce), omfg_message, "最高警报", 'sound/misc/announce_syndi.ogg', null, "纳米交通运输部: 中央指挥部"), rand(2 SECONDS, 6 SECONDS))
			for(var/mob/iter_player as anything in GLOB.player_list)
				if(IS_CULTIST(iter_player))
					iter_player.client?.give_award(/datum/award/achievement/misc/cult_shuttle_omfg, iter_player)

		qdel(src)

#undef MAX_SHUTTLE_CURSES

/obj/item/cult_shift
	name = "帷幕相移叉"
	desc = "该遗物会瞬间将你和你拉着的任何东西向前传送一定距离."
	icon = 'icons/obj/antags/cult/items.dmi'
	icon_state ="shifter"
	///How many uses does the item have before becoming inert
	var/uses = 4

/obj/item/cult_shift/examine(mob/user)
	. = ..()
	if(uses)
		. += span_cult("它还有[uses]次使用次数.")
	else
		. += span_cult("它用尽次数了.")

///Handles teleporting the atom we're pulling along with us when using the shifter
/obj/item/cult_shift/proc/handle_teleport_grab(turf/target_turf, mob/user)
	var/mob/living/carbon/pulling_user = user
	if(pulling_user.pulling)
		var/atom/movable/pulled = pulling_user.pulling
		do_teleport(pulled, target_turf, channel = TELEPORT_CHANNEL_CULT)
		. = pulled

/obj/item/cult_shift/attack_self(mob/user)
	if(!uses || !iscarbon(user))
		to_chat(user, span_warning("[src]在你的手中停滞不动."))
		return
	if(!IS_CULTIST(user))
		user.dropItemToGround(src, TRUE)
		step(src, pick(GLOB.alldirs))
		to_chat(user, span_warning("[src]在你手中熄灭，你与这个维度的联系过于紧密!"))
		return

	//The user of the shifter
	var/mob/living/carbon/user_cultist = user
	//Initial teleport location
	var/turf/mobloc = get_turf(user_cultist)
	//Teleport target turf, with some error to spice it up
	var/turf/destination = get_teleport_loc(location = mobloc, target = user_cultist, distance = 9, density_check = TRUE, errorx = 3, errory = 1, eoffsety = 1)
	//The atom the user was pulling when using the shifter; we handle it here before teleporting the user as to not lose their 'pulling' var
	var/atom/movable/pulled = handle_teleport_grab(destination, user_cultist)

	if(!destination || !do_teleport(user_cultist, destination, channel = TELEPORT_CHANNEL_CULT))
		playsound(src, 'sound/items/haunted/ghostitemattack.ogg', 100, TRUE)
		balloon_alert(user, "传送失败!")
		return

	uses--
	if(uses <= 0)
		icon_state = "shifter_drained"

	if(pulled)
		user_cultist.start_pulling(pulled) //forcemove (teleporting) resets pulls, so we need to re-pull

	new /obj/effect/temp_visual/dir_setting/cult/phase/out(mobloc, user_cultist.dir)
	new /obj/effect/temp_visual/dir_setting/cult/phase(destination, user_cultist.dir)

	playsound(mobloc, SFX_PORTAL_ENTER, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	playsound(destination, 'sound/effects/phasein.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	playsound(destination, SFX_PORTAL_ENTER, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/obj/item/flashlight/flare/culttorch
	name = "虚空火炬"
	desc = "由资深的教徒使用，可以立刻将物品运送给他们需要的兄弟."
	w_class = WEIGHT_CLASS_SMALL
	light_range = 1
	icon_state = "torch"
	inhand_icon_state = "torch"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	color = "#ff0000"
	on_damage = 15
	slot_flags = null
	var/charges = 5
	start_on = TRUE

/obj/item/flashlight/flare/culttorch/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/datum/antagonist/cult/cult = user.mind.has_antag_datum(/datum/antagonist/cult)
	var/datum/team/cult/cult_team = cult?.get_team()
	if(isnull(cult_team))
		to_chat(user, span_warning("这似乎没什么用."))
		return ITEM_INTERACT_BLOCKING

	if(!isitem(interacting_with))
		to_chat(user, span_warning("[src]只能传送物品!"))
		return ITEM_INTERACT_BLOCKING

	var/list/mob/living/cultists = list()
	for(var/datum/mind/cult_mind as anything in cult_team.members)
		if(cult_mind == user.mind)
			continue
		if(cult_mind.current?.stat != DEAD)
			cultists |= cult_mind.current

	var/mob/living/cultist_to_receive = tgui_input_list(user, "你希望呼唤谁到[src]?", "几何血尊追随者", (cultists - user))
	if(QDELETED(src) || loc != user || user.incapacitated())
		return ITEM_INTERACT_BLOCKING
	if(isnull(cultist_to_receive))
		to_chat(user, span_cult_italic("你需要一个目的地!"))
		return ITEM_INTERACT_BLOCKING
	if(cultist_to_receive.stat == DEAD)
		to_chat(user, span_cult_italic("[cultist_to_receive]已经死了!"))
		return ITEM_INTERACT_BLOCKING
	if(!(cultist_to_receive.mind in cult_team.members))
		to_chat(user, span_cult_italic("[cultist_to_receive]不是几何血尊追随者!"))
		return ITEM_INTERACT_BLOCKING
	if(!isturf(interacting_with.loc))
		to_chat(user, span_cult_italic("[interacting_with]必须在一个表面上才能传送它!"))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_cult_italic("你用[src]点燃了[interacting_with], 把它变成了灰烬, \
		但透过火光, 你看到[interacting_with]已经到达了[cultist_to_receive]!"))
	user.log_message("用[src]传送[interacting_with]到[cultist_to_receive].", LOG_GAME)
	cultist_to_receive.put_in_hands(interacting_with)
	charges--
	to_chat(user, span_notice("[src]还能使用[charges]次."))
	if(charges <= 0)
		qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/melee/cultblade/halberd
	name = "血戟"
	desc = "一把不定型的戟，由凝结的血液构成，它似乎与其创造者有联系. 不得不说，与其说是戟，不如说是长柄战斧.."
	icon = 'icons/obj/weapons/spear.dmi'
	icon_state = "occultpoleaxe0"
	base_icon_state = "occultpoleaxe"
	inhand_icon_state = "occultpoleaxe0"
	w_class = WEIGHT_CLASS_HUGE
	force = 17
	throwforce = 40
	throw_speed = 2
	armour_penetration = 30
	block_chance = 30
	slot_flags = null
	attack_verb_continuous = list("攻击", "切砍", "平勾", "横刺", "挑击", "劈刺")
	attack_verb_simple = list("攻击", "切砍", "平勾", "横刺", "挑击", "劈刺")
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_sound = 'sound/weapons/parry.ogg'
	var/datum/action/innate/cult/halberd/halberd_act

/obj/item/melee/cultblade/halberd/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
		speed = 10 SECONDS, \
		effectiveness = 90, \
	)
	AddComponent(/datum/component/two_handed, \
		force_unwielded = 17, \
		force_wielded = 24, \
	)

/obj/item/melee/cultblade/halberd/update_icon_state()
	icon_state = HAS_TRAIT(src, TRAIT_WIELDED) ? "[base_icon_state]1" : "[base_icon_state]0"
	inhand_icon_state = HAS_TRAIT(src, TRAIT_WIELDED) ? "[base_icon_state]1" : "[base_icon_state]0"
	return ..()

/obj/item/melee/cultblade/halberd/Destroy()
	if(halberd_act)
		QDEL_NULL(halberd_act)
	return ..()

/obj/item/melee/cultblade/halberd/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/turf/T = get_turf(hit_atom)
	if(isliving(hit_atom))
		var/mob/living/target = hit_atom

		if(IS_CULTIST(target) && target.put_in_active_hand(src))
			playsound(src, 'sound/weapons/throwtap.ogg', 50)
			target.visible_message(span_warning("[target]接住了[src]!"))
			return
		if(target.can_block_magic() || IS_CULTIST(target))
			target.visible_message(span_warning("[src]从[target]上弹开，似乎被一股看不见的力量所排斥!"))
			return
		if(!..())
			target.Paralyze(50)
			break_halberd(T)
	else
		..()

/obj/item/melee/cultblade/halberd/proc/break_halberd(turf/T)
	if(src)
		if(!T)
			T = get_turf(src)
		if(T)
			T.visible_message(span_warning("[src]粉碎并融化成血!"))
			new /obj/effect/temp_visual/cult/sparks(T)
			new /obj/effect/decal/cleanable/blood/splatter(T)
			playsound(T, 'sound/effects/glassbr3.ogg', 100)
	qdel(src)

/obj/item/melee/cultblade/halberd/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "攻击", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(HAS_TRAIT(src, TRAIT_WIELDED))
		final_block_chance *= 2
	if(IS_CULTIST(owner) && prob(final_block_chance))
		owner.visible_message(span_danger("[owner]闪避了[src]的[attack_text]!"))
		new /obj/effect/temp_visual/cult/sparks(get_turf(owner))
		return TRUE
	else
		return FALSE

/datum/action/innate/cult/halberd
	name = "鲜血纽带"
	desc = "唤回那把血戟!"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	button_icon_state = "bloodspear"
	default_button_position = "6:157,4:-2"
	var/obj/item/melee/cultblade/halberd/halberd
	var/cooldown = 0

/datum/action/innate/cult/halberd/Grant(mob/user, obj/blood_halberd)
	. = ..()
	halberd = blood_halberd

/datum/action/innate/cult/halberd/Activate()
	if(owner == halberd.loc || cooldown > world.time)
		return
	var/halberd_location = get_turf(halberd)
	var/owner_location = get_turf(owner)
	if(get_dist(owner_location, halberd_location) > 10)
		to_chat(owner,span_cult("血戟离得太远了!"))
	else
		cooldown = world.time + 20
		if(isliving(halberd.loc))
			var/mob/living/current_owner = halberd.loc
			current_owner.dropItemToGround(halberd)
			current_owner.visible_message(span_warning("一股看不见的力量从[current_owner]的手中夺走了血戟!"))
		halberd.throw_at(owner, 10, 2, owner)


/obj/item/gun/magic/wand/arcane_barrage/blood
	name = "血弹幕"
	desc = "以牙还牙."
	color = "#ff0000"
	ammo_type =  /obj/item/ammo_casing/magic/arcane_barrage/blood
	fire_sound = 'sound/magic/wand_teleport.ogg'

/obj/item/ammo_casing/magic/arcane_barrage/blood
	projectile_type = /obj/projectile/magic/arcane_barrage/blood
	firing_effect_type = /obj/effect/temp_visual/cult/sparks

/obj/projectile/magic/arcane_barrage/blood
	name = "血弹幕子弹"
	icon_state = "mini_leaper"
	nondirectional_sprite = TRUE
	damage_type = BRUTE
	impact_effect_type = /obj/effect/temp_visual/dir_setting/bloodsplatter

/obj/projectile/magic/arcane_barrage/blood/Bump(atom/target)
	. = ..()
	var/turf/our_turf = get_turf(target)
	playsound(our_turf , 'sound/effects/splat.ogg', 50, TRUE)
	new /obj/effect/temp_visual/cult/sparks(our_turf)

/obj/projectile/magic/arcane_barrage/blood/prehit_pierce(atom/target)
	. = ..()
	if(!ismob(target))
		return PROJECTILE_PIERCE_NONE

	var/mob/living/our_target = target
	if(!IS_CULTIST(our_target))
		return PROJECTILE_PIERCE_NONE

	if(iscarbon(our_target) && our_target.stat != DEAD)
		var/mob/living/carbon/carbon_cultist = our_target
		carbon_cultist.reagents.add_reagent(/datum/reagent/fuel/unholywater, 4)
	if(isshade(our_target) || isconstruct(our_target))
		var/mob/living/basic/construct/undead_abomination = our_target
		if(undead_abomination.health + 5 < undead_abomination.maxHealth)
			undead_abomination.adjust_health(-5)
	return PROJECTILE_DELETE_WITHOUT_HITTING

/obj/item/blood_beam
	name = "\improper 魔气"
	desc = "扭曲了周围现实的魔气."
	icon = 'icons/obj/weapons/hand.dmi'
	lefthand_file = 'icons/mob/inhands/items/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/touchspell_righthand.dmi'
	icon_state = "disintegrate"
	inhand_icon_state = "disintegrate"
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	var/charging = FALSE
	var/firing = FALSE
	var/angle

/obj/item/blood_beam/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)


/obj/item/blood_beam/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return ranged_interact_with_atom(interacting_with, user, modifiers)

/obj/item/blood_beam/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(firing || charging)
		return ITEM_INTERACT_BLOCKING
	if(!ishuman(user))
		return ITEM_INTERACT_BLOCKING
	angle = get_angle(user, interacting_with)
	charging = TRUE
	INVOKE_ASYNC(src, PROC_REF(charge), user)
	if(do_after(user, 9 SECONDS, target = user))
		firing = TRUE
		ADD_TRAIT(user, TRAIT_IMMOBILIZED, CULT_TRAIT)
		var/params = list2params(modifiers)
		INVOKE_ASYNC(src, PROC_REF(pewpew), user, params)
		var/obj/structure/emergency_shield/cult/weak/N = new(user.loc)
		if(do_after(user, 9 SECONDS, target = user))
			user.Paralyze(40)
			to_chat(user, span_cult_italic("你已经耗尽了这个法术的力量!"))
		REMOVE_TRAIT(user, TRAIT_IMMOBILIZED, CULT_TRAIT)
		firing = FALSE
		if(N)
			qdel(N)
		qdel(src)
	charging = FALSE
	return ITEM_INTERACT_SUCCESS

/obj/item/blood_beam/proc/charge(mob/user)
	var/obj/O
	playsound(src, 'sound/magic/lightning_chargeup.ogg', 100, TRUE)
	for(var/i in 1 to 12)
		if(!charging)
			break
		if(i > 1)
			sleep(1.5 SECONDS)
		if(i < 4)
			O = new /obj/effect/temp_visual/cult/rune_spawn/rune1/inner(user.loc, 30, "#ff0000")
		else
			O = new /obj/effect/temp_visual/cult/rune_spawn/rune5(user.loc, 30, "#ff0000")
			new /obj/effect/temp_visual/dir_setting/cult/phase/out(user.loc, user.dir)
	if(O)
		qdel(O)

/obj/item/blood_beam/proc/pewpew(mob/user, proximity_flag)
	var/turf/targets_from = get_turf(src)
	var/spread = 40
	var/second = FALSE
	var/set_angle = angle
	for(var/i in 1 to 12)
		if(second)
			set_angle = angle - spread
			spread -= 8
		else
			sleep(1.5 SECONDS)
			set_angle = angle + spread
		second = !second //Handles beam firing in pairs
		if(!firing)
			break
		playsound(src, 'sound/magic/exit_blood.ogg', 75, TRUE)
		new /obj/effect/temp_visual/dir_setting/cult/phase(user.loc, user.dir)
		var/turf/temp_target = get_turf_in_angle(set_angle, targets_from, 40)
		for(var/turf/T in get_line(targets_from,temp_target))
			if (locate(/obj/effect/blessing, T))
				temp_target = T
				playsound(T, 'sound/effects/parry.ogg', 50, TRUE)
				new /obj/effect/temp_visual/at_shield(T, T)
				break
			T.narsie_act(TRUE, TRUE)
			for(var/mob/living/target in T.contents)
				if(IS_CULTIST(target))
					new /obj/effect/temp_visual/cult/sparks(T)
					if(ishuman(target))
						var/mob/living/carbon/human/H = target
						if(H.stat != DEAD)
							H.reagents.add_reagent(/datum/reagent/fuel/unholywater, 7)
					if(isshade(target) || isconstruct(target))
						var/mob/living/basic/construct/healed_guy = target
						if(healed_guy.health + 15 < healed_guy.maxHealth)
							healed_guy.adjust_health(-15)
						else
							healed_guy.health = healed_guy.maxHealth
				else
					var/mob/living/L = target
					if(L.density)
						L.Paralyze(20)
						L.adjustBruteLoss(45)
						playsound(L, 'sound/hallucinations/wail.ogg', 50, TRUE)
						L.emote("scream")
		user.Beam(temp_target, icon_state="blood_beam", time = 7, beam_type = /obj/effect/ebeam/blood)


/obj/effect/ebeam/blood
	name = "血激流"

/obj/item/shield/mirror
	name = "镜盾"
	desc = "Nar'Sie教派用来迷惑敌人的盾牌. 通过对边缘加重可作为投掷武器使用 - 能够以不可思议的精度致残多个敌人."
	icon_state = "mirror_shield" // eshield1 for expanded
	inhand_icon_state = "mirror_shield"
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	force = 5
	throwforce = 15
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("盾击", "戳击")
	attack_verb_simple = list("盾击", "戳击")
	hitsound = 'sound/weapons/smash.ogg'
	block_sound = 'sound/weapons/effects/ric5.ogg'
	var/illusions = 2

/obj/item/shield/mirror/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "攻击", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(IS_CULTIST(owner))
		if(attack_type == PROJECTILE_ATTACK)
			if(damage_type == BRUTE || damage_type == BURN)
				if(damage >= 30)
					var/turf/T = get_turf(owner)
					T.visible_message(span_warning("[hitby]的强大力量粉碎了镜盾!"))
					new /obj/effect/temp_visual/cult/sparks(T)
					playsound(T, 'sound/effects/glassbr3.ogg', 100)
					owner.Paralyze(25)
					qdel(src)
					return FALSE
			var/obj/projectile/projectile = hitby
			if(projectile.reflectable & REFLECT_NORMAL)
				return FALSE //To avoid reflection chance double-dipping with block chance
		. = ..()
		if(.)
			if(illusions > 0)
				illusions--
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/shield/mirror, readd)), 45 SECONDS)
				if(prob(60))
					var/mob/living/simple_animal/hostile/illusion/M = new(owner.loc)
					M.faction = list(FACTION_CULT)
					M.Copy_Parent(owner, 70, 10, 5)
					M.move_to_delay = owner.cached_multiplicative_slowdown
				else
					var/mob/living/simple_animal/hostile/illusion/escape/E = new(owner.loc)
					E.Copy_Parent(owner, 70, 10)
					E.GiveTarget(owner)
					E.Goto(owner, owner.cached_multiplicative_slowdown, E.minimum_distance)
			return TRUE
	else
		if(prob(50))
			var/mob/living/simple_animal/hostile/illusion/H = new(owner.loc)
			H.Copy_Parent(owner, 100, 20, 5)
			H.faction = list(FACTION_CULT)
			H.GiveTarget(owner)
			H.move_to_delay = owner.cached_multiplicative_slowdown
			to_chat(owner, span_danger("<b>[src]背叛了你!</b>"))
		return FALSE

/obj/item/shield/mirror/proc/readd()
	illusions++
	if(illusions == initial(illusions) && isliving(loc))
		var/mob/living/holder = loc
		to_chat(holder, "<span class='cult italic'>盾的幻术恢复到全满状态!</span>")

/obj/item/shield/mirror/IsReflect()
	if(prob(block_chance))
		return TRUE
	return FALSE

/obj/item/shield/mirror/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/turf/impact_turf = get_turf(hit_atom)
	if(isliving(hit_atom))
		var/mob/living/target = hit_atom

		if(target.can_block_magic() || IS_CULTIST(target))
			target.visible_message(span_warning("[src]从[target]上弹开，似乎被一股看不见的力量所排斥!"))
			return
		if(IS_CULTIST(target) && target.put_in_active_hand(src))
			playsound(src, 'sound/weapons/throwtap.ogg', 50)
			target.visible_message(span_warning("[target]接住了[src]!"))
			return
		if(!..())
			target.Paralyze(30)
			var/mob/thrower = throwingdatum?.get_thrower()
			if(thrower)
				for(var/mob/living/Next in orange(2, impact_turf))
					if(!Next.density || IS_CULTIST(Next))
						continue
					throw_at(Next, 3, 1, thrower)
					return
				throw_at(thrower, 7, 1, null)
	else
		..()

#undef SHUTTLE_CURSE_OMFG_TIMESPAN
