/datum/mutation/human/olfaction
	name = "超级嗅觉"
	desc = "你的嗅觉与犬类媲美，能分辨细微气味并追踪气味来源."
	quality = POSITIVE
	difficulty = 12
	text_gain_indication = "<span class='notice'>气味开始变得更有意义...</span>"
	text_lose_indication = "<span class='notice'>你的嗅觉恢复了正常.</span>"
	power_path = /datum/action/cooldown/spell/olfaction
	instability = POSITIVE_INSTABILITY_MODERATE
	synchronizer_coeff = 1

/datum/mutation/human/olfaction/modify()
	. = ..()
	var/datum/action/cooldown/spell/olfaction/to_modify = .
	if(!istype(to_modify)) // null or invalid
		return

	to_modify.sensitivity = GET_MUTATION_SYNCHRONIZER(src)

/datum/action/cooldown/spell/olfaction
	name = "追忆气味"
	desc = "记下你当前持有的物品的气味，以便于追踪."
	button_icon_state = "nose"

	cooldown_time = 10 SECONDS
	spell_requirements = NONE

	/// Weakref to the mob we're tracking
	var/datum/weakref/tracking_ref
	/// Our nose's sensitivity
	var/sensitivity = 1

/datum/action/cooldown/spell/olfaction/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		return FALSE

	var/mob/living/living_cast_on = cast_on
	if(ishuman(living_cast_on) && !living_cast_on.get_bodypart(BODY_ZONE_HEAD))
		to_chat(owner, span_warning("你没有鼻子!"))
		return FALSE

	if(HAS_TRAIT(living_cast_on, TRAIT_ANOSMIA)) //Anosmia quirk holders can't smell anything
		to_chat(owner, span_warning("你不能闻!"))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/olfaction/cast(mob/living/cast_on)
	. = ..()
	// Can we sniff? is there miasma in the air?
	var/datum/gas_mixture/air = cast_on.loc.return_air()
	var/list/cached_gases = air.gases

	if(cached_gases[/datum/gas/miasma])
		cast_on.adjust_disgust(sensitivity * 45)
		to_chat(cast_on, span_warning("你灵敏的鼻子闻到一股恶臭，让你感到恶心！试试去更干净的地方吧!"))
		return

	var/atom/sniffed = cast_on.get_active_held_item()
	if(sniffed)
		pick_up_target(cast_on, sniffed)
	else
		follow_target(cast_on)

/// Attempt to pick up a new target based on the fingerprints on [sniffed].
/datum/action/cooldown/spell/olfaction/proc/pick_up_target(mob/living/caster, atom/sniffed)
	var/mob/living/carbon/old_target = tracking_ref?.resolve()
	var/list/possibles = list()
	var/list/prints = GET_ATOM_FINGERPRINTS(sniffed)
	if(prints)
		for(var/mob/living/carbon/to_check as anything in GLOB.carbon_list)
			if(prints[md5(to_check.dna?.unique_identity)])
				possibles |= to_check

	// There are no finger prints on the atom, so nothing to track
	if(!length(possibles))
		to_chat(caster, span_warning("你使出全力嗅探了[sniffed]，但没有找到任何气味..."))
		return

	var/mob/living/carbon/new_target = tgui_input_list(caster, "记忆气味", "追踪气味", sort_names(possibles))
	if(QDELETED(src) || QDELETED(caster))
		return

	if(QDELETED(new_target))
		// We don't have a new target OR an old target
		if(QDELETED(old_target))
			to_chat(caster, span_warning("你决定不记住任何气味， \
				相反，你余光瞥见了自己的鼻子. \
				这让你想起那次你开始手动呼吸然后停不下来的经历. 真是糟糕的一天."))
			tracking_ref = null

		// We don't have a new target, but we have an old target to fall back on
		else
			to_chat(caster, span_notice("你再次追踪[old_target]，猎捕继续."))
			on_the_trail(caster)
		return

	// We have a new target to track
	to_chat(caster, span_notice("你闻到了[new_target]的气味. 猎捕开始."))
	tracking_ref = WEAKREF(new_target)
	on_the_trail(caster)

/// Attempt to follow our current tracking target.
/datum/action/cooldown/spell/olfaction/proc/follow_target(mob/living/caster)
	var/mob/living/carbon/current_target = tracking_ref?.resolve()
	// Either our weakref failed to resolve (our target's gone),
	// or we never had a target in the first place
	if(QDELETED(current_target))
		to_chat(caster, span_warning("你的手空空如也，没有东西可闻， \
			周围也没有什么可以追踪的气味. 你只好闻了闻自己的皮肤...嗯，有点咸味."))
		tracking_ref = null
		return

	on_the_trail(caster)

/// Actually go through and give the user a hint of the direction our target is.
/datum/action/cooldown/spell/olfaction/proc/on_the_trail(mob/living/caster)
	var/mob/living/carbon/current_target = tracking_ref?.resolve()
	//Using get_turf to deal with those pesky closets that put your x y z to 0
	var/turf/current_target_turf = get_turf(current_target)
	var/turf/caster_turf = get_turf(caster)
	if(!current_target)
		to_chat(caster, span_warning("你没有追踪任何气味，但游戏却认为你在追踪， \
			出现了错误!请报告此bug."))
		stack_trace("[type] - on_the_trail was called when no tracking target was set.")
		tracking_ref = null
		return

	if(current_target == caster)
		to_chat(caster, span_warning("你闻到了自己的气味. 是的，就是你自己."))
		return

	if(caster_turf.z < current_target_turf.z)
		to_chat(caster, span_warning("气味线索... 高高在你头顶？嗯，他们可能真的非常、非常远."))
		return

	else if(caster_turf.z > current_target_turf.z)
		to_chat(caster, span_warning("气味线索... 深深在你脚下？嗯，他们可能真的非常、非常远."))
		return

	var/direction_text = span_bold("[dir2text(get_dir(caster_turf, current_target_turf))]")
	if(direction_text)
		to_chat(caster, span_notice("你感受到了[current_target]的气味，气味线索指向[direction_text]."))
