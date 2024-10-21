/obj/machinery/sleeper
	name = "冬眠仓"
	desc = "用于稳定伤情和进一步治疗的封闭睡眠舱."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	base_icon_state = "sleeper"
	density = FALSE
	obj_flags = BLOCKS_CONSTRUCTION
	state_open = TRUE
	interaction_flags_mouse_drop = NEED_DEXTERITY
	circuit = /obj/item/circuitboard/machine/sleeper

	payment_department = ACCOUNT_MED
	fair_market_price = 5

	///How much chems is allowed to be in a patient at once, before we force them to wait for the reagent to process.
	var/efficiency = 1
	///The minimum damage required to use any chem other than Epinephrine.
	var/min_health = -25
	///Whether the machine can be operated by the person inside of it.
	var/controls_inside = FALSE
	///Whether this sleeper can be deconstructed and drop the board, if its on mapload.
	var/deconstructable = FALSE
	///Message sent when a user enters the machine.
	var/enter_message = span_boldnotice("你感到周围有寒凉的空气，你感官内敛收缩，身体变得麻木.")

	///List of currently available chems.
	var/list/available_chems = list()
	///Used when emagged to scramble which chem is used, eg: mutadone -> morphine
	var/list/chem_buttons
	///All chems this sleeper will get, depending on the parts inside.
	var/list/possible_chems = list(
		list(
			/datum/reagent/medicine/epinephrine,
			/datum/reagent/medicine/morphine,
			/datum/reagent/medicine/c2/convermol,
			/datum/reagent/medicine/c2/libital,
			/datum/reagent/medicine/c2/aiuri,
		),
		list(
			/datum/reagent/medicine/oculine,
			/datum/reagent/medicine/inacusiate,
		),
		list(
			/datum/reagent/medicine/c2/multiver,
			/datum/reagent/medicine/mutadone,
			/datum/reagent/medicine/mannitol,
			/datum/reagent/medicine/salbutamol,
			/datum/reagent/medicine/pen_acid,
		),
		list(
			/datum/reagent/medicine/omnizine,
		),
	)

/obj/machinery/sleeper/Initialize(mapload)
	. = ..()
	if(mapload && !deconstructable)
		LAZYREMOVE(component_parts, circuit)
		QDEL_NULL(circuit)
	occupant_typecache = GLOB.typecache_living
	update_appearance()
	reset_chem_buttons()

/obj/machinery/sleeper/RefreshParts()
	. = ..()
	var/matterbin_rating
	for(var/datum/stock_part/matter_bin/matterbins in component_parts)
		matterbin_rating += matterbins.tier
	efficiency = initial(efficiency) * matterbin_rating
	min_health = initial(min_health) * matterbin_rating

	available_chems.Cut()
	for(var/datum/stock_part/servo/servos in component_parts)
		for(var/i in 1 to servos.tier)
			available_chems |= possible_chems[i]

	reset_chem_buttons()

/obj/machinery/sleeper/update_icon_state()
	icon_state = "[base_icon_state][state_open ? "-open" : null]"
	return ..()

/obj/machinery/sleeper/container_resist_act(mob/living/user)
	visible_message(span_notice("[occupant] emerges from [src]!"),
		span_notice("You climb out of [src]!"))
	open_machine()

/obj/machinery/sleeper/Exited(atom/movable/gone, direction)
	. = ..()
	if (!state_open && gone == occupant)
		container_resist_act(gone)

/obj/machinery/sleeper/relaymove(mob/living/user, direction)
	if (!state_open)
		container_resist_act(user)

/obj/machinery/sleeper/open_machine(drop = TRUE, density_to_set = FALSE)
	if(!state_open && !panel_open)
		flick("[initial(icon_state)]-anim", src)
	return ..()

/obj/machinery/sleeper/close_machine(mob/user, density_to_set = TRUE)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		flick("[initial(icon_state)]-anim", src)
		..()
		var/mob/living/mob_occupant = occupant
		if(mob_occupant && mob_occupant.stat != DEAD)
			to_chat(mob_occupant, "[enter_message]")

/obj/machinery/sleeper/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(is_operational && occupant)
		open_machine()

/obj/machinery/sleeper/mouse_drop_receive(atom/target, mob/user, params)
	if(!iscarbon(target))
		return
	close_machine(target)

/obj/machinery/sleeper/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(occupant)
		to_chat(user, span_warning("[src]当前已被占用!"))
		return TRUE
	if(state_open)
		to_chat(user, span_warning("[src]必须先关闭来[panel_open ? "盖上" : "打开"]它的检修舱盖!"))
		return TRUE
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-o", initial(icon_state), I))
		return TRUE
	return FALSE

/obj/machinery/sleeper/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_change_direction_wrench(user, I))
		return TRUE
	return FALSE

/obj/machinery/sleeper/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_pry_open(I))
		return TRUE
	if(default_deconstruction_crowbar(I))
		return TRUE
	return FALSE

/obj/machinery/sleeper/default_pry_open(obj/item/I) //wew
	. = !(state_open || panel_open) && I.tool_behaviour == TOOL_CROWBAR
	if(.)
		I.play_tool_sound(src, 50)
		visible_message(span_notice("[usr]撬开了[src]."), span_notice("你撬开了[src]."))
		open_machine()

/obj/machinery/sleeper/ui_state(mob/user)
	if(!controls_inside)
		return GLOB.notcontained_state
	return GLOB.default_state

/obj/machinery/sleeper/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sleeper", name)
		ui.open()

/obj/machinery/sleeper/click_alt(mob/user)
	if(state_open)
		close_machine()
	else
		open_machine()
	return CLICK_ACTION_SUCCESS

/obj/machinery/sleeper/examine(mob/user)
	. = ..()
	. += span_notice("Alt加左键[src]来[state_open ? "关闭" : "开启"]它.")

/obj/machinery/sleeper/process()
	use_energy(idle_power_usage)

/obj/machinery/sleeper/nap_violation(mob/violator)
	. = ..()
	open_machine()

/obj/machinery/sleeper/ui_data()
	var/list/data = list()
	data["occupied"] = !!occupant
	data["open"] = state_open

	data["chems"] = list()
	for(var/chem in available_chems)
		var/datum/reagent/R = GLOB.chemical_reagents_list[chem]
		data["chems"] += list(
			list(
				"name" = R.name,
				"id" = R.type,
				"allowed" = chem_allowed(chem),
			),
		)

	data["occupant"] = list()
	var/mob/living/mob_occupant = occupant
	if(mob_occupant)
		data["occupant"]["name"] = mob_occupant.name
		switch(mob_occupant.stat)
			if(CONSCIOUS)
				data["occupant"]["stat"] = "意识清醒"
				data["occupant"]["statstate"] = "良好"
			if(SOFT_CRIT)
				data["occupant"]["stat"] = "意识清醒"
				data["occupant"]["statstate"] = "一般"
			if(UNCONSCIOUS, HARD_CRIT)
				data["occupant"]["stat"] = "无意识"
				data["occupant"]["statstate"] = "一般"
			if(DEAD)
				data["occupant"]["stat"] = "死亡"
				data["occupant"]["statstate"] = "糟糕"
		data["occupant"]["health"] = mob_occupant.health
		data["occupant"]["maxHealth"] = mob_occupant.maxHealth
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_DEAD
		data["occupant"]["bruteLoss"] = mob_occupant.getBruteLoss()
		data["occupant"]["oxyLoss"] = mob_occupant.getOxyLoss()
		data["occupant"]["toxLoss"] = mob_occupant.getToxLoss()
		data["occupant"]["fireLoss"] = mob_occupant.getFireLoss()
		data["occupant"]["brainLoss"] = mob_occupant.get_organ_loss(ORGAN_SLOT_BRAIN)
		data["occupant"]["reagents"] = list()
		if(mob_occupant.reagents && mob_occupant.reagents.reagent_list.len)
			for(var/datum/reagent/R in mob_occupant.reagents.reagent_list)
				if(R.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems
					continue
				data["occupant"]["reagents"] += list(
					list(
						"name" = R.name,
						"volume" = R.volume,
					),
				)

	return data

/obj/machinery/sleeper/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/living/mob_occupant = occupant
	check_nap_violations()
	switch(action)
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine()
			. = TRUE
		if("inject")
			var/chem = text2path(params["chem"])
			if(!is_operational || !mob_occupant || isnull(chem))
				return
			if(mob_occupant.health < min_health && !ispath(chem, /datum/reagent/medicine/epinephrine))
				return
			if(inject_chem(chem, usr))
				. = TRUE
				if((obj_flags & EMAGGED) && prob(5))
					to_chat(usr, span_warning("检测到化学系统改线，结果可能与预期不符!"))

/obj/machinery/sleeper/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE

	balloon_alert(user, "接口干扰")
	obj_flags |= EMAGGED

	var/list/av_chem = available_chems.Copy()
	for(var/chem in av_chem)
		chem_buttons[chem] = pick_n_take(av_chem) //no dupes, allow for random buttons to still be correct
	return TRUE

/obj/machinery/sleeper/proc/inject_chem(chem, mob/user)
	if((chem in available_chems) && chem_allowed(chem))
		occupant.reagents.add_reagent(chem_buttons[chem], 10) //emag effect kicks in here so that the "intended" chem is used for all checks, for extra FUUU
		if(user)
			log_combat(user, occupant, "injected [chem] into", addition = "via [src]")
		return TRUE

/obj/machinery/sleeper/proc/chem_allowed(chem)
	var/mob/living/mob_occupant = occupant
	if(!mob_occupant || !mob_occupant.reagents)
		return
	var/amount = mob_occupant.reagents.get_reagent_amount(chem) + 10 <= 20 * efficiency
	var/occ_health = mob_occupant.health > min_health || chem == /datum/reagent/medicine/epinephrine
	return amount && occ_health

/obj/machinery/sleeper/proc/reset_chem_buttons()
	obj_flags &= ~EMAGGED
	LAZYINITLIST(chem_buttons)
	for(var/chem in available_chems)
		chem_buttons[chem] = chem

/**
 * Syndicate version
 * Can be controlled from the inside and can be deconstructed.
 */
/obj/machinery/sleeper/syndie
	icon_state = "sleeper_s"
	base_icon_state = "sleeper_s"
	controls_inside = TRUE
	deconstructable = TRUE

///Fully upgraded variant, the circuit using tier 4 parts.
/obj/machinery/sleeper/syndie/fullupgrade
	circuit = /obj/item/circuitboard/machine/sleeper/fullupgrade

///Fully upgraded, not deconstructable, while using the normal sprite.
/obj/machinery/sleeper/syndie/fullupgrade/nt
	icon_state = "sleeper"
	base_icon_state = "sleeper"
	deconstructable = FALSE

/obj/machinery/sleeper/self_control
	controls_inside = TRUE

/obj/machinery/sleeper/old
	icon_state = "oldpod"
	base_icon_state = "oldpod"

/obj/machinery/sleeper/party
	name = "派对仓"
	desc = "'冬眠仓'装置曾以其自动治疗特性而闻名，直到一项调查指出它们一直在给患者错误地服用致命的醋酸铅. 这台就是曾经的问题机器，现在被改造成了所谓的派对仓，使用它可能不是个好注意."
	icon_state = "partypod"
	base_icon_state = "partypod"
	circuit = /obj/item/circuitboard/machine/sleeper/party
	controls_inside = TRUE
	deconstructable = TRUE
	enter_message = span_boldnotice("在仓内你被时髦音乐包围住了，内心涌动出krunk氛围，心情也随之放松下来.")

	//Exclusively uses non-lethal, "fun" chems. At an obvious downside.
	possible_chems = list(
		list(
			/datum/reagent/consumable/ethanol/beer,
			/datum/reagent/consumable/laughter,
		),
		list(
			/datum/reagent/spraytan,
			/datum/reagent/barbers_aid,
		),
		list(
			/datum/reagent/colorful_reagent,
			/datum/reagent/hair_dye,
		),
		list(
			/datum/reagent/drug/space_drugs,
			/datum/reagent/baldium,
		),
	)
	///Chemicals that need to have a touch or vapor reaction to be applied, not the standard chamber reaction.
	var/spray_chems = list(
		/datum/reagent/spraytan,
		/datum/reagent/hair_dye,
		/datum/reagent/baldium,
		/datum/reagent/barbers_aid,
	)

/obj/machinery/sleeper/party/inject_chem(chem, mob/user)
	if(obj_flags & EMAGGED)
		occupant.reagents.add_reagent(/datum/reagent/toxin/leadacetate, 4)
	else if (prob(20)) //You're injecting chemicals into yourself from a recalled, decrepit medical machine. What did you expect?
		occupant.reagents.add_reagent(/datum/reagent/toxin/leadacetate, rand(1,3))
	if(chem in spray_chems)
		var/datum/reagents/holder = new()
		holder.add_reagent(chem_buttons[chem], 10) //I hope this is the correct way to do this.
		holder.trans_to(occupant, 10, methods = VAPOR)
		playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
		if(user)
			log_combat(user, occupant, "sprayed [chem] into", addition = "via [src]")
		return TRUE
	return ..()
