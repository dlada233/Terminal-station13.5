/obj/item/abductor
	icon = 'icons/obj/antags/abductor.dmi'
	lefthand_file = 'icons/mob/inhands/antag/abductor_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/abductor_righthand.dmi'

/obj/item/proc/AbductorCheck(mob/user)
	if (HAS_TRAIT(user, TRAIT_ABDUCTOR_TRAINING))
		return TRUE
	if (istype(user) && HAS_MIND_TRAIT(user, TRAIT_ABDUCTOR_TRAINING))
		return TRUE
	to_chat(user, span_warning("你搞不懂它是怎么运作的!"))
	return FALSE

/obj/item/abductor/proc/ScientistCheck(mob/user)
	var/training = HAS_MIND_TRAIT(user, TRAIT_ABDUCTOR_TRAINING)
	var/sci_training = HAS_MIND_TRAIT(user, TRAIT_ABDUCTOR_SCIENTIST_TRAINING)

	if(training && !sci_training)
		to_chat(user, span_warning("你没有接受过该物品的使用训练!"))
		. = FALSE
	else if(!training && !sci_training)
		to_chat(user, span_warning("你搞不懂它是怎么运作的!"))
		. = FALSE
	else
		. = TRUE

/obj/item/abductor/gizmo
	name = "科研工具"
	desc = "用于检索样本和扫描外观的双模式工具，扫描行动可以通过摄像头完成."
	icon_state = "gizmo_scan"
	inhand_icon_state = "silencer"
	var/mode = GIZMO_SCAN
	var/datum/weakref/marked_target_weakref
	var/obj/machinery/abductor/console/console

/obj/item/abductor/gizmo/attack_self(mob/user)
	if(!ScientistCheck(user))
		return
	if(!console)
		to_chat(user, span_warning("设备未连接到控制台!"))
		return

	if(mode == GIZMO_SCAN)
		mode = GIZMO_MARK
		icon_state = "gizmo_mark"
	else
		mode = GIZMO_SCAN
		icon_state = "gizmo_scan"
	to_chat(user, span_notice("你切换设备到[mode == GIZMO_SCAN? "扫描": "标记"]模式"))

/obj/item/abductor/gizmo/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ScientistCheck(user))
		return ITEM_INTERACT_SKIP_TO_ATTACK // So you slap them with it
	if(!console)
		to_chat(user, span_warning("设备未连接到控制台!"))
		return ITEM_INTERACT_BLOCKING

	switch(mode)
		if(GIZMO_SCAN)
			scan(interacting_with, user)
		if(GIZMO_MARK)
			mark(interacting_with, user)

	return ITEM_INTERACT_SUCCESS

/obj/item/abductor/gizmo/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/abductor/gizmo/proc/scan(atom/target, mob/living/user)
	if(ishuman(target))
		console.AddSnapshot(target)
		to_chat(user, span_notice("你扫描[target]信息并添加到数据库."))

/obj/item/abductor/gizmo/proc/mark(atom/target, mob/living/user)
	var/mob/living/marked = marked_target_weakref?.resolve()
	if(marked == target)
		to_chat(user, span_warning("该样本已经被标记了!"))
		return
	if(isabductor(target) || iscow(target))
		marked_target_weakref = WEAKREF(target)
		to_chat(user, span_notice("你标记[target]以便将来检索."))
	else
		prepare(target,user)

/obj/item/abductor/gizmo/proc/prepare(atom/target, mob/living/user)
	if(get_dist(target,user)>1)
		to_chat(user, span_warning("你需要在样本旁边来做运输准备!"))
		return
	to_chat(user, span_notice("你开始准备运输[target]..."))
	if(do_after(user, 10 SECONDS, target = target))
		marked_target_weakref = WEAKREF(target)
		to_chat(user, span_notice("你完成了[target]的运输准备."))

/obj/item/abductor/gizmo/Destroy()
	if(console)
		console.gizmo = null
		console = null
	. = ..()


/obj/item/abductor/silencer
	name = "劫持者静默仪"
	desc = "用于关闭通讯设备的小型装置."
	icon_state = "silencer"
	inhand_icon_state = "gizmo"

/obj/item/abductor/silencer/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!AbductorCheck(user))
		return ITEM_INTERACT_SKIP_TO_ATTACK // So you slap them with it

	radio_off(interacting_with, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/abductor/silencer/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/abductor/silencer/proc/radio_off(atom/target, mob/living/user)
	if( !(user in (viewers(7,target))) )
		return

	var/turf/targloc = get_turf(target)

	var/mob/living/carbon/human/human_target
	for(human_target in view(2,targloc))
		if(human_target == user)
			continue
		to_chat(user, span_notice("你让[human_target]的无线电设备静默了."))
		radio_off_mob(human_target)

/obj/item/abductor/silencer/proc/radio_off_mob(mob/living/carbon/human/target)
	var/list/all_items = target.get_all_contents()

	for(var/obj/item/radio/radio in all_items)
		radio.set_listening(FALSE)
		if(!istype(radio, /obj/item/radio/headset))
			radio.set_broadcasting(FALSE) //goddamned headset hacks

/obj/item/abductor/mind_device
	name = "心灵接口仪"
	desc = "一种可以直接与有知觉的大脑交流的双模式工具. 可用于向目标发送脑内消息，\
			或向带有未耗尽次数的腺体的测试对象发送命令."
	icon_state = "mind_device_message"
	inhand_icon_state = "silencer"
	var/mode = MIND_DEVICE_MESSAGE

/obj/item/abductor/mind_device/attack_self(mob/user)
	if(!ScientistCheck(user))
		return

	if(mode == MIND_DEVICE_MESSAGE)
		mode = MIND_DEVICE_CONTROL
		icon_state = "mind_device_control"
	else
		mode = MIND_DEVICE_MESSAGE
		icon_state = "mind_device_message"
	to_chat(user, span_notice("你切换设备到[mode == MIND_DEVICE_MESSAGE? "传讯": "命令"]模式"))

/obj/item/abductor/mind_device/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/abductor/mind_device/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ScientistCheck(user))
		return ITEM_INTERACT_BLOCKING

	switch(mode)
		if(MIND_DEVICE_CONTROL)
			mind_control(interacting_with, user)
		if(MIND_DEVICE_MESSAGE)
			mind_message(interacting_with, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/abductor/mind_device/proc/mind_control(atom/target, mob/living/user)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/organ/internal/heart/gland/target_gland = carbon_target.get_organ_slot("heart")
		if(!istype(target_gland))
			to_chat(user, span_warning("你的目标没有实验性腺体!"))
			return
		if(!target_gland.mind_control_uses)
			to_chat(user, span_warning("你的目标体内的腺体已经耗尽了!"))
			return
		if(target_gland.active_mind_control)
			to_chat(user, span_warning("你的目标已经被精神控制了!"))
			return

		var/command = tgui_input_text(user, "输入你对目标所下达的命令.\
											次数剩余: [target_gland.mind_control_uses]，持续时间: [DisplayTimeText(target_gland.mind_control_duration)]", "下达命令")

		if(!command)
			return

		if(QDELETED(user) || user.get_active_held_item() != src || loc != user)
			return

		if(QDELETED(target_gland))
			return

		if(carbon_target.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = 0))
			user.balloon_alert(user, "被阻碍!")
			to_chat(user, span_warning("你的目标似乎患有某种精神障碍，阻碍了消息的发送."))
			return

		target_gland.mind_control(command, user)
		to_chat(user, span_notice("你对你的目标下达了命令."))

/obj/item/abductor/mind_device/proc/mind_message(atom/target, mob/living/user)
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.stat == DEAD)
			to_chat(user, span_warning("你的目标已经死了!"))
			return
		var/message = tgui_input_text(user, "将消息发送到目标的大脑", "输入消息")
		if(!message)
			return
		if(QDELETED(living_target) || living_target.stat == DEAD)
			return

		living_target.balloon_alert(living_target, "你听到一个声音")
		to_chat(living_target, span_hear("一个声音在你的脑中响起: </span><span class='abductor'>[message]"))
		to_chat(user, span_notice("你发送了消息给你的目标."))
		log_directed_talk(user, living_target, message, LOG_SAY, "劫持者低语")


/obj/item/firing_pin/abductor
	name = "外星撞针"
	icon_state = "firing_pin_ayy"
	desc = "这个撞针摸起来温暖而粘腻，你发誓你感觉到它在不断地在精神上探测你."
	fail_message = "<span class='abductor'>撞针错误，请联系指挥部.</span>"

/obj/item/firing_pin/abductor/pin_auth(mob/living/user)
	. = isabductor(user)

/obj/item/gun/energy/alien
	name = "外星手枪"
	desc = "一把发射高强度辐射的复杂枪械."
	ammo_type = list(/obj/item/ammo_casing/energy/radiation)
	pin = /obj/item/firing_pin/abductor
	icon_state = "alienpistol"
	inhand_icon_state = "alienpistol"
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL

/obj/item/gun/energy/shrink_ray
	name = "缩小射线炮"
	desc = "这是一项可怕的外星技术，通过增加局部空间中原子的磁力，暂时使物体缩小. \
			或者只是太空魔法，不管怎么样，它就是缩小了."
	ammo_type = list(/obj/item/ammo_casing/energy/shrink)
	pin = /obj/item/firing_pin/abductor
	inhand_icon_state = "shrink_ray"
	icon_state = "shrink_ray"
	automatic_charge_overlays = FALSE
	fire_delay = 30
	selfcharge = 1//shot costs 200 energy, has a max capacity of 1000 for 5 shots. self charge returns 25 energy every couple ticks, so about 1 shot charged every 12~ seconds
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL// variable-size trigger, get it? (abductors need this to be set so the gun is usable for them)

/obj/item/paper/guides/antag/abductor
	name = "手术指南"
	icon_state = "alienpaper_words"
	show_written_words = FALSE
	default_raw_text = {"<b>傻瓜手术指南</b><br>

<br>
1.获取新鲜样本.<br>
2.把样本放在手术台上.<br>
3.铺上手术布，准备实验解刨手术.<br>
4.在标本的躯干上使用手术刀.<br>
5.用牵开器牵拉标本躯干的皮肤.<br>
6.用止血钳夹住标本躯干上的出血点.<br>
7.再次在样本的躯干上使用手术刀.<br>
8.用你的手摸索样本的躯干，摘除多余的器官.<br>
9.植入替换腺体(从器官储存库中取得).<br>
10.考虑将样本捆绑起来，以免影响工作. <br>
11.将样本放进实验机器里.<br>
12.在机器内进行选择，目标最终将被分析并传送到选定的降落点.<br>
13.你将获得一点补给点数，该对象也将记入你的指标.<br>
<br>
恭喜你！你现在已经完成了入侵式异种生物学研究的培训!"}

/obj/item/paper/guides/antag/abductor/click_alt()
	return CLICK_ACTION_BLOCKING //otherwise it would fold into a paperplane.

/obj/item/melee/baton/abductor
	name = "先进电棍"
	desc = "一把四模式的电棍，用于使样本丧失行动能力并加以束缚."

	icon = 'icons/obj/antags/abductor.dmi'
	lefthand_file = 'icons/mob/inhands/antag/abductor_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/abductor_righthand.dmi'
	icon_state = "wonderprodStun"
	inhand_icon_state = "wonderprod"

	force = 7
	wound_bonus = FALSE

	actions_types = list(/datum/action/item_action/toggle_mode)

	cooldown = 0 SECONDS
	stamina_damage = 0
	knockdown_time = 14 SECONDS
	on_stun_sound = 'sound/weapons/egloves.ogg'
	affect_cyborg = TRUE

	var/mode = BATON_STUN

	var/sleep_time = 2 MINUTES
	var/time_to_cuff = 3 SECONDS

/obj/item/melee/baton/abductor/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/melee/baton/abductor/proc/toggle(mob/living/user=usr)
	if(!AbductorCheck(user))
		return
	mode = (mode+1)%BATON_MODES
	var/txt
	switch(mode)
		if(BATON_STUN)
			txt = "击晕"
		if(BATON_SLEEP)
			txt = "睡眠诱导"
		if(BATON_CUFF)
			txt = "束缚"
		if(BATON_PROBE)
			txt = "探测"

	var/is_stun_mode = mode == BATON_STUN
	var/is_stun_or_sleep = mode == BATON_STUN || mode == BATON_SLEEP

	affect_cyborg = is_stun_mode
	log_stun_attack = is_stun_mode // other modes have their own log entries.
	stun_animation = is_stun_or_sleep
	on_stun_sound = is_stun_or_sleep ? 'sound/weapons/egloves.ogg' : null

	to_chat(usr, span_notice("你切换电棍到[txt]模式."))
	update_appearance()

/obj/item/melee/baton/abductor/update_icon_state()
	. = ..()
	switch(mode)
		if(BATON_STUN)
			icon_state = "wonderprodStun"
			inhand_icon_state = "wonderprodStun"
		if(BATON_SLEEP)
			icon_state = "wonderprodSleep"
			inhand_icon_state = "wonderprodSleep"
		if(BATON_CUFF)
			icon_state = "wonderprodCuff"
			inhand_icon_state = "wonderprodCuff"
		if(BATON_PROBE)
			icon_state = "wonderprodProbe"
			inhand_icon_state = "wonderprodProbe"

/obj/item/melee/baton/abductor/baton_attack(mob/target, mob/living/user, modifiers)
	if(!AbductorCheck(user))
		return BATON_ATTACK_DONE
	return ..()

/obj/item/melee/baton/abductor/baton_effect(mob/living/target, mob/living/user, modifiers, stun_override)
	switch (mode)
		if(BATON_STUN)
			target.visible_message(span_danger("[user]用[src]击晕了[target]!"),
				span_userdanger("[user]用[src]击晕了你!"))
			target.set_jitter_if_lower(40 SECONDS)
			target.set_confusion_if_lower(10 SECONDS)
			target.set_stutter_if_lower(16 SECONDS)
			SEND_SIGNAL(target, COMSIG_LIVING_MINOR_SHOCK)
			target.Paralyze(knockdown_time * (HAS_TRAIT(target, TRAIT_BATON_RESISTANCE) ? 0.1 : 1))
		if(BATON_SLEEP)
			SleepAttack(target,user)
		if(BATON_CUFF)
			CuffAttack(target,user)
		if(BATON_PROBE)
			ProbeAttack(target,user)

/obj/item/melee/baton/abductor/get_stun_description(mob/living/target, mob/living/user)
	return // chat messages are handled in their own procs.

/obj/item/melee/baton/abductor/get_cyborg_stun_description(mob/living/target, mob/living/user)
	return // same as above.

/obj/item/melee/baton/abductor/attack_self(mob/living/user)
	. = ..()
	toggle(user)

/obj/item/melee/baton/abductor/proc/SleepAttack(mob/living/target, mob/living/user)
	playsound(src, on_stun_sound, 50, TRUE, -1)
	if(target.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB))
		if(target.can_block_magic(MAGIC_RESISTANCE_MIND))
			to_chat(user, span_warning("该样本受到某种精神保护，你的睡眠诱导被阻碍了."))
			target.visible_message(span_danger("[user]用[src]诱导[target]进入睡眠，但没有成功!"), \
			span_userdanger("你感到一股奇怪的睡意涌上心头!"))
			target.adjust_drowsiness(4 SECONDS)
			return
		target.visible_message(span_danger("[user]用[src]诱导[target]进入睡眠!"), \
		span_userdanger("你突然感到困倦无比!"))
		target.Sleeping(sleep_time)
		log_combat(user, target, "使入睡")
	else
		if(target.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = 0))
			to_chat(user, span_warning("该样本受到某种精神保护，你的睡眠诱导被完全阻止了."))
			target.visible_message(span_danger("[user]用[src]诱导[target]进入睡眠，但没有成功!"), \
			span_userdanger("困倦感迅速消退!"))
			return
		target.adjust_drowsiness(2 SECONDS)
		to_chat(user, span_warning("睡眠诱导只对被击晕的样本有效! "))
		target.visible_message(span_danger("[user]试图用[src]诱导[target]进入睡眠!"), \
							span_userdanger("你突然感到昏昏欲睡!"))

/obj/item/melee/baton/abductor/proc/CuffAttack(mob/living/victim, mob/living/user)
	if(!iscarbon(victim))
		return
	var/mob/living/carbon/carbon_victim = victim
	if(!carbon_victim.handcuffed)
		if(carbon_victim.canBeHandcuffed())
			playsound(src, 'sound/weapons/cablecuff.ogg', 30, TRUE, -2)
			carbon_victim.visible_message(span_danger("[user]开始用[src]束缚[carbon_victim]!"), \
									span_userdanger("[user]开始在你的双手周围制造一个能量场!"))
			if(do_after(user, time_to_cuff, carbon_victim) && carbon_victim.canBeHandcuffed())
				if(!carbon_victim.handcuffed)
					carbon_victim.set_handcuffed(new /obj/item/restraints/handcuffs/energy/used(carbon_victim))
					carbon_victim.update_handcuffed()
					to_chat(user, span_notice("你束缚了[carbon_victim]."))
					log_combat(user, carbon_victim, "被铐上")
			else
				to_chat(user, span_warning("你没能束缚[carbon_victim]."))
		else
			to_chat(user, span_warning("[carbon_victim]没有两只手..."))

/obj/item/melee/baton/abductor/proc/ProbeAttack(mob/living/victim, mob/living/user)
	victim.visible_message(span_danger("[user]用[src]探测[victim]!"), \
						span_userdanger("[user]探测了你!"))

	var/species = span_warning("未知物种")
	var/helptext = span_warning("该物种不适合进行实验.")

	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		species = span_notice("[human_victim.dna.species.name]")
		if(IS_CHANGELING(human_victim))
			species = span_warning("化形生命形式")
		var/obj/item/organ/internal/heart/gland/temp = locate() in human_victim.organs
		if(temp)
			helptext = span_warning("探测到实验性腺体!")
		else
			if (human_victim.get_organ_slot(ORGAN_SLOT_HEART))
				helptext = span_notice("该对象适合进行实验.")
			else
				helptext = span_warning("该对象不适合进行实验.")

	to_chat(user, "[span_notice("探测结果:")][species]")
	to_chat(user, "[helptext]")

/obj/item/restraints/handcuffs/energy
	name = "硬光能量场"
	desc = "束缚双手的硬光能量场."
	icon_state = "cuff" // Needs sprite
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	breakouttime = 45 SECONDS
	trashtype = /obj/item/restraints/handcuffs/energy/used
	flags_1 = NONE

/obj/item/restraints/handcuffs/energy/used
	item_flags = DROPDEL

/obj/item/restraints/handcuffs/energy/used/dropped(mob/user)
	user.visible_message(span_danger("[user]的[name]因溃能而断裂!"), \
							span_userdanger("[user]的[name]因溃能而断裂!"))
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(4,0,user.loc)
	sparks.start()
	. = ..()

/obj/item/melee/baton/abductor/examine(mob/user)
	. = ..()
	if(AbductorCheck(user))
		switch(mode)
			if(BATON_STUN)
				. += span_warning("该电棍当前为击晕模式.")
			if(BATON_SLEEP)
				. += span_warning("该电棍当前为睡眠诱导模式.")
			if(BATON_CUFF)
				. += span_warning("该电棍当前为束缚模式.")
			if(BATON_PROBE)
				. += span_warning("该电棍当前为探测模式.")

/obj/item/radio/headset/abductor
	name = "外星耳机"
	desc = "一款先进的外星耳机，用于监听空间站的通讯，没人知道为什么还有麦克风功能."
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "abductor_headset"
	keyslot2 = /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/abductor/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))
	make_syndie()

// Stops humans from disassembling abductor headsets.
/obj/item/radio/headset/abductor/screwdriver_act(mob/living/user, obj/item/tool)
	return ITEM_INTERACT_SUCCESS

/obj/item/abductor_machine_beacon
	name = "机器信标"
	desc = "用来快速建造绑架机的信标."
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "beacon"
	w_class = WEIGHT_CLASS_TINY
	var/obj/machinery/spawned_machine

/obj/item/abductor_machine_beacon/attack_self(mob/user)
	..()
	user.visible_message(span_notice("[user]放置并激活了[src]."), span_notice("你放置并激活了[src]."))
	user.dropItemToGround(src)
	playsound(src, 'sound/machines/terminal_alert.ogg', 50)
	addtimer(CALLBACK(src, PROC_REF(try_spawn_machine)), 3 SECONDS)

/obj/item/abductor_machine_beacon/proc/try_spawn_machine()
	var/viable = FALSE
	if(isfloorturf(loc))
		var/turf/T = loc
		viable = TRUE
		for(var/obj/thing in T.contents)
			if(thing.density || ismachinery(thing) || isstructure(thing))
				viable = FALSE
	if(viable)
		playsound(src, 'sound/effects/phasein.ogg', 50, TRUE)
		var/new_machine = new spawned_machine(loc)
		visible_message(span_notice("[new_machine]在信标上浮现!"))
		qdel(src)
	else
		playsound(src, 'sound/machines/buzz-two.ogg', 50)

/obj/item/abductor_machine_beacon/chem_dispenser
	name = "信标 - 试剂合成器"
	spawned_machine = /obj/machinery/chem_dispenser/abductor

/obj/item/scalpel/alien
	name = "外星手术刀"
	desc = "这是一把闪闪发光的尖刀，由银绿色的金属制成."
	icon = 'icons/obj/antags/abductor.dmi'
	surgical_tray_overlay = "scalpel_alien"
	toolspeed = 0.25

/obj/item/hemostat/alien
	name = "外星止血钳"
	desc = "是你从未见过的东西."
	icon = 'icons/obj/antags/abductor.dmi'
	surgical_tray_overlay = "hemostat_alien"
	toolspeed = 0.25

/obj/item/retractor/alien
	name = "外星牵开器"
	desc = "你要牵开那面纱吗."
	icon = 'icons/obj/antags/abductor.dmi'
	surgical_tray_overlay = "retractor_alien"
	toolspeed = 0.25

/obj/item/circular_saw/alien
	name = "外星骨锯"
	desc = "外星人也要破开骨头吗，也许还需要找到一把外星斧头?"
	icon = 'icons/obj/antags/abductor.dmi'
	surgical_tray_overlay = "saw_alien"
	toolspeed = 0.25

/obj/item/surgicaldrill/alien
	name = "外星骨钻"
	desc = "也许外星大夫终于找到了钻头的用途."
	icon = 'icons/obj/antags/abductor.dmi'
	surgical_tray_overlay = "drill_alien"
	toolspeed = 0.25

/obj/item/cautery/alien
	name = "外星缝合器"
	desc = "为什么不流血的外星人会有止血工具？除非..."
	icon = 'icons/obj/antags/abductor.dmi'
	surgical_tray_overlay = "cautery_alien"
	toolspeed = 0.25

/obj/item/clothing/head/helmet/abductor
	name = "外星头盔"
	desc = "以尖刺风格进行绑架，阻碍电子追踪手段."
	icon_state = "alienhelmet"
	inhand_icon_state = null
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/helmet/abductor/equipped(mob/living/user, slot)
	. = ..()
	if(slot_flags & slot)
		RegisterSignal(user, COMSIG_LIVING_CAN_TRACK, PROC_REF(can_track))
	else
		UnregisterSignal(user, COMSIG_LIVING_CAN_TRACK)

/obj/item/clothing/head/helmet/abductor/dropped(mob/living/user)
	. = ..()
	UnregisterSignal(user, COMSIG_LIVING_CAN_TRACK)

/obj/item/clothing/head/helmet/abductor/proc/can_track(datum/source, mob/user)
	SIGNAL_HANDLER

	return COMPONENT_CANT_TRACK

/obj/item/abductor/alien_omnitool
	name = "多功能接口"
	desc = "实际上就是一把太空瑞士军刀，包含各种的集成工具，右键以切换工具集."
	icon_state = "omnitool"
	inhand_icon_state = "silencer"
	toolspeed = 0.25
	tool_behaviour = null
	usesound = 'sound/items/pshoom.ogg'
	///A list of all the tools we offer. Stored as "Tool" for the key, and the icon/icon_state as the value.
	var/list/tool_list = list()
	///Which toolset do we have active currently?
	var/active_toolset = TOOLSET_MEDICAL

/obj/item/abductor/alien_omnitool/get_all_tool_behaviours()
	return list(
	TOOL_BLOODFILTER,
	TOOL_BONESET,
	TOOL_CAUTERY,
	TOOL_CROWBAR,
	TOOL_DRILL,
	TOOL_HEMOSTAT,
	TOOL_MULTITOOL,
	TOOL_RETRACTOR,
	TOOL_SAW,
	TOOL_SCALPEL,
	TOOL_SCREWDRIVER,
	TOOL_WELDER,
	TOOL_WIRECUTTER,
	TOOL_WRENCH,
	)

/obj/item/abductor/alien_omnitool/Initialize(mapload)
	. = ..()
	set_toolset() //This populates the tool list, and sets it to the hacking configuration.

/obj/item/abductor/alien_omnitool/examine()
	. = ..()
	. += "当前模式为: [tool_behaviour]"

/obj/item/abductor/alien_omnitool/attack_self(mob/user)
	if(!user)
		return

	var/tool_result = show_radial_menu(user, src, tool_list, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(tool_result)
		if("牵开器")
			tool_behaviour = TOOL_RETRACTOR
		if("止血钳")
			tool_behaviour = TOOL_HEMOSTAT
		if("缝合器")
			tool_behaviour = TOOL_CAUTERY
		if("骨钻")
			tool_behaviour = TOOL_DRILL
		if("手术刀")
			tool_behaviour = TOOL_SCALPEL
		if("骨锯")
			tool_behaviour = TOOL_SAW
		if("接骨器")
			tool_behaviour = TOOL_BONESET
		if("血液过滤器")
			tool_behaviour = TOOL_BLOODFILTER
		if("撬棍")
			tool_behaviour = TOOL_CROWBAR
		if("多功能工具")
			tool_behaviour = TOOL_MULTITOOL
		if("螺丝刀")
			tool_behaviour = TOOL_SCREWDRIVER
		if("剪线钳")
			tool_behaviour = TOOL_WIRECUTTER
		if("扳手")
			tool_behaviour = TOOL_WRENCH
		if("焊接工具")
			tool_behaviour = TOOL_WELDER

	playsound(loc, 'sound/machines/click.ogg', 50, TRUE)

/obj/item/abductor/alien_omnitool/attack_self_secondary(mob/user, modifiers) //ADD SFX FOR USING THE TOOL
	if(!user)
		return

	set_toolset(user)
	playsound(loc, 'sound/machines/click.ogg', 50, TRUE)

/obj/item/abductor/alien_omnitool/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/abductor/alien_omnitool/proc/set_toolset(mob/user)
	if(active_toolset == TOOLSET_MEDICAL)
		tool_list = list(
			"撬棍" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "crowbar"),
			"多功能工具" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "multitool"),
			"螺丝刀" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "screwdriver_a"),
			"剪线钳" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "cutters"),
			"扳手" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "wrench"),
			"焊接工具" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "welder"),
		)
		active_toolset = TOOLSET_HACKING
		if(user)
			balloon_alert(user, "已选择入侵工具集")
	else
		tool_list = list(
			"牵开器" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "retractor"),
			"止血钳" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "hemostat"),
			"缝合器" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "cautery"),
			"骨钻" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "drill"),
			"手术刀" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "scalpel"),
			"骨锯" = image(icon = 'icons/obj/antags/abductor.dmi', icon_state = "saw"),
			"接骨器" = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "bonesetter"),
			"血液过滤器" = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "bloodfilter"),
		)
		active_toolset = TOOLSET_MEDICAL
		if(user)
			balloon_alert(user, "已选择医用工具集")
