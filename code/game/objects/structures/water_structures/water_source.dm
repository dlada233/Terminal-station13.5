//Water source, use the type water_source for unlimited water sources like classic sinks.
/obj/structure/water_source
	name = "水源"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "一个用于洗手洗脸的水槽，看起来好像是无限供应的"
	anchored = TRUE
	///Boolean on whether something is currently being washed, preventing multiple people from cleaning at once.
	var/busy = FALSE
	///The reagent that is dispensed from this source, by default it's water.
	var/datum/reagent/dispensedreagent = /datum/reagent/water

/obj/structure/water_source/Initialize(mapload)
	. = ..()
	create_reagents(INFINITY, NO_REACT)
	reagents.add_reagent(dispensedreagent, INFINITY)

/obj/structure/water_source/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!iscarbon(user))
		return
	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, span_warning("已经有人在这里洗东西了!"))
		return
	var/selected_area = user.parse_zone_with_bodypart(user.zone_selected)
	var/washing_face = FALSE
	if(selected_area in list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_EYES))
		washing_face = TRUE
	user.visible_message(
		span_notice("[user]开始清洗自己的[washing_face ? "脸部" : "双手"]..."),
		span_notice("你开始清洗[washing_face ? "脸部" : "双手"]..."))
	busy = TRUE

	if(!do_after(user, 4 SECONDS, target = src))
		busy = FALSE
		return

	busy = FALSE

	if(washing_face)
		SEND_SIGNAL(user, COMSIG_COMPONENT_CLEAN_FACE_ACT, CLEAN_WASH)
	else if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(!human_user.wash_hands(CLEAN_WASH))
			to_chat(user, span_warning("你的手被什么东西盖住了!"))
			return
	else
		user.wash(CLEAN_WASH)

	user.visible_message(
		span_notice("[user]用[src]清洗自己的[washing_face ? "脸部" : "双手"]."),
		span_notice("你用[src]清洗[washing_face ? "脸部" : "双手"]."),
	)

/obj/structure/water_source/attackby(obj/item/attacking_item, mob/living/user, params)
	if(busy)
		to_chat(user, span_warning("已经有人在这里洗东西了!"))
		return

	if(attacking_item.item_flags & ABSTRACT) //Abstract items like grabs won't wash. No-drop items will though because it's still technically an item in your hand.
		return

	if(is_reagent_container(attacking_item))
		var/obj/item/reagent_containers/container = attacking_item
		if(container.is_refillable())
			if(!container.reagents.holder_full())
				container.reagents.add_reagent(dispensedreagent, min(container.volume - container.reagents.total_volume, container.amount_per_transfer_from_this))
				to_chat(user, span_notice("你从[src]处灌装[container]."))
				return TRUE
			to_chat(user, span_notice("[container]是满得."))
			return FALSE

	if(istype(attacking_item, /obj/item/melee/baton/security))
		var/obj/item/melee/baton/security/baton = attacking_item
		if(baton.cell?.charge && baton.active)
			flick("baton_active", src)
			user.Paralyze(baton.knockdown_time)
			user.set_stutter(baton.knockdown_time)
			baton.cell.use(baton.cell_hit_cost)
			user.visible_message(
				span_warning("[user]在尝试清洗手中的[baton.name]时触电了!"),
				span_userdanger("你不明智地在[baton]开启时清洗了它."))
			playsound(src, baton.on_stun_sound, 50, TRUE)
			return

	if(istype(attacking_item, /obj/item/mop))
		attacking_item.reagents.add_reagent(dispensedreagent, 5)
		to_chat(user, span_notice("你在[src]里打湿[attacking_item]."))
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
		return

	if(istype(attacking_item, /obj/item/stack/medical/gauze))
		var/obj/item/stack/medical/gauze/G = attacking_item
		new /obj/item/reagent_containers/cup/rag(loc)
		to_chat(user, span_notice("你撕下一条纱布，做成了一块抹布."))
		G.use(1)
		return

	if(istype(attacking_item, /obj/item/stack/sheet/cloth))
		var/obj/item/stack/sheet/cloth/cloth = attacking_item
		new /obj/item/reagent_containers/cup/rag(loc)
		to_chat(user, span_notice("你撕下一块布条，做成了一块抹布."))
		cloth.use(1)
		return

	if(istype(attacking_item, /obj/item/stack/ore/glass))
		new /obj/item/stack/sheet/sandblock(loc)
		to_chat(user, span_notice("你把水槽里的沙子弄湿，然后捏成了一块."))
		attacking_item.use(1)
		return

	if(!user.combat_mode)
		to_chat(user, span_notice("你开始清洗[attacking_item]..."))
		busy = TRUE
		if(!do_after(user, 4 SECONDS, target = src))
			busy = FALSE
			return TRUE
		busy = FALSE
		attacking_item.wash(CLEAN_WASH)
		reagents.expose(attacking_item, TOUCH, 5 / max(reagents.total_volume, 5))
		user.visible_message(
			span_notice("[user]用[src]清洗了[attacking_item]."),
			span_notice("你用[src]清洗了[attacking_item]."))
		return TRUE

	return ..()

/obj/structure/water_source/puddle //splishy splashy ^_^
	name = "水坑"
	desc = "可以洗手和洗脸的水坑."
	icon_state = "puddle"
	base_icon_state = "puddle"
	resistance_flags = UNACIDABLE

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/structure/water_source/puddle/attack_hand(mob/user, list/modifiers)
	icon_state = "[base_icon_state]-splash"
	. = ..()
	icon_state = base_icon_state

/obj/structure/water_source/puddle/attackby(obj/item/attacking_item, mob/user, params)
	icon_state = "[base_icon_state]-splash"
	. = ..()
	icon_state = base_icon_state
