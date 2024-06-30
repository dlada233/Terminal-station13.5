//CONTAINS: Evidence bags

/obj/item/evidencebag
	name = "证物袋"
	desc = "空的证物袋."
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "evidenceobj"
	inhand_icon_state = ""
	w_class = WEIGHT_CLASS_TINY

/obj/item/evidencebag/afterattack(obj/item/I, mob/user,proximity)
	. = ..()
	if(!proximity || loc == I)
		return
	evidencebagEquip(I, user)
	return . | AFTERATTACK_PROCESSED_ITEM

/obj/item/evidencebag/attackby(obj/item/I, mob/user, params)
	if(evidencebagEquip(I, user))
		return 1

/obj/item/evidencebag/Exited(atom/movable/gone, direction)
	. = ..()
	cut_overlays()
	update_weight_class(initial(w_class))
	icon_state = initial(icon_state)
	desc = initial(desc)

/obj/item/evidencebag/proc/evidencebagEquip(obj/item/I, mob/user)
	if(!istype(I) || I.anchored)
		return

	if(loc.atom_storage && I.atom_storage)
		to_chat(user, span_warning("不管你怎么试，你都没法把[I]放到[src]里面."))
		return TRUE //begone infinite storage ghosts, begone from me

	if(HAS_TRAIT(I, TRAIT_NO_STORAGE_INSERT))
		to_chat(user, span_warning("不管你怎么试，你都没法把[I]放到[src]里面."))
		return TRUE

	if(istype(I, /obj/item/evidencebag))
		to_chat(user, span_warning("你觉得把一个证物袋放进另一个证物袋的做法有点荒谬."))
		return TRUE //now this is podracing

	if(loc in I.get_all_contents()) // fixes tg #39452, evidence bags could store their own location, causing I to be stored in the bag while being present inworld still, and able to be teleported when removed.
		to_chat(user, span_warning("你会发现，当[I]还在[src]里面的时候，把[I]放到[src]里面是非常困难的!"))
		return

	if(I.w_class > WEIGHT_CLASS_NORMAL)
		to_chat(user, span_warning("[I]不能装进[src]!"))
		return

	if(contents.len)
		to_chat(user, span_warning("[src]已经装了东西了!"))
		return

	if(!isturf(I.loc)) //If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(I.loc.atom_storage) //in a container.
			I.loc.atom_storage.remove_single(user, I, src)
		if(!user.is_holding(I) || HAS_TRAIT(I, TRAIT_NODROP))
			return

	if(QDELETED(I))
		return

	user.visible_message(span_notice("[user]把[I]放进[src]."), span_notice("你把[I]放进[src]."),\
	span_hear("你听到有人把东西放进塑料袋的沙沙声."))

	icon_state = "evidence"

	var/mutable_appearance/in_evidence = new(I)
	in_evidence.plane = FLOAT_PLANE
	in_evidence.layer = FLOAT_LAYER
	in_evidence.pixel_x = 0
	in_evidence.pixel_y = 0
	add_overlay(in_evidence)
	add_overlay("evidence") //should look nicer for transparent stuff. not really that important, but hey.

	desc = "一个包含[I]的证物袋. [I.desc]"
	I.forceMove(src)
	update_weight_class(I.w_class)
	return 1

/obj/item/evidencebag/attack_self(mob/user)
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message(span_notice("[user]从[src]拿出[I]."), span_notice("[user]从[src]拿出[I]"),\
		span_hear("你听到有人捣鼓塑料袋的声音，似乎是从里面拿走了一些东西."))
		cut_overlays() //remove the overlays
		user.put_in_hands(I)
		update_weight_class(WEIGHT_CLASS_TINY)
		icon_state = "evidenceobj"
		desc = "一个空的证据袋."

	else
		to_chat(user, span_notice("[src]是空的."))
		icon_state = "evidenceobj"
	return

/obj/item/storage/box/evidence
	name = "证物袋盒"
	desc = "一个装着证物袋的盒子."

/obj/item/storage/box/evidence/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/evidencebag(src)
