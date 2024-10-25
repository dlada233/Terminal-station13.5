////////////////////////////////////////
//Singularity beacon
////////////////////////////////////////
/obj/machinery/power/singularity_beacon
	name = "不详的信标"
	desc = "看起来很可疑..."
	icon = 'icons/obj/machines/engine/singularity.dmi'
	icon_state = "beacon0"

	anchored = FALSE
	density = TRUE
	layer = BELOW_MOB_LAYER //so people can't hide it and it's REALLY OBVIOUS
	verb_say = "states"
	var/cooldown = 0

	var/active = FALSE
	var/icontype = "beacon"


/obj/machinery/power/singularity_beacon/proc/Activate(mob/user = null)
	if(surplus() < 1500)
		if(user)
			to_chat(user, span_notice("所连电缆没有足够的电流."))
		return
	for (var/datum/component/singularity/singulo as anything in GLOB.singularities)
		var/atom/singulo_atom = singulo.parent
		if(singulo_atom.z == z)
			singulo.target = src
	icon_state = "[icontype]1"
	active = TRUE
	if(user)
		to_chat(user, span_notice("你激活了信标."))


/obj/machinery/power/singularity_beacon/proc/Deactivate(mob/user = null)
	for(var/_singulo in GLOB.singularities)
		var/datum/component/singularity/singulo = _singulo
		if(singulo.target == src)
			singulo.target = null
	icon_state = "[icontype]0"
	active = FALSE
	if(user)
		to_chat(user, span_notice("你关闭了信标."))


/obj/machinery/power/singularity_beacon/attack_ai(mob/user)
	return


/obj/machinery/power/singularity_beacon/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(anchored)
		return active ? Deactivate(user) : Activate(user)
	else
		to_chat(user, span_warning("你需要先用扳手固定[src]到地板上!"))

/obj/machinery/power/singularity_beacon/wrench_act(mob/living/user, obj/item/tool)
	. = TRUE
	if(active)
		to_chat(user, span_warning("你需要先关闭[src]!"))
		return

	if(anchored)
		tool.play_tool_sound(src, 50)
		set_anchored(FALSE)
		to_chat(user, span_notice("你拆到地板上[src]的螺栓，并切断了连接的电缆."))
		disconnect_from_network()
		return
	else
		if(!connect_to_network())
			to_chat(user, span_warning("[src]必须被放置到暴露的通电电缆上!"))
			return
		tool.play_tool_sound(src, 50)
		set_anchored(TRUE)
		to_chat(user, span_notice("你固定[src]的螺栓到地板上并连接电缆."))
		return

/obj/machinery/power/singularity_beacon/screwdriver_act(mob/living/user, obj/item/tool)
	user.visible_message( \
			"[user]对[src]乱怼一通.", \
			span_notice("你没法用螺丝刀拧动[src]的螺栓! 尝试用扳手."))
	return TRUE

/obj/machinery/power/singularity_beacon/Destroy()
	if(active)
		Deactivate()
	return ..()

//stealth direct power usage
/obj/machinery/power/singularity_beacon/process()
	if(!active)
		return

	if(surplus() >= 1500)
		add_load(1500)
		if(cooldown <= world.time)
			cooldown = world.time + 80
			for(var/_singulo_component in GLOB.singularities)
				var/datum/component/singularity/singulo_component = _singulo_component
				var/atom/singulo = singulo_component.parent
				if(singulo.z == z)
					say("[singulo]现在是[get_dist(src,singulo)]到[dir2text(get_dir(src,singulo))]的标准长度.")
	else
		Deactivate()
		say("电量不足 - 功率下降")


/obj/machinery/power/singularity_beacon/syndicate
	icontype = "beaconsynd"
	icon_state = "beaconsynd0"

// SINGULO BEACON SPAWNER
/obj/item/sbeacondrop
	name = "可疑的信标"
	icon = 'icons/obj/devices/tracker.dmi'
	icon_state = "beacon"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	desc = "标签上写着: <i>警告: 激活此设备将向你的位置发送一台特殊信标.</i>."
	w_class = WEIGHT_CLASS_SMALL
	var/droptype = /obj/machinery/power/singularity_beacon/syndicate


/obj/item/sbeacondrop/attack_self(mob/user)
	if(user)
		to_chat(user, span_notice("Locked In."))
		new droptype( user.loc )
		playsound(src, 'sound/effects/pop.ogg', 100, TRUE, TRUE)
		qdel(src)
	return

/obj/item/sbeacondrop/bomb
	desc = "标签上写着: <i>警告: 激活此设备将向你的位置发送一台高浓度炸药</i>."
	droptype = /obj/machinery/syndicatebomb

/obj/item/sbeacondrop/emp
	desc = "标签上写着: <i>警告: 激活此设备将向你的位置发送一台高功率电磁装置</i>."
	droptype = /obj/machinery/syndicatebomb/emp

/obj/item/sbeacondrop/powersink
	desc = "标签上写着: <i>警告: 激活此设备将向你的位置发送一台电力汲取装置</i>."
	droptype = /obj/item/powersink

/obj/item/sbeacondrop/clownbomb
	desc = "标签上写着: <i>警告: 激活此设备将向你的位置发送一台傻瓜炸药</i>."
	droptype = /obj/machinery/syndicatebomb/badmin/clown

/obj/item/sbeacondrop/horse
	desc = "标签上写着: <i>警告: 激活此设备将向你的位置发送一匹马.</i>"
	droptype = /mob/living/basic/pony/syndicate
