/obj/item/borg_chameleon
	name = "赛博变色龙投影仪"
	icon = 'icons/obj/devices/syndie_gadget.dmi'
	icon_state = "shield0"
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/friendlyName
	var/savedName
	var/active = FALSE
	var/activationCost = 300
	var/activationUpkeep = 50
	var/disguise = "engineer"
	var/mob/listeningTo
	var/static/list/signalCache = list( // list here all signals that should break the camouflage
			COMSIG_ATOM_ATTACKBY,
			COMSIG_ATOM_ATTACK_HAND,
			COMSIG_MOVABLE_IMPACT_ZONE,
			COMSIG_ATOM_BULLET_ACT,
			COMSIG_ATOM_EX_ACT,
			COMSIG_ATOM_FIRE_ACT,
			COMSIG_ATOM_EMP_ACT,
			)
	var/mob/living/silicon/robot/user // needed for process()
	var/animation_playing = FALSE

/obj/item/borg_chameleon/Initialize(mapload)
	. = ..()
	friendlyName = pick(GLOB.ai_names)

/obj/item/borg_chameleon/Destroy()
	listeningTo = null
	return ..()

/obj/item/borg_chameleon/dropped(mob/user)
	. = ..()
	disrupt(user)

/obj/item/borg_chameleon/equipped(mob/user)
	. = ..()
	disrupt(user)

/obj/item/borg_chameleon/attack_self(mob/living/silicon/robot/user)
	if (user && user.cell && user.cell.charge >  activationCost)
		if (isturf(user.loc))
			toggle(user)
		else
			to_chat(user, span_warning("在某物内部时，你不能使用[src]!"))
	else
		to_chat(user, span_warning("你的电池至少需要[activationCost]电量来使用[src]!"))

/obj/item/borg_chameleon/proc/toggle(mob/living/silicon/robot/user)
	if(active)
		playsound(src, 'sound/effects/pop.ogg', 100, TRUE, -6)
		to_chat(user, span_notice("你停用[src]."))
		deactivate(user)
	else
		if(animation_playing)
			to_chat(user, span_notice("[src]正在充能."))
			return
		animation_playing = TRUE
		to_chat(user, span_notice("你激活[src]."))
		playsound(src, 'sound/effects/seedling_chargeup.ogg', 100, TRUE, -6)
		apply_wibbly_filters(user)
		if (do_after(user, 50, target=user) && user.cell.use(activationCost))
			playsound(src, 'sound/effects/bamf.ogg', 100, TRUE, -6)
			to_chat(user, span_notice("你现在伪装成了纳米工程赛博\"[friendlyName]\"."))
			activate(user)
		else
			to_chat(user, span_warning("变色龙场失效."))
			do_sparks(3, FALSE, user)
		remove_wibbly_filters(user)
		animation_playing = FALSE

/obj/item/borg_chameleon/process()
	if (user)
		if (!user.cell || !user.cell.use(activationUpkeep))
			disrupt(user)
	else
		return PROCESS_KILL

/obj/item/borg_chameleon/proc/activate(mob/living/silicon/robot/user)
	START_PROCESSING(SSobj, src)
	src.user = user
	savedName = user.name
	user.name = friendlyName
	user.model.cyborg_base_icon = disguise
	user.model.name = capitalize(disguise)
	user.bubble_icon = "robot"
	active = TRUE
	user.update_icons()

	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, signalCache)
	RegisterSignals(user, signalCache, PROC_REF(disrupt))
	listeningTo = user

/obj/item/borg_chameleon/proc/deactivate(mob/living/silicon/robot/user)
	STOP_PROCESSING(SSobj, src)
	if(listeningTo)
		UnregisterSignal(listeningTo, signalCache)
		listeningTo = null
	do_sparks(5, FALSE, user)
	user.name = savedName
	user.model.cyborg_base_icon = initial(user.model.cyborg_base_icon)
	user.model.name = initial(user.model.name)
	user.bubble_icon = "syndibot"
	active = FALSE
	user.update_icons()
	src.user = user

/obj/item/borg_chameleon/proc/disrupt(mob/living/silicon/robot/user)
	SIGNAL_HANDLER
	if(active)
		to_chat(user, span_danger("你的变色龙场失效了."))
		deactivate(user)
