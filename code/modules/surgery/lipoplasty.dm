/datum/surgery/lipoplasty
	name = "抽脂手术"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/cut_fat,
		/datum/surgery_step/remove_fat,
		/datum/surgery_step/close,
	)

/datum/surgery/lipoplasty/can_start(mob/user, mob/living/carbon/target)
	if(!HAS_TRAIT_FROM(target, TRAIT_FAT, OBESITY) || target.nutrition < NUTRITION_LEVEL_WELL_FED)
		return FALSE
	return ..()


//cut fat
/datum/surgery_step/cut_fat
	name = "切割多余脂肪 (圆锯)"
	implements = list(
		TOOL_SAW = 100,
		/obj/item/shovel/serrated = 75,
		/obj/item/hatchet = 35,
		/obj/item/knife/butcher = 25)
	time = 64
	surgery_effects_mood = TRUE
	preop_sound = list(
		/obj/item/circular_saw = 'sound/surgery/saw.ogg',
		/obj/item = 'sound/surgery/scalpel1.ogg',
	)

/datum/surgery_step/cut_fat/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message(span_notice("[user]开始切割[target]的多余脂肪."), span_notice("你开始切割[target]的多余脂肪..."))
	display_results(
		user,
		target,
		span_notice("你开始切割[target]的多余脂肪..."),
		span_notice("[user]开始切割[target]的多余脂肪."),
		span_notice("[user]开始用[tool]切割[target]的[target_zone]."),
	)
	display_pain(target, "你感到[target_zone]传来一阵刺痛！")

/datum/surgery_step/cut_fat/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	display_results(
		user,
		target,
		span_notice("你把[target]的多余脂肪切了下来."),
		span_notice("[user]把[target]的多余脂肪切了下来！"),
		span_notice("[user]完成了对[target]的[target_zone]的切割."),
	)
	display_pain(target, "[target_zone]的脂肪松了下来，晃动着，疼得要命！")
	return TRUE

//remove fat
/datum/surgery_step/remove_fat
	name = "移除松弛脂肪 (牵开器)"
	implements = list(
		TOOL_RETRACTOR = 100,
		TOOL_SCREWDRIVER = 45,
		TOOL_WIRECUTTER = 35)
	time = 32
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'

/datum/surgery_step/remove_fat/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("你开始抽取[target]的松弛脂肪..."),
		span_notice("[user]开始抽取[target]的松弛脂肪！"),
		span_notice("[user]开始从[target]的[target_zone]中抽取东西."),
	)
	display_pain(target, "你感到松弛的脂肪被奇怪而无痛地拉了出来！")

/datum/surgery_step/remove_fat/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("你从[target]身上抽出了脂肪."),
		span_notice("[user]从[target]身上抽出了脂肪！"),
		span_notice("[user]从[target]身上抽出了脂肪！"),
	)
	target.overeatduration = 0 //patient is unfatted
	var/removednutriment = target.nutrition
	target.set_nutrition(NUTRITION_LEVEL_WELL_FED)
	removednutriment -= NUTRITION_LEVEL_WELL_FED //whatever was removed goes into the meat
	var/mob/living/carbon/human/human = target
	var/typeofmeat = /obj/item/food/meat/slab/human

	if(target.flags_1 & HOLOGRAM_1)
		typeofmeat = null
	else if(human.dna && human.dna.species)
		typeofmeat = human.dna.species.meat

	if(typeofmeat)
		var/obj/item/food/meat/slab/human/newmeat = new typeofmeat
		newmeat.name = "肥肉"
		newmeat.desc = "从病人身上取出的极度肥厚的组织."
		newmeat.subjectname = human.real_name
		newmeat.subjectjob = human.job
		newmeat.reagents.add_reagent (/datum/reagent/consumable/nutriment, (removednutriment / 15)) //To balance with nutriment_factor of nutriment
		newmeat.forceMove(target.loc)
	return ..()
