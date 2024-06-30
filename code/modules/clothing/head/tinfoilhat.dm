/obj/item/clothing/head/costume/foilhat
	name = "锡纸帽"
	desc = "精神控制波、思想检测仪！但只要我做了这顶能隔绝信号的帽子，就没什么好担心的！"
	icon_state = "foilhat"
	inhand_icon_state = null
	armor_type = /datum/armor/costume_foilhat
	equip_delay_other = 140
	clothing_flags = ANTI_TINFOIL_MANEUVER
	var/datum/brain_trauma/mild/phobia/conspiracies/paranoia
	var/warped = FALSE

/datum/armor/costume_foilhat
	laser = -5
	energy = -15

/obj/item/clothing/head/costume/foilhat/Initialize(mapload)
	. = ..()
	if(warped)
		warp_up()
		return

	AddComponent(
		/datum/component/anti_magic, \
		antimagic_flags = MAGIC_RESISTANCE_MIND, \
		inventory_flags = ITEM_SLOT_HEAD, \
		charges = 6, \
		drain_antimagic = CALLBACK(src, PROC_REF(drain_antimagic)), \
		expiration = CALLBACK(src, PROC_REF(warp_up)) \
	)


/obj/item/clothing/head/costume/foilhat/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_HEAD) || warped)
		return
	if(paranoia)
		QDEL_NULL(paranoia)
	paranoia = new()

	RegisterSignal(user, COMSIG_HUMAN_SUICIDE_ACT, PROC_REF(call_suicide))

	user.gain_trauma(paranoia, TRAUMA_RESILIENCE_MAGIC)
	to_chat(user, span_warning("当你戴上锡纸帽时，各种阴谋论和看似疯狂的想法突然涌入你的脑海，你曾认为难以置信的事情现在看起来......不可否认. 一切都是相互关联的，任何事情都不是偶然发生的. 你知道得太多了，他们现在要来抓你了. "))

/obj/item/clothing/head/costume/foilhat/MouseDrop(atom/over_object)
	//God Im sorry
	if(!warped && iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(src == C.head)
			to_chat(C, span_userdanger("你为什么想要摘下这个？你想让他们进入你的思维吗？！"))
			return
	return ..()

/obj/item/clothing/head/costume/foilhat/dropped(mob/user)
	. = ..()
	if(paranoia)
		QDEL_NULL(paranoia)
	UnregisterSignal(user, COMSIG_HUMAN_SUICIDE_ACT)

/// 当锡纸帽被耗尽反魔法充能时.
/obj/item/clothing/head/costume/foilhat/proc/drain_antimagic(mob/user)
	to_chat(user, span_warning("[src] 稍微皱了一下，一定是有什么东西试图进入你的思维中！"))

/obj/item/clothing/head/costume/foilhat/proc/warp_up()
	name = "焦糊的锡纸帽"
	desc = "一顶严重变形的帽子，它已不再能抵御各种来自妄想或现实中的危险了."
	warped = TRUE
	clothing_flags &= ~ANTI_TINFOIL_MANEUVER
	if(!isliving(loc) || !paranoia)
		return
	var/mob/living/target = loc
	UnregisterSignal(target, COMSIG_HUMAN_SUICIDE_ACT)
	if(target.get_item_by_slot(ITEM_SLOT_HEAD) != src)
		return
	QDEL_NULL(paranoia)
	if(target.stat < UNCONSCIOUS)
		to_chat(target, span_warning("当你戴着的帽子彻底变成破烂时，你的阴谋论狂热迅速消散了，曾经的理论听起来就像是场荒谬的闹剧."))

/obj/item/clothing/head/costume/foilhat/attack_hand(mob/user, list/modifiers)
	if(!warped && iscarbon(user))
		var/mob/living/carbon/wearer = user
		if(src == wearer.head)
			to_chat(user, span_userdanger("你为什么想要摘下这个？你想让他们进入你的思维吗？！"))
			return
	return ..()

/obj/item/clothing/head/costume/foilhat/microwave_act(obj/machinery/microwave/microwave_source, mob/microwaver, randomize_pixel_offset)
	. = ..()
	if(warped)
		return

	warp_up()
	return . | COMPONENT_MICROWAVE_SUCCESS

/obj/item/clothing/head/costume/foilhat/proc/call_suicide(datum/source)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(suicide_act), source) //SIGNAL_HANDLER doesn't like things waiting; INVOKE_ASYNC bypasses that
	return OXYLOSS

/obj/item/clothing/head/costume/foilhat/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]的眼中露出了疯狂的神色！这个人明白了这一切背后的真相，这个人试图自杀！"))
	var/static/list/conspiracy_line = list(
		";他们把摄像头藏在天花板里！他们监视我们的一举一动！！",
		";我怎么能生活在一个命运和存在由个别人群决定的世界里？！！",
		";他们在玩弄你们所有人的思想，把你们当作实验对象！！",
		";他们雇佣助手时从不做背景调查！！",
		";我们生活在一个动物园里，而我们才是被观察的对象！！",
		";我们每天都在重复我们的生活，却从未去质疑为什么！！"
	)
	user.say(pick(conspiracy_line), forced=type)
	var/obj/item/organ/internal/brain/brain = user.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.set_organ_damage(BRAIN_DAMAGE_DEATH)
	return OXYLOSS
