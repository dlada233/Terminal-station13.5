//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/

///////////
//MATCHES//
///////////
/obj/item/match
	name = "火柴"
	desc = "简易的火柴，点燃精致的香烟."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	w_class = WEIGHT_CLASS_TINY
	heat = 1000
	grind_results = list(/datum/reagent/phosphorus = 2)
	/// Whether this match has been lit.
	var/lit = FALSE
	/// Whether this match has burnt out.
	var/burnt = FALSE
	/// How long the match lasts in seconds
	var/smoketime = 10 SECONDS

/obj/item/match/process(seconds_per_tick)
	smoketime -= seconds_per_tick * (1 SECONDS)
	if(smoketime <= 0)
		matchburnout()
	else
		open_flame(heat)

/obj/item/match/fire_act(exposed_temperature, exposed_volume)
	matchignite()

/obj/item/match/proc/matchignite()
	if(lit || burnt)
		return
	//SKYRAT EDIT ADDITION
	var/turf/my_turf = get_turf(src)
	my_turf.pollute_turf(/datum/pollutant/sulphur, 5)
	//SKYRAT EDIT END
	playsound(src, 'sound/items/match_strike.ogg', 15, TRUE)
	lit = TRUE
	icon_state = "match_lit"
	damtype = BURN
	force = 3
	hitsound = 'sound/items/welder.ogg'
	inhand_icon_state = "cigon"
	name = "点燃的[initial(name)]"
	desc = "一根[initial(name)]，这根已经点燃了."
	attack_verb_continuous = string_list(list("灼烧", "火燎"))
	attack_verb_simple = string_list(list("灼烧", "火燎"))
	START_PROCESSING(SSobj, src)
	update_appearance()

/obj/item/match/proc/matchburnout()
	if(!lit)
		return

	lit = FALSE
	burnt = TRUE
	damtype = BRUTE
	force = initial(force)
	icon_state = "match_burnt"
	inhand_icon_state = "cigoff"
	name = "燃尽的[initial(name)]"
	desc = "一根[initial(name)]，这根曾经有一段辉煌的时间."
	attack_verb_continuous = string_list(list("拍"))
	attack_verb_simple = string_list(list("拍"))
	STOP_PROCESSING(SSobj, src)

/obj/item/match/extinguish()
	. = ..()
	matchburnout()

/obj/item/match/dropped(mob/user)
	matchburnout()
	return ..()

/obj/item/match/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!isliving(M))
		return

	if(lit && M.ignite_mob())
		message_admins("[ADMIN_LOOKUPFLW(user)]在[AREACOORD(user)]用[src]点燃了[key_name_admin(M)]")
		user.log_message("用[src]点燃了[key_name(M)]", LOG_ATTACK)

	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)
	if(!lit || !cig || user.combat_mode)
		..()
		return

	if(cig.lit)
		to_chat(user, span_warning("[cig]已经点燃了!"))
	if(M == user)
		cig.attackby(src, user)
	else
		cig.light(span_notice("[user] holds [src] out for [M], and lights [cig]."))

/// Finds a cigarette on another mob to help light.
/obj/item/proc/help_light_cig(mob/living/M)
	var/mask_item = M.get_item_by_slot(ITEM_SLOT_MASK)
	if(istype(mask_item, /obj/item/clothing/mask/cigarette))
		return mask_item

/obj/item/match/get_temperature()
	return lit * heat

/obj/item/match/firebrand
	name = "火把"
	desc = "一个未点燃的火把，为什么不干脆直接叫棍子呢？"
	smoketime = 40 SECONDS
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/carbon = 2)

/obj/item/match/firebrand/Initialize(mapload)
	. = ..()
	matchignite()

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/cigarette
	name = "香烟"
	desc = "用烟草和尼古丁卷成的纸卷."
	icon_state = "cigoff"
	inhand_icon_state = "cigon" //gets overriden during intialize(), just have it for unit test sanity.
	throw_speed = 0.5
	w_class = WEIGHT_CLASS_TINY
	body_parts_covered = null
	grind_results = list()
	heat = 1000
	throw_verb = "轻弹"
	/// Whether this cigarette has been lit.
	var/lit = FALSE
	/// Whether this cigarette should start lit.
	var/starts_lit = FALSE
	// Note - these are in masks.dmi not in cigarette.dmi
	/// The icon state used when this is lit.
	var/icon_on = "cigon"
	/// The icon state used when this is extinguished.
	var/icon_off = "cigoff"
	/// The inhand icon state used when this is lit.
	var/inhand_icon_on = "cigon"
	/// The inhand icon state used when this is extinguished.
	var/inhand_icon_off = "cigoff"
	/// How long the cigarette lasts in seconds
	var/smoketime = 6 MINUTES
	/// How much time between drags of the cigarette.
	var/dragtime = 10 SECONDS
	/// The cooldown that prevents just huffing the entire cigarette at once.
	COOLDOWN_DECLARE(drag_cooldown)
	/// The type of cigarette butt spawned when this burns out.
	var/type_butt = /obj/item/cigbutt
	/// The capacity for chems this cigarette has.
	var/chem_volume = 30
	/// The reagents that this cigarette starts with.
	var/list/list_reagents = list(/datum/reagent/drug/nicotine = 15)
	/// Should we smoke all of the chems in the cig before it runs out. Splits each puff to take a portion of the overall chems so by the end you'll always have consumed all of the chems inside.
	var/smoke_all = FALSE
	/// How much damage this deals to the lungs per drag.
	var/lung_harm = 1
	/// If, when glorf'd, we will choke on this cig forever
	var/choke_forever = FALSE
	/// When choking, what is the maximum amount of time we COULD choke for
	var/choke_time_max = 30 SECONDS // I am mean

	var/pollution_type = /datum/pollutant/smoke //SKYRAT EDIT ADDITION /// What type of pollution does this produce on smoking, changed to weed pollution sometimes


/obj/item/clothing/mask/cigarette/Initialize(mapload)
	. = ..()
	create_reagents(chem_volume, INJECTABLE | NO_REACT)
	if(list_reagents)
		reagents.add_reagent_list(list_reagents)
	if(starts_lit)
		light()
	AddComponent(/datum/component/knockoff, 90, list(BODY_ZONE_PRECISE_MOUTH), slot_flags) //90% to knock off when wearing a mask
	AddElement(/datum/element/update_icon_updates_onmob)
	icon_state = icon_off
	inhand_icon_state = inhand_icon_off

/obj/item/clothing/mask/cigarette/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/mask/cigarette/equipped(mob/equipee, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_MASK))
		UnregisterSignal(equipee, COMSIG_HUMAN_FORCESAY)
		return
	RegisterSignal(equipee, COMSIG_HUMAN_FORCESAY, PROC_REF(on_forcesay))

/obj/item/clothing/mask/cigarette/dropped(mob/dropee)
	. = ..()
	UnregisterSignal(dropee, COMSIG_HUMAN_FORCESAY)

/obj/item/clothing/mask/cigarette/proc/on_forcesay(mob/living/source)
	SIGNAL_HANDLER
	source.apply_status_effect(/datum/status_effect/choke, src, lit, choke_forever ? -1 : rand(25 SECONDS, choke_time_max))

/obj/item/clothing/mask/cigarette/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]狂抽[src]!看起来想早日得肺癌."))
	return (TOXLOSS|OXYLOSS)

/obj/item/clothing/mask/cigarette/attackby(obj/item/W, mob/user, params)
	if(lit)
		return ..()

	var/lighting_text = W.ignition_effect(src, user)
	if(!lighting_text)
		return ..()

	if(!check_oxygen(user)) //cigarettes need oxygen
		balloon_alert(user, "没有空气!")
		return ..()

	if(smoketime > 0)
		light(lighting_text)
	else
		to_chat(user, span_warning("没有什么可抽的."))

/// Checks that we have enough air to smoke
/obj/item/clothing/mask/cigarette/proc/check_oxygen(mob/user)
	if (reagents.has_reagent(/datum/reagent/oxygen))
		return TRUE
	var/datum/gas_mixture/air = return_air()
	if (!isnull(air) && air.has_gas(/datum/gas/oxygen, 1))
		return TRUE
	if (!iscarbon(user))
		return FALSE
	var/mob/living/carbon/the_smoker = user
	return the_smoker.can_breathe_helmet()

/obj/item/clothing/mask/cigarette/afterattack(obj/item/reagent_containers/cup/glass, mob/user, proximity)
	. = ..()
	if(!proximity || lit) //can't dip if cigarette is lit (it will heat the reagents in the glass instead)
		return
	if(!istype(glass)) //you can dip cigarettes into beakers
		return

	if(glass.reagents.trans_to(src, chem_volume, transferred_by = user)) //if reagents were transferred, show the message
		to_chat(user, span_notice("你把[src]浸入[glass]中."))
	//if not, either the beaker was empty, or the cigarette was full
	else if(!glass.reagents.total_volume)
		to_chat(user, span_warning("[glass]是空的!"))
	else
		to_chat(user, span_warning("[src]已经满了!"))

	return AFTERATTACK_PROCESSED_ITEM

/obj/item/clothing/mask/cigarette/update_icon_state()
	. = ..()
	if(lit)
		icon_state = icon_on
		inhand_icon_state = inhand_icon_on
	else
		icon_state = icon_off
		inhand_icon_state = inhand_icon_off

/// Lights the cigarette with given flavor text.
/obj/item/clothing/mask/cigarette/proc/light(flavor_text = null)
	if(lit)
		return

	lit = TRUE

	if(!(flags_1 & INITIALIZED_1))
		update_icon()
		return

	attack_verb_continuous = string_list(list("灼烧", "火燎"))
	attack_verb_simple = string_list(list("灼烧", "火燎"))
	hitsound = 'sound/items/welder.ogg'
	damtype = BURN
	force = 4
	if(reagents.get_reagent_amount(/datum/reagent/toxin/plasma)) // the plasma explodes when exposed to fire
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/plasma) / 2.5, 1), get_turf(src), 0, 0)
		e.start(src)
		qdel(src)
		return
	if(reagents.get_reagent_amount(/datum/reagent/fuel)) // the fuel explodes, too, but much less violently
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/fuel) / 5, 1), get_turf(src), 0, 0)
		e.start(src)
		qdel(src)
		return
	//SKYRAT EDIT ADDITION
	// Setting the puffed pollutant to cannabis if we're smoking the space drugs reagent(obtained from cannabis)
	if(reagents.has_reagent(/datum/reagent/drug/space_drugs))
		pollution_type = /datum/pollutant/smoke/cannabis
	// allowing reagents to react after being lit
	//SKYRAT EDIT END

	reagents.flags &= ~(NO_REACT)
	reagents.handle_reactions()
	update_icon()
	if(flavor_text)
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
	START_PROCESSING(SSobj, src)

	//can't think of any other way to update the overlays :<
	if(ismob(loc))
		var/mob/M = loc
		M.update_worn_mask()
		M.update_held_items()

/obj/item/clothing/mask/cigarette/extinguish()
	. = ..()
	if(!lit)
		return
	attack_verb_continuous = null
	attack_verb_simple = null
	hitsound = null
	damtype = BRUTE
	force = 0
	STOP_PROCESSING(SSobj, src)
	reagents.flags |= NO_REACT
	lit = FALSE
	update_icon()

	if(ismob(loc))
		var/mob/living/M = loc
		to_chat(M, span_notice("Your [name] goes out."))
		M.update_worn_mask()
		M.update_held_items()

/// Handles processing the reagents in the cigarette.
/obj/item/clothing/mask/cigarette/proc/handle_reagents()
	if(!reagents.total_volume)
		return
	reagents.expose_temperature(heat, 0.05)
	if(!reagents.total_volume) //may have reacted and gone to 0 after expose_temperature
		return
	var/to_smoke = smoke_all ? (reagents.total_volume * (dragtime / smoketime)) : REAGENTS_METABOLISM
	var/mob/living/carbon/smoker = loc
	// These checks are a bit messy but at least they're fairly readable
	// Check if the smoker is a carbon mob, since it needs to have wear_mask
	if(!istype(smoker))
		// If not, check if it's a gas mask
		if(!istype(smoker, /obj/item/clothing/mask/gas))
			reagents.remove_any(to_smoke)
			return

		smoker = smoker.loc

		// If it is, check if that mask is on a carbon mob
		if(!istype(smoker) || smoker.get_item_by_slot(ITEM_SLOT_MASK) != loc)
			reagents.remove_any(to_smoke)
			return
	else
		if(src != smoker.wear_mask)
			reagents.remove_any(to_smoke)
			return

	reagents.expose(smoker, INGEST, min(to_smoke / reagents.total_volume, 1))
	var/obj/item/organ/internal/lungs/lungs = smoker.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(lungs && IS_ORGANIC_ORGAN(lungs))
		var/smoker_resistance = HAS_TRAIT(smoker, TRAIT_SMOKER) ? 0.5 : 1
		smoker.adjustOrganLoss(ORGAN_SLOT_LUNGS, lung_harm * smoker_resistance)
	if(!reagents.trans_to(smoker, to_smoke, methods = INGEST, ignore_stomach = TRUE))
		reagents.remove_any(to_smoke)

/obj/item/clothing/mask/cigarette/process(seconds_per_tick)
	var/mob/living/user = isliving(loc) ? loc : null
	user?.ignite_mob()

	if(!check_oxygen(user))
		extinguish()
		return

	// SKYRAT EDIT ADDITION START - Pollution
	var/turf/location = get_turf(src)
	location.pollute_turf(pollution_type, 5, POLLUTION_PASSIVE_EMITTER_CAP)
	// SKYRAT EDIT END

	smoketime -= seconds_per_tick * (1 SECONDS)
	if(smoketime <= 0)
		put_out(user)
		return

	open_flame(heat)
	if((reagents?.total_volume) && COOLDOWN_FINISHED(src, drag_cooldown))
		COOLDOWN_START(src, drag_cooldown, dragtime)
		handle_reagents()

/obj/item/clothing/mask/cigarette/attack_self(mob/user)
	if(lit)
		put_out(user, TRUE)
	return ..()

/obj/item/clothing/mask/cigarette/proc/put_out(mob/user, done_early = FALSE)
	var/atom/location = drop_location()
	if(done_early)
		user.visible_message(span_notice("[user]淡定地将扔在地上的[src]踩灭."))
		new /obj/effect/decal/cleanable/ash(location)
	else if(user)
		to_chat(user, span_notice("Your [name] goes out."))
	new type_butt(location)
	qdel(src)

/obj/item/clothing/mask/cigarette/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M))
		return ..()
	if(M.on_fire && !lit)
		light(span_notice("[user]用燃烧的[M]点燃了自己的[src]，真是个铁骨硬汉."))
		return
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)
	if(!lit || !cig || user.combat_mode)
		return ..()

	if(cig.lit)
		to_chat(user, span_warning("[cig.name]已经点燃了!"))
	if(M == user)
		cig.attackby(src, user)
	else
		cig.light(span_notice("[user] holds the [name] out for [M], and lights [M.p_their()] [cig.name]."))

/obj/item/clothing/mask/cigarette/fire_act(exposed_temperature, exposed_volume)
	light()

/obj/item/clothing/mask/cigarette/get_temperature()
	return lit * heat

jay
// Cigarette brands.
/obj/item/clothing/mask/cigarette/space_cigarette
	desc = "一根\"太空牌\"香烟——让你想在哪抽就在哪抽！."
	list_reagents = list(/datum/reagent/drug/nicotine = 9, /datum/reagent/oxygen = 9)
	smoketime = 4 MINUTES // space cigs have a shorter burn time than normal cigs
	smoke_all = TRUE // so that it doesn't runout of oxygen while being smoked in space

/obj/item/clothing/mask/cigarette/dromedary
	desc = "一根\"单峰骆驼\"牌香烟，与流行的观点相反，它并不含甘汞，但是有一股水味."
	list_reagents = list(/datum/reagent/drug/nicotine = 13, /datum/reagent/water = 5) //camel has water

/obj/item/clothing/mask/cigarette/uplift
	desc = "一根\"平滑上升\"牌香烟，气味清新."
	list_reagents = list(/datum/reagent/drug/nicotine = 13, /datum/reagent/consumable/menthol = 5)

/obj/item/clothing/mask/cigarette/robust
	desc = "一根\"强健\"牌香烟."

/obj/item/clothing/mask/cigarette/robustgold
	desc = "一根金版\"强健\"牌香烟."
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/gold = 3) // Just enough to taste a hint of expensive metal.

/obj/item/clothing/mask/cigarette/carp
	desc = "一根经典鲤鱼牌香烟，在包装侧面写有说明表示其不含鲤鱼毒."

/obj/item/clothing/mask/cigarette/carp/Initialize(mapload)
	. = ..()
	if(!prob(5))
		return
	reagents?.add_reagent(/datum/reagent/toxin/carpotoxin , 3) // They lied

/obj/item/clothing/mask/cigarette/syndicate
	desc = "一根未知品牌的香烟."
	chem_volume = 60
	smoketime = 2 MINUTES
	smoke_all = TRUE
	lung_harm = 1.5
	list_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/medicine/omnizine = 15)

/obj/item/clothing/mask/cigarette/shadyjims
	desc = "一根\"阴暗吉姆\"超细香烟"
	lung_harm = 1.5
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/toxin/lipolicide = 4, /datum/reagent/ammonia = 2, /datum/reagent/toxin/plantbgone = 1, /datum/reagent/toxin = 1.5)

/obj/item/clothing/mask/cigarette/xeno
	desc = "一根\"异滤牌\"香烟."
	lung_harm = 2
	list_reagents = list (/datum/reagent/drug/nicotine = 20, /datum/reagent/medicine/regen_jelly = 15, /datum/reagent/drug/krokodil = 4)

// Rollies.

/obj/item/clothing/mask/cigarette/rollie
	name = "手卷香烟"
	desc = "一卷用薄纸包裹的干燥烟草."
	icon_state = "spliffoff"
	icon_on = "spliffon"
	icon_off = "spliffoff"
	type_butt = /obj/item/cigbutt/roach
	throw_speed = 0.5
	smoketime = 4 MINUTES
	chem_volume = 50
	list_reagents = null
	choke_time_max = 40 SECONDS

/obj/item/clothing/mask/cigarette/rollie/Initialize(mapload)
	name = pick(list(
		"bifta",
		"bifter",
		"bird",
		"blunt",
		"bloint",
		"boof",
		"boofer",
		"bomber",
		"bone",
		"bun",
		"doink",
		"doob",
		"doober",
		"doobie",
		"dutch",
		"fatty",
		"hogger",
		"hooter",
		"hootie",
		"\improper J",
		"jay",
		"jimmy",
		"joint",
		"juju",
		"jeebie weebie",
		"number",
		"owl",
		"phattie",
		"puffer",
		"reef",
		"reefer",
		"rollie",
		"scoobie",
		"shorty",
		"spiff",
		"spliff",
		"toke",
		"torpedo",
		"zoot",
		"zooter"))
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/clothing/mask/cigarette/rollie/nicotine
	list_reagents = list(/datum/reagent/drug/nicotine = 15)

/obj/item/clothing/mask/cigarette/rollie/trippy
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/drug/mushroomhallucinogen = 35)
	starts_lit = TRUE

/obj/item/clothing/mask/cigarette/rollie/cannabis
	list_reagents = list(/datum/reagent/drug/cannabis = 15)

/obj/item/clothing/mask/cigarette/rollie/mindbreaker
	list_reagents = list(/datum/reagent/toxin/mindbreaker = 35, /datum/reagent/toxin/lipolicide = 15)

/obj/item/clothing/mask/cigarette/candy
	name = "Little Timmy牌糖果香烟" // \improper
	desc = "全年龄可抽*! 不含任何尼古丁，健康风险可以在烟头上查阅."
	smoketime = 2 MINUTES
	icon_state = "candyoff"
	icon_on = "candyon"
	icon_off = "candyoff" //make sure to add positional sprites in icons/obj/cigarettes.dmi if you add more.
	inhand_icon_off = "candyoff"
	type_butt = /obj/item/food/candy_trash
	heat = 473.15 // Lowered so that the sugar can be carmalized, but not burnt.
	lung_harm = 0.5
	list_reagents = list(/datum/reagent/consumable/sugar = 20)
	choke_time_max = 70 SECONDS // This shit really is deadly

/obj/item/clothing/mask/cigarette/candy/nicotine
	desc = "全年龄可抽*! 不含任何尼古丁，健康风险可以在烟头上查阅."
	type_butt = /obj/item/food/candy_trash/nicotine
	list_reagents = list(/datum/reagent/consumable/sugar = 20, /datum/reagent/drug/nicotine = 20) //oh no!
	smoke_all = TRUE //timmy's not getting out of this one

/obj/item/cigbutt/roach
	name = "烟头"
	desc = "一支脏兮兮的旧烟头，对不吸烟的人来说，就是用过的烟卷."
	icon_state = "roach"

/obj/item/cigbutt/roach/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)


////////////
// CIGARS //
////////////
/obj/item/clothing/mask/cigarette/cigar
	name = "优质雪茄"
	desc = "一卷棕色的烟草和...嗯，或许是吧，这根也太大了."
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff" //make sure to add positional sprites in icons/obj/cigarettes.dmi if you add more.
	inhand_icon_state = "cigaron" //gets overriden during intialize(), just have it for unit test sanity.
	inhand_icon_on = "cigaron"
	inhand_icon_off = "cigaroff"
	type_butt = /obj/item/cigbutt/cigarbutt
	throw_speed = 0.5
	smoketime = 11 MINUTES
	chem_volume = 40
	list_reagents = list(/datum/reagent/drug/nicotine = 25)
	choke_time_max = 40 SECONDS

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "高斯巴强健雪茄" // \improper
	desc = "有了它，你对雪茄便别无所求."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 20 MINUTES
	chem_volume = 80
	list_reagents = list(/datum/reagent/drug/nicotine = 40)

/obj/item/clothing/mask/cigarette/cigar/havana
	name = "优质哈瓦那雪茄"
	desc = "只为顶级中的顶级."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 30 MINUTES
	chem_volume = 60
	list_reagents = list(/datum/reagent/drug/nicotine = 45)

/obj/item/cigbutt
	name = "烟蒂"
	desc = "一个脏兮兮的旧烟头."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	grind_results = list(/datum/reagent/carbon = 2)

/obj/item/cigbutt/cigarbutt
	name = "雪茄蒂"
	desc = "一个脏兮兮的旧雪茄蒂."
	icon_state = "cigarbutt"

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/cigarette/pipe
	name = "烟斗"
	desc = "抽烟的烟斗，可能是用海泡石之类的东西做的."
	icon_state = "pipeoff"
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	inhand_icon_state = null
	inhand_icon_on = null
	inhand_icon_off = null
	smoketime = 0
	chem_volume = 200 // So we can fit densified chemicals plants
	list_reagents = null
	w_class = WEIGHT_CLASS_SMALL
	choke_forever = TRUE
	///name of the stuff packed inside this pipe
	var/packeditem

/obj/item/clothing/mask/cigarette/pipe/Initialize(mapload)
	. = ..()
	update_name()

/obj/item/clothing/mask/cigarette/pipe/update_name()
	. = ..()
	name = packeditem ? "[packeditem] [initial(name)]" : "空 [initial(name)]"

/obj/item/clothing/mask/cigarette/pipe/put_out(mob/user, done_early = FALSE)
	lit = FALSE
	if(done_early)
		user.visible_message(span_notice("[user] puts out [src]."), span_notice("You put out [src]."))

	else
		if(user)
			to_chat(user, span_notice("Your [name] goes out."))
		packeditem = null
	update_icon()

	inhand_icon_state = icon_off
	user?.update_worn_mask()
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/mask/cigarette/pipe/attackby(obj/item/thing, mob/user, params)
	if(!istype(thing, /obj/item/food/grown))
		return ..()

	var/obj/item/food/grown/to_smoke = thing
	if(packeditem)
		to_chat(user, span_warning("已经填入东西了!"))
		return
	if(!HAS_TRAIT(to_smoke, TRAIT_DRIED))
		to_chat(user, span_warning("必须先把它弄干!"))
		return

	to_chat(user, span_notice("你把[to_smoke]填入[src]."))
	smoketime = 13 MINUTES
	packeditem = to_smoke.name
	update_name()
	if(to_smoke.reagents)
		to_smoke.reagents.trans_to(src, to_smoke.reagents.total_volume, transferred_by = user)
	qdel(to_smoke)


/obj/item/clothing/mask/cigarette/pipe/attack_self(mob/user)
	var/atom/location = drop_location()
	if(packeditem && !lit)
		to_chat(user, span_notice("你将[src]清空到[location]上."))
		new /obj/effect/decal/cleanable/ash(location)
		packeditem = null
		smoketime = 0
		reagents.clear_reagents()
		update_name()
		return
	return ..()

/obj/item/clothing/mask/cigarette/pipe/cobpipe
	name = "玉米烟斗"
	desc = "最初在乡下农夫间流行，至今仍受太空世代青睐的经典尼古丁输送系统.“对此，麦克阿瑟将军评论到...”"
	icon_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	icon_off = "cobpipeoff"
	inhand_icon_on = null
	inhand_icon_off = null

/////////
//ZIPPO//
/////////
/obj/item/lighter
	name = "Zippo打火机" // \improper
	desc = "Zippo."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "zippo"
	inhand_icon_state = "zippo"
	worn_icon_state = "lighter"
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	heat = 1500
	resistance_flags = FIRE_PROOF
	grind_results = list(/datum/reagent/iron = 1, /datum/reagent/fuel = 5, /datum/reagent/fuel/oil = 5)
	custom_price = PAYCHECK_CREW * 1.1
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.6
	light_color = LIGHT_COLOR_FIRE
	light_on = FALSE
	/// Whether the lighter is lit.
	var/lit = FALSE
	/// Whether the lighter is fancy. Fancy lighters have fancier flavortext and won't burn thumbs.
	var/fancy = TRUE
	/// The engraving overlay used by this lighter.
	var/overlay_state
	/// A list of possible engraving overlays.
	var/overlay_list = list(
		"单色",
		"爵士",
		"拾叁",
		"蛇案"
		)

/obj/item/lighter/Initialize(mapload)
	. = ..()
	if(!overlay_state)
		overlay_state = pick(overlay_list)
	AddComponent(\
		/datum/component/bullet_intercepting,\
		block_chance = 0.5,\
		active_slots = ITEM_SLOT_SUITSTORE,\
		on_intercepted = CALLBACK(src, PROC_REF(on_intercepted_bullet)),\
	)
	update_appearance()

/// Destroy the lighter when it's shot by a bullet
/obj/item/lighter/proc/on_intercepted_bullet(mob/living/victim, obj/projectile/bullet)
	victim.visible_message(span_warning("\The [bullet]击中了[victim]的打火机!"))
	playsound(victim, get_sfx(SFX_RICOCHET), 100, TRUE)
	new /obj/effect/decal/cleanable/oil(get_turf(src))
	do_sparks(1, TRUE, src)
	victim.dropItemToGround(src, force = TRUE, silent = TRUE)
	qdel(src)

/obj/item/lighter/cyborg_unequip(mob/user)
	if(!lit)
		return
	set_lit(FALSE)

/obj/item/lighter/suicide_act(mob/living/carbon/user)
	if (lit)
		user.visible_message(span_suicide("[user]将脸靠近[src]的火焰!这是一种自杀行为!"))
		playsound(src, 'sound/items/welder.ogg', 50, TRUE)
		return FIRELOSS
	else
		user.visible_message(span_suicide("[user]用[src]拍自己!这是一种自杀行为!"))
		return BRUTELOSS

/obj/item/lighter/update_icon_state()
	icon_state = "[initial(icon_state)][lit ? "-on" : ""]"
	return ..()

/obj/item/lighter/update_overlays()
	. = ..()
	. += create_lighter_overlay()

/// Generates an overlay used by this lighter.
/obj/item/lighter/proc/create_lighter_overlay()
	return mutable_appearance(icon, "lighter_overlay_[overlay_state][lit ? "-on" : ""]")

/obj/item/lighter/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		. = span_infoplain(span_rose("随着手腕轻轻一挥, [user]丝滑地用[src]点燃了[A]，Damn [user.p_theyre()] cool."))

/obj/item/lighter/proc/set_lit(new_lit)
	if(lit == new_lit)
		return

	lit = new_lit
	if(lit)
		force = 5
		damtype = BURN
		hitsound = 'sound/items/welder.ogg'
		attack_verb_continuous = string_list(list("灼烧", "火燎"))
		attack_verb_simple = string_list(list("灼烧", "火燎"))
		START_PROCESSING(SSobj, src)
	else
		hitsound = SFX_SWING_HIT
		force = 0
		attack_verb_continuous = null //human_defense.dm takes care of it
		attack_verb_simple = null
		STOP_PROCESSING(SSobj, src)
	set_light_on(lit)
	update_appearance()

/obj/item/lighter/extinguish()
	. = ..()
	set_lit(FALSE)

/obj/item/lighter/attack_self(mob/living/user)
	if(!user.is_holding(src))
		return ..()
	if(lit)
		set_lit(FALSE)
		if(fancy)
			user.visible_message(
				span_notice("只听安静的‘咔哒’一声, [user]关上了[src]，动作行云流水. Wow."),
				span_notice("你安静地关上了[src]，动作行云流水. Wow.")
			)
			playsound(src, 'modular_skyrat/master_files/sound/items/zippo_close.ogg', 50, TRUE) // SKYRAT EDIT ADDITION
		else
			user.visible_message(
				span_notice("[user]安静地关上了[src]."),
				span_notice("你安静地关上了[src].")
			)
		return

	set_lit(TRUE)
	if(fancy)
		user.visible_message(
			span_notice("不需要打断步伐, 只需一个动作，[user] 丝滑地打开并点燃了[src]."),
			span_notice("不需要打断步伐, 只需一个动作，你丝滑地打开并点燃了[src].")
		)
		playsound(src, 'modular_skyrat/master_files/sound/items/zippo_open.ogg', 50, TRUE) // SKYRAT EDIT ADDITION
		return

	var/hand_protected = FALSE
	var/mob/living/carbon/human/human_user = user
	if(!istype(human_user) || HAS_TRAIT(human_user, TRAIT_RESISTHEAT) || HAS_TRAIT(human_user, TRAIT_RESISTHEATHANDS))
		hand_protected = TRUE
	else if(!istype(human_user.gloves, /obj/item/clothing/gloves))
		hand_protected = FALSE
	else
		var/obj/item/clothing/gloves/gloves = human_user.gloves
		if(gloves.max_heat_protection_temperature)
			hand_protected = (gloves.max_heat_protection_temperature > 360)

	if(hand_protected || prob(75))
		user.visible_message(
			span_notice("经过几次尝试, [user]成功点燃了[src]."),
			span_notice("经过几次尝试，你成功点燃了[src].")
		)
		return

	var/hitzone = user.held_index_to_dir(user.active_hand_index) == "r" ? BODY_ZONE_PRECISE_R_HAND : BODY_ZONE_PRECISE_L_HAND
	user.apply_damage(5, BURN, hitzone)
	user.visible_message(
		span_warning("经过几次尝试并烧伤了手指后, [user]成功点燃了[src]."),
		span_warning("经过几次尝试并烧伤了手指后, 你成功点燃了[src].")
	)
	user.add_mood_event("burnt_thumb", /datum/mood_event/burnt_thumb)


/obj/item/lighter/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(lit && M.ignite_mob())
		message_admins("[ADMIN_LOOKUPFLW(user)] set [key_name_admin(M)] on fire with [src] at [AREACOORD(user)]")
		log_game("[key_name(user)] set [key_name(M)] on fire with [src] at [AREACOORD(user)]")
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)
	if(!lit || !cig || user.combat_mode)
		..()
		return

	if(cig.lit)
		to_chat(user, span_warning("[cig.name]已经点燃了!"))
	if(M == user)
		cig.attackby(src, user)
		return

	if(fancy)
		cig.light(span_rose("[user] whips the [name] out and holds it for [M]. [user.p_Their()] arm is as steady as the unflickering flame [user.p_they()] light[user.p_s()] \the [cig] with."))
	else
		cig.light(span_notice("[user] holds the [name] out for [M], and lights [M.p_their()] [cig.name]."))


/obj/item/lighter/process()
	open_flame(heat)

/obj/item/lighter/get_temperature()
	return lit * heat


/obj/item/lighter/greyscale
	name = "廉价打火机"
	desc = "便宜打火机罢了."
	icon_state = "lighter"
	fancy = FALSE
	overlay_list = list(
		"透明",
		"长条",
		"哑光",
		"祖宝" //u cant stoppo th zoppo
		)

	/// The color of the lighter.
	var/lighter_color
	/// The set of colors this lighter can be autoset as on init.
	var/list/color_list = list( //Same 16 color selection as electronic assemblies
		COLOR_ASSEMBLY_BLACK,
		COLOR_FLOORTILE_GRAY,
		COLOR_ASSEMBLY_BGRAY,
		COLOR_ASSEMBLY_WHITE,
		COLOR_ASSEMBLY_RED,
		COLOR_ASSEMBLY_ORANGE,
		COLOR_ASSEMBLY_BEIGE,
		COLOR_ASSEMBLY_BROWN,
		COLOR_ASSEMBLY_GOLD,
		COLOR_ASSEMBLY_YELLOW,
		COLOR_ASSEMBLY_GURKHA,
		COLOR_ASSEMBLY_LGREEN,
		COLOR_ASSEMBLY_GREEN,
		COLOR_ASSEMBLY_LBLUE,
		COLOR_ASSEMBLY_BLUE,
		COLOR_ASSEMBLY_PURPLE
		)

/obj/item/lighter/greyscale/Initialize(mapload)
	. = ..()
	if(!lighter_color)
		lighter_color = pick(color_list)
	update_appearance()

/obj/item/lighter/greyscale/create_lighter_overlay()
	var/mutable_appearance/lighter_overlay = ..()
	lighter_overlay.color = lighter_color
	return lighter_overlay

/obj/item/lighter/greyscale/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		. = span_notice("一番摆弄后, [user]成功用[src]点燃了[A].")


/obj/item/lighter/slime
	name = "史莱姆zippo"
	desc = "史莱姆和工业科技制成的打火机, 其火焰温度比一般的热得多."
	icon_state = "slighter"
	heat = 3000 //Blue flame!
	light_color = LIGHT_COLOR_CYAN
	overlay_state = "slime"
	grind_results = list(/datum/reagent/iron = 1, /datum/reagent/fuel = 5, /datum/reagent/medicine/pyroxadone = 5)

/obj/item/lighter/skull
	name = "骷髅zippo"
	desc = "一个绝对够酷的zippo打火机, 看看这个头骨造型"
	overlay_state = "skull"

/obj/item/lighter/mime
	name = "苍白zippo"
	desc = "无需燃料，只需纯粹的表演精神即可点燃香烟."
	icon_state = "mlighter" //These ones don't show a flame.
	light_color = LIGHT_COLOR_HALOGEN
	heat = 0 //I swear it's a real lighter dude you just can't see the flame dude I promise
	overlay_state = "mime"
	grind_results = list(/datum/reagent/iron = 1, /datum/reagent/toxin/mutetoxin = 5, /datum/reagent/consumable/nothing = 10)
	light_range = 0
	light_power = 0
	fancy = FALSE

/obj/item/lighter/mime/ignition_effect(atom/A, mob/user)
	. = span_infoplain("[user]将[name]举到[A]前, 奇迹般地燃了起来!")

/obj/item/lighter/bright
	name = "炫光zippo"
	desc = "当你点燃它时, 它会产生刺眼得难以置信的化学反应, 点燃时请勿直视."
	icon_state = "slighter"
	light_color = LIGHT_COLOR_ELECTRIC_CYAN
	overlay_state = "bright"
	grind_results = list(/datum/reagent/iron = 1, /datum/reagent/flash_powder = 10)
	light_range = 8
	light_power = 3 //Irritatingly bright and large enough to cover a small room.
	fancy = FALSE

/obj/item/lighter/bright/examine(mob/user)
	. = ..()

	if(lit && isliving(user))
		var/mob/living/current_viewer = user
		current_viewer.flash_act(4)

/obj/item/lighter/bright/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		. = span_infoplain(span_rose("[user]将[src]举到[A]前, 一道耀眼的光点燃了它!"))
		var/mob/living/current_viewer = user
		current_viewer.flash_act(4)

/obj/effect/spawner/random/special_lighter
	name = "特别的打火机生成点"
	icon_state = "lighter"
	loot = list(
		/obj/item/lighter/skull,
		/obj/item/lighter/mime,
		/obj/item/lighter/bright,
	)

///////////
//ROLLING//
///////////
/obj/item/rollingpaper
	name = "卷烟纸"
	desc = "用来制作精选香烟的薄纸."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper"
	w_class = WEIGHT_CLASS_TINY

/obj/item/rollingpaper/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, /obj/item/clothing/mask/cigarette/rollie, CUSTOM_INGREDIENT_ICON_NOCHANGE, ingredient_type=CUSTOM_INGREDIENT_TYPE_DRYABLE, max_ingredients=2)


///////////////
//VAPE NATION//
///////////////
/obj/item/clothing/mask/vape
	name = "电子烟" // improper
	desc = "一款优雅有格调的电子烟，为端庄优雅的绅士设计，上面的标签写着 \"警告: 请勿填充可燃物.\".“适合纯真的人”"//<<< i'd vape to that.
	icon = 'icons/obj/clothing/masks.dmi'
	worn_icon_muzzled = 'modular_skyrat/master_files/icons/mob/clothing/mask.dmi' //SKYRAT EDIT: ADDITION
	icon_state = "vape"
	worn_icon_state = "vape_worn"
	greyscale_config = /datum/greyscale_config/vape
	greyscale_config_worn = /datum/greyscale_config/vape/worn
	greyscale_config_worn_muzzled = /datum/greyscale_config/vape/worn/muzzled //SKYRAT EDIT ADDITION
	greyscale_colors = "#2e2e2e"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_TINY
	flags_1 = IS_PLAYER_COLORABLE_1

	/// The capacity of the vape.
	var/chem_volume = 100
	/// The amount of time between drags.
	var/dragtime = 8 SECONDS
	/// A cooldown to prevent huffing the vape all at once.
	COOLDOWN_DECLARE(drag_cooldown)
	/// Whether the resevoir is open and we can add reagents.
	var/screw = FALSE
	/// Whether the vape has been overloaded to spread smoke.
	var/super = FALSE

/obj/item/clothing/mask/vape/Initialize(mapload)
	. = ..()
	create_reagents(chem_volume, NO_REACT)
	reagents.add_reagent(/datum/reagent/drug/nicotine, 50)

/obj/item/clothing/mask/vape/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]沉迷上了电子烟, [user]只给自己想尝尝所有的口味."))//it doesn't give you cancer, it is cancer
	return (TOXLOSS|OXYLOSS)

/obj/item/clothing/mask/vape/screwdriver_act(mob/living/user, obj/item/tool)
	if(!screw)
		screw = TRUE
		to_chat(user, span_notice("你打开[src]的盖子."))
		reagents.flags |= OPENCONTAINER
		if(obj_flags & EMAGGED)
			icon_state = "vape_open_high"
			set_greyscale(new_config = /datum/greyscale_config/vape/open_high)
		else if(super)
			icon_state = "vape_open_med"
			set_greyscale(new_config = /datum/greyscale_config/vape/open_med)
		else
			icon_state = "vape_open_low"
			set_greyscale(new_config = /datum/greyscale_config/vape/open_low)
	else
		screw = FALSE
		to_chat(user, span_notice("你关上[src]的盖子."))
		reagents.flags &= ~(OPENCONTAINER)
		icon_state = initial(icon_state)
		set_greyscale(new_config = initial(greyscale_config))

/obj/item/clothing/mask/vape/multitool_act(mob/living/user, obj/item/tool)
	. = TRUE
	if(screw && !(obj_flags & EMAGGED))//also kinky
		if(!super)
			super = TRUE
			to_chat(user, span_notice("你调大了[src]的电压."))
			icon_state = "vape_open_med"
			set_greyscale(new_config = /datum/greyscale_config/vape/open_med)
		else
			super = FALSE
			to_chat(user, span_notice("你调小了[src]的电压."))
			icon_state = "vape_open_low"
			set_greyscale(new_config = /datum/greyscale_config/vape/open_low)

	if(screw && (obj_flags & EMAGGED))
		to_chat(user, span_warning("[src]无法改装!"))

/obj/item/clothing/mask/vape/emag_act(mob/user, obj/item/card/emag/emag_card) // I WON'T REGRET WRITTING THIS, SURLY.

	if (!screw)
		balloon_alert(user, "先打开盖子!")
		return FALSE

	if (obj_flags & EMAGGED)
		balloon_alert(user, "已经被emag了!")
		return FALSE

	obj_flags |= EMAGGED
	super = FALSE
	balloon_alert(user, "电压拉满")
	icon_state = "vape_open_high"
	set_greyscale(new_config = /datum/greyscale_config/vape/open_high)
	var/datum/effect_system/spark_spread/sp = new /datum/effect_system/spark_spread //for effect
	sp.set_up(5, 1, src)
	sp.start()
	return TRUE

/obj/item/clothing/mask/vape/attack_self(mob/user)
	if(reagents.total_volume > 0)
		to_chat(user, span_notice("你清空了[src]中所有的填料."))
		reagents.clear_reagents()

/obj/item/clothing/mask/vape/equipped(mob/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_MASK))
		return

	if(screw)
		to_chat(user, span_warning("你得先把盖子盖上!"))
		return

	to_chat(user, span_notice("你开始吞云吐雾."))
	reagents.flags &= ~(NO_REACT)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/vape/dropped(mob/user)
	. = ..()
	if(user.get_item_by_slot(ITEM_SLOT_MASK) == src)
		reagents.flags |= NO_REACT
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/mask/vape/proc/handle_reagents()
	if(!reagents.total_volume)
		return

	var/mob/living/carbon/vaper = loc
	if(!iscarbon(vaper) || src != vaper.wear_mask)
		reagents.remove_any(REAGENTS_METABOLISM)
		return

	if(reagents.get_reagent_amount(/datum/reagent/fuel))
		//HOT STUFF
		vaper.adjust_fire_stacks(2)
		vaper.ignite_mob()

	if(reagents.get_reagent_amount(/datum/reagent/toxin/plasma)) // the plasma explodes when exposed to fire
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/plasma) / 2.5, 1), get_turf(src), 0, 0)
		e.start(src)
		qdel(src)

	if(!reagents.trans_to(vaper, REAGENTS_METABOLISM, methods = INGEST, ignore_stomach = TRUE))
		reagents.remove_any(REAGENTS_METABOLISM)

/obj/item/clothing/mask/vape/process(seconds_per_tick)
	var/mob/living/M = loc

	if(isliving(loc))
		M.ignite_mob()

	if(!reagents.total_volume)
		if(ismob(loc))
			to_chat(M, span_warning("[src]是空的!"))
			STOP_PROCESSING(SSobj, src)
			//it's reusable so it won't unequip when empty
		return

	if(!COOLDOWN_FINISHED(src, drag_cooldown))
		return

	//Time to start puffing those fat vapes, yo.
	COOLDOWN_START(src, drag_cooldown, dragtime)

	//SKYRAT EDIT ADDITION
	//open flame removed because vapes are a closed system, they won't light anything on fire
	var/turf/my_turf = get_turf(src)
	my_turf.pollute_turf(/datum/pollutant/smoke/vape, 5, POLLUTION_PASSIVE_EMITTER_CAP)
	//SKYRAT EDIT END

	if(obj_flags & EMAGGED)
		var/datum/effect_system/fluid_spread/smoke/chem/smoke_machine/puff = new
		puff.set_up(4, holder = src, location = loc, carry = reagents, efficiency = 24)
		puff.start()
		if(prob(5)) //small chance for the vape to break and deal damage if it's emagged
			playsound(get_turf(src), 'sound/effects/pop_expl.ogg', 50, FALSE)
			M.apply_damage(20, BURN, BODY_ZONE_HEAD)
			M.Paralyze(300)
			var/datum/effect_system/spark_spread/sp = new /datum/effect_system/spark_spread
			sp.set_up(5, 1, src)
			sp.start()
			to_chat(M, span_userdanger("[src]突然在你的嘴中爆炸!"))
			qdel(src)
			return
	else if(super)
		var/datum/effect_system/fluid_spread/smoke/chem/smoke_machine/puff = new
		puff.set_up(1, holder = src, location = loc, carry = reagents, efficiency = 24)
		puff.start()

	handle_reagents()

/obj/item/clothing/mask/vape/red
	greyscale_colors = "#A02525"
	flags_1 = NONE

/obj/item/clothing/mask/vape/blue
	greyscale_colors = "#294A98"
	flags_1 = NONE

/obj/item/clothing/mask/vape/purple
	greyscale_colors = "#9900CC"
	flags_1 = NONE

/obj/item/clothing/mask/vape/green
	greyscale_colors = "#3D9829"
	flags_1 = NONE

/obj/item/clothing/mask/vape/yellow
	greyscale_colors = "#DAC20E"
	flags_1 = NONE

/obj/item/clothing/mask/vape/orange
	greyscale_colors = "#da930e"
	flags_1 = NONE

/obj/item/clothing/mask/vape/black
	greyscale_colors = "#2e2e2e"
	flags_1 = NONE

/obj/item/clothing/mask/vape/white
	greyscale_colors = "#DCDCDC"
	flags_1 = NONE
