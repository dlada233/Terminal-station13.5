/datum/surgery/core_removal
	name = "核心移除"
	target_mobtypes = list(/mob/living/basic/slime)
	surgery_flags = SURGERY_IGNORE_CLOTHES
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/extract_core,
	)

/datum/surgery/core_removal/can_start(mob/user, mob/living/target)
	return target.stat == DEAD && ..()

//extract brain
/datum/surgery_step/extract_core
	name = "提取核心 (止血钳/撬棍)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_CROWBAR = 100)
	time = 16

/datum/surgery_step/extract_core/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始从[target]中提取核心..."),
		span_notice("[user]开始从[target]中提取核心."),
		span_notice("[user]开始从[target]中提取核心."),
	)

/datum/surgery_step/extract_core/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/basic/slime/target_slime = target
	if(target_slime.cores > 0)
		target_slime.cores--
		display_results(
			user,
			target,
			span_notice("你成功地从[target]中提取了一个核心。[target_slime.cores]个核心剩余."),
			span_notice("[user]成功地从[target]中提取了一个核心!"),
			span_notice("[user]成功地从[target]中提取了一个核心!"),
		)

		new target_slime.slime_type.core_type(target_slime.loc)

		if(target_slime.cores <= 0)
			target_slime.icon_state = "[target_slime.slime_type.colour] baby slime dead-nocore"
			return ..()
		else
			return FALSE
	else
		to_chat(user, span_warning("[target]中没有剩余的核心了!"))
		return ..()
