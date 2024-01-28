//Reagents produced by metabolising/reacting fermichems inoptimally these specifically are for toxins
//Inverse = Splitting
//Invert = Whole conversion
//Failed = End reaction below purity_min

////////////////////TOXINS///////////////////////////

//Lipolicide - Impure Version
/datum/reagent/impurity/ipecacide
	name = "Ipecacide-肚痛物质"
	description = "引起呕吐的极其恶心的物质当断肠毒素反应不纯时产生."
	ph = 7
	liver_damage = 0

/datum/reagent/impurity/ipecacide/on_mob_add(mob/living/carbon/owner)
	if(owner.disgust >= DISGUST_LEVEL_GROSS)
		return ..()
	owner.adjust_disgust(50)
	..()

//Formaldehyde - Impure Version
/datum/reagent/impurity/methanol
	name = "Methanol-甲醇"
	description = "一种淡而无色的液体，有独特的气味，误食会导致失明，它是不纯甲醛的副产品."
	reagent_state = LIQUID
	color = "#aae7e4"
	ph = 7
	liver_damage = 0

/datum/reagent/impurity/methanol/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/obj/item/organ/internal/eyes/eyes = affected_mob.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes?.apply_organ_damage(0.5 * REM * seconds_per_tick, required_organ_flag = affected_organ_flags))
		return UPDATE_MOB_HEALTH

//Chloral Hydrate - Impure Version
/datum/reagent/impurity/chloralax
	name = "Chloralax-水合产物"
	description = "一种油性、无色、微毒性液体，当不纯的水合氯醛在生物体内分解时产生."
	reagent_state = LIQUID
	color = "#387774"
	ph = 7
	liver_damage = 0

/datum/reagent/impurity/chloralax/on_mob_life(mob/living/carbon/owner, seconds_per_tick)
	. = ..()
	if(owner.adjustToxLoss(1 * REM * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

//Mindbreaker Toxin - Impure Version
/datum/reagent/impurity/rosenol
	name = "Rosenol-蓝玫瑰油"
	description = "一种奇怪的蓝色液体，在不纯净的毒素反应中产生."
	reagent_state = LIQUID
	color = "#0963ad"
	ph = 7
	liver_damage = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/impurity/rosenol/on_mob_life(mob/living/carbon/owner, seconds_per_tick)
	. = ..()
	var/obj/item/organ/internal/tongue/tongue = owner.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	if(SPT_PROB(4.0, seconds_per_tick))
		owner.manual_emote("clicks with [owner.p_their()] tongue.")
		owner.say("吵.", forced = /datum/reagent/impurity/rosenol)
	if(SPT_PROB(2.0, seconds_per_tick))
		owner.say(pick("啊这是个错误", "太恐怖了.", "大家小心，土豆很烫.", "我六岁的时候吃了一袋李子.", "要说有什么我不能忍受的，那就是西红柿.", "要说我喜欢什么，那就是西红柿.", "我们有一个非常严格的船长，你不允许在他的站点呼吸.", "那些不强壮的就会倒下死去，你会听到它们在你身后倒下的声音."), forced = /datum/reagent/impurity/rosenol)
