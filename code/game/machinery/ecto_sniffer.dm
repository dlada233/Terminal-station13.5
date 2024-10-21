/obj/machinery/ecto_sniffer
	name = "探灵仪"
	desc = "一种对灵异物质高度敏感的科学仪器，校准后可以探测到周围的灵能反应."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "ecto_sniffer"
	density = FALSE
	anchored = FALSE
	pass_flags = PASSTABLE
	circuit = /obj/item/circuitboard/machine/ecto_sniffer
	///determines if the device if the power switch is turned on or off. Useful if the ghosts are too annoying.
	var/on = TRUE
	///If this var set to false the ghosts will not be able interact with the machine, say if the machine is silently disabled by cutting the internal wire.
	var/sensor_enabled = TRUE
	///List of ckeys containing players who have recently activated the device, players on this list are prohibited from activating the device untill their residue decays.
	var/list/ectoplasmic_residues = list()

/obj/machinery/ecto_sniffer/Initialize(mapload)
	. = ..()
	set_wires(new/datum/wires/ecto_sniffer(src))

/obj/machinery/ecto_sniffer/attack_ghost(mob/user)
	. = ..()
	if(!is_operational || !on || !sensor_enabled)
		return

	for(var/spirit_key in ectoplasmic_residues)
		if(spirit_key == user.ckey)
			return
	activate(user)

/obj/machinery/ecto_sniffer/proc/activate(mob/activator)
	if(!use_energy(active_power_usage, force = FALSE))
		return
	flick("ecto_sniffer_flick", src)
	playsound(loc, 'sound/machines/ectoscope_beep.ogg', 75)
	say("检测到“[pick(world.file2list("strings/spook_levels.txt"))]”级超自然活动!")
	if(activator?.ckey)
		ectoplasmic_residues += activator.ckey
		addtimer(CALLBACK(src, PROC_REF(clear_residue), activator.ckey), 15 SECONDS)

/obj/machinery/ecto_sniffer/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	add_fingerprint(user)
	on = !on
	balloon_alert(user, "探灵仪[on ? "打开着" : "关闭着"]")
	update_appearance()

/obj/machinery/ecto_sniffer/update_icon_state()
	. = ..()
	if(panel_open)
		icon_state = "[initial(icon_state)]_open"
	else
		icon_state = "[initial(icon_state)][(is_operational && on) ? null : "-p"]"

/obj/machinery/ecto_sniffer/update_overlays()
	. = ..()
	if(is_operational && on)
		. += emissive_appearance(icon, "[initial(icon_state)]-light-mask", src, alpha = src.alpha)

/obj/machinery/ecto_sniffer/wrench_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src, 15)
	set_anchored(!anchored)
	balloon_alert(user, "探灵仪[anchored ? "固定住了" : "未被固定"]")

/obj/machinery/ecto_sniffer/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(!.)
		return default_deconstruction_screwdriver(user, "ecto_sniffer_open", "ecto_sniffer", I)

/obj/machinery/ecto_sniffer/crowbar_act(mob/living/user, obj/item/tool)
	if(!default_deconstruction_crowbar(tool))
		return ..()

/obj/machinery/ecto_sniffer/Destroy()
	ectoplasmic_residues = null
	. = ..()

/obj/machinery/ecto_sniffer/examine(mob/user)
	. = ..()
	. += span_notice("任何活跃的幽灵都会在探灵仪上留下一层外质，产生一声微弱可听见的信号，以表明它们希望以正电子脑的身份返回世界.")

///Removes the ghost from the ectoplasmic_residues list and lets them know they are free to activate the sniffer again.
/obj/machinery/ecto_sniffer/proc/clear_residue(ghost_ckey)
	ectoplasmic_residues -= ghost_ckey
	var/mob/ghost = get_mob_by_ckey(ghost_ckey)
	if(!ghost || isliving(ghost))
		return
	to_chat(ghost, "[FOLLOW_LINK(ghost, src)] <span class='nicegreen'>你留在[src]传感器上的外质已经消失.</span>")
