/* Backpacks
 * Contains:
 * Backpack
 * Backpack Types
 * Satchel Types
 */

/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "背包"
	desc = "你把它背在背上，把东西放进去."
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	icon_state = "backpack"
	inhand_icon_state = "backpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK //ERROOOOO
	resistance_flags = NONE
	max_integrity = 300
	storage_type = /datum/storage/backpack

/obj/item/storage/backpack/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/attack_equip)

/*
 * Backpack Types
 */

/obj/item/storage/backpack/old/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 12

/obj/item/bag_of_holding_inert
	name = "未激活蓝空背包"
	desc = "目前只是一个笨重的金属块与蓝空异常核心槽."
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	icon_state = "bag_of_holding-inert"
	inhand_icon_state = "brokenpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION

/obj/item/bag_of_holding_inert/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slapcrafting,\
		slapcraft_recipes = list(/datum/crafting_recipe/boh)\
	)

/obj/item/storage/backpack/holding
	name = "蓝空背包"
	desc = "能连接到蓝空口袋空间的背包."
	icon_state = "bag_of_holding"
	inhand_icon_state = "holdingpack"
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION
	armor_type = /datum/armor/backpack_holding
	storage_type = /datum/storage/bag_of_holding

/datum/armor/backpack_holding
	fire = 60
	acid = 50

/obj/item/storage/backpack/holding/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正跳入[src]! 这是一种自杀行为."))
	user.dropItemToGround(src, TRUE)
	user.Stun(100, ignore_canstun = TRUE)
	sleep(2 SECONDS)
	playsound(src, SFX_RUSTLE, 50, TRUE, -5)
	user.suicide_log()
	qdel(user)


/obj/item/storage/backpack/santabag
	name = "圣诞老人礼物包"
	desc = "太空圣诞老人在圣诞节用这个给太空里所有的好孩子送礼物!哇，它好大啊!"
	icon_state = "giftbag0"
	inhand_icon_state = "giftbag"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/backpack/santabag/Initialize(mapload)
	. = ..()
	regenerate_presents()

/obj/item/storage/backpack/santabag/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]把[src]戴在头上并拉进袋口! 看起来没有什么圣诞精神..."))
	return OXYLOSS

/obj/item/storage/backpack/santabag/proc/regenerate_presents()
	addtimer(CALLBACK(src, PROC_REF(regenerate_presents)), 30 SECONDS)

	var/mob/user = get(loc, /mob)
	if(!istype(user))
		return
	if(HAS_MIND_TRAIT(user, TRAIT_CANNOT_OPEN_PRESENTS))
		var/turf/floor = get_turf(src)
		var/obj/item/thing = new /obj/item/gift/anything(floor)
		if(!atom_storage.attempt_insert(thing, user, override = TRUE, force = STORAGE_SOFT_LOCKED))
			qdel(thing)


/obj/item/storage/backpack/cultpack
	name = "奖杯架"
	desc = "这对携带额外装备和自豪地展示你的疯狂都很有用."
	icon_state = "backpack-cult"
	inhand_icon_state = "backpack"
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER

/obj/item/storage/backpack/clown
	name = "小丑背包"
	desc = "Honk!有限公司出品."
	icon_state = "backpack-clown"
	inhand_icon_state = "clownpack"

/obj/item/storage/backpack/explorer
	name = "探索者背包"
	desc = "一个结实的背包，用来存放你的战利品."
	icon_state = "backpack-explorer"
	inhand_icon_state = "explorerpack"

/obj/item/storage/backpack/mime
	name = "默剧背包"
	desc = "专为沉默的工作者设计的无声背包. 沉默有限公司出品."
	icon_state = "backpack-mime"
	inhand_icon_state = "mimepack"

/obj/item/storage/backpack/medic
	name = "医用背包"
	desc = "这是一个专为无菌环境设计的背包."
	icon_state = "backpack-medical"
	inhand_icon_state = "medicalpack"

/obj/item/storage/backpack/coroner
	name = "验尸官背包"
	desc = "这是一个专门为死亡环境设计的背包."
	icon_state = "backpack-coroner"
	inhand_icon_state = "coronerpack"

/obj/item/storage/backpack/security
	name = "安保背包"
	desc = "这是一个非常坚固的背包."
	icon_state = "backpack-security"
	inhand_icon_state = "securitypack"

/obj/item/storage/backpack/captain
	name = "舰长背包"
	desc = "为纳米的高官设计的背包."
	icon_state = "backpack-captain"
	inhand_icon_state = "captainpack"

/obj/item/storage/backpack/industrial
	name = "工业背包"
	desc = "对于空间站的日常生活来说，这是一个坚固的背包."
	icon_state = "backpack-engineering"
	inhand_icon_state = "engiepack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/botany
	name = "植物学背包"
	desc = "这是一个由纯天然纤维制成的背包."
	icon_state = "backpack-hydroponics"
	inhand_icon_state = "botpack"

/obj/item/storage/backpack/chemistry
	name = "化学背包"
	desc = "专为防止污渍和有害液体而设计的背包."
	icon_state = "backpack-chemistry"
	inhand_icon_state = "chempack"

/obj/item/storage/backpack/genetics
	name = "基因学背包"
	desc = "一个设计得超级坚固的袋子，以防有人突然袭击你."
	icon_state = "backpack-genetics"
	inhand_icon_state = "genepack"

/obj/item/storage/backpack/science
	name = "科研背包"
	desc = "一个特别设计的背包，它是防火的，闻起来有点等离子体的味道."
	icon_state = "backpack-science"
	inhand_icon_state = "scipack"

/obj/item/storage/backpack/virology
	name = "病毒学背包"
	desc = "由低过敏性纤维制成的背包，它的目的是帮助防止疾病的传播，闻起来像猴子."
	icon_state = "backpack-virology"
	inhand_icon_state = "viropack"

/obj/item/storage/backpack/ert
	name = "应急部队指挥官背包"
	desc = "一个有很多口袋的宽敞背包，由应急部队指挥官装备."
	icon_state = "ert_commander"
	inhand_icon_state = "securitypack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/ert/security
	name = "应急部队安保背包"
	desc = "一个有很多口袋的宽敞背包，由应急安保人员装备."
	icon_state = "ert_security"

/obj/item/storage/backpack/ert/medical
	name = "应急部队医疗背包"
	desc = "一个有很多口袋的宽敞背包，由应急医疗人员装备."
	icon_state = "ert_medical"

/obj/item/storage/backpack/ert/engineer
	name = "应急部队工程背包"
	desc = "一个有很多口袋的宽敞背包，由应急工程人员装备."
	icon_state = "ert_engineering"

/obj/item/storage/backpack/ert/janitor
	name = "应急部队清洁背包"
	desc = "一个有很多口袋的宽敞背包，由应急清洁人员装备."
	icon_state = "ert_janitor"

/obj/item/storage/backpack/ert/clown
	name = "应急部队小丑背包"
	desc = "一个有很多口袋的宽敞背包，由应急小丑人员装备."
	icon_state = "ert_clown"

/obj/item/storage/backpack/saddlepack
	name = "驮运袋"
	desc = "一种既可以装在坐骑上又可以背在背上的包，它相当宽敞的，但代价是让你觉得自己像一头驮着东西的骡子."
	icon = 'icons/obj/storage/ethereal.dmi'
	worn_icon = 'icons/mob/clothing/back/ethereal.dmi'
	icon_state = "saddlepack"

/obj/item/storage/backpack/saddlepack/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 26

// MEAT MEAT MEAT MEAT MEAT

/obj/item/storage/backpack/meat
	name = "\improper 肉"
	desc = "肉 肉 肉 肉 肉 肉"
	icon_state = "meatmeatmeat"
	inhand_icon_state = "meatmeatmeat"
	force = 15
	throwforce = 15
	attack_verb_continuous = list("肉啊", "肉啊肉啊")
	attack_verb_simple = list("肉啊", "肉啊肉啊")
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 25) // MEAT
	///Sounds used in the squeak component
	var/list/meat_sounds = list('sound/effects/blobattack.ogg' = 1)
	///Reagents added to the edible component, ingested when you EAT the MEAT
	var/list/meat_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	///The food types of the edible component
	var/foodtypes = MEAT | RAW
	///How our MEAT tastes. It tastes like MEAT
	var/list/tastes = list("肉" = 1)
	///Eating verbs when consuming the MEAT
	var/list/eatverbs = list("肉了", "吸入了", "咬", "消耗了")

/obj/item/storage/backpack/meat/Initialize(mapload)
	. = ..()
	AddComponent(
		/datum/component/edible,\
		initial_reagents = meat_reagents,\
		foodtypes = foodtypes,\
		tastes = tastes,\
		eatverbs = eatverbs,\
	)
	AddComponent(/datum/component/squeak, meat_sounds)
	AddComponent(
		/datum/component/blood_walk,\
		blood_type = /obj/effect/decal/cleanable/blood,\
		blood_spawn_chance = 15,\
		max_blood = 300,\
	)
	AddComponent(
		/datum/component/bloody_spreader,\
		blood_left = INFINITY,\
		blood_dna = list("MEAT DNA" = "MT+"),\
		diseases = null,\
	)

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "挎包"
	desc = "一个时髦的挎包."
	icon_state = "satchel-norm"
	inhand_icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/leather
	name = "皮革挎包"
	desc = "这是一个用上等皮革做的非常别致的挎包."
	icon_state = "satchel-leather"
	inhand_icon_state = "挎包"

/obj/item/storage/backpack/satchel/leather/withwallet/PopulateContents()
	new /obj/item/storage/wallet/random(src)

/obj/item/storage/backpack/satchel/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/eng
	name = "工业挎包"
	desc = "有额外口袋的结实背包."
	icon_state = "satchel-engineering"
	inhand_icon_state = "satchel-eng"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/med
	name = "医疗挎包"
	desc = "医疗部门使用的无菌包."
	icon_state = "satchel-medical"
	inhand_icon_state = "satchel-med"

/obj/item/storage/backpack/satchel/vir
	name = "病毒学家挎包"
	desc = "带有病毒学配色的无菌包."
	icon_state = "satchel-virology"
	inhand_icon_state = "satchel-vir"

/obj/item/storage/backpack/satchel/chem
	name = "化学挎包"
	desc = "带有化学配色的无菌包."
	icon_state = "satchel-chemistry"
	inhand_icon_state = "satchel-chem"

/obj/item/storage/backpack/satchel/coroner
	name = "验尸官挎包"
	desc = "一个用来装某人尸体的背包."
	icon_state = "satchel-coroner"
	inhand_icon_state = "satchel-coroner"

/obj/item/storage/backpack/satchel/gen
	name = "基因学家挎包"
	desc = "带有基因学配色的无菌包."
	icon_state = "satchel-genetics"
	inhand_icon_state = "satchel-gen"

/obj/item/storage/backpack/satchel/science
	name = "科研挎包"
	desc = "用于存放研究材料。"
	icon_state = "satchel-science"
	inhand_icon_state = "satchel-sci"

/obj/item/storage/backpack/satchel/hyd
	name = "植物学家挎包"
	desc = "全天然纤维制成的背包."
	icon_state = "satchel-hydroponics"
	inhand_icon_state = "satchel-hyd"

/obj/item/storage/backpack/satchel/sec
	name = "安保挎包"
	desc = "一个强大的挎包，用于安保相关需求."
	icon_state = "satchel-security"
	inhand_icon_state = "satchel-sec"

/obj/item/storage/backpack/satchel/explorer
	name = "探索者挎包"
	desc = "一个用来存放战利品的结实的背包."
	icon_state = "satchel-explorer"
	inhand_icon_state = "satchel-explorer"

/obj/item/storage/backpack/satchel/cap
	name = "舰长挎包"
	desc = "纳米高官专用的挎包."
	icon_state = "satchel-captain"
	inhand_icon_state = "satchel-cap"

/obj/item/storage/backpack/satchel/flat
	name = "走私者挎包"
	desc = "一个非常小的挎包，可以很容易地装进狭小的空间."
	icon_state = "satchel-flat"
	inhand_icon_state = "satchel-flat"
	w_class = WEIGHT_CLASS_NORMAL //Can fit in backpacks itself.

/obj/item/storage/backpack/satchel/flat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE, INVISIBILITY_MAXIMUM, use_anchor = TRUE) // SKYRAT EDIT - Ghosts can't see smuggler's satchels
	atom_storage.max_total_storage = 15
	atom_storage.set_holdable(cant_hold_list = list(/obj/item/storage/backpack/satchel/flat)) //muh recursive backpacks)

/obj/item/storage/backpack/satchel/flat/PopulateContents()
	for(var/items in 1 to 4)
		new /obj/effect/spawner/random/contraband(src)

/obj/item/storage/backpack/satchel/flat/with_tools/PopulateContents()
	new /obj/item/stack/tile/iron/base(src)
	new /obj/item/crowbar(src)

	..()

/obj/item/storage/backpack/satchel/flat/empty/PopulateContents()
	return

/obj/item/storage/backpack/duffelbag
	name = "旅行包"
	desc = "可以比一般背包储存更多东西的旅行包."
	icon_state = "duffel"
	inhand_icon_state = "duffel"
	actions_types = list(/datum/action/item_action/zipper)
	storage_type = /datum/storage/duffel
	// How much to slow you down if your bag isn't zipped up
	var/zip_slowdown = 1
	/// If this bag is zipped (contents hidden) up or not
	/// Starts enabled so you're forced to interact with it to "get" it
	var/zipped_up = TRUE
	// How much time it takes to zip up (close) the duffelbag
	var/zip_up_duration = 0.5 SECONDS
	// Audio played during zipup
	var/zip_up_sfx = 'sound/items/zip_up.ogg'
	// How much time it takes to unzip the duffel
	var/unzip_duration = 2.1 SECONDS
	// Audio played during unzip
	var/unzip_sfx = 'sound/items/un_zip.ogg'

/obj/item/storage/backpack/duffelbag/Initialize(mapload)
	. = ..()
	set_zipper(TRUE)

/obj/item/storage/backpack/duffelbag/update_desc(updates)
	. = ..()
	desc = "[initial(desc)]<br>[zipped_up ? "旅行包拉链已经拉上了，所以你没法拿放东西." : "旅行包拉链没拉，使你的行动更加迟缓."]"

/obj/item/storage/backpack/duffelbag/attack_self(mob/user, modifiers)
	if(loc != user) // God fuck TK
		return ..()
	if(zipped_up)
		return attack_hand(user, modifiers)
	else
		return attack_hand_secondary(user, modifiers)

/obj/item/storage/backpack/duffelbag/attack_self_secondary(mob/user, modifiers)
	attack_self(user, modifiers)
	return ..()

// If we're zipped, click to unzip
/obj/item/storage/backpack/duffelbag/attack_hand(mob/user, list/modifiers)
	if(loc != user)
		// Hacky, but please don't be cringe yeah?
		atom_storage.silent = TRUE
		. = ..()
		atom_storage.silent = initial(atom_storage.silent)
		return
	if(!zipped_up)
		return ..()

	balloon_alert(user, "unzipping...")
	playsound(src, unzip_sfx, 100, FALSE)
	var/datum/callback/can_unzip = CALLBACK(src, PROC_REF(zipper_matches), TRUE)
	if(!do_after(user, unzip_duration, src, extra_checks = can_unzip))
		user.balloon_alert(user, "unzip failed!")
		return
	balloon_alert(user, "unzipped")
	set_zipper(FALSE)
	return TRUE

// Vis versa
/obj/item/storage/backpack/duffelbag/attack_hand_secondary(mob/user, list/modifiers)
	if(loc != user)
		return ..()
	if(zipped_up)
		return SECONDARY_ATTACK_CALL_NORMAL

	balloon_alert(user, "zipping...")
	playsound(src, zip_up_sfx, 100, FALSE)
	var/datum/callback/can_zip = CALLBACK(src, PROC_REF(zipper_matches), FALSE)
	if(!do_after(user, zip_up_duration, src, extra_checks = can_zip))
		user.balloon_alert(user, "zip failed!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	balloon_alert(user, "zipped")
	set_zipper(TRUE)
	return SECONDARY_ATTACK_CONTINUE_CHAIN

/// Checks to see if the zipper matches the passed in state
/// Returns true if so, false otherwise
/obj/item/storage/backpack/duffelbag/proc/zipper_matches(matching_value)
	return zipped_up == matching_value

/obj/item/storage/backpack/duffelbag/proc/set_zipper(new_zip)
	zipped_up = new_zip
	SEND_SIGNAL(src, COMSIG_DUFFEL_ZIP_CHANGE, new_zip)
	if(zipped_up)
		slowdown = initial(slowdown)
		atom_storage.locked = STORAGE_SOFT_LOCKED
		atom_storage.display_contents = FALSE
		for(var/obj/item/weapon as anything in get_all_contents_type(/obj/item)) //close ui of this and all items inside dufflebag
			weapon.atom_storage?.close_all() //not everything has storage initialized
	else
		slowdown = zip_slowdown
		atom_storage.locked = STORAGE_NOT_LOCKED
		atom_storage.display_contents = TRUE

	if(isliving(loc))
		var/mob/living/wearer = loc
		wearer.update_equipment_speed_mods()
	update_appearance()

/obj/item/storage/backpack/duffelbag/cursed
	name = "活旅行包"
	desc = "一个被诅咒的小丑旅行包，有一个警告标签提升它会饥饿的吞食在里面的食物，如果食物难吃的一塌糊涂或者掺杂了不干净的东西，那么可能对旅行包造成一些负面影响..."
	icon_state = "duffel-curse"
	inhand_icon_state = "duffel-curse"
	zip_slowdown = 2
	max_integrity = 100

/obj/item/storage/backpack/duffelbag/cursed/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/curse_of_hunger, add_dropdel = TRUE)

/obj/item/storage/backpack/duffelbag/captain
	name = "舰长旅行包"
	desc = "一个大的行李袋，用来装舰长的物品."
	icon_state = "duffel-captain"
	inhand_icon_state = "duffel-captain"

/obj/item/storage/backpack/duffelbag/med
	name = "医疗旅行包"
	desc = "一个装额外医疗用品的大行李袋."
	icon_state = "duffel-medical"
	inhand_icon_state = "duffel-med"

/obj/item/storage/backpack/duffelbag/coroner
	name = "验尸官旅行包"
	desc = "一次装大量器官的大行李袋."
	icon_state = "duffel-coroner"
	inhand_icon_state = "duffel-coroner"

/obj/item/storage/backpack/duffelbag/explorer
	name = "探索者旅行包"
	desc = "用来装额外珍奇物品的大行李袋."
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"

/obj/item/storage/backpack/duffelbag/hydroponics
	name = "水培旅行包"
	desc = "一个装额外园艺工具的大行李袋."
	icon_state = "duffel-hydroponics"
	inhand_icon_state = "duffel-hydroponics"

/obj/item/storage/backpack/duffelbag/chemistry
	name = "化学旅行包"
	desc = "用来装额外化学物质的大行李袋."
	icon_state = "duffel-chemistry"
	inhand_icon_state = "duffel-chemistry"

/obj/item/storage/backpack/duffelbag/genetics
	name = "基因学家旅行包"
	desc = "一个装额外基因突变用品的大行李袋."
	icon_state = "duffel-genetics"
	inhand_icon_state = "duffel-genetics"

/obj/item/storage/backpack/duffelbag/science
	name = "科研旅行包"
	desc = "用来装额外科学部件的大行李袋."
	icon_state = "duffel-science"
	inhand_icon_state = "duffel-sci"

/obj/item/storage/backpack/duffelbag/virology
	name = "病毒学家旅行包"
	desc = "A large duffel bag for holding extra viral bottles."
	icon_state = "duffel-virology"
	inhand_icon_state = "duffel-virology"

/obj/item/storage/backpack/duffelbag/sec
	name = "安保旅行包"
	desc = "一个装额外安保物资和弹药的大行李袋."
	icon_state = "duffel-security"
	inhand_icon_state = "duffel-sec"

/obj/item/storage/backpack/duffelbag/sec/surgery
	name = "手术旅行包"
	desc = "一个大的行李袋，用来装额外的用品——有一个硬质空间，可以放各种看起来锋利的工具."

/obj/item/storage/backpack/duffelbag/sec/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/suit/toggle/labcoat/hospitalgown(src)	//SKYRAT EDIT ADDITION
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/blood_filter(src)

/obj/item/storage/backpack/duffelbag/engineering
	name = "工业旅行包"
	desc = "一个装额外工具和用品的大行李袋."
	icon_state = "duffel-engineering"
	inhand_icon_state = "duffel-eng"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/drone
	name = "无人机旅行包"
	desc = "用来装工具和帽子的大行李袋."
	icon_state = "duffel-drone"
	inhand_icon_state = "duffel-drone"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/drone/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)

/obj/item/storage/backpack/duffelbag/clown
	name = "小丑旅行包"
	desc = "一个装很多搞笑笑话的大行李袋!"
	icon_state = "duffel-clown"
	inhand_icon_state = "duffel-clown"

/obj/item/storage/backpack/duffelbag/clown/cream_pie/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/food/pie/cream(src)

/obj/item/storage/backpack/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/syndie
	name = "看起来很可疑的旅行包"
	desc = "装额外战术物资的大行李袋，它包含一个油塑钛战术拉链来提升拉拉链速度，能装下两件大件物品!"
	icon_state = "duffel-syndie"
	inhand_icon_state = "duffel-syndieammo"
	storage_type = /datum/storage/duffel/syndicate
	resistance_flags = FIRE_PROOF
	// Less slowdown while unzipped. Still bulky, but it won't halve your movement speed in an active combat situation.
	zip_slowdown = 0.3
	// Faster unzipping. Utilizes the same noise as zipping up to fit the unzip duration.
	unzip_duration = 0.5 SECONDS
	unzip_sfx = 'sound/items/zip_up.ogg'

//SKYRAT EDIT CHANGE START - It's just a black duffel.
/obj/item/storage/backpack/duffelbag/syndie
	name = "战术旅行包"
	desc = "装额外战术物资的大行李袋."
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE
	special_desc = "这个行李袋里面缝着辛迪加的标志，它似乎由更轻但更坚固的材料制成，并设有一个油塑钛拉链，以达到最高速度的去拉拉链."
//SKYRAT EDIT CHANGE END

/obj/item/storage/backpack/duffelbag/syndie/hitman
	desc = "装多余东西的大行李袋，背面有Nanotrasen的标志."
	icon_state = "duffel-syndieammo"
	inhand_icon_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/hitman/PopulateContents()
	new /obj/item/clothing/under/costume/buttondown/slacks/service(src)
	new /obj/item/clothing/neck/tie/red/hitman(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	new /obj/item/clothing/suit/toggle/lawyer/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/head/fedora(src)

/obj/item/storage/backpack/duffelbag/syndie/med
	name = "医疗旅行包"
	desc = "一个装额外医疗用品的大行李袋."
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery
	name = "手术旅行包"
	desc = "一个大的行李袋，用来装额外的用品——这个有一个硬质空间，可以放各种看起来锋利的工具." //SKYRAT EDIT CHANGE, to match the security surgery bag
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // SKYRAT EDIT ADDITION
	special_desc = "这个行李袋里面缝着辛迪加的标志，它似乎是由更轻但更坚固的材料制成的." // SKYRAT EDIT ADDITION

/obj/item/storage/backpack/duffelbag/syndie/surgery/PopulateContents()
	new /obj/item/scalpel/advanced(src)
	new /obj/item/retractor/advanced(src)
	new /obj/item/cautery/advanced(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/reagent_containers/medigel/sterilizine(src)
	new /obj/item/bonesetter(src)
	new /obj/item/blood_filter(src)
	new /obj/item/stack/medical/bone_gel(src)
	new /obj/item/stack/sticky_tape/surgical(src)
	new /obj/item/emergency_bed(src)
	new /obj/item/clothing/suit/jacket/straight_jacket(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/mmi/syndie(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo
	name = "军火旅行包"
	desc = "装额外武器、弹药和补给品的大行李袋."
	icon_state = "duffel-syndieammo"
	inhand_icon_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/ammo/mech
	desc = "一个大行李袋，塞满了各种机甲的弹药."

/obj/item/storage/backpack/duffelbag/syndie/ammo/mech/PopulateContents()
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/storage/belt/utility/syndicate(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler
	desc = "一个大行李袋，塞满了各种机甲的弹药."

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler/PopulateContents()
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/missiles_srm(src)
	new /obj/item/mecha_ammo/missiles_srm(src)
	new /obj/item/mecha_ammo/missiles_srm(src)

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle
	desc = "一个大的行李袋，里面装着医疗设备，一支Donksoft轻机枪，一个大箱子的防暴泡沫弹和磁力靴模块。"

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle/PopulateContents()
	new /obj/item/mod/module/magboot(src)
	new /obj/item/storage/medkit/tactical/premium(src)
	new /obj/item/gun/ballistic/automatic/l6_saw/toy(src)
	new /obj/item/ammo_box/foambox/riot(src)

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle
	desc = "一个装有致命化学物质的大行李袋，一个手持化学喷雾器，生化泡沫手榴弹，一支Donksoft突击步枪，一盒防暴泡沫弹，一支飞镖手枪和一盒注射器."

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle/PopulateContents()
	new /obj/item/reagent_containers/spray/chemsprayer/bioterror(src)
	new /obj/item/storage/box/syndie_kit/chemical(src)
	new /obj/item/gun/syringe/syndicate(src)
	new /obj/item/gun/ballistic/automatic/c20r/toy(src)
	new /obj/item/storage/box/syringes(src)
	new /obj/item/ammo_box/foambox/riot(src)
	new /obj/item/grenade/chem_grenade/bioterrorfoam(src)
	if(prob(5))
		new /obj/item/food/pizza/pineapple(src)

/obj/item/storage/backpack/duffelbag/syndie/c4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/grenade/c4(src)

/obj/item/storage/backpack/duffelbag/syndie/x4/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/grenade/c4/x4(src)

/obj/item/storage/backpack/duffelbag/syndie/firestarter
	desc = "一个大行李袋，里面装着一个新的俄罗斯火焰喷射器，精英模块服，一把APS手枪，迷你炸弹，弹药和其他设备."

/obj/item/storage/backpack/duffelbag/syndie/firestarter/PopulateContents()
	new /obj/item/clothing/under/syndicate/soviet(src)
	new /obj/item/mod/control/pre_equipped/elite/flamethrower(src)
	new /obj/item/gun/ballistic/automatic/pistol/aps(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/fire(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/fire(src)
	new /obj/item/reagent_containers/cup/glass/bottle/vodka/badminka(src)
	new /obj/item/reagent_containers/hypospray/medipen/stimulants(src)
	new /obj/item/grenade/syndieminibomb(src)

// For ClownOps.
/obj/item/storage/backpack/duffelbag/clown/syndie
	storage_type = /datum/storage/duffel/syndicate

/obj/item/storage/backpack/duffelbag/clown/syndie/PopulateContents()
	new /obj/item/modular_computer/pda/clown(src)
	new /obj/item/clothing/under/rank/civilian/clown(src)
	new /obj/item/clothing/shoes/clown_shoes(src)
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/bikehorn(src)
	new /obj/item/implanter/sad_trombone(src)

/obj/item/storage/backpack/henchmen
	name = "翼"
	desc = "授予那些应得的追随者，这可能不包括你."
	icon_state = "henchmen"
	inhand_icon_state = null

/obj/item/storage/backpack/duffelbag/cops
	name = "警察包"
	desc = "一个装额外警用装备的大行李袋."

/obj/item/storage/backpack/duffelbag/mining_conscript
	name = "采矿征召包"
	desc = "一个行李袋，里面装着矿工在野外工作所需的一切物品."
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"

/obj/item/storage/backpack/duffelbag/mining_conscript/PopulateContents()
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/t_scanner/adv_mining_scanner/lesser(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/clothing/suit/hooded/explorer(src)
	new /obj/item/encryptionkey/headset_mining(src)
	new /obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/card/id/advanced/mining(src)
	new /obj/item/gun/energy/recharge/kinetic_accelerator(src)
	new /obj/item/knife/combat/survival(src)
	new /obj/item/flashlight/seclite(src)

/*
 * Messenger Bag Types
 */

/obj/item/storage/backpack/messenger
	name = "邮差包"
	desc = "时髦的邮差包，有时被称为快递袋。时尚便携."
	icon_state = "messenger"
	inhand_icon_state = "messenger"
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'

/obj/item/storage/backpack/messenger/eng
	name = "工业邮差包"
	desc = "一种坚固的邮差包，由经过高级处理的皮革制成，防火，它的口袋也比平时多."
	icon_state = "messenger_engineering"
	inhand_icon_state = "messenger_engineering"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/messenger/med
	name = "医疗邮差包"
	desc = "一个无菌邮差包深受医务人员的喜爱，因为它的便携性和圆滑的轮廓."
	icon_state = "messenger_medical"
	inhand_icon_state = "messenger_medical"

/obj/item/storage/backpack/messenger/vir
	name = "病毒学家邮差包"
	desc = "带有病毒学色彩的无菌邮差袋，有助于在创纪录的时间内部署生物危害."
	icon_state = "messenger_virology"
	inhand_icon_state = "messenger_virology"

/obj/item/storage/backpack/messenger/chem
	name = "化学邮差包"
	desc = "有化学颜色的无菌邮差包，可以让你准时到达你的小巷交易."
	icon_state = "messenger_chemistry"
	inhand_icon_state = "messenger_chemistry"

/obj/item/storage/backpack/messenger/coroner
	name = "验尸官邮差包"
	desc = "一个邮差包，用来让你以良好的速度溜出墓地."
	icon_state = "messenger_coroner"
	inhand_icon_state = "messenger_coroner"

/obj/item/storage/backpack/messenger/gen
	name = "基因学家邮差包"
	desc = "一个带有遗传学色彩的无菌邮差包，是绿巨人非常可爱的配饰."
	icon_state = "messenger_genetics"
	inhand_icon_state = "messenger_genetics"

/obj/item/storage/backpack/messenger/science
	name = "科研邮差包"
	desc = "有用的持有研究材料，并加快你到不同的扫描目标的速度."
	icon_state = "messenger_science"
	inhand_icon_state = "messenger_science"

/obj/item/storage/backpack/messenger/hyd
	name = "植物学家邮差包"
	desc = "一个由天然纤维制成的邮差包，能让你及时赶到现场."
	icon_state = "messenger_hydroponics"
	inhand_icon_state = "messenger_hydroponics"

/obj/item/storage/backpack/messenger/sec
	name = "安保邮差包"
	desc = "一个坚固的邮差包，用于安全相关的需要."
	icon_state = "messenger_security"
	inhand_icon_state = "messenger_security"

/obj/item/storage/backpack/messenger/explorer
	name = "探索者邮差包"
	desc = "一个坚固的邮差包，用于存放你的战利品，以及为你的龙骨盔甲制作一个非常可爱的配件."
	icon_state = "messenger_explorer"
	inhand_icon_state = "messenger_explorer"

/obj/item/storage/backpack/messenger/cap
	name = "舰长邮差包"
	desc = "纳米高官专用邮差包，由真鲸皮制成."
	icon_state = "messenger_captain"
	inhand_icon_state = "messenger_captain"

/obj/item/storage/backpack/messenger/clown
	name = "小丑邮差包."
	desc = "这是Honk公司最新的存储“技术”！嘿，这么小的包怎么能装这么多?佩戴者绝对不会告诉你的."
	icon_state = "messenger_clown"
	inhand_icon_state = "messenger_clown"
