///hud action for starting and stopping flight
/datum/action/innate/flight
	name = "切换飞行"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_IMMOBILE|AB_CHECK_INCAPACITATED
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "flight"

/datum/action/innate/flight/Activate()
	var/mob/living/carbon/human/human = owner
	var/obj/item/organ/external/wings/functional/wings = human.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
	if(wings?.can_fly(human))
		wings.toggle_flight(human)
		if(!(human.movement_type & FLYING))
			to_chat(human, span_notice("你轻轻地回到地上..."))
		else
			to_chat(human, span_notice("你拍打着翅膀，开始在地面上轻轻地盘旋..."))
			human.set_resting(FALSE, TRUE)

///The true wings that you can use to fly and shit (you cant actually shit with them)
/obj/item/organ/external/wings/functional
	///The flight action object
	var/datum/action/innate/flight/fly

	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/functional

	///Are our wings open or closed?
	var/wings_open = FALSE

	// grind_results = list(/datum/reagent/flightpotion = 5)
	food_reagents = list(/datum/reagent/flightpotion = 5)

/obj/item/organ/external/wings/functional/Destroy()
	QDEL_NULL(fly)
	return ..()

/obj/item/organ/external/wings/functional/Insert(mob/living/carbon/receiver, special, movement_flags)
	. = ..()
	if(!.)
		return
	if(QDELETED(fly))
		fly = new
	fly.Grant(receiver)

/obj/item/organ/external/wings/functional/Remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	fly?.Remove(organ_owner)
	if(wings_open)
		toggle_flight(organ_owner)

/obj/item/organ/external/wings/functional/on_life(seconds_per_tick, times_fired)
	. = ..()
	handle_flight(owner)

///Called on_life(). Handle flight code and check if we're still flying
/obj/item/organ/external/wings/functional/proc/handle_flight(mob/living/carbon/human/human)
	if(!(human.movement_type & FLYING))
		return FALSE
	if(!can_fly(human))
		toggle_flight(human)
		return FALSE
	return TRUE


///Check if we're still eligible for flight (wings covered, atmosphere too thin, etc)
/obj/item/organ/external/wings/functional/proc/can_fly(mob/living/carbon/human/human)
	if(human.stat || human.body_position == LYING_DOWN)
		return FALSE
	//Jumpsuits have tail holes, so it makes sense they have wing holes too
	if(human.wear_suit && ((human.wear_suit.flags_inv & HIDEJUMPSUIT) && (!human.wear_suit.species_exception || !is_type_in_list(src, human.wear_suit.species_exception))))
		to_chat(human, span_warning("你的外装挡住了你的翅膀!"))
		return FALSE
	var/turf/location = get_turf(human)
	if(!location)
		return FALSE

	var/datum/gas_mixture/environment = location.return_air()
	if(environment?.return_pressure() < HAZARD_LOW_PRESSURE + 10)
		to_chat(human, span_warning("大气环境太稀薄了，你飞不起来!"))
		return FALSE
	else
		return TRUE

///Slipping but in the air?
/obj/item/organ/external/wings/functional/proc/fly_slip(mob/living/carbon/human/human)
	var/obj/buckled_obj
	if(human.buckled)
		buckled_obj = human.buckled

	to_chat(human, span_notice("你张开翅膀飞了起来!"))

	playsound(human.loc, 'sound/misc/slip.ogg', 50, TRUE, -3)

	for(var/obj/item/choking_hazard in human.held_items)
		human.accident(choking_hazard)

	var/olddir = human.dir

	human.stop_pulling()
	if(buckled_obj)
		buckled_obj.unbuckle_mob(human)
		step(buckled_obj, olddir)
	else
		human.AddComponent(/datum/component/force_move, get_ranged_target_turf(human, olddir, 4), TRUE)
	return TRUE

///UNSAFE PROC, should only be called through the Activate or other sources that check for CanFly
/obj/item/organ/external/wings/functional/proc/toggle_flight(mob/living/carbon/human/human)
	if(!HAS_TRAIT_FROM(human, TRAIT_MOVE_FLYING, SPECIES_FLIGHT_TRAIT))
		human.physiology.stun_mod *= 2
		human.add_traits(list(TRAIT_NO_FLOATING_ANIM, TRAIT_MOVE_FLYING), SPECIES_FLIGHT_TRAIT)
		passtable_on(human, SPECIES_FLIGHT_TRAIT)
		open_wings()
	else
		human.physiology.stun_mod *= 0.5
		human.remove_traits(list(TRAIT_NO_FLOATING_ANIM, TRAIT_MOVE_FLYING), SPECIES_FLIGHT_TRAIT)
		passtable_off(human, SPECIES_FLIGHT_TRAIT)
		close_wings()

	human.refresh_gravity()

///SPREAD OUR WINGS AND FLLLLLYYYYYY
/obj/item/organ/external/wings/functional/proc/open_wings()
	var/datum/bodypart_overlay/mutant/wings/functional/overlay = bodypart_overlay
	overlay.open_wings()
	wings_open = TRUE
	owner.update_body_parts()

///close our wings
/obj/item/organ/external/wings/functional/proc/close_wings()
	var/datum/bodypart_overlay/mutant/wings/functional/overlay = bodypart_overlay
	wings_open = FALSE
	overlay.close_wings()
	owner.update_body_parts()

	if(isturf(owner?.loc))
		var/turf/location = loc
		location.Entered(src, NONE)

///Bodypart overlay of function wings, including open and close functionality!
/datum/bodypart_overlay/mutant/wings/functional
	///Are our wings currently open? Change through open_wings or close_wings()
	VAR_PRIVATE/wings_open = FALSE
	///Feature render key for opened wings
	var/open_feature_key = "wingsopen"

/datum/bodypart_overlay/mutant/wings/functional/get_global_feature_list()
	/* SKYRAT EDIT - CUSTOMIZATION - ORIGINAL:
	if(wings_open)
		return SSaccessories.wings_open_list
	else
		return SSaccessories.wings_list
	*/ // ORIGINAL END - SKYRAT EDIT START - CUSTOMIZATION - TODO: Add support for wings_open
	if(wings_open)
		return SSaccessories.sprite_accessories["wings_open"]

	return SSaccessories.sprite_accessories["wings"]
	// SKYRAT EDIT END

///Update our wingsprite to the open wings variant
/datum/bodypart_overlay/mutant/wings/functional/proc/open_wings()
	wings_open = TRUE
	feature_key = open_feature_key
	set_appearance_from_name(sprite_datum.name) //It'll look for the same name again, but this time from the open wings list

///Update our wingsprite to the closed wings variant
/datum/bodypart_overlay/mutant/wings/functional/proc/close_wings()
	wings_open = FALSE
	feature_key = initial(feature_key)
	set_appearance_from_name(sprite_datum.name)

/datum/bodypart_overlay/mutant/wings/functional/generate_icon_cache()
	. = ..()
	. += wings_open ? "open" : "closed"

///angel wings, which relate to humans. comes with holiness.
/obj/item/organ/external/wings/functional/angel
	name = "天使翅膀"
	desc = "不包括自以为是的态度."
	sprite_accessory_override = /datum/sprite_accessory/wings_open/angel

	organ_traits = list(TRAIT_HOLY)

///dragon wings, which relate to lizards.
/obj/item/organ/external/wings/functional/dragon
	name = "龙翼"
	desc = "嘿，嘿-不是蜥蜴的翅膀，龙的翅膀，巨龙的翅膀."
	sprite_accessory_override = /datum/sprite_accessory/wings/dragon

///robotic wings, which relate to androids.
/obj/item/organ/external/wings/functional/robotic
	name = "机械翅膀"
	desc = "这些微型装置利用微型悬浮引擎，在业内也被称为“微翅”，能够一次提起几克重的物体；如果聚集足够多的这种装置，就能举起令人惊叹的大件物品."
	organ_flags = ORGAN_ROBOTIC
	sprite_accessory_override = /datum/sprite_accessory/wings/robotic

///skeletal wings, which relate to skeletal races.
/obj/item/organ/external/wings/functional/skeleton
	name = "骨翼"
	desc = "靠青春期少年的笔记本涂鸦提供动力？开个玩笑。，说真的，这些是怎么让你飞起来的？！"
	sprite_accessory_override = /datum/sprite_accessory/wings/skeleton

/obj/item/organ/external/wings/functional/moth/make_flap_sound(mob/living/carbon/wing_owner)
	playsound(wing_owner, 'sound/voice/moth/moth_flutter.ogg', 50, TRUE)

///mothra wings, which relate to moths.
/obj/item/organ/external/wings/functional/moth/mothra
	name = "飞蛾翅膀"
	desc = "像传说中伟大的母亲那样飞翔."
	sprite_accessory_override = /datum/sprite_accessory/wings/mothra

///megamoth wings, which relate to moths as an alternate choice. they're both pretty cool.
/obj/item/organ/external/wings/functional/moth/megamoth
	name = "大飞蛾翅膀"
	desc = "不要这么扑棱."
	sprite_accessory_override = /datum/sprite_accessory/wings/megamoth

///fly wings, which relate to flies.
/obj/item/organ/external/wings/functional/fly
	name = "苍蝇翅膀"
	desc = "像苍蝇一样飞."
	sprite_accessory_override = /datum/sprite_accessory/wings/fly

///slime wings, which relate to slimes.
/obj/item/organ/external/wings/functional/slime
	name = "史莱姆翅膀"
	desc = "这么软的东西是怎么飞起来的?"
	sprite_accessory_override = /datum/sprite_accessory/wings/slime
