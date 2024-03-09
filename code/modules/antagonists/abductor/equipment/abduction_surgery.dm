/datum/surgery/organ_extraction
	name = "实验性器官移植"
	possible_locs = list(BODY_ZONE_CHEST)
	surgery_flags = SURGERY_IGNORE_CLOTHES | SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/extract_organ,
		/datum/surgery_step/gland_insert,
	)

/datum/surgery/organ_extraction/can_start(mob/user, mob/living/carbon/target)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna.species.id == SPECIES_ABDUCTOR)
		return TRUE
	for(var/obj/item/implant/abductor/A in H.implants)
		return TRUE
	return FALSE


/datum/surgery_step/extract_organ
	name = "摘除器官"
	accept_hand = 1
	time = 32
	var/obj/item/organ/IC = null
	var/list/organ_types = list(/obj/item/organ/internal/heart)

/datum/surgery_step/extract_organ/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	for(var/atom/A in target.organs)
		if(A.type in organ_types)
			IC = A
			break
	user.visible_message(span_notice("[user]开始摘除[target]的器官."), span_notice("你开始摘除[target]的器官..."))

/datum/surgery_step/extract_organ/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(IC)
		user.visible_message(span_notice("[user]从[target]的[target_zone]中取出[IC]!"), span_notice("你从[target]的[target_zone]中取出[IC]."))
		user.put_in_hands(IC)
		IC.Remove(target)
		return 1
	else
		to_chat(user, span_warning("你在[target]里[target_zone]找不到任何东西!"))
		return 1

/datum/surgery_step/gland_insert
	name = "植入腺体"
	implements = list(/obj/item/organ/internal/heart/gland = 100)
	time = 32

/datum/surgery_step/gland_insert/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message(span_notice("[user]开始植入[tool]到[target]体内."), span_notice("你开始植入[tool]到[target]体内..."))

/datum/surgery_step/gland_insert/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message(span_notice("[user]植入了[tool]到[target]体内."), span_notice("你开始植入[tool]到[target]体内."))
	user.temporarilyRemoveItemFromInventory(tool, TRUE)
	var/obj/item/organ/internal/heart/gland/gland = tool
	gland.Insert(target, 2)
	return 1
