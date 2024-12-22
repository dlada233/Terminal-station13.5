/obj/machinery/dryer
	name = "烘手器"
	desc = "蜥蜴之息-3000，一款实验性烘手器."
	icon = 'modular_skyrat/modules/salon/icons/dryer.dmi'
	icon_state = "dryer"
	density = FALSE
	anchored = TRUE
	var/busy = FALSE

/obj/machinery/dryer/attack_hand(mob/user)
	if(iscyborg(user) || isAI(user))
		return

	if(!can_interact(user))
		return

	if(busy)
		to_chat(user, span_warning("已有人在此烘干."))
		return

	to_chat(user, span_notice("你开始烘干你的手."))
	playsound(src, 'modular_skyrat/modules/salon/sound/drying.ogg', 50)
	add_fingerprint(user)
	busy = TRUE
	if(do_after(user, 4 SECONDS, src))
		busy = FALSE
		user.visible_message("[user]使用[src]烘干了手.")
	else
		busy = FALSE
