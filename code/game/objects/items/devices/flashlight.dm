#define FAILURE 0
#define SUCCESS 1
#define NO_FUEL 2
#define ALREADY_LIT 3

/obj/item/flashlight
	name = "手提电筒"
	desc = "手持式应急灯."
	custom_price = PAYCHECK_CREW
	icon = 'icons/obj/lighting.dmi'
	dir = WEST
	icon_state = "flashlight"
	inhand_icon_state = "flashlight"
	worn_icon_state = "flashlight"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/glass= SMALL_MATERIAL_AMOUNT * 0.2)
	actions_types = list(/datum/action/item_action/toggle_light)
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_range = 4
	light_power = 1
	light_on = FALSE
	/// If we've been forcibly disabled for a temporary amount of time.
	COOLDOWN_DECLARE(disabled_time)
	/// Can we toggle this light on and off (used for contexual screentips only)
	var/toggle_context = TRUE
	/// The sound the light makes when it's turned on
	var/sound_on = 'sound/weapons/magin.ogg'
	/// The sound the light makes when it's turned off
	var/sound_off = 'sound/weapons/magout.ogg'
	/// Should the flashlight start turned on?
	var/start_on = FALSE

/obj/item/flashlight/Initialize(mapload)
	. = ..()
	if(start_on)
		set_light_on(TRUE)
	update_brightness()
	register_context()

	if(toggle_context)
		RegisterSignal(src, COMSIG_HIT_BY_SABOTEUR, PROC_REF(on_saboteur))

	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/flashlight_eyes)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/flashlight/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	// single use lights can be toggled on once
	if(isnull(held_item) && (toggle_context || !light_on))
		context[SCREENTIP_CONTEXT_RMB] = "Toggle light"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/flashlight) && (toggle_context || !light_on))
		context[SCREENTIP_CONTEXT_LMB] = "Toggle light"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/flashlight/update_icon_state()
	. = ..()
	if(light_on)
		icon_state = "[initial(icon_state)]-on"
		if(!isnull(inhand_icon_state))
			inhand_icon_state = "[initial(inhand_icon_state)]-on"
	else
		icon_state = initial(icon_state)
		if(!isnull(inhand_icon_state))
			inhand_icon_state = initial(inhand_icon_state)

/obj/item/flashlight/proc/update_brightness()
	update_appearance(UPDATE_ICON)
	if(light_system == STATIC_LIGHT)
		update_light()

/obj/item/flashlight/proc/toggle_light(mob/user)
	playsound(src, light_on ? sound_off : sound_on, 40, TRUE)
	if(!COOLDOWN_FINISHED(src, disabled_time))
		if(user)
			balloon_alert(user, "disrupted!")
		set_light_on(FALSE)
		update_brightness()
		update_item_action_buttons()
		return FALSE
	var/old_light_on = light_on
	set_light_on(!light_on)
	update_brightness()
	update_item_action_buttons()
	return light_on != old_light_on // If the value of light_on didn't change, return false. Otherwise true.

/obj/item/flashlight/attack_self(mob/user)
	toggle_light(user)

/obj/item/flashlight/attack_hand_secondary(mob/user, list/modifiers)
	attack_self(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/flashlight/suicide_act(mob/living/carbon/human/user)
	if (user.is_blind())
		user.visible_message(span_suicide("[user] is putting [src] close to [user.p_their()] eyes and turning it on... but [user.p_theyre()] blind!"))
		return SHAME
	user.visible_message(span_suicide("[user] is putting [src] close to [user.p_their()] eyes and turning it on! It looks like [user.p_theyre()] trying to commit suicide!"))
	return FIRELOSS

/obj/item/flashlight/attack(mob/living/carbon/M, mob/living/carbon/human/user)
	add_fingerprint(user)
	if(istype(M) && light_on && (user.zone_selected in list(BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH)))

		if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50)) //too dumb to use flashlight properly
			return ..() //just hit them in the head

		if(!ISADVANCEDTOOLUSER(user))
			to_chat(user, span_warning("You don't have the dexterity to do this!"))
			return

		if(!M.get_bodypart(BODY_ZONE_HEAD))
			to_chat(user, span_warning("[M] doesn't have a head!"))
			return

		if(light_power < 1)
			to_chat(user, "[span_warning("\The [src] isn't bright enough to see anything!")] ")
			return

		var/render_list = list()//information will be packaged in a list for clean display to the user

		switch(user.zone_selected)
			if(BODY_ZONE_PRECISE_EYES)
				if((M.head && M.head.flags_cover & HEADCOVERSEYES) || (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSEYES) || (M.glasses && M.glasses.flags_cover & GLASSESCOVERSEYES))
					to_chat(user, span_warning("You're going to need to remove that [(M.head && M.head.flags_cover & HEADCOVERSEYES) ? "helmet" : (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSEYES) ? "mask": "glasses"] first!"))
					return

				var/obj/item/organ/internal/eyes/E = M.get_organ_slot(ORGAN_SLOT_EYES)
				var/obj/item/organ/internal/brain = M.get_organ_slot(ORGAN_SLOT_BRAIN)
				if(!E)
					to_chat(user, span_warning("[M] doesn't have any eyes!"))
					return

				M.flash_act(visual = TRUE, length = (user.combat_mode) ? 2.5 SECONDS : 1 SECONDS) // Apply a 1 second flash effect to the target. The duration increases to 2.5 Seconds if you have combat mode on.

				if(M == user) //they're using it on themselves
					user.visible_message(span_warning("[user] shines [src] into [M.p_their()] eyes."), ignored_mobs = user)
					render_list += span_info("You direct [src] to into your eyes:\n")

					if(M.is_blind())
						render_list += "<span class='notice ml-1'>You're not entirely certain what you were expecting...</span>\n"
					else
						render_list += "<span class='notice ml-1'>Trippy!</span>\n"

				else
					user.visible_message(span_warning("[user] directs [src] to [M]'s eyes."), ignored_mobs = user)
					render_list += span_info("You direct [src] to [M]'s eyes:\n")

					if(M.stat == DEAD || M.is_blind() || M.get_eye_protection() > FLASH_PROTECTION_WELDER)
						render_list += "<span class='danger ml-1'>[M.p_Their()] pupils don't react to the light!</span>\n"//mob is dead
					else if(brain.damage > 20)
						render_list += "<span class='danger ml-1'>[M.p_Their()] pupils contract unevenly!</span>\n"//mob has sustained damage to their brain
					else
						render_list += "<span class='notice ml-1'>[M.p_Their()] pupils narrow.</span>\n"//they're okay :D

					if(M.dna && M.dna.check_mutation(/datum/mutation/human/xray))
						render_list += "<span class='danger ml-1'>[M.p_Their()] pupils give an eerie glow!</span>\n"//mob has X-ray vision

				//display our packaged information in an examine block for easy reading
				to_chat(user, examine_block(jointext(render_list, "")), type = MESSAGE_TYPE_INFO)

			if(BODY_ZONE_PRECISE_MOUTH)

				if(M.is_mouth_covered())
					to_chat(user, span_warning("You're going to need to remove that [(M.head && M.head.flags_cover & HEADCOVERSMOUTH) ? "helmet" : "mask"] first!"))
					return

				var/list/mouth_organs = new
				for(var/obj/item/organ/organ as anything in M.organs)
					if(organ.zone == BODY_ZONE_PRECISE_MOUTH)
						mouth_organs.Add(organ)
				var/organ_list = ""
				var/organ_count = LAZYLEN(mouth_organs)
				if(organ_count)
					for(var/I in 1 to organ_count)
						if(I > 1)
							if(I == mouth_organs.len)
								organ_list += ", and "
							else
								organ_list += ", "
						var/obj/item/organ/O = mouth_organs[I]
						organ_list += (O.gender == "plural" ? O.name : "\an [O.name]")

				var/pill_count = 0
				for(var/datum/action/item_action/hands_free/activate_pill/AP in M.actions)
					pill_count++

				if(M == user)//if we're looking on our own mouth
					var/can_use_mirror = FALSE
					if(isturf(user.loc))
						var/obj/structure/mirror/mirror = locate(/obj/structure/mirror, user.loc)
						if(mirror)
							switch(user.dir)
								if(NORTH)
									can_use_mirror = mirror.pixel_y > 0
								if(SOUTH)
									can_use_mirror = mirror.pixel_y < 0
								if(EAST)
									can_use_mirror = mirror.pixel_x > 0
								if(WEST)
									can_use_mirror = mirror.pixel_x < 0

					M.visible_message(span_notice("[M] directs [src] to [ M.p_their()] mouth."), ignored_mobs = user)
					render_list += span_info("You point [src] into your mouth:\n")
					if(!can_use_mirror)
						to_chat(user, span_notice("You can't see anything without a mirror."))
						return
					if(organ_count)
						render_list += "<span class='notice ml-1'>Inside your mouth [organ_count > 1 ? "are" : "is"] [organ_list].</span>\n"
					else
						render_list += "<span class='notice ml-1'>There's nothing inside your mouth.</span>\n"
					if(pill_count)
						render_list += "<span class='notice ml-1'>You have [pill_count] implanted pill[pill_count > 1 ? "s" : ""].</span>\n"

				else //if we're looking in someone elses mouth
					user.visible_message(span_notice("[user] directs [src] to [M]'s mouth."), ignored_mobs = user)
					render_list += span_info("You point [src] into [M]'s mouth:\n")
					if(organ_count)
						render_list += "<span class='notice ml-1'>Inside [ M.p_their()] mouth [organ_count > 1 ? "are" : "is"] [organ_list].</span>\n"
					else
						render_list += "<span class='notice ml-1'>[M] doesn't have any organs in [ M.p_their()] mouth.</span>\n"
					if(pill_count)
						render_list += "<span class='notice ml-1'>[M] has [pill_count] pill[pill_count > 1 ? "s" : ""] implanted in [ M.p_their()] teeth.</span>\n"

				//assess any suffocation damage
				var/hypoxia_status = M.getOxyLoss() > 20

				if(M == user)
					if(hypoxia_status)
						render_list += "<span class='danger ml-1'>Your lips appear blue!</span>\n"//you have suffocation damage
					else
						render_list += "<span class='notice ml-1'>Your lips appear healthy.</span>\n"//you're okay!
				else
					if(hypoxia_status)
						render_list += "<span class='danger ml-1'>[M.p_Their()] lips appear blue!</span>\n"//they have suffocation damage
					else
						render_list += "<span class='notice ml-1'>[M.p_Their()] lips appear healthy.</span>\n"//they're okay!

				//assess blood level
				if(M == user)
					render_list += span_info("You press a finger to your gums:\n")
				else
					render_list += span_info("You press a finger to [M.p_their()] gums:\n")

				if(M.blood_volume <= BLOOD_VOLUME_SAFE && M.blood_volume > BLOOD_VOLUME_OKAY)
					render_list += "<span class='danger ml-1'>Color returns slowly!</span>\n"//low blood
				else if(M.blood_volume <= BLOOD_VOLUME_OKAY)
					render_list += "<span class='danger ml-1'>Color does not return!</span>\n"//critical blood
				else
					render_list += "<span class='notice ml-1'>Color returns quickly.</span>\n"//they're okay :D

				//display our packaged information in an examine block for easy reading
				to_chat(user, examine_block(jointext(render_list, "")), type = MESSAGE_TYPE_INFO)

	else
		return ..()

/// for directional sprites - so we get the same sprite in the inventory each time we pick one up
/obj/item/flashlight/equipped(mob/user, slot, initial)
	. = ..()
	setDir(initial(dir))
	SEND_SIGNAL(user, COMSIG_ATOM_DIR_CHANGE, user.dir, user.dir) // This is dumb, but if we don't do this then the lighting overlay may be facing the wrong direction depending on how it is picked up

/// for directional sprites - so when we drop the flashlight, it drops facing the same way the user is facing
/obj/item/flashlight/dropped(mob/user, silent = FALSE)
	. = ..()
	if(istype(user) && dir != user.dir)
		setDir(user.dir)

/// when hit by a light disruptor - turns the light off, forces the light to be disabled for a few seconds
/obj/item/flashlight/proc/on_saboteur(datum/source, disrupt_duration)
	SIGNAL_HANDLER
	if(light_on)
		toggle_light()
	COOLDOWN_START(src, disabled_time, disrupt_duration)
	return COMSIG_SABOTEUR_SUCCESS

/obj/item/flashlight/pen
	name = "笔形电筒"
	desc = "钢笔大小的灯，供医务人员使用，还可以用来生成全息影像，提醒人们即将到来的医疗援助."
	dir = EAST
	icon_state = "penlight"
	inhand_icon_state = ""
	worn_icon_state = "pen"
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CONDUCTS_ELECTRICITY
	light_range = 2
	COOLDOWN_DECLARE(holosign_cooldown)

/obj/item/flashlight/pen/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag)
		return

	if(!COOLDOWN_FINISHED(src, holosign_cooldown))
		balloon_alert(user, "not ready!")
		return

	var/target_turf = get_turf(target)
	var/mob/living/living_target = locate(/mob/living) in target_turf

	if(!living_target || (living_target == user))
		return

	to_chat(living_target, span_boldnotice("[user] is offering medical assistance; please halt your actions."))
	new /obj/effect/temp_visual/medical_holosign(target_turf, user) //produce a holographic glow
	COOLDOWN_START(src, holosign_cooldown, 10 SECONDS)

// see: [/datum/wound/burn/flesh/proc/uv()]
/obj/item/flashlight/pen/paramedic
	name = "paramedic penlight"
	desc = "高功率紫外线笔灯，旨在帮助严重烧伤患者预防感染. 请勿直视."
	icon_state = "penlight_surgical"
	light_color = LIGHT_COLOR_PURPLE
	/// Our current UV cooldown
	COOLDOWN_DECLARE(uv_cooldown)
	/// How long between UV fryings
	var/uv_cooldown_length = 30 SECONDS
	/// How much sanitization to apply to the burn wound
	var/uv_power = 1

/obj/effect/temp_visual/medical_holosign
	name = "医疗全息信号"
	desc = "小型全息投影，提示医护人员即将前来救助病人."
	icon_state = "medi_holo"
	duration = 30

/obj/effect/temp_visual/medical_holosign/Initialize(mapload, creator)
	. = ..()
	playsound(loc, 'sound/machines/ping.ogg', 50, FALSE) //make some noise!
	if(creator)
		visible_message(span_danger("[creator] created a medical hologram!"))

/obj/item/flashlight/seclite
	name = "战术手电"
	desc = "安保部配给的坚固手电筒."
	dir = EAST
	icon_state = "seclite"
	inhand_icon_state = "seclite"
	worn_icon_state = "seclite"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	force = 9 // Not as good as a stun baton.
	light_range = 5 // A little better than the standard flashlight.
	hitsound = 'sound/weapons/genhit1.ogg'

// the desk lamps are a bit special
/obj/item/flashlight/lamp
	name = "台灯"
	desc = "一个可调节底座的台灯."
	icon_state = "lamp"
	inhand_icon_state = "lamp"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	force = 10
	light_range = 3.5
	light_system = STATIC_LIGHT
	light_color = LIGHT_COLOR_FAINT_BLUE
	w_class = WEIGHT_CLASS_BULKY
	obj_flags = CONDUCTS_ELECTRICITY
	custom_materials = null
	start_on = TRUE

// green-shaded desk lamp
/obj/item/flashlight/lamp/green
	desc = "一个经典的绿色台灯."
	icon_state = "lampgreen"
	inhand_icon_state = "lampgreen"
	light_color = LIGHT_COLOR_TUNGSTEN

//Bananalamp
/obj/item/flashlight/lamp/bananalamp
	name = "香蕉灯"
	desc = "只有小丑才会想出制造这种廉价的香蕉形台灯. 它甚至有个愚蠢的拉绳开关."
	icon_state = "bananalamp"
	inhand_icon_state = null
	light_color = LIGHT_COLOR_BRIGHT_YELLOW

// FLARES
/obj/item/flashlight/flare
	name = "信号弹"
	desc = "一根纳米传讯供给的红色信号弹. 侧面印有使用说明：'拉绳即可点燃'."
	light_range = 7 // Pretty bright.
	icon_state = "flare"
	inhand_icon_state = "flare"
	worn_icon_state = "flare"
	actions_types = list()
	heat = 1000
	light_color = LIGHT_COLOR_FLARE
	light_system = MOVABLE_LIGHT
	grind_results = list(/datum/reagent/sulfur = 15)
	sound_on = 'sound/items/match_strike.ogg'
	toggle_context = FALSE
	/// How many seconds of fuel we have left
	var/fuel = 0
	/// Do we randomize the fuel when initialized
	var/randomize_fuel = TRUE
	/// How much damage it does when turned on
	var/on_damage = 7
	/// Type of atom thats spawns after fuel is used up
	var/trash_type = /obj/item/trash/flare
	/// If the light source can be extinguished
	var/can_be_extinguished = FALSE
	custom_materials = list(/datum/material/plastic= SMALL_MATERIAL_AMOUNT * 0.5)

/obj/item/flashlight/flare/Initialize(mapload)
	. = ..()
	if(randomize_fuel)
		fuel = rand(25 MINUTES, 35 MINUTES)
	if(light_on)
		attack_verb_continuous = string_list(list("burns", "singes"))
		attack_verb_simple = string_list(list("burn", "singe"))
		hitsound = 'sound/items/welder.ogg'
		force = on_damage
		damtype = BURN
		update_brightness()

/obj/item/flashlight/flare/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/flashlight/flare/attack(mob/living/carbon/victim, mob/living/carbon/user)
	if(!isliving(victim))
		return ..()

	if(light_on && victim.ignite_mob())
		message_admins("[ADMIN_LOOKUPFLW(user)]在[AREACOORD(user)]用[src]点燃了[key_name_admin(victim)]")
		user.log_message("用[src]点燃了[key_name(victim)]", LOG_ATTACK)

	return ..()

/obj/item/flashlight/flare/toggle_light()
	if(light_on || !fuel)
		return FALSE
	. = ..()

	name = "点燃的[initial(name)]"
	attack_verb_continuous = string_list(list("烧了", "烫了"))
	attack_verb_simple = string_list(list("烧了", "烫了"))
	hitsound = 'sound/items/welder.ogg'
	force = on_damage
	damtype = BURN


/obj/item/flashlight/flare/proc/turn_off()
	set_light_on(FALSE)
	name = initial(name)
	attack_verb_continuous = initial(attack_verb_continuous)
	attack_verb_simple = initial(attack_verb_simple)
	hitsound = initial(hitsound)
	force = initial(force)
	damtype = initial(damtype)
	update_brightness()

/obj/item/flashlight/flare/extinguish()
	. = ..()
	if((fuel != INFINITY) && can_be_extinguished)
		turn_off()

/obj/item/flashlight/flare/update_brightness()
	..()
	inhand_icon_state = "[initial(inhand_icon_state)]" + (light_on ? "-on" : "")
	update_appearance()

/obj/item/flashlight/flare/process(seconds_per_tick)
	open_flame(heat)
	fuel = max(fuel - seconds_per_tick * (1 SECONDS), 0)

	if(!fuel || !light_on)
		turn_off()
		STOP_PROCESSING(SSobj, src)

		if(!fuel && trash_type)
			new trash_type(loc)
			qdel(src)

/obj/item/flashlight/flare/proc/ignition(mob/user)
	if(!fuel)
		if(user)
			balloon_alert(user, "燃料用尽了!")
		return NO_FUEL
	if(light_on)
		if(user)
			balloon_alert(user, "已经点燃!")
		return ALREADY_LIT
	if(!toggle_light())
		return FAILURE

	if(fuel != INFINITY)
		START_PROCESSING(SSobj, src)

	return SUCCESS

/obj/item/flashlight/flare/fire_act(exposed_temperature, exposed_volume)
	ignition()
	return ..()

/obj/item/flashlight/flare/attack_self(mob/user)
	if(ignition(user) == SUCCESS)
		user.visible_message(span_notice("[user] 点燃了 \the [src]."), span_notice("你点燃了 \the [initial(src.name)]!"))

/obj/item/flashlight/flare/get_temperature()
	return light_on * heat

/obj/item/flashlight/flare/candle
	name = "红蜡烛"
	desc = "在希腊神话中，普罗米修斯从众神那里偷走了火，并把火赋予了人类. 这根红色蜡烛是他为自己保留的珍宝之一."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	inhand_icon_state = "candle"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	heat = 1000
	light_color = LIGHT_COLOR_FIRE
	light_range = 2
	fuel = 35 MINUTES
	randomize_fuel = FALSE
	trash_type = /obj/item/trash/candle
	can_be_extinguished = TRUE
	var/scented_type //SKYRAT EDIT ADDITION /// Pollutant type for scented candles
	/// The current wax level, used for drawing the correct icon
	var/current_wax_level = 1
	/// The previous wax level, remembered so we only have to make 3 update_appearance calls total as opposed to every tick
	var/last_wax_level = 1

/obj/item/flashlight/flare/candle/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/**
 * Just checks the wax level of the candle for displaying the correct sprite.
 *
 * This gets called in process() every tick. If the wax level has changed, then we call our update.
 */
/obj/item/flashlight/flare/candle/proc/check_wax_level()
	switch(fuel)
		if(25 MINUTES to INFINITY)
			current_wax_level = 1
		if(15 MINUTES to 25 MINUTES)
			current_wax_level = 2
		if(0 to 15 MINUTES)
			current_wax_level = 3

	if(last_wax_level != current_wax_level)
		last_wax_level = current_wax_level
		update_appearance(UPDATE_ICON | UPDATE_NAME)

/obj/item/flashlight/flare/candle/update_icon_state()
	. = ..()
	icon_state = "candle[current_wax_level][light_on ? "_lit" : ""]"
	inhand_icon_state = "candle[light_on ? "_lit" : ""]"

/**
 * Try to ignite the candle.
 *
 * Candles are ignited a bit differently from flares, in that they must be manually lit from other fire sources.
 * This will perform all the necessary checks to ensure that can happen, and display a message if it worked.
 *
 * Arguments:
 * * obj/item/fire_starter - the item being used to ignite the candle.
 * * mob/user - the user to display a message to.
 * * quiet - suppresses the to_chat message.
 * * silent - suppresses the balloon alerts as well as the to_chat message.
 */
/obj/item/flashlight/flare/candle/proc/try_light_candle(obj/item/fire_starter, mob/user, quiet, silent)
	if(!istype(fire_starter))
		return
	if(!istype(user))
		return

	var/success_msg = fire_starter.ignition_effect(src, user)
	var/ignition_result

	if(success_msg)
		ignition_result = ignition()

	switch(ignition_result)
		if(SUCCESS)
			update_appearance(UPDATE_ICON | UPDATE_NAME)
			if(!quiet && !silent)
				user.visible_message(success_msg)
			return SUCCESS
		if(ALREADY_LIT)
			if(!silent)
				balloon_alert(user, "已经点燃了!")
			return ALREADY_LIT
		if(NO_FUEL)
			if(!silent)
				balloon_alert(user, "烧光了!")
			return NO_FUEL

/// allows lighting an unlit candle from some fire source by left clicking the candle with the source
/obj/item/flashlight/flare/candle/attackby(obj/item/attacking_item, mob/user, params)
	if(try_light_candle(attacking_item, user, silent = istype(attacking_item, src.type))) // so we don't double balloon alerts when a candle is used to light another candle
		return COMPONENT_CANCEL_ATTACK_CHAIN
	else
		return ..()

// allows lighting an unlit candle from some fire source by left clicking the source with the candle
/obj/item/flashlight/flare/candle/pre_attack(atom/target, mob/living/user, params)
	if(ismob(target))
		return ..()

	if(try_light_candle(target, user, quiet = TRUE))
		return COMPONENT_CANCEL_ATTACK_CHAIN

	return ..()

/obj/item/flashlight/flare/candle/attack_self(mob/user)
	if(light_on && (fuel != INFINITY || !can_be_extinguished)) // can't extinguish eternal candles
		turn_off()
		user.visible_message(span_notice("[user] 熄灭了 [src]."))

/obj/item/flashlight/flare/candle/process(seconds_per_tick)
	. = ..()
	check_wax_level()

/obj/item/flashlight/flare/candle/infinite
	name = "永恒蜡烛"
	fuel = INFINITY
	randomize_fuel = FALSE
	can_be_extinguished = FALSE
	start_on = TRUE

/obj/item/flashlight/flare/torch
	name = "火把"
	desc = "用树叶和圆木做成的火把."
	light_range = 4
	icon_state = "torch"
	inhand_icon_state = "torch"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	light_color = LIGHT_COLOR_ORANGE
	on_damage = 10
	slot_flags = null
	trash_type = /obj/effect/decal/cleanable/ash
	can_be_extinguished = TRUE

/obj/item/flashlight/lantern
	name = "提灯"
	icon_state = "lantern"
	inhand_icon_state = "lantern"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	desc = "一盏矿用提灯."
	light_range = 6 // luminosity when on
	light_system = MOVABLE_LIGHT

/obj/item/flashlight/lantern/heirloom_moth
	name = "老旧提灯"
	desc = "一盏用了很久的老提灯."
	light_range = 4

/obj/item/flashlight/lantern/syndicate
	name = "可疑的提灯"
	desc = "一盏看上去很可疑的提灯."
	icon_state = "syndilantern"
	inhand_icon_state = "syndilantern"
	light_range = 10

/obj/item/flashlight/lantern/jade
	name = "玉提灯"
	desc = "一盏华丽的绿色提灯."
	color = LIGHT_COLOR_GREEN
	light_color = LIGHT_COLOR_GREEN

/obj/item/flashlight/slime
	gender = PLURAL
	name = "发光的史莱姆提取物"
	desc = "从黄色史莱姆中提取，挤压时发出强光."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "slime"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	custom_materials = null
	light_range = 7 //luminosity when on
	light_system = MOVABLE_LIGHT

/obj/item/flashlight/emp
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // SKYRAT EDIT
	special_desc = "这个手电筒装有一个微型电磁脉冲发生器." //SKYRAT EDIT
	var/emp_max_charges = 4
	var/emp_cur_charges = 4
	var/charge_timer = 0
	/// How many seconds between each recharge
	var/charge_delay = 20

/obj/item/flashlight/emp/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/flashlight/emp/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/flashlight/emp/process(seconds_per_tick)
	charge_timer += seconds_per_tick
	if(charge_timer < charge_delay)
		return FALSE
	charge_timer -= charge_delay
	emp_cur_charges = min(emp_cur_charges+1, emp_max_charges)
	return TRUE

/obj/item/flashlight/emp/attack(mob/living/M, mob/living/user)
	if(light_on && (user.zone_selected in list(BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH))) // call original attack when examining organs
		..()
	return

/obj/item/flashlight/emp/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(emp_cur_charges > 0)
		emp_cur_charges -= 1

		if(ismob(A))
			var/mob/M = A
			log_combat(user, M, "attacked", "EMP-light")
			M.visible_message(span_danger("[user] blinks \the [src] at \the [A]."), \
								span_userdanger("[user] blinks \the [src] at you."))
		else
			A.visible_message(span_danger("[user] blinks \the [src] at \the [A]."))
		to_chat(user, span_notice("\The [src] 还剩[emp_cur_charges] 次使用次数."))
		A.emp_act(EMP_HEAVY)
	else
		to_chat(user, span_warning("\The [src] 需要时间充电!"))
	return

/obj/item/flashlight/emp/debug //for testing emp_act()
	name = "debug 电磁脉冲手电筒"
	emp_max_charges = 100
	emp_cur_charges = 100

// Glowsticks, in the uncomfortable range of similar to flares,
// but not similar enough to make it worth a refactor
/obj/item/flashlight/glowstick
	name = "荧光棒"
	desc = "军用荧光棒."
	custom_price = PAYCHECK_LOWER
	w_class = WEIGHT_CLASS_SMALL
	light_range = 4
	light_system = MOVABLE_LIGHT
	color = LIGHT_COLOR_GREEN
	icon_state = "glowstick"
	base_icon_state = "glowstick"
	inhand_icon_state = null
	worn_icon_state = "lightstick"
	grind_results = list(/datum/reagent/phenol = 15, /datum/reagent/hydrogen = 10, /datum/reagent/oxygen = 5) //Meth-in-a-stick
	sound_on = 'sound/effects/wounds/crack2.ogg' // the cracking sound isn't just for wounds silly
	toggle_context = FALSE
	/// How many seconds of fuel we have left
	var/fuel = 0

/obj/item/flashlight/glowstick/Initialize(mapload)
	fuel = rand(50 MINUTES, 60 MINUTES)
	set_light_color(color)
	return ..()

/obj/item/flashlight/glowstick/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/flashlight/glowstick/process(seconds_per_tick)
	fuel = max(fuel - seconds_per_tick * (1 SECONDS), 0)
	if(fuel <= 0)
		turn_off()
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/glowstick/proc/turn_off()
	set_light_on(FALSE)
	update_appearance(UPDATE_ICON)

/obj/item/flashlight/glowstick/update_appearance(updates=ALL)
	. = ..()
	if(fuel <= 0)
		set_light_on(FALSE)
		return
	if(light_on)
		set_light_on(TRUE)
		return

/obj/item/flashlight/glowstick/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][(fuel <= 0) ? "-empty" : ""]"
	inhand_icon_state = "[base_icon_state][((fuel > 0) && light_on) ? "-on" : ""]"

/obj/item/flashlight/glowstick/update_overlays()
	. = ..()
	if(fuel <= 0 && !light_on)
		return

	var/mutable_appearance/glowstick_overlay = mutable_appearance(icon, "glowstick-glow")
	glowstick_overlay.color = color
	. += glowstick_overlay

/obj/item/flashlight/glowstick/attack_self(mob/user)
	if(fuel <= 0)
		balloon_alert(user, "荧光棒耗尽了!")
		return
	if(light_on)
		balloon_alert(user, "已经点亮了!")
		return

	. = ..()
	if(.)
		user.visible_message(span_notice("[user]弯折并摇晃[src]."), span_notice("你弯折并摇晃[src], 点亮了荧光棒!"))
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/glowstick/suicide_act(mob/living/carbon/human/user)
	if(!fuel)
		user.visible_message(span_suicide("[user] is trying to squirt [src]'s fluids into [user.p_their()] eyes... but it's empty!"))
		return SHAME
	var/obj/item/organ/internal/eyes/eyes = user.get_organ_slot(ORGAN_SLOT_EYES)
	if(!eyes)
		user.visible_message(span_suicide("[user] is trying to squirt [src]'s fluids into [user.p_their()] eyes... but [user.p_they()] don't have any!"))
		return SHAME
	user.visible_message(span_suicide("[user] is squirting [src]'s fluids into [user.p_their()] eyes! It looks like [user.p_theyre()] trying to commit suicide!"))
	fuel = 0
	return FIRELOSS

/obj/item/flashlight/glowstick/red
	name = "红色荧光棒"
	color = COLOR_SOFT_RED

/obj/item/flashlight/glowstick/blue
	name = "蓝色荧光棒"
	color = LIGHT_COLOR_BLUE

/obj/item/flashlight/glowstick/cyan
	name = "青色荧光棒"
	color = LIGHT_COLOR_CYAN

/obj/item/flashlight/glowstick/orange
	name = "橘色荧光棒"
	color = LIGHT_COLOR_ORANGE

/obj/item/flashlight/glowstick/yellow
	name = "黄色荧光棒"
	color = LIGHT_COLOR_DIM_YELLOW

/obj/item/flashlight/glowstick/pink
	name = "粉色荧光棒"
	color = LIGHT_COLOR_PINK

/obj/item/flashlight/spotlight //invisible lighting source
	name = "迪斯科灯"
	desc = "棒极了..."
	icon_state = null
	light_system = MOVABLE_LIGHT
	light_range = 4
	light_power = 10
	alpha = 0
	plane = FLOOR_PLANE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	///Boolean that switches when a full color flip ends, so the light can appear in all colors.
	var/even_cycle = FALSE
	///Base light_range that can be set on Initialize to use in smooth light range expansions and contractions.
	var/base_light_range = 4
	start_on = TRUE

/obj/item/flashlight/spotlight/Initialize(mapload, _light_range, _light_power, _light_color)
	. = ..()
	if(!isnull(_light_range))
		base_light_range = _light_range
		set_light_range(_light_range)
	if(!isnull(_light_power))
		set_light_power(_light_power)
	if(!isnull(_light_color))
		set_light_color(_light_color)

/obj/item/flashlight/flashdark
	name = "闪暗灯"
	desc = "一种用神秘元素制造的奇怪装置，以某种方式发出黑暗，或者它只是在吸收光线？没人知道."
	icon_state = "flashdark"
	inhand_icon_state = "flashdark"
	light_system = STATIC_LIGHT //The overlay light component is not yet ready to produce darkness.
	light_range = 0
	///Variable to preserve old lighting behavior in flashlights, to handle darkness.
	var/dark_light_range = 2.5
	///Variable to preserve old lighting behavior in flashlights, to handle darkness.
	var/dark_light_power = -3
	var/on = FALSE

/obj/item/flashlight/flashdark/update_brightness()
	. = ..()
	if(on)
		set_light(dark_light_range, dark_light_power)
	else
		set_light(0)

//type and subtypes spawned and used to give some eyes lights,
/obj/item/flashlight/eyelight
	name = "眼灯"
	desc = "你是怎么发现这个不该存在于脑外的东西的？"
	light_system = MOVABLE_LIGHT
	light_range = 15
	light_power = 1
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = DROPDEL
	actions_types = list()

/obj/item/flashlight/eyelight/adapted
	name = "adaptedlight"
	desc = "There is no possible way for a player to see this, so I can safely talk at length about why this exists. Adapted eyes come \
	with icons that go above the lighting layer so to make sure the red eyes that pierce the darkness are always visible we make the \
	human emit the smallest amount of light possible. Thanks for reading :)"
	light_range = 1
	light_power = 0.07

/obj/item/flashlight/eyelight/glow
	light_system = MOVABLE_LIGHT_BEAM
	light_range = 4
	light_power = 2

#undef FAILURE
#undef SUCCESS
#undef NO_FUEL
#undef ALREADY_LIT
