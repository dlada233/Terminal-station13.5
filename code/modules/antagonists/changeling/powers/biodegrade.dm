/datum/action/changeling/biodegrade
	name = "生物降解"
	desc = "溶解束缚物或其他阻碍移动的物体，需要花费30点化学物质."
	helptext = "标准的束缚物甚至锁柜都可以被溶解，但缺点是很容易被附近的人察觉到."
	button_icon_state = "biodegrade"
	chemical_cost = 30 //High cost to prevent spam
	dna_cost = 2
	req_human = TRUE
	disabled_by_fire = FALSE

/datum/action/changeling/biodegrade/sting_action(mob/living/carbon/human/user)
	if(user.handcuffed)
		var/obj/O = user.get_item_by_slot(ITEM_SLOT_HANDCUFFED)
		if(!istype(O))
			return FALSE
		user.visible_message(span_warning("[user]吐出一团酸性物质到[O]上!"), \
			span_warning("我们吐出酸性黏液到束缚物上!"))

		addtimer(CALLBACK(src, PROC_REF(dissolve_handcuffs), user, O), 3 SECONDS)
		log_combat(user, user.handcuffed, "溶解手铐", addition = "(生物降解)")
		..()
		return TRUE

	if(user.legcuffed)
		var/obj/O = user.get_item_by_slot(ITEM_SLOT_LEGCUFFED)
		if(!istype(O))
			return FALSE
		user.visible_message(span_warning("[user]吐出一团酸性物质到[O]上!"), \
			span_warning("我们吐出酸性黏液到束缚物上!"))

		addtimer(CALLBACK(src, PROC_REF(dissolve_legcuffs), user, O), 3 SECONDS)
		log_combat(user, user.legcuffed, "溶解脚镣", addition = "(生物降解)")
		..()
		return TRUE

	if(user.wear_suit?.breakouttime)
		var/obj/item/clothing/suit/S = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		if(!istype(S))
			return FALSE
		user.visible_message(span_warning("[user]吐出一团酸性物质到[S]上!"), \
			span_warning("我们把酸性黏液吐到[user.wear_suit.name]上!"))
		addtimer(CALLBACK(src, PROC_REF(dissolve_straightjacket), user, S), 3 SECONDS)
		log_combat(user, user.wear_suit, "溶解[user.wear_suit]", addition = "(生物降解)")
		..()
		return TRUE

	if(istype(user.loc, /obj/structure/closet))
		var/obj/structure/closet/C = user.loc
		if(!istype(C))
			return FALSE
		C.visible_message(span_warning("[C]的铰链突然开始融化并松动!"))
		to_chat(user, span_warning("我们把酸性黏液吐到[C]上!"))
		addtimer(CALLBACK(src, PROC_REF(open_closet), user, C), 7 SECONDS)
		log_combat(user, user.loc, "溶解锁柜", addition = "(生物降解)")
		..()
		return TRUE

	if(istype(user.loc, /obj/structure/spider/cocoon))
		var/obj/structure/spider/cocoon/C = user.loc
		if(!istype(C))
			return FALSE
		C.visible_message(span_warning("[src]发生变化并开始分崩离析!"))
		to_chat(user, span_warning("我们从皮肤中分泌酸性酶以溶解束缚我们的茧..."))
		addtimer(CALLBACK(src, PROC_REF(dissolve_cocoon), user, C), 25) //Very short because it's just webs
		log_combat(user, user.loc, "溶解茧", addition = "(生物降解)")
		..()
		return TRUE

	var/obj/item/clothing/shoes/shoes = user.shoes
	if(istype(shoes) && shoes.tied == SHOES_KNOTTED && !(shoes.resistance_flags & (INDESTRUCTIBLE|UNACIDABLE|ACID_PROOF)))
		new /obj/effect/decal/cleanable/greenglow(shoes.drop_location())
		user.visible_message(
			span_warning("[user]分泌出酸性黏液到[shoes.name]上，将它溶解成了一摊黏糊糊的东西!"),
			span_warning("我们分泌出酸性黏液到[shoes.name]上，将它溶解成了一摊黏糊糊的东西!"),
		)
		log_combat(user, shoes, "溶解了自己的鞋子", addition = "(生物降解)")
		qdel(shoes)
		..()
		return TRUE

	user.balloon_alert(user, "没有被束缚!")
	return FALSE

/datum/action/changeling/biodegrade/proc/dissolve_handcuffs(mob/living/carbon/human/user, obj/O)
	if(O && user.handcuffed == O)
		user.visible_message(span_warning("[O]溶化成一摊滋滋作响的黏液."))
		new /obj/effect/decal/cleanable/greenglow(O.drop_location())
		qdel(O)

/datum/action/changeling/biodegrade/proc/dissolve_legcuffs(mob/living/carbon/human/user, obj/O)
	if(O && user.legcuffed == O)
		user.visible_message(span_warning("[O]溶化成一摊滋滋作响的黏液."))
		new /obj/effect/decal/cleanable/greenglow(O.drop_location())
		qdel(O)

/datum/action/changeling/biodegrade/proc/dissolve_straightjacket(mob/living/carbon/human/user, obj/S)
	if(S && user.wear_suit == S)
		user.visible_message(span_warning("[S]溶化成一摊滋滋作响的黏液."))
		new /obj/effect/decal/cleanable/greenglow(S.drop_location())
		qdel(S)

/datum/action/changeling/biodegrade/proc/open_closet(mob/living/carbon/human/user, obj/structure/closet/C)
	if(C && user.loc == C)
		C.visible_message(span_warning("[C]的门分崩离析!"))
		new /obj/effect/decal/cleanable/greenglow(C.drop_location())
		C.welded = FALSE
		C.locked = FALSE
		C.broken = TRUE
		C.open()
		to_chat(user, span_warning("我们打开了关住我们的容器!"))

/datum/action/changeling/biodegrade/proc/dissolve_cocoon(mob/living/carbon/human/user, obj/structure/spider/cocoon/C)
	if(C && user.loc == C)
		new /obj/effect/decal/cleanable/greenglow(C.drop_location())
		qdel(C) //The cocoon's destroy will move the changeling outside of it without interference
		to_chat(user, span_warning("我们溶解了茧!"))
