/obj/item/disk/surgery/brainwashing
	name = "手术软盘" //SKYRAT EDIT: Formerly "Brainwashing Surgery Disk" //Finally I can upload the funny surgery disk without letting everyone in the room know about it!
	desc = "软盘上有关于某种手术的说明，但是标签已经被刮掉了..." //Skyrat edit: Moved to Special Desc.
	surgeries = list(/datum/surgery/advanced/brainwashing)
	special_desc_requirement = EXAMINE_CHECK_JOB // SKYRAT EDIT
	special_desc_jobs = list("医生, 首席医疗官, 机械学家") // SKYRAT EDIT CHANGE //You mean to tell me the roles that get this role-exclusive item know what it does?
	special_desc = "这张软盘提供了如何在大脑中植入指令的说明，让被植入者不惜一切代价地遵守指令."

/datum/surgery/advanced/brainwashing
	name = "洗脑"
	desc = "将指令植入大脑，被植入者将不惜一切代价地遵守指令，植入心盾可以清除它."
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/brainwash,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/brainwashing/can_start(mob/user, mob/living/carbon/target)
	if(!..())
		return FALSE
	var/obj/item/organ/internal/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE
	return TRUE

/datum/surgery_step/brainwash
	name = "洗脑 (止血钳)"
	implements = list(
		TOOL_HEMOSTAT = 85,
		TOOL_WIRECUTTER = 50,
		/obj/item/stack/package_wrap = 35,
		/obj/item/stack/cable_coil = 15)
	time = 200
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	var/objective

/datum/surgery_step/brainwash/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	objective = tgui_input_text(user, "选择要在手术患者中留下的指令目标", "洗脑")
	if(!objective)
		return SURGERY_STEP_FAIL
	display_results(
		user,
		target,
	span_notice("你开始对[target]进行洗脑..."),
	span_notice("[user]开始修理[target]的大脑."),
	span_notice("[user]开始对[target]的大脑进行手术."),
	)
	display_pain(target, "你的头感到难以想象的剧痛！")// Same message as other brain surgeries

/datum/surgery_step/brainwash/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(!target.mind)
		to_chat(user, span_warning("[target]没有回应洗脑，这个人似乎根本没有思想意识..."))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_MINDSHIELD))
		to_chat(user, span_warning("你听到[target]大脑里有一个微弱的嗡嗡声，洗脑被消除了."))
		return FALSE
	display_results(
		user,
		target,
		span_notice("你成功地洗脑了[target]."),
		span_notice("[user]成功地修理了[target]的大脑！"),
		span_notice("[user]完成了对[target]大脑的手术."),
	)
	to_chat(target, span_userdanger("你的脑海中充满了新的强迫感...你感到不得不服从它！"))
	brainwash(target, objective)
	message_admins("[ADMIN_LOOKUPFLW(user)]通过手术对[ADMIN_LOOKUPFLW(target)]进行了洗脑，目标为'[objective]'.")
	user.log_message("使用洗脑手术对[key_name(target)]进行了洗脑，目标为'[objective]'。", LOG_ATTACK)
	target.log_message("被[key_name(user)]使用洗脑手术洗脑，目标为'[objective]'。", LOG_VICTIM, log_globally=FALSE)
	user.log_message("通过手术对[key_name(target)]进行了洗脑，目标为'[objective]'。", LOG_GAME)
	return ..()

/datum/surgery_step/brainwash/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_slot(ORGAN_SLOT_BRAIN))
		display_results(
			user,
			target,
			span_warning("你搞砸了，损伤了脑组织！"),
			span_warning("[user]搞砸了，造成了脑损伤！"),
			span_notice("[user]完成了对[target]大脑的手术."),
		)
		display_pain(target, "你的头感到剧烈的疼痛!")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 40)
	else
		user.visible_message(span_warning("[user]突然发现正在手术的大脑不见了."), span_warning("你突然发现刚才正在手术的大脑不见了."))
	return FALSE
