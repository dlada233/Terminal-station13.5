#define CARP_ORGAN_COLOR "#4caee7"
#define CARP_SCLERA_COLOR "#ffffff"
#define CARP_PUPIL_COLOR "#00b1b1"
#define CARP_COLORS CARP_ORGAN_COLOR + CARP_SCLERA_COLOR + CARP_PUPIL_COLOR

///bonus of the carp: you can swim through space!
/datum/status_effect/organ_set_bonus/carp
	id = "organ_set_bonus_carp"
	organs_needed = 4
	bonus_activate_text = span_notice("你融入了鲤鱼DNA，你已学会如何在太空中推进自己!")
	bonus_deactivate_text = span_notice("你的DNA变得以原始为主，所以太空游泳能力将变得很弱...")
	bonus_traits = list(TRAIT_SPACEWALK)

///Carp lungs! You can breathe in space! Oh... you can't breathe on the station, you need low oxygen environments.
/// Inverts behavior of lungs. Bypasses suffocation due to space / lack of gas, but also allows Oxygen to suffocate.
/obj/item/organ/internal/lungs/carp
	name = "变异鲤鱼肺"
	desc = "将鲤鱼DNA注入正常肺的产物."
	// Oxygen causes suffocation.
	safe_oxygen_min = 0
	safe_oxygen_max = 15

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "lungs"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = CARP_COLORS

/obj/item/organ/internal/lungs/carp/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "它的脖子上有奇怪的腮.", BODY_ZONE_HEAD)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/carp)
	ADD_TRAIT(src, TRAIT_SPACEBREATHING, REF(src))

///occasionally sheds carp teeth, stronger melee (bite) attacks, but you can't cover your mouth anymore.
/obj/item/organ/internal/tongue/carp
	name = "变异鲤鱼嘴"
	desc = "将鲤鱼DNA注入正常嘴的产物."

	say_mod = "叫道"

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "tongue"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = CARP_COLORS

/obj/item/organ/internal/tongue/carp/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "它的牙齿锋利且巨大.", BODY_ZONE_PRECISE_MOUTH)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/carp)

/obj/item/organ/internal/tongue/carp/on_mob_insert(mob/living/carbon/tongue_owner, special, movement_flags)
	. = ..()
	if(!ishuman(tongue_owner))
		return
	var/mob/living/carbon/human/human_receiver = tongue_owner
	if(!human_receiver.can_mutate())
		return
	var/datum/species/rec_species = human_receiver.dna.species
	rec_species.update_no_equip_flags(tongue_owner, rec_species.no_equip_flags | ITEM_SLOT_MASK)

/obj/item/organ/internal/tongue/carp/on_bodypart_insert(obj/item/bodypart/limb)
	. = ..()
	limb.unarmed_damage_low = 10
	limb.unarmed_damage_high = 15
	limb.unarmed_effectiveness = 15

/obj/item/organ/internal/tongue/carp/on_mob_remove(mob/living/carbon/tongue_owner)
	. = ..()
	if(!ishuman(tongue_owner))
		return
	var/mob/living/carbon/human/human_receiver = tongue_owner
	if(!human_receiver.can_mutate())
		return
	var/datum/species/rec_species = human_receiver.dna.species
	rec_species.update_no_equip_flags(tongue_owner, initial(rec_species.no_equip_flags))

/obj/item/organ/internal/tongue/carp/on_bodypart_remove(obj/item/bodypart/head)
	. = ..()

	head.unarmed_damage_low = initial(head.unarmed_damage_low)
	head.unarmed_damage_high = initial(head.unarmed_damage_high)
	head.unarmed_effectiveness = initial(head.unarmed_effectiveness)

/obj/item/organ/internal/tongue/carp/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(owner.stat != CONSCIOUS || !prob(0.1))
		return
	owner.emote("cough")
	var/turf/tooth_fairy = get_turf(owner)
	if(tooth_fairy)
		new /obj/item/knife/carp(tooth_fairy)

/obj/item/knife/carp
	name = "变异鲤鱼齿"
	desc = "又大又锋利，足以戳到别人眼睛."
	icon_state = "carptooth"

///carp brain. you need to occasionally go to a new zlevel. think of it as... walking your dog!
/obj/item/organ/internal/brain/carp
	name = "变异鲤鱼脑"
	desc = "将鲤鱼DNA注入正常大脑的产物."

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "brain"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = CARP_COLORS

	///Timer counting down. When finished, the owner gets a bad moodlet.
	var/cooldown_timer
	///how much time the timer is given
	var/cooldown_time = 10 MINUTES

/obj/item/organ/internal/brain/carp/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/carp)
	AddElement(/datum/element/noticable_organ, "它看起来不能一直待在同一个地方.")

/obj/item/organ/internal/brain/carp/on_mob_insert(mob/living/carbon/brain_owner)
	. = ..()
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(unsatisfied_nomad)), cooldown_time, TIMER_STOPPABLE|TIMER_OVERRIDE|TIMER_UNIQUE)
	RegisterSignal(brain_owner, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(satisfied_nomad))

//technically you could get around the mood issue by extracting and reimplanting the brain but it will be far easier to just go one z there and back
/obj/item/organ/internal/brain/carp/on_mob_remove(mob/living/carbon/brain_owner)
	. = ..()
	UnregisterSignal(brain_owner, COMSIG_MOVABLE_Z_CHANGED)
	deltimer(cooldown_timer)

/obj/item/organ/internal/brain/carp/get_attacking_limb(mob/living/carbon/human/target)
	return owner.get_bodypart(BODY_ZONE_HEAD)

/obj/item/organ/internal/brain/carp/proc/unsatisfied_nomad()
	owner.add_mood_event("nomad", /datum/mood_event/unsatisfied_nomad)

/obj/item/organ/internal/brain/carp/proc/satisfied_nomad()
	SIGNAL_HANDLER
	owner.clear_mood_event("nomad")
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(unsatisfied_nomad)), cooldown_time, TIMER_STOPPABLE|TIMER_OVERRIDE|TIMER_UNIQUE)

/// makes you cold resistant, but heat-weak.
/obj/item/organ/internal/heart/carp
	name = "变异鲤鱼心"
	desc = "将鲤鱼DNA注入正常心脏的产物."

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "heart"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = CARP_COLORS

	organ_traits = list(TRAIT_RESISTCOLD, TRAIT_RESISTLOWPRESSURE)

/obj/item/organ/internal/heart/carp/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "皮肤上排列着细小的鳞片.", BODY_ZONE_CHEST)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/carp)
	AddElement(/datum/element/update_icon_blocker)

#undef CARP_ORGAN_COLOR
#undef CARP_SCLERA_COLOR
#undef CARP_PUPIL_COLOR
#undef CARP_COLORS
