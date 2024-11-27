/datum/surgery/advanced/bioware/ligament_hook
	name = "韧带钩"
	desc = "一种外科手术，通过重塑躯干与四肢之间的连接，使得四肢在被切断后可以手动重新连接. \
		然而，这会削弱连接强度，使它们更容易再次脱落."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/apply_bioware/reshape_ligaments,
		/datum/surgery_step/close,
	)

	status_effect_gained = /datum/status_effect/bioware/ligaments/hooked

/datum/surgery_step/apply_bioware/reshape_ligaments
	name = "重塑韧带(手)"

/datum/surgery_step/apply_bioware/reshape_ligaments/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始将[target]的韧带重塑成钩状."),
		span_notice("[user]开始将[target]的韧带重塑成钩状."),
		span_notice("[user]开始操作[target]的韧带."),
	)
	display_pain(target, "你的四肢传来剧烈的疼痛，仿佛被火烧一般!")

/datum/surgery_step/apply_bioware/reshape_ligaments/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(!.)
		return

	display_results(
		user,
		target,
		span_notice("你成功地将[target]的韧带重塑成了连接钩!"),
		span_notice("[user]成功地将[target]的韧带重塑成了连接钩!"),
		span_notice("[user]完成了对[target]韧带的操作."),
	)
	display_pain(target, "你的四肢感觉...异常地松弛.")
