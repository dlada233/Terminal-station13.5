/obj/item/clothing/head
	name = BODY_ZONE_HEAD
	icon = 'icons/obj/clothing/head/default.dmi'
	worn_icon = 'icons/mob/clothing/head/default.dmi'
	lefthand_file = 'icons/mob/inhands/clothing/hats_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/hats_righthand.dmi'
	body_parts_covered = HEAD
	slot_flags = ITEM_SLOT_HEAD

///特殊的throw_impact用于将帽子像飞盘一样扔向人，使它们戴在头上/尝试脱掉他们的帽子.
/obj/item/clothing/head/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	. = ..()
	///如果投掷物的目标区域不是头部
	if(thrownthing.target_zone != BODY_ZONE_HEAD)
		return
	///忽略任何启用了防锡纸措施的帽子
	if(clothing_flags & ANTI_TINFOIL_MANEUVER)
		return
	///如果帽子可以容纳物品并且里面有东西.主要是为了防止像把小型炸弹塞进帽子然后扔出去这样的超级作弊行为
	if(LAZYLEN(contents))
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/H = hit_atom
		if(istype(H.head, /obj/item))
			var/obj/item/WH = H.head
			///检查物品是否有NODROP
			if(HAS_TRAIT(WH, TRAIT_NODROP))
				H.visible_message(span_warning("[src] 从 [H] 的 [WH.name] 上弹开了！"), span_warning("[src] 从你的 [WH.name] 上弹开，掉到地上."))
				return
			///检查物品是否为实际的头部衣物，因为有些非衣物的物品也可以穿戴
			if(istype(WH, /obj/item/clothing/head))
				var/obj/item/clothing/head/WHH = WH
				///贴合的帽子不能被击落
				if(WHH.clothing_flags & SNUG_FIT)
					H.visible_message(span_warning("[src] 从 [H] 的 [WHH.name] 上弹开了！"), span_warning("[src] 从你的 [WHH.name] 上弹开，掉到地上."))
					return
			///如果帽子设法击落了某物
			if(H.dropItemToGround(WH))
				H.visible_message(span_warning("[src] 将 [WH] 从 [H] 的头上击落了！"), span_warning("[WH] 突然被 [src] 从你头上击落了！"))
		if(H.equip_to_slot_if_possible(src, ITEM_SLOT_HEAD, 0, 1, 1))
			H.visible_message(span_notice("[src] 整齐地落在 [H] 的头上！"), span_notice("[src] 完美地落在你头上！"))
			H.update_held_items() //强制更新手部以防止在投掷模式下出现幽灵精灵
		return
	if(iscyborg(hit_atom))
		var/mob/living/silicon/robot/R = hit_atom
		var/obj/item/worn_hat = R.hat
		if(worn_hat && HAS_TRAIT(worn_hat, TRAIT_NODROP))
			R.visible_message(span_warning("[src] 从 [worn_hat] 上弹开，没有效果！"), span_warning("[src] 从你强大的 [worn_hat.name] 上弹开，掉到地上."))
			return
		if(is_type_in_typecache(src, GLOB.blacklisted_borg_hats))//在机器人的黑名单中的帽子会弹开
			R.visible_message(span_warning("[src] 从 [R] 上弹开了！"), span_warning("[src] 从你身上弹开，掉到地上."))
			return
		else
			R.visible_message(span_notice("[src] 整齐地落在 [R] 上！"), span_notice("[src] 完美地落在你头上！"))
			R.place_on_head(src) //帽子并不是设计成紧贴机器人头部的，所以它们总是会设法互相击落




/obj/item/clothing/head/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damagedhelmet")
	if(GET_ATOM_BLOOD_DNA_LENGTH(src))
		if(clothing_flags & LARGE_WORN_ICON)
			. += mutable_appearance('icons/effects/64x64.dmi', "helmetblood_large")
		else
			. += mutable_appearance('icons/effects/blood.dmi', "helmetblood")

/obj/item/clothing/head/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_worn_head()
