/obj/item/autopsy_scanner
	name = "解剖扫描仪"
	desc = "用于在一场解剖中从尸体中提取信息，也可以像高级健康分析仪那样扫描尸体的伤情!"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "autopsy_scanner"
	inhand_icon_state = "autopsy_scanner"
	worn_icon_state = "autopsy_scanner"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*2)
	custom_price = PAYCHECK_COMMAND

/obj/item/autopsy_scanner/interact_with_atom(atom/interacting_with, mob/living/user)
	if(!isliving(interacting_with))
		return NONE
	if(!user.can_read(src) || user.is_blind())
		return ITEM_INTERACT_BLOCKING

	var/mob/living/M = interacting_with

	if(M.stat != DEAD && !HAS_TRAIT(M, TRAIT_FAKEDEATH)) // good job, you found a loophole
		to_chat(user, span_deadsay("[icon2html(src, user)] ERROR!不可扫描活体,请购买健康分析仪或使对象成为尸体."))
		return ITEM_INTERACT_BLOCKING

	. = ITEM_INTERACT_SUCCESS

	// Clumsiness/brain damage check
	if ((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))
		user.visible_message(span_warning("[user] analyzes the floor's vitals!"), \
							span_notice("You stupidly try to analyze the floor's vitals!"))
		to_chat(user, "[span_info("Analyzing results for The floor:\n\tOverall status: <b>Healthy</b>")]\
				\n[span_info("Key: <font color='#00cccc'>Suffocation</font>/<font color='#00cc66'>Toxin</font>/<font color='#ffcc33'>Burn</font>/<font color='#ff3333'>Brute</font>")]\
				\n[span_info("\tDamage specifics: <font color='#66cccc'>0</font>-<font color='#00cc66'>0</font>-<font color='#ff9933'>0</font>-<font color='#ff3333'>0</font>")]\
				\n[span_info("Body temperature: ???")]")
		return

	user.visible_message(span_notice("[user] scans [M]'s cadaver."))
	to_chat(user, span_deadsay("[icon2html(src, user)] ANALYZING CADAVER."))

	healthscan(user, M, advanced = TRUE)

	add_fingerprint(user)

/obj/item/autopsy_scanner/proc/scan_cadaver(mob/living/carbon/human/user, mob/living/carbon/scanned)
	if(scanned.stat != DEAD)
		return

	var/list/autopsy_information = list()
	autopsy_information += "[scanned.name] - 种族: [scanned.dna.species.name]"
	autopsy_information += "死亡时间 - [scanned.station_timestamp_timeofdeath]"
	autopsy_information += "尸检时间 - [station_time_timestamp()]"
	autopsy_information += "验尸官 - [user.name]"

	autopsy_information += "毒素伤: [CEILING(scanned.getToxLoss(), 1)]"
	autopsy_information += "窒息伤: [CEILING(scanned.getOxyLoss(), 1)]"

	autopsy_information += "<center>部位数据</center><br>"
	for(var/obj/item/bodypart/bodyparts as anything in scanned.bodyparts)
		autopsy_information += "<b>[bodyparts.name]</b><br>"
		autopsy_information += "创伤: [bodyparts.brute_dam] | 烧伤: [bodyparts.burn_dam]<br>"
		if(!bodyparts.wounds)
			continue
		autopsy_information += "重伤信息:<br>"
		for(var/datum/wound/wounds as anything in bodyparts.wounds)
			if(wounds.wound_source)
				autopsy_information += "<b>[wounds.name]</b> - 归因于 <i>[wounds.wound_source]</i><br>"

	autopsy_information += "<center>器官数据</center>"
	for(var/obj/item/organ/organs as anything in scanned.organs)
		autopsy_information += "[organs.name]: <b>[CEILING(organs.damage, 1)] 损伤</b><br>"

	autopsy_information += "<center>化学数据</center>"
	for(var/datum/reagent/scanned_reagents as anything in scanned.reagents.reagent_list)
		if(scanned_reagents.chemical_flags & REAGENT_INVISIBLE)
			continue
		autopsy_information += "<b>[round(scanned_reagents.volume, 0.1)] unit\s of [scanned_reagents.name]</b><br>"
		autopsy_information += "化学信息: <i>[scanned_reagents.description]</i><br>"

	autopsy_information += "<center>血液数据</center>"
	if(HAS_TRAIT(scanned, TRAIT_HUSK))
		autopsy_information += "未发现血液成分, 受害者遭到剥皮放血: "
		if(HAS_TRAIT_FROM(scanned, TRAIT_HUSK, BURN))
			autopsy_information += "重度烧伤.</br>"
		else if (HAS_TRAIT_FROM(scanned, TRAIT_HUSK, CHANGELING_DRAIN))
			autopsy_information += "干裂,常由化形引起.</br>"
		else
			autopsy_information += "未知成因.</br>"
	else
		var/blood_id = scanned.get_blood_id()
		if(blood_id)
			var/blood_percent = round((scanned.blood_volume / BLOOD_VOLUME_NORMAL) * 100)
			var/blood_type = scanned.dna.blood_type
			if(blood_id != /datum/reagent/blood)
				var/datum/reagent/reagents = GLOB.chemical_reagents_list[blood_id]
				blood_type = reagents ? reagents.name : blood_id
			autopsy_information += "血型: [blood_type]<br>"
			autopsy_information += "血容量: [scanned.blood_volume] cl ([blood_percent]%) <br>"

	for(var/datum/disease/diseases as anything in scanned.diseases)
		autopsy_information += "名称: [diseases.name] | 类型: [diseases.spread_text]<br>"
		if(!istype(diseases, /datum/disease/advance))
			continue
		autopsy_information += "<b>症状:</b><br>"
		var/datum/disease/advance/advanced_disease = diseases
		for(var/datum/symptom/symptom as anything in advanced_disease.symptoms)
			autopsy_information += "[symptom.name] - [symptom.desc]<br>"

	var/obj/item/paper/autopsy_report = new(user.loc)
	autopsy_report.name = "尸检报告 ([scanned.name])"
	autopsy_report.add_raw_text(autopsy_information.Join("\n"))
	autopsy_report.update_appearance(UPDATE_ICON)
	user.put_in_hands(autopsy_report)
	user.balloon_alert(user, "报告已打印")
	return TRUE
