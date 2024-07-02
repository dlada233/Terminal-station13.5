// Describes the three modes of scanning available for health analyzers
#define SCANMODE_HEALTH 0
#define SCANMODE_WOUND 1
#define SCANMODE_COUNT 2 // Update this to be the number of scan modes if you add more

/obj/item/healthanalyzer
	name = "健康扫描仪"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "health"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "一种手持式健康分析仪，能够区分对象的生命体征，有一个侧键来扫描化学物质，并可以切换到重伤扫描模式."
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT *2)
	interaction_flags_click = NEED_LITERACY|NEED_LIGHT|ALLOW_RESTING
	/// Verbose/condensed
	var/mode = SCANNER_VERBOSE
	/// HEALTH/WOUND
	var/scanmode = SCANMODE_HEALTH
	/// Advanced health analyzer
	var/advanced = FALSE
	custom_price = PAYCHECK_COMMAND
	/// If this analyzer will give a bonus to wound treatments apon woundscan.
	var/give_wound_treatment_bonus = FALSE

/obj/item/healthanalyzer/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/healthanalyzer/examine(mob/user)
	. = ..()
	if(src.mode != SCANNER_NO_MODE)
		. += span_notice("Alt并单击 [src] 来切换到肢体损伤读数模式.")

/obj/item/healthanalyzer/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to analyze [user.p_them()]self with [src]! The display shows that [user.p_theyre()] dead!"))
	return BRUTELOSS

/obj/item/healthanalyzer/attack_self(mob/user)
	if(!user.can_read(src)) //SKYRAT EDIT: Blind People Can Analyze Again
		return

	scanmode = (scanmode + 1) % SCANMODE_COUNT
	switch(scanmode)
		if(SCANMODE_HEALTH)
			to_chat(user, span_notice("你切换健康分析仪以检测身体健康."))
		if(SCANMODE_WOUND)
			to_chat(user, span_notice("你切换健康分析仪以显示伤口额外信息."))

/obj/item/healthanalyzer/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	if(!user.can_read(src)) //SKYRAT EDIT CHANGE - Blind People Can Analyze Again- ORIGINAL: if(!user.can_read(src) || user.is_blind())
		return ITEM_INTERACT_BLOCKING

	var/mob/living/M = interacting_with

	. = ITEM_INTERACT_SUCCESS

	flick("[icon_state]-scan", src) //makes it so that it plays the scan animation upon scanning, including clumsy scanning

	// Clumsiness/brain damage check
	if ((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))
		user.visible_message(span_warning("[user] analyzes the floor's vitals!"), \
							span_notice("You stupidly try to analyze the floor's vitals!"))
		to_chat(user, "[span_info("Analyzing results for The floor:\n\tOverall status: <b>Healthy</b>")]\
				\n[span_info("Key: <font color='#00cccc'>Suffocation</font>/<font color='#00cc66'>Toxin</font>/<font color='#ffcc33'>Burn</font>/<font color='#ff3333'>Brute</font>")]\
				\n[span_info("\tDamage specifics: <font color='#66cccc'>0</font>-<font color='#00cc66'>0</font>-<font color='#ff9933'>0</font>-<font color='#ff3333'>0</font>")]\
				\n[span_info("Body temperature: ???")]")
		return

	if(ispodperson(M) && !advanced)
		to_chat(user, "<span class='info'>[M]的生物结构对健康分析仪来说太复杂了.")
		return

	user.visible_message(span_notice("[user]分析[M]的状态."))
	balloon_alert(user, "正在分析状态")
	playsound(user.loc, 'sound/items/healthanalyzer.ogg', 50)

	switch (scanmode)
		if (SCANMODE_HEALTH)
			healthscan(user, M, mode, advanced)
		if (SCANMODE_WOUND)
			woundscan(user, M, src)

	add_fingerprint(user)

/obj/item/healthanalyzer/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	if(!user.can_read(src)) // SKYRAT EDIT CHANGE - Blind people can analyze again - ORIGINAL: if(!user.can_read(src) || user.is_blind())
		return ITEM_INTERACT_BLOCKING

	chemscan(user, interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/healthanalyzer/add_item_context(
	obj/item/source,
	list/context,
	atom/target,
)
	if (!isliving(target))
		return NONE

	switch (scanmode)
		if (SCANMODE_HEALTH)
			context[SCREENTIP_CONTEXT_LMB] = "检测健康"
		if (SCANMODE_WOUND)
			context[SCREENTIP_CONTEXT_LMB] = "扫描伤口"

	context[SCREENTIP_CONTEXT_RMB] = "检测化学物质"

	return CONTEXTUAL_SCREENTIP_SET

/**
 * healthscan
 * returns a list of everything a health scan should give to a player.
 * Examples of where this is used is Health Analyzer and the Physical Scanner tablet app.
 * Args:
 * user - The person with the scanner
 * target - The person being scanned
 * mode - Uses SCANNER_CONDENSED or SCANNER_VERBOSE to decide whether to give a list of all individual limb damage
 * advanced - Whether it will give more advanced details, such as husk source.
 * tochat - Whether to immediately post the result into the chat of the user, otherwise it will return the results.
 */
/proc/healthscan(mob/user, mob/living/target, mode = SCANNER_VERBOSE, advanced = FALSE, tochat = TRUE)
	if(user.incapacitated())
		return

	// the final list of strings to render
	var/render_list = list()

	// Damage specifics
	var/oxy_loss = target.getOxyLoss()
	var/tox_loss = target.getToxLoss()
	var/fire_loss = target.getFireLoss()
	var/brute_loss = target.getBruteLoss()
	var/mob_status = (target.stat == DEAD ? span_alert("<b>已死亡</b>") : "<b>[round(target.health/target.maxHealth,0.01)*100]% 健康</b>")

	if(HAS_TRAIT(target, TRAIT_FAKEDEATH) && !advanced)
		mob_status = span_alert("<b>已死亡</b>")
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss))) // Random oxygen loss

	render_list += "[span_info("[target]分析结果:")]\n<span class='info ml-1'>总体状况: [mob_status]</span>\n"

	if(ishuman(target))
		var/mob/living/carbon/human/humantarget = target
		if(humantarget.undergoing_cardiac_arrest() && humantarget.stat != DEAD)
			render_list += "<span class='alert ml-1'><b>心脏病发作:请立即进行除颤或其他电击!</b></span>\n"
		if(humantarget.has_reagent(/datum/reagent/inverse/technetium))
			advanced = TRUE

	SEND_SIGNAL(target, COMSIG_LIVING_HEALTHSCAN, render_list, advanced, user, mode)

	// Husk detection
	if(HAS_TRAIT(target, TRAIT_HUSK))
		if(advanced)
			if(HAS_TRAIT_FROM(target, TRAIT_HUSK, BURN))
				/* SKYRAT EDIT START: More unhusking information */
				render_list += "<span class='alert ml-1'>对象已被严重烧伤. Proceed by repairing burn damage and following up with \
								application of [SYNTHFLESH_UNHUSK_AMOUNT]u synthflesh or injection of rezadone as treatment.</span>\n"
			else if (HAS_TRAIT_FROM(target, TRAIT_HUSK, CHANGELING_DRAIN))
				render_list += "<span class='alert ml-1'>对象已被风干. Use application of [SYNTHFLESH_LING_UNHUSK_AMOUNT]u \
								of synthflesh or injection of rezadone as treatment.</span>\n"
				/* SKYRAT EDIT END */
			else
				render_list += "<span class='alert ml-1'>对象被神秘的事故损毁了外皮.</span>\n"

		else
			render_list += "<span class='alert ml-1'>对象外皮已经损毁.</span>\n"

	if(target.getStaminaLoss())
		if(advanced)
			render_list += "<span class='alert ml-1'>疲劳水平: [target.getStaminaLoss()]%.</span>\n"
		else
			render_list += "<span class='alert ml-1'>对象表现出了疲劳.</span>\n"
	if (!target.get_organ_slot(ORGAN_SLOT_BRAIN)) // kept exclusively for soul purposes
		render_list += "<span class='alert ml-1'>对象没有大脑.</span>\n"

	var/death_consequences_status_text // SKYRAT EDIT ADDITION: Death consequences quirk
	if(iscarbon(target))
		var/mob/living/carbon/carbontarget = target
		if(LAZYLEN(carbontarget.get_traumas()))
			var/list/trauma_text = list()
			for(var/datum/brain_trauma/trauma in carbontarget.get_traumas())
				//SKYRAT EDIT: Scary Traits (Bimbo)
				if(!trauma.display_scanner)
					continue
				//SKYRAT EDIT: Scary Traits (Bimbo)
				var/trauma_desc = ""
				switch(trauma.resilience)
					if(TRAUMA_RESILIENCE_SURGERY)
						trauma_desc += "严重的"
					if(TRAUMA_RESILIENCE_LOBOTOMY)
						trauma_desc += "根深蒂固的"
					if(TRAUMA_RESILIENCE_WOUND)
						trauma_desc += "使之身心破碎的"
					if(TRAUMA_RESILIENCE_MAGIC, TRAUMA_RESILIENCE_ABSOLUTE)
						trauma_desc += "永久性"
				trauma_desc += trauma.scan_desc
				trauma_text += trauma_desc
				// SKYRAT EDIT ADDITION START: Death Consequences Quirk
				if (istype(trauma, /datum/brain_trauma/severe/death_consequences))
					var/datum/brain_trauma/severe/death_consequences/consequences_trauma = trauma
					death_consequences_status_text = consequences_trauma.get_health_analyzer_link_text(user)
				// SKYRAT EDIT ADDITION END: Death Consequences Quirk
			render_list += "<span class='alert ml-1'>检测到颅脑损伤,该对象可能患有[english_list(trauma_text)].</span>\n"
		if(carbontarget.quirks.len)
			render_list += "<span class='info ml-1'>主要障碍: [carbontarget.get_quirk_string(FALSE, CAT_QUIRK_MAJOR_DISABILITY, from_scan = TRUE)].</span>\n"
			if(advanced)
				render_list += "<span class='info ml-1'>次要障碍: [carbontarget.get_quirk_string(FALSE, CAT_QUIRK_MINOR_DISABILITY, TRUE)].</span>\n"

	// SKYRAT EDIT ADDITION START -- Show increased/decreased brute/burn mods, to "leave a paper trail" for the fragility quirk
	if(ishuman(target))
		var/mob/living/carbon/human/humantarget = target

		var/datum/physiology/physiology = humantarget.physiology
		if (physiology.brute_mod != 1)
			render_list += "<span class='danger ml-1'>Subject takes [(physiology.brute_mod) * 100]% brute damage.</span>\n"
		if (physiology.burn_mod != 1)
			render_list += "<span class='danger ml-1'>Subject takes [(physiology.burn_mod) * 100]% burn damage.</span>\n"
	// SKYRAT EDIT ADDITION END

	if (HAS_TRAIT(target, TRAIT_IRRADIATED))
		render_list += "<span class='alert ml-1'>对象遭到辐射,请施以解毒治疗.</span>\n"

	//Eyes and ears
	if(advanced && iscarbon(target))
		var/mob/living/carbon/carbontarget = target

		// Ear status
		var/obj/item/organ/internal/ears/ears = carbontarget.get_organ_slot(ORGAN_SLOT_EARS)
		if(istype(ears))
			if(HAS_TRAIT_FROM(carbontarget, TRAIT_DEAF, GENETIC_MUTATION))
				render_list += "<span class='alert ml-2'>对象患有先天性失聪.\n</span>"
			else if(HAS_TRAIT_FROM(carbontarget, TRAIT_DEAF, EAR_DAMAGE))
				render_list += "<span class='alert ml-2'>对象因耳损伤而失聪.\n</span>"
			else if(HAS_TRAIT(carbontarget, TRAIT_DEAF))
				render_list += "<span class='alert ml-2'>对象失聪.\n</span>"
			else
				if(ears.damage)
					render_list += "<span class='alert ml-2'>对象患有 [ears.damage > ears.maxHealth ? "永久性 ": "临时性 "]听觉损伤.\n</span>"
				if(ears.deaf)
					render_list += "<span class='alert ml-2'>对象患有 [ears.damage > ears.maxHealth ? "永久性 ": "临时性 "] 失聪.\n</span>"

		// Eye status
		var/obj/item/organ/internal/eyes/eyes = carbontarget.get_organ_slot(ORGAN_SLOT_EYES)
		if(istype(eyes))
			if(carbontarget.is_blind())
				render_list += "<span class='alert ml-2'>对象失明.\n</span>"
			else if(carbontarget.is_nearsighted())
				render_list += "<span class='alert ml-2'>对象近视.\n</span>"

	// Body part damage report
	if(iscarbon(target))
		var/mob/living/carbon/carbontarget = target
		var/list/damaged = carbontarget.get_damaged_bodyparts(1,1)
		if(length(damaged)>0 || oxy_loss>0 || tox_loss>0 || fire_loss>0)
			var/dmgreport = "<span class='info ml-1'>一般状况:</span>\
							<table class='ml-2'><tr><font face='Verdana'>\
							<td style='width:7em;'><font color='#ff0000'><b>伤害:</b></font></td>\
							<td style='width:5em;'><font color='#ff3333'><b>Brute-创伤</b></font></td>\
							<td style='width:4em;'><font color='#ff9933'><b>Burn-烧伤</b></font></td>\
							<td style='width:4em;'><font color='#00cc66'><b>Toxin-毒素伤</b></font></td>\
							<td style='width:8em;'><font color='#00cccc'><b>Suffocation-窒息伤</b></font></td></tr>\
							<tr><td><font color='#ff3333'><b>总体情况:</b></font></td>\
							<td><font color='#ff3333'><b>[CEILING(brute_loss,1)]</b></font></td>\
							<td><font color='#ff9933'><b>[CEILING(fire_loss,1)]</b></font></td>\
							<td><font color='#00cc66'><b>[CEILING(tox_loss,1)]</b></font></td>\
							<td><font color='#33ccff'><b>[CEILING(oxy_loss,1)]</b></font></td></tr>"

			if(mode == SCANNER_VERBOSE)
				for(var/obj/item/bodypart/limb as anything in damaged)
					if(limb.bodytype & BODYTYPE_ROBOTIC)
						dmgreport += "<tr><td><font color='#cc3333'>[capitalize(limb.name)]:</font></td>"
					else
						dmgreport += "<tr><td><font color='#cc3333'>[capitalize(limb.plaintext_zone)]:</font></td>"
					dmgreport += "<td><font color='#cc3333'>[(limb.brute_dam > 0) ? "[CEILING(limb.brute_dam,1)]" : "0"]</font></td>"
					dmgreport += "<td><font color='#ff9933'>[(limb.burn_dam > 0) ? "[CEILING(limb.burn_dam,1)]" : "0"]</font></td></tr>"
			dmgreport += "</font></table>"
			render_list += dmgreport // tables do not need extra linebreak
		for(var/obj/item/bodypart/limb as anything in carbontarget.bodyparts)
			for(var/obj/item/embed as anything in limb.embedded_objects)
				render_list += "<span class='alert ml-1'>嵌入物体: [embed] 位于 \the [limb.plaintext_zone]</span>\n"

	if(ishuman(target))
		var/mob/living/carbon/human/humantarget = target

		// Organ damage, missing organs
		if(humantarget.organs && humantarget.organs.len)
			var/render = FALSE
			var/toReport = "<span class='info ml-1'>Organs:</span>\
				<table class='ml-2'><tr>\
				<td style='width:6em;'><font color='#ff0000'><b>Organ:</b></font></td>\
				[advanced ? "<td style='width:3em;'><font color='#ff0000'><b>Dmg</b></font></td>" : ""]\
				<td style='width:12em;'><font color='#ff0000'><b>Status</b></font></td>"

			for(var/obj/item/organ/organ as anything in humantarget.organs)
				var/status = organ.get_status_text(advanced)
				if (status != "")
					render = TRUE
					toReport += "<tr><td><font color='#cc3333'>[organ.name]:</font></td>\
						[advanced ? "<td><font color='#ff3333'>[CEILING(organ.damage,1)]</font></td>" : ""]\
						<td>[status]</td></tr>"

			var/missing_organs = list()
			if(!humantarget.get_organ_slot(ORGAN_SLOT_BRAIN))
				missing_organs += "brain-大脑"
			if(!HAS_TRAIT_FROM(humantarget, TRAIT_NOBLOOD, SPECIES_TRAIT) && !humantarget.get_organ_slot(ORGAN_SLOT_HEART))
				missing_organs += "heart-心脏"
			if(!HAS_TRAIT_FROM(humantarget, TRAIT_NOBREATH, SPECIES_TRAIT) && !humantarget.get_organ_slot(ORGAN_SLOT_LUNGS))
				missing_organs += "lungs-肺部"
			if(!HAS_TRAIT_FROM(humantarget, TRAIT_LIVERLESS_METABOLISM, SPECIES_TRAIT) && !humantarget.get_organ_slot(ORGAN_SLOT_LIVER))
				missing_organs += "liver-肝脏"
			if(!HAS_TRAIT_FROM(humantarget, TRAIT_NOHUNGER, SPECIES_TRAIT) && !humantarget.get_organ_slot(ORGAN_SLOT_STOMACH))
				missing_organs += "stomach-胃部"
			if(!humantarget.get_organ_slot(ORGAN_SLOT_TONGUE))
				missing_organs += "tongue-舌头"
			if(!humantarget.get_organ_slot(ORGAN_SLOT_EARS))
				missing_organs += "ears-耳部"
			if(!humantarget.get_organ_slot(ORGAN_SLOT_EYES))
				missing_organs += "eyes-眼部"

			if(length(missing_organs))
				render = TRUE
				for(var/organ in missing_organs)
					toReport += "<tr><td><font color='#cc3333'>[organ]:</font></td>\
						[advanced ? "<td><font color='#ff3333'>["-"]</font></td>" : ""]\
						<td><font color='#cc3333'>["Missing"]</font></td></tr>"

			if(render)
				render_list += toReport + "</table>" // tables do not need extra linebreak

		//Genetic stability
		if(advanced && humantarget.has_dna())
			render_list += "<span class='info ml-1'>基因稳定度: [humantarget.dna.stability]%.</span>\n"

		// Hulk and body temperature
		var/datum/species/targetspecies = humantarget.dna.species
		var/mutant = humantarget.dna.check_mutation(/datum/mutation/human/hulk)

		render_list += "<span class='info ml-1'>Species: [targetspecies.name][mutant ? "-derived mutant" : ""]</span>\n"
		var/core_temperature_message = "核心体温: [round(humantarget.coretemperature-T0C, 0.1)] &deg;C ([round(humantarget.coretemperature*1.8-459.67,0.1)] &deg;F)"
		if(humantarget.coretemperature >= humantarget.get_body_temp_heat_damage_limit())
			render_list += "<span class='alert ml-1'>☼ [core_temperature_message] ☼</span>\n"
		else if(humantarget.coretemperature <= humantarget.get_body_temp_cold_damage_limit())
			render_list += "<span class='alert ml-1'>❄ [core_temperature_message] ❄</span>\n"
		else
			render_list += "<span class='info ml-1'>[core_temperature_message]</span>\n"

	var/body_temperature_message = "身体体温: [round(target.bodytemperature-T0C, 0.1)] &deg;C ([round(target.bodytemperature*1.8-459.67,0.1)] &deg;F)"
	if(target.bodytemperature >= target.get_body_temp_heat_damage_limit())
		render_list += "<span class='alert ml-1'>☼ [body_temperature_message] ☼</span>\n"
	else if(target.bodytemperature <= target.get_body_temp_cold_damage_limit())
		render_list += "<span class='alert ml-1'>❄ [body_temperature_message] ❄</span>\n"
	else
		render_list += "<span class='info ml-1'>[body_temperature_message]</span>\n"

	// Time of death
	if(target.station_timestamp_timeofdeath && (target.stat == DEAD || ((HAS_TRAIT(target, TRAIT_FAKEDEATH)) && !advanced)))
		render_list += "<span class='info ml-1'>死亡时间: [target.station_timestamp_timeofdeath]</span>\n"
		var/tdelta = round(world.time - target.timeofdeath)
		render_list += "<span class='alert ml-1'><b>对象死于 [DisplayTimeText(tdelta)] 之前.</b></span>\n"

	// Wounds
	if(iscarbon(target))
		var/mob/living/carbon/carbontarget = target
		var/list/wounded_parts = carbontarget.get_wounded_bodyparts()
		for(var/i in wounded_parts)
			var/obj/item/bodypart/wounded_part = i
			render_list += "<span class='alert ml-1'><b>Wound-重伤 [LAZYLEN(wounded_part.wounds) > 1 ? "" : ""] 被检测到于 [wounded_part.name]</b>"
			for(var/k in wounded_part.wounds)
				var/datum/wound/W = k
				render_list += "<div class='ml-2'>[W.name] ([W.severity_text()])\n推荐对策: [W.treat_text]</div>" // less lines than in woundscan() so we don't overload people trying to get basic med info
			render_list += "</span>"

	//Diseases
	for(var/datum/disease/disease as anything in target.diseases)
		if(!(disease.visibility_flags & HIDDEN_SCANNER))
			render_list += "<span class='alert ml-1'><b>警告: 检测到 [disease.form]</b>\n\
			<div class='ml-2'>Name: [disease.name].\n类型: [disease.spread_text].\n阶段: [disease.stage]/[disease.max_stages].\n可能的治愈方法: [disease.cure_text]</div>\
			</span>" // divs do not need extra linebreak

	// Blood Level
	if(target.has_dna())
		var/mob/living/carbon/carbontarget = target
		var/blood_id = carbontarget.get_blood_id()
		if(blood_id)
			if(carbontarget.is_bleeding())
				render_list += "<span class='alert ml-1'><b>对象正在流血!</b></span>\n"
			var/blood_percent = round((carbontarget.blood_volume / BLOOD_VOLUME_NORMAL) * 100)
			var/blood_type = carbontarget.dna.blood_type
			if(blood_id != /datum/reagent/blood) // special blood substance
				var/datum/reagent/R = GLOB.chemical_reagents_list[blood_id]
				blood_type = R ? R.name : blood_id
			if(carbontarget.blood_volume <= BLOOD_VOLUME_SAFE && carbontarget.blood_volume > BLOOD_VOLUME_OKAY)
				render_list += "<span class='alert ml-1'>血含量: 低 [blood_percent] %, [carbontarget.blood_volume] cl,</span> [span_info("血型: [blood_type]")]\n"
			else if(carbontarget.blood_volume <= BLOOD_VOLUME_OKAY)
				render_list += "<span class='alert ml-1'>血含量: <b>危急 [blood_percent] %</b>, [carbontarget.blood_volume] cl,</span> [span_info("血型: [blood_type]")]\n"
			else
				render_list += "<span class='info ml-1'>血含量: [blood_percent]%, [carbontarget.blood_volume] cl, type: [blood_type]</span>\n"

	// Blood Alcohol Content
	var/blood_alcohol_content = target.get_blood_alcohol_content()
	if(blood_alcohol_content > 0)
		if(blood_alcohol_content >= 0.24)
			render_list += "<span class='alert ml-1'>Blood alcohol content: <b>CRITICAL [blood_alcohol_content]%</b></span>\n"
		else
			render_list += "<span class='info ml-1'>Blood alcohol content: [blood_alcohol_content]%</span>\n"

	// Cybernetics
	if(iscarbon(target))
		var/mob/living/carbon/carbontarget = target
		var/cyberimp_detect
		for(var/obj/item/organ/internal/cyberimp/cyberimp in carbontarget.organs)
			if(IS_ROBOTIC_ORGAN(cyberimp) && !(cyberimp.organ_flags & ORGAN_HIDDEN))
				cyberimp_detect += "[!cyberimp_detect ? "[cyberimp.get_examine_string(user)]" : ", [cyberimp.get_examine_string(user)]"]"
		if(cyberimp_detect)
			render_list += "<span class='notice ml-1'>Detected cybernetic modifications:</span>\n"
			render_list += "<span class='notice ml-2'>[cyberimp_detect]</span>\n"
	// we handled the last <br> so we don't need handholding

	// SKYRAT EDIT ADDITION - Mutant stuff
	if(target.GetComponent(/datum/component/mutant_infection))
		render_list += span_userdanger("UNKNOWN PROTO-VIRAL INFECTION DETECTED. ISOLATE IMMEDIATELY.")
	// SKYRAT EDIT END

	// SKYRAT EDIT ADDITION - DEATH CONSEQUENCES QUIRK
	if(death_consequences_status_text)
		render_list += death_consequences_status_text
	// SKYRAT EDIT END

	if(tochat)
		to_chat(user, examine_block(jointext(render_list, "")), trailing_newline = FALSE, type = MESSAGE_TYPE_INFO)
	else
		return(jointext(render_list, ""))

/proc/chemscan(mob/living/user, mob/living/target)
	if(user.incapacitated())
		return

	if(istype(target) && target.reagents)
		var/list/render_list = list() //The master list of readouts, including reagents in the blood/stomach, addictions, quirks, etc.
		var/list/render_block = list() //A second block of readout strings. If this ends up empty after checking stomach/blood contents, we give the "empty" header.

		// Blood reagents
		if(target.reagents.reagent_list.len)
			for(var/r in target.reagents.reagent_list)
				var/datum/reagent/reagent = r
				if(reagent.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems on scanners
					continue
				render_block += "<span class='notice ml-2'>[round(reagent.volume, 0.001)] units of [reagent.name][reagent.overdosed ? "</span> - [span_boldannounce("OVERDOSING")]" : ".</span>"]\n"

		if(!length(render_block)) //If no VISIBLY DISPLAYED reagents are present, we report as if there is nothing.
			render_list += "<span class='notice ml-1'>对象的血液中没有任何试剂成分.</span>\n"
		else
			render_list += "<span class='notice ml-1'>对象的血液中含有以下试剂成分:</span>\n"
			render_list += render_block //Otherwise, we add the header, reagent readouts, and clear the readout block for use on the stomach.
			render_block.Cut()

		// Stomach reagents
		var/obj/item/organ/internal/stomach/belly = target.get_organ_slot(ORGAN_SLOT_STOMACH)
		if(belly)
			if(belly.reagents.reagent_list.len)
				for(var/bile in belly.reagents.reagent_list)
					var/datum/reagent/bit = bile
					if(bit.chemical_flags & REAGENT_INVISIBLE)
						continue
					if(!belly.food_reagents[bit.type])
						render_block += "<span class='notice ml-2'>[round(bit.volume, 0.001)] units of [bit.name][bit.overdosed ? "</span> - [span_boldannounce("OVERDOSING")]" : ".</span>"]\n"
					else
						var/bit_vol = bit.volume - belly.food_reagents[bit.type]
						if(bit_vol > 0)
							render_block += "<span class='notice ml-2'>[round(bit_vol, 0.001)] units of [bit.name][bit.overdosed ? "</span> - [span_boldannounce("OVERDOSING")]" : ".</span>"]\n"

			if(!length(render_block))
				render_list += "<span class='notice ml-1'>Subject contains no reagents in their stomach.</span>\n"
			else
				render_list += "<span class='notice ml-1'>Subject contains the following reagents in their stomach:</span>\n"
				render_list += render_block

		// Addictions
		if(LAZYLEN(target.mind?.active_addictions))
			render_list += "<span class='boldannounce ml-1'>Subject is addicted to the following types of drug:</span>\n"
			for(var/datum/addiction/addiction_type as anything in target.mind.active_addictions)
				render_list += "<span class='alert ml-2'>[initial(addiction_type.name)]</span>\n"

		// Special eigenstasium addiction
		if(target.has_status_effect(/datum/status_effect/eigenstasium))
			render_list += "<span class='notice ml-1'>Subject is temporally unstable. Stabilising agent is recommended to reduce disturbances.</span>\n"

		// Allergies
		for(var/datum/quirk/quirky as anything in target.quirks)
			if(istype(quirky, /datum/quirk/item_quirk/allergic))
				var/datum/quirk/item_quirk/allergic/allergies_quirk = quirky
				var/allergies = allergies_quirk.allergy_string
				render_list += "<span class='alert ml-1'>Subject is extremely allergic to the following chemicals:</span>\n"
				render_list += "<span class='alert ml-2'>[allergies]</span>\n"

		// we handled the last <br> so we don't need handholding
		to_chat(user, examine_block(jointext(render_list, "")), trailing_newline = FALSE, type = MESSAGE_TYPE_INFO)

/obj/item/healthanalyzer/click_alt(mob/user)
	if(mode == SCANNER_NO_MODE)
		return CLICK_ACTION_BLOCKING

	mode = !mode
	to_chat(user, mode == SCANNER_VERBOSE ? "The scanner now shows specific limb damage." : "The scanner no longer shows limb damage.")
	return CLICK_ACTION_SUCCESS

/obj/item/healthanalyzer/advanced
	name = "高级健康分析仪"
	icon_state = "health_adv"
	desc = "一种手持式身体扫描仪，能够高精度地分析对象的生命体征."
	advanced = TRUE

#define AID_EMOTION_NEUTRAL "neutral"
#define AID_EMOTION_HAPPY "happy"
#define AID_EMOTION_WARN "cautious"
#define AID_EMOTION_ANGRY "angery"
#define AID_EMOTION_SAD "sad"

/// Displays wounds with extended information on their status vs medscanners
/proc/woundscan(mob/user, mob/living/carbon/patient, obj/item/healthanalyzer/scanner, simple_scan = FALSE)
	if(!istype(patient) || user.incapacitated())
		return

	var/render_list = ""
	var/advised = FALSE
	for(var/limb in patient.get_wounded_bodyparts())
		var/obj/item/bodypart/wounded_part = limb
		render_list += "<span class='alert ml-1'><b>Warning: Wound-重伤[LAZYLEN(wounded_part.wounds) > 1? "" : ""] 被检测到于 [wounded_part.name]</b>"
		for(var/limb_wound in wounded_part.wounds)
			var/datum/wound/current_wound = limb_wound
			render_list += "<div class='ml-2'>[simple_scan ? current_wound.get_simple_scanner_description() : current_wound.get_scanner_description()]</div>\n"
			if (scanner.give_wound_treatment_bonus)
				ADD_TRAIT(current_wound, TRAIT_WOUND_SCANNED, ANALYZER_TRAIT)
				if(!advised)
					to_chat(user, span_notice("你注意到明亮的全息图像出现在你的 [(length(wounded_part.wounds) || length(patient.get_wounded_bodyparts()) ) > 1 ? "不同伤口" : "伤口"]之上. 它们充满了有用的参数信息，这对于治疗有所帮助!"))
					advised = TRUE
		render_list += "</span>"

	if(render_list == "")
		if(simple_scan)
			var/obj/item/healthanalyzer/simple/simple_scanner = scanner
			// Only emit the cheerful scanner message if this scan came from a scanner
			playsound(simple_scanner, 'sound/machines/ping.ogg', 50, FALSE)
			to_chat(user, span_notice("\The [simple_scanner] makes a happy ping and briefly displays a smiley face with several exclamation points! It's really excited to report that [patient] has no wounds!"))
			simple_scanner.show_emotion(AID_EMOTION_HAPPY)
		to_chat(user, "<span class='notice ml-1'>No wounds detected in subject.</span>")
	else
		to_chat(user, examine_block(jointext(render_list, "")), type = MESSAGE_TYPE_INFO)
		if(simple_scan)
			var/obj/item/healthanalyzer/simple/simple_scanner = scanner
			simple_scanner.show_emotion(AID_EMOTION_WARN)
			playsound(simple_scanner, 'sound/machines/twobeep.ogg', 50, FALSE)


/obj/item/healthanalyzer/simple
	name = "急救小帮手"
	icon_state = "first_aid"
	desc = "一个有用的、适宜六岁以上儿童使用的、最重要的是及其便宜的MeLo-Tech医疗扫描仪，用于诊断严重伤口与介绍治疗对策，虽然告诉你身上是否有一个大洞这种功能听起来没什么用，但它在伤口附近还会显示一个临时的全息图像，其中的信息保证了治疗效果与速度的两倍."
	mode = SCANNER_NO_MODE
	give_wound_treatment_bonus = TRUE

	/// Cooldown for when the analyzer will allow you to ask it for encouragement. Don't get greedy!
	var/next_encouragement
	/// The analyzer's current emotion. Affects the sprite overlays and if it's going to prick you for being greedy or not.
	var/emotion = AID_EMOTION_NEUTRAL
	/// Encouragements to play when attack_selfing
	var/list/encouragements = list("简单地露出一张笑脸，空虚地凝视着你", "简单地显示了一个旋转的卡通心脏", "展示了一段关于健康饮食和锻炼的鼓励信息", \
			"提醒你每个人都在努力", "显示一条祝福的信息", "对你有学习急救的兴趣表示真诚的感谢", "正式赦免你所有的罪")
	/// How often one can ask for encouragement
	var/patience = 10 SECONDS
	/// What do we scan for, only used in descriptions
	var/scan_for_what = "serious injuries"

/obj/item/healthanalyzer/simple/attack_self(mob/user)
	if(next_encouragement < world.time)
		playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
		to_chat(user, span_notice("[src] makes a happy ping and [pick(encouragements)]!"))
		next_encouragement = world.time + 10 SECONDS
		show_emotion(AID_EMOTION_HAPPY)
	else if(emotion != AID_EMOTION_ANGRY)
		greed_warning(user)
	else
		violence(user)

/obj/item/healthanalyzer/simple/proc/greed_warning(mob/user)
	to_chat(user, span_warning("[src] 显示了一张令人毛骨悚然的高清皱眉脸，惩罚你要求它给予太多鼓励."))
	show_emotion(AID_EMOTION_ANGRY)

/obj/item/healthanalyzer/simple/proc/violence(mob/user)
	playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
	if(isliving(user))
		var/mob/living/L = user
		to_chat(L, span_warning("[src] 发出失望嗡嗡声，并为了惩罚你的贪婪而刺痛了你的手指...嗷!"))
		flick(icon_state + "_pinprick", src)
		violence_damage(user)
		user.dropItemToGround(src)
		show_emotion(AID_EMOTION_HAPPY)

/obj/item/healthanalyzer/simple/proc/violence_damage(mob/living/user)
	user.adjustBruteLoss(4)

/obj/item/healthanalyzer/simple/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	if(!user.can_read(src)) //SKYRAT EDIT CHANGE - Blind People Can Analyze Again - ORIGINAL: if(!user.can_read(src) || user.is_blind())
		return ITEM_INTERACT_BLOCKING

	add_fingerprint(user)
	user.visible_message(
		span_notice("[user] scans [interacting_with] for [scan_for_what]."),
		span_notice("You scan [interacting_with] for [scan_for_what]."),
	)

	if(!iscarbon(interacting_with))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		to_chat(user, span_notice("[src] makes a sad buzz and briefly displays an unhappy face, indicating it can't scan [interacting_with]."))
		show_emotion(AI_EMOTION_SAD)
		return ITEM_INTERACT_BLOCKING

	do_the_scan(interacting_with, user)
	flick(icon_state + "_pinprick", src)
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/item/healthanalyzer/simple/proc/do_the_scan(mob/living/carbon/scanning, mob/living/user)
	woundscan(user, scanning, src, simple_scan = TRUE)

/obj/item/healthanalyzer/simple/update_overlays()
	. = ..()
	switch(emotion)
		if(AID_EMOTION_HAPPY)
			. += mutable_appearance(icon, "+no_wounds")
		if(AID_EMOTION_WARN)
			. += mutable_appearance(icon, "+wound_warn")
		if(AID_EMOTION_ANGRY)
			. += mutable_appearance(icon, "+angry")
		if(AID_EMOTION_SAD)
			. += mutable_appearance(icon, "+fail_scan")

/// Sets a new emotion display on the scanner, and resets back to neutral in a moment
/obj/item/healthanalyzer/simple/proc/show_emotion(new_emotion)
	emotion = new_emotion
	update_appearance(UPDATE_OVERLAYS)
	if (emotion != AID_EMOTION_NEUTRAL)
		addtimer(CALLBACK(src, PROC_REF(reset_emotions), AID_EMOTION_NEUTRAL), 2 SECONDS)

// Resets visible emotion back to neutral
/obj/item/healthanalyzer/simple/proc/reset_emotions()
	emotion = AID_EMOTION_NEUTRAL
	update_appearance(UPDATE_OVERLAYS)

/obj/item/healthanalyzer/simple/miner
	name = "矿用急救小帮手"
	icon_state = "miner_aid"
	desc = "一个有用的、适宜六岁以上儿童使用的、最重要的是及其便宜的MeLo-Tech医疗扫描仪，用于诊断严重伤口与介绍治疗对策,有一个很酷但是没有任何用的天线."

/obj/item/healthanalyzer/simple/disease
	name = "disease state analyzer"
	desc = "Another of MeLo-Tech's dubiously useful medsci scanners, the disease analyzer is a pretty rare find these days - NT found out that giving their hospitals the lowest-common-denominator pandemic equipment resulted in too much financial loss of life to be profitable. There's rumours that the inbuilt AI is jealous of the first aid analyzer's success."
	icon_state = "disease_aid"
	mode = SCANNER_NO_MODE
	encouragements = list("encourages you to take your medication", "briefly displays a spinning cartoon heart", "reasures you about your condition", \
			"reminds you that everyone is doing their best", "displays a message wishing you well", "displays a message saying how proud it is that you're taking care of yourself", "formally absolves you of all your sins")
	patience = 20 SECONDS
	scan_for_what = "diseases"

/obj/item/healthanalyzer/simple/disease/violence_damage(mob/living/user)
	user.adjustBruteLoss(1)
	user.reagents.add_reagent(/datum/reagent/toxin, rand(1, 3))

/obj/item/healthanalyzer/simple/disease/do_the_scan(mob/living/carbon/scanning, mob/living/user)
	diseasescan(user, scanning, src)

/obj/item/healthanalyzer/simple/disease/update_overlays()
	. = ..()
	switch(emotion)
		if(AID_EMOTION_HAPPY)
			. += mutable_appearance(icon, "+not_infected")
		if(AID_EMOTION_WARN)
			. += mutable_appearance(icon, "+infected")
		if(AID_EMOTION_ANGRY)
			. += mutable_appearance(icon, "+rancurous")
		if(AID_EMOTION_SAD)
			. += mutable_appearance(icon, "+unknown_scan")
	if(emotion != AID_EMOTION_NEUTRAL)
		addtimer(CALLBACK(src, PROC_REF(reset_emotions)), 4 SECONDS) // longer on purpose

/// Checks the individual for any diseases that are visible to the scanner, and displays the diseases in the attacked to the attacker.
/proc/diseasescan(mob/user, mob/living/carbon/patient, obj/item/healthanalyzer/simple/scanner)
	if(!istype(patient) || user.incapacitated())
		return

	var/list/render = list()
	for(var/datum/disease/disease as anything in patient.diseases)
		if(!(disease.visibility_flags & HIDDEN_SCANNER))
			render += "<span class='alert ml-1'><b>Warning: [disease.form] detected</b>\n\
			<div class='ml-2'>Name: [disease.name].\nType: [disease.spread_text].\nStage: [disease.stage]/[disease.max_stages].\nPossible Cure: [disease.cure_text]</div>\
			</span>"

	if(!length(render))
		playsound(scanner, 'sound/machines/ping.ogg', 50, FALSE)
		to_chat(user, span_notice("\The [scanner] makes a happy ping and briefly displays a smiley face with several exclamation points! It's really excited to report that [patient] has no diseases!"))
		scanner.emotion = AID_EMOTION_HAPPY
	else
		to_chat(user, span_notice(render.Join("")))
		scanner.emotion = AID_EMOTION_WARN
		playsound(scanner, 'sound/machines/twobeep.ogg', 50, FALSE)

#undef SCANMODE_HEALTH
#undef SCANMODE_WOUND
#undef SCANMODE_COUNT

#undef AID_EMOTION_NEUTRAL
#undef AID_EMOTION_HAPPY
#undef AID_EMOTION_WARN
#undef AID_EMOTION_ANGRY
#undef AID_EMOTION_SAD
