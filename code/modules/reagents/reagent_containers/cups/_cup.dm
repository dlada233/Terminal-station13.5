/obj/item/reagent_containers/cup
	name = "open container"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50)
	volume = 50
	reagent_flags = OPENCONTAINER | DUNKABLE
	spillable = TRUE
	resistance_flags = ACID_PROOF
	icon_state = "bottle"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'

	///Like Edible's food type, what kind of drink is this?
	var/drink_type = NONE
	///The last time we have checked for taste.
	var/last_check_time
	///How much we drink at once, shot glasses drink more.
	var/gulp_size = 5
	///Whether the 'bottle' is made of glass or not so that milk cartons dont shatter when someone gets hit by it.
	var/isGlass = FALSE

/obj/item/reagent_containers/cup/examine(mob/user)
	. = ..()
	if(drink_type)
		var/list/types = bitfield_to_list(drink_type, FOOD_FLAGS)
		. += span_notice("它是[LOWER_TEXT(english_list(types))].")

/**
 * Checks if the mob actually liked drinking this cup.
 *
 * This is a bunch of copypaste from the edible component, consider reworking this to use it!
 */
/obj/item/reagent_containers/cup/proc/checkLiked(fraction, mob/eater)
	if(last_check_time + 5 SECONDS > world.time)
		return FALSE
	if(!ishuman(eater))
		return FALSE
	var/mob/living/carbon/human/gourmand = eater
	//Bruh this breakfast thing is cringe and shouldve been handled separately from food-types, remove this in the future (Actually, just kill foodtypes in general)
	if((drink_type & BREAKFAST) && world.time - SSticker.round_start_time < STOP_SERVING_BREAKFAST)
		gourmand.add_mood_event("breakfast", /datum/mood_event/breakfast)
	last_check_time = world.time

	var/food_taste_reaction = gourmand.get_food_taste_reaction(src, drink_type)
	switch(food_taste_reaction)
		if(FOOD_TOXIC)
			to_chat(gourmand,span_warning("那是什么鬼东西?!"))
			gourmand.adjust_disgust(25 + 30 * fraction)
			gourmand.add_mood_event("toxic_food", /datum/mood_event/disgusting_food)
		if(FOOD_DISLIKED)
			to_chat(gourmand,span_notice("味道不太好..."))
			gourmand.adjust_disgust(11 + 15 * fraction)
			gourmand.add_mood_event("gross_food", /datum/mood_event/gross_food)
		if(FOOD_LIKED)
			to_chat(gourmand,span_notice("我爱这个味道!"))
			gourmand.adjust_disgust(-5 + -2.5 * fraction)
			gourmand.add_mood_event("fav_food", /datum/mood_event/favorite_food)

/obj/item/reagent_containers/cup/attack(mob/living/target_mob, mob/living/user, obj/target)
	if(!canconsume(target_mob, user))
		return

	if(!spillable)
		return

	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning("[src]是空的!"))
		return

	if(!istype(target_mob))
		return

	if(target_mob != user)
		target_mob.visible_message(span_danger("[user]尝试用[src]喂给[target_mob]一些东西."), \
					span_userdanger("[user]尝试用[src]喂给你一些东西."))
		if(!do_after(user, 3 SECONDS, target_mob))
			return
		if(!reagents || !reagents.total_volume)
			return // The drink might be empty after the delay, such as by spam-feeding
		target_mob.visible_message(span_danger("[user]用[src]喂给了[target_mob]一些东西."), \
					span_userdanger("[user]用[src]喂给了你一些东西."))
		log_combat(user, target_mob, "fed", reagents.get_reagent_log_string())
	else
		to_chat(user, span_notice("你拿着[src]喝下一大口"))

	SEND_SIGNAL(src, COMSIG_GLASS_DRANK, target_mob, user)
	SEND_SIGNAL(target_mob, COMSIG_GLASS_DRANK, src, user) // SKYRAT EDIT ADDITION - Hemophages can't casually drink what's not going to regenerate their blood
	var/fraction = min(gulp_size/reagents.total_volume, 1)
	reagents.trans_to(target_mob, gulp_size, transferred_by = user, methods = INGEST)
	checkLiked(fraction, target_mob)
	playsound(target_mob.loc,'sound/items/drink.ogg', rand(10,50), TRUE)
	if(!iscarbon(target_mob))
		return
	var/mob/living/carbon/carbon_drinker = target_mob
	var/list/diseases = carbon_drinker.get_static_viruses()
	if(!LAZYLEN(diseases))
		return
	var/list/datum/disease/diseases_to_add = list()
	for(var/datum/disease/malady as anything in diseases)
		if(malady.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS)
			diseases_to_add += malady
	if(LAZYLEN(diseases_to_add))
		AddComponent(/datum/component/infective, diseases_to_add)

/obj/item/reagent_containers/cup/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!check_allowed_items(target, target_self = TRUE))
		return NONE
	if(!spillable)
		return NONE

	if(target.is_refillable()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, span_warning("[src]是空的!"))
			return ITEM_INTERACT_BLOCKING

		if(target.reagents.holder_full())
			to_chat(user, span_warning("[target]是满的."))
			return ITEM_INTERACT_BLOCKING

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this, transferred_by = user)
		playsound(target.loc, pick('sound/effects/liquid_pour1.ogg', 'sound/effects/liquid_pour2.ogg', 'sound/effects/liquid_pour3.ogg'), 50)
		to_chat(user, span_notice("你将[trans]单位液体转移到[target]."))
		SEND_SIGNAL(src, COMSIG_REAGENTS_CUP_TRANSFER_TO, target)
		target.update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target]是空的，且无法被重新填装!"))
			return ITEM_INTERACT_BLOCKING

		if(reagents.holder_full())
			to_chat(user, span_warning("[src]是满的."))
			return ITEM_INTERACT_BLOCKING

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transferred_by = user)
		to_chat(user, span_notice("你用[target]里[trans]单位内容物填装了[src]."))
		SEND_SIGNAL(src, COMSIG_REAGENTS_CUP_TRANSFER_FROM, target)
		target.update_appearance()
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/reagent_containers/cup/interact_with_atom_secondary(atom/target, mob/living/user, list/modifiers)
	if(user.combat_mode)
		return ITEM_INTERACT_SKIP_TO_ATTACK
	if(!check_allowed_items(target, target_self = TRUE))
		return NONE
	if(!spillable)
		return ITEM_INTERACT_BLOCKING

	if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target]是空的!"))
			return ITEM_INTERACT_BLOCKING

		if(reagents.holder_full())
			to_chat(user, span_warning("[src]是满的."))
			return ITEM_INTERACT_BLOCKING

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transferred_by = user)
		to_chat(user, span_notice("你用[target]里[trans]单位内容物填装了[src]."))

	target.update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/cup/attackby(obj/item/attacking_item, mob/user, params)
	var/hotness = attacking_item.get_temperature()
	if(hotness && reagents)
		reagents.expose_temperature(hotness)
		to_chat(user, span_notice("你用[attacking_item]加热[name]!"))
		return TRUE

	//Cooling method
	if(istype(attacking_item, /obj/item/extinguisher))
		var/obj/item/extinguisher/extinguisher = attacking_item
		if(extinguisher.safety)
			return TRUE
		if (extinguisher.reagents.total_volume < 1)
			to_chat(user, span_warning("[extinguisher]是空的!"))
			return TRUE
		var/cooling = (0 - reagents.chem_temp) * extinguisher.cooling_power * 2
		reagents.expose_temperature(cooling)
		to_chat(user, span_notice("你用[attacking_item]冷却[name]!"))
		playsound(loc, 'sound/effects/extinguish.ogg', 75, TRUE, -3)
		extinguisher.reagents.remove_all(1)
		return TRUE

	if(istype(attacking_item, /obj/item/food/egg)) //breaking eggs
		var/obj/item/food/egg/attacking_egg = attacking_item
		if(!reagents)
			return TRUE
		if(reagents.holder_full())
			to_chat(user, span_notice("[src]是满的."))
		else
			to_chat(user, span_notice("你打[attacking_egg]到[src]."))
			attacking_egg.reagents.trans_to(src, attacking_egg.reagents.total_volume, transferred_by = user)
			qdel(attacking_egg)
		return TRUE

	return ..()

/*
 * On accidental consumption, make sure the container is partially glass, and continue to the reagent_container proc
 */
/obj/item/reagent_containers/cup/on_accidental_consumption(mob/living/carbon/M, mob/living/carbon/user, obj/item/source_item, discover_after = TRUE)
	if(isGlass && !custom_materials)
		set_custom_materials(list(GET_MATERIAL_REF(/datum/material/glass) = 5))//sets it to glass so, later on, it gets picked up by the glass catch (hope it doesn't 'break' things lol)
	return ..()

/// Callback for [datum/component/takes_reagent_appearance] to inherent style footypes
/obj/item/reagent_containers/cup/proc/on_cup_change(datum/glass_style/has_foodtype/style)
	if(!istype(style))
		return
	drink_type = style.drink_type

/// Callback for [datum/component/takes_reagent_appearance] to reset to no foodtypes
/obj/item/reagent_containers/cup/proc/on_cup_reset()
	drink_type = NONE

/obj/item/reagent_containers/cup/beaker
	name = "烧杯"
	desc = "一杯烧杯，最多可以容纳60单位试剂." //SKYRAT EDIT: Used to say can hold up to 50 units.
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "beaker"
	inhand_icon_state = "beaker"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	worn_icon_state = "beaker"
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT*5)
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)
	volume = 60 //SKYRAT EDIT: Addition
	possible_transfer_amounts = list(5,10,15,20,30,60) //SKYRAT EDIT: Addition

/obj/item/reagent_containers/cup/beaker/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/reagent_containers/cup/beaker/get_part_rating()
	return reagents.maximum_volume

/obj/item/reagent_containers/cup/beaker/jar
	name = "蜂蜜罐"
	desc = "装蜂蜜的罐子，可以容纳50单位的香甜蜂蜜."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "vapour"

/obj/item/reagent_containers/cup/beaker/large
	name = "大烧杯"
	desc = "一杯大烧杯. 可以容纳120单位的试剂." //SKYRAT EDIT: Used to say Can hold up to 100 units.
	icon_state = "beakerlarge"
	custom_materials = list(/datum/material/glass= SHEET_MATERIAL_AMOUNT*1.25)
	volume = 120 //SKYRAT EDIT: Original value (100)
	amount_per_transfer_from_this = 10
	//possible_transfer_amounts = list(5,10,15,20,25,30,50,100) //SKYRAT EDIT: Original Values
	possible_transfer_amounts = list(5,10,15,20,30,40,60,120) //SKYRAT EDIT: New Values
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/cup/beaker/plastic
	name = "特大烧杯"
	desc = "一杯特大号的烧杯. 可以容纳150单位的试剂." //SKYRAT EDIT: Used to say Can hold up to 120 units
	icon_state = "beakerwhite"
	custom_materials = list(/datum/material/glass=SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plastic=SHEET_MATERIAL_AMOUNT * 1.5)
	volume = 150 //SKYRAT EDIT: Original Value (120)
	amount_per_transfer_from_this = 10
	//possible_transfer_amounts = list(5,10,15,20,25,30,60,120) //SKYRAT EDIT: Original values
	possible_transfer_amounts = list(5,10,15,20,25,30,50,75,150) //SKYRAT EDIT: New Values
	fill_icon_thresholds = list(0, 1, 10, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/cup/beaker/meta
	name = "超材料烧杯"
	desc = "一杯大号烧杯，可以容纳180单位的试剂."
	icon_state = "beakergold"
	custom_materials = list(/datum/material/glass=SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plastic=SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold=HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium=HALF_SHEET_MATERIAL_AMOUNT)
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,60,120,180)
	fill_icon_thresholds = list(0, 1, 10, 25, 35, 50, 60, 80, 100)

/obj/item/reagent_containers/cup/beaker/noreact
	name = "低温保存烧杯"
	desc = "一种允许存储化学物质而不发生反应的低温保存烧杯，最多可以容纳50单位的试剂."
	icon_state = "beakernoreact"
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT * 1.5)
	reagent_flags = OPENCONTAINER | NO_REACT
	volume = 50
	amount_per_transfer_from_this = 10

/obj/item/reagent_containers/cup/beaker/bluespace
	name = "蓝空烧杯"
	desc = "一杯蓝空烧杯，由蓝空技术、古巴皮特混合物制成，最多可以容纳300单位的试剂."
	icon_state = "beakerbluespace"
	custom_materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/plasma =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace =HALF_SHEET_MATERIAL_AMOUNT)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100,300)

/obj/item/reagent_containers/cup/beaker/meta/omnizine
	list_reagents = list(/datum/reagent/medicine/omnizine = 180)

/obj/item/reagent_containers/cup/beaker/meta/sal_acid
	list_reagents = list(/datum/reagent/medicine/sal_acid = 180)

/obj/item/reagent_containers/cup/beaker/meta/oxandrolone
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 180)

/obj/item/reagent_containers/cup/beaker/meta/pen_acid
	list_reagents = list(/datum/reagent/medicine/pen_acid = 180)

/obj/item/reagent_containers/cup/beaker/meta/atropine
	list_reagents = list(/datum/reagent/medicine/atropine = 180)

/obj/item/reagent_containers/cup/beaker/meta/salbutamol
	list_reagents = list(/datum/reagent/medicine/salbutamol = 180)

/obj/item/reagent_containers/cup/beaker/meta/rezadone
	list_reagents = list(/datum/reagent/medicine/rezadone = 180)

/obj/item/reagent_containers/cup/beaker/cryoxadone
	list_reagents = list(/datum/reagent/medicine/cryoxadone = 30)

/obj/item/reagent_containers/cup/beaker/sulfuric
	list_reagents = list(/datum/reagent/toxin/acid = 50)

/obj/item/reagent_containers/cup/beaker/slime
	list_reagents = list(/datum/reagent/toxin/slimejelly = 50)

/obj/item/reagent_containers/cup/beaker/large/libital
	name = "利比特备用杯(稀释)"
	list_reagents = list(/datum/reagent/medicine/c2/libital = 10,/datum/reagent/medicine/granibitaluri = 40)

/obj/item/reagent_containers/cup/beaker/large/aiuri
	name = "艾尤里备用杯(稀释)"
	list_reagents = list(/datum/reagent/medicine/c2/aiuri = 10, /datum/reagent/medicine/granibitaluri = 40)

/obj/item/reagent_containers/cup/beaker/large/multiver
	name = "木太尔备用杯(稀释)"
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 10, /datum/reagent/medicine/granibitaluri = 40)

/obj/item/reagent_containers/cup/beaker/large/epinephrine
	name = "肾上腺素备用杯(稀释)"
	list_reagents = list(/datum/reagent/medicine/epinephrine = 50)

/obj/item/reagent_containers/cup/beaker/synthflesh
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 50)

/obj/item/reagent_containers/cup/bucket
	name = "水桶"
	desc = "这是一个水桶，用拖把右键水桶可以挤干拖把." //SKYRAT EDIT CHANGE - ORIGINAL: desc = "It's a bucket."
	icon = 'icons/obj/service/janitor.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	icon_state = "bucket"
	inhand_icon_state = "bucket"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	fill_icon_state = "bucket"
	fill_icon_thresholds = list(50, 90)
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT * 2)
	w_class = WEIGHT_CLASS_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100) //SKYRAT EDIT CHANGE
	volume = 100 //SKYRAT EDIT CHANGE
	flags_inv = HIDEHAIR
	slot_flags = ITEM_SLOT_HEAD
	resistance_flags = NONE
	armor_type = /datum/armor/cup_bucket
	slot_equipment_priority = list( \
		ITEM_SLOT_BACK, ITEM_SLOT_ID,\
		ITEM_SLOT_ICLOTHING, ITEM_SLOT_OCLOTHING,\
		ITEM_SLOT_MASK, ITEM_SLOT_HEAD, ITEM_SLOT_NECK,\
		ITEM_SLOT_FEET, ITEM_SLOT_GLOVES,\
		ITEM_SLOT_EARS, ITEM_SLOT_EYES,\
		ITEM_SLOT_BELT, ITEM_SLOT_SUITSTORE,\
		ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET,\
		ITEM_SLOT_DEX_STORAGE
	)

/datum/armor/cup_bucket
	melee = 10
	fire = 75
	acid = 50

/obj/item/reagent_containers/cup/bucket/wooden
	name = "木桶"
	icon_state = "woodbucket"
	inhand_icon_state = "woodbucket"
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)
	resistance_flags = FLAMMABLE
	armor_type = /datum/armor/bucket_wooden

/datum/armor/bucket_wooden
	melee = 10
	acid = 50

// SKYRAT EDIT CHANGE START - LIQUIDS
/* Original
/obj/item/reagent_containers/cup/bucket/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/mop))
		if(reagents.total_volume < 1)
			user.balloon_alert(user, "empty!")
		else
			reagents.trans_to(O, 5, transferred_by = user)
			user.balloon_alert(user, "doused [O]")
			playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
		return
*/
/obj/item/reagent_containers/cup/bucket/attackby(obj/mop, mob/living/user, params)
	if(istype(mop, /obj/item/mop))
		var/is_right_clicking = LAZYACCESS(params2list(params), RIGHT_CLICK)
		if(is_right_clicking)
			if(mop.reagents.total_volume == 0)
				user.balloon_alert(user, "拖把是干的!")
				return
			if(reagents.total_volume == reagents.maximum_volume)
				user.balloon_alert(user, "拖把是满的!")
				return
			mop.reagents.remove_all(mop.reagents.total_volume * SQUEEZING_DISPERSAL_RATIO)
			mop.reagents.trans_to(src, mop.reagents.total_volume, transferred_by = user)
			user.balloon_alert(user, "挤干拖把")
		else
			if(reagents.total_volume < 1)
				user.balloon_alert(user, "容器是空的!")
			else
				reagents.trans_to(mop, 5, transferred_by = user)
				user.balloon_alert(user, "浸润拖把")
				playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)

	else if(isprox(mop)) //This works with wooden buckets for now. Somewhat unintended, but maybe someone will add sprites for it soon(TM)
		to_chat(user, span_notice("你添加[mop]到[src]."))
		qdel(mop)
		var/obj/item/bot_assembly/cleanbot/new_cleanbot_ass = new(null, src)
		user.put_in_hands(new_cleanbot_ass)
		return
// SKYRAT EDIT CHANGE END - LIQUIDS

/obj/item/reagent_containers/cup/bucket/equipped(mob/user, slot)
	. = ..()
	if (slot & ITEM_SLOT_HEAD)
		if(reagents.total_volume)
			to_chat(user, span_userdanger("[src]里面的东西洒了你一身!"))
			reagents.expose(user, TOUCH)
			reagents.clear_reagents()
		reagents.flags = NONE

/obj/item/reagent_containers/cup/bucket/dropped(mob/user)
	. = ..()
	reagents.flags = initial(reagent_flags)

/obj/item/reagent_containers/cup/bucket/equip_to_best_slot(mob/M)
	if(reagents.total_volume) //If there is water in a bucket, don't quick equip it to the head
		var/index = slot_equipment_priority.Find(ITEM_SLOT_HEAD)
		slot_equipment_priority.Remove(ITEM_SLOT_HEAD)
		. = ..()
		slot_equipment_priority.Insert(index, ITEM_SLOT_HEAD)
		return
	return ..()

/obj/item/pestle
	name = "研磨杵"
	desc = "研磨杵是一种古老的、简单的工具，与研钵结合使用来研磨榨汁."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "pestle"
	force = 7

/obj/item/reagent_containers/cup/mortar
	name = "研钵"
	desc = "研钵是一种特殊形状的碗，与研磨杵结合使用可以研磨榨汁，只是费力而且缓慢."
	desc_controls = "Alt加左键取出物品."
	icon_state = "mortar"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50, 100)
	volume = 100
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)
	resistance_flags = FLAMMABLE
	reagent_flags = OPENCONTAINER
	spillable = TRUE
	var/obj/item/grinded

/obj/item/reagent_containers/cup/mortar/click_alt(mob/user)
	if(!grinded)
		return CLICK_ACTION_BLOCKING
	grinded.forceMove(drop_location())
	grinded = null
	balloon_alert(user, "ejected")
	return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/cup/mortar/attackby(obj/item/I, mob/living/carbon/human/user)
	..()
	if(istype(I,/obj/item/pestle))
		if(grinded)
			if(user.getStaminaLoss() > 50)
				to_chat(user, span_warning("你太累了，无法工作!"))
				return
			var/list/choose_options = list(
				"研磨" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_grind"),
				"榨汁" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_juice")
			)
			var/picked_option = show_radial_menu(user, src, choose_options, radius = 38, require_near = TRUE)
			if(grinded && in_range(src, user) && user.is_holding(I) && picked_option)
				to_chat(user, span_notice("You start grinding..."))
				if(do_after(user, 2.5 SECONDS, target = src))
					user.adjustStaminaLoss(40)
					switch(picked_option)
						if("榨汁")
							return juice_item(grinded, user)
						if("研磨")
							return grind_item(grinded, user)
						else
							to_chat(user, span_notice("你试着研磨研钵本身而不是[grinded]. 你失败了."))
							return
			return
		else
			to_chat(user, span_warning("没有什么可研磨的!"))
			return
	if(grinded)
		to_chat(user, span_warning("里面已经有东西了!"))
		return
	if(I.juice_typepath || I.grind_results)
		I.forceMove(src)
		grinded = I
		return
	to_chat(user, span_warning("你无法研磨这个!"))

/obj/item/reagent_containers/cup/mortar/proc/grind_item(obj/item/item, mob/living/carbon/human/user)
	if(item.flags_1 & HOLOGRAM_1)
		to_chat(user, span_notice("你尝试研磨[item]，但它消失了"))
		qdel(item)
		return

	if(!item.grind(reagents, user))
		if(isstack(item))
			to_chat(usr, span_notice("[src]尝试尽可能将[item]磨碎."))
		else
			to_chat(user, span_danger("你没能研磨[item]."))
		return
	to_chat(user, span_notice("你把[item]磨成细粉."))
	grinded = null
	QDEL_NULL(item)

/obj/item/reagent_containers/cup/mortar/proc/juice_item(obj/item/item, mob/living/carbon/human/user)
	if(item.flags_1 & HOLOGRAM_1)
		to_chat(user, span_notice("你尝试榨取[item]，但它消失了!"))
		qdel(item)
		return

	if(!item.juice(reagents, user))
		to_chat(user, span_notice("你没能榨取[item]."))
		return
	to_chat(user, span_notice("你将[item]榨成液体."))
	grinded = null
	QDEL_NULL(item)

//Coffeepots: for reference, a standard cup is 30u, to allow 20u for sugar/sweetener/milk/creamer
/obj/item/reagent_containers/cup/coffeepot
	name = "咖啡壶"
	desc = "一个大咖啡壶，用来煮公司生活必备的咖啡，煮一次能倒满4杯标准咖啡杯."
	volume = 120
	icon_state = "coffeepot"
	fill_icon_state = "coffeepot"
	fill_icon_thresholds = list(0, 1, 30, 60, 100)

/obj/item/reagent_containers/cup/coffeepot/bluespace
	name = "蓝空咖啡壶"
	desc = "书呆子们能做出的最先进的咖啡壶: 外观时尚；刻度线；适配咖啡机；是的，它什么都有. 煮一次能倒满8杯标准咖啡杯."
	volume = 240
	icon_state = "coffeepot_bluespace"
	fill_icon_thresholds = list(0)

///Test tubes created by chem master and pandemic and placed in racks
/obj/item/reagent_containers/cup/tube
	name = "试管"
	desc = "小型试管."
	icon_state = "test_tube"
	fill_icon_state = "tube"
	inhand_icon_state = "atoxinbottle"
	worn_icon_state = "beaker"
	possible_transfer_amounts = list(5, 10, 15, 30)
	volume = 30
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)
