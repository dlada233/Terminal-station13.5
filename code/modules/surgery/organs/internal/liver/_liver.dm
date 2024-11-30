#define LIVER_DEFAULT_TOX_TOLERANCE 3 //amount of toxins the liver can filter out
#define LIVER_DEFAULT_TOX_RESISTANCE 1 //lower values lower how harmful toxins are to the liver
#define LIVER_FAILURE_STAGE_SECONDS 180 //amount of seconds before liver failure reaches a new stage // SKYRAT EDIT CHANGE - Original: 60
#define MAX_TOXIN_LIVER_DAMAGE 2 //the max damage the liver can receive per second (~1 min at max damage will destroy liver)

/obj/item/organ/internal/liver
	name = "肝-liver"
	desc = "搭配建议：基安蒂葡萄酒和蚕豆."
	icon_state = "liver"
	visual = FALSE
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LIVER

	maxHealth = STANDARD_ORGAN_THRESHOLD
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY // smack in the middle of decay times

	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/iron = 5)
	grind_results = list(/datum/reagent/consumable/nutriment/peptides = 5)

	/// Affects how much damage the liver takes from alcohol
	var/alcohol_tolerance = ALCOHOL_RATE
	/// The maximum volume of toxins the liver will ignore
	var/toxTolerance = LIVER_DEFAULT_TOX_TOLERANCE
	/// Modifies how much damage toxin deals to the liver
	var/liver_resistance = LIVER_DEFAULT_TOX_RESISTANCE
	var/filterToxins = TRUE //whether to filter toxins
	var/operated = FALSE //whether the liver's been repaired with surgery and can be fixed again or not

/obj/item/organ/internal/liver/Initialize(mapload)
	. = ..()
	// If the liver handles foods like a clown, it honks like a bike horn
	// Don't think about it too much.
	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_COMEDY_METABOLISM), PROC_REF(on_add_comedy_metabolism))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_COMEDY_METABOLISM), PROC_REF(on_remove_comedy_metabolism))

/* Signal handler for the liver gaining the TRAIT_COMEDY_METABOLISM trait
 *
 * Adds the "squeak" component, so clown livers will act just like their
 * bike horns, and honk when you hit them with things, or throw them
 * against things, or step on them.
 *
 * The removal of the component, if this liver loses that trait, is handled
 * by the component itself.
 */
/obj/item/organ/internal/liver/proc/on_add_comedy_metabolism()
	SIGNAL_HANDLER

	// Are clown "bike" horns made from the livers of ex-clowns?
	// Would that make the clown more or less likely to honk it
	AddComponent(/datum/component/squeak, list('sound/items/bikehorn.ogg'=1), 50, falloff_exponent = 20)

/* Signal handler for the liver losing the TRAIT_COMEDY_METABOLISM trait
 *
 * Basically just removes squeak component
 */
/obj/item/organ/internal/liver/proc/on_remove_comedy_metabolism()
	SIGNAL_HANDLER

	qdel(GetComponent(/datum/component/squeak))

/// Registers COMSIG_SPECIES_HANDLE_CHEMICAL from owner
/obj/item/organ/internal/liver/on_mob_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	RegisterSignal(organ_owner, COMSIG_SPECIES_HANDLE_CHEMICAL, PROC_REF(handle_chemical))

/// Unregisters COMSIG_SPECIES_HANDLE_CHEMICAL from owner
/obj/item/organ/internal/liver/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_SPECIES_HANDLE_CHEMICAL)

/**
 * This proc can be overriden by liver subtypes so they can handle certain chemicals in special ways.
 * Return null to continue running the normal on_mob_life() for that reagent.
 * Return COMSIG_MOB_STOP_REAGENT_CHECK to not run the normal metabolism effects.
 *
 * NOTE: If you return COMSIG_MOB_STOP_REAGENT_CHECK, that reagent will not be removed like normal! You must handle it manually.
 **/
/obj/item/organ/internal/liver/proc/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

/obj/item/organ/internal/liver/examine(mob/user)
	. = ..()

	if(HAS_MIND_TRAIT(user, TRAIT_ENTRAILS_READER) || isobserver(user))
		if(HAS_TRAIT(src, TRAIT_LAW_ENFORCEMENT_METABOLISM))
			. += span_info("脂肪沉积和零星残留物表明，这是<em>安保人员</em>的肝脏.")
		if(HAS_TRAIT(src, TRAIT_CULINARY_METABOLISM))
			. += span_info("高含铁量和轻微的蒜味表明，这是<em>厨师</em>的肝脏.")
		if(HAS_TRAIT(src, TRAIT_COMEDY_METABOLISM))
			. += span_info("一股香蕉味，光滑的表面，按压时会[span_clown("honking")]，表明这是<em>小丑</em>的肝脏.")
		if(HAS_TRAIT(src, TRAIT_MEDICAL_METABOLISM))
			. += span_info("压力痕迹和淡淡的医用酒精味表明，这是<em>医疗工作者</em>的肝脏.")
		if(HAS_TRAIT(src, TRAIT_ENGINEER_METABOLISM))
			. += span_info("有辐射暴露和太空适应的迹象表明，这是<em>工程师</em>的肝脏.")
		if(HAS_TRAIT(src, TRAIT_BALLMER_SCIENTIST))
			. += span_info("奇怪的发光残留物、凝固的固体等离子碎片以及看似肿瘤的物质表明，这是受到辐射的<em>科学家</em>的肝脏.")
		if(HAS_TRAIT(src, TRAIT_MAINTENANCE_METABOLISM))
			. += span_info("半消化的老鼠尾巴（怎么会）、恶心的污泥和淡淡的灰牛味表明，这是<em>助手</em>的肝脏残留物.")
		if(HAS_TRAIT(src, TRAIT_CORONER_METABOLISM))
			. += span_info("泡菜和海水的气味，以及出奇完好的保存状态表明，这是<em>验尸官</em>的肝脏残留物.")
		if(HAS_TRAIT(src, TRAIT_HUMAN_AI_METABOLISM))
			. += span_info("肝脏看起来几乎不像人类的，完全自给自足，这表明这是<em>人类AI</em>的肝脏残留物.")

		// royal trumps pretender royal
		if(HAS_TRAIT(src, TRAIT_ROYAL_METABOLISM))
			. += span_info("奢华食物的丰富饮食、软床带来的柔软度表明，这是<em>员工部长</em>的肝脏.")
		else if(HAS_TRAIT(src, TRAIT_PRETENDER_ROYAL_METABOLISM))
			. += span_info("仿制鱼子酱的饮食和失眠的迹象表明，这是<em>想成为部长的人</em>的肝脏.")

/obj/item/organ/internal/liver/before_organ_replacement(obj/item/organ/replacement)
	. = ..()
	if(!istype(replacement, type))
		return

	var/datum/job/owner_job = owner.mind?.assigned_role
	if(!owner_job || !LAZYLEN(owner_job.liver_traits))
		return

	// Transfer over liver traits from jobs, if we should have them
	for(var/readded_trait in owner_job.liver_traits)
		if(!HAS_TRAIT_FROM(src, readded_trait, JOB_TRAIT))
			continue
		ADD_TRAIT(replacement, readded_trait, JOB_TRAIT)

#define HAS_SILENT_TOXIN 0 //don't provide a feedback message if this is the only toxin present
#define HAS_NO_TOXIN 1
#define HAS_PAINFUL_TOXIN 2

/obj/item/organ/internal/liver/on_life(seconds_per_tick, times_fired)
	. = ..()
	//If your liver is failing, then we use the liverless version of metabolize
	if((organ_flags & ORGAN_FAILING) || HAS_TRAIT(owner, TRAIT_LIVERLESS_METABOLISM))
		owner.reagents.metabolize(owner, seconds_per_tick, times_fired, can_overdose = TRUE, liverless = TRUE)
		return

	var/obj/belly = owner.get_organ_slot(ORGAN_SLOT_STOMACH)
	var/list/cached_reagents = owner.reagents?.reagent_list
	var/liver_damage = 0
	var/provide_pain_message = HAS_NO_TOXIN

	if(filterToxins && !HAS_TRAIT(owner, TRAIT_TOXINLOVER))
		for(var/datum/reagent/toxin/toxin in cached_reagents)
			if(toxin.affected_organ_flags && !(organ_flags & toxin.affected_organ_flags)) //this particular toxin does not affect this type of organ
				continue
			var/amount = toxin.volume
			if(belly)
				amount += belly.reagents.get_reagent_amount(toxin.type)

			// a 15u syringe is a nice baseline to scale lethality by
			liver_damage += ((amount/15) * toxin.toxpwr * toxin.liver_damage_multiplier) / liver_resistance

			if(provide_pain_message != HAS_PAINFUL_TOXIN)
				provide_pain_message = toxin.silent_toxin ? HAS_SILENT_TOXIN : HAS_PAINFUL_TOXIN

	owner.reagents?.metabolize(owner, seconds_per_tick, times_fired, can_overdose = TRUE)

	if(liver_damage)
		apply_organ_damage(min(liver_damage * seconds_per_tick , MAX_TOXIN_LIVER_DAMAGE * seconds_per_tick))

	if(provide_pain_message && damage > 10 && SPT_PROB(damage/6, seconds_per_tick)) //the higher the damage the higher the probability
		to_chat(owner, span_warning("你感到腹部隐隐作痛."))


/obj/item/organ/internal/liver/handle_failing_organs(seconds_per_tick)
	if(HAS_TRAIT(owner, TRAIT_STABLELIVER) || HAS_TRAIT(owner, TRAIT_LIVERLESS_METABOLISM))
		return
	return ..()

/obj/item/organ/internal/liver/organ_failure(seconds_per_tick)
	switch(failure_time/LIVER_FAILURE_STAGE_SECONDS)
		if(1)
			to_chat(owner, span_userdanger("你感到腹部刺痛!"))
		if(2)
			to_chat(owner, span_userdanger("你感到肠胃有灼烧感!"))
			owner.vomit(VOMIT_CATEGORY_DEFAULT)
		if(3)
			to_chat(owner, span_userdanger("你感到喉咙里有酸痛感!"))
			owner.vomit(VOMIT_CATEGORY_BLOOD)
		if(4)
			to_chat(owner, span_userdanger("剧痛使你昏倒!"))
			owner.vomit(VOMIT_CATEGORY_BLOOD, distance = rand(1,2))
			owner.emote("Scream")
			owner.AdjustUnconscious(2.5 SECONDS)
		if(5)
			to_chat(owner, span_userdanger("你感觉内脏仿佛要融化!"))
			owner.vomit(VOMIT_CATEGORY_BLOOD, distance = rand(1,3))
			owner.emote("Scream")
			owner.AdjustUnconscious(5 SECONDS)

	switch(failure_time)
		//After 60 seconds we begin to feel the effects
		if(1 * LIVER_FAILURE_STAGE_SECONDS to 2 * LIVER_FAILURE_STAGE_SECONDS - 1)
			owner.adjustToxLoss(0.2 * seconds_per_tick,forced = TRUE)
			owner.adjust_disgust(0.1 * seconds_per_tick)

		if(2 * LIVER_FAILURE_STAGE_SECONDS to 3 * LIVER_FAILURE_STAGE_SECONDS - 1)
			owner.adjustToxLoss(0.4 * seconds_per_tick,forced = TRUE)
			owner.adjust_drowsiness(0.5 SECONDS * seconds_per_tick)
			owner.adjust_disgust(0.3 * seconds_per_tick)

		if(3 * LIVER_FAILURE_STAGE_SECONDS to 4 * LIVER_FAILURE_STAGE_SECONDS - 1)
			owner.adjustToxLoss(0.6 * seconds_per_tick,forced = TRUE)
			owner.adjustOrganLoss(pick(ORGAN_SLOT_HEART,ORGAN_SLOT_LUNGS,ORGAN_SLOT_STOMACH,ORGAN_SLOT_EYES,ORGAN_SLOT_EARS),0.2 * seconds_per_tick)
			owner.adjust_drowsiness(1 SECONDS * seconds_per_tick)
			owner.adjust_disgust(0.6 * seconds_per_tick)

			if(SPT_PROB(1.5, seconds_per_tick))
				owner.emote("drool")

		if(4 * LIVER_FAILURE_STAGE_SECONDS to INFINITY)
			owner.adjustToxLoss(0.8 * seconds_per_tick,forced = TRUE)
			owner.adjustOrganLoss(pick(ORGAN_SLOT_HEART,ORGAN_SLOT_LUNGS,ORGAN_SLOT_STOMACH,ORGAN_SLOT_EYES,ORGAN_SLOT_EARS),0.5 * seconds_per_tick)
			owner.adjust_drowsiness(1.6 SECONDS * seconds_per_tick)
			owner.adjust_disgust(1.2 * seconds_per_tick)

			if(SPT_PROB(3, seconds_per_tick))
				owner.emote("drool")

/obj/item/organ/internal/liver/on_owner_examine(datum/source, mob/user, list/examine_list)
	if(!ishuman(owner) || !(organ_flags & ORGAN_FAILING))
		return

	var/mob/living/carbon/human/humie_owner = owner
	if(!humie_owner.get_organ_slot(ORGAN_SLOT_EYES) || humie_owner.is_eyes_covered())
		return
	switch(failure_time)
		if(0 to 3 * LIVER_FAILURE_STAGE_SECONDS - 1)
			examine_list += span_notice("[owner]的眼睛微微发黄.")
		if(3 * LIVER_FAILURE_STAGE_SECONDS to 4 * LIVER_FAILURE_STAGE_SECONDS - 1)
			examine_list += span_notice("[owner]的眼睛完全发黄，而且显然很痛苦.")
		if(4 * LIVER_FAILURE_STAGE_SECONDS to INFINITY)
			examine_list += span_danger("[owner]的眼睛完全发黄并且肿胀流脓，看起来活不了多久了.")

/obj/item/organ/internal/liver/get_availability(datum/species/owner_species, mob/living/owner_mob)
	return owner_species.mutantliver

// alien livers can ignore up to 15u of toxins, but they take x3 liver damage
/obj/item/organ/internal/liver/alien
	name = "异星肝-alien liver" // doesnt matter for actual aliens because they dont take toxin damage
	desc = "一个曾经属于杀手外星人的肝脏，谁知道它以前吃过什么."
	icon_state = "liver-x" // Same sprite as fly-person liver.
	liver_resistance = 0.333 * LIVER_DEFAULT_TOX_RESISTANCE // -66%
	toxTolerance = 15 // complete toxin immunity like xenos have would be too powerful

/obj/item/organ/internal/liver/cybernetic
	name = "初级电子肝-basic cybernetic liver"
	desc = "一个非常基础的设备，旨在模仿人类肝脏的功能，处理毒素的能力略逊于有机肝脏."
	failing_desc = "似乎坏了."
	icon_state = "liver-c"
	organ_flags = ORGAN_ROBOTIC
	maxHealth = STANDARD_ORGAN_THRESHOLD*0.5
	toxTolerance = 2
	liver_resistance = 0.9 * LIVER_DEFAULT_TOX_RESISTANCE // -10%
	var/emp_vulnerability = 80 //Chance of permanent effects if emp-ed.

/obj/item/organ/internal/liver/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!COOLDOWN_FINISHED(src, severe_cooldown)) //So we cant just spam emp to kill people.
		owner.adjustToxLoss(10)
		COOLDOWN_START(src, severe_cooldown, 10 SECONDS)
	if(prob(emp_vulnerability/severity)) //Chance of permanent effects
		organ_flags |= ORGAN_EMP //Starts organ faliure - gonna need replacing soon.

/obj/item/organ/internal/liver/cybernetic/tier2
	name = "电子肝-cybernetic liver"
	desc = "一种模仿人类肝脏功能的电子设备，处理毒素的能力比有机肝脏稍强."
	icon_state = "liver-c-u"
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 5 //can shrug off up to 5u of toxins
	liver_resistance = 1.2 * LIVER_DEFAULT_TOX_RESISTANCE // +20%
	emp_vulnerability = 40

/obj/item/organ/internal/liver/cybernetic/tier3
	name = "高级电子肝-upgraded cybernetic liver"
	desc = "一个升级版本的电子肝，旨在进一步改善有机肝脏的功能.能抵抗酒精中毒，过滤毒素的能力也很强."
	icon_state = "liver-c-u2"
	alcohol_tolerance = ALCOHOL_RATE * 0.2
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 10 //can shrug off up to 10u of toxins
	liver_resistance = 1.5 * LIVER_DEFAULT_TOX_RESISTANCE // +50%
	emp_vulnerability = 20

/obj/item/organ/internal/liver/cybernetic/surplus
	name = "廉价人工肝-surplus prosthetic liver"
	desc = "一种非常便宜的人工肝脏，大量生产用于肝功能低下的酗酒者……它看起来更像一个过滤器，而不是真正的肝脏.非常脆弱，排毒能力极差，而且对酒精非常耐受性低.完全无法抵御电磁脉冲的攻击."
	icon_state = "liver-c-s"
	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.35
	alcohol_tolerance = ALCOHOL_RATE * 2 // can barely handle alcohol
	toxTolerance = 1 //basically can't shrug off any toxins
	liver_resistance = 0.75 * LIVER_DEFAULT_TOX_RESISTANCE // -25%
	emp_vulnerability = 100

//surplus organs are so awful that they explode when removed, unless failing
/obj/item/organ/internal/liver/cybernetic/surplus/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dangerous_surgical_removal)

#undef HAS_SILENT_TOXIN
#undef HAS_NO_TOXIN
#undef HAS_PAINFUL_TOXIN
#undef LIVER_DEFAULT_TOX_TOLERANCE
//#undef LIVER_DEFAULT_TOX_RESISTANCE // SKYRAT EDIT REMOVAL - Needed in modular
#undef LIVER_FAILURE_STAGE_SECONDS
#undef MAX_TOXIN_LIVER_DAMAGE
