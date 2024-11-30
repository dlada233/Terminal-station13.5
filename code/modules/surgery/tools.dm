/obj/item/retractor
	name = "牵开器"
	desc = "用于牵开物体."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "retractor"
	inhand_icon_state = "retractor"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 1.5)
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	tool_behaviour = TOOL_RETRACTOR
	toolspeed = 1
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "retractor_normal"

/obj/item/retractor/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/retractor/augment
	desc = "微机械操作器，用于牵开物体."
	toolspeed = 0.5

/obj/item/retractor/cyborg
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "toolkit_medborg_retractor"

/obj/item/hemostat
	name = "止血钳"
	desc = "你觉得你之前见过这个."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "hemostat"
	inhand_icon_state = "hemostat"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT*1.25)
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("夹击", "夹紧")
	attack_verb_simple = list("夹击", "夹紧")
	tool_behaviour = TOOL_HEMOSTAT
	toolspeed = 1
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "hemostat_normal"

/obj/item/hemostat/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/hemostat/augment
	desc = "微型伺服器驱动一对钳子以止血."
	toolspeed = 0.5

/obj/item/hemostat/cyborg
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "toolkit_medborg_hemostat"

/obj/item/cautery
	name = "缝合器"
	desc = "这个用于止血."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "cautery"
	inhand_icon_state = "cautery"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/glass = SMALL_MATERIAL_AMOUNT*7.5)
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("灼烧")
	attack_verb_simple = list("灼烧")
	tool_behaviour = TOOL_CAUTERY
	toolspeed = 1
	heat = 500
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "cautery_normal"

/obj/item/cautery/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/cautery/ignition_effect(atom/ignitable_atom, mob/user)
	. = span_notice("[user]将[src]的末端触碰到[ignitable_atom]，伴随着一缕烟雾将其点燃。")

/obj/item/cautery/augment
	desc = "加热元件，用于烧灼伤口."
	toolspeed = 0.5

/obj/item/cautery/cyborg
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "toolkit_medborg_cautery"

/obj/item/cautery/advanced
	name = "高级缝合器"
	desc = "它投射出用于医疗应用的高功率激光."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "e_cautery"
	inhand_icon_state = "e_cautery"
	surgical_tray_overlay = "cautery_advanced"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/plasma =SHEET_MATERIAL_AMOUNT, /datum/material/uranium = SHEET_MATERIAL_AMOUNT*1.5, /datum/material/titanium = SHEET_MATERIAL_AMOUNT*1.5)
	hitsound = 'sound/items/welder.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7
	light_system = OVERLAY_LIGHT
	light_range = 1.5
	light_power = 0.4
	light_color = COLOR_SOFT_RED

/obj/item/cautery/advanced/get_all_tool_behaviours()
	return list(TOOL_CAUTERY, TOOL_DRILL)

/obj/item/cautery/advanced/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between drill and cautery and gives feedback to the user.
 */
/obj/item/cautery/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		tool_behaviour = TOOL_DRILL
		set_light_color(LIGHT_COLOR_BLUE)
	else
		tool_behaviour = TOOL_CAUTERY
		set_light_color(LIGHT_COLOR_ORANGE)

	balloon_alert(user, "聚焦透镜设置为[active ? "钻孔" : "修补"]模式")
	playsound(user ? user : src, 'sound/weapons/tap.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/cautery/advanced/examine()
	. = ..()
	. += span_notice("它当前设置为[tool_behaviour == TOOL_CAUTERY ? "修补" : "钻孔"]模式.")

/obj/item/surgicaldrill
	name = "外科电钻"
	desc = "你可以使用这个物品进行钻孔作业，洞了没?"
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "drill"
	inhand_icon_state = "drill"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	hitsound = 'sound/weapons/circsawhit.ogg'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/glass = SHEET_MATERIAL_AMOUNT*3)
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = SURGICAL_TOOL
	force = 15
	demolition_mod = 0.5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("钻孔")
	attack_verb_simple = list("钻孔")
	tool_behaviour = TOOL_DRILL
	toolspeed = 1
	sharpness = SHARP_POINTY
	wound_bonus = 10
	bare_wound_bonus = 10
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "drill_normal"

/obj/item/surgicaldrill/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/eyestab)

/obj/item/surgicaldrill/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/surgicaldrill/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]用[src]狠狠地撞向自己胸口! 看起来是在尝试自杀!"))
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon, gib), null, null, TRUE, TRUE), 2.5 SECONDS)
	user.SpinAnimation(3, 10)
	playsound(user, 'sound/machines/juicer.ogg', 20, TRUE)
	return MANUAL_SUICIDE

/obj/item/surgicaldrill/cyborg
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "toolkit_medborg_drill"

/obj/item/surgicaldrill/augment
	desc = "实际上是你手臂内的小型电钻，可能会，也可能不会穿透天际."
	hitsound = 'sound/weapons/circsawhit.ogg'
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5

/obj/item/scalpel
	name = "手术刀"
	desc = "切啊切啊，然后继续切啊."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "scalpel"
	inhand_icon_state = "scalpel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = SURGICAL_TOOL
	force = 10
	demolition_mod = 0.25
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	attack_verb_continuous = list("攻击", "切割", "刺", "划", "撕扯", "割裂")
	attack_verb_simple = list("攻击", "切割", "刺", "划", "撕扯", "割裂")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SCALPEL
	toolspeed = 1
	wound_bonus = 10
	bare_wound_bonus = 15
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "scalpel_normal"

/obj/item/scalpel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 8 SECONDS * toolspeed, \
	effectiveness = 100, \
	bonus_modifier = 0, \
	)
	AddElement(/datum/element/eyestab)

/obj/item/scalpel/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/scalpel/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]在用[src]割自己的[pick("手腕", "喉咙", "腹部")]! 看起来是在尝试自杀!"))
	return BRUTELOSS

/obj/item/scalpel/cyborg
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "toolkit_medborg_scalpel"

/obj/item/scalpel/augment
	desc = "超锋利刀片直接连接至骨骼以提供超高精确度."
	toolspeed = 0.5

/obj/item/circular_saw
	name = "圆锯"
	desc = "用于重型切割."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "saw"
	inhand_icon_state = "saw"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	hitsound = 'sound/weapons/circsawhit.ogg'
	mob_throw_hit_sound = 'sound/weapons/pierce.ogg'
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = SURGICAL_TOOL
	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 9
	throw_speed = 2
	throw_range = 5
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/glass = SHEET_MATERIAL_AMOUNT*3)
	attack_verb_continuous = list("攻击","切割","锯","锯割")
	attack_verb_simple = list("攻击","切割","锯","锯割")
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SAW
	toolspeed = 1
	wound_bonus = 15
	bare_wound_bonus = 10
	/// How this looks when placed in a surgical tray
	var/surgical_tray_overlay = "saw_normal"

/obj/item/circular_saw/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 4 SECONDS * toolspeed, \
	effectiveness = 100, \
	bonus_modifier = 5, \
	butcher_sound = 'sound/weapons/circsawhit.ogg', \
	)
	//saws are very accurate and fast at butchering
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/chainsaw)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/circular_saw/get_surgery_tool_overlay(tray_extended)
	return surgical_tray_overlay

/obj/item/circular_saw/cyborg
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "toolkit_medborg_saw"

/obj/item/circular_saw/augment
	desc = "小型但旋转速度极快的锯，它会一直撕扯切割直到完成."
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5


/obj/item/surgical_drapes
	name = "手术布"
	desc = "纳米传讯品牌手术布提供最佳的安全性和感染防护."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "surgical_drapes"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "drapes"
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("slaps")
	attack_verb_simple = list("slap")
	interaction_flags_atom = parent_type::interaction_flags_atom | INTERACT_ATOM_IGNORE_MOBILITY

/obj/item/surgical_drapes/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/surgery_initiator)

/obj/item/surgical_drapes/cyborg
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "toolkit_medborg_surgicaldrapes"

/obj/item/surgical_processor //allows medical cyborgs to scan and initiate advanced surgeries
	name = "手术处理器"
	desc = "用于从磁盘或操作计算机扫描和启动手术的设备."
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "surgical_processor"
	item_flags = NOBLUDGEON
	// List of surgeries downloaded into the device.
	var/list/loaded_surgeries = list()
	// If a surgery has been downloaded in. Will cause the display to have a noticeable effect - helps to realize you forgot to load anything in.
	var/downloaded = TRUE

/obj/item/surgical_processor/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/surgery_initiator)

/obj/item/surgical_processor/examine(mob/user)
	. = ..()
	. += span_notice("将处理器安装到你的一个激活模块中以访问已下载的高级手术.")
	. += span_boldnotice("可用的高级手术:")
	//list of downloaded surgeries' names
	var/list/surgeries_names = list()
	for(var/datum/surgery/downloaded_surgery as anything in loaded_surgeries)
		if(initial(downloaded_surgery.replaced_by) in loaded_surgeries) //if a surgery has a better version replacing it, we don't include it in the list
			continue
		surgeries_names += "[initial(downloaded_surgery.name)]"
	. += span_notice("[english_list(surgeries_names)]")

/obj/item/surgical_processor/equipped(mob/user, slot, initial)
	. = ..()
	if(!(slot & ITEM_SLOT_HANDS))
		UnregisterSignal(user, COMSIG_SURGERY_STARTING)
		return
	RegisterSignal(user, COMSIG_SURGERY_STARTING, PROC_REF(check_surgery))

/obj/item/surgical_processor/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_SURGERY_STARTING)

/obj/item/surgical_processor/cyborg_unequip(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_SURGERY_STARTING)

/obj/item/surgical_processor/interact_with_atom(atom/design_holder, mob/living/user, list/modifiers)
	if(!istype(design_holder, /obj/item/disk/surgery) && !istype(design_holder, /obj/machinery/computer/operating))
		return NONE
	balloon_alert(user, "复制设计中...")
	playsound(src, 'sound/machines/terminal_processing.ogg', 25, TRUE)
	if(do_after(user, 1 SECONDS, target = design_holder))
		if(istype(design_holder, /obj/item/disk/surgery))
			var/obj/item/disk/surgery/surgery_disk = design_holder
			loaded_surgeries |= surgery_disk.surgeries
		else
			var/obj/machinery/computer/operating/surgery_computer = design_holder
			loaded_surgeries |= surgery_computer.advanced_surgeries
		playsound(src, 'sound/machines/terminal_success.ogg', 25, TRUE)
		downloaded = TRUE
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/item/surgical_processor/update_overlays()
	. = ..()
	if(downloaded)
		. += mutable_appearance(src.icon, "+downloaded")

/obj/item/surgical_processor/proc/check_surgery(mob/user, datum/surgery/surgery, mob/patient)
	SIGNAL_HANDLER

	if(surgery.replaced_by in loaded_surgeries)
		return COMPONENT_CANCEL_SURGERY
	if(surgery.type in loaded_surgeries)
		return COMPONENT_FORCE_SURGERY

/obj/item/scalpel/advanced
	name = "激光手术刀"
	desc = "使用激光技术切割的高级手术刀."
	icon_state = "e_scalpel"
	inhand_icon_state = "e_scalpel"
	surgical_tray_overlay = "scalpel_advanced"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/diamond =SMALL_MATERIAL_AMOUNT * 2, /datum/material/titanium = SHEET_MATERIAL_AMOUNT*2)
	hitsound = 'sound/weapons/blade1.ogg'
	force = 16
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7
	light_system = OVERLAY_LIGHT
	light_range = 1.5
	light_power = 0.4
	light_color = LIGHT_COLOR_BLUE
	sharpness = SHARP_EDGED

/obj/item/scalpel/advanced/get_all_tool_behaviours()
	return list(TOOL_SAW, TOOL_SCALPEL)

/obj/item/scalpel/advanced/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = force + 1, \
		throwforce_on = throwforce, \
		throw_speed_on = throw_speed, \
		sharpness_on = sharpness, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between saw and scalpel and updates the light / gives feedback to the user.
 */
/obj/item/scalpel/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		tool_behaviour = TOOL_SAW
		set_light_color(LIGHT_COLOR_ORANGE)
	else
		tool_behaviour = TOOL_SCALPEL
		set_light_color(LIGHT_COLOR_BLUE)

	balloon_alert(user, "[active ? "已启用" : "已禁用"] 锯骨模式")
	playsound(user ? user : src, 'sound/machines/click.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/scalpel/advanced/examine()
	. = ..()
	. += span_notice("它当前设置为[tool_behaviour == TOOL_SCALPEL ? "手术刀" : "锯骨"]模式.")

/obj/item/retractor/advanced
	name = "机械夹持器"
	desc = "杆和齿轮的组合体."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*6, /datum/material/glass = SHEET_MATERIAL_AMOUNT*2, /datum/material/silver = SHEET_MATERIAL_AMOUNT*2, /datum/material/titanium =SHEET_MATERIAL_AMOUNT * 2.5)
	icon_state = "adv_retractor"
	inhand_icon_state = "adv_retractor"
	surgical_tray_overlay = "retractor_advanced"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7

/obj/item/retractor/advanced/get_all_tool_behaviours()
	return list(TOOL_HEMOSTAT, TOOL_RETRACTOR)

/obj/item/retractor/advanced/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between retractor and hemostat and gives feedback to the user.
 */
/obj/item/retractor/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_HEMOSTAT : TOOL_RETRACTOR)
	balloon_alert(user, "装备设定为[active ? "夹具" : "牵开"]模式")
	playsound(user ? user : src, 'sound/items/change_drill.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/retractor/advanced/examine()
	. = ..()
	. += span_notice("它可以用作[tool_behaviour == TOOL_RETRACTOR ? "牵开器" : "止血钳"].")

/obj/item/shears
	name = "截肢剪"
	desc = "一种重型外科剪，用于实现肢体与患者的干净分离，保持患者静止对于固定和对齐剪刀至关重要."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "shears"
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = SURGICAL_TOOL
	toolspeed = 1
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 6
	throw_speed = 2
	throw_range = 5
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*4, /datum/material/titanium=SHEET_MATERIAL_AMOUNT*3)
	attack_verb_continuous = list("剪","剪切")
	attack_verb_simple = list("剪","剪切")
	sharpness = SHARP_EDGED
	custom_premium_price = PAYCHECK_CREW * 14

/obj/item/shears/attack(mob/living/amputee, mob/living/user)
	if(!iscarbon(amputee) || user.combat_mode)
		return ..()

	if(user.zone_selected == BODY_ZONE_CHEST)
		return ..()

	var/mob/living/carbon/patient = amputee

	if(HAS_TRAIT(patient, TRAIT_NODISMEMBER))
		to_chat(user, span_warning("病人的四肢看起来太结实，无法截肢。"))
		return

	var/candidate_name
	var/obj/item/organ/external/tail_snip_candidate
	var/obj/item/bodypart/limb_snip_candidate

	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN)
		tail_snip_candidate = patient.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
		if(!tail_snip_candidate)
			to_chat(user, span_warning("[patient]没有尾巴."))
			return
		candidate_name = tail_snip_candidate.name

	else
		limb_snip_candidate = patient.get_bodypart(check_zone(user.zone_selected))
		if(!limb_snip_candidate)
			to_chat(user, span_warning("[patient]已经缺失那条肢体了，你还想怎样？"))
			return
		candidate_name = limb_snip_candidate.name

	var/amputation_speed_mod = 1

	patient.visible_message(span_danger("[user]开始用[src]固定住[patient]的[candidate_name]."), span_userdanger("[user]开始用[src]固定住你的[candidate_name]!"))
	playsound(get_turf(patient), 'sound/items/ratchet.ogg', 20, TRUE)
	if(patient.stat >= UNCONSCIOUS || HAS_TRAIT(patient, TRAIT_INCAPACITATED)) //if you're incapacitated (due to paralysis, a stun, being in staminacrit, etc.), critted, unconscious, or dead, it's much easier to properly line up a snip
		amputation_speed_mod *= 0.5
	if(patient.stat != DEAD && patient.has_status_effect(/datum/status_effect/jitter)) //jittering will make it harder to secure the shears, even if you can't otherwise move
		amputation_speed_mod *= 1.5 //15*0.5*1.5=11.25, so staminacritting someone who's jittering (from, say, a stun baton) won't give you enough time to snip their head off, but staminacritting someone who isn't jittering will

	if(do_after(user,  toolspeed * 15 SECONDS * amputation_speed_mod, target = patient))
		playsound(get_turf(patient), 'sound/weapons/bladeslice.ogg', 250, TRUE)
		if(user.zone_selected == BODY_ZONE_PRECISE_GROIN) //OwO
			tail_snip_candidate.Remove(patient)
			tail_snip_candidate.forceMove(get_turf(patient))
		else
			limb_snip_candidate.dismember()
		user.visible_message(span_danger("[src]猛地合上，截断了[patient]的[candidate_name]."), span_notice("你用[src]截断了[patient]的[candidate_name]."))
		user.log_message("[user]用[src]截断了[patient]的[candidate_name]", LOG_GAME)
		patient.log_message("[patient]的[candidate_name]被[user]用[src]截断了", LOG_GAME)

	if(HAS_MIND_TRAIT(user, TRAIT_MORBID)) //Freak
		user.add_mood_event("morbid_dismemberment", /datum/mood_event/morbid_dismemberment)

/obj/item/shears/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]正用[src]夹住自己！看起来是在尝试自杀!"))
	var/timer = 1 SECONDS
	for(var/obj/item/bodypart/thing in user.bodyparts)
		if(thing.body_part == CHEST)
			continue
		addtimer(CALLBACK(thing, TYPE_PROC_REF(/obj/item/bodypart/, dismember)), timer)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), user, 'sound/weapons/bladeslice.ogg', 70), timer)
		timer += 1 SECONDS
	sleep(timer)
	return BRUTELOSS

/obj/item/bonesetter
	name = "接骨器"
	desc = "用于将事物恢复原状."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "bonesetter"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5,  /datum/material/glass = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/silver = SHEET_MATERIAL_AMOUNT*1.25)
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("矫正")
	attack_verb_simple = list("矫正")
	tool_behaviour = TOOL_BONESET
	toolspeed = 1

/obj/item/bonesetter/get_surgery_tool_overlay(tray_extended)
	return "bonesetter" + (tray_extended ? "" : "_out")

/obj/item/bonesetter/cyborg
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "toolkit_medborg_bonesetter"

/obj/item/blood_filter
	name = "血液过滤器"
	desc = "用于过滤血液."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "bloodfilter"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/glass=HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver=SMALL_MATERIAL_AMOUNT*5)
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("泵送", "吸取")
	attack_verb_simple = list("泵送", "吸取")
	tool_behaviour = TOOL_BLOODFILTER
	toolspeed = 1
	/// Assoc list of chem ids to names, used for deciding which chems to filter when used for surgery
	var/list/whitelist = list()

/obj/item/blood_filter/get_surgery_tool_overlay(tray_extended)
	return "filter"

/obj/item/blood_filter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BloodFilter", name)
		ui.open()

/obj/item/blood_filter/ui_data(mob/user)
	. = list()

	.["whitelist"] = list()
	for(var/key in whitelist)
		.["whitelist"] += whitelist[key]

/obj/item/blood_filter/ui_act(action, params)
	. = ..()
	if(.)
		return

	. = TRUE
	switch(action)
		if("add")
			var/selected_reagent = tgui_input_list(usr, "选择要过滤的试剂", "白名单试剂", GLOB.name2reagent)
			if(!selected_reagent)
				return FALSE

			var/datum/reagent/chem_id = GLOB.name2reagent[selected_reagent]
			if(!chem_id)
				return FALSE

			if(!(chem_id in whitelist))
				whitelist[chem_id] = selected_reagent

		if("remove")
			var/chem_name = params["reagent"]
			var/chem_id = get_chem_id(chem_name)
			whitelist -= chem_id

/*
 * Cruel Surgery Tools
 *
 * This variety of tool has the CRUEL_IMPLEMENT flag.
 *
 * Bonuses if the surgery is being done by a morbid user and it is of their interest.
 *
 * Morbid users are interested in; autospies, revival surgery, plastic surgery, organ/feature manipulations, amputations
 *
 * Otherwise, normal tool.
 */

/obj/item/retractor/cruel
	name = "扭曲牵开器"
	desc = "帮助揭露宁愿深埋的秘密."
	icon_state = "cruelretractor"
	surgical_tray_overlay = "retractor_cruel"
	item_flags = SURGICAL_TOOL | CRUEL_IMPLEMENT

/obj/item/hemostat/cruel
	name = "残酷止血钳"
	desc = "夹紧出血处，但对拯救生命不太擅长."
	icon_state = "cruelhemostat"
	surgical_tray_overlay = "hemostat_cruel"
	item_flags = SURGICAL_TOOL | CRUEL_IMPLEMENT

/obj/item/cautery/cruel
	name = "野蛮烧灼器"
	desc = "把这算作又一次成功的活体解剖."
	icon_state = "cruelcautery"
	surgical_tray_overlay = "cautery_cruel"
	item_flags = SURGICAL_TOOL | CRUEL_IMPLEMENT

/obj/item/scalpel/cruel
	name = "饥渴手术刀"
	desc = "我记得每次握住你。我天生的伴侣..."
	icon_state = "cruelscalpel"
	surgical_tray_overlay = "scalpel_cruel"
	item_flags = SURGICAL_TOOL | CRUEL_IMPLEMENT

/obj/item/scalpel/cruel/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bane, mob_biotypes = MOB_UNDEAD, damage_multiplier = 1) //Just in case one of the tennants get uppity
