/* Clown Items
 * Contains:
 * Soap
 * Bike Horns
 * Air Horns
 * Canned Laughter
 */

/*
 * Soap
 */

/obj/item/soap
	name = "肥皂"
	desc = "一块便宜肥皂，别闻."
	gender = PLURAL
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "soap"
	inhand_icon_state = "soap"
	worn_icon_state = "soap"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	grind_results = list(/datum/reagent/lye = 10)
	var/cleanspeed = 3.5 SECONDS //slower than mop
	force_string = "强效杀菌..."
	var/uses = 100

/obj/item/soap/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 80)
	AddComponent(/datum/component/cleaner, cleanspeed, 0.1, pre_clean_callback=CALLBACK(src, PROC_REF(should_clean)), on_cleaned_callback=CALLBACK(src, PROC_REF(decreaseUses))) //less scaling for soapies

/obj/item/soap/examine(mob/user)
	. = ..()
	var/max_uses = initial(uses)
	var/msg = "看起来像是刚从包装盒里拆出来的."
	if(uses != max_uses)
		var/percentage_left = uses / max_uses
		switch(percentage_left)
			if(0 to 0.15)
				msg = "几乎看不出原形了, 你不确定还能用多久."
			if(0.15 to 0.30)
				msg = "用掉了很多, 但还剩下一些."
			if(0.30 to 0.50)
				msg = "已经不是兼具美感的造型了, 但用起来还可以."
			if(0.50 to 0.75)
				msg = "似乎是比以前小了一圈, 但还能用好一会呢."
			else
				msg = "被用过一点了, 但仍然和新的差不多."
	. += span_notice("[msg]")

/obj/item/soap/homemade
	desc = "一块手工肥皂，闻起来的味道...嗯...."
	grind_results = list(/datum/reagent/consumable/liquidgibs = 9, /datum/reagent/lye = 9)
	icon_state = "soapgibs"
	inhand_icon_state = "soapgibs"
	worn_icon_state = "soapgibs"
	cleanspeed = 3 SECONDS // faster than base soap to reward chemists for going to the effort

/obj/item/soap/nanotrasen
	desc = "一块强力的Nanotrasen牌肥皂，有等离子的气味."
	grind_results = list(/datum/reagent/toxin/plasma = 10, /datum/reagent/lye = 10)
	icon_state = "soapnt"
	inhand_icon_state = "soapnt"
	worn_icon_state = "soapnt"
	cleanspeed = 2.8 SECONDS //janitor gets this
	uses = 300

/obj/item/soap/nanotrasen/cyborg

/obj/item/soap/deluxe
	desc = "Waffle Co-华夫公司的高档香皂，有高级奢侈品的气味."
	grind_results = list(/datum/reagent/consumable/aloejuice = 10, /datum/reagent/lye = 10)
	icon_state = "soapdeluxe"
	inhand_icon_state = "soapdeluxe"
	worn_icon_state = "soapdeluxe"
	cleanspeed = 2 SECONDS //captain gets one of these

/obj/item/soap/syndie
	desc = "一块靠不住的肥皂，含有能更快清除血迹的化学成分."
	grind_results = list(/datum/reagent/toxin/acid = 10, /datum/reagent/lye = 10)
	icon_state = "soapsyndie"
	inhand_icon_state = "soapsyndie"
	worn_icon_state = "soapsyndie"
	cleanspeed = 0.5 SECONDS //faster than mops so it's useful for traitors who want to clean crime scenes

/obj/item/soap/omega
	name = "\improper Omega 肥皂"
	desc = "人类已知最先进的肥皂，为细菌的灭绝拉开了序幕."
	grind_results = list(/datum/reagent/consumable/potato_juice = 9, /datum/reagent/consumable/ethanol/lizardwine = 9, /datum/reagent/monkey_powder = 9, /datum/reagent/drug/krokodil = 9, /datum/reagent/toxin/acid/nitracid = 9, /datum/reagent/baldium = 9, /datum/reagent/consumable/ethanol/hooch = 9, /datum/reagent/bluespace = 9, /datum/reagent/drug/pumpup = 9, /datum/reagent/consumable/space_cola = 9)
	icon_state = "soapomega"
	inhand_icon_state = "soapomega"
	worn_icon_state = "soapomega"
	cleanspeed = 0.3 SECONDS //Only the truest of mind soul and body get one of these
	uses = 800 //In the Greek numeric system, Omega has a value of 800

/obj/item/soap/omega/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正用[src]来把自己从世界线上抹去!这是一种自杀行为!"))
	new /obj/structure/chrono_field(user.loc, user)
	return MANUAL_SUICIDE

/obj/item/paper/fluff/stations/soap
	name = "古代清洁工之诗"
	desc = "一份经过许多人转手的旧纸张."
	default_raw_text = "<B>O皂物语</B><BR><BR>O皂者<B>土豆</B>. 汁, 不磨乎.<BR><BR> 取之 <B>蜥之</B> 尾, 酿为 <B>酒乎</B>.<BR><BR> <B>猴粉者</B>, 助其业.<BR><BR> 噫 <B>Krokodil-二氢脱氧吗啡</B>, 因为冰毒会爆炸.<BR><BR> <B>Nitric acid-硝酸</B> 和 <B>Baldium-秃头素</B>, 有机溶解.<BR><BR> 满杯 <B>Hooch-私酒</B>, 洗尽铅华<BR><BR> 啊 <B>Bluespace Dust-蓝空尘</B>, 聊蔽美之逍遥.<BR><BR> 满针的 <B>Pump-up-兴奋剂</B>, 为安保留下祸根.<BR><BR> 加一罐 <B>Space Cola-太空可乐</B>, 因为我收了广告费.<BR><BR> <B>火火火</B> 铸皂为剑.<BR><BR> <B>每种试剂10单位，造出他妈的肥皂，干翻他妈的整个世界.</B>"

/obj/item/soap/suicide_act(mob/living/user)
	user.say(";FFFFFFFFFFFFFFFFUUUUUUUDGE!!", forced="soap suicide")
	user.visible_message(span_suicide("[user]把[src]拼命地咬，产生了厚厚的泡沫! [user.p_They()]'ll never get that BB gun now!"))
	var/datum/effect_system/fluid_spread/foam/foam = new
	foam.set_up(1, holder = src, location = get_turf(user))
	foam.start()
	return TOXLOSS

/obj/item/soap/proc/should_clean(datum/cleaning_source, atom/atom_to_clean, mob/living/cleaner)
	return check_allowed_items(atom_to_clean)

/**
 * Decrease the number of uses the bar of soap has.
 *
 * The higher the cleaning skill, the less likely the soap will lose a use.
 * Arguments
 * * source - the source of the cleaning
 * * target - The atom that is being cleaned
 * * user - The mob that is using the soap to clean.
 */
/obj/item/soap/proc/decreaseUses(datum/source, atom/target, mob/living/user, clean_succeeded)
	if(!clean_succeeded)
		return
	var/skillcheck = 1
	if(user?.mind)
		skillcheck = user.mind.get_skill_modifier(/datum/skill/cleaning, SKILL_SPEED_MODIFIER)
	if(prob(skillcheck*100)) //higher level = more uses assuming RNG is nice
		uses--
	if(uses <= 0)
		noUses(user)

/obj/item/soap/proc/noUses(mob/user)
	to_chat(user, span_warning("[src]碎成小块!"))
	qdel(src)

/obj/item/soap/nanotrasen/cyborg/noUses(mob/user)
	to_chat(user, span_warning("肥皂的化学物质用完了!"))

/obj/item/soap/nanotrasen/cyborg/afterattack(atom/target, mob/user, proximity)
	. = isitem(target) ? AFTERATTACK_PROCESSED_ITEM : NONE
	if(uses <= 0)
		to_chat(user, span_warning("不好，你需要充电!"))
		return .
	return ..() | .

/obj/item/soap/attackby_storage_insert(datum/storage, atom/storage_holder, mob/living/user)
	return !user?.combat_mode  // only cleans a storage item if on combat

/*
 * Bike Horns
 */

/obj/item/bikehorn
	name = "自行车喇叭"
	desc = "自行车上的喇叭，有传言说是用被回收的小丑做的."
	icon = 'icons/obj/art/horn.dmi'
	icon_state = "bike_horn"
	inhand_icon_state = "bike_horn"
	worn_icon_state = "horn"
	lefthand_file = 'icons/mob/inhands/equipment/horns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/horns_righthand.dmi'
	throwforce = 0
	hitsound = null //To prevent tap.ogg playing, as the item lacks of force
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	throw_speed = 3
	throw_range = 7
	attack_verb_continuous = list("HONKS")
	attack_verb_simple = list("HONK")
	///sound file given to the squeaky component we make in Initialize() so sub-types can specify their own sound
	var/sound_file = 'sound/items/bikehorn.ogg'

/obj/item/bikehorn/Initialize(mapload)
	. = ..()
	var/list/sound_list = list()
	sound_list[sound_file] = 1
	AddComponent(/datum/component/squeak, sound_list, 50, falloff_exponent = 20)

/obj/item/bikehorn/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(user != M && ishuman(user))
		var/mob/living/carbon/human/H = user
		if (HAS_TRAIT(H, TRAIT_CLUMSY)) //only clowns can unlock its true powers
			M.add_mood_event("honk", /datum/mood_event/honk)
	return ..()

/obj/item/bikehorn/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]郑重地用[src]指向自己的太阳穴!这是一种自杀行为!"))
	playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE)
	return BRUTELOSS

//air horn
/obj/item/bikehorn/airhorn
	name = "air horn-气动喇叭"
	desc = "孩子, 你从哪拿到它的?"
	icon_state = "air_horn"
	worn_icon_state = "horn_air"
	sound_file = 'sound/items/airhorn2.ogg'

//golden bikehorn
/obj/item/bikehorn/golden
	name = "金自行车喇叭"
	desc = "金的? 是蕉矿啦! Honk!"
	icon_state = "gold_horn"
	inhand_icon_state = "gold_horn"
	worn_icon_state = "horn_gold"
	COOLDOWN_DECLARE(golden_horn_cooldown)

/obj/item/bikehorn/golden/attack()
	flip_mobs()
	return ..()

/obj/item/bikehorn/golden/attack_self(mob/user)
	flip_mobs()
	..()

/obj/item/bikehorn/golden/proc/flip_mobs(mob/living/carbon/M, mob/user)
	if(!COOLDOWN_FINISHED(src, golden_horn_cooldown))
		return
	var/turf/T = get_turf(src)
	for(M in ohearers(7, T))
		if(M.can_hear())
			M.emote("flip")
	COOLDOWN_START(src, golden_horn_cooldown, 1 SECONDS)

/obj/item/bikehorn/rubberducky/plasticducky
	name = "plastic ducky"
	desc = "It's a cheap plastic knockoff of a loveable bathtime toy."
	custom_materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~" //thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	inhand_icon_state = "rubberducky"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	worn_icon_state = "duck"
	sound_file = 'sound/effects/quack.ogg'

//canned laughter
/obj/item/reagent_containers/cup/soda_cans/canned_laughter
	name = "罐头笑声"
	desc = "光是看着就让你想笑."
	icon_state = "laughter"
	volume = 50
	list_reagents = list(/datum/reagent/consumable/laughter = 50)
