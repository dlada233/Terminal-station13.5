/obj/item/stack/sticky_tape
	name = "胶带"
	singular_name = "胶带"
	desc = "可以贴在物品上使得物品具有粘性."
	icon = 'icons/obj/tapes.dmi'
	icon_state = "tape"
	var/prefix = "sticky"
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	amount = 5
	max_amount = 5
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 5)
	splint_factor = 0.65
	merge_type = /obj/item/stack/sticky_tape
	var/list/conferred_embed = EMBED_HARMLESS
	///The tape type you get when ripping off a piece of tape.
	var/obj/tape_gag = /obj/item/clothing/mask/muzzle/tape
	greyscale_config = /datum/greyscale_config/tape
	greyscale_colors = "#B2B2B2#BD6A62"

/obj/item/stack/sticky_tape/attack_hand(mob/user, list/modifiers)
	if(user.get_inactive_held_item() == src)
		if(is_zero_amount(delete_if_zero = TRUE))
			return
		playsound(user, 'sound/items/duct_tape_rip.ogg', 50, TRUE)
		if(!do_after(user, 1 SECONDS))
			return
		var/new_tape_gag = new tape_gag(src)
		user.put_in_hands(new_tape_gag)
		use(1)
		to_chat(user, span_notice("You rip off a piece of tape."))
		playsound(user, 'sound/items/duct_tape_snap.ogg', 50, TRUE)
		return TRUE
	return ..()

/obj/item/stack/sticky_tape/examine(mob/user)
	. = ..()
	. += "[span_notice("You could rip a piece off by using an empty hand.")]"

/obj/item/stack/sticky_tape/interact_with_atom(obj/item/target, mob/living/user, list/modifiers)
	if(!isitem(target))
		return NONE

	if(target.embedding && target.embedding == conferred_embed)
		to_chat(user, span_warning("[target] is already coated in [src]!"))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice("[user] begins wrapping [target] with [src]."), span_notice("You begin wrapping [target] with [src]."))
	playsound(user, 'sound/items/duct_tape_rip.ogg', 50, TRUE)

	if(do_after(user, 3 SECONDS, target=target))
		playsound(user, 'sound/items/duct_tape_snap.ogg', 50, TRUE)
		use(1)
		if(istype(target, /obj/item/clothing/gloves/fingerless))
			var/obj/item/clothing/gloves/tackler/offbrand/O = new /obj/item/clothing/gloves/tackler/offbrand
			to_chat(user, span_notice("You turn [target] into [O] with [src]."))
			QDEL_NULL(target)
			user.put_in_hands(O)
			return ITEM_INTERACT_SUCCESS

		if(target.embedding && target.embedding == conferred_embed)
			to_chat(user, span_warning("[target] is already coated in [src]!"))
			return ITEM_INTERACT_BLOCKING

		target.embedding = conferred_embed
		target.updateEmbedding()
		to_chat(user, span_notice("You finish wrapping [target] with [src]."))
		target.name = "[prefix] [target.name]"

		if(isgrenade(target))
			var/obj/item/grenade/sticky_bomb = target
			sticky_bomb.sticky = TRUE

	return ITEM_INTERACT_SUCCESS

/obj/item/stack/sticky_tape/super
	name = "超级胶带"
	singular_name = "超级胶带"
	desc = "可能是银河系中邪恶的物品，使用时请极度谨慎."
	prefix = "super sticky"
	conferred_embed = EMBED_HARMLESS_SUPERIOR
	splint_factor = 0.4
	merge_type = /obj/item/stack/sticky_tape/super
	greyscale_colors = "#4D4D4D#75433F"
	tape_gag = /obj/item/clothing/mask/muzzle/tape/super

/obj/item/stack/sticky_tape/pointy
	name = "尖锐胶带"
	singular_name = "尖锐胶带"
	desc = "胶带上带有倒刺，粘到人体上并在撕下时造成二次伤害."
	icon_state = "tape_spikes"
	prefix = "pointy"
	conferred_embed = EMBED_POINTY
	merge_type = /obj/item/stack/sticky_tape/pointy
	greyscale_config = /datum/greyscale_config/tape/spikes
	greyscale_colors = "#E64539#808080#AD2F45"
	tape_gag = /obj/item/clothing/mask/muzzle/tape/pointy

/obj/item/stack/sticky_tape/pointy/super
	name = "超级尖锐胶带"
	singular_name = "超级尖锐胶带"
	desc = "你都不知道胶带能有这么险恶. Welcome to Space Station 13."
	prefix = "super pointy"
	conferred_embed = EMBED_POINTY_SUPERIOR
	merge_type = /obj/item/stack/sticky_tape/pointy/super
	greyscale_colors = "#8C0A00#4F4F4F#300008"
	tape_gag = /obj/item/clothing/mask/muzzle/tape/pointy/super

/obj/item/stack/sticky_tape/surgical
	name = "手术胶带"
	singular_name = "手术胶带"
	desc = "配合骨胶修复骨折的骨头，不是用来恶作剧的."
	prefix = "surgical"
	conferred_embed = list("embed_chance" = 30, "pain_mult" = 0, "jostle_pain_mult" = 0, "ignore_throwspeed_threshold" = TRUE)
	splint_factor = 0.5
	custom_price = PAYCHECK_CREW
	merge_type = /obj/item/stack/sticky_tape/surgical
	greyscale_colors = "#70BAE7#BD6A62"
	tape_gag = /obj/item/clothing/mask/muzzle/tape/surgical

/obj/item/stack/sticky_tape/surgical/get_surgery_tool_overlay(tray_extended)
	return "tape" + (tray_extended ? "" : "_out")
