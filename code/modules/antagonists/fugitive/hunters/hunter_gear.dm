//works similar to the experiment machine (experiment.dm) except it just holds more and more prisoners

/obj/machinery/fugitive_capture
	name = "蓝空捕获机"
	desc = "为了安全运送囚犯，里面比看起来要大的大的多."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "bluespace-prison"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF //ha ha no getting out!!

/obj/machinery/fugitive_capture/examine(mob/user)
	. = ..()
	. += span_notice("将囚犯拖拽进机器中以关押.")

/obj/machinery/fugitive_capture/MouseDrop_T(mob/target, mob/user)
	var/mob/living/fugitive_hunter = user
	if(!isliving(fugitive_hunter))
		return
	if(HAS_TRAIT(fugitive_hunter, TRAIT_UI_BLOCKED) || !Adjacent(fugitive_hunter) || !target.Adjacent(fugitive_hunter) || !ishuman(target))
		return
	var/mob/living/carbon/human/fugitive = target
	var/datum/antagonist/fugitive/fug_antag = fugitive.mind.has_antag_datum(/datum/antagonist/fugitive)
	if(!fug_antag)
		to_chat(fugitive_hunter, span_warning("这个不是通缉犯!"))
		return
	if(do_after(fugitive_hunter, 5 SECONDS, target = fugitive))
		add_prisoner(fugitive, fug_antag)

/obj/machinery/fugitive_capture/proc/add_prisoner(mob/living/carbon/human/fugitive, datum/antagonist/fugitive/antag)
	fugitive.forceMove(src)
	antag.is_captured = TRUE
	to_chat(fugitive, span_userdanger("你被扔进了一片无边无际的蓝空虚空中，下坠在无意识的虚无深渊中，通往现实的相对入口越发狭小，直到你再也看不见它. 你最终未能逃脱追捕."))
	fugitive.ghostize(TRUE) //so they cannot suicide, round end stuff.
	use_energy(active_power_usage)

/obj/machinery/computer/shuttle/hunter
	name = "飞船终端"
	shuttleId = "huntership"
	possible_destinations = "huntership_home;huntership_custom;whiteship_home;syndicate_nw"
	req_access = list(ACCESS_HUNTER)

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/hunter
	name = "飞船导航计算机"
	desc = "用以确定精确的到达位置."
	shuttleId = "huntership"
	lock_override = CAMERA_LOCK_STATION
	shuttlePortId = "huntership_custom"
	see_hidden = FALSE
	jump_to_ports = list("huntership_home" = 1, "whiteship_home" = 1, "syndicate_nw" = 1)
	view_range = 4.5

/obj/structure/closet/crate/eva
	name = "EVA板条箱"
	icon_state = "o2crate"
	base_icon_state = "o2crate"

/obj/structure/closet/crate/eva/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/space/eva(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/helmet/space/eva(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/mask/breath(src)
	for(var/i in 1 to 3)
		new /obj/item/tank/internals/oxygen(src)

///Psyker-friendly shuttle gear!

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/hunter/psyker
	name = "灵能导航整经仪"
	desc = "利用增幅后的脑波来绘制并定位出灵能飞船的精确到达位置."
	icon_screen = "recharge_comp_on"
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON //blind friendly
	x_offset = 0
	y_offset = 11

/obj/machinery/fugitive_capture/psyker
	name = "灵能抚慰室"
	desc = "经过改造的抚慰室，常用于灵能者，通过向他们投射强烈的噪音和痛苦刺激来使他们平静下来. 经过改造后用于关押囚犯，非灵能者被强制关入后不会产生任何持续性副作用."

/obj/machinery/fugitive_capture/psyker/process() //I have no fucking idea how to make click-dragging work for psykers so this one just sucks them in.
	for(var/mob/living/carbon/human/potential_victim in range(1, get_turf(src)))
		var/datum/antagonist/fugitive/fug_antag = potential_victim.mind.has_antag_datum(/datum/antagonist/fugitive)
		if(fug_antag)
			potential_victim.visible_message(span_alert("[potential_victim]被猛烈地吸入[src]!"))
			add_prisoner(potential_victim, fug_antag)

/// Psyker gear
/obj/item/reagent_containers/hypospray/medipen/gore
	name = "脏血自动注射器"
	desc = "一个装满了血腥液体的贫民窟样式的自动注射器，也就是脏可卡因. 工作时可能不应该注射这个，但它确实可以当做一种超级兴奋剂. 不要一次性使用两次."
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/drug/kronkaine/gore = 15)
	icon_state = "maintenance"
	base_icon_state = "maintenance"
	label_examine = FALSE

//Captain's special mental recharge gear

/obj/item/clothing/suit/armor/reactive/psykerboost
	name = "反应式灵能增幅护甲"
	desc = "一套实验性的护甲，灵能者用以增幅自身思维. 通过增幅穿戴者的灵能来对敌意做出反应."
	cooldown_message = span_danger("灵能增幅护甲的心灵线圈还在冷却!")
	emp_message = span_danger("灵能增幅护甲的心灵线圈发出低稳的鸣声，开始了重新校准.")
	color = "#d6ad8b"

/obj/item/clothing/suit/armor/reactive/psykerboost/cooldown_activation(mob/living/carbon/human/owner)
	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(1, 1, src)
	sparks.start()
	return ..()

/obj/item/clothing/suit/armor/reactive/psykerboost/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "攻击", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src]挡住了[attack_text]，增幅了[owner]的灵能!"))
	for(var/datum/action/cooldown/spell/psychic_ability in owner.actions)
		if(psychic_ability.school == SCHOOL_PSYCHIC)
			psychic_ability.reset_spell_cooldown()
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/psykerboost/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "攻击", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src]挡住了[attack_text]，消耗了[owner]的灵能!"))
	for(var/datum/action/cooldown/spell/psychic_ability in owner.actions)
		if(psychic_ability.school == SCHOOL_PSYCHIC)
			psychic_ability.StartCooldown()
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/structure/bouncy_castle
	name = "跳跳乐充气城堡"
	desc = "吸毒者的地狱下得太快，甚至在他们死前就能做到. 请吧."
	icon = 'icons/obj/toys/bouncy_castle.dmi'
	icon_state = "bouncy_castle"
	anchored = TRUE
	density = TRUE

/obj/structure/bouncy_castle/Initialize(mapload, mob/gored)
	. = ..()
	if(gored)
		name = gored.real_name

	AddComponent(
		/datum/component/blood_walk,\
		blood_type = /obj/effect/decal/cleanable/blood,\
		blood_spawn_chance = 66.6,\
		max_blood = INFINITY,\
	)

	AddComponent(/datum/component/bloody_spreader,\
		blood_left = INFINITY,\
		blood_dna = list("肉质DNA" = "MT-"),\
		diseases = null,\
	)

/obj/structure/bouncy_castle/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, 'sound/effects/attackblob.ogg', 50, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 100, TRUE)

/obj/item/paper/crumpled/fluff/fortune_teller
	name = "潦草便条"
	default_raw_text = "<b>记好了!</b> 客户喜欢把我们的口香糖当作水晶球. \
		所以它即使一点用也没有，也要忍住咀嚼它的冲动."

/**
 * # Bounty Locator
 *
 * Locates a random, living fugitive and reports their name/location on a 40 second cooldown.
 *
 * Locates a random fugitive antagonist via the GLOB.antagonists list, and reads out their real name and area name.
 * Captured or dead fugitives are not reported.
 */
/obj/machinery/fugitive_locator
	name = "赏金定位器"
	desc = "追踪你辖区内悬赏目标的特征. 没人知道它追踪目标是经由何种机制. \
		无论是蓝空纠缠物还是简单的RFID植入物，这台机器都能找到你要找的人，无论他们藏在哪里."
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator-Purple"
	density = TRUE
	/// Cooldown on locating a fugitive.
	COOLDOWN_DECLARE(locate_cooldown)

/obj/machinery/fugitive_locator/interact(mob/user)
	if(!COOLDOWN_FINISHED(src, locate_cooldown))
		balloon_alert_to_viewers("定位器充能中!", vision_distance = 3)
		return
	var/mob/living/bounty = locate_fugitive()
	if(!bounty)
		say("没有发现悬赏目标.")
	else
		say("发现悬赏目标. 赏金ID: [bounty.real_name]. 位置: [get_area_name(bounty)]")

	COOLDOWN_START(src, locate_cooldown, 40 SECONDS)

///Locates a random fugitive via their antag datum and returns them.
/obj/machinery/fugitive_locator/proc/locate_fugitive()
	var/list/datum_list = shuffle(GLOB.antagonists)
	for(var/datum/antagonist/fugitive/fugitive_datum in datum_list)
		if(!fugitive_datum.owner)
			stack_trace("Fugitive locator tried to locate a fugitive antag datum with no owner.")
			continue
		if(fugitive_datum.is_captured)
			continue
		var/mob/living/found_fugitive = fugitive_datum.owner.current
		if(found_fugitive.stat == DEAD)
			continue

		return found_fugitive

/obj/item/radio/headset/psyker
	name = "灵能耳机"
	desc = "一种用来增强灵能波的耳机，可以保护耳朵不受闪光弹伤害."
	icon_state = "psyker_headset"
	worn_icon_state = "syndie_headset"

/obj/item/radio/headset/psyker/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/psyker/equipped(mob/living/user, slot)
	. = ..()
	if(slot_flags & slot)
		ADD_CLOTHING_TRAIT(user, TRAIT_ECHOLOCATION_EXTRA_RANGE)

/obj/item/radio/headset/psyker/dropped(mob/user, silent)
	. = ..()
	REMOVE_CLOTHING_TRAIT(user, TRAIT_ECHOLOCATION_EXTRA_RANGE)
