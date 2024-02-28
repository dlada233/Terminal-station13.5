/datum/mutation/human/tongue_spike
	name = "舌刺"
	desc = "允许生物自行射出自己的舌头以作为致命武器."
	quality = POSITIVE
	text_gain_indication = span_notice("你感觉可以自己的喉舌之音射出去.")
	instability = 15
	power_path = /datum/action/cooldown/spell/tongue_spike

	energy_coeff = 1
	synchronizer_coeff = 1

/datum/action/cooldown/spell/tongue_spike
	name = "发射舌刺"
	desc = "你猛地伸出舌头，以极快的速度射向你面前的敌人，刺击并造成伤害，直到他们将其拔出为止."
	button_icon = 'icons/mob/actions/actions_genetic.dmi'
	button_icon_state = "spike"

	cooldown_time = 1 SECONDS
	spell_requirements = SPELL_REQUIRES_HUMAN

	/// The type-path to what projectile we spawn to throw at someone.
	var/spike_path = /obj/item/hardened_spike

/datum/action/cooldown/spell/tongue_spike/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/tongue_spike/cast(mob/living/carbon/cast_on)
	. = ..()
	if(HAS_TRAIT(cast_on, TRAIT_NODISMEMBER))
		to_chat(cast_on, span_notice("你很努力地集中精神，但无事发生."))
		return

	var/obj/item/organ/internal/tongue/to_fire = locate() in cast_on.organs
	if(!to_fire)
		to_chat(cast_on, span_notice("你没有可以发射的舌头!"))
		return

	to_fire.Remove(cast_on, special = TRUE)
	var/obj/item/hardened_spike/spike = new spike_path(get_turf(cast_on), cast_on)
	to_fire.forceMove(spike)
	spike.throw_at(get_edge_target_turf(cast_on, cast_on.dir), 14, 4, cast_on)

/obj/item/hardened_spike
	name = "生物质刺"
	desc = "由生物质硬化而成的尖刺.非常锐利!"
	icon = 'icons/obj/weapons/thrown.dmi'
	icon_state = "tonguespike"
	force = 2
	throwforce = 25
	throw_speed = 4
	embedding = list(
		"impact_pain_mult" = 0,
		"embedded_pain_multiplier" = 15,
		"embed_chance" = 100,
		"embedded_fall_chance" = 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,
	)
	w_class = WEIGHT_CLASS_SMALL
	sharpness = SHARP_POINTY
	custom_materials = list(/datum/material/biomass = SMALL_MATERIAL_AMOUNT * 5)
	/// What mob "fired" our tongue
	var/datum/weakref/fired_by_ref
	/// if we missed our target
	var/missed = TRUE

/obj/item/hardened_spike/Initialize(mapload, mob/living/carbon/source)
	. = ..()
	src.fired_by_ref = WEAKREF(source)
	addtimer(CALLBACK(src, PROC_REF(check_embedded)), 5 SECONDS)

/obj/item/hardened_spike/proc/check_embedded()
	if(missed)
		unembedded()

/obj/item/hardened_spike/embedded(atom/target)
	. = ..()
	if(isbodypart(target))
		missed = FALSE

/obj/item/hardened_spike/unembedded()
	visible_message(span_warning("[src]嘎吱作响，扭曲变形了!"))
	for(var/obj/tongue as anything in contents)
		tongue.forceMove(get_turf(src))

	qdel(src)

/datum/mutation/human/tongue_spike/chem
	name = "化学舌刺"
	desc = "允许生物自行地将舌头作为刺射出，用于远距离传递化学物质."
	quality = POSITIVE
	text_gain_indication = span_notice("你感觉可以通过射出舌刺来与他人形成连接.")
	instability = 15
	locked = TRUE
	power_path = /datum/action/cooldown/spell/tongue_spike/chem
	energy_coeff = 1
	synchronizer_coeff = 1

/datum/action/cooldown/spell/tongue_spike/chem
	name = "发射化学舌刺"
	desc = "用舌头发射生物质刺，命中敌人后造成少量伤害并嵌入其中. 在此期间，你可以将身上的化学物质通过尖刺注入敌人."
	button_icon_state = "spikechem"

	spike_path = /obj/item/hardened_spike/chem

/obj/item/hardened_spike/chem
	name = "化学舌刺"
	desc = "硬化的生物质，被塑造成... 某种东西."
	icon_state = "tonguespikechem"
	throwforce = 2
	embedding = list(
		"impact_pain_mult" = 0,
		"embedded_pain_multiplier" = 0,
		"embed_chance" = 100,
		"embedded_fall_chance" = 0,
		"embedded_pain_chance" = 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,  //never hurts once it's in you
	)
	/// Whether the tongue's already embedded in a target once before
	var/embedded_once_alread = FALSE

/obj/item/hardened_spike/chem/embedded(mob/living/carbon/human/embedded_mob)
	. = ..()
	if(embedded_once_alread)
		return
	embedded_once_alread = TRUE

	var/mob/living/carbon/fired_by = fired_by_ref?.resolve()
	if(!fired_by)
		return

	var/datum/action/send_chems/chem_action = new(src)
	chem_action.transferred_ref = WEAKREF(embedded_mob)
	chem_action.Grant(fired_by)

	to_chat(fired_by, span_notice("连接已建立！使用\"转移化学物质\"技能，将你的化学物质输送给连接的目标!"))

/obj/item/hardened_spike/chem/unembedded()
	var/mob/living/carbon/fired_by = fired_by_ref?.resolve()
	if(fired_by)
		to_chat(fired_by, span_warning("连接丢失!"))
		var/datum/action/send_chems/chem_action = locate() in fired_by.actions
		QDEL_NULL(chem_action)

	return ..()

/datum/action/send_chems
	name = "转运化学物质"
	desc = "将你所有的化学试剂注入被化学舌刺给刺中的目标体内. 单次使用."
	background_icon_state = "bg_spell"
	button_icon = 'icons/mob/actions/actions_genetic.dmi'
	button_icon_state = "spikechemswap"
	check_flags = AB_CHECK_CONSCIOUS

	/// Weakref to the mob target that we transfer chemicals to on activation
	var/datum/weakref/transferred_ref

/datum/action/send_chems/New(Target)
	. = ..()
	if(!istype(target, /obj/item/hardened_spike/chem))
		qdel(src)

/datum/action/send_chems/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner) || !owner.reagents)
		return FALSE
	var/mob/living/carbon/human/transferer = owner
	var/mob/living/carbon/human/transferred = transferred_ref?.resolve()
	if(!ishuman(transferred))
		return FALSE

	to_chat(transferred, span_warning("你感到一阵细微的刺痛!"))
	transferer.reagents.trans_to(transferred, transferer.reagents.total_volume, transferred_by = transferer)

	var/obj/item/hardened_spike/chem/chem_spike = target
	var/obj/item/bodypart/spike_location = chem_spike.check_embedded()

	//this is where it would deal damage, if it transfers chems it removes itself so no damage
	chem_spike.forceMove(get_turf(spike_location))
	chem_spike.visible_message(span_notice("[chem_spike]从[spike_location]上脱落了!"))
	return TRUE
