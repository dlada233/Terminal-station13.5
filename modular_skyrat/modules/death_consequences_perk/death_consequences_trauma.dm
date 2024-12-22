#define DEGRADATION_LEVEL_NONE "dc_level_none"
#define DEGRADATION_LEVEL_LOW "dc_level_low"
#define DEGRADATION_LEVEL_MEDIUM "dc_level_medium"
#define DEGRADATION_LEVEL_HIGH "dc_level_high"
#define DEGRADATION_LEVEL_CRITICAL "dc_level_critical"

#define DEGRADATION_LEVEL_NONE_THRESHOLD 0.2
#define DEGRADATION_LEVEL_LOW_THRESHOLD 0.4
#define DEGRADATION_LEVEL_MEDIUM_THRESHOLD 0.6
#define DEGRADATION_LEVEL_HIGH_THRESHOLD 0.8

/// Only rezadone at or above this purity can reduce degradation. Needed because of borg synthesizers.
#define DEATH_CONSEQUENCES_REZADONE_MINIMUM_PURITY 100

/datum/brain_trauma/severe/death_consequences
	name = DEATH_CONSEQUENCES_QUIRK_NAME
	desc = DEATH_CONSEQUENCES_QUIRK_DESC
	scan_desc = "死亡性机能衰退"
	gain_text = span_warning("有那么一瞬间，你感觉与身体断开了联系.")
	lose_text = span_notice("你觉得你又牢牢地抓住了意识!")
	random_gain = FALSE

	/// The current degradation we are currently at. Generally speaking, things get worse the higher this is. Can never go below 0.
	var/current_degradation = 0
	/// The absolute maximum degradation we can receive. Will cause permadeath if [permakill_if_at_max_degradation] is TRUE.
	var/max_degradation = DEATH_CONSEQUENCES_DEFAULT_MAX_DEGRADATION // arbitrary
	/// While alive, our victim will lose degradation by this amount per second.
	var/base_degradation_reduction_per_second_while_alive = DEATH_CONSEQUENCES_DEFAULT_LIVING_DEGRADATION_RECOVERY
	/// When our victim dies, they will degrade by this amount, but only if the last time they died was after [time_required_between_deaths_to_degrade] ago.
	var/base_degradation_on_death = DEATH_CONSEQUENCES_DEFAULT_DEGRADATION_ON_DEATH
	/// While dead, our victim will degrade by this amount every second. Reduced by stasis and formeldahyde.
	var/base_degradation_per_second_while_dead = 0

	/// The last time we caused immediate degradation on death.
	var/last_time_degraded_on_death = -2 MINUTES // we do this to avoid a lil bug where it cant happen at roundstart
	/// If the last time we degraded on death was less than this time ago, we won't immediately degrade when our victim dies. Used for preventing things like MDs constantly reviving someone and PKing them.
	var/time_required_between_deaths_to_degrade = 2 MINUTES

	/// If our victim is dead, their passive degradation will be multiplied against this if they have formal in their system.
	var/formaldehyde_death_degradation_mult = 0
	/// If our victim is alive and is metabolizing rezadone, we will reduce degradation by this amount every second.
	var/rezadone_degradation_decrease = DEATH_CONSEQUENCES_DEFAULT_REZADONE_DEGRADATION_REDUCTION

	/// When eigenstasium is metabolized, degradation is reduced by this.
	var/eigenstasium_degradation_decrease = DEATH_CONSEQUENCES_DEFAULT_EIGENSTASIUM_DEGRADATION_REDUCTION

	/// If our victim is dead, their passive degradation will be multiplied against this if they are in stasis.
	var/stasis_passive_degradation_multiplier = 0

	/// If true, when [current_degradation] reaches [max_degradation], we will DNR and ghost our victim.
	var/permakill_if_at_max_degradation = FALSE
	/// If true, when [current_degradation] reaches [max_degradation], we will DNR and KILL our victim.
	var/force_death_if_permakilled = FALSE

	/// If we have killed our owner permanently.
	var/final_death_delivered = FALSE

	// Higher = overall less intense threshold reduction but it still maxes out once it gets there
	/// The degradation we will begin reducing the crit threshold at.
	var/crit_threshold_min_degradation = 0
	/// The degradation we will stop reducing the crit threshold at.
	var/crit_threshold_max_degradation = 200
	/// The amount our victims crit threshold will be reduced by at [crit_threshold_max_degradation] degradation.
	var/max_crit_threshold_reduction = 100

	/// The degradation we will begin applying stamina damage at.
	var/stamina_damage_minimum_degradation = 100
	/// The degradation we will stop increasing the stamina damage at.
	var/stamina_damage_max_degradation = 500
	/// The amount our victims crit threshold will be reduced by at [stamina_damage_max_degradation] degradation.
	var/max_stamina_damage = 80

	/// Used for updating our crit threshold reduction. We store the previous value, then subtract it from crit threshold, to get the value we had before we adjusted.
	var/crit_threshold_currently_reduced_by = 0

	/// The last world.time we sent a message to our owner reminding them of their current degradation. Used for cooldowns and such.
	var/time_of_last_message_sent = -DEATH_CONSEQUENCES_TIME_BETWEEN_REMINDERS
	/// The time between each reminder ([degradation_messages]).
	var/time_between_reminders = DEATH_CONSEQUENCES_TIME_BETWEEN_REMINDERS

	/// The current level of degradation. Used mostly for reminder messages.
	var/current_degradation_level = DEGRADATION_LEVEL_NONE

	// Will be iterated through sequentially, so the higher a path is, the quicker it'll be searched
	// Make sure to put the larger bonuses and more specific types higher than the generic ones
	/// A assoc list of (atom/movable typepath -> mult), where mult is used as a multiplier against passive living degradation reduction.
	var/static/list/buckled_to_recovery_mult_table = list(
		/obj/structure/bed/medical = 5,
		/obj/structure/bed = 3,

		/obj/structure/chair/comfy = 2,
		/obj/structure/chair/sofa = 2,
		/obj/structure/chair = 1.5,

		/mob/living = 1.25, // being carried
	)
	/// Only used if the thing we are buckled to is not in [buckled_to_recovery_mult_table].
	var/static/buckled_to_default_mult = 1.15

	/// The random messages that will be sent to our victim if their degradation moves to a new threshold.
	/// Contains nested assoc lists of (DEGRADATION_LEVEL_DEFINE -> list((message -> weight), ...)) where ... is a indefinite number of message -> weight pairs.
	var/static/list/degradation_messages = list(
		DEGRADATION_LEVEL_LOW = list(
			span_warning("你的身体有点疼.") = 10,
			span_warning("你感觉有点脱离自我.") = 10,
			span_warning("你感觉有点累.") = 10,
		),
		DEGRADATION_LEVEL_MEDIUM = list(
			span_danger("你全身疼痛...") = 10,
			span_danger("你感觉自己正在与身体脱节...") = 10,
			span_danger("你感觉思考变得困难...") = 10,
		),
		DEGRADATION_LEVEL_HIGH = list(
			span_bolddanger("你全身颤抖!") = 10,
			span_bolddanger("你觉得正在失去对自己的控制!") = 10,
			span_bolddanger("你的意识就像一块那样脆弱!") = 10,
			span_bolddanger("你感觉精疲力尽!") = 10,
		),
		DEGRADATION_LEVEL_CRITICAL = list(
			span_revenwarning("<b>哪里都在疼...快要不行了...</b>") = 10,
			span_revenwarning("<b>思考不了...太困难...太过辛苦...</b>") = 10,
			span_revenwarning("<b>你感觉到身体很陌生，好像你不属于它...</b>") = 10,
			span_revenwarning("<b>... 我是谁?</b>") = 1,
			span_revenwarning("<b>... 我在哪?</b>") = 1,
			span_revenwarning("<b>... 我是什么?</b>") = 1,
		)
	)

	/// Assoc list of (mob -> world.time + time_to_view_extra_data_after_scan). Used for determining if someone can use our health analyzer href
	var/list/mob/time_til_scan_expires = list()
	/// The amount of time someone has to view our extra info via health analyzer after scanning us.
	var/time_to_view_extra_data_after_scan = 5 SECONDS

/datum/brain_trauma/severe/death_consequences/Destroy()
	for (var/mob/entry as anything in time_til_scan_expires)
		UnregisterSignal(entry, COMSIG_QDELETING)
		time_til_scan_expires -= entry

	return ..()

/datum/brain_trauma/severe/death_consequences/on_gain()
	. = ..()

	RegisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(victim_ahealed))

	update_variables()
	START_PROCESSING(SSprocessing, src)

/datum/brain_trauma/severe/death_consequences/on_lose(silent)
	owner.crit_threshold -= crit_threshold_currently_reduced_by
	STOP_PROCESSING(SSprocessing, src)

	if (final_death_delivered)
		REMOVE_TRAIT(owner, TRAIT_DNR, TRAUMA_TRAIT)

	UnregisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL)

	return ..()

// DEGRADATION ALTERATION / PROCESS

/datum/brain_trauma/severe/death_consequences/on_death()
	. = ..()

	if (base_degradation_on_death != 0)
		if (!last_time_degraded_on_death || world.time - time_required_between_deaths_to_degrade <= last_time_degraded_on_death)
			return

		adjust_degradation(base_degradation_on_death)
		if (!final_death_delivered) // already sends a very spooky message if they permadie
			var/visible_message = span_revenwarning("[owner]短暂地挣扎了一下，随后便瘫软下来. 你感觉到自己可能需要<b>阻止这个人再次死去...</b>")
			var/self_message = span_revenwarning("当你的心智因死亡的冲击而天旋地转时，你感受到了将你与身体相连的虚幻纽带正在承受巨大的压力...")

			var/mob/dead/observer/ghost = owner.get_ghost()
			var/mob/self_message_target = (ghost ? ghost : owner)
			owner.visible_message(visible_message, ignored_mobs = self_message_target)
			to_chat(self_message_target, self_message)

		last_time_degraded_on_death = world.time

/datum/brain_trauma/severe/death_consequences/process(seconds_per_tick)
	if (owner.status_flags & GODMODE)
		return

	var/is_dead = (owner.stat == DEAD)
	var/degradation_increase = get_passive_degradation_increase(is_dead) * seconds_per_tick
	var/degradation_reduction = get_passive_degradation_decrease(is_dead) * seconds_per_tick

	adjust_degradation(degradation_increase - degradation_reduction)

	// Ensure our victim's stamina is at or above our minimum stamina damage
	if (!is_dead)
		damage_stamina(seconds_per_tick)

	if ((world.time - time_between_reminders) > time_of_last_message_sent)
		send_reminder()

/// Returns the amount, every second, degradation should INCREASE by.
/datum/brain_trauma/severe/death_consequences/proc/get_passive_degradation_increase(is_dead)
	var/increase = 0

	if (is_dead)
		increase += base_degradation_per_second_while_dead

		if (owner.has_reagent(/datum/reagent/toxin/formaldehyde, needs_metabolizing = FALSE))
			var/datum/reagent/reagent_instance = owner.reagents.has_reagent(/datum/reagent/toxin/formaldehyde)
			if (reagent_process_flags_valid(owner, reagent_instance))
				increase *= formaldehyde_death_degradation_mult
	else
		if (base_degradation_reduction_per_second_while_alive < 0) // if you wanna die slowly while alive, go ahead bud
			increase -= base_degradation_reduction_per_second_while_alive

	if (HAS_TRAIT(owner, TRAIT_STASIS))
		increase *= stasis_passive_degradation_multiplier

	return increase

/// Returns the amount, every second, degradation should DECREASE by.
/datum/brain_trauma/severe/death_consequences/proc/get_passive_degradation_decrease(is_dead)
	var/decrease = 0

	if (!is_dead)
		if (base_degradation_reduction_per_second_while_alive > 0)
			decrease += base_degradation_reduction_per_second_while_alive

		var/datum/reagent/rezadone_instance = owner.reagents.has_reagent(/datum/reagent/medicine/rezadone, needs_metabolizing = TRUE)
		if (rezadone_instance)
			if ((rezadone_instance.purity >= DEATH_CONSEQUENCES_REZADONE_MINIMUM_PURITY) && reagent_process_flags_valid(owner, rezadone_instance))
				decrease += rezadone_degradation_decrease

	if (owner.has_reagent(/datum/reagent/eigenstate))
		decrease += eigenstasium_degradation_decrease

	return (decrease * get_passive_degradation_decrease_mult())

#define DEGRADATION_REDUCTION_SLEEPING_MULT 3
#define DEGRADATION_REDUCTION_RESTING_MULT 1.5

/// Returns a multiplier that should be used whenever degradation is passively decreased. Is determined by resting, sleeping, and buckled status.
/datum/brain_trauma/severe/death_consequences/proc/get_passive_degradation_decrease_mult()
	var/decrease_mult = 1

	if (owner.IsSleeping())
		decrease_mult *= DEGRADATION_REDUCTION_SLEEPING_MULT
	else if (owner.resting)
		decrease_mult *= DEGRADATION_REDUCTION_RESTING_MULT

	var/buckled_to_mult
	if (owner.buckled)
		for (var/atom/atom_typepath as anything in buckled_to_recovery_mult_table)
			if (istype(owner.buckled, atom_typepath))
				buckled_to_mult = buckled_to_recovery_mult_table[atom_typepath]
				break
		if (isnull(buckled_to_mult))
			buckled_to_mult = buckled_to_default_mult
	else
		buckled_to_mult = 1

	decrease_mult *= buckled_to_mult

	return decrease_mult

#undef DEGRADATION_REDUCTION_SLEEPING_MULT
#undef DEGRADATION_REDUCTION_RESTING_MULT

/// Setter proc for [current_degradation] that clamps the incoming value and updates effects if the value changed.
/datum/brain_trauma/severe/death_consequences/proc/adjust_degradation(adjustment)
	var/old_degradation = current_degradation
	current_degradation = clamp((current_degradation + adjustment), 0, max_degradation)
	if (current_degradation != old_degradation)
		update_degradation_level()
		update_effects()

/**
 * Updates [current_degradation_level] by comparing current degradation to max.
 *
 * Args:
 * * send_reminder_if_changed = TRUE: If TRUE, will call [send_reminder()] if [current_degradation_level] is changed.
 */
/datum/brain_trauma/severe/death_consequences/proc/update_degradation_level(send_reminder_if_changed = TRUE)
	var/old_level = current_degradation_level
	switch (current_degradation / max_degradation)
		if (0 to DEGRADATION_LEVEL_NONE_THRESHOLD)
			current_degradation_level = DEGRADATION_LEVEL_NONE
		if (DEGRADATION_LEVEL_NONE_THRESHOLD to DEGRADATION_LEVEL_LOW_THRESHOLD)
			current_degradation_level = DEGRADATION_LEVEL_LOW
		if (DEGRADATION_LEVEL_LOW_THRESHOLD to DEGRADATION_LEVEL_MEDIUM_THRESHOLD)
			current_degradation_level = DEGRADATION_LEVEL_MEDIUM
		if (DEGRADATION_LEVEL_MEDIUM_THRESHOLD to DEGRADATION_LEVEL_HIGH_THRESHOLD)
			current_degradation_level = DEGRADATION_LEVEL_HIGH
		else
			current_degradation_level = DEGRADATION_LEVEL_CRITICAL

	if (send_reminder_if_changed && !final_death_delivered && (old_level != current_degradation_level))
		send_reminder(FALSE)

// EFFECTS

/// Refreshes all our effects and updates their values. Kills the victim if they opted in and their degradation equals their maximum.
/datum/brain_trauma/severe/death_consequences/proc/update_effects()
	var/threshold_adjustment = get_crit_threshold_adjustment()
	owner.crit_threshold = ((owner.crit_threshold - crit_threshold_currently_reduced_by) + threshold_adjustment)
	crit_threshold_currently_reduced_by = threshold_adjustment

	if (permakill_if_at_max_degradation && (current_degradation >= max_degradation))
		and_so_your_story_ends()

/// Calculates the amount that we should add to our victim's critical threshold.
/datum/brain_trauma/severe/death_consequences/proc/get_crit_threshold_adjustment()
	SHOULD_BE_PURE(TRUE)

	var/clamped_degradation = clamp((current_degradation - crit_threshold_min_degradation), 0, crit_threshold_max_degradation)
	var/percent_to_max = (clamped_degradation / crit_threshold_max_degradation)

	var/proposed_alteration = max_crit_threshold_reduction * percent_to_max
	var/proposed_threshold = ((owner.crit_threshold - crit_threshold_currently_reduced_by) + proposed_alteration)
	var/overflow = max((proposed_threshold - DEATH_CONSEQUENCES_MINIMUM_VICTIM_CRIT_THRESHOLD), 0)
	var/final_alteration = (proposed_alteration - overflow)

	return final_alteration

/// Ensures our victim's stamina is at or above the minimum stamina they're supposed to have.
/datum/brain_trauma/severe/death_consequences/proc/damage_stamina(seconds_per_tick)
	if (victim_properly_resting())
		return

	var/clamped_degradation = clamp((current_degradation - stamina_damage_minimum_degradation), 0, stamina_damage_max_degradation)
	var/percent_to_max = min((clamped_degradation / stamina_damage_max_degradation), 1)
	var/minimum_stamina_damage = max_stamina_damage * percent_to_max

	// The constantly decreasing degradation will constantly lower the minimum stamina damage, and thus, if we DONT check a range of staminaloss,
	// we will always consider it "above" our minimum, and thus never delay stamina regen.
	var/owner_staminaloss = owner.getStaminaLoss()
	if (minimum_stamina_damage <= 0)
		return
	if (owner_staminaloss > (minimum_stamina_damage + 1))
		return
	else if ((owner_staminaloss >= (minimum_stamina_damage - 1)) && (owner_staminaloss <= (minimum_stamina_damage + 1)))
		owner.apply_status_effect(/datum/status_effect/incapacitating/stamcrit)
		return

	var/final_adjustment = (minimum_stamina_damage - owner_staminaloss)
	owner.adjustStaminaLoss(final_adjustment) // we adjust instead of set for things like stamina regen timer

/**
 * Sends a flavorful to_chat to the target, picking from degradation_messages[current_degradation_level]. Can fail to send one if no message is found.
 *
 * Args:
 * * update_cooldown = TRUE: If true, updates [time_of_last_message_sent] to be world.time.
 */
/datum/brain_trauma/severe/death_consequences/proc/send_reminder(update_cooldown = TRUE)
	var/list/message_list = degradation_messages[current_degradation_level] // can return null
	if (!length(message_list)) // sanity
		return
	var/message = pick_weight(message_list)

	if (!message)
		return

	to_chat(owner, message)

	if (update_cooldown)
		time_of_last_message_sent = world.time

/// The proc we call when we permanently kill our victim due to being at maximum degradation. DNRs them, ghosts/kills them, and prints a series of highly dramatic messages,
/// befitting for a death such as this.
/datum/brain_trauma/severe/death_consequences/proc/and_so_your_story_ends()
	ADD_TRAIT(owner, TRAIT_DNR, TRAUMA_TRAIT) // you're gone bro
	final_death_delivered = TRUE

	// this is a sufficiently dramatic event for some dramatic to_chats
	var/visible_message
	var/self_message
	var/log_message

	if (owner.stat == DEAD)
		visible_message=span_revenwarning("围绕[owner]的空气似乎瞬间产生了涟漪.")
		self_message=span_revendanger("将你束缚在身体上的虚幻“纽带”终于断裂了，你试图抓住它，但很快就发现自己正坠入一个深邃、黑暗的无底深渊...")
		log_message="由于共振不稳定特质，已被永久变为幽灵."
	else
		if (force_death_if_permakilled) // kill them - a violent and painful end
			visible_message = span_revenwarning("[owner]突然发出一声骇人的喘息，跪倒在地，双手抱头！他的身体其余部分很快就瘫软下来，再也无法站起.")
			owner.death(gibbed = FALSE)
			log_message = "由于共振不稳定特质，已被永久杀死."
		else // ghostize them - they simply stop thinking, forever
			visible_message = span_revenwarning("[owner]的头猛地向上仰起，然后松弛下来，张着嘴，瞳孔放大，停止了所有动作，只是站在那里，摇摇晃晃.")
			owner.ghostize(can_reenter_corpse = FALSE)
			log_message = "由于共振不稳定特质，已被永久变为幽灵."

		self_message = span_revendanger("你的思维突然变得混乱，你失去了对所有思考和机能的控制. 你试图紧闭双眼，但仅仅一秒后你就忘记了它们的位置. 你离自己越来越远，直到再也无法返回...")

	var/mob/dead/observer/owner_ghost = owner.get_ghost()
	var/mob/self_message_target = (owner_ghost ? owner_ghost : owner) // if youre ghosted, you still get the message

	visible_message += span_revenwarning(" <b>你感觉到发生了可怕的事情.</b>") // append crucial info and context clues
	self_message += span_danger(" 你已被死亡衰退所杀死，这使你无法回到你的身体，甚至无法被复活. 你可以根据自己的意愿来扮演这个角色，一切由你决定.")

	owner.investigate_log(log_message)
	owner.visible_message(visible_message, ignored_mobs = self_message_target) // finally, send it
	owner.balloon_alert_to_viewers("发生了可怕的事情...")
	to_chat(self_message_target, self_message)

/// Returns a short-ish string containing an href to [get_specific_data].
/datum/brain_trauma/severe/death_consequences/proc/get_health_analyzer_link_text(mob/user)
	var/message = span_bolddanger("\n对象患有死亡性机能衰退.")
	if (final_death_delivered)
		message += span_purple("<i>\n神经模式与意识零点无差别，对象可能已经衰退至死亡.</i>")
		return message

	message += span_danger("\n当前衰退值/最大值: [span_blue("<b>[current_degradation]</b>")]/<b>[max_degradation]</b>.")
	message += span_notice("\n<a href='?src=[REF(src)];[DEATH_CONSEQUENCES_SHOW_HEALTH_ANALYZER_DATA]=1'>浏览衰退详情?</a>")
	if (permakill_if_at_max_degradation)
		message += span_revenwarning("\n\n<b><i>如果衰退达到最大值，对象将永久死亡!</i></b>")

	if (user)
		if (isnull(time_til_scan_expires[user]))
			RegisterSignal(user, COMSIG_QDELETING, PROC_REF(scanning_user_qdeleting))
		time_til_scan_expires[user] = (world.time + time_to_view_extra_data_after_scan)

	return message

/datum/brain_trauma/severe/death_consequences/proc/scanning_user_qdeleting(datum/signal_source)
	SIGNAL_HANDLER

	time_til_scan_expires -= signal_source
	UnregisterSignal(signal_source, COMSIG_QDELETING)

/datum/brain_trauma/severe/death_consequences/Topic(href, list/href_list)
	. = ..()

	if (href_list[DEATH_CONSEQUENCES_SHOW_HEALTH_ANALYZER_DATA])
		if (world.time <= time_til_scan_expires[usr])
			to_chat(usr, examine_block(get_specific_data()), trailing_newline = FALSE, type = MESSAGE_TYPE_INFO)
		else
			to_chat(usr, span_warning("你的扫描已过期! 请尝试再次扫描!"))

/// Returns a large string intended to show specifics of how this degradation work.
/datum/brain_trauma/severe/death_consequences/proc/get_specific_data()
	var/message = span_bolddanger("对象患有死亡性机能衰退.")
	if (final_death_delivered)
		message += span_purple("<i>\n神经模式与意识零点无差别，对象可能已经衰退至死亡.</i>")
		return message

	var/owner_organic = (owner.dna.species.reagent_flags & PROCESS_ORGANIC)
	message += span_danger("\n当前衰退值/最大值: [span_blue("<b>[current_degradation]</b>")]/<b>[max_degradation]</b>.")
	if (base_degradation_reduction_per_second_while_alive)
		message += span_danger("\n当对象保持存活，能以每秒[span_blue("[base_degradation_reduction_per_second_while_alive]的速度恢复衰退.")].")
	if (base_degradation_per_second_while_dead)
		message += span_danger("\n当对象死亡，将以每秒[span_bolddanger("[base_degradation_per_second_while_dead]的速度遭受衰退")].")
		if (owner_organic && formaldehyde_death_degradation_mult != 1)
			message += span_danger(" 在此情况下，甲醛将以<b>[span_blue("[formaldehyde_death_degradation_mult]")]</b>倍的速度改变衰退.")
		if (stasis_passive_degradation_multiplier < 1)
			message += span_danger(" 静滞状态将有效减缓(甚至停止)衰退.")
	if (base_degradation_on_death)
		message += span_danger("\n死亡将产生<b>[base_degradation_on_death]</b>的基本衰退.")
	if (owner_organic && rezadone_degradation_decrease)
		message += span_danger("\n纯度在<i>[DEATH_CONSEQUENCES_REZADONE_MINIMUM_PURITY]</i>%或以上的生物酮(Rezadone)将以每秒[span_blue("[rezadone_degradation_decrease]")]的速度减少衰退.")
	if (eigenstasium_degradation_decrease)
		message += span_danger("\n本征态波动液(Eigenstasium)将以每秒[span_blue("[eigenstasium_degradation_decrease]")]的速度减少衰退.")

	message += span_danger("\n所有的衰退减少都可以通过[span_blue("休息、睡眠或坐在舒适的东西上")]来[span_blue("加快")].")

	if (permakill_if_at_max_degradation)
		message += span_revenwarning("\n\n<b><i>如果衰退达到最大值，对象将永久死亡!</i></b>")

	return message

/// Used in stamina damage. Determines if our victim is resting, sleeping, or is buckled to something cozy.
/datum/brain_trauma/severe/death_consequences/proc/victim_properly_resting()
	if (owner.resting || owner.IsSleeping())
		return TRUE

	if (owner.buckled)
		for (var/typepath in buckled_to_recovery_mult_table)
			if (istype(owner.buckled, typepath))
				return TRUE

	return FALSE

/// Signal handler proc for healing our victim on an aheal. Permadeath can only be reversed by admin aheals.
/datum/brain_trauma/severe/death_consequences/proc/victim_ahealed(datum/signal_source, heal_flags)
	SIGNAL_HANDLER

	if ((heal_flags & HEAL_AFFLICTIONS) == HEAL_AFFLICTIONS)
		adjust_degradation(-INFINITY) // a good ol' regenerative extract can fix you up
	if ((heal_flags & (ADMIN_HEAL_ALL)) == ADMIN_HEAL_ALL) // but only god can actually revive you
		final_death_delivered = FALSE
		REMOVE_TRAIT(owner, TRAIT_DNR, TRAUMA_TRAIT)

/// Resets all our variables to our victim's preferences, if they have any. Used for the initial setup, then any time our victim manually refreshes variables.
/datum/brain_trauma/severe/death_consequences/proc/update_variables(client/source = owner.client)
	// source is necessary since, in testing, i found the verb didnt work if you aghosted as owner.client was null, so we have to specify
	// "hey dude this is still our mind" via the arg

	// theoretically speaking theres should be no circumstances where mind.current is shared with another mind, so this should be intrinsically
	// safe, since only the true owner of the mob can actually use the verb to refresh the variables

	if (isnull(source))
		return // sanity

	var/ckey = lowertext(owner.mind?.key)
	if (isnull(ckey) || ckey != source.ckey)
		return // sanity

	var/datum/preferences/victim_prefs = source.prefs
	if (!victim_prefs)
		return

	max_degradation = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/max_degradation)
	current_degradation = clamp(victim_prefs.read_preference(/datum/preference/numeric/death_consequences/starting_degradation), 0, max_degradation - 1) // let's not let people instantly fucking die

	base_degradation_reduction_per_second_while_alive = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/living_degradation_recovery_per_second)
	base_degradation_per_second_while_dead = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/dead_degradation_per_second)
	base_degradation_on_death = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/degradation_on_death)

	var/min_crit_threshold_percent = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/crit_threshold_reduction_min_percent_of_max)
	crit_threshold_min_degradation = (max_degradation * (min_crit_threshold_percent / 100))
	var/max_crit_threshold_percent = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/crit_threshold_reduction_percent_of_max)
	crit_threshold_max_degradation = (max_degradation * (max_crit_threshold_percent / 100))
	max_crit_threshold_reduction = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/max_crit_threshold_reduction)

	var/min_stamina_damage_percent = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/stamina_damage_min_percent_of_max)
	stamina_damage_minimum_degradation = (max_degradation * (min_stamina_damage_percent / 100))
	var/max_stamina_damage_percent = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/stamina_damage_percent_of_max)
	max_stamina_damage = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/max_stamina_damage)
	stamina_damage_max_degradation = (max_degradation * (max_stamina_damage_percent / 100))

	permakill_if_at_max_degradation = victim_prefs.read_preference(/datum/preference/toggle/death_consequences/permakill_at_max)
	force_death_if_permakilled = victim_prefs.read_preference(/datum/preference/toggle/death_consequences/force_death_if_permakilled)

	rezadone_degradation_decrease = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/rezadone_living_degradation_reduction)
	eigenstasium_degradation_decrease = victim_prefs.read_preference(/datum/preference/numeric/death_consequences/eigenstasium_degradation_reduction)

	update_effects()

#undef DEGRADATION_LEVEL_NONE
#undef DEGRADATION_LEVEL_LOW
#undef DEGRADATION_LEVEL_MEDIUM
#undef DEGRADATION_LEVEL_HIGH
#undef DEGRADATION_LEVEL_CRITICAL

#undef DEGRADATION_LEVEL_NONE_THRESHOLD
#undef DEGRADATION_LEVEL_LOW_THRESHOLD
#undef DEGRADATION_LEVEL_MEDIUM_THRESHOLD
#undef DEGRADATION_LEVEL_HIGH_THRESHOLD

#undef DEATH_CONSEQUENCES_REZADONE_MINIMUM_PURITY
