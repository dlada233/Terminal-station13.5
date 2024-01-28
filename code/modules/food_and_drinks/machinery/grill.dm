//I JUST WANNA GRILL FOR GOD'S SAKE

#define GRILL_FUELUSAGE_IDLE 0.5
#define GRILL_FUELUSAGE_ACTIVE 5

/obj/machinery/grill//SKYRAT EDIT - ICON OVERRIDEN BY AESTHETICS - SEE MODULE
	name = "烧烤架"
	desc = "Just like the old days."
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "grill_open"
	density = TRUE
	pass_flags_self = PASSMACHINE | LETPASSTHROW
	layer = BELOW_OBJ_LAYER
	use_power = NO_POWER_USE
	var/grill_fuel = 0
	var/obj/item/food/grilled_item
	var/grill_time = 0
	var/datum/looping_sound/grill/grill_loop

/obj/machinery/grill/Initialize(mapload)
	. = ..()
	grill_loop = new(src, FALSE)

/obj/machinery/grill/Destroy()
	grilled_item = null
	QDEL_NULL(grill_loop)
	return ..()

/obj/machinery/grill/update_icon_state()
	if(grilled_item)
		icon_state = "grill"
		return ..()
	if(grill_fuel > 0)
		icon_state = "grill_on"
		return ..()
	icon_state = "grill_open"
	return ..()

/obj/machinery/grill/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/sheet/mineral/coal) || istype(I, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/S = I
		var/stackamount = S.get_amount()
		to_chat(user, span_notice("你把[stackamount] [I]放到[src]."))
		if(istype(I, /obj/item/stack/sheet/mineral/coal))
			grill_fuel += (500 * stackamount)
		else
			grill_fuel += (50 * stackamount)
		S.use(stackamount)
		update_appearance()
		return
	if(I.resistance_flags & INDESTRUCTIBLE)
		to_chat(user, span_warning("你不觉得烤[I]是明智的..."))
		return ..()
	if(istype(I, /obj/item/reagent_containers/cup/glass))
		if(I.reagents.has_reagent(/datum/reagent/consumable/monkey_energy))
			grill_fuel += (20 * (I.reagents.get_reagent_amount(/datum/reagent/consumable/monkey_energy)))
			to_chat(user, span_notice("你把猴之能量倒入[src]."))
			I.reagents.remove_reagent(/datum/reagent/consumable/monkey_energy, I.reagents.get_reagent_amount(/datum/reagent/consumable/monkey_energy))
			update_appearance()
			return
	else if(IS_EDIBLE(I))
		if(HAS_TRAIT(I, TRAIT_NODROP) || (I.item_flags & (ABSTRACT | DROPDEL)))
			return ..()
		else if(HAS_TRAIT(I, TRAIT_FOOD_GRILLED))
			to_chat(user, span_notice("[I]已经被烤过了!"))
			return
		else if(grill_fuel <= 0)
			to_chat(user, span_warning("没有足够的燃料了!"))
			return
		else if(!grilled_item && user.transferItemToLoc(I, src))
			grilled_item = I
			RegisterSignal(grilled_item, COMSIG_ITEM_GRILLED, PROC_REF(GrillCompleted))
			to_chat(user, span_notice("你把[grilled_item]放到[src]上."))
			update_appearance()
			grill_loop.start()
			return

	..()

/obj/machinery/grill/process(seconds_per_tick)
	..()
	update_appearance()
	if(grill_fuel <= 0)
		return
	else
		grill_fuel -= GRILL_FUELUSAGE_IDLE * seconds_per_tick
		if(SPT_PROB(0.5, seconds_per_tick))
			var/datum/effect_system/fluid_spread/smoke/bad/smoke = new
			smoke.set_up(1, holder = src, location = loc)
			smoke.start()
	if(grilled_item)
		SEND_SIGNAL(grilled_item, COMSIG_ITEM_GRILL_PROCESS, src, seconds_per_tick)
		grill_time += seconds_per_tick
		grilled_item.reagents.add_reagent(/datum/reagent/consumable/char, 0.5 * seconds_per_tick)
		grill_fuel -= GRILL_FUELUSAGE_ACTIVE * seconds_per_tick
		grilled_item.AddComponent(/datum/component/sizzle)

/obj/machinery/grill/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == grilled_item)
		finish_grill()
		grilled_item = null

/obj/machinery/grill/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_unfasten_wrench(user, I) != CANT_UNFASTEN)
		return TRUE

/obj/machinery/grill/deconstruct(disassembled = TRUE)
	if(grilled_item)
		finish_grill()
	if(!(obj_flags & NO_DECONSTRUCTION))
		new /obj/item/stack/sheet/iron(loc, 5)
		new /obj/item/stack/rods(loc, 5)
	..()

/obj/machinery/grill/attack_ai(mob/user)
	return

/obj/machinery/grill/attack_hand(mob/user, list/modifiers)
	if(grilled_item)
		to_chat(user, span_notice("你拿开[grilled_item]从[src]."))
		grilled_item.forceMove(drop_location())
		update_appearance()
		return
	return ..()

/obj/machinery/grill/proc/finish_grill()
	if(!QDELETED(grilled_item))
		if(grill_time >= 20)
			grilled_item.AddElement(/datum/element/grilled_item, grill_time)
		UnregisterSignal(grilled_item, COMSIG_ITEM_GRILLED)
	grill_time = 0
	grill_loop.stop()

///Called when a food is transformed by the grillable component
/obj/machinery/grill/proc/GrillCompleted(obj/item/source, atom/grilled_result)
	SIGNAL_HANDLER
	grilled_item = grilled_result //use the new item!!

/obj/machinery/grill/unwrenched
	anchored = FALSE

#undef GRILL_FUELUSAGE_IDLE
#undef GRILL_FUELUSAGE_ACTIVE
