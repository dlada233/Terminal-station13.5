//The Medical Kiosk is designed to act as a low access alernative to  a medical analyzer, and doesn't require breaking into medical. Self Diagnose at your heart's content!
//For a fee that is. Comes in 4 flavors of medical scan.

/// Shows if the machine is being used for a general scan.
#define KIOSK_SCANNING_GENERAL (1<<0)
/// Shows if the machine is being used for a disease scan.
#define KIOSK_SCANNING_SYMPTOMS (1<<1)
/// Shows if the machine is being used for a radiation/brain trauma scan.
#define KIOSK_SCANNING_NEURORAD (1<<2)
/// Shows if the machine is being used for a reagent scan.
#define KIOSK_SCANNING_REAGENTS (1<<3)



/obj/machinery/medical_kiosk
	name = "诊断亭"
	desc = "独立运作的诊断亭，可以进行大多数情况下的医疗诊断."
	icon = 'icons/obj/machines/medical_kiosk.dmi'
	icon_state = "kiosk"
	base_icon_state = "kiosk"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/medical_kiosk
	payment_department = ACCOUNT_MED
	var/obj/item/scanner_wand
	/// How much it costs to use the kiosk by default.
	var/default_price = 15          //I'm defaulting to a low price on this, but in the future I wouldn't have an issue making it more or less expensive.
	/// How much it currently costs to use the kiosk.
	var/active_price = 15           //Change by using a multitool on the board.
	/// Makes the TGUI display gibberish and/or incorrect/erratic information.
	var/pandemonium = FALSE //AKA: Emag mode.

	/// Shows whether the kiosk is being used to scan someone and what it's being used for.
	var/scan_active = NONE

	/// Do we have someone paying to use this?
	var/paying_customer = FALSE //Ticked yes if passing inuse()

	/// Who's paying?
	var/datum/weakref/paying_ref //The person using the console in each instance. Used for paying for the kiosk.
	/// Who's getting scanned?
	var/datum/weakref/patient_ref //If scanning someone else, this will be the target.

/obj/machinery/medical_kiosk/Initialize(mapload) //loaded subtype for mapping use
	. = ..()
	AddComponent(/datum/component/payment, active_price, SSeconomy.get_dep_account(ACCOUNT_MED), PAYMENT_FRIENDLY)
	register_context()
	scanner_wand = new/obj/item/scanner_wand(src)

/obj/machinery/medical_kiosk/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	var/screentip_change = FALSE

	if(!held_item && scanner_wand)
		context[SCREENTIP_CONTEXT_RMB] = "拾取扫描棒"
		return screentip_change = TRUE

	if(istype(held_item) && held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = anchored ? "解除固定" : "固定"
		return screentip_change = TRUE
	if(istype(held_item) && held_item.tool_behaviour == TOOL_CROWBAR && panel_open)
		context[SCREENTIP_CONTEXT_LMB] = "拆解"
		return screentip_change = TRUE
	if(istype(held_item) && held_item.tool_behaviour == TOOL_SCREWDRIVER)
		context[SCREENTIP_CONTEXT_LMB] = panel_open ? "关上检修盖" : "打开检修盖"
		return screentip_change = TRUE
	if(istype(held_item, /obj/item/scanner_wand))
		context[SCREENTIP_CONTEXT_LMB] = "归还扫描棒"
		return screentip_change = TRUE

/obj/machinery/medical_kiosk/proc/inuse()  //Verifies that the user can use the interface, followed by showing medical information.
	var/mob/living/carbon/human/paying = paying_ref?.resolve()
	if(!paying)
		paying_ref = null
		return

	var/obj/item/card/id/card = paying.get_idcard(TRUE)
	if(card?.registered_account?.account_job?.paycheck_department == payment_department)
		use_energy(active_power_usage)
		paying_customer = TRUE
		say("您好，尊敬的医务人员!")
		RefreshParts()
		return
	var/bonus_fee = pandemonium ? rand(10,30) : 0
	if(attempt_charge(src, paying, bonus_fee) & COMPONENT_OBJ_CANCEL_CHARGE )
		return
	use_energy(active_power_usage)
	paying_customer = TRUE
	icon_state = "[base_icon_state]_active"
	say("感谢惠顾!")
	RefreshParts()
	return

/obj/machinery/medical_kiosk/proc/clearScans() //Called it enough times to be it's own proc
	scan_active = NONE
	update_appearance()
	return

/obj/machinery/medical_kiosk/update_icon_state()
	if(panel_open)
		icon_state = "[base_icon_state]_open"
		return ..()
	if(!is_operational)
		icon_state = "[base_icon_state]_off"
		return ..()
	icon_state = "[base_icon_state][scan_active ? "_active" : null]"
	return ..()

/obj/machinery/medical_kiosk/wrench_act(mob/living/user, obj/item/tool) //Allows for wrenching/unwrenching the machine.
	..()
	default_unfasten_wrench(user, tool, time = 0.1 SECONDS)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/medical_kiosk/RefreshParts()
	. = ..()
	var/obj/item/circuitboard/machine/medical_kiosk/board = circuit
	if(board)
		active_price = board.custom_cost
	return

/obj/machinery/medical_kiosk/attackby(obj/item/O, mob/user, params)
	if(default_deconstruction_screwdriver(user, "[base_icon_state]_open", "[base_icon_state]_off", O))
		return
	else if(default_deconstruction_crowbar(O))
		return

	if(istype(O, /obj/item/scanner_wand))
		var/obj/item/scanner_wand/W = O
		if(scanner_wand)
			balloon_alert(user, "已经有了一根扫描棒!")
			return
		if(HAS_TRAIT(O, TRAIT_NODROP) || !user.transferItemToLoc(O, src))
			balloon_alert(user, "粘在了你的手上!")
			return
		user.visible_message(span_notice("[user]将[O]扣到[src]上!"))
		balloon_alert(user, "扫描棒已归还")
		//This will be the scanner returning scanner_wand's selected_target variable and assigning it to the altPatient var
		if(W.selected_target)
			var/datum/weakref/target_ref = WEAKREF(W.return_patient())
			if(patient_ref != target_ref)
				clearScans()
			patient_ref = target_ref
			user.visible_message(span_notice("[W.return_patient()]已设置为当前患者."))
			W.selected_target = null
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		scanner_wand = O
		return
	return ..()

/obj/machinery/medical_kiosk/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!ishuman(user) || !user.can_perform_action(src))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!scanner_wand)
		balloon_alert(user, "无扫描棒!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!user.put_in_hands(scanner_wand))
		balloon_alert(user, "扫描棒掉落!")
		scanner_wand = null
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	user.visible_message(span_notice("[user]从[src]上取下[scanner_wand]."))
	balloon_alert(user, "扫描设备已拔出")
	playsound(src, 'sound/machines/click.ogg', 60, TRUE)
	scanner_wand = null
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/medical_kiosk/Destroy()
	qdel(scanner_wand)
	return ..()

/obj/machinery/medical_kiosk/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	if(user)
		if (emag_card)
			user.visible_message(span_warning("[user]在[src]的生物识别设备前挥动可疑的卡片!"))
		balloon_alert(user, "传感器已超驰")
	obj_flags |= EMAGGED
	var/obj/item/circuitboard/computer/cargo/board = circuit
	board.obj_flags |= EMAGGED //Mirrors emag status onto the board as well.
	pandemonium = TRUE
	return TRUE

/obj/machinery/medical_kiosk/examine(mob/user)
	. = ..()
	if(scanner_wand == null)
		. += span_notice("[src]缺少扫描设备.")
	else
		. += span_notice("[src]的扫描设备被扣在侧面，右键以取出.")

/obj/machinery/medical_kiosk/ui_interact(mob/user, datum/tgui/ui)
	var/patient_distance = 0
	if(!ishuman(user))
		to_chat(user, span_warning("[src]无法与非类人生物交互!"))
		if (ui)
			ui.close()
		return
	var/mob/living/carbon/human/patient = patient_ref?.resolve()
	patient_distance = get_dist(src.loc, patient)
	if(patient == null)
		say("扫描设备重置.")
		patient_ref = WEAKREF(user)
	else if(patient_distance>5)
		patient_ref = null
		say("患者超出范围，生物识别重置.")
		clearScans()
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MedicalKiosk", name)
		ui.open()
		icon_state = "[base_icon_state]_active"
		RefreshParts()
		var/mob/living/carbon/human/paying = user
		paying_ref = WEAKREF(paying)

/obj/machinery/medical_kiosk/ui_data(mob/living/carbon/human/user)
	var/mob/living/carbon/human/patient = patient_ref?.resolve()
	var/list/data = list()
	if(!patient)
		return
	var/patient_name = patient.name
	var/patient_status = "存活."
	var/max_health = patient.maxHealth
	var/total_health = patient.health
	var/brute_loss = patient.getBruteLoss()
	var/fire_loss = patient.getFireLoss()
	var/tox_loss = patient.getToxLoss()
	var/oxy_loss = patient.getOxyLoss()
	var/chaos_modifier = 0

	var/sickness = "患者没有表现出患病迹象."
	var/sickness_data = "不适用."

	var/bleed_status = "患者当前没有流血."
	var/blood_status = " 患者要么体内没有血液，要么不依靠血液维持生命."
	var/blood_percent = round((patient.blood_volume / BLOOD_VOLUME_NORMAL)*100)
	var/blood_type = patient.dna.blood_type
	var/blood_warning = " "
	var/blood_alcohol = patient.get_blood_alcohol_content()

	for(var/thing in patient.diseases) //Disease Information
		var/datum/disease/D = thing
		if(!(D.visibility_flags & HIDDEN_SCANNER))
			sickness = "警告: 患者患有某种形式的病毒疾病，请寻求进一步的医疗帮助."
			sickness_data = "\n名称: [D.name].\n类型: [D.spread_text].\n阶段: [D.stage]/[D.max_stages].\n可能的治疗手段: [D.cure_text]"

	if(!HAS_TRAIT(patient, TRAIT_GENELESS) && !HAS_TRAIT(patient, TRAIT_NOBLOOD)) //Blood levels Information
		if(patient.is_bleeding())
			bleed_status = "患者正在流血!"
		if(blood_percent <= 80)
			blood_warning = " 患者血含量处在低水平，建议大量进食或补充铁元素."
		if(blood_percent <= 60)
			blood_warning = " 患者血含量处在致命的极低水平. 建议立刻输血、补充铁元素或生理盐水注射, 忽视治疗可能导致死亡!"
		blood_status = "患者血含量当前为[blood_percent]%，[ blood_type]型血. [blood_warning]"

	var/trauma_status = "患者没有神经创伤."
	var/brain_loss = patient.get_organ_loss(ORGAN_SLOT_BRAIN)
	var/brain_status = "大脑模式正常."
	if(LAZYLEN(patient.get_traumas()))
		var/list/trauma_text = list()
		for(var/t in patient.get_traumas())
			var/datum/brain_trauma/trauma = t
			//SKYRAT EDIT: Scary Traits (Bimbo)
			if(!trauma.display_scanner)
				continue
			//SKYRAT EDIT: Scary Traits (Bimbo)
			var/trauma_desc = ""
			switch(trauma.resilience)
				if(TRAUMA_RESILIENCE_SURGERY)
					trauma_desc += "严重的 "
				if(TRAUMA_RESILIENCE_LOBOTOMY)
					trauma_desc += "根深蒂固的 "
				if(TRAUMA_RESILIENCE_MAGIC, TRAUMA_RESILIENCE_ABSOLUTE)
					trauma_desc += "永久性 "
			trauma_desc += trauma.scan_desc
			trauma_text += trauma_desc
		trauma_status = "检测到神经创伤，患者似乎患有[english_list(trauma_text)]."

	var/chemical_list = list()
	var/overdose_list = list()
	var/addict_list = list()
	var/hallucination_status = "患者没有产生幻觉."

	if(patient.reagents.reagent_list.len) //Chemical Analysis details.
		for(var/r in patient.reagents.reagent_list)
			var/datum/reagent/reagent = r
			if(reagent.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems
				continue
			chemical_list += list(list("name" = reagent.name, "volume" = round(reagent.volume, 0.01)))
			if(reagent.overdosed)
				overdose_list += list(list("name" = reagent.name))
	var/obj/item/organ/internal/stomach/belly = patient.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(belly?.reagents.reagent_list.len) //include the stomach contents if it exists
		for(var/bile in belly.reagents.reagent_list)
			var/datum/reagent/bit = bile
			if(bit.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems
				continue
			if(!belly.food_reagents[bit.type])
				chemical_list += list(list("name" = bit.name, "volume" = round(bit.volume, 0.01)))
			else
				var/bit_vol = bit.volume - belly.food_reagents[bit.type]
				if(bit_vol > 0)
					chemical_list += list(list("name" = bit.name, "volume" = round(bit_vol, 0.01)))
	for(var/datum/addiction/addiction_type as anything in patient.mind.active_addictions)
		addict_list += list(list("name" = initial(addiction_type.name)))

	if (patient.has_status_effect(/datum/status_effect/hallucination))
		hallucination_status = "患者脑内似乎产生幻觉，建议治疗方法: 卧床休息、服用Mannitol-甘露醇或Psicodine-定神素."

	if(patient.stat == DEAD || HAS_TRAIT(patient, TRAIT_FAKEDEATH) || ((brute_loss+fire_loss+tox_loss+oxy_loss) >= 200))  //Patient status checks.
		patient_status = "死亡."
	if((brute_loss+fire_loss+tox_loss+oxy_loss) >= 80)
		patient_status = "重伤"
	else if((brute_loss+fire_loss+tox_loss+oxy_loss) >= 40)
		patient_status = "受伤"
	else if((brute_loss+fire_loss+tox_loss+oxy_loss) >= 20)
		patient_status = "轻伤"
	if(pandemonium || user.has_status_effect(/datum/status_effect/hallucination))
		patient_status = pick(
			"手动呼吸.",
			"请联系NTOS管理员.",
			"97%碳, 3%天然香料",
			"潮起潮落让我们疲惫不堪.",
			"这是红斑狼疮，你得了红斑狼疮.",
			"有猴病.",
		)

	if((brain_loss) >= 100)   //Brain status checks.
		brain_status = "检测到极重脑损伤."
	else if((brain_loss) >= 50)
		brain_status = "检测到严重脑损伤."
	else if((brain_loss) >= 20)
		brain_status = "检测到脑损伤."
	else if((brain_loss) >= 1)
		brain_status = "检测到轻度脑损伤."  //You may have a miiiild case of severe brain damage.

	if(pandemonium)
		chaos_modifier = 1
	else if(user.has_status_effect(/datum/status_effect/hallucination))
		chaos_modifier = 0.3

	data["kiosk_cost"] = active_price + (chaos_modifier * (rand(1,25)))
	data["patient_name"] = patient_name
	data["patient_health"] = round(((total_health - (chaos_modifier * (rand(1,50)))) / max_health) * 100, 0.001)
	data["brute_health"] = round(brute_loss+(chaos_modifier * (rand(1,30))),0.001) //To break this down for easy reading, all health values are rounded to the .001 place
	data["burn_health"] = round(fire_loss+(chaos_modifier * (rand(1,30))),0.001) //then a random number is added, which is multiplied by chaos modifier.
	data["toxin_health"] = round(tox_loss+(chaos_modifier * (rand(1,30))),0.001) //That allows for a weaker version of the affect to be applied while hallucinating as opposed to emagged.
	data["suffocation_health"] = round(oxy_loss+(chaos_modifier * (rand(1,30))),0.001) //It's not the cleanest but it does make for a colorful window.
	data["brain_health"] = brain_status
	data["brain_damage"] = brain_loss+(chaos_modifier * (rand(1,30)))
	data["patient_status"] = patient_status
	data["trauma_status"] = trauma_status
	data["patient_illness"] = sickness
	data["illness_info"] = sickness_data
	data["bleed_status"] = bleed_status
	data["blood_levels"] = blood_percent - (chaos_modifier * (rand(1,35)))
	data["blood_status"] = blood_status
	data["blood_alcohol"] = blood_alcohol
	data["chemical_list"] = chemical_list
	data["overdose_list"] = overdose_list
	data["addict_list"] = addict_list
	data["hallucinating_status"] = hallucination_status

	data["active_status_1"] = scan_active & KIOSK_SCANNING_GENERAL // General Scan Check
	data["active_status_2"] = scan_active & KIOSK_SCANNING_SYMPTOMS // Symptom Scan Check
	data["active_status_3"] = scan_active & KIOSK_SCANNING_NEURORAD // Radio-Neuro Scan Check
	data["active_status_4"] = scan_active & KIOSK_SCANNING_REAGENTS // Reagents/hallucination Scan Check
	return data

/obj/machinery/medical_kiosk/ui_act(action,active)
	. = ..()
	if(.)
		return

	switch(action)
		if("beginScan_1")
			if(!(scan_active & KIOSK_SCANNING_GENERAL))
				inuse()
			if(paying_customer == TRUE)
				scan_active |= KIOSK_SCANNING_GENERAL
				paying_customer = FALSE
		if("beginScan_2")
			if(!(scan_active & KIOSK_SCANNING_SYMPTOMS))
				inuse()
			if(paying_customer == TRUE)
				scan_active |= KIOSK_SCANNING_SYMPTOMS
				paying_customer = FALSE
		if("beginScan_3")
			if(!(scan_active & KIOSK_SCANNING_NEURORAD))
				inuse()
			if(paying_customer == TRUE)
				scan_active |= KIOSK_SCANNING_NEURORAD
				paying_customer = FALSE
		if("beginScan_4")
			if(!(scan_active & KIOSK_SCANNING_REAGENTS))
				inuse()
			if(paying_customer == TRUE)
				scan_active |= KIOSK_SCANNING_REAGENTS
				paying_customer = FALSE
		if("clearTarget")
			patient_ref = null
			clearScans()
			. = TRUE


#undef KIOSK_SCANNING_GENERAL
#undef KIOSK_SCANNING_NEURORAD
#undef KIOSK_SCANNING_REAGENTS
#undef KIOSK_SCANNING_SYMPTOMS
