/// A fake nuke that actually contains beer.
/obj/machinery/nuclearbomb/beer
	name = "\improper 纳米传讯牌核裂变炸弹"
	desc = "纳米传讯战争部的一个相当成功的成就就是他们的核裂变炸弹，以其成本低廉和威力巨大而闻名. 标签显示，虽然该设备已经退役，但每个纳米传讯空间站都配备了另一台类似的装置以防万一. 所有舰长都小心翼翼地保管着引爆它所需的磁盘-至少标签上这样讲."
	proper_bomb = FALSE
	/// The keg located within the beer nuke.
	var/obj/structure/reagent_dispensers/beerkeg/keg
	/// Reagent that is produced once the nuke detonates.
	var/flood_reagent = /datum/reagent/consumable/ethanol/beer
	/// Round event control we might as well keep track of instead of locating every time
	var/datum/round_event_control/scrubber_overflow/every_vent/overflow_control

/obj/machinery/nuclearbomb/beer/Initialize(mapload)
	. = ..()
	keg = new(src)
	QDEL_NULL(core)
	overflow_control = locate(/datum/round_event_control/scrubber_overflow/every_vent) in SSevents.control

/obj/machinery/nuclearbomb/beer/Destroy()
	UnregisterSignal(overflow_control, COMSIG_CREATED_ROUND_EVENT)
	. = ..()

/obj/machinery/nuclearbomb/beer/examine(mob/user)
	. = ..()
	if(keg.reagents.total_volume)
		. += span_notice("它还有[keg.reagents.total_volume]单位剩余.")
	else
		. += span_danger("它是空的.")

/obj/machinery/nuclearbomb/beer/attackby(obj/item/weapon, mob/user, params)
	if(weapon.is_refillable())
		weapon.afterattack(keg, user, TRUE) // redirect refillable containers to the keg, allowing them to be filled
		return TRUE // pretend we handled the attack, too.

	if(istype(weapon, /obj/item/nuke_core_container))
		to_chat(user, span_notice("[src]因为退役已经拆除了钚芯."))
		return TRUE

	return ..()

/obj/machinery/nuclearbomb/beer/actually_explode()
	//Unblock roundend, we're not actually exploding.
	SSticker.roundend_check_paused = FALSE
	var/turf/bomb_location = get_turf(src)
	if(!bomb_location)
		disarm_nuke()
		return
	if(is_station_level(bomb_location.z))
		addtimer(CALLBACK(src, PROC_REF(really_actually_explode)), 11 SECONDS)
	else
		visible_message(span_notice("[src]发出不详地嘶嘶声."))
		addtimer(CALLBACK(src, PROC_REF(local_foam)), 11 SECONDS)

/obj/machinery/nuclearbomb/beer/disarm_nuke(mob/disarmer)
	exploding = FALSE
	exploded = TRUE
	return ..()

/obj/machinery/nuclearbomb/beer/proc/local_foam()
	var/datum/reagents/tmp_holder = new/datum/reagents(1000)
	tmp_holder.my_atom = src
	tmp_holder.add_reagent(flood_reagent, 100)

	var/datum/effect_system/fluid_spread/foam/foam = new
	foam.set_up(200, holder = src, location = get_turf(src), carry = tmp_holder)
	foam.start()
	disarm_nuke()

/obj/machinery/nuclearbomb/beer/really_actually_explode(detonation_status)
	//if it's always hooked in it'll override admin choices
	RegisterSignal(overflow_control, COMSIG_CREATED_ROUND_EVENT, PROC_REF(on_created_round_event))
	disarm_nuke()
	overflow_control.run_event(event_cause = "一枚啤酒核弹")

/// signal sent from overflow control when it fires an event
/obj/machinery/nuclearbomb/beer/proc/on_created_round_event(datum/round_event_control/source_event_control, datum/round_event/scrubber_overflow/every_vent/created_event)
	SIGNAL_HANDLER
	UnregisterSignal(overflow_control, COMSIG_CREATED_ROUND_EVENT)
	created_event.forced_reagent_type = flood_reagent
