/datum/surgery/advanced/bioware/ligament_reinforcement
	name = "韧带加固"
	desc = "一种外科手术，通过在躯干与四肢连接处周围添加保护组织和骨笼，防止断肢. 然而，这会导致神经连接更容易中断，使得四肢在受损时更容易失去功能."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/apply_bioware/reinforce_ligaments,
		/datum/surgery_step/close,
	)

	status_effect_gained = /datum/status_effect/bioware/ligaments/reinforced

/datum/surgery_step/apply_bioware/reinforce_ligaments
	name = "加固韧带 (手)"

/datum/surgery_step/apply_bioware/reinforce_ligaments/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始加固[target]的韧带."),
		span_notice("[user]开始加固[target]的韧带."),
		span_notice("[user]开始操作[target]的韧带."),
	)
	display_pain(target, "你的四肢传来剧烈的疼痛，仿佛被火烧一般!")

/datum/surgery_step/apply_bioware/reinforce_ligaments/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(!.)
		return

	display_results(
		user,
		target,
		span_notice("你成功加固了[target]的韧带!"),
		span_notice("[user]成功加固了[target]的韧带!"),
		span_notice("[user]完成了对[target]韧带的操作."),
	)
	display_pain(target, "你的四肢感觉更加稳固了，但也变得更加脆弱.")
