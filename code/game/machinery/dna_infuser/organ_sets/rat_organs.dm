#define RAT_ORGAN_COLOR "#646464"
#define RAT_SCLERA_COLOR "#f0e055"
#define RAT_PUPIL_COLOR COLOR_BLACK
#define RAT_COLORS RAT_ORGAN_COLOR + RAT_SCLERA_COLOR + RAT_PUPIL_COLOR

///bonus of the rat: you can ventcrawl!
/datum/status_effect/organ_set_bonus/rat
	id = "organ_set_bonus_rat"
	organs_needed = 4
	bonus_activate_text = span_notice("啮齿动物DNA深深地融入了你，你获得了钻通风管道的能力!")
	bonus_deactivate_text = span_notice("啮齿动物DNA从你体内褪下，你不再能钻通风管道...")
	bonus_traits = list(TRAIT_VENTCRAWLER_NUDE)

///way better night vision, super sensitive. lotta things work like this, huh?
/obj/item/organ/internal/eyes/night_vision/rat
	name = "变异老鼠眼"
	desc = "将老鼠DNA注入到正常器官的产物."
	flash_protect = FLASH_PROTECTION_HYPER_SENSITIVE
	eye_color_left = COLOR_BLACK
	eye_color_right = COLOR_BLACK

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "eyes"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = RAT_COLORS
	low_light_cutoff = list(16, 11, 0)
	medium_light_cutoff = list(30, 20, 5)
	high_light_cutoff = list(45, 35, 10)

/obj/item/organ/internal/eyes/night_vision/rat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "它的眼睛瞳孔呈现深黑而灵活的样子，周围是让人恶心的黄色巩膜.", BODY_ZONE_PRECISE_EYES)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/rat)

///increases hunger, disgust recovers quicker, expands what is defined as "food"
/obj/item/organ/internal/stomach/rat
	name = "变异老鼠胃"
	desc = "将老鼠DNA注入到正常器官的产物."
	disgust_metabolism = 3

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "stomach"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = RAT_COLORS
	hunger_modifier = 10

/obj/item/organ/internal/stomach/rat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/rat)
	AddElement(/datum/element/noticable_organ, "它的嘴流下太多口水.", BODY_ZONE_PRECISE_MOUTH)

/// makes you smaller, walk over tables, and take 1.5x damage
/obj/item/organ/internal/heart/rat
	name = "变异老鼠心"
	desc = "将老鼠DNA注入到正常器官的产物."
	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "heart"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = RAT_COLORS

/obj/item/organ/internal/heart/rat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/rat)
	AddElement(/datum/element/noticable_organ, "它的身姿不太自然!")
	AddElement(/datum/element/update_icon_blocker)

/obj/item/organ/internal/heart/rat/on_mob_insert(mob/living/carbon/receiver)
	. = ..()
	if(!ishuman(receiver))
		return
	var/mob/living/carbon/human/human_receiver = receiver
	if(human_receiver.can_mutate())
		human_receiver.dna.add_mutation(/datum/mutation/human/dwarfism)
	//but 1.5 damage
	human_receiver.physiology?.damage_resistance -= 50

/obj/item/organ/internal/heart/rat/on_mob_remove(mob/living/carbon/heartless, special)
	. = ..()
	if(!ishuman(heartless))
		return
	var/mob/living/carbon/human/human_heartless = heartless
	if(human_heartless.can_mutate())
		human_heartless.dna.remove_mutation(/datum/mutation/human/dwarfism)
	human_heartless.physiology?.damage_resistance += 50

/// you occasionally squeak, and have some rat related verbal tics
/obj/item/organ/internal/tongue/rat
	name = "变异老鼠舌"
	desc = "将老鼠DNA注入到正常器官的产物."
	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "tongue"
	say_mod = "squeaks"
	modifies_speech = TRUE
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = RAT_COLORS
	liked_foodtypes = DAIRY //mmm, cheese. doesn't especially like anything else
	disliked_foodtypes = NONE //but a rat can eat anything without issue
	toxic_foodtypes = NONE

/obj/item/organ/internal/tongue/rat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "它的牙齿形状奇怪且泛黄", BODY_ZONE_PRECISE_MOUTH)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/rat)

/obj/item/organ/internal/tongue/rat/modify_speech(datum/source, list/speech_args)
	. = ..()
	var/message = LOWER_TEXT(speech_args[SPEECH_MESSAGE])
	if(message == "hi" || message == "hi.")
		speech_args[SPEECH_MESSAGE] = "很糕心见到你!"
	if(message == "hi?")
		speech_args[SPEECH_MESSAGE] = "Um... 很糕心见到你?"

/obj/item/organ/internal/tongue/rat/on_mob_insert(mob/living/carbon/tongue_owner, special, movement_flags)
	. = ..()
	RegisterSignal(tongue_owner, COMSIG_CARBON_ITEM_GIVEN, PROC_REF(its_on_the_mouse))

/obj/item/organ/internal/tongue/rat/on_mob_remove(mob/living/carbon/tongue_owner)
	. = ..()
	UnregisterSignal(tongue_owner, COMSIG_CARBON_ITEM_GIVEN)

/obj/item/organ/internal/tongue/rat/proc/on_item_given(mob/living/carbon/offerer, mob/living/taker, obj/item/given)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(its_on_the_mouse), offerer, taker)

/obj/item/organ/internal/tongue/rat/proc/its_on_the_mouse(mob/living/carbon/offerer, mob/living/taker)
	offerer.say("For you, it's on the mouse.")
	taker.add_mood_event("it_was_on_the_mouse", /datum/mood_event/it_was_on_the_mouse)

/obj/item/organ/internal/tongue/rat/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(prob(5))
		owner.emote("squeaks")
		playsound(owner, 'sound/creatures/mousesqueek.ogg', 100)

#undef RAT_ORGAN_COLOR
#undef RAT_SCLERA_COLOR
#undef RAT_PUPIL_COLOR
#undef RAT_COLORS
