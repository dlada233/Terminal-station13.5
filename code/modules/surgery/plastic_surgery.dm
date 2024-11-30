/// Disk containing info for doing advanced plastic surgery. Spawns in maint and available as a role-restricted item in traitor uplinks.
/obj/item/disk/surgery/advanced_plastic_surgery
	name = "高级整形手术软盘"
	desc = "该磁盘提供了进行高级整形手术的指南，此手术允许人们使用另一人的照片完全重塑某人的面部. 在重塑面部时，他们需要在副手中持有该人的照片.随着基因技术的兴起，这种手术早已变得过时.此物品已成为许多收藏家的古董，而在大多数地方，只有更便宜且更简单的整形手术基本形式仍在使用."
	surgeries = list(/datum/surgery/plastic_surgery/advanced)

/datum/surgery/plastic_surgery
	name = "整形手术"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB | SURGERY_MORBID_CURIOSITY
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/reshape_face,
		/datum/surgery_step/close,
	)

/datum/surgery/plastic_surgery/advanced
	name = "高级整形手术"
	desc = "此手术允许人们使用另一人的照片完全重塑某人的面部. 在重塑面部时，他们需要在副手中持有该人的照片."
	requires_tech = TRUE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/insert_plastic,
		/datum/surgery_step/reshape_face,
		/datum/surgery_step/close,
	)

//Insert plastic step, It ain't called plastic surgery for nothing! :)
/datum/surgery_step/insert_plastic
	name = "插入塑料 (塑料)"
	implements = list(
		/obj/item/stack/sheet/plastic = 100,
		/obj/item/stack/sheet/meat = 100)
	time = 3.2 SECONDS
	preop_sound = 'sound/effects/blobattack.ogg'
	success_sound = 'sound/effects/attackblob.ogg'
	failure_sound = 'sound/effects/blobattack.ogg'

/datum/surgery_step/insert_plastic/preop(mob/user, mob/living/target, target_zone, obj/item/stack/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始将[tool]插入[target]的[target.parse_zone_with_bodypart(target_zone)]切口中..."),
		span_notice("[user]开始将[tool]插入[target]的[target.parse_zone_with_bodypart(target_zone)]切口中."),
		span_notice("[user]开始将[tool]插入[target]的[target.parse_zone_with_bodypart(target_zone)]切口中."),
	)
	display_pain(target, "你感到有什么东西正在你的[target.parse_zone_with_bodypart(target_zone)]皮肤下插入.")

/datum/surgery_step/insert_plastic/success(mob/user, mob/living/target, target_zone, obj/item/stack/tool, datum/surgery/surgery, default_display_results)
	. = ..()
	tool.use(1)

//reshape_face
/datum/surgery_step/reshape_face
	name = "重塑面部 (手术刀)"
	implements = list(
		TOOL_SCALPEL = 100,
		/obj/item/knife = 50,
		TOOL_WIRECUTTER = 35)
	time = 64
	surgery_effects_mood = TRUE

/datum/surgery_step/reshape_face/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message(span_notice("[user]开始改变[target]的外貌."), span_notice("你开始改变[target]的外貌..."))
	display_results(
		user,
		target,
		span_notice("你开始改变[target]的外貌..."),
		span_notice("[user]开始改变[target]的外貌."),
		span_notice("[user]开始在[target]的脸上做切口."),
	)
	display_pain(target, "你感到脸上传来切割般的疼痛！")

/datum/surgery_step/reshape_face/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(HAS_TRAIT_FROM(target, TRAIT_DISFIGURED, TRAIT_GENERIC))
		REMOVE_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
		display_results(
			user,
			target,
			span_notice("你成功地恢复了[target]的外貌."),
			span_notice("[user]成功地恢复了[target]的外貌！"),
			span_notice("[user]完成了对[target]脸部的手术."),
		)
		display_pain(target, "疼痛消失了，你的脸再次感觉正常了！")
	else
		var/list/names = list()
		if(!isabductor(user))
			var/obj/item/offhand = user.get_inactive_held_item()
			if(istype(offhand, /obj/item/photo) && istype(surgery, /datum/surgery/plastic_surgery/advanced))
				var/obj/item/photo/disguises = offhand
				for(var/namelist as anything in disguises.picture?.names_seen)
					names += namelist
			else
				user.visible_message(span_warning("你没有照片来作为外貌的基础，将恢复为随机外貌."))
				for(var/i in 1 to 10)
					names += target.generate_random_mob_name(TRUE)
		else
			for(var/j in 1 to 9)
				names += "Subject [target.gender == MALE ? "i" : "o"]-[pick("a", "b", "c", "d", "e")]-[rand(10000, 99999)]"
			names += target.generate_random_mob_name(TRUE) //give one normal name in case they want to do regular plastic surgery
		var/chosen_name = tgui_input_list(user, "分配的新名字", "整形手术", names)
		if(isnull(chosen_name))
			return
		var/oldname = target.real_name
		target.real_name = chosen_name
		var/newname = target.real_name //something about how the code handles names required that I use this instead of target.real_name
		display_results(
			user,
			target,
			span_notice("你彻底改变了[oldname]的外貌，此人现在是[newname]."),
			span_notice("[user]彻底改变了[oldname]的外貌，此人现在是[newname]！"),
			span_notice("[user]完成了对[target]脸部的手术."),
		)
		display_pain(target, "疼痛消失了，你的脸感觉全新且陌生！")
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		human_target.sec_hud_set_ID()
	if(HAS_MIND_TRAIT(user, TRAIT_MORBID) && ishuman(user))
		var/mob/living/carbon/human/morbid_weirdo = user
		morbid_weirdo.add_mood_event("morbid_abominable_surgery_success", /datum/mood_event/morbid_abominable_surgery_success)
	return ..()

/datum/surgery_step/reshape_face/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("你搞砸了，导致[target]的外貌变得丑陋！"),
		span_notice("[user]搞砸了，使[target]的外貌变得丑陋！"),
		span_notice("[user]完成了对[target]脸部的手术."),
	)
	display_pain(target, "你的脸感觉可怕地留下了疤痕和畸形！")
	ADD_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
	return FALSE
