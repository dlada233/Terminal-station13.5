/obj/item/clothing/neck/heretic_focus
	name = "聚焦琥珀"
	desc = "一块琥珀透镜，通向了世界之外. 用余光望去时，项链似乎在抽动."
	icon_state = "eldritch_necklace"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/heretic_focus/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/heretic_focus)

/obj/item/clothing/neck/eldritch_amulet
	name = "温暖的邪术勋章"
	desc = "一枚奇怪的奖章. 视线透过晶莹的表面，周遭的世界渐渐远去. 你看到了自己的心脏，同千万的其他心脏一齐脉动."
	icon = 'icons/obj/antags/eldritch.dmi'
	icon_state = "eye_medalion"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	/// A secondary clothing trait only applied to heretics.
	var/heretic_only_trait = TRAIT_THERMAL_VISION

/obj/item/clothing/neck/eldritch_amulet/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/heretic_focus)

/obj/item/clothing/neck/eldritch_amulet/equipped(mob/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_NECK))
		return
	if(!ishuman(user) || !IS_HERETIC_OR_MONSTER(user))
		return

	ADD_TRAIT(user, heretic_only_trait, "[CLOTHING_TRAIT]_[REF(src)]")
	user.update_sight()

/obj/item/clothing/neck/eldritch_amulet/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, heretic_only_trait, "[CLOTHING_TRAIT]_[REF(src)]")
	user.update_sight()

/obj/item/clothing/neck/eldritch_amulet/piercing
	name = "冰冷的邪术勋章"
	desc = "一枚奇怪的奖章. 视线透过晶莹的表面，光线折射出骇人的色谱，你看到自己在绵延不绝的镜子上的倒影，被扭曲成不可能的形状."
	heretic_only_trait = TRAIT_XRAY_VISION

// Cosmetic-only version
/obj/item/clothing/neck/fake_heretic_amulet
	name = "宗教符像"
	desc = "一枚奇怪的奖章，让佩戴者看起来像是邪教成员."
	icon = 'icons/obj/antags/eldritch.dmi'
	icon_state = "eye_medalion"
	w_class = WEIGHT_CLASS_SMALL


// The amulet conversion tool used by moon heretics
/obj/item/clothing/neck/heretic_focus/moon_amulet
	name = "月光护符"
	desc = "凝结着心田、灵魂与月亮的碎片，凝视它会让你头晕目眩，耳边也会泛起笑声与喜悦的低语."
	icon = 'icons/obj/antags/eldritch.dmi'
	icon_state = "moon_amulette"
	w_class = WEIGHT_CLASS_SMALL
	// How much damage does this item do to the targets sanity?
	var/sanity_damage = 20

/obj/item/clothing/neck/heretic_focus/moon_amulet/attack(mob/living/target, mob/living/user, params)
	var/mob/living/carbon/human/hit = target
	if(!IS_HERETIC_OR_MONSTER(user))
		user.balloon_alert(user, "你感到有人在看着你.")
		user.add_mood_event("月光护符的疯狂", /datum/mood_event/amulet_insanity)
		user.mob_mood.set_sanity(user.mob_mood.sanity - 50)
		return
	if(hit.can_block_magic())
		return
	if(!hit.mob_mood)
		return
	if(hit.mob_mood.sanity_level < SANITY_LEVEL_UNSTABLE)
		user.balloon_alert(user, "他的心灵太过强大!")
		hit.add_mood_event("月光护符的疯狂", /datum/mood_event/amulet_insanity)
		hit.mob_mood.set_sanity(hit.mob_mood.sanity - sanity_damage)
	else
		user.balloon_alert(user, "他的心灵已经曲向了真相!")
		hit.apply_status_effect(/datum/status_effect/moon_converted)
		user.log_message("使[target]发疯.", LOG_GAME)
		hit.log_message("被[user]驱使而发疯.")
	. = ..()
