/obj/machinery/gibber//SKYRAT EDIT - ICON OVERRIDDEN BY AESTHETICS - SEE MODULE
	name = "歌唱机"
	desc = "这个名字还不够描述的?"
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "grinder"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/gibber
	anchored_tabletop_offset = 8

	var/operating = FALSE //Is it on?
	var/dirty = FALSE // Does it need cleaning?
	var/gibtime = 40 // Time from starting until meat appears
	var/meat_produced = 2
	var/ignore_clothing = FALSE


/obj/machinery/gibber/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_cleaned))
	if(prob(5))
		name = "歌唱机"
		desc = "好吧，如果我...如果我把你放在绞肉机里剁碎，只剩下你的眼球!你可能会——不是你，我只是说，如果你——如果有人把你推到绞肉机里，而你的一根指骨还完好无损，他们不会把它捡起来然后说，嗯，看，这不是致命的，这不是一个立即致命的举动!"
		dirty = TRUE
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/gibber/RefreshParts()
	. = ..()
	gibtime = 40
	meat_produced = initial(meat_produced)
	for(var/datum/stock_part/matter_bin/matter_bin in component_parts)
		meat_produced += matter_bin.tier
	for(var/datum/stock_part/servo/servo in component_parts)
		gibtime -= 5 * servo.tier
		if(servo.tier >= 2)
			ignore_clothing = TRUE

/obj/machinery/gibber/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("状态显示: 将输出<b>[meat_produced]</b>块肉(s)在经过<b>[gibtime*0.1]</b>秒加工后.")
		for(var/datum/stock_part/servo/servo in component_parts)
			if(servo.tier >= 2)
				. += span_notice("[src]已经升级到可以处理无机材料了.")

/obj/machinery/gibber/update_overlays()
	. = ..()
	if(dirty)
		. += "grinder_bloody"
	if(machine_stat & (NOPOWER|BROKEN) || panel_open)
		return
	if(!occupant)
		. += "grinder_empty"
		. += emissive_appearance(icon, "grinder_empty", src, alpha = src.alpha)
		return
	if(operating)
		. += "grinder_active"
		. += emissive_appearance(icon, "grinder_active", src, alpha = src.alpha)
		. += "grinder_jaws_active"
		return
	. += "grinder_loaded"
	. += emissive_appearance(icon, "grinder_loaded", src, alpha = src.alpha)

/obj/machinery/gibber/on_set_panel_open(old_value)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/gibber/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/machinery/gibber/container_resist_act(mob/living/user)
	go_out()

/obj/machinery/gibber/relaymove(mob/living/user, direction)
	go_out()

/obj/machinery/gibber/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(operating)
		to_chat(user, span_danger("锁上了还在运行."))
		return

	if(!anchored)
		to_chat(user, span_warning("[src]不能使用，需要将其螺栓固定在地面上!"))
		return

	if(user.pulling && isliving(user.pulling))
		var/mob/living/L = user.pulling
		if(!iscarbon(L))
			to_chat(user, span_warning("该物品不适合[src]!"))
			return
		var/mob/living/carbon/C = L
		if(C.buckled || C.has_buckled_mobs())
			to_chat(user, span_warning("[C]是附属于某物的!"))
			return

		if(!ignore_clothing)
			for(var/obj/item/I in C.held_items + C.get_equipped_items())
				if(!HAS_TRAIT(I, TRAIT_NODROP))
					to_chat(user, span_warning("对象可能没有非生物物品!"))
					return

		user.visible_message(span_danger("[user]开始将[C]放入[src]!"))

		add_fingerprint(user)

		if(do_after(user, gibtime, target = src))
			if(C && user.pulling == C && !C.buckled && !C.has_buckled_mobs() && !occupant)
				user.visible_message(span_danger("[user]将[C]放入[src]!"))
				C.forceMove(src)
				set_occupant(C)
				update_appearance()
	else
		startgibbing(user)

/obj/machinery/gibber/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/gibber/attackby(obj/item/P, mob/user, params)
	if(default_deconstruction_screwdriver(user, "grinder_open", "grinder", P))
		return

	else if(default_pry_open(P, close_after_pry = TRUE))
		return

	else if(default_deconstruction_crowbar(P))
		return
	else
		return ..()

/obj/machinery/gibber/verb/eject()
	set category = "物件"
	set name = "空歌唱机"
	set src in oview(1)
	if (usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return
	if(!usr.can_perform_action(src))
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/gibber/proc/go_out()
	dump_inventory_contents()
	update_appearance()

/obj/machinery/gibber/proc/startgibbing(mob/user)
	if(operating)
		return
	if(!occupant)
		audible_message(span_hear("你听到一声巨大的金属摩擦声."))
		return
	if(occupant.flags_1 & HOLOGRAM_1)
		audible_message(span_hear("你听到一声短促的金属摩擦声"))
		playsound(loc, 'sound/machines/hiss.ogg', 20, TRUE)
		qdel(occupant)
		set_occupant(null)
		return

	use_energy(active_power_usage)
	audible_message(span_hear("你听到一声响亮的磨碎声."))
	playsound(loc, 'sound/machines/juicer.ogg', 50, TRUE)
	operating = TRUE
	update_appearance()

	Shake(pixelshiftx = 1, pixelshifty = 0, duration = gibtime)
	var/mob/living/mob_occupant = occupant
	var/sourcename = mob_occupant.real_name
	var/sourcejob
	if(ishuman(occupant))
		var/mob/living/carbon/human/gibee = occupant
		sourcejob = gibee.job
	var/sourcenutriment = mob_occupant.nutrition / 15
	var/gibtype = /obj/effect/decal/cleanable/blood/gibs
	var/typeofmeat = /obj/item/food/meat/slab/human
	var/typeofskin

	var/obj/item/food/meat/slab/allmeat[meat_produced]
	var/obj/item/stack/sheet/animalhide/skin
	var/list/datum/disease/diseases = mob_occupant.get_static_viruses()

	if(ishuman(occupant))
		var/mob/living/carbon/human/gibee = occupant
		if(prob(40) && (sourcejob in list(JOB_SECURITY_OFFICER,JOB_WARDEN,JOB_HEAD_OF_SECURITY)))
			typeofmeat = /obj/item/food/meat/slab/pig
		else if(gibee.dna && gibee.dna.species)
			typeofmeat = gibee.dna.species.meat
			typeofskin = gibee.dna.species.skinned_type

	else if(iscarbon(occupant))
		var/mob/living/carbon/C = occupant
		typeofmeat = C.type_of_meat
		gibtype = C.gib_type
		if(isalien(C))
			typeofskin = /obj/item/stack/sheet/animalhide/xeno

	var/occupant_volume
	if(occupant?.reagents)
		occupant_volume = occupant.reagents.total_volume
	for (var/i=1 to meat_produced)
		var/obj/item/food/meat/slab/newmeat = new typeofmeat
		newmeat.name = "[sourcename] [newmeat.name]"
		newmeat.set_custom_materials(list(GET_MATERIAL_REF(/datum/material/meat/mob_meat, occupant) = 4 * SHEET_MATERIAL_AMOUNT))
		if(istype(newmeat))
			newmeat.subjectname = sourcename
			newmeat.reagents.add_reagent (/datum/reagent/consumable/nutriment, sourcenutriment / meat_produced) // Thehehe. Fat guys go first
			if(occupant_volume)
				occupant.reagents.trans_to(newmeat, occupant_volume / meat_produced, remove_blacklisted = TRUE)
			if(sourcejob)
				newmeat.subjectjob = sourcejob

		allmeat[i] = newmeat

	if(typeofskin)
		skin = new typeofskin

	log_combat(user, occupant, "gibbed")
	mob_occupant.investigate_log("has been gibbed by [src].", INVESTIGATE_DEATHS)
	mob_occupant.death(TRUE)
	mob_occupant.ghostize()
	set_occupant(null)
	qdel(mob_occupant)
	addtimer(CALLBACK(src, PROC_REF(make_meat), skin, allmeat, meat_produced, gibtype, diseases), gibtime)

/obj/machinery/gibber/proc/make_meat(obj/item/stack/sheet/animalhide/skin, list/obj/item/food/meat/slab/allmeat, meat_produced, gibtype, list/datum/disease/diseases)
	playsound(src.loc, 'sound/effects/splat.ogg', 50, TRUE)
	operating = FALSE
	if (!dirty && prob(50))
		dirty = TRUE
	var/turf/T = get_turf(src)
	var/list/turf/nearby_turfs = RANGE_TURFS(3,T) - T
	if(skin)
		skin.forceMove(loc)
		skin.throw_at(pick(nearby_turfs),meat_produced,3)
	for (var/i=1 to meat_produced)
		var/obj/item/meatslab = allmeat[i]

		if(LAZYLEN(diseases))
			var/list/datum/disease/diseases_to_add = list()
			for(var/datum/disease/disease as anything in diseases)
				// admin or special viruses that should not be reproduced
				if(disease.spread_flags & (DISEASE_SPREAD_SPECIAL | DISEASE_SPREAD_NON_CONTAGIOUS))
					continue

				diseases_to_add += disease
			if(LAZYLEN(diseases_to_add))
				meatslab.AddComponent(/datum/component/infective, diseases_to_add)

		meatslab.forceMove(loc)
		meatslab.throw_at(pick(nearby_turfs),i,3)
		for (var/turfs=1 to meat_produced)
			var/turf/gibturf = pick(nearby_turfs)
			if (!gibturf.density && (src in view(gibturf)))
				new gibtype(gibturf, i, diseases)

	pixel_x = base_pixel_x //return to its spot after shaking
	operating = FALSE
	update_appearance()

//auto-gibs anything that bumps into it
/obj/machinery/gibber/autogibber
	var/input_dir = NORTH

/obj/machinery/gibber/autogibber/Bumped(atom/movable/AM)
	var/atom/input = get_step(src, input_dir)
	if(isliving(AM))
		var/mob/living/victim = AM

		if(victim.loc == input)
			victim.forceMove(src)
			victim.gib(DROP_ALL_REMAINS)

/obj/machinery/gibber/proc/on_cleaned(obj/source_component, obj/source)
	dirty = FALSE
	update_appearance(UPDATE_OVERLAYS)
