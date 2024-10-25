/// how long it takes to infuse
#define INFUSING_TIME 4 SECONDS
/// we throw in a scream along the way.
#define SCREAM_TIME 3 SECONDS

/obj/machinery/dna_infuser
	name = "\improper DNA注入机"
	desc = "一种将外部DNA与融合对象自身DNA融合的遗传学机器."
	icon = 'icons/obj/machines/cloning.dmi'
	icon_state = "infuser"
	base_icon_state = "infuser"
	density = TRUE
	obj_flags = BLOCKS_CONSTRUCTION // Becomes undense when the door is open
	interaction_flags_mouse_drop = NEED_HANDS | NEED_DEXTERITY
	circuit = /obj/item/circuitboard/machine/dna_infuser

	/// maximum tier this will infuse
	var/max_tier_allowed = DNA_MUTANT_TIER_ONE
	///currently infusing a vict- subject
	var/infusing = FALSE
	///what we're infusing with
	var/atom/movable/infusing_from
	///what we're turning into
	var/datum/infuser_entry/infusing_into
	///a message for relaying that the machine is locked if someone tries to leave while it's active
	COOLDOWN_DECLARE(message_cooldown)

/obj/machinery/dna_infuser/Initialize(mapload)
	. = ..()
	occupant_typecache = typecacheof(/mob/living/carbon/human)

/obj/machinery/dna_infuser/Destroy()
	. = ..()
	//dump_inventory_contents called by parent, emptying infusing_from
	infusing_into = null

/obj/machinery/dna_infuser/examine(mob/user)
	. = ..()
	if(!occupant)
		. += span_notice("需要[span_bold("注入对象")].")
	else
		. += span_notice("\"[span_bold(occupant.name)]\"在注入舱里.")
	if(!infusing_from)
		. += span_notice("缺少[span_bold("外部DNA源")].")
	else
		. += span_notice("[span_bold(infusing_from.name)]在注入舱内.")
	. += span_notice("操作说明: 获取死亡的生物，根据尺寸放入注入舱内.")
	. += span_notice("融合对象进入舱内，然后外面有人启动机器，你的一个器官就有了改变!")
	. += span_notice("Alt加左键可以弹出外部DNA源.")
	if(max_tier_allowed < DNA_INFUSER_MAX_TIER)
		. += span_boldnotice("现在, 融合对象只能注入等级[max_tier_allowed]的类型.")
	else
		. += span_boldnotice("最大等级被解锁了，所有注入类型都可以使用了.")
	. += span_notice("进一步检查以获得更多信息.")

/obj/machinery/dna_infuser/examine_more(mob/user)
	. = ..()
	. += span_notice("如果你注入等级[DNA_MUTANT_TIER_ONE]类型直到解锁奖励, 它将升级到最高等级并允许更复杂的注入.")
	. += span_notice("能达到的最高等级为[DNA_INFUSER_MAX_TIER].")

/obj/machinery/dna_infuser/interact(mob/user)
	if(user == occupant)
		toggle_open(user)
		return
	if(infusing)
		balloon_alert(user, "开着的时候不行!")
		return
	if(occupant && infusing_from)
		if(!occupant.can_infuse(user))
			playsound(src, 'sound/machines/scanbuzz.ogg', 35, vary = TRUE)
			return
		balloon_alert(user, "开始DNA注入...")
		start_infuse()
		return
	toggle_open(user)

/obj/machinery/dna_infuser/proc/start_infuse()
	var/mob/living/carbon/human/human_occupant = occupant
	infusing = TRUE
	visible_message(span_notice("[src]嗡嗡作响, 开始了注入过程!"))

	infusing_into = infusing_from.get_infusion_entry()
	var/fail_title = ""
	var/fail_explanation = ""
	if(istype(infusing_into, /datum/infuser_entry/fly))
		fail_title = "未知DNA"
		fail_explanation = "未知DNA. 请参阅 \"DNA注入手册\"."
	if(infusing_into.tier > max_tier_allowed)
		infusing_into = GLOB.infuser_entries[/datum/infuser_entry/fly]
		fail_title = "过于复杂"
		fail_explanation = "DNA太过复杂，机器需要先注入简单DNA."
	playsound(src, 'sound/machines/blender.ogg', 50, vary = TRUE)
	to_chat(human_occupant, span_danger("小针头反复刺你!"))
	human_occupant.take_overall_damage(10)
	human_occupant.add_mob_memory(/datum/memory/dna_infusion, protagonist = human_occupant, deuteragonist = infusing_from, mutantlike = infusing_into.infusion_desc)
	Shake(duration = INFUSING_TIME)
	addtimer(CALLBACK(human_occupant, TYPE_PROC_REF(/mob, emote), "scream"), INFUSING_TIME - 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(end_infuse), fail_explanation, fail_title), INFUSING_TIME)
	update_appearance()

/obj/machinery/dna_infuser/proc/end_infuse(fail_explanation, fail_title)
	var/mob/living/carbon/human/human_occupant = occupant
	if(human_occupant.infuse_organ(infusing_into))
		check_tier_progression(human_occupant)
		to_chat(occupant, span_danger("你感觉自己变得越来越... [infusing_into.infusion_desc]?"))
	infusing = FALSE
	infusing_into = null
	QDEL_NULL(infusing_from)
	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, vary = FALSE)
	if(fail_explanation)
		playsound(src, 'sound/machines/printer.ogg', 100, TRUE)
		visible_message(span_notice("[src]打印错误报告."))
		var/obj/item/paper/printed_paper = new /obj/item/paper(loc)
		printed_paper.name = "错误报告 - '[fail_title]'"
		printed_paper.add_raw_text(fail_explanation)
		printed_paper.update_appearance()
	toggle_open()
	update_appearance()

/// checks to see if the machine should progress a new tier.
/obj/machinery/dna_infuser/proc/check_tier_progression(mob/living/carbon/human/target)
	if(
		max_tier_allowed != DNA_INFUSER_MAX_TIER \
		&& infusing_into.tier == max_tier_allowed \
		&& target.has_status_effect(infusing_into.status_effect_type) \
	)
		max_tier_allowed++
		playsound(src, 'sound/machines/ding.ogg', 50, TRUE)
		visible_message(span_notice("[src]记录了完全注入的结果."))

/obj/machinery/dna_infuser/update_icon_state()
	//out of order
	if(machine_stat & (NOPOWER | BROKEN))
		icon_state = base_icon_state
		return ..()
	//maintenance
	if((machine_stat & MAINT) || panel_open)
		icon_state = "[base_icon_state]_panel"
		return ..()
	//actively running
	if(infusing)
		icon_state = "[base_icon_state]_on"
		return ..()
	//open or not
	icon_state = "[base_icon_state][state_open ? "_open" : null]"
	return ..()

/obj/machinery/dna_infuser/proc/toggle_open(mob/user)
	if(panel_open)
		if(user)
			balloon_alert(user, "先关上盖!")
		return
	if(state_open)
		close_machine()
		return
	else if(infusing)
		if(user)
			balloon_alert(user, "开着的时候不行!")
		return
	open_machine(drop = FALSE)
	//we set drop to false to manually call it with an allowlist
	dump_inventory_contents(list(occupant))

/obj/machinery/dna_infuser/attackby(obj/item/used, mob/user, params)
	if(infusing)
		return
	if(!occupant && default_deconstruction_screwdriver(user, icon_state, icon_state, used))//sent icon_state is irrelevant...
		update_appearance()//..since we're updating the icon here, since the scanner can be unpowered when opened/closed
		return
	if(default_pry_open(used))
		return
	if(default_deconstruction_crowbar(used))
		return
	if(ismovable(used))
		add_infusion_item(used, user)
	return ..()

/obj/machinery/dna_infuser/relaymove(mob/living/user, direction)
	if(user.stat)
		if(COOLDOWN_FINISHED(src, message_cooldown))
			COOLDOWN_START(src, message_cooldown, 4 SECONDS)
			to_chat(user, span_warning("[src]的门纹丝不动!"))
		return
	if(infusing)
		if(COOLDOWN_FINISHED(src, message_cooldown))
			COOLDOWN_START(src, message_cooldown, 4 SECONDS)
			to_chat(user, span_danger("[src]的门纹丝不动，针头尚在注射!"))
		return
	open_machine(drop = FALSE)
	//we set drop to false to manually call it with an allowlist
	dump_inventory_contents(list(occupant))

// mostly good for dead mobs that turn into items like dead mice (smack to add).
/obj/machinery/dna_infuser/proc/add_infusion_item(obj/item/target, mob/user)
	// if the machine already has a infusion target, or the target is not valid then no adding.
	if(!is_valid_infusion(target, user))
		return
	if(!user.transferItemToLoc(target, src))
		to_chat(user, span_warning("[target] is 粘在了你的手上!"))
		return
	infusing_from = target

// mostly good for dead mobs like corpses (drag to add).
/obj/machinery/dna_infuser/mouse_drop_receive(atom/target, mob/user, params)
	// if the machine is closed, already has a infusion target, or the target is not valid then no mouse drop.
	if(!is_valid_infusion(target, user))
		return
	infusing_from = target
	infusing_from.forceMove(src)

/// Verify that the given infusion source/mob is a dead creature.
/obj/machinery/dna_infuser/proc/is_valid_infusion(atom/movable/target, mob/user)
	var/datum/component/edible/food_comp = IS_EDIBLE(target)
	if(infusing_from)
		balloon_alert(user, "清空机器先!")
		return FALSE
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.stat != DEAD)
			balloon_alert(user, "仅限死亡生物!")
			return FALSE
	else if(food_comp)
		if(!(food_comp.foodtypes & GORE))
			balloon_alert(user, "仅限生物!")
			return FALSE
	else
		return FALSE
	return TRUE

/obj/machinery/dna_infuser/click_alt(mob/user)
	if(infusing)
		balloon_alert(user, "开着的时候不行!")
		return
	if(!infusing_from)
		balloon_alert(user, "无样本可弹出!")
		return
	balloon_alert(user, "已弹出样本")
	infusing_from.forceMove(get_turf(src))
	infusing_from = null
	return CLICK_ACTION_SUCCESS

#undef INFUSING_TIME
#undef SCREAM_TIME
